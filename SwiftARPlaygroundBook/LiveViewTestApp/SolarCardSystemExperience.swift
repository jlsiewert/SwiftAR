//
//  SolarCardSystemExperience.swift
//  LiveViewTestApp
//
//  Created by Jan Luca Siewert on 19.04.21.
//

import Foundation
import SwiftAR
import SwiftUI


typealias Anchor = SwiftAR.Anchor
typealias Group = SwiftAR.Group

struct Planet: Hashable {
    let image: UIImage
    let name: String
    let diameter: Double
    let daysPerYear: Double?
    let distanceToSun: Double?
    
    // I know, I know
    static var sun = Planet(image: #imageLiteral(resourceName: "sun.jpg"), name: "Sun", diameter: 1_392_684, daysPerYear: nil, distanceToSun: nil)
    static var mercury = Planet(image: #imageLiteral(resourceName: "mercury.jpg"), name: "Mercury", diameter: 4_879.4, daysPerYear: 88, distanceToSun: 57_909_00)
    static var venus = Planet(image: #imageLiteral(resourceName: "venus.jpg"), name: "Venus", diameter: 12_103.6, daysPerYear: 225, distanceToSun: 108_160_000)
    static var earth = Planet(image: #imageLiteral(resourceName: "earth.jpg"), name: "Earth", diameter: 12_765.3, daysPerYear: 365, distanceToSun: 149_600_000)
    static var mars = Planet(image: #imageLiteral(resourceName: "mars.jpg"), name: "Mars", diameter: 6_792.4, daysPerYear: 687, distanceToSun: 227_990_000)
    static var jupiter = Planet(image: #imageLiteral(resourceName: "jupiter.jpg"), name: "Jupiter", diameter: 142_984, daysPerYear: 4333, distanceToSun: 778_360_000)
    static var saturn = Planet(image: #imageLiteral(resourceName: "saturn.jpg"), name: "Saturn", diameter: 120_536, daysPerYear: 10_759, distanceToSun: 1_433_500_00)
    static var uranus = Planet(image: #imageLiteral(resourceName: "uranus.jpg"), name: "Uranus", diameter: 51_118, daysPerYear: 30_687, distanceToSun: 2_872_400_00)
    static var neptune = Planet(image: #imageLiteral(resourceName: "neptune.jpg"), name: "Neptune", diameter: 49_528, daysPerYear: 60_190, distanceToSun: 4_498_400_000)
    
    static var allPlanets: [Planet] = [
        .sun,
        .mercury,
        .venus,
        .earth,
        .mars,
        .jupiter,
        .saturn,
        .uranus,
        .neptune
    ]
    
    static func == (lhs: Planet, rhs: Planet) -> Bool {
        lhs.name == rhs.name
    }
}

struct PlanetInformation: View {
    struct InformationRow: View {
        static var formatter: NumberFormatter = {
            let f = NumberFormatter()
            f.numberStyle = .decimal
            f.maximumFractionDigits = 0
            return f
        }()
        
        let value: Double?
        let label: String
        let unit: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(label).bold()
                if let value = value, let formatted = InformationRow.formatter.string(from: NSNumber(value: value)) {
                    Text("\(formatted) \(unit)")
                } else {
                    Text("–")
                }
            }
        }
    }
    
    struct PlanetTitleView: View {
        let image: UIImage
        let name: String
        
        var body: some View {
            HStack(spacing: 12) {
                Text(name)
                    .font(.largeTitle).bold()
                Spacer()
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                
            }
            .frame(maxHeight: 30)
        }
    }
    
    let planet: Planet
    @SwiftUI.Binding var visible: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            PlanetTitleView(image: planet.image, name: planet.name)
            InformationRow(value: planet.diameter, label: "Diameter", unit: "km")
            InformationRow(value: planet.distanceToSun, label: "Distance to Sun", unit: "km")
            InformationRow(value: planet.daysPerYear, label: "Year Length", unit: "days")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.cornerRadius(25))
        .onTapGesture {
            visible = false
        }
    }
}

struct PlanetInformationPlane: Model {
    let planet: Planet
    @SwiftAR.Binding var visible: Bool
    
    
    
    var body: some Model {
        Plane(width: 0.2, height: 0.2)
            .material(PlanetInformation(planet: planet, visible: $visible.binding))
            .rotate(yaw: visible ? 0 : .pi)
    }
}

struct PlanetModel: Model {
    var planet: Planet
    var radius: Float = 0.05
    var relativeToSun: Bool
    
    var body: some Model {
        Sphere(radius: sphereRadius)
            .material(.texture(planet.image))
            .translate(y: 0.1 + sphereRadius)
    }
    
    var sphereRadius: Float {
        if relativeToSun {
            return Float(Double(radius) * planet.diameter / Planet.sun.diameter)
        } else {
            return radius
        }
    }
}

struct PlanetInformationModel: Model {
    let planet: Planet
    @SwiftAR.State var selected: Bool = false
    var radius: Float = 0.1
    var body: some Model {
        Group {
            PlanetModel(planet: planet, radius: radius, relativeToSun: selected)
            PlanetInformationPlane(planet: planet, visible: $selected)
        }
        .animation()
        .onTap {
            selected.toggle()
        }
    }
}

struct SolarSystemExperience: Experience {
    let planetCount = Planet.allPlanets.count
    let radius: Float = 0.1
    let relativeToSun: Bool = false
    
    var body: some Anchor {
        Surface(.horizontal) {
            ForEach(0..<planetCount) { i in
                PlanetInformationModel(planet: Planet.allPlanets[i], radius: radius)
                    .environment(\.reducedVertexCount, true)
                    .translate(x: 2.5 * radius * (Float(i) - Float( planetCount ) / Float(2) ))
            }
        }
    }
}
