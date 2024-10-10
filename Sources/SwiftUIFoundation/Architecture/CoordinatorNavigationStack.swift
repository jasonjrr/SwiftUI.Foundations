//
//  CoordinatorNavigationStack.swift
//
//
//  Created by Jason Lew-Rapai on 10/10/24.
//

import SwiftUI

@available(iOS 17.0, *)
public struct CoordinatorNavigationStack<Content>: View where Content : View {
    @Bindable var path: CoordinatorNavigationPath
    let content: () -> Content
    
    public init(path: CoordinatorNavigationPath, @ViewBuilder content: @escaping () -> Content) {
        self.path = path
        self.content = content
    }
    
    public var body: some View {
        NavigationStack(path: self.$path.path, root: self.content)
    }
}

@available(iOS 17.0, *)
@Observable
public class CoordinatorNavigationPath {
    public typealias NavigationObject = AnyObject & Hashable & Equatable
    fileprivate var path: NavigationPath = NavigationPath()
    private var objects: [any NavigationObject] = []
    
    @ObservationIgnored
    private let semaphore: DispatchSemaphore = DispatchSemaphore(value: 1)
    
    public var last: (any NavigationObject)? {
        self.objects.last
    }
    
    public init() {}
    
    public func append(_ object: some NavigationObject) {
        self.semaphore.wait()
        self.objects.append(object)
        self.path.append(object)
        self.semaphore.signal()
    }
    
    public func removeAll() {
        self.semaphore.wait()
        self.objects.removeAll()
        while self.path.count > 0 {
            self.path.removeLast()
        }
        self.semaphore.signal()
    }
    
    public func removeLast() {
        self.semaphore.wait()
        self.objects.removeLast()
        self.path.removeLast()
        self.semaphore.signal()
    }
    
    @discardableResult
    public func removeLast<Element : NavigationObject>(through graphObject: Element) -> Element? {
        self.semaphore.wait()
        var removeCount: Int = 0
        defer {
            self.path.removeLast(removeCount)
            self.semaphore.signal()
        }
        
        while let object = self.objects.popLast() {
            removeCount = removeCount + 1
            if graphObject === object {
                return graphObject
            }
        }
        return nil
    }
    
    @discardableResult
    public func removeLast(through clause: (any NavigationObject) -> Bool) -> (any NavigationObject)? {
        self.semaphore.wait()
        var removeCount: Int = 0
        defer {
            self.path.removeLast(removeCount)
            self.semaphore.signal()
        }
        
        while let object = self.objects.popLast() {
            removeCount = removeCount + 1
            if clause(object) {
                return object
            }
        }
        return nil
    }
}
