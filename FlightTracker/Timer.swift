import Combine
import SwiftUI

class MyTimer {
    var currentTimePublisher = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .common)
    var cancellable: AnyCancellable?

    init() {
        self.cancellable = currentTimePublisher.connect() as? AnyCancellable
    }

    deinit {
        self.cancellable?.cancel()
    }
}
