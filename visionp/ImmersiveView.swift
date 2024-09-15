//
//  ImmersiveView.swift
//  visionp
//
//  Created by Leonard Pauli on 2024-09-14.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ImmersiveView: View {
  @Environment(AppModel.self) private var appModel
  @ObservedObject var gestureModel: HandGestureModel

  var body: some View {
    RealityView { content in
      // Existing spheres
      add_sphere(to: content).position.x = 1.0
      add_sphere(to: content).position.y = 1.0
      add_sphere(to: content).position.z = 1.0
      _ = add_sphere(to: content)
      _ = add_blue_sphere(to: content)
    } update: { content in
      guard let pointer = gestureModel.computeIndexFingerTipPositionGlobal(for: gestureModel.latestHandTracking.right) else {return}
      
      if let blueSphere = content.entities.first(where: { $0.name == "BlueSphere" }) as? ModelEntity
      {
        blueSphere.position = [appModel.sphereX, appModel.sphereY, appModel.sphereZ]
        blueSphere.scale = .one * appModel.sphereRadius
        blueSphere.position = pointer
      }
    }
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

  func add_sphere(to parent: any RealityViewContentProtocol) -> ModelEntity {
    let sphere = ModelEntity(
      mesh: .generateSphere(radius: 0.05),
      materials: [SimpleMaterial(color: .black, roughness: 0.5, isMetallic: true)])
    parent.add(sphere)
    return sphere
  }

  func add_blue_sphere(to parent: any RealityViewContentProtocol) -> ModelEntity {
    let sphere = ModelEntity(
      mesh: .generateSphere(radius: 1.00),
      materials: [SimpleMaterial(color: .blue, roughness: 0.5, isMetallic: true)])
    sphere.name = "BlueSphere"
    parent.add(sphere)
    return sphere
  }
}

#Preview(immersionStyle: .mixed) {
  ImmersiveView(gestureModel: HandGestureModelContainer.handGestureModel)
    .environment(AppModel())
}
