# ``SwiftAR/Model``

A `Model` is the basic building block to create virtual content.

## Overview

Use a ``ModelBuilder`` to create a concete model builder.

```swift
struct MyModel: Model {
    var body: some Model {
        Sphere()
    }
}
```

To modify a model, use a ``ModelModifier``, for example
to change the scane in which the model is shown.

```swift
struct MyModel: Model {
    var body: some Model {
        Sphere()
           .scale(0.3)
    }
}
```

## Topics

### Body

- ``body-swift.property``
- ``Model/Body``
- ``ModelBuilder``

### Model Primitives

- ``Cube``
- ``Plane``
- ``Sphere``

### Custom Models


- ``Group``
- ``ForEach``
- ``AnyModel``
- ``AnimatedModel``
- ``TupelModel``

### Modifiers

- <doc:ModelModifiers>

