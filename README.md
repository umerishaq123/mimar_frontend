 Flutter Location-Based App

A Flutter application that utilizes geolocation services to provide users with dynamic location-based features such as reverse geocoding, live location access, and more.

---

 Features

 Get user's current location using GPS
 Convert coordinates into readable addresses
 Smooth UI loading with Shimmer effect
 Beautiful custom fonts with Google Fonts
 data populate through apis integration
 Permission handling and graceful fallbacks
 Local data persistence with Shared Preferences

---

 Setup Instructions

Follow these steps to run the project locally:

 Clone the repository

git clone https://github.com/umerishaq123/mimar_frontend.git
cd your-repo

packages:-

provider	State management
http	HTTP networking
shared_preferences	Local key-value storage
flutter_spinkit	Loading spinners
intl	Internationalization & date formatting
google_fonts	Access to Google Fonts
geolocator	Get current location
geocoding	Convert coordinates to addresses
permission_handler	Request location and storage permission
shimmer	Shimmer loading animation



permissions:-

<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>
