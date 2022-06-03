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
//  Created by Carson Katri on 7/7/20.
//

import Combine

/// Use the `@EnvironmentObject` model modifier to pass down ``Combine.ObservableObject`` objects
/// down the model hierachy.
///
/// The renderer produces a runtime error when accessing an `EnvironmentObject` that was not passed down the hierachy
///
/// ```swift
/// class ViewModel: ObservableObject {
///     @Published var currentColor: Color = .red
/// }
///
/// struct ColoredSphere: Model {
///     @EnvironmentObject var model: ViewModel
///
///     var body: some Model {
///         Sphere(radius: 1)
///             .material(.color(model.currentColor))
///     }
/// }
///
/// struct MyModel: Model {
///     @StateObject var model = ViewModel()
///
///     var body: some Model {
///         ColoredSphere()
///             .environmentObject(model)
///     }
/// }
///
/// ```
@propertyWrapper public struct EnvironmentObject<ObjectType>
  where ObjectType: ObservableObject
{
  @dynamicMemberLookup public struct Wrapper {
    internal let root: ObjectType
    public subscript<Subject>(
      dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>
    ) -> Binding<Subject> {
      .init(
        get: {
          self.root[keyPath: keyPath]
        }, set: {
          self.root[keyPath: keyPath] = $0
        }
      )
    }
  }

  var _store: ObjectType?

  mutating func setContent(from values: EnvironmentValues) {
    _store = values[ObjectIdentifier(ObjectType.self)]
  }

  public var wrappedValue: ObjectType {
    guard let store = _store else { error() }
    return store
  }

  public var projectedValue: Wrapper {
    guard let store = _store else { error() }
    return Wrapper(root: store)
  }

    var objectWillChange: ObjectType.ObjectWillChangePublisher {
        wrappedValue.objectWillChange
  }

  func error() -> Never {
    fatalError("No ObservableObject found for type \(ObjectType.self)")
  }

  public init() {}
}

extension EnvironmentObject: ObservedProperty, EnvironmentReader, AnyObservedProperty {}

extension ObservableObject {
  static var environmentStore: WritableKeyPath<EnvironmentValues, Self?> {
    \.[ObjectIdentifier(self)]
  }
}

public extension Model {
  func environmentObject<B>(_ bindable: B) -> some Model where B: ObservableObject {
    environment(B.environmentStore, bindable)
  }
}
