# Google Play Console Data Safety Declaration Guide

## For Ethio Entrance, Freshman Tricks App

This guide provides the exact information you need to fill out the **Data Safety** section in Google Play Console.

---

## Overview

The Data Safety section helps users understand how your app collects, shares, and secures their data. You must accurately disclose all data collection and handling practices.

---

## Section 1: Does your app collect or share any of the required user data types?

**Answer: YES**

Ethio Entrance, Freshman Tricks collects personal data to provide educational services.

---

## Section 2: Data Types Collected

### ✅ Personal Information

#### **Name**

- **Collected:** YES
- **Shared:** NO
- **Purpose:** App functionality, Personalization
- **Required:** YES
- **Description:** Used for account identification and personalized learning experience

#### **Phone Number**

- **Collected:** YES
- **Shared:** NO
- **Purpose:** App functionality, Account management, Authentication
- **Required:** YES
- **Description:** Used for user authentication and account recovery

#### **Email Address**

- **Collected:** NO
- **Shared:** NO

---

### ✅ Photos and Videos

#### **Photos**

- **Collected:** YES (optional)
- **Shared:** NO
- **Purpose:** App functionality, Personalization
- **Required:** NO
- **Description:** Users can optionally upload a profile picture. Not required for app functionality.

---

### ✅ Device or Other IDs

#### **Device or other IDs**

- **Collected:** YES
- **Shared:** NO
- **Purpose:** App functionality, Account management, Fraud prevention
- **Required:** YES
- **Description:** Device ID is collected for multi-device account management and security. We create a unique identifier based on device information and phone number.

**Note:** We collect:

- Device ID (generated hash)
- Device brand, model, manufacturer
- Operating system
- Device name

---

### ✅ App Activity

#### **App interactions**

- **Collected:** YES
- **Shared:** NO
- **Purpose:** App functionality, Analytics, Personalization
- **Required:** NO
- **Description:** Study plan progress, exam scores, downloaded content are tracked to provide personalized learning experience

---

### ✅ Financial Info (if applicable)

#### **Payment info**

- **Collected:** YES (if subscription model is active)
- **Shared:** NO (except with payment processor)
- **Purpose:** App functionality, Account management
- **Required:** NO (only for premium features)
- **Description:** Payment receipt images uploaded by users for subscription verification

---

### ❌ NOT Collected

The following data types are **NOT** collected:

