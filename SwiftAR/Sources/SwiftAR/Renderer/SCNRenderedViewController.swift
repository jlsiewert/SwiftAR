//
//  SCNRenderedViewController.swift
//  
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation
import SceneKit
#if canImport(PlaygroundSupport)
import PlaygroundSupport
#endif

public class SCNRenderedViewController<E: Experience>: UIViewController {
    let scnView = SCNView()
    
    var renderer: SCNNodeRenderer!
    
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
        #if canImport(PlaygroundSupport)
        view.frame = self.liveViewSafeAreaGuide
        #else
        scnView.showsStatistics = true
        #endif
        scnView.frame = view.frame
        scnView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scnView)
        
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        
        let scene = SCNScene()
        scnView.scene = scene
        scnView.backgroundColor = UIColor(white: 0.98, alpha: 1)
        
        renderer = SCNNodeRenderer(scene: scene, experience: experience)
    }
}

#if canImport(PlaygroundSupport)
extension SCNRenderedViewController: PlaygroundLiveViewSafeAreaContainer { }
#endif
