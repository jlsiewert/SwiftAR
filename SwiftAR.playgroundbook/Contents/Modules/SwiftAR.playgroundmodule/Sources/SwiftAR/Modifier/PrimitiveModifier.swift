//
//  PrimitiveModifier.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 10.04.21.
//

import Foundation

protocol PrimitiveModifier: ModelModifier {
    associatedtype Body = Never
}

public extension ModelModifier where Body == Never {
    func body(content: Content) -> Body {
        fatalError(
            "\(Self.self) is a primitive `ModelModifier`, you're not supposed to run `body(content:)`"
        )
    }
}
