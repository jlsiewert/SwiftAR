// MIT License
//
// Copyright (c) 2017-2021 Wesley Wickwire and Tokamak contributors
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

struct TypeInfo {
  public let kind: Kind
  public let name: String
  public let type: Any.Type
  public let mangledName: String
  public let properties: [PropertyInfo]
  public let size: Int
  public let alignment: Int
  public let stride: Int
  public let genericTypes: [Any.Type]

  init(metadata: StructMetadata) {
    kind = metadata.kind
    name = String(describing: metadata.type)
    type = metadata.type
    size = metadata.size
    alignment = metadata.alignment
    stride = metadata.stride
    properties = metadata.properties()
    mangledName = metadata.mangledName()
    genericTypes = Array(metadata.genericArguments())
  }

  func property(named: String) -> PropertyInfo? {
    properties.first(where: { $0.name == named })
  }
    
    static func typeInfo(of type: Any.Type) -> TypeInfo? {
        guard Kind(type: type) == .struct else {
            return nil
        }
        
        return StructMetadata(type: type).toTypeInfo()
    }

}
