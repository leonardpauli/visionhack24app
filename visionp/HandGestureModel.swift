import ARKit
import SwiftUI

@MainActor
class HandGestureModel: ObservableObject, @unchecked Sendable {
  let session = ARKitSession()
  var handTracking = HandTrackingProvider()
  @Published var latestHandTracking: HandsUpdates = .init(left: nil, right: nil)

  struct HandsUpdates {
    var left: HandAnchor?
    var right: HandAnchor?
  }

  func start() async {
    do {
      if HandTrackingProvider.isSupported {
        print("ARKitSession.starting")
        try await session.run([handTracking])
      }
    } catch {
      print("ARKitSession.error ", error)
    }
  }

  func publishHandTrackingUpdates() async {
    for await update in handTracking.anchorUpdates {
      let anchor = update.anchor
      guard case AnchorUpdate<HandAnchor>.Event.updated = update.event, anchor.isTracked else {
        continue
      }

      if anchor.chirality == .left {
        latestHandTracking.left = anchor
      } else if anchor.chirality == .right {
        latestHandTracking.right = anchor
      }

      // printIndexFingerTipPosition(for: anchor)
    }
  }

  func monitorSessionEvents() async {
    for await event in session.events {
      switch event {
      case .authorizationChanged(let type, let status):
        if type == .handTracking && status != .allowed {
          // todo: stop the game, ask user to re-grant hand tracking authorization in settings
        }
      default:
        print("handtracker.session_event \(event)")
      }
    }
  }

  func computeIndexFingerTipPositionGlobal(for anchor: HandAnchor?) -> SIMD3<Float>? {
    guard let anchor = anchor, let indexFingerTip = anchor.handSkeleton?.joint(.indexFingerTip),
      indexFingerTip.isTracked
    else { return nil }

    let indexFingerTipTransform = matrix_multiply(
      anchor.originFromAnchorTransform,
      indexFingerTip.anchorFromJointTransform
    )
    let globalPosition = indexFingerTipTransform.columns.3.xyz

    return globalPosition

  }

  private func printIndexFingerTipPosition(for anchor: HandAnchor) {
    guard let globalPosition = computeIndexFingerTipPositionGlobal(for: anchor) else { return }
    print("handtracker.\(anchor.chirality).index_finger_tip.position.global: \(globalPosition)")
  }
}
