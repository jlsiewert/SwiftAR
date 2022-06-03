// Copyright 2019-2020 Tokamak contributors
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
//
//  Created by Max Desiatov on 09/02/2019.
//

typealias Updater<T> = (inout T) -> ()

/**
 Use a `Binding` when you want pass a mutable reference to a source of
 truth managed.
 
 A `Binding` gets created from a ``State`` using the `$` prefix shorthand.
 
 ```swift
 // A model that changes its color based on a Binding<Bool>
 struct ColorChangingModel: Model {
    @Binding tapped: Bool

    var body: some Model {
        Sphere()
            .material(.color( tapped ? .red : .blue ))
            .onTap {
                // Even though the model defines no source of truth,
                // the binding provides a mutable reference to one.
                tapped.toggle()
            }
    }
 }
 
 struct MyModel: Model {
    @State state = true
 
    var body: some Model {
        ColorChangingModel($state) // Create a Binding using the $ shorthand from a State
            .scale(state ? 1 : 0.5 )
    }
 }
 ```
 
 Note that `set` functions are not `mutating`, they never update the
 view's state in-place synchronously, but only schedule an update with
 the renderer at a later time.
 */
@propertyWrapper public struct Binding<Value>: DynamicProperty {
  public var wrappedValue: Value {
    get { get() }
    nonmutating set { set(newValue) }
  }

  private let get: () -> Value
  private let set: (Value) -> ()

  /// Retruns a `Binding` for the value
  public var projectedValue: Binding<Value> { self }

  /// Create a new Binding from a specific getter and setter.
  public init(get: @escaping () -> Value, set: @escaping (Value) -> ()) {
    self.get = get
    self.set = set
  }

  /// Use a keypath to create a nested Binding
  public subscript<Subject>(
    dynamicMember keyPath: WritableKeyPath<Value, Subject>
  ) -> Binding<Subject> {
    .init(
      get: {
        self.wrappedValue[keyPath: keyPath]
      }, set: {
        self.wrappedValue[keyPath: keyPath] = $0
      }
    )
  }

  /// Create a Binding for a constant value.
  ///
  /// Attempting to mutate a constant binding has no effect.
  public static func constant(_ value: Value) -> Self {
    .init(get: { value }, set: { _ in })
  }
}
