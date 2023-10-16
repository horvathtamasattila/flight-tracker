import Combine
import SwiftUI

class MyTimer: ObservableObject {
    let currentTimePublisher = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .default)
    let cancellable: AnyCancellable?

    init() {
        self.cancellable = currentTimePublisher.connect() as? AnyCancellable
    }

    deinit {
        self.cancellable?.cancel()
    }
}
