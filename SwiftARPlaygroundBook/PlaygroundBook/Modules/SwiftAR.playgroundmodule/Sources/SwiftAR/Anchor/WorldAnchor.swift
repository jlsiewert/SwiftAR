//
//  WorldAnchor.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import Foundation
import simd

/**
 Use the `World` ``Anchor`` whenever you want to place content at an arbitary position within the room.
 
 Use the ``Model/transform(_:)`` and related functions to specify the exact position of the model.
 This is particulary usefull when using the ``World/onTap(_:)`` raycast handler.
 */
public struct World<Body: Model>: Anchor {
    
    public let body: Body
    var raycast: ((simd_float4x4) -> ())?
    
    public init(@ModelBuilder _ model: @escaping () -> Body) {
        self.body = model()
    }
}

public extension World {
    
    /// Adds an event handler that triggers every time the user taps on the world.
    /// The handler then performs a raycast from the 2D point the user taps into the environment.
    ///
    /// ```swift
    ///struct PlaygroundExperience: Experience {
    ///     @State var currentTransform: simd_float4x4?
    ///     var body: some Anchor {
    ///        World {
    ///               if let currentTransform = currentTransform {
    ///                     Sphere(radius: 0.05)
    ///                         .material(.color(.red))
    ///                         .transform(currentTransform)
    ///               }
    ///           }
    ///        }
    ///       .onTap {
    ///          raycasts.append(RaycastResult(transform: $0))
    ///     }
    /// }
    ///
    /// ```
    ///
    /// - Parameter raycastHandler: The event handler. It passes the 4x4 transformation matrix of the world position to the handler.
    func onTap( _ raycastHandler: @escaping (simd_float4x4) -> () ) -> Self {
        var s = self
        s.raycast = raycastHandler
        return s
    }
}
