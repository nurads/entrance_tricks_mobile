# Deep Linking Setup Guide

Deep linking has been configured for both iOS and Android. This document outlines what has been set up and what additional steps may be required.

## What Has Been Configured

### ✅ Android

- Added deep link intent filters in `AndroidManifest.xml`
- Supports both HTTPS App Links and custom URL scheme (`vectoracademy://`)
- Configured for domains: `vectoracademy.app` and `www.vectoracademy.app`

### ✅ iOS

- Added custom URL scheme (`vectoracademy://`) in `Info.plist`
- Created entitlements file for Associated Domains
- Configured for domains: `vectoracademy.app` and `www.vectoracademy.app`

### ✅ Flutter Code

- Added `app_links` package dependency
- Created `DeepLinkService` to handle incoming deep links
- Integrated deep link handling in `main.dart`
- Supports navigation to all major routes with parameters

## Additional Setup Required

### iOS Universal Links (Optional but Recommended)

For Universal Links to work on iOS, you need to:

1. **Add Entitlements File to Xcode Project:**

   - Open `ios/Runner.xcworkspace` in Xcode
   - Select the Runner target
   - Go to "Signing & Capabilities"
   - Add "Associated Domains" capability
   - Add domains: `applinks:vectoracademy.app` and `applinks:www.vectoracademy.app`
   - Or manually add the `Runner.entitlements` file to the project

2. **Create Apple App Site Association File:**
   - Host a file at: `https://vectoracademy.app/.well-known/apple-app-site-association`
   - The file should be served with `Content-Type: application/json` (no `.json` extension)
   - Example content:
   ```json
   {
     "applinks": {
       "apps": [],
       "details": [
         {
           "appID": "TEAM_ID.com.vector_academy.app",
           "paths": ["*"]
         }
       ]
     }
   }
   ```
   - Replace `TEAM_ID` with your Apple Developer Team ID

### Android App Links (Optional but Recommended)

For App Links to work on Android, you need to:

1. **Create Digital Asset Links File:**

   - Host a file at: `https://vectoracademy.app/.well-known/assetlinks.json`
   - Example content:

   ```json
   [
     {
       "relation": ["delegate_permission/common.handle_all_urls"],
       "target": {
         "namespace": "android_app",
         "package_name": "com.vector_academy.app",
         "sha256_cert_fingerprints": ["YOUR_SHA256_FINGERPRINT"]
       }
     }
   ]
   ```

   - Get your SHA256 fingerprint using:
     ```bash
     keytool -list -v -keystore your-keystore.jks -alias your-alias
     ```

2. **Update Domain in Configuration:**
   - Replace `vectoracademy.app` with your actual domain in:
     - `android/app/src/main/AndroidManifest.xml`
     - `ios/Runner/Runner.entitlements`
     - `ios/Runner/Info.plist` (if using Universal Links)

## Supported Deep Link Patterns

### Custom URL Scheme

- `vectoracademy://home`
- `vectoracademy://subjects`
- `vectoracademy://subject?id=123`
- `vectoracademy://chapter?id=456`
- `vectoracademy://exam?id=789`

### HTTPS Links (when App Links/Universal Links are configured)

- `https://vectoracademy.app/home`
- `https://vectoracademy.app/subjects`
- `https://vectoracademy.app/subject?id=123`
- `https://vectoracademy.app/chapter?id=456`
- `https://vectoracademy.app/exam?id=789`

### Supported Routes

- `/home` - Home page
- `/login` - Login page
- `/register` - Registration page
- `/subjects` - Subjects list
- `/subject?id={id}` or `/subject/{id}` - Subject detail
- `/chapter?id={id}` or `/chapter/{id}` - Chapter detail
- `/exam?id={id}` or `/exam/{id}` - Exam detail
- `/downloads` - Downloads page
- `/support` - Support page
- `/about` - About page
- `/faq` - FAQ page
- `/edit-profile` - Edit profile page
- `/video-player?url={url}&title={title}&id={id}` - Video player
- `/pdf-reader?url={url}&title={title}&id={id}` - PDF reader

## Testing

### Android

1. Test custom scheme:

   ```bash
   adb shell am start -W -a android.intent.action.VIEW -d "vectoracademy://home" com.vector_academy.app
   ```

2. Test App Link (requires server setup):
   ```bash
   adb shell am start -W -a android.intent.action.VIEW -d "https://vectoracademy.app/home" com.vector_academy.app
   ```

### iOS

1. Test custom scheme:

   - Open Safari and type: `vectoracademy://home`
   - Or use Xcode console: `xcrun simctl openurl booted "vectoracademy://home"`

2. Test Universal Link (requires server setup):
   - Send yourself a link via Messages or Notes
   - Tap the link to open the app

## Notes

- Custom URL schemes work immediately without server configuration
- App Links (Android) and Universal Links (iOS) require server-side configuration
- The deep link service automatically handles authentication - unauthenticated users are redirected to login
- All deep links are logged for debugging purposes
