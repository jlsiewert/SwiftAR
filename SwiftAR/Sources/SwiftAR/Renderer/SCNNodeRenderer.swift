//
//  File.swift
//  
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation
import SceneKit

public final class SCNNodeRenderer<E: Experience>: Renderer {
    typealias TargetType = SCNNode
    let scene: SCNScene
    var reconciler: StackReconciler<SCNNodeRenderer, E>!
    
    public init(scene: SCNScene, experience: E) {
        self.scene = scene
        self.reconciler = StackReconciler(experience: experience, renderer: self)
        scene.background.contents = UIColor.lightGray
    }
    
    func mount<E, M>(_ element: MountedElement<SCNNodeRenderer, E, M>, to parent: SCNNode) -> SCNNode where E : Experience, M : Model {
        print("Mount \(element)")
        if let element = element as? NodeReflectable {
            print("Mount primitive \(element)")
            let node = element.create()
            parent.addChildNode(node)
            return node
        }
        let node = SCNNode()
        parent.addChildNode(node)
        return node
    }
    
    func renderRoot<E: Experience>(_ experience: E) -> SCNNode {
        // Todo: Create AR Experience
        return scene.rootNode
    }
    
    func apply(_ modifier: Any, to target: SCNNode) {
        guard let modifier = modifier as? NodeReflectableModifier else {
            fatalError("Unknown Modifier send to renderer")
        }
        print("Applying primitive modifier \(modifier) to \(target)")
        modifier.apply(to: target)
    }
}
