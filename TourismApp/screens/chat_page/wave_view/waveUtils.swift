//
//  waveUtils.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 10/09/23.
//

import Foundation

public class Timeout {
    
    public typealias ComplectionBlock = () -> Void
    
    public static func setInterval(_ interval: TimeInterval,
                                   block: @escaping ComplectionBlock) -> Timer {
        return Timer.scheduledTimer(timeInterval: interval,
                                    target: BlockOperation(block: block),
                                    selector: #selector(Operation.main),
                                    userInfo: nil, repeats: true)
    }
    
}

public class Lerp {
    public static func lerp(_ v0: CGFloat, _ v1: CGFloat, _ t: CGFloat) -> CGFloat {
        return v0 * (1 - t) + v1 * t
    }
}

extension Date {
    var millisecondsSince1970: Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
