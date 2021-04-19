//
//  TransformModifier.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 10.04.21.
//

import Foundation
import simd

public struct TransformModifier: PrimitiveModifier {
    public typealias Body = Never
    
    let transform: simd_float4x4
    
    public init(transform: simd_float4x4) {
        self.transform = transform
    }
    
    public init(translation: simd_float3) {
        self.transform = simd_float4x4(translation: translation)
    }
    
    public init(rotation: simd_quatf) {
        self.transform = simd_float4x4(rotation)
    }
}

public extension Model {
    func transform(_ transform: simd_float4x4) -> ModifiedContent<Self, TransformModifier> {
        modifier(TransformModifier(transform: transform))
    }
    
    func translate(_ translation: simd_float3) -> ModifiedContent<Self, TransformModifier> {
        modifier(TransformModifier(translation: translation))
    }
    
    func translate(x: Float = 0, y: Float = 0, z: Float = 0) -> ModifiedContent<Self, TransformModifier> {
        modifier(TransformModifier(translation: [x, y, z]))
    }
    
    func rotate(_ rotation: simd_quatf) -> ModifiedContent<Self, TransformModifier> {
        modifier(TransformModifier(rotation: rotation))
    }
    
    func rotate(yaw: Float = 0, pitch: Float = 0, roll: Float = 0) -> ModifiedContent<Self, TransformModifier> {
        modifier(TransformModifier(rotation: simd_quatf(yaw: yaw, pitch: pitch, roll: roll)))
    }
    
    func scale(x: Float = 1, y: Float = 1, z: Float = 1) -> ModifiedContent<Self, TransformModifier> {
        modifier(TransformModifier(transform: simd_float4x4(scale: [x, y, z])))
    }
    
    func scale(_ scale: Float) -> ModifiedContent<Self, TransformModifier> {
        self.scale(x: scale, y: scale, z: scale)
    }
}
