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
 A `ObservedObject` subscribes to a Combine `ObservableObject`
 and rerenders a `Model` when the object publishes it's ``Combine/ObservableObject/objectWillChange`` publisher.
 
 When using `ObservedObject`, it is your responsibility to manage the lifecycle of the class instance.
 Look at ``StateObject`` when `SwiftAR` should manage the storage of the object yourself.
 
 ```swift
 class CurrentPositionModel: ObservableObject {
 @Published var position: simd_float3 = [0, 0, 0]
 }
 
 struct MyModel: Model {
    // A specific model instance is passed to the struct when it is created.
    @ObservedObject var model: CurrentPositionModel
 
     var body: some Model {
        Sphere()
            .translate(model.position)
     }
 }
 ```
 
 */
@propertyWrapper
public struct ObservedObject<ObjectType>: DynamicProperty where ObjectType: ObservableObject {
  /// A wrapper to create a binding from a property of an `ObservedObject`
  @dynamicMemberLookup
  public struct Wrapper {
    let root: ObjectType
    public subscript<Subject>(
      dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>
    ) -> Binding<Subject> {
      .init(
        get: {
          self.root[keyPath: keyPath]
        },
        set: {
          self.root[keyPath: keyPath] = $0
        }
      )
    }
  }
  
  /// Returns the stored object.
  public var wrappedValue: ObjectType { projectedValue.root }
    
    /// Create a `ObservedObject` by wrapping an object instance.
    /// - Parameter wrappedValue: The instance to wrap
  public init(wrappedValue: ObjectType) {
    projectedValue = Wrapper(root: wrappedValue)
  }

    /// Use the `projectedValue` with the `$` property wrapper shortcut to
    /// create a ``Binding`` to a value stored in a `ObservableObject`.
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
    ///    // Note that we don't initialize a new CurrentPositionModel.
    ///    // Instead, a managed instance needs to be passed from a super-model.
    ///    @ObservableObject var model: CurrentPositionModel
    ///
    ///    var body: some Model {
    ///       // Use the $-prefix to create a Binding to a specific property.
    ///       SphereModel(position: $model.position)
    ///    }
    /// }
    /// ```
  public let projectedValue: Wrapper
}

extension ObservedObject: AnyObservedProperty, ObservedProperty {
  var objectWillChange: AnyPublisher<(), Never> {
    wrappedValue.objectWillChange.map { _ in }.eraseToAnyPublisher()
  }
}
