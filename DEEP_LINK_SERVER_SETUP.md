# Deep Link Server Setup Guide

This guide explains how to set up the server-side files required for Android App Links and iOS Universal Links to work properly.

## Files Required

1. **assetlinks.json** - For Android App Links
2. **apple-app-site-association** - For iOS Universal Links

## Android App Links Setup

### 1. Get Your SHA256 Certificate Fingerprint

You need to get the SHA256 fingerprint of your app's signing certificate.

#### For Debug Build:

```bash
# On Windows (PowerShell)
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

# On macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

#### For Release Build:

```bash
# Replace with your actual keystore path and alias
keytool -list -v -keystore path/to/your/keystore.jks -alias your-alias-name
```

Look for the **SHA256** fingerprint in the output. It will look like:

```
SHA256: AA:BB:CC:DD:EE:FF:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:11:22:33:44:55:66:77:88:99:AA:BB
```

### 2. Update assetlinks.json

1. Open the `assetlinks.json` file
2. Replace `YOUR_SHA256_FINGERPRINT_HERE` with your actual SHA256 fingerprint (remove colons)
3. If you have multiple signing keys (debug and release), add both fingerprints:

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.vector_academy.app",
      "sha256_cert_fingerprints": [
        "DEBUG_SHA256_FINGERPRINT",
        "RELEASE_SHA256_FINGERPRINT"
      ]
    }
  }
]
```

### 3. Host the File

Upload `assetlinks.json` to your server at:

```
https://entrancetricks.com/.well-known/assetlinks.json
```

**Important Requirements:**

- Must be served over HTTPS
- Must be accessible without authentication
- Content-Type must be `application/json`
- Must be at the exact path: `/.well-known/assetlinks.json`

### 4. Verify the Setup

Test that the file is accessible:

```bash
curl https://entrancetricks.com/.well-known/assetlinks.json
```

Verify with Google's tool:

```
https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://entrancetricks.com&relation=delegate_permission/common.handle_all_urls
```

## iOS Universal Links Setup

### 1. Get Your Apple Developer Team ID

1. Go to [Apple Developer Portal](https://developer.apple.com/account)
2. Navigate to Membership section
3. Find your **Team ID** (it's a 10-character string like `ABC123DEF4`)

### 2. Update apple-app-site-association

1. Open the `apple-app-site-association` file
2. Replace `TEAM_ID` with your actual Team ID
3. The final format should be: `ABC123DEF4.com.vector_academy.app`

### 3. Host the File

Upload `apple-app-site-association` to your server at:

```
https://entrancetricks.com/.well-known/apple-app-site-association
```

**Important Requirements:**

- Must be served over HTTPS
- Must be accessible without authentication
- Content-Type must be `application/json` (NOT `text/plain`)
- Must NOT have a file extension (no `.json`)
- Must be at the exact path: `/.well-known/apple-app-site-association`

### 4. Server Configuration

Make sure your web server is configured to:

- Serve the file with `Content-Type: application/json`
- Allow access without authentication
- Support HTTPS

#### Example Nginx Configuration:

```nginx
location /.well-known/apple-app-site-association {
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
}

location /.well-known/assetlinks.json {
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
}
```

#### Example Apache Configuration (.htaccess):

```apache
<Files "apple-app-site-association">
    Header set Content-Type "application/json"
</Files>

<Files "assetlinks.json">
    Header set Content-Type "application/json"
</Files>
```

### 5. Verify the Setup

Test that the file is accessible:

```bash
curl https://entrancetricks.com/.well-known/apple-app-site-association
```

The response should show your JSON content with `Content-Type: application/json`.

## Testing Deep Links

### Android Testing

1. **Test App Link:**

   ```bash
   adb shell am start -W -a android.intent.action.VIEW -d "https://entrancetricks.com/news-detail?id=123" com.vector_academy.app
   ```

2. **Verify App Link Association:**
   ```bash
   adb shell pm get-app-links com.vector_academy.app
   ```

### iOS Testing

1. **Test Universal Link:**

   - Send yourself a link via Messages or Notes
   - Tap the link - it should open in the app
   - Or use Xcode console:
     ```bash
     xcrun simctl openurl booted "https://entrancetricks.com/news-detail?id=123"
     ```

2. **Verify Associated Domains:**
   - Make sure the entitlements file is properly configured in Xcode
   - Check that Associated Domains capability is enabled

## Troubleshooting

### Android Issues

- **App Links not working:**

  - Verify the SHA256 fingerprint matches exactly (no colons)
  - Ensure the file is accessible over HTTPS
  - Check that `android:autoVerify="true"` is in AndroidManifest.xml
  - Clear app data and reinstall the app

- **Verification failed:**
  - Use Google's Digital Asset Links API to verify
  - Check server logs for requests from Google's verification service

### iOS Issues

- **Universal Links not working:**

  - Verify the file has no `.json` extension
  - Ensure Content-Type is `application/json`
  - Check that Associated Domains are configured in Xcode
  - Delete and reinstall the app (iOS caches the association)

- **File not found:**
  - Verify the file is at the exact path
  - Check server configuration for `.well-known` directory
  - Ensure HTTPS is properly configured

## Notes

- Both files must be updated whenever you change your signing certificates
- For production, use your release certificate fingerprint
- For development, you may want to include both debug and release fingerprints
- The files are cached by the OS, so changes may take time to propagate
- Always test on a real device, not just emulators/simulators
