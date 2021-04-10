import SwiftAR
import PlaygroundSupport
import UIKit

struct PlaygroundExperience: Experience {
    var body: some Anchor {
        Surface {
            Cube()
                .rotate(yaw: .pi / 4)
        }
    }
}

let renderer = SCNRenderedViewController(experience: PlaygroundExperience())
PlaygroundPage.current.liveView = renderer.view
