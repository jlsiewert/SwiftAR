//
//  OptionalModel.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 18.04.21.
//

import Foundation

public struct _OptionalModel<Body: Model>: Model {
    var wrapped: Body?
    
    public init(_ wrapped: Body?) {
        self.wrapped = wrapped
    }
}

extension _OptionalModel: PrimitiveModel { }

extension _OptionalModel: ChildProvidingModel {
    var children: [AnyModel] {
        if let w = wrapped {
            return [AnyModel(erasing: w)]
        } else {
            return []
        }
    }
}
