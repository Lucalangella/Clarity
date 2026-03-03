# Clarity: Your Prescription, Decoded

Clarity is an educational and practical iOS application designed to demystify eyeglass prescriptions. By translating complex optical numbers into interactive visualizations, Clarity empowers users to understand their vision needs, accurately measure their Pupillary Distance (PD) using Augmented Reality, and find the perfect frames based on clinical optical rules.

---

## Key Features

### 1. Interactive Prescription Translation
Forget confusing paper cards. Clarity features highly tactile, custom-built controls to input your prescription:
* **Sphere (SPH) & Cylinder (CYL):** Intuitive, sliding ruler scales (`VisualRulerScaleView`) that smoothly snap to 0.25 diopter increments.
* **Axis:** An interactive Tabo protractor (`ProtractorView`) that lets you physically drag a needle to set the exact cylinder axis for both the Right (OD) and Left (OS) eye.

### 2. AR Pupillary Distance (PD) Scanner
Leveraging ARKit and the TrueDepth camera, Clarity includes a highly accurate, guided face scanner to measure the distance between your pupils in millimeters. 
* Guides the user through a focus-and-follow routine to capture median PD.
* Calculates distance accurately using real-world eyeball radius estimations.

### 3. Dynamic Lens Thickness Visualization
Wondering why your lenses are thick at the edges or heavy in the middle? 
* Clarity dynamically draws a cross-section of your lens (`LensCrossSectionShape`) based on your spherical equivalent (SE).
* Toggle between different lens indices (Polycarbonate 1.59, High-Index 1.67, and Ultra High-Index 1.74) to instantly see how the material affects thickness and weight.

### 4. Smart Frame Recommendations
Not all frames work for all prescriptions. Clarity uses built-in clinical optical rules to recommend the best frames for your specific needs:
* **High Rx / Very High Rx:** Excludes large shapes (like Aviators) to minimize edge thickness.
* **PD Extremes:** Filters frames to prevent unwanted prism and eye strain.
* **Astigmatism & Anisometropia:** Retains stable, full-rim frames to hide thickness variations and axis tilt.

### 5. 3D Viewer & AR Virtual Try-On
* **3D Preview:** Inspect recommended frames (like Browline, Cat-eye, Geometric) in a 360-degree SceneKit viewer.
* **AR Try-On:** Jump into a live RealityKit AR view to see the glasses tracked to your face in real-time. Includes fine-tuning sliders for size, height, and depth to get the perfect virtual fit.

---

## Tech Stack & Architecture

This project is built as a **Swift Playgrounds App Package** (`.swiftpm`) using modern iOS frameworks:

* **SwiftUI:** The entire UI is built declaratively, heavily utilizing custom layouts, gestures (`DragGesture`), and geometry readers for responsive controls.
* **ARKit:** Powers the `ARFaceTrackingConfiguration` used in both the PD Scanner and the AR Try-On engine.
* **RealityKit & SceneKit:** Used for rendering the 3D `.usdz` frame models and applying physically-based materials (like transparent glass for lenses).
* **Swift 6 / Observation Framework:** Uses `@Observable` macros for clean, reactive state management across view models.

---

## Getting Started

### Requirements
* **OS:** iOS 18.0 or later.
* **Hardware:** An iPhone or iPad with a TrueDepth camera (FaceID) is required for the AR PD Scanner and AR Virtual Try-On features.
* **Environment:** Swift Playgrounds 4+ or Xcode 16+.

### Installation
1. Clone the repository or download the `.swiftpm` folder.
2. Double-click `Clarity.swiftpm` to open it in **Xcode**, or open it directly in the **Swift Playgrounds** app on your iPad or Mac.
3. Build and run the app on a physical device (AR features will not work fully in the simulator).
4. *Note: Ensure you grant camera permissions on launch, or the AR functionality will be disabled.*

---

## Project Structure

* **Models:** Core data structures (`Prescription`, `EyeData`, `OpticalRule`) housing the clinical logic for frame filtering and SE calculation.
* **ViewModels:** Main actors (`ContentViewModel`, `FaceScannerViewModel`) driving the UI state, onboarding walkthroughs, and AR processing.
* **Views/CustomControls:** Reusable, highly customized interactive UI elements like the `VisualRulerScaleView` and `ProtractorView`.
* **Views/ARFeatures:** The ARKit integrations, including the custom face tracking engine and the biometric scaling logic.
* **Utilities:** Math helpers like the `PDCalculator`.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details. Copyright (c) 2026 Lucalangella.
