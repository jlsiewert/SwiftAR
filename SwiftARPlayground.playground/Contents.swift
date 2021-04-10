import SwiftAR
import PlaygroundSupport
import UIKit

struct PlaygroundExperience: Experience {
    var body: some Anchor {
        Surface {
            Cube()
        }
    }
}

let renderer = SCNRenderedViewController(experience: PlaygroundExperience())
renderer.view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
PlaygroundPage.current.liveView = renderer.view