- ✗ Location (precise or approximate)
- ✗ Contacts
- ✗ Messages
- ✗ Audio files
- ✗ Video files (we provide videos, but don't collect user videos)
- ✗ Calendar events
- ✗ Web browsing history
- ✗ Health and fitness data
- ✗ Files and docs (except payment receipts if uploaded)

---

## Section 3: How is user data shared?

### Data Sharing: NO (with exceptions)

**Answer: NO** - We do not share user data with third parties

**Exceptions:**

- Payment processing (if applicable) - payment gateway receives transaction data
- Legal requirements - we may disclose data if required by law

---

## Section 4: Is all of the user data collected by your app encrypted in transit?

**Answer: YES**

All user data is encrypted in transit using HTTPS/TLS encryption when communicating with our servers.

---

## Section 5: Do you provide a way for users to request that their data is deleted?

**Answer: YES**

Users can delete their account and all associated data by:

1. Opening Vector Academy app
2. Going to **Settings > Profile**
3. Selecting **Delete Account**
4. Confirming deletion

**Timeline:** User data is deleted from active systems within 30 days. Backup data is permanently deleted within 90 days.

---

## Section 6: Privacy Policy

**Privacy Policy URL:** https://entrancetricks.com/privacy

**Important:** You must upload the `PRIVACY_POLICY.md` file to your website at this URL before submitting to Play Console.

---

## Section 7: Permissions Justification

When reviewers ask why you need certain permissions, provide these justifications:

### INTERNET

**Why needed:** Required to fetch educational content, authenticate users, and sync data with our servers for Ethio Entrance, Freshman Tricks.

### RECEIVE_BOOT_COMPLETED

**Why needed:** Allows the app to reschedule study plan notification reminders after device reboot, ensuring students don't miss their planned study sessions.

### VIBRATE

**Why needed:** Provides haptic feedback for notifications, enhancing user awareness of study plan reminders.

### USE_FULL_SCREEN_INTENT

**Why needed:** Enables study plan reminder notifications to display even when the device is locked, ensuring students are alerted at the scheduled study time. This is crucial for educational reminders to be effective.

### SCHEDULE_EXACT_ALARM

**Why needed:** Allows precise scheduling of study plan reminders. Students rely on exact timing for their study schedules. This permission ensures notifications are delivered at the exact time set by the user, not delayed by battery optimization.

**Android 14+ Note:** This is a restricted permission that requires explicit user consent. We request this permission at runtime with a clear explanation.

---

## Section 8: Data Safety Summary (for app description)

Use this concise summary in your app description or release notes:

```
📊 DATA SAFETY SUMMARY

✅ What we collect:
• Name, phone number (for account)
• Device info (for security)
• Study progress (to personalize learning)
• Profile picture (optional)

🔒 Security:
• All data encrypted in transit (HTTPS)
• Passwords securely hashed
• No data selling to third parties

👤 Your control:
• Delete account anytime
• Update profile information
• Export your data
• Disable notifications

🎯 Purpose:
We collect only what's needed to provide you with the best educational experience.

📜 Full Privacy Policy: entrancetricks.com/privacy
```

---

## Section 9: Pre-Submission Checklist

Before submitting your app to Google Play Console, ensure:

- [ ] ✅ AndroidManifest.xml: Removed `usesCleartextTraffic` or set to `false`
- [ ] ✅ AndroidManifest.xml: Removed `requestLegacyExternalStorage`
- [ ] ✅ Privacy Policy uploaded to website (entrancetricks.com/privacy)
- [ ] ✅ Privacy Policy URL added in Play Console
- [ ] ✅ Data Safety section completely filled out
- [ ] ✅ All permissions justified
- [ ] ✅ Consent checkbox added to registration
- [ ] ✅ Runtime permission request for SCHEDULE_EXACT_ALARM implemented
- [ ] ✅ Account deletion feature working
- [ ] ✅ All API endpoints use HTTPS
- [ ] ✅ Tested on Android 14+ devices

---

## Section 10: Common Rejection Reasons & Fixes

### Rejection: "App uses cleartext traffic"

**Fix:** Already done ✅ - `usesCleartextTraffic` removed from manifest

### Rejection: "Missing runtime permission request"

**Fix:** Already done ✅ - Added runtime request for SCHEDULE_EXACT_ALARM

### Rejection: "Privacy policy not accessible"

**Action Needed:** Upload PRIVACY_POLICY.md to your website

### Rejection: "Insufficient user consent"

**Fix:** Already done ✅ - Added explicit consent checkbox in registration

### Rejection: "Data Safety section incomplete"

**Fix:** Use this guide to fill out all required fields

---

## Section 11: Testing Before Submission

### Test these scenarios:

1. **Fresh Install:**

   - App requests notification permissions ✓
   - App requests exact alarm permission on Android 14+ ✓
   - Registration requires privacy policy acceptance ✓

2. **Data Access:**

   - Users can view their profile data ✓
   - Users can update their information ✓

3. **Data Deletion:**

   - Account deletion removes all user data ✓
   - Confirmation dialog appears before deletion ✓

4. **Permissions:**
   - All permissions can be revoked in device settings ✓
   - App handles denied permissions gracefully ✓

---

## Section 12: Support Documentation

Keep these documents ready in case reviewers request additional information:

1. **Privacy Policy** (PRIVACY_POLICY.md)
2. **This Data Safety Guide** (PLAY_CONSOLE_DATA_SAFETY_GUIDE.md)
3. **Screenshots** showing:
   - Consent checkbox in registration
   - Privacy policy dialog
   - Account deletion flow
   - Permission request dialogs

---

## Section 13: Post-Submission

After submitting:

1. **Monitor Review Status:** Check Play Console daily for reviewer questions
2. **Respond Promptly:** Answer any queries within 24-48 hours
3. **Update as Needed:** If policies change, update both app and Play Console
4. **Version Updates:** When adding new data collection, update Data Safety section

---

## Need Help?

If reviewers have questions or your app is rejected:

1. Read the rejection reason carefully
2. Check which section of this guide applies
3. Make the necessary changes
4. Respond to reviewers explaining what was fixed
5. Resubmit for review

---

## Summary Checklist for Play Console Submission

```
✅ App complies with Google Play policies
✅ usesCleartextTraffic removed (or set to false)
✅ requestLegacyExternalStorage removed
✅ Privacy policy hosted online
✅ Privacy policy URL added to Play Console
✅ Data Safety section completed
✅ All permissions justified
✅ Runtime permissions requested
✅ Consent checkbox in registration
✅ Account deletion implemented
✅ HTTPS encryption for all API calls
✅ Tested on Android 14+
✅ Screenshots prepared
✅ Support documentation ready
```

---

**Good luck with your Play Console submission!**

_Vector Academy - Educational Excellence_

---

## Quick Reference: Data Safety Answers

| Question                   | Answer | Details                                     |
| -------------------------- | ------ | ------------------------------------------- |
| Collects user data?        | YES    | Personal info, device ID, photos (optional) |
| Shares user data?          | NO     | Except payment processing                   |
| Encrypted in transit?      | YES    | HTTPS for all communications                |
| User can request deletion? | YES    | Via Settings > Profile > Delete Account     |
| Privacy policy URL?        | YES    | https://entrancetricks.com/privacy          |

---

_Document Version: 1.0_
_Last Updated: November 2025_
