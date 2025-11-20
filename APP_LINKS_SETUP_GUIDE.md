# App Links Setup Guide for entrancetricks.com

## Current Status ✅
The app now works with deeplinks in both debug and release builds. However, without `android:autoVerify="true"`, users will see a disambiguation dialog when clicking links.

## Problem Explanation

### Why it worked in debug but not release:
- **Debug builds**: Android is lenient and doesn't strictly enforce App Links verification
- **Release builds**: Android strictly verifies Digital Asset Links; if verification fails, it opens the Play Store instead

### The Solution
To make links open directly in your app without a dialog, you need to set up **Android App Links** properly with Digital Asset Links verification.

---

## Complete Setup Steps

### Step 1: Get Your SHA256 Fingerprint

#### Option A: From Google Play Console (RECOMMENDED)
1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Navigate to: **Release** → **Setup** → **App Integrity** → **App signing**
4. Find "SHA-256 certificate fingerprint" under "App signing key certificate"
5. Copy it (format: `AA:BB:CC:DD:EE:...`)
6. **Remove all colons** from the fingerprint (you'll need this for the JSON file)

#### Option B: From Local Keystore (if you have the keystore file)
```bash
keytool -list -v -keystore path/to/your-release-key.jks -alias your-key-alias
```
- Enter your keystore password when prompted
- Look for "SHA256:" in the output
- Copy the fingerprint and remove all colons

### Step 2: Update assetlinks.json

1. Open the `assetlinks.json` file in your project root
2. Replace `PASTE_YOUR_SHA256_HERE_WITHOUT_COLONS` with your actual SHA256 fingerprint (without colons)

Example:
```json
[
    {
        "relation": [
            "delegate_permission/common.handle_all_urls"
        ],
        "target": {
            "namespace": "android_app",
            "package_name": "com.vector_academy.app",
            "sha256_cert_fingerprints": [
                "14F2D6B3C8A9E5F1D3C7B8A2E4F6D1C3B5A7E9F2D4C6B8A1E3F5D7C9B2A4E6F8"
            ]
        }
    }
]
```

### Step 3: Host the assetlinks.json File

You must host this file at **BOTH** of these URLs:
- `https://entrancetricks.com/.well-known/assetlinks.json`
- `https://www.entrancetricks.com/.well-known/assetlinks.json`

#### Hosting Requirements:
- ✅ Must be served over **HTTPS** (not HTTP)
- ✅ Must return `Content-Type: application/json` header
- ✅ Must be **publicly accessible** (no authentication required)
- ✅ Must **not redirect** to another URL
- ✅ Must be at the **exact path**: `/.well-known/assetlinks.json`

#### How to Host (depends on your server):

**For Apache (.htaccess in /.well-known/ directory):**
```apache
<Files "assetlinks.json">
    Header set Content-Type "application/json"
</Files>
```

**For Nginx (in your server config):**
```nginx
location /.well-known/assetlinks.json {
    default_type application/json;
}
```

**For Node.js/Express:**
```javascript
app.get('/.well-known/assetlinks.json', (req, res) => {
    res.setHeader('Content-Type', 'application/json');
    res.sendFile('/path/to/assetlinks.json');
});
```

### Step 4: Verify the File is Accessible

Test that your file is properly hosted:
```bash
curl -I https://entrancetricks.com/.well-known/assetlinks.json
curl -I https://www.entrancetricks.com/.well-known/assetlinks.json
```

You should see:
- HTTP status: `200 OK`
- Content-Type: `application/json`

### Step 5: Verify with Google's Tool

Use Google's Statement List Generator and Tester:
https://developers.google.com/digital-asset-links/tools/generator

1. Enter your domain: `entrancetricks.com`
2. Enter package name: `com.vector_academy.app`
3. Enter your SHA256 fingerprint
4. Click "Generate Statement"
5. Click "Test Statement" to verify

### Step 6: Re-enable android:autoVerify

Once the assetlinks.json file is properly hosted and verified, update your AndroidManifest.xml:

In `android/app/src/main/AndroidManifest.xml`, change line 36 from:
```xml
<intent-filter>
```

To:
```xml
<intent-filter android:autoVerify="true">
```

### Step 7: Rebuild and Test

1. Build a new release version:
   ```bash
   flutter clean
   flutter build appbundle --release
   ```

2. Upload to Play Console (internal testing track is fine for testing)

3. Wait for Play Store to process the build (can take a few hours)

4. Test the deeplinks by clicking a link like:
   - `https://entrancetricks.com/news?id=123`

---

## Testing Your Setup

### Test on a Physical Device:

1. **Using ADB:**
   ```bash
   adb shell am start -W -a android.intent.action.VIEW -d "https://entrancetricks.com/news?id=123" com.vector_academy.app
   ```

2. **Using a Web Page:**
   Create a simple HTML file:
   ```html
   <!DOCTYPE html>
   <html>
   <body>
       <h1>Test Deep Links</h1>
       <a href="https://entrancetricks.com/news?id=123">Open News</a>
       <a href="https://entrancetricks.com/exam?id=456">Open Exam</a>
   </body>
   </html>
   ```
   Open this in Chrome on your device and tap the links.

3. **Send yourself a link:**
   Send a link via WhatsApp, Telegram, or Email and tap it.

### Verify App Links Status (Android):

```bash
adb shell dumpsys package d
```

Look for your package name and check the verification status.

---

## Troubleshooting

### Links still open Play Store after setup:

1. **Clear App Links Preferences:**
   - Settings → Apps → Your App → Open by default → Clear defaults
   - Try the link again

2. **Force verification refresh:**
   ```bash
   adb shell pm verify-app-links --re-verify com.vector_academy.app
   ```

3. **Check verification status:**
   ```bash
   adb shell pm get-app-links com.vector_academy.app
   ```

### Links open browser instead of app:

1. Verify the assetlinks.json is accessible and has correct SHA256
2. Make sure you uploaded the build to Play Store (even in internal testing)
3. Wait 10-15 minutes after uploading for Google to verify
4. Check that `android:autoVerify="true"` is present

### Multiple SHA256 Fingerprints:

If you have both a local keystore and Play Store signing, you need **both** fingerprints in your assetlinks.json:

```json
"sha256_cert_fingerprints": [
    "FINGERPRINT_FROM_PLAY_STORE",
    "FINGERPRINT_FROM_LOCAL_KEYSTORE"
]
```

---

## Current Configuration

- **Package Name:** `com.vector_academy.app`
- **Domains:** 
  - `entrancetricks.com`
  - `www.entrancetricks.com`
- **Custom Scheme:** `entrancetricks://` (works as fallback)

## Supported Deep Link Patterns

### HTTPS Links (after App Links setup):
- `https://entrancetricks.com/home`
- `https://entrancetricks.com/subjects`
- `https://entrancetricks.com/news?id=123`
- `https://entrancetricks.com/exam?id=456`

### Custom Scheme (always works):
- `entrancetricks://home`
- `entrancetricks://subjects`
- `entrancetricks://news?id=123`
- `entrancetricks://exam?id=456`

---

## Quick Reference Commands

```bash
# Get SHA256 from keystore
keytool -list -v -keystore your-keystore.jks -alias your-alias

# Test file accessibility
curl -I https://entrancetricks.com/.well-known/assetlinks.json

# Test deeplink with ADB
adb shell am start -W -a android.intent.action.VIEW -d "https://entrancetricks.com/home"

# Check verification status
adb shell pm get-app-links com.vector_academy.app

# Force re-verify
adb shell pm verify-app-links --re-verify com.vector_academy.app

# Clear defaults
adb shell pm set-app-links --package com.vector_academy.app 0

# View all package details
adb shell dumpsys package com.vector_academy.app
```

---

## Summary

✅ **Current Status:** Deeplinks work but show disambiguation dialog  
🔧 **To Remove Dialog:** Complete Steps 1-7 above  
⏱️ **Estimated Time:** 30 minutes + Google verification time (1-24 hours)  
📝 **Key Files:** 
- `android/app/src/main/AndroidManifest.xml`
- `assetlinks.json` (must be hosted at `/.well-known/assetlinks.json`)

