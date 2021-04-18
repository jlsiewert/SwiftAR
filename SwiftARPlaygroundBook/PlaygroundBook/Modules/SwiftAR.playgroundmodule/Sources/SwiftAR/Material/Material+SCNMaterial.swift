//
//  Material+SCNMaterial.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 13.04.21.
//

import Foundation
import SceneKit

extension Material {
    private var materialProperty: Any {
        switch self {
            case .color(let c): return c
            case .texture(let i): return i
            case ._swiftUIview(let v): return SCNMaterialProperty.view(view: v)
        }
    }
    
    func createMaterial() -> SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = materialProperty
        m.diffuse.intensity = 1
        switch self {
            case ._swiftUIview:
                m.lightingModel = .constant
            default:
            m.lightingModel = .physicallyBased
        }
        return m
    }
    
    func update(material: SCNMaterial) {
        switch self {
            case ._swiftUIview:
                assertionFailure("Updating a material from a view is unsupported")
                return
            default:
                break
        }
        material.diffuse.contents = materialProperty
    }
}
