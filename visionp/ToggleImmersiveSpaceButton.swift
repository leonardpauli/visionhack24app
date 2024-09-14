//
//  ToggleImmersiveSpaceButton.swift
//  visionp
//
//  Created by Leonard Pauli on 2024-09-14.
//

import SwiftUI

struct ToggleImmersiveSpaceButton: View {

    @Environment(AppModel.self) private var appModel

    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    var body: some View {
        Button {
            Task { @MainActor in
                switch appModel.immersiveSpaceState {
                    case .open:
                        appModel.immersiveSpaceState = .inTransition
                        await dismissImmersiveSpace()
                        // see ImmersiveView.onDisappear()
                    case .closed:
                        appModel.immersiveSpaceState = .inTransition
                        switch await openImmersiveSpace(id: appModel.immersiveSpaceID) {
                            case .opened:
                                // see ImmersiveView.onAppear()
                                break

                            case .userCancelled, .error:
                                fallthrough
                            @unknown default:
                                // assume space did not open.
                                appModel.immersiveSpaceState = .closed
                        }

                    case .inTransition:
                        // unreachable (button should be disabled)
                        break
                }
            }
        } label: {
            Text(appModel.immersiveSpaceState == .open ? "End Immersive Space" : "Enter Immersive Space")
        }
        .disabled(appModel.immersiveSpaceState == .inTransition)
        .animation(.none, value: 0)
        .fontWeight(.semibold)
    }
}
