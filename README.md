# J’Donuts — MADivizion Flutter code test

## 1. How to run the app

Install Flutter with the SDK version below. For Android, set up the Android SDK and start an emulator or connect an Android device. For iOS, use macOS with Xcode and CocoaPods, then start an iPhone Simulator. [Android setup](https://docs.flutter.dev/platform-integration/android/setup) · [iOS setup](https://docs.flutter.dev/platform-integration/ios/setup)

From the repository root, check your toolchain, fetch dependencies, and list your devices.

```bash
flutter doctor
flutter pub get
flutter devices
```

Start the app in debug mode. Replace `DEVICE_ID` with an ID from `flutter devices`.

```bash
flutter run -d DEVICE_ID
```

On the first launch, tap **Let’s Get Started** to register. The app uses the demo OTP in section 7. The catalog is seeded from bundled assets, so the Home, Product Detail, and Rewards screens can be explored offline after setup.

Run static analysis and the unit and widget tests from the repository root.

```bash
flutter analyze
flutter test
```

Run the registration-to-product integration test on a connected device or simulator.

```bash
flutter test -d DEVICE_ID integration_test/registration_to_product_test.dart
```

## 2. Flutter and Dart versions

- **Flutter** 3.44.9 (stable channel)
- **Dart** 3.12.2 (bundled with Flutter)

I developed and tested the app with this stable SDK version. Using the same version for the submission makes it easier to reproduce the build with the toolchain and plugin versions I tested.

## 3. Architecture and folder map

The app is organized by feature. Auth, Home, Product, and Rewards each have three layers.

- **Presentation** contains screens, widgets, and Riverpod providers that expose state to the UI.
- **Domain** defines the data types, validation rules, and repository interfaces in plain Dart.
- **Data** implements those interfaces. The catalog repositories read from Drift and map database rows to domain types. The fake auth repository uses secure storage.

For example, Product Detail receives a product ID and watches its Riverpod provider. The provider asks `ProductRepository` for that product, and `DriftProductRepository` reads it from SQLite. The app wires the catalog repositories to one shared database in `lib/app/data/catalog_providers.dart`.

```text
lib/
  app/        Routing, theme, motion settings, shared catalog database and connectivity
  auth/       Onboarding, login, registration, and session handling
  home/       Member header, banners, product sections, and nearby shops
  product/    Product detail and quantity controls
  rewards/    Points, tiers, challenges, and Rewards animations
  settings/   Settings screen and sign-out action
  core/       Shared types and reusable widgets
  l10n/       Localized app strings
assets/       Bundled catalog data and images
test/         Unit and widget tests
integration_test/  Register → Home → Product Detail flow
```

## 4. State management and rationale

I chose Riverpod because I’m comfortable with it and it keeps dependency injection and shared state in one place. For a solo project of this size, it gave me a straightforward way to wire repositories, manage subscriptions, and override dependencies in tests.

I use `StreamProvider` for data that changes over time, such as the catalog and product details, and a `Notifier` for OTP verification, attempts, and resend state. Providers marked `autoDispose` clean up when their listeners are gone. State that belongs to one widget, such as product quantity or an animation controller, stays in that widget.

## 5. Offline data strategy

For a food-ordering app, I would use offline storage to keep browsing available. In production, the server would own prices, offers, and rewards. The app would show the last saved catalog when offline, and checkout would confirm current prices and availability with the server.

- **Local data.** On the first catalog read, the app seeds Drift/SQLite from `assets/data/catalog_seed.json`. Home, Product Detail, and Rewards watch the database, so they can render offline from the first run. An offline banner tells users when they’re seeing saved content.
- **Connectivity and refresh.** `connectivity_plus` detects network changes. A separate HTTPS request checks internet reachability, since joining Wi-Fi alone doesn’t guarantee access. Home refreshes on its first online check, when connectivity returns, and on pull-to-refresh while online. I used the bundled `catalog_refresh.json` file as a simulated server response. The app applies it by changing the Coconut Donut discount from 10% to 15% in SQLite. The screens see the update through their existing queries, and a failed refresh leaves the saved catalog available.
- **Image caching.** Coconut Donut has one remote image URL to demonstrate disk caching with `cached_network_image`. Opening it online lets the app cache the image for a later offline visit. If the remote image is unavailable and there’s no cached copy, the app falls back to the bundled PNG. The rest of the catalog images are bundled.

## 6. Animations

- **Onboarding and Welcome.** Onboarding brings in the artwork, title, and actions in sequence. On Welcome, the donut tiles slide in one by one, followed by the title fading up.
- **Registration and login.** The progress ring fills and becomes a check mark at completion. The OTP boxes animate on focus and shake after an incorrect code. The shared primary button scales on press and switches to a loading indicator while a request runs.
- **Home and Product Detail.** Home shows a skeleton shimmer while data loads, then staggers the entrance of Seasonal Specials, Popular, and Order Again. The banner carousel advances automatically. On Product Detail, the quantity number fades when it changes.
- **Rewards.** The points ring sweeps as the number counts up. The tiers appear in order and the connector fills toward the next tier. The badge pops in, challenge cards enter one by one, and their progress animates through the donut’s color reveal or the coffee arc. The completed challenge’s **Earn** button pulses. The Rewards tabs use a sliding pill and a content crossfade.
- **Bottom navigation.** The active pink pill slides between Home, Rewards, and Settings.

I used Flutter’s built-in animation widgets and `CustomPainter` for the progress artwork. Timings and curves live in `AppMotion`. The animations use `MediaQuery.disableAnimationsOf()` to reduce or skip motion when requested by the device.

## 7. Fake OTP

Enter **`123456`** when prompted for the verification code during registration or login. The app verifies this demo code locally.

## 8. Known gaps and time spent

- **OTP resend and lockout.** The five-minute countdown already uses a deadline based on the device clock. The deadline and failed attempts are held in memory, so reopening the OTP flow after its state is disposed starts a fresh countdown and clears the lockout. Persisting the deadline and attempt count locally would carry them across a relaunch. In production, I would have the server enforce resend and attempt limits and tell the app when the user can retry.
- **Demo authentication.** The fake OTP controls whether the UI advances. Account creation receives no proof that the phone number was verified. In production, I would have the backend issue a short-lived, single-use token after verifying the OTP and bind it to the phone number and registration purpose. The app would submit it with the name and date of birth, and the backend would validate and consume it when creating the account. For returning users, the backend could issue a session directly after verifying the OTP.
- I prioritized offline browsing, catalog refresh, and Rewards motion, and deferred the product image Hero transition from Home to Product Detail.
- **Performance.** The 60 fps target in profile mode on a mid-range Android phone remains unverified.

**Time spent** — Approximately 24 hours.
