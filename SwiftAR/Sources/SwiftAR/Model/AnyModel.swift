//
//  AnyModel.swift
//  
//
//  Created by Jan Luca Siewert on 10.04.21.
//

import Foundation

public struct AnyModel: Model {
    private let bodyClosure: () -> AnyModel

    public init<M: Model>(erasing model: M) {
        if let model = model as? AnyModel {
            self = model
        } else {
            self.bodyClosure = { AnyModel(erasing: model.body) }
        }
    }
    
    public var body: AnyModel {
        self.bodyClosure()
    }
    
}
