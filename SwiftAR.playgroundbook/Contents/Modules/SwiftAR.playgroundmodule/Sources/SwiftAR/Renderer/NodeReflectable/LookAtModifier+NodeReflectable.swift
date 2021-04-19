//
//  LookAtModifier+NodeReflectable.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 18.04.21.
//

import Foundation
import SceneKit

extension LookAtModifier: NodeReflectableModifier {
    func apply<R: Renderer>(to node: SCNNode, with renderer: R?) {
        guard let renderer = renderer as? SCNNodeRenderer else {
            return
        }
        
        // Remove old child nodes
        node.childNodes.filter({ $0.name == "LookAtTargetNode" }).forEach( { $0.removeFromParentNode() })
        
        let constraint: SCNConstraint
        switch target {
            case .camera:
                constraint = SCNBillboardConstraint()
            case .point(let transform):
                let lookAtTargetNode = SCNNode()
                node.addChildNode(lookAtTargetNode)
                lookAtTargetNode.name = "LookAtTargetNode"
                lookAtTargetNode.setWorldTransform(SCNMatrix4(transform))
                constraint = SCNLookAtConstraint(target: lookAtTargetNode)
            case .origin:
                constraint = SCNLookAtConstraint(target: renderer.root)
        }
        
        node.constraints = [constraint]
    }
    
    
}
