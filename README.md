☕ About

BrewMap is a Flutter-based mobile application designed for coffee enthusiasts who want to explore nearby cafés with ease. Whether you're looking for your next favorite coffee spot or need directions to a café, BrewMap makes the journey seamless and intuitive.✨ Key Features

🗺️ Interactive Map Exploration - Discover cafés near your current location with real-time mapping

🚶 Smart Navigation - Get walking directions to your chosen café with animated route visualization

⭐ Favorites Management - Save your favorite cafés for quick access, synced across devices

🔐 Secure Authentication - Multiple sign-in options including email/password, Google, and Apple

🌓 Adaptive Theming - Seamless light and dark mode support for comfortable viewing

🌍 Multi-Language Support - Currently available in English and Turkish

📱 Platform-Specific UI - Native Material Design for Android and Cupertino for iOS

🏗️ ArchitectureBrewMap follows Clean Architecture principles with BLoC pattern for state management, ensuring:

Separation of Concerns - Clear boundaries between UI, business logic, and data layers

Testability - Easy unit and widget testing with isolated components

Scalability - Modular structure that grows with your features

Maintainability - Predictable state management and unidirectional data flow

🛠️ Tech Stack

State Management

Flutter BLoC - Predictable state management with Cubit pattern

Equatable - Value equality for state comparison

Backend & Services

Firebase Authentication - Email, Google, and Apple sign-in

Cloud Firestore - Real-time database for favorites sync

Dio - HTTP client for API requests

APIs & Services

Google Maps API - Places search and directions

Google Maps Flutter - Interactive map widget

Local Storage

Hive - Fast, lightweight NoSQL database for offline favorites and settings

Architecture & Utilities

GetIt - Dependency injection / Service locator

Either Dart - Functional error handling

Geolocator - Location services and permissions


Installation

Clone the repository

bash   git clone https://github.com/mrtanonur/brewmap.git

cd brewmap

Install dependencies

bash   flutter pub get

Set up environment variables

Create a .env file in the root directory:

env   GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here

Configure Firebase

Create a Firebase project at Firebase Console

Add Android/iOS apps to your project

Download configuration files:

google-services.json → android/app/

GoogleService-Info.plist → ios/Runner/


Enable Authentication methods (Email/Password, Google, Apple)

Create a Firestore database

Set up Firestore security rules:



javascript   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /user/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
         match /favorite/{favoriteId} {
           allow read, write: if request.auth != null && request.auth.uid == userId;
         }
       }
     }
   }

Run the app

bash   flutter run
