//
//  ARFaceTrackingEngine.swift
//  Glasses
//

import SwiftUI
import ARKit

struct ARFaceTrackingEngine: UIViewRepresentable {
    var viewModel: FaceScannerViewModel

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        arView.delegate = context.coordinator
        arView.session.delegate = context.coordinator
        arView.backgroundColor = .clear

        guard ARFaceTrackingConfiguration.isSupported else { return arView }

        let config = ARFaceTrackingConfiguration()
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])

        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        context.coordinator.showMesh = (viewModel.state == .processing)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
        var parent: ARFaceTrackingEngine
        var faceNode: SCNNode?

        var showMesh: Bool = false {
            didSet {
                faceNode?.isHidden = !showMesh
            }
        }

        init(_ parent: ARFaceTrackingEngine) {
            self.parent = parent
        }

        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            guard let device = renderer.device, anchor is ARFaceAnchor else { return nil }

            let faceGeometry = ARSCNFaceGeometry(device: device)
            let node = SCNNode(geometry: faceGeometry)

            node.geometry?.firstMaterial?.fillMode = .lines
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.8)
            node.isHidden = true

            self.faceNode = node
            return node
        }

        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let faceAnchor = anchor as? ARFaceAnchor,
                  let faceGeometry = node.geometry as? ARSCNFaceGeometry else { return }
            faceGeometry.update(from: faceAnchor.geometry)
        }

        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            // 1. Extract the face anchor from the background thread update
            guard let faceAnchor = anchors.compactMap({ $0 as? ARFaceAnchor }).first else { return }

            // 2. Explicitly capture the viewModel reference.
            // Since the ViewModel is @MainActor, it is safe to 'send' to a MainActor Task.
            let viewModel = self.parent.viewModel

            Task { @MainActor in
                // 3. Call the processing logic on the Main Actor
                viewModel.processFaceAnchor(faceAnchor)
            }
        }
    }
}
