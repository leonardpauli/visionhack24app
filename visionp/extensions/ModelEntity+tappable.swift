import Foundation
import RealityKit

extension ModelEntity {
  func addTappable() -> ModelEntity {
    let cloned = self.clone(recursive: true)
    cloned.components.set(InputTargetComponent())
    cloned.generateCollisionShapes(recursive: true)
    return cloned
  }
}
