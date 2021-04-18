//
//  ARReflectableAnchor.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 11.04.21.
//

import Foundation
import ARKit

protocol ARReflectableAnchor {
    func configuration() -> ARConfiguration
    func guidanceHint() -> ARCoachingOverlayView.Goal?
}

protocol ARAnchorAttachable: ARReflectableAnchor {
    func shouldAttach(to anchor: ARAnchor) -> Bool
}

protocol NodeAttachableAnchor: ARReflectableAnchor {
    func shouldAttach(to node: SCNNode) -> Bool
}

protocol RaycastHandlingAnchor {
    var raycast: ((simd_float4x4) -> ())? { get }
}

extension Surface: ARAnchorAttachable {
    func shouldAttach(to anchor: ARAnchor) -> Bool {
        anchor is ARPlaneAnchor
    }
    
    func configuration() -> ARConfiguration {
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        config.wantsHDREnvironmentTextures = true
        config.isLightEstimationEnabled = true
        switch self.surfaceType {
            case .any: config.planeDetection = [.horizontal, .vertical]
            case .horizontal: config.planeDetection = [.horizontal]
            case .vertical: config.planeDetection = [.vertical]
        }
        return config
    }
    
    func guidanceHint() -> ARCoachingOverlayView.Goal? {
        switch surfaceType {
            case .any: return .anyPlane
            case .horizontal: return .horizontalPlane
            case .vertical: return .verticalPlane
        }
    }
}

extension World: NodeAttachableAnchor, RaycastHandlingAnchor {
    func shouldAttach(to node: SCNNode) -> Bool {
        true
    }
    
    func configuration() -> ARConfiguration {
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        config.wantsHDREnvironmentTextures = true
        config.isLightEstimationEnabled = true
        return config
    }
    
    func guidanceHint() -> ARCoachingOverlayView.Goal? {
        #if targetEnvironment(simulator)
        return nil
        #else
        return .tracking
        #endif
    }
    
    
}
