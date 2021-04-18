//
//  TransformModifier+NodeReflectable.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 10.04.21.
//

import Foundation
import SceneKit

extension TransformModifier: NodeReflectableModifier {
    func apply<R: Renderer>(to node: SCNNode, with renderer: R?) {
        node.simdTransform = transform
    }
    
    
}
