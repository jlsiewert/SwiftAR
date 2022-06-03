//
//  Experience.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import UIKit


/**
 The `Experience` is the base model for all `SwiftAR` content.
 It describes the root scene of the AR content.
 
 The `Experience` has a ``body`` property that describes
 the specific ``Anchor`` that is used to place the experience
 into the real world.
 
 In a Playground, `Experience` conforms to ``PlaygroundLiveViewable``
 so that it can be directly added to the live view of a Playground
 through the SceneKit renderer implemented in ``SCNRenderedViewController``.
 */
public protocol Experience {
    /// The type of the specific AR ``Anchor`` used.
    associatedtype Body: Anchor
    /// The ``Anchor`` that is used in this `Experience`.
    /// An `Experience` only has a single ``Anchor``.
    var body: Body { get }
    
    /// Create a new `Experience`.
    init()
}

#if swift(>=5.4)
#elseif canImport(PlaygroundSupport)
import PlaygroundSupport

public extension Experience: PlaygroundLiveViewable {
    var playgroundLiveViewRepresentation: PlaygroundLiveViewRepresentation {
        SCNRenderedViewController(experience: self)
    }
}

extension Experience {
    /// Displays an `Experience` in the Playground LiveView.
    public static func liveView() {
        let e = Self()
        PlaygroundPage.current.needsIndefiniteExecution = true
        PlaygroundPage.current.liveView = e
    }
}
#endif
