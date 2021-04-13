//
//  ViewController.swift
//  SwiftARTest
//
//  Created by Jan Luca Siewert on 13.04.21.
//

import UIKit
import SwiftAR

struct PlaygroundExperience: Experience {
    var body: some Anchor {
        Surface {
            Cube()
                .translate(x: 1)
                .scale(0.8)
                .rotate(yaw: .pi/4)
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let e = PlaygroundExperience()
        let vc = SCNRenderedViewController(experience: e)
        addChild(vc)
        vc.view.frame = view.frame
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(vc.view)
    }


}

