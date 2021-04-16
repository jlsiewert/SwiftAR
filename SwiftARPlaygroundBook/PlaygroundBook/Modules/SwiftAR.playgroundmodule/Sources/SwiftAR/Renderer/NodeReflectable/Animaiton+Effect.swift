//
//  File.swift
//  
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation
import SceneKit

extension AnimatedModel: OnUpdateElement {
    func onUpdate() {
        guard let animation = animation else { return }
        print("Begin Animation")
        SCNTransaction.begin()
        switch animation {
            case .easeInOut(let duration):
                SCNTransaction.animationDuration = duration
                SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            case .easeIn(let duration):
                SCNTransaction.animationDuration = duration
                SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeIn)
            case .easeOut(let duration):
                SCNTransaction.animationDuration = duration
                SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeOut)
            case .linear(let duration):
                SCNTransaction.animationDuration = duration
                SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .linear)
        }
    }
    
    func onUpdatedEnded() {
        guard animation != nil else { return }
        print("End Animation")
        SCNTransaction.commit()
    }
}
