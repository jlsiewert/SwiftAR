//
//  ForEach.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation

/**
 Use `ForEach` to iterate over a `RandomAccessCollection` and create a `Model` for each `Element`.
 
 To identify each element across multiple renders, provide a `KeyPath<Data.Element: ID>`, where `ID` is static,
 hashable property or make sure `Data.Element` conforms to `Identifiable`.
 
 ```swift
 struct MyModel: Model {
    let positions: Set<simd_float3> = [[0,0,0], [1,0,0], [1,1,0]]
 
    var body: some Model {
        // Because simd_float3 conforms to Hasbable, we use \.self as the id for our elements.
        ForEach(positions, id: \.self) { p in
            Sphere()
                .translate(p)
        }
    }
 }
 */
public struct ForEach<Data: RandomAccessCollection, ID: Hashable, Content: Model>: Model {
    let data: Data
    let id: KeyPath<Data.Element, ID>
    let content: (Data.Element) -> Content
    
    /// Iterate over a collection by providing a closure and a key path to a constant hashable property.
    /// - Parameters:
    ///   - data: the data to iterate through
    ///   - id: A keypath to a property that identifies the element. Each element should have a unique, stable ID
    ///   - content: A closure to create a `Model` from an individual `Element`
    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @ModelBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
    }
}

public extension ForEach where Data.Element: Identifiable, ID == Data.Element.ID {
    
    /// Iterate over a collection of identifiable elements with a closure
    /// - Parameters:
    ///   - data: The collection of elements
    ///   - content: A closure to create a `Model` from an individual element.
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
