//
//  AnyModel.swift
//  
//
//  Created by Jan Luca Siewert on 10.04.21.
//

import Foundation

public struct AnyModel: Model {
    private let bodyClosure: (Any) -> AnyModel
    /// The type erased model
    var model: Any
    let bodyType: Any.Type
    let type: Any.Type

    public init<M: Model>(erasing model: M) {
        if let model = model as? AnyModel {
            print("Model is already an AnyModel!")
            self = model
        } else {
            print("AnyModel: \(Swift.type(of: model))")
            self.model = model
            self.bodyClosure = {
                print("Running body closure")
                return AnyModel(erasing: ($0 as! M).body)
            }
            self.bodyType = M.Body.Type.self
            self.type = M.Type.self
        }
        
    }
    
    public var body: AnyModel {
        self.bodyClosure(model)
    }
    
}
