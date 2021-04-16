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
        view.frame = self.liveViewSafeAreaGuide.layoutFrame
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
        
        let gestureRecognoizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        scnView.addGestureRecognizer(gestureRecognoizer)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        let location = sender.location(in: scnView)
        
        // First, check nodes, then raycast
        if let first = scnView.hitTest(location, options: [:]).first {
            // Traverse up the hierachy until no more nodes or a `TappableNode` is found
            var element: SCNNode? = first.node
            while element != nil {
                if let tappable = element as? TappableNode {
                    tappable.onTapHandler()
                    return
                }
                element = element?.parent
            }
        }
    }
}

#if canImport(PlaygroundSupport)
import PlaygroundSupport
extension SCNRenderedViewController: PlaygroundLiveViewSafeAreaContainer { }
#endif
