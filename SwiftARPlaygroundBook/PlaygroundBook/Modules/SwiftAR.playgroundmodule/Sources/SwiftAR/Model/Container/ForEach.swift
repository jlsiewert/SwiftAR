//
//  ForEach.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation

public struct ForEach<Data: RandomAccessCollection, ID: Hashable, Content: Model>: Model {
    let data: Data
    let id: KeyPath<Data.Element, ID>
    let content: (Data.Element) -> Content
    
    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @ModelBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
    }
}

public extension ForEach where Data.Element: Identifiable, ID == Data.Element.ID {
    init(_ data: Data, @ModelBuilder content: @escaping (Data.Element) -> Content) {
        self.init(data, id: \.id, content: content)
    }
}

public extension ForEach where Data == Range<Int>, ID == Int {
    init(_ range: Range<Int>, @ModelBuilder content: @escaping (Data.Element) -> Content) {
        self.init(range, id: \.self, content: content)
    }
}

extension ForEach: PrimitiveModel {  }

extension ForEach: ChildProvidingModel {
    var children: [AnyModel] {
        data.map(content)
            .map( { AnyModel(erasing: $0) } )
    }
    
    
}
