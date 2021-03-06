//
//  NodeReflectable+Modifier.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 10.04.21.
//

import Foundation
import SceneKit

protocol NodeReflectableModifier {
    func apply<R: Renderer>(to node: SCNNode, with renderer: R?)
}
