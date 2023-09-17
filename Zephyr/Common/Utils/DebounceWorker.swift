//
//  DebounceWorker.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import Foundation

final class DebounceWorker {
    private let queue: DispatchQueue
    private let interval: TimeInterval
    private var workItem: DispatchWorkItem?

    init(queue: DispatchQueue, interval: TimeInterval) {
        self.queue = queue
        self.interval = interval
    }

    func debounce(_ action: @escaping () -> Void) {
        cancel()
        let workItem = DispatchWorkItem(block: action)
        queue.asyncAfter(deadline: .now() + interval, execute: workItem)
        self.workItem = workItem
    }

    func cancel() {
        workItem?.cancel()
    }
}
