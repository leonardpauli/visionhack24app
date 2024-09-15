import SwiftUI

@MainActor
@Observable
class AppModel {
  static let immersiveSpaceID = "ImmersiveSpace"
  static let immersiveSphereDetailID: String = "ImmersiveSphereDetail"

  enum ImmersiveSpaceState {
    case closed
    case inTransition
    case open
  }
  var immersiveSpaceState = ImmersiveSpaceState.closed

  var mainSphere = Sphere(position: [0, 0, 0], radius: 0.05, color: .cyan, isPointer: true)
  var additionalSpheres: [Sphere] = []

  func addSphere(at position: SIMD3<Float>) {
    let newSphere = Sphere(position: position)
    additionalSpheres.append(newSphere)
  }

  func updateSphere(_ sphere: Sphere) {
    if let index = additionalSpheres.firstIndex(where: { $0.id == sphere.id }) {
      additionalSpheres[index] = sphere
    }
  }

  func deleteSphere(_ sphere: Sphere) {
    additionalSpheres.removeAll { $0.id == sphere.id }
  }
}
