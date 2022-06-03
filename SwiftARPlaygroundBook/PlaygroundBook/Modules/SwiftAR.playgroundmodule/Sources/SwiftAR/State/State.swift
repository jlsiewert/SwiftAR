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
//
//  Created by Max Desiatov on 08/04/2020.
//
protocol ValueStorage {
  var getter: (() -> Any)? { get set }
  var anyInitialValue: Any { get }
}

protocol WritableValueStorage: ValueStorage {
  var setter: ((Any) -> ())? { get set }
}

/**
 Use `State` when you want to define a source of truth for a value.
 
 The storage of the value is managed by the system.
 Use the `$` shorthand to create a mutable ``Binding`` to that source of truth.
 
 See ``Binding`` for details
 */
@propertyWrapper public struct State<Value> {
  private let initialValue: Value

  var anyInitialValue: Any { initialValue }

  var getter: (() -> Any)?
  var setter: ((Any) -> ())?

  /// Create a source of truth by wrapping an initial value
  public init(wrappedValue value: Value) {
    initialValue = value
  }

  /// Read and write to the value managed by the system
  public var wrappedValue: Value {
    get { getter?() as? Value ?? initialValue }
    nonmutating set { setter?(newValue) }
  }

  /// Create a `Binding` from the source of truth
  public var projectedValue: Binding<Value> {
    guard let getter = getter, let setter = setter else {
      fatalError("\(#function) not available outside of `body`")
    }
    // swiftlint:disable:next force_cast
    return .init(get: { getter() as! Value }, set: { setter($0) })
  }
}

extension State: WritableValueStorage {}
extension State: DynamicProperty { }

public extension State where Value: ExpressibleByNilLiteral {
  @inlinable
  init() { self.init(wrappedValue: nil) }
}
