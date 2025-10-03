#!/bin/bash

# This script helps set up Firebase configuration for the Smart Campus Companion app

echo "🚀 Setting up Firebase configuration for Smart Campus Companion"

# Check if the Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed. Please install it first:"
    echo "   npm install -g firebase-tools"
    echo "   Then run: firebase login"
    exit 1
fi

# Create Android directory if it doesn't exist
mkdir -p android/app/

# Create iOS directory if it doesn't exist
mkdir -p ios/Runner/

# Ask user for Firebase project details
read -p "🔹 Enter your Firebase project ID: " FIREBASE_PROJECT_ID
read -p "🔹 Enter your Android package name (e.g., com.example.app): " ANDROID_PACKAGE_NAME
read -p "🔹 Enter your iOS bundle ID (e.g., com.example.app): " IOS_BUNDLE_ID

# Download Google Services files
echo "\n📥 Downloading Firebase configuration files..."

# Download google-services.json for Android
firebase apps:sdkconfig --project $FIREBASE_PROJECT_ID android $ANDROID_PACKAGE_NAME > android/app/google-services.json

# Download GoogleService-Info.plist for iOS
firebase apps:sdkconfig --project $FIREBASE_PROJECT_ID ios $IOS_BUNDLE_ID > ios/Runner/GoogleService-Info.plist

# Verify files were downloaded
if [ -f "android/app/google-services.json" ] && [ -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo "\n✅ Firebase configuration files downloaded successfully!"
    echo "   - Android: android/app/google-services.json"
    echo "   - iOS: ios/Runner/GoogleService-Info.plist"
    
    # Enable Firebase services
    echo "\n🔧 Enabling required Firebase services..."
    firebase --project $FIREBASE_PROJECT_ID firestore:databases:create --region us-central1 --collection=sample --data-export=false --require-ssl=false --ttl=disabled
    firebase --project $FIREBASE_PROJECT_ID auth:import users.json --hash-algo=BCRYPT
    
    echo "\n🎉 Firebase setup complete!"
    echo "   Don't forget to enable Authentication methods in the Firebase Console:"
    echo "   1. Go to https://console.firebase.google.com/"
    echo "   2. Select your project"
    echo "   3. Go to Authentication > Sign-in method"
    echo "   4. Enable Email/Password and Google Sign-In"
    
else
    echo "\n❌ Error downloading Firebase configuration files. Please check your project ID and try again."
    exit 1
fi
