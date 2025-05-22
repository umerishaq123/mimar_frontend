import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProvider with ChangeNotifier {
  String _currentCity = "Unknown";
  String _currentCountry = "Unknown";
  bool _isLoading = false;
  String _error = "";
  bool _locationPermissionGranted = false;

  // Getters
  String get currentCity => _currentCity;
  String get currentCountry => _currentCountry;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get locationPermissionGranted => _locationPermissionGranted;

  Future<void> initializeLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
     
      await _checkLocationPermission();
      
      if (_locationPermissionGranted) {
        await _getCurrentCity();
      }
    } catch (e) {
      _error = "Failed to get location: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

 
  Future<void> _checkLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    
    if (status.isDenied) {
      // Request permission
      status = await Permission.location.request();
    }
    
    if (status.isPermanentlyDenied) {
      _error = "Location permission permanently denied. Please enable it in app settings.";
      _locationPermissionGranted = false;
    } else if (status.isDenied) {
      _error = "Location permission denied";
      _locationPermissionGranted = false;
    } else if (status.isGranted) {
      _locationPermissionGranted = true;
      _error = "";
    }
    
    notifyListeners();
  }


  Future<void> _getCurrentCity() async {
    try {
      
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error = "Location services are disabled. Please enable them.";
        notifyListeners();
        return;
      }

     
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
  
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, 
        position.longitude
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _currentCity = place.locality ?? "Unknown";
        _currentCountry = place.country ?? "Unknown";
        _error = "";
      } else {
        _error = "No city found for current location";
      }
    } catch (e) {
      _error = "Failed to get current city: $e";
    }
    
    notifyListeners();
  }


  Future<void> refreshLocation() async {
    if (_locationPermissionGranted) {
      _isLoading = true;
      notifyListeners();
      
      try {
        await _getCurrentCity();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      await initializeLocation();
    }
  }
}