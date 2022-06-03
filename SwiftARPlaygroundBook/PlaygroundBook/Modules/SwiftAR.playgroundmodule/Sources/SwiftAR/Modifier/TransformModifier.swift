//
//  TransformModifier.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 10.04.21.
//

import Foundation
import simd

/// A ``ModelModifier`` that applies a specific transform to a ``Model``.
///
/// - Note: It is recommended to use the convenience methods defined on <doc:ModelModifiers.Transform>
///         to apply a transform.
///
///
/// The order in which `TransformModifier`, or, for that matter, any modifier is applied, _matters_.
/// This examples moves a sphere 1 meter in x direction and _then_ scales it to half it's size.
///
/// ```swift
/// struct MyModel {
///     var body: some Model {
///         Sphere()
///             .scale(0.5)
///             .translate(x: 1)
///         }
/// }
/// ```
///
/// Changing the order of the modifiers on the other hand first scales the model
/// and therefore moves it only by 0.5 meters.
///
///```swift
/// struct MyModel {
///     var body: some Model {
///         Sphere()
///             .translate(x: 1)
///             .scale(0.5)
///         }
/// }
/// ```
public struct TransformModifier: PrimitiveModifier {
    public typealias Body = Never
    
    let transform: simd_float4x4
    
    /// Create a new ``TransformModifier`` from a ``simd/simd_float4x4`` 4x4 matrix.
    /// - Parameter transform: A 4x4 transformation matrix.
    public init(transform: simd_float4x4) {
        self.transform = transform
    }
    
    /// Create a new ``TransformModifier`` from a translation vector.
    /// - Parameter translation: The vector specifying the x, y, and z component of the translation.
    public init(translation: simd_float3) {
        self.transform = simd_float4x4(translation: translation)
    }
    
    /// Create a new ``TransformModifier`` from a specific rotation.
    /// - Parameter rotation: A quaternion describing a rotation.
    public init(rotation: simd_quatf) {
        self.transform = simd_float4x4(rotation)
    }
}

public extension Model {
    
    /// Apply a specific transform to modify a ``Model``.
    /// - Parameter transform: The 4x4 transformation matrix
    /// - Returns: A ``Model`` transformed by the matrix.
    func transform(_ transform: simd_float4x4) -> ModifiedContent<Self, TransformModifier> {
        modifier(TransformModifier(transform: transform))
    }
    
    /// Apply a specific translation to a ``Model``.
    /// - Parameter translation: The translation vector specifying the x, y, and z component.
    /// - Returns: A ``Model`` translated by the vector.
    func translate(_ translation: simd_float3) -> ModifiedContent<Self, TransformModifier> {
        modifier(TransformModifier(translation: translation))
    }
    
    /// Apply a translation specified by individual `x`, `y`, and `z` coordinates.
    /// - Parameters:
    ///   - x: The translation in x direction
    ///   - y: The translation in y direction
    ///   - z: The translation in z direction
    /// - Returns: A ``Model`` translated by the vector.
    func translate(x: Float = 0, y: Float = 0, z: Float = 0) -> ModifiedContent<Self, TransformModifier> {
        modifier(TransformModifier(translation: [x, y, z]))
    }
    
    /// Apply a rotation specified by a quaternion
    /// - Parameter rotation: The rotation quaternion
    /// - Returns: A ``Model`` rotated by the quaternion.
    func rotate(_ rotation: simd_quatf) -> ModifiedContent<Self, TransformModifier> {
        modifier(TransformModifier(rotation: rotation))
    }
    
    /// Apply a rotation specified by Euler angles.
    /// - Parameters:
    ///   - yaw: The yaw angle in radians
    ///   - pitch: The pitch angle in radians
    ///   - roll: The roll angle in radians
    /// - Returns: A ``Model`` rotated by the Euler angles.
    func rotate(yaw: Float = 0, pitch: Float = 0, roll: Float = 0) -> ModifiedContent<Self, TransformModifier> {
        modifier(TransformModifier(rotation: simd_quatf(yaw: yaw, pitch: pitch, roll: roll)))
    }
    
    /// Apply a scale to invidual axis of a `Model`
    /// - Parameters:
    ///   - x: The scale in `x` direction
    ///   - y: The scale in `y` direction
    ///   - z: The scale in `z` direction
    /// - Returns: A ``Model`` scaled by the specified amount
    func scale(x: Float = 1, y: Float = 1, z: Float = 1) -> ModifiedContent<Self, TransformModifier> {
        modifier(TransformModifier(transform: simd_float4x4(scale: [x, y, z])))
    }
    
    /// Apply a uniform scale to all axis of a `Model`
    /// - Parameter scale: The scale that is applied to all axis
    /// - Returns: A ``Model`` scaled by the specified amount
    func scale(_ scale: Float) -> ModifiedContent<Self, TransformModifier> {
        self.scale(x: scale, y: scale, z: scale)
    }
}
