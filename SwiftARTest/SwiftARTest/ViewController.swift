//
//  ViewController.swift
//  SwiftARTest
//
//  Created by Jan Luca Siewert on 13.04.21.
//

import UIKit
import SwiftAR

struct TappableCube: Model {
    @State var counter = 2
    var body: some Model {
        ForEach(0..<counter, content: { i in
            Cube()
                .material(.color(.red))
                .translate(x: -0.15 * Float(i + 1))
                .onTap {
                    counter += 1
                    
                    if counter > 4 {
                        counter = 1
                    }
                }
        })
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
    @State var tapped = true
    var body: some Anchor {
        Surface {
            Group {
            TappableCube()
            Cube()
                .rotate(yaw: tapped ? 0 : .pi / 4)
                .onTap {
                    tapped.toggle()
                }
            }
            .scale(tapped ? 1 : 0.5)
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

