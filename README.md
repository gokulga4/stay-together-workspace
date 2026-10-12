# StayTogether extracted app assets

This repository contains extracted Android app assets, not the original app source or APK build project.

## Firebase configuration

1. Copy `.env.example` to `.env`.
2. Replace the placeholders with the Firebase web app settings from your own Firebase project. The API key setting is named `VITE_FIREBASE_KEY`.
3. In PowerShell, run `.\configure-firebase.ps1`.

The script writes `assets\public\firebase-config.js`, which is ignored by Git and loaded by the web app and messaging service worker. Do not commit that generated file or `.env`. Firebase web API keys are visible to clients; restrict them in Google Cloud and configure Firebase security rules.

These extracted assets do not include the original app source or build system, so this setup does not rebuild the Android APK.
