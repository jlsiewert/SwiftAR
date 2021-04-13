import XCTest
@testable import SwiftAR

final class SwiftARTests: XCTestCase {
    func testSimpleCube() {
        struct PlaygroundExperience: Experience {
            var body: some Anchor {
                Surface {
                    Cube()
                }
            }
        }
        
        let experience = PlaygroundExperience()
        let vc = SCNRenderedViewController(experience: experience)
        vc.viewWillAppear(true)
        let e = expectation(description: "wait for nothing")
        wait(for: [e], timeout: 60*60)
    }
}
