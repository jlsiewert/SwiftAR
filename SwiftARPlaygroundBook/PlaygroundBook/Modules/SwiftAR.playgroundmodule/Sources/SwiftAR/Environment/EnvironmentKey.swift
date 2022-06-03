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

/// Use the `EnvironmentKey` together with ``EnvironmentValues`` to define custom keys to pass down the hierachy.
public protocol EnvironmentKey {
  associatedtype Value
  static var defaultValue: Value { get }
}

protocol EnvironmentModifier {
  func modifyEnvironment(_ values: inout EnvironmentValues)
}

struct _EnvironmentKeyWritingModifier<Value>: ModelModifier, EnvironmentModifier {
  public let keyPath: WritableKeyPath<EnvironmentValues, Value>
  public let value: Value

  public init(keyPath: WritableKeyPath<EnvironmentValues, Value>, value: Value) {
    self.keyPath = keyPath
    self.value = value
  }

  public typealias Body = Never

  func modifyEnvironment(_ values: inout EnvironmentValues) {
    values[keyPath: keyPath] = value
  }
}

public extension Model {
  func environment<V>(
    _ keyPath: WritableKeyPath<EnvironmentValues, V>,
    _ value: V
  ) -> some Model {
    modifier(_EnvironmentKeyWritingModifier(keyPath: keyPath, value: value))
  }
}
