//
//  simd+Extensions.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import Foundation
import simd

public extension SIMD3 where Scalar == Float {
    static var x: Self { [1, 0, 0] }
    static var y: Self { [0, 1, 0] }
    static var z: Self { [0, 0, 1] }
}

public extension SIMD4 where Scalar == Float {
    static var x: Self { [1, 0, 0, 0] }
    static var y: Self { [0, 1, 0, 0] }
    static var z: Self { [0, 0, 1, 0] }
    
    init(_ vec3: SIMD3<Float>, w: Float = 0) {
        self.init(vec3.x, vec3.y, vec3.z, w)
    }
}

public extension simd_float4x4 {
    init(translation: simd_float4) {
        self.init(.x, .y, .z, translation)
    }
    
    init(translation: simd_float3) {
        self.init(.x, .y, .z, SIMD4(translation, w: 1))
    }
    
    init(scale: simd_float3) {
        self.init(diagonal: [scale.x, scale.y, scale.z, 0])
    }
    
    init(scaleX x: Float = 1, y: Float = 1, z: Float = 1) {
        self.init(scale: [x, y, z])
    }
    
    init(scale: Float) {
        self.init(scale: [scale, scale, scale])
    }
}

public extension simd_quatf {
    // https://computergraphics.stackexchange.com/questions/8195/how-to-convert-euler-angles-to-quaternions-and-get-the-same-euler-angles-back-fr
    init(yaw: Float, pitch: Float, roll: Float) {
        let sy = sin(yaw/2)
        let cy = cos(yaw/2)
        let sp = sin(pitch/2)
        let cp = cos(pitch/2)
        let sr = sin(roll/2)
        let cr = cos(roll/2)
        
        let qx = sr * cp * cy - cr * sp * sy
        let qy = cr * sp * cy + sr * cp * sy
        let qz = cr * cp * sy - sr * sp * cy
        let qw = cr * cp * cy + sr * sp * sy
        
        self.init(vector: [qx, qy, qz, qw])
    }
    
    init(euler: simd_float3) {
        self.init(yaw: euler.x, pitch: euler.y, roll: euler.z)
    }
}
