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
        self.init(.x, .y, .z, SIMD4(translation))
    }
}
