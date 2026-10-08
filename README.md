# Homework 01 Calculator Studio

Myles Miller · 002753776 · Undergraduate pathway

Calculator Studio is a Flutter two-operand calculator with digits 0–9, addition, subtraction, multiplication, division, a readable display, and a responsive button grid. I selected exactly three undergraduate enhancements: light/dark theme toggle, All Clear, and error handling for division by zero and incomplete expressions.

## Run and build

From this project directory, run `flutter pub get`, `flutter run`, `flutter analyze`, `flutter test`, and `flutter build apk --release`. The Android package is `edu.gsu.myles.calculator_app`; the generated release build is `build/app/outputs/flutter-apk/app-release.apk`. There are no extra runtime packages.

## Design

`lib/calculator_engine.dart` owns current display text, the first operand, pending operator, transition flags, and an optional error message. The Flutter screen renders that state and dispatches key presses to the engine. It does not store a second result string, which avoids display/result drift. Theme mode is owned by the app widget because the MaterialApp needs it. All Clear resets the entire calculation, including error and pending operator. Numeric output may contain a fractional result (for example 7 ÷ 2 = 3.5), but this undergraduate app has no decimal-input key.

## Checks

`flutter analyze` reported no issues, and `flutter test` passed four engine test groups covering the four operators and negative result, division by zero/incomplete input and recovery, a fractional output, and repeated-operator/result transitions. I installed the **release APK** on a Pixel 7 Pro Android 17 emulator. Manual UI checks showed `8 + 7 = 15`, then `× 2 = 30`; the theme button changed its label from “Switch to dark theme” to “Switch to light theme”; and `AC, 8 ÷ 0 =` showed “Cannot divide by zero. Tap AC or enter a new number.” The last state is pictured in `evidence/dark_divide_by_zero.png`.

The UI has descriptive semantics labels for buttons and error text. I did not perform a live TalkBack or large-font device test, so those remain validation work. Very long input is capped at 12 digits; the cap currently gives no explicit message.

## Attribution

OpenAI Codex assisted with code and documentation. Gemini and ChatGPT were used for the two assignment review prompts; their suggestions were checked against the engine tests and release UI, as described in the separate implementation document. Assignment reference: [Homework 01 Calculator Studio](https://codd.cs.gsu.edu/~lhenry23/mad/hw/hw01/index.html).

