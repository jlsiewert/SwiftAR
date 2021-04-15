//
//  ModelModifier.swift
//  
//
//  Created by Jan Luca Siewert on 10.04.21.
//
// Copyright 2020 Tokamak contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import Foundation

public protocol ModelModifier {
    associatedtype Body: Model
    
    typealias Content = _ModelModifierContent<Self>
    
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
    func modifier<Modifier: ModelModifier>(_ modifier: Modifier) -> ModifiedContent<Self, Modifier> {
        ModifiedContent(content: self, modifier: modifier)
    }
}

protocol ChildProvidingModel {
    var children: [AnyModel] { get }
}

protocol AppyableModel {
    func applyModifier(_ closure: (Any) -> ())
}
