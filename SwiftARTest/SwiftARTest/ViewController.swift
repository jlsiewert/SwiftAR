//
//  ViewController.swift
//  SwiftARTest
//
//  Created by Jan Luca Siewert on 13.04.21.
//

import UIKit
import SwiftAR


struct PlaygroundExperience: Experience {
    
    @State var counter = 0
    
    var body: some SwiftAR.Anchor {
        Surface {
            Group {
                Group {
            Sphere(radius: 0.05)
                .onTap {
                    counter += 1
                }
                .material(.color(.green))
                Sphere(radius: 0.05)
                    .material(.color(.red))
                    .onTap {
                        counter = 0
                    }
                    .translate(x: -0.1)
                }
                .scale( counter % 2 == 0 ? 1 : 0.8 )
            ForEach(0..<counter) { i in
                Cube()
                    .material(.color(self.color(for: i)))
                    .translate(x: 0.15 * Float(i+1))
            }
            }
            .animation()
        }
    }
    
    func color(for index: Int) -> UIColor {
        switch index % 4 {
            case 0: return .green
            case 1: return .blue
            case 2: return .orange
            default: return .cyan
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

