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
 Use `EnvironmentValues` together with ``EnvironmentKey`` to create
 custom values to pass down the model hierachy.
 
 ```swift
 public struct ReduceVertexCountKey: EnvironmentKey {
     /// By default, no reduction in rendering quality should take place.
     public static var defaultValue: Bool = false
 }

 public extension EnvironmentValues {
     var reducedVertexCount: Bool {
         get { self[ReduceVertexCountKey.self] }
         set { self[ReduceVertexCountKey.self] = newValue }
     }
 }
 ```
 */
public struct EnvironmentValues {
  private var values: [ObjectIdentifier: Any] = [:]

  public init() {}

  public subscript<K>(key: K.Type) -> K.Value where K: EnvironmentKey {
    get {
      if let val = values[ObjectIdentifier(key)] as? K.Value {
        return val
      }
      return K.defaultValue
    }
    set {
      values[ObjectIdentifier(key)] = newValue
    }
  }

  subscript<B>(bindable: ObjectIdentifier) -> B? where B: ObservableObject {
    get {
      values[bindable] as? B
    }
    set {
      values[bindable] = newValue
    }
  }
}

struct IsEnabledKey: EnvironmentKey {
  static let defaultValue = true
}

extension EnvironmentValues {
  var isEnabled: Bool {
    get {
      self[IsEnabledKey.self]
    }
    set {
      self[IsEnabledKey.self] = newValue
    }
  }
}

struct _EnvironmentValuesWritingModifier: ModelModifier, EnvironmentModifier {
  let environmentValues: EnvironmentValues

  func body(content: Content) -> some Model {
    content
  }

  func modifyEnvironment(_ values: inout EnvironmentValues) {
    values = environmentValues
  }
}

extension Model {
  func environmentValues(_ values: EnvironmentValues) -> some Model {
    modifier(_EnvironmentValuesWritingModifier(environmentValues: values))
  }
}
