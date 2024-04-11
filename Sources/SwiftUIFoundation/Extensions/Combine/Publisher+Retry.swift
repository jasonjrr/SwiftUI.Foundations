//
//  Publisher+Retry.swift
//  
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import Combine

extension Publisher {
    public func retry<T: Scheduler>(_ retries: Int, delay: T.SchedulerTimeType.Stride, scheduler: T) -> AnyPublisher<Output, Failure> {
        self.catch { _ in
            Just()
                .delay(for: delay, scheduler: scheduler)
                .flatMap { _ in self }
                .retry(retries > 0 ? retries - 1 : 0)
        }
        .eraseToAnyPublisher()
    }
}
