//
//  SurfaceAnchor.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import Foundation

/**
 An ``Anchor`` that recognizes a Surface, like a wall or a table.
 
 ```swift
 struct SolarSystemExperience: Experience {
     var body: some Anchor {
         Surface(.horizontal) {
            Sphere(radius: 1)
        }
    }
 }
 ```
 */
public struct Surface<M: Model>: Anchor {
    /// The description for the specific surface type the model should be anchored at
    public enum SurfaceType {
        /// A horizontal plane, like a table or the floor
        case horizontal
        /// A vertical plane, like a wall
        case vertical
        /// Any surface
        case any
    }
    
    let model: () -> M
    let surfaceType: SurfaceType
    
    public init(_ surfaceType: SurfaceType = .any, @ModelBuilder _ modelBuilder: @escaping () -> M) {
        self.model = modelBuilder
        self.surfaceType = surfaceType
    }
    
    public var body: M {
        model()
    }
}
