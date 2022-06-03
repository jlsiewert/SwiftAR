# ``SwiftAR``

SwiftAR is a declerative framework to create Augmented Reality experiences.

![The SwiftAR Logo](Header.png)

> Warning: `SwiftUI` is a **proof-of-concept** that was build entirely
for the 2021 WWDC Scholarship.
It is an exploration on how `SwiftUI` internals, like `@State`, might
be build in pure Swift.
It is intended to be used as part of this Playground Book and this
Playground Book alone.
While the implementation is stable and functional, it **should not
be used as part of any production environment**.

The SwiftAR API design is heavily inspired by `SwiftUI` and can be used to create
interactive AR content based on `ARKit`.

An AR experience is built using three basic building blocks.

1. The ``Experience`` is the base protocol that describes the AR scene.
2. An ``Anchor`` describes how content is added to the real world.
3. The ``Model`` is used to create virtual AR content.

## Topics

### Experience

- ``Experience``

### Anchor

- ``Anchor``
- ``Surface``
- ``World``

### Model

- ``Model``
- ``Material``

### State

- ``State``
- ``Binding``
- ``StateObject``
- ``ObservedObject``

### Environment

- ``Environment``
- ``EnvironmentObject``
- ``EnvironmentKey``
- ``EnvironmentValues``

#### Built-In Environement Keys

- ``ReduceVertexCountKey``
- ``MaterialEnvrionmentKey``

### Rendering Experiences

- ``SCNRenderedViewController``

