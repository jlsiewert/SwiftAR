//
//  Cube.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import Foundation

public struct Cube: Model {    
    let width: Float
    let height: Float
    let length: Float
    
    public init(width: Float = 0.1, height: Float = 0.1, length: Float = 0.1) {
        self.width = width
        self.height = height
        self.length = length
    }
    
}

extension Cube: PrimitiveModel {}
