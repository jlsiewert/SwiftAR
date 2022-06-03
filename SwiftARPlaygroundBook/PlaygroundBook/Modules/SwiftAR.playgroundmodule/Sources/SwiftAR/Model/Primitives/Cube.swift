//
//  Cube.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import Foundation

/// A Cube primitive from a specific width, height, and length
public struct Cube: Model {
    let width: Float
    let height: Float
    let length: Float
    
    @Environment(\.material) var material: Material
    
    /// Create a new Cube from the specific width, height, and length.
    /// - Parameters:
    ///   - width: The width of the cube
    ///   - height: The height of the cube
    ///   - length: The length of the cube
    public init(width: Float = 0.1, height: Float = 0.1, length: Float = 0.1) {
        self.width = width
        self.height = height
        self.length = length
    }
}

extension Cube: PrimitiveModel {}
