#  SwiftAR

`SwiftAR` is a declerative framework to build AR experiences, with a `SwiftUI` inspired design.

It builds on the base types `Experience`, `Anchor` and `Model` to compose AR scenes.
It has support for primitve models, materials and textures (even `SwiftUI` views can be assigned
as a material) as well as interactivity.

The types can use the `@State` or similar property wrappers (like `@StateObjects`, `@EnvironmentObject` , etc.)
to build interactive scenses.
A `Model` can have an `onTap` gesture attached.
Similarly, the `World` anchor class supports raycasting through the `onTap` modifier as well.

The projects supports result builders `ModelModifiers` and collections with `ForEach`
as well as `@Environment`

## Acknowlegments

The project uses files and implentations from the [Tokamak](https://github.com/TokamakUI/Tokamak)
project, available under the Apache 2 License.

The demo playground uses textures for the planets from our soloar system
from [Solar System Scope](https://www.solarsystemscope.com/)
under the Creative Commons Attribution 4.0 International license.


This project is my submission for the WWDC 21 Swift Students Challenge.
