//
//  ModifiedContent.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 10.04.21.
//

import Foundation

protocol ModifierContainer {
    var environmentModifier: EnvironmentModifier? { get }
}

public struct ModifiedContent<Content: Model, Modifier: ModelModifier>: PrimitiveModel {
    @Environment(\.self) var environment
    
    public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
    
    let content: Content
    private(set) var modifier: Modifier

}

extension ModifiedContent: ChildProvidingModel {
    var children: [AnyModel] {
        [AnyModel(erasing: content)]
    }
}

extension ModifiedContent: ApplyableModel {
    func applyModifier(_ closure: (Any) -> ()) {
        closure(modifier as Any)
    }
}

extension ModifiedContent: ModifierContainer {
    var environmentModifier: EnvironmentModifier? { modifier as? EnvironmentModifier }
}

extension ModifiedContent: EnvironmentReader where Modifier: EnvironmentReader {
    mutating func setContent(from values: EnvironmentValues) {
        modifier.setContent(from: values)
    }
}
