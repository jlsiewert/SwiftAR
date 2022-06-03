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

import Combine

/**
 A `StateObject` subscribes to a Combine `ObservableObject`
 and rerenders a `Model` when the object publishes it's ``Combine/ObservableObject/objectWillChange`` publisher.
 
 Use `StateObject` when you want `SwiftAR` to manage the lifecycle of the class instance.
 Look at ``ObservedObject`` when you manage the lifecycle yourself or when the object
 gets stored by `SwiftAR` from another `Model`.
 
 ```swift
 class CurrentPositionModel: ObservableObject {
    @Published var position: simd_float3 = [0, 0, 0]
 }
 
 struct MyModel: Model {
    // Make SwiftAR responsible for managing an instance of our model.
    // A new CurrentPositionModel only gets created when a new MyModel is added
    // to the render hierachy.
    @StateObject var model = CurrentPositionModel()
 
    var body: some Model {
        Sphere()
            .translate(model.position)
    }
 }
 ```
 
 */
@propertyWrapper
public struct StateObject<ObjectType: ObservableObject>: DynamicProperty {
  /// Returns the stored value
  public var wrappedValue: ObjectType { (getter?() as? ObservedObject.Wrapper)?.root ?? initial() }

  let initial: () -> ObjectType
  var getter: (() -> Any)?
    
  /// Create a new `StateObject` by wrapping a `ObservableObject` instance
  /// - Parameter initial: The instance that should be managed by `SwiftAR`.
  ///
  /// The `wrappedValue` will be stored the first time a `Model` is added to the
  /// hierachy. On subsequent redraws, the stored object will be used.
  public init(wrappedValue initial: @autoclosure @escaping () -> ObjectType) {
    self.initial = initial
  }

    /// Use the `projectedValue` with the `$` property wrapper shortcut to
    /// create a ``Binding`` to a value stored in a `StateObject`.
    ///
    /// This ``Model`` creates a `Binding` from the ``ObservedObject`` to
    /// be able to write to the stored property.
    ///
    /// ```swift
    /// struct SphereModel: Model {
    ///    @Binding var position: simd_float3
    ///
    ///    var body: some Model {
    ///       Sphere()
    ///          .translate(position)
    ///          .onTap {
    ///             // Move the sphere 1 meter in x direction
    ///             position.x += 1
    ///          }
    ///    }
    /// }
    ///
    /// struct MyModel: Model {
    ///    @StateObject var model = CurrentPositionModel()
    ///
    ///    var body: some Model {
    ///       // Use the $-prefix to create a Binding to a specific property.
    ///       SphereModel(position: $model.position)
    ///    }
    /// }
    /// ```
  public var projectedValue: ObservedObject<ObjectType>.Wrapper {
    getter?() as? ObservedObject.Wrapper ?? ObservedObject.Wrapper(root: initial())
  }
}

extension StateObject: AnyObservedProperty, ObservedProperty {
  var objectWillChange: AnyPublisher<(), Never> {
    wrappedValue.objectWillChange.map { _ in }.eraseToAnyPublisher()
  }
}

extension StateObject: ValueStorage {
  var anyInitialValue: Any {
    ObservedObject.Wrapper(root: initial())
  }
}
