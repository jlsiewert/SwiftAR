//
//  File.swift
//  
//
//  Created by Jan Luca Siewert on 11.04.21.
//

import Foundation
import Combine

protocol ObservedProperty: DynamicProperty {
    associatedtype ObjectWillChangePublisher: Publisher where ObjectWillChangePublisher.Failure == Never
    
    var objectWillChange: ObjectWillChangePublisher { get }
}


protocol AnyObservedProperty: ObservedProperty {
    var anyObjectWillChange: AnyPublisher<Void, Never> { get }
}

extension AnyObservedProperty {
    var anyObjectWillChange: AnyPublisher<Void, Never> {
        objectWillChange.map({ _ in () }).eraseToAnyPublisher()
    }
}
