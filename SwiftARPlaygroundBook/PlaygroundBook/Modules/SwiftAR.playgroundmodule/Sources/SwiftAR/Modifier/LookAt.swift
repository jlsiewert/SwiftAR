//
//  LookAt.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 18.04.21.
//

import Foundation
import simd

/// A modifier that ensures that a ``Model`` always faces a specified ``Target``.
///
/// The modifier aligns the model so that the local z vector faces the ``Target``.
public struct LookAtModifier: PrimitiveModifier {
    /// The target the ``Model`` should face
    public enum Target {
        /// The world origin
        case origin
        /// The camera, or point of view, of the scene
        case camera
        /// A specific point in the world
        case point(simd_float4x4)
    }
    
    public typealias Body = Never
    let target: Target
    
    /// Creates a modifier that ensures a `Model` always faces a ``Target``
    /// - Parameter target: The target. The local z vector will face this point
    public init(_ target: Target) {
        self.target = target
    }
}

public extension Model {
    
    /// Ensures that a model always faces a specific target.
    ///
    /// The model will be orientated so that it's local z vector will point to the traget.
    /// - Parameter target: The target to point to
    /// - Returns: A modified ``Model``
    func lookAt(_ target: LookAtModifier.Target) -> some Model {
        modifier(LookAtModifier(target))
    }
}
