//
//  AnyAnchor.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 11.04.21.
//

import Foundation

struct AnyAnchor: Anchor {
    var anchor: Any
    let bodyClosure: (Any) -> AnyModel
    let bodyType: Any.Type
    let type: Any.Type
    
    init<A: Anchor>(erasing anchor: A) {
        if let a = anchor as? AnyAnchor {
            self = a
        } else {
            self.anchor = anchor
            self.bodyClosure = { AnyModel(erasing: ($0 as! A).body) }
            self.bodyType = A.Body.Type.self
            self.type = A.self
        }
    }
    
    var body: AnyModel {
        return bodyClosure(anchor)
    }
}
