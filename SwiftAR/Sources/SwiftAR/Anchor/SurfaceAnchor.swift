//
//  SurfaceAnchor.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import Foundation

public struct Surface<M: Model>: Anchor {
    public enum SurfaceType {
        case horizontal, vertical, mesh, anyPlane, all
    }
    
    let model: () -> M
    let surfaceType: SurfaceType
    
    public init(_ surfaceType: SurfaceType = .all, @ModelBuilder _ modelBuilder: @escaping () -> M) {
        self.model = modelBuilder
        self.surfaceType = surfaceType
    }
    
    public var body: M {
        model()
    }
}
