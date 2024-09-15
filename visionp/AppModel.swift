//
//  AppModel.swift
//  visionp
//
//  Created by Leonard Pauli on 2024-09-14.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
  let immersiveSpaceID = "ImmersiveSpace"
  enum ImmersiveSpaceState {
    case closed
    case inTransition
    case open
  }
  var immersiveSpaceState = ImmersiveSpaceState.closed
  
  // New properties for the blue sphere
  var sphereX: Float = 0.0
  var sphereY: Float = 0.0
  var sphereZ: Float = 0.0
  var sphereRadius: Float = 0.05
}
