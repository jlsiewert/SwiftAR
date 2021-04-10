//
//  ModifiedContent.swift
//  
//
//  Created by Jan Luca Siewert on 10.04.21.
//

import Foundation

public struct ModifiedContent<Content: Model, Modifier: ModelModifier>: Model {
    
    public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
    
    let content: Content
    let modifier: Modifier
    
    public var body: Modifier.Body {
        applied
    }
    
    public var applied: Modifier.Body {
        modifier.body(content: _ModelModifierContent(modifier: modifier, content: content))
    }
}

extension ModifiedContent: ModifiedModelContentDeferredToRenderer where Modifier: PrimitiveModifier {
    func createMountedElement<R, E>(for parent: AnyMountedElement<R, E>) -> AnyMountedElement<R, E> where R : Renderer, E : Experience {
        let element = MountedElement(model: content, parent: parent)
        return AnyMountedElement(element: element)
    }
    
    func applyToModifier(closure: (Any) -> ()) {
        closure(modifier as Any)
    }
}
