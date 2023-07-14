## Commands

* `flutter create <app> --empty`
* `dart run build_runner watch --delete-conflicting-outputs`

## IDE plugins and configs
**Android Studio**
- Set timing to 0 in `Settings > Editor > General > Code Completion`
- Install the following extensions: `IdeaVim`, `Flutter Pub Version Checker`, `Flutter Snippets`, `FlutterAssetAutoCompletion`
Alt+` Terminal
Alt+1 Run
Alt+2 Message
Alt+3 Dart Analysis
Alt+4 Project
Alt+5 Flutter Performance
Alt+6 Device File Explorer
Alt+L Logcat
Alt+B Bookmark
Alt+S Structure
**VSCode**


## Framework Dependencies

Tools | Dependencies
:- | -
Flutter for android | AGP
AGP | Gradle
Gradle | JDK

> **Note**
> 1. AGP, Gradle are automatically downloaded based on config file
> 2. JDK is embeded with Android Studio and Kotlin is embeded with Gradle
> 3. Beware of compatibility issues
> * AGP compatibility: https://developer.android.com/build/releases/gradle-plugin
> * Gradle compatibility: https://docs.gradle.org/current/userguide/compatibility.html

## Diagnostic
**Config checks**

**Native code reset**

## Integration
**Localization**
1. Install `Flutter Intl` plugin (Android Studio)
2. Run `Tools > Flutter Intl > Initialize`


## Upgrade project

1. Flutter
  * Check changelog: https://github.com/flutter/flutter/wiki/Hotfixes-to-the-Stable-Channel
2. AGP, Gradle, and Kotlin:

  * Option 1: Use AGP Upgrade Assistant
    1. Open `Project root/android` in Android Studio
    2. Run `Tools > AGP Upgrade Assistant`
    3. Follow instructions
  * Option 2: Use Project Structure settings
    1. Open `Project root/android` in Android Studio
    2. Run `File > Project Structure`
    3. Edit AGP and Gradle variables
    > **Warning**: This approach can break project because of compatibility issues, syntax changes, or compatibility requirements of Gradle


