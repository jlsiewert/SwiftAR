# Model Modifiers

Use modifiers to change the appearance and behaviors of a ``Model``

## Overview

Model modifiers usually modify a `Model` and return a ``ModifiedContent``.


## Topics

### Applying a Modifier

- ``Model/modifier(_:)``
- ``ModelModifier``
- ``ModifiedContent``

### Transform

- ``Model/transform(_:)``
- ``Model/translate(_:)``
- ``Model/translate(x:y:z:)``
- ``Model/rotate(_:)``
- ``Model/rotate(yaw:pitch:roll:)``
- ``Model/scale(_:)``
- ``Model/scale(x:y:z:)``
- ``Model/lookAt(_:)``
- ``TransformModifier``

### Applying Materials

- ``Material``
- ``Model/material(_:)-3ah50``
- ``Model/material(_:)-3k1h1``

### Animations

- ``Model/animation(_:)``
- ``AnimatedModel/AnimationType``
- ``AnimatedModel``

### Respond to Effects

- ``Model/onAppear(_:)``
- ``Model/onDisappear(_:)``
- ``Model/onTap(perform:)``

### Changing the Environment

- ``Model/environment(_:_:)``
- ``Model/environmentObject(_:)``
