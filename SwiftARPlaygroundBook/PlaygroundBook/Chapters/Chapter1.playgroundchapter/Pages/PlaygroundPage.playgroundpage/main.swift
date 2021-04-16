/*:
 # Introduction to SwiftAR
 
 *A Playground by Jan Luca Siewert*
 
 ## Introduction
 
 The introduction of `SwiftUI` drastically lowered
 the boundary for new Swift programmers to create
 beautiful, native applications.
 
 Another area that usually requres a lot of knowledge
 and experience is AR.
 
 This Playground introduces `SwiftAR`, a `SwiftUI`-inspired,
 declerative syntax to create AR experiences.
 
 ## Getting Started
 
 Take a look at the simple `struct` below.
 The `Experience` is the base required to create
 an Augmented Reality experience.
 It starts with an `Anchor`, in this case
 a surface.
 
 On top of the surface one can add a `Model`.
 Models support a `ViewBuilder` like `ModelBuilder`
 syntax as well as modifiers.
 
 Here, we create a simple cube and change it's
 `material` to a simple color.
 
 Run the Playground and find a surface to see the
 created `PlaygroundExperience` in action.
 Besides declaring the hierachy, just call
 `PlaygroundExperience.liveView()` to start
 the experience in the live view.
 
 */

import SwiftAR

struct PlaygroundExperience: Experience {
    var body: some Anchor {
        Surface(.horizontal) {
            Cube()
                .material(.color(.orange))
        }
    }
}

PlaygroundExperience.liveView()
