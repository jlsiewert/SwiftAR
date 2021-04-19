//
//  Experience.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import UIKit

public protocol Experience {
    associatedtype Body: Anchor
    var body: Body { get }
    
    init()
}

#if swift(>=5.4)
#elseif canImport(PlaygroundSupport)
import PlaygroundSupport

extension Experience {
    public static func liveView() {
        let e = Self()
        let vc = SCNRenderedViewController(experience: e)
        PlaygroundPage.current.needsIndefiniteExecution = true
        PlaygroundPage.current.liveView = vc
    }
}
#endif
