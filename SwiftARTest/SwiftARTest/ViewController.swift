//
//  ViewController.swift
//  SwiftARTest
//
//  Created by Jan Luca Siewert on 13.04.21.
//

import UIKit
import SwiftAR

struct TappableCube: Model {
    @State var counter = 0
    var body: some Model {
        Cube()
            .material(.color(currentColor))
            .onTap {
                counter = counter + 1
            }
    }
    
    var currentColor: UIColor {
        switch counter % 4 {
            case 0: return .red
            case 1: return .yellow
            case 2: return .green
            case 3: return .blue
            default:
                return .white
        }
    }
}

struct PlaygroundExperience: Experience {
    var body: some Anchor {
        Surface {
            TappableCube()
                .translate(x: 1)
                .scale(0.8)
                .rotate(yaw: .pi/4, roll: .pi / 8)
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

