//
//  ConditionalModel.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 18.04.21.
//

import Foundation

public struct _ConditionalModel<TrueContent: Model, FalseContent: Model>: Model {
    enum Content {
        case `true`(TrueContent)
        case `false`(FalseContent)
    }
    
    var content: Content
    
    init(content: Content) {
        self.content = content
    }
}

extension _ConditionalModel: PrimitiveModel { }

extension _ConditionalModel: ChildProvidingModel {
    var children: [AnyModel] {
        switch content {
            case .false(let falseContent):
                return [AnyModel(erasing: falseContent)]
            case .true(let trueContent):
                return [AnyModel(erasing: trueContent)]
        }
    }
}
