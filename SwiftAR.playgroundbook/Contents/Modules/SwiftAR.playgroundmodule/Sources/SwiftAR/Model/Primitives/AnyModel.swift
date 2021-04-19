//
//  AnyModel.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 10.04.21.
//

import Foundation

public struct AnyModel: Model {
    let bodyClosure: (Any) -> AnyModel
    /// The type erased model
    var model: Any
    let bodyType: Any.Type
    let type: Any.Type

    public init<M: Model>(erasing model: M) {
        if let model = model as? AnyModel {
            self = model
        } else {
            self.model = model
            self.bodyClosure = {
                return AnyModel(erasing: ($0 as! M).body)
            }
            self.bodyType = M.Body.Type.self
            self.type = M.self
        }
        
    }
    
    public var body: AnyModel {
        self.bodyClosure(model)
    }
    
}
