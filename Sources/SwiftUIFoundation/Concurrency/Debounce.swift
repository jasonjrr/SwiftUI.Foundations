//
//  File.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 2/12/25.
//

import Foundation

struct StateMachine<T> {
    enum State {
        case idle
        case debouncing(value: T, dueTime: ContinuousClock.Instant, isValueDuringSleep: Bool)
   }

    var state: State
    let duration: ContinuousClock.Duration
    
    init(duration: ContinuousClock.Duration) {
        self.state = .idle
        self.duration = duration
    }

    mutating func newValue(_ value: T) -> (Bool, ContinuousClock.Instant) {
        let dueTime = ContinuousClock.now + duration
        switch self.state {
        case .idle:
            // there is no value being debounced
            self.state = .debouncing(value: value, dueTime: dueTime, isValueDuringSleep: false)
            // we should start a new task to begin the debounce
            return (true, dueTime)
        case .debouncing:
            // there is already a value being debounced
            // the new value takes its place and we update the due time
            self.state = .debouncing(value: value, dueTime: dueTime, isValueDuringSleep: true)
            // no need to create a new task, we extend the lifespan of the current task
            return (false, dueTime)
        }
    }

    enum SleepIsOverAction {
        case continueDebouncing(dueTime: ContinuousClock.Instant)
        case finishDebouncing(value: T)
    }

    mutating func sleepIsOver() -> SleepIsOverAction {
        switch self.state {
        case .idle:
            fatalError("inconsistent state, no value was being debounced.")
        case .debouncing(let value, let dueTime, true):
            // one or more values have been set while sleeping
            state = .debouncing(value: value, dueTime: dueTime, isValueDuringSleep: false)
            // we have to continue debouncing with the latest value
            return .continueDebouncing(dueTime: dueTime)
        case .debouncing(let value, _, false):
            // no values were set while sleeping
            state = .idle
            // we can output the latest known value
            return .finishDebouncing(value: value)
        }
    }
}

final class SafeStorage<T>: @unchecked Sendable {
    private let lock = NSRecursiveLock()
    private var stored: T
    
    init(stored: T) {
        self.stored = stored
    }
    
    func get() -> T {
        self.lock.lock()
        defer { self.lock.unlock() }
        return self.stored
    }
    
    func set(stored: T) {
        self.lock.lock()
        defer { self.lock.unlock() }
        self.stored = stored
    }
    
    func apply<R>(block: (inout T) -> R) -> R {
        self.lock.lock()
        defer { self.lock.unlock() }
        return block(&self.stored)
    }
}

public final class Debounce<T>: Sendable {
    private let output: @Sendable (T) async -> Void
    private let stateMachine: SafeStorage<StateMachine<T>>
    private let task: SafeStorage<Task<Void, Never>?>
    
    public init(
        duration: ContinuousClock.Duration,
        output: @Sendable @escaping (T) async -> Void
    ) {
        self.stateMachine = SafeStorage(stored: StateMachine(duration: duration))
        self.task = SafeStorage(stored: nil)
        self.output = output
    }
    
    public func emit(value: T) {
        let (shouldStartATask, dueTime) = self.stateMachine.apply { machine in
            machine.newValue(value)
        }
        
        if shouldStartATask {
            self.task.set(stored: Task { [output, stateMachine] in
                var localDueTime = dueTime
                loop: while true {
                    try? await Task.sleep(until: localDueTime, clock: .continuous)
                
                    let action = stateMachine.apply { machine in
                        machine.sleepIsOver()
                    }
                
                    switch action {
                    case .finishDebouncing(let value):
                        await output(value)
                        break loop
                    case .continueDebouncing(let newDueTime):
                        localDueTime = newDueTime
                        continue loop
                    }
                }
            })
        }
    }
    
    deinit {
        self.task.get()?.cancel()
    }
}
