//
//  ModelModifier.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 10.04.21.
//


import Foundation

/// A modifier that is applied to a ``Model``
public protocol ModelModifier {
    /// The result type of the modifier
    associatedtype Body: Model
    /// The base type the modifier is applied to.
    typealias Content = _ModelModifierContent<Self>
    /// The closue that applies the desired effect.
    func body(content: Content) -> Body
}


public struct _ModelModifierContent<Modifier: ModelModifier>: Model {
    let modifier: Modifier
    let content: AnyModel
    
    init<M: Model>(modifier: Modifier, content: M) {
        self.modifier = modifier
        self.content = AnyModel(erasing: content)
    }
    public var body: AnyModel { content }
}

public extension Model {
    
    /// Applies a given ``ModelModifier`` to the `Model`.
    /// - Returns: A ``ModifiedContent`` `Model`.
    func modifier<Modifier: ModelModifier>(_ modifier: Modifier) -> ModifiedContent<Self, Modifier> {
        ModifiedContent(content: self, modifier: modifier)
    }
}

protocol ChildProvidingModel {
    var children: [AnyModel] { get }
}

protocol ApplyableModel {
    func applyModifier(_ closure: (Any) -> ())
}
