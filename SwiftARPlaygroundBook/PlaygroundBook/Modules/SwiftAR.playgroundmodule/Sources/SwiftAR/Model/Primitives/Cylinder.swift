//
//  Cylinder.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation
import SceneKit

/// A Cylinder primitive defined by a radius and a height.
///
/// This ``Model`` response to the ``ReduceVertexCountKey`` ``Environment``
/// and optinally renders in a lower quality.
public struct Cylinder: Model {
    let radius: CGFloat
    let height: CGFloat
    
    @Environment(\.material) var material: Material
    @Environment(\.reducedVertexCount) var reducedVertexCount
    
    /// Create a new primitive cylinder from a specfic radius and height.
    /// - Parameters:
    ///   - radius: The radius of the base.
    ///   - height: The height of the cyliner.
    public init(radius: Float = 0.1, height: Float = 0.2) {
        self.radius = CGFloat(radius)
        self.height = CGFloat(height)
    }
}

extension Cylinder: PrimitiveModel { }
extension Cylinder: NodeReflectable {
    func create() -> SCNNode {
        let c = SCNCylinder(radius: radius, height: height)
        c.heightSegmentCount = 1
        c.radialSegmentCount = reducedVertexCount ? 24 : 48
        material.apply(to: c)
        return SCNNode(geometry: c)
    }
    
    func update(_ node: SCNNode) {
        guard let c = node.geometry as? SCNCylinder else {
            return
        }
        c.radius = radius
        c.height = height
        c.radialSegmentCount = reducedVertexCount ? 24 : 48
        c.materials.first.map(material.update(material:))
    }
    
    
}
