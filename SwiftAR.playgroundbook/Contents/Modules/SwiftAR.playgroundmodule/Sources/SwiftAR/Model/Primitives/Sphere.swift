//
//  Sphere.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation
import SceneKit

public struct ReduceVertexCountKey: EnvironmentKey {
    public static var defaultValue: Bool = false
}

public extension EnvironmentValues {
    var reducedVertexCount: Bool {
        get { self[ReduceVertexCountKey.self] }
        set { self[ReduceVertexCountKey.self] = newValue }
    }
}


public struct Sphere: Model {
    let radius: Float
    
    @Environment(\.material) var material: Material
    @Environment(\.reducedVertexCount) var reducedVertexCount
    
    public init(radius: Float = 0.1) {
        self.radius = radius
    }
}

extension Sphere: PrimitiveModel { }
extension Sphere: NodeReflectable {
    func create() -> SCNNode {
        let sphere = SCNSphere(radius: CGFloat(radius))
        sphere.segmentCount = reducedVertexCount ? 12 : 48
        material.apply(to: sphere)
        return SCNNode(geometry: sphere)
    }
    
    func update(_ node: SCNNode) {
        guard let s = node.geometry as? SCNSphere else { return }
        s.radius = CGFloat(radius)
        s.segmentCount = reducedVertexCount ? 12 : 48
        s.materials.first.map(material.update(material:))
    }
    
    
}
