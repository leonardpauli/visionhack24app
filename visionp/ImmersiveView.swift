import RealityKit
import RealityKitContent
import SwiftUI

struct ImmersiveView: View {
  @Environment(AppModel.self) private var appModel
  @ObservedObject var gestureModel: HandGestureModel

  @Environment(\.openWindow) private var openWindow

  class SceneObjects {
    var pointerSphere: ModelEntity?
  }
  @State private var sceneObjects = SceneObjects()

  var body: some View {
    RealityView { content in
      self.sceneObjects.pointerSphere = add_colored_sphere(
        to: content, sphere: appModel.mainSphere, main: true)
      content.add(self.sceneObjects.pointerSphere!)
    } update: { content in
      updateMainSphere(content)
      updateAdditionalSpheres(content)
    }
    .gesture(
      SpatialTapGesture().targetedToAnyEntity().onEnded { value in
        handleTap(on: value.entity)
      }
    )
    .task {
      await gestureModel.start()
    }
    .task {
      await gestureModel.publishHandTrackingUpdates()
    }
    .task {
      await gestureModel.monitorSessionEvents()
    }
  }

  private func updateMainSphere(_ content: RealityViewContent) {
    guard let sphere = sceneObjects.pointerSphere
    else { return }

    let p1 = gestureModel.latestHandTracking.right
    let p2 = gestureModel.latestHandTracking.left

    guard let pointer1 = gestureModel.computeIndexFingerTipPositionGlobal(for: p1)
    else { return }
    guard let pointer2 = gestureModel.computeIndexFingerTipPositionGlobal(for: p2)
    else { return }

    // guard
    //   let mainSphereEntity = content.entities.first(where: { $0.name == "MainSphere" })
    //     as? ModelEntity
    // else { return }

    sphere.scale = .one * appModel.mainSphere.radius
    // appModel.mainSphere.position = pointer1
    sphere.position = pointer1

    print("main sphere pos \(pointer1)")

    let distance = distance(pointer1, pointer2)
    let color = UIColor(
      hue: CGFloat(distance / 2.0), saturation: 1.0, brightness: 1.0,
      alpha: distance < appModel.mainSphere.radius ? 0.3 : 1.0)
    sphere.model?.materials = [SimpleMaterial(color: color, roughness: 0.5, isMetallic: true)]

    // if let pointer = gestureModel.computeIndexFingerTipPositionGlobal(
    //   for: gestureModel.latestHandTracking.right)
    // {
    //   mainSphereEntity.position = pointer
    //   appModel.mainSphere.position = pointer
    // }
  }

  private func updateAdditionalSpheres(_ content: RealityViewContent) {
    for var sphere in appModel.additionalSpheres {
      if let sphereEntity = content.entities.first(where: { $0.name == sphere.id.uuidString })
        as? ModelEntity
      {
        
        // sphereEntity.position = sphere.position
        sphere.position = sphereEntity.position
        sphereEntity.scale = .one * sphere.radius
        sphereEntity.model?.materials = [
          SimpleMaterial(color: UIColor(sphere.color), roughness: 0.5, isMetallic: true)
        ]
      } else {
        let sphereEntity = add_colored_sphere(to: content, sphere: sphere)
        sphereEntity.position = sphere.position
        sphereEntity.scale = .one * sphere.radius
        sphereEntity.model?.materials = [
          SimpleMaterial(color: UIColor(sphere.color), roughness: 0.5, isMetallic: true)
        ]
        content.add(sphereEntity)
      }
    }
  }

  private func handleTap(on entity: Entity) {
    print("Tapped on \(entity.name)")
    if entity.id == sceneObjects.pointerSphere?.id {
      let newPosition = appModel.mainSphere.position + [0, 0, -0.1]  // Add sphere slightly in front
      appModel.addSphere(at: newPosition)
    } else if let sphereId = UUID(uuidString: entity.name) {
      if let sphere = appModel.additionalSpheres.first(where: { $0.id == sphereId }) {
        openWindow(id: AppModel.immersiveSphereDetailID, value: sphere)
      }
    }
  }

  private func add_colored_sphere(
    to content: RealityViewContent, sphere: Sphere, main: Bool = false
  ) -> ModelEntity {
    let sphereEntity = ModelEntity(
      mesh: .generateSphere(radius: 1.0),
      materials: [SimpleMaterial(color: UIColor(sphere.color), roughness: 0.5, isMetallic: true)]
    )
    sphereEntity.position = sphere.position
    sphereEntity.name = sphere.id.uuidString

    sphereEntity.components.set(InputTargetComponent())
    sphereEntity.generateCollisionShapes(recursive: true)

    var physicsBody = PhysicsBodyComponent(
      shapes: [.generateSphere(radius: sphere.radius)],
      mass: 1.0,
      material: .generate(friction: 0.5, restitution: 0.5),
      mode: main ? .kinematic : .dynamic
    )
    physicsBody.isAffectedByGravity = false
    sphereEntity.components.set(physicsBody)

    return sphereEntity
  }
}

#Preview(immersionStyle: .mixed) {
  ImmersiveView(gestureModel: HandGestureModelContainer.handGestureModel)
    .environment(AppModel())
}
