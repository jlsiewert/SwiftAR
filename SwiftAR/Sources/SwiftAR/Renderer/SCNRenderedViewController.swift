//
//  SCNRenderedViewController.swift
//  
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation
import SceneKit

public class SCNRenderedViewController<E: Experience>: UIViewController {
    let scnView = SCNView()
    
    var renderer: SCNNodeRenderer<E>!
    
    let experience: E
    
    public init(experience: E) {
        self.experience = experience
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        scnView.frame = view.frame
        scnView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scnView)
        
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        
        let scene = SCNScene()
        scnView.scene = scene
        
        renderer = SCNNodeRenderer(scene: scene, experience: experience)
    }
}
