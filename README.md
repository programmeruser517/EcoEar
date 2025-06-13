# EcoEar

<img src="./ecoear/assets/images/banner_curved.png" alt="EcoEar Logo" width="50%" />

EcoEar is a Flutter-based mobile application and Chrome extension designed to detect wildlife calls through a phone's microphone and share detection data with nearby users. The project integrates Firebase for authentication, storage, and messaging, and provides a schedule for building the app, extension, and data processing pipeline.

## Project Setup

1. Install the Flutter SDK along with Android Studio and Xcode command-line tools.
2. Verify your environment:
   ```bash
   flutter doctor
   ```
3. Create the Flutter project and basic folder structure:
   ```bash
   flutter create ecoear
   cd ecoear
   mkdir -p lib/services lib/widgets lib/views lib/models
   ```
4. Configure Firebase for Android and iOS, then download and place the `google-services.json` and `GoogleService-Info.plist` files in their respective folders.
5. Add dependencies:
   ```bash
   flutter pub add firebase_core firebase_auth cloud_firestore firebase_messaging
   ```

## Development Phases

### Phase 0: Foundation & Architecture (May 30 – June 2, 2025)
- Ensure the Flutter environment is fully configured for iOS and Android.
- Initialize a GitHub repository and set up CI workflows for building artifacts.
- Create the project architecture, including service layers and Firebase hooks.
- Design brand assets such as the app icon and splash screen.

### Phase 1: UI Shell & Styling (June 3 – June 9, 2025)
- Build a `NotificationBanner` widget with dynamic styles and transitions.
- Implement the home page layout with a waveform visualization using `Stack` and `Positioned` widgets.
- Add a theme manager for light and dark modes, persisting preferences with `shared_preferences`.
- Create a settings modal for user feedback and streak statistics.

### Phase 2: Core Feature Development (June 10 – June 16, 2025)
- Capture audio using `flutter_audio_capture` and analyze frequency data with a Fast Fourier Transform (FFT).
- Detect target frequency bands and log detections to Firestore.
- Track user streaks and provide feedback through badge animations or sounds.
- Implement a `SessionLogger` to save time, location, and device information.

### Phase 3: Community Signals & Chrome Extension (June 17 – June 24, 2025)
- Create a Firebase Cloud Function to monitor multiple detections within the same zone and send alerts via Firebase Messaging.
- Display active alert zones on a heatmap overlay in the app.
- Build a Chrome extension that injects indicators into Google Maps, flagging eco-sensitive route segments and suggesting alternatives.

### Phase 4: Final App and Extension Launch (June 25 – July 1, 2025)
- Refine layout spacing and handle microphone startup errors.
- Test background operation on both Android and iOS.
- Deploy builds to TestFlight and Google Play for internal testing.
- Announce the launch via university mailing lists and social channels.

### Phase 5: Data Collection & Visualization (July 2 – July 14, 2025)
- Track detections by time and zone in Firestore.
- Export logs using Python and the Firebase Admin SDK.
- Perform statistical analysis with pandas and SciPy, generating heatmaps and activity histograms.

## Building the App

To run the application on a connected device or emulator:
```bash
flutter run
```
For a production build:
```bash
flutter build apk --release      # Android
flutter build ios --release      # iOS
```

## Chrome Extension

The accompanying Chrome extension enhances Google Maps with eco-sensitivity alerts. After building the extension, load the unpacked directory in Chrome's extensions page and test it alongside the mobile app's Firebase data.

## Repository Contents

- `EcoEarSwiftProtoBackup.zip` – early Swift prototype and asset archive.
- `README.md` – project overview and setup instructions.

## Contributing

Contributions are welcome! Please submit pull requests with clear explanations of changes. For major features, open an issue first to discuss your ideas.

## License

This project is provided under the MIT License. See the `LICENSE` file for details.
