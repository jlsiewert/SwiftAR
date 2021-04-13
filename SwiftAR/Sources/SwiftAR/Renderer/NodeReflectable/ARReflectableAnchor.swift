//
//  File.swift
//  
//
//  Created by Jan Luca Siewert on 11.04.21.
//

import Foundation
import ARKit

protocol ARReflectableAnchor {
    func configuration() -> ARConfiguration
    func isAnchor(_ anchor: ARAnchor) -> Bool
    func create() -> ARAnchor?
}

extension Surface: ARReflectableAnchor {
    func configuration() -> ARConfiguration {
        let config = ARWorldTrackingConfiguration()
        switch surfaceType {
            case .any: config.planeDetection = [.horizontal, .vertical]
            case .horizontal: config.planeDetection = [.horizontal]
            case .vertical: config.planeDetection = [.vertical]
        }
        return config
    }
    
    func isAnchor(_ anchor: ARAnchor) -> Bool {
        anchor is ARPlaneAnchor
    }
    
    func create() -> ARAnchor? {
        nil
    }
}

extension World: ARReflectableAnchor {
   
    func configuration() -> ARConfiguration {
        ARWorldTrackingConfiguration()
    }
    
    func isAnchor(_ anchor: ARAnchor) -> Bool {
        anchor.name == "world_anchor"
    }
    
    func create() -> ARAnchor? {
        return ARAnchor(name: "world_anchor", transform: transform)
    }
}
