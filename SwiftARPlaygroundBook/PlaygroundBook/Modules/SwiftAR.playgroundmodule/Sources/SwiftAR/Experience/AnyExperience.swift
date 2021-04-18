//
//  AnyExperience.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 11.04.21.
//

import Foundation

struct AnyExperience: Experience {
    var experience: Any
    let bodyClosure: (Any) -> AnyAnchor
    let bodyType: Any.Type
    let type: Any.Type
    
    init<E: Experience>(erasing experience: E) {
        if let e = experience as? AnyExperience {
            self = e
        } else {
            self.experience = experience
            self.bodyClosure = { AnyAnchor(erasing: ($0 as! E).body) }
            self.bodyType = E.Body.Type.self
            self.type = E.self
        }
    }
    
    var body: AnyAnchor {
        bodyClosure(experience)
    }
    
    init() {
        fatalError("Don't initialize `AnyExperience` directly")
    }
}
