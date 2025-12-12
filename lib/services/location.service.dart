import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/widgets/bottomsheets/location_permission.bottomsheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' hide LocationAccuracy;
// import 'package:geocoder/geocoder.dart';
import 'package:rxdart/rxdart.dart';
import 'geocoder.service.dart';

class LocationService {
  //
  static Location location = new Location();

  static bool? serviceEnabled;
  static PermissionStatus? _permissionGranted;
  static LocationData? _locationData;
  static Address? currenctAddress;
  static DeliveryAddress? deliveryaddress;
  static StreamSubscription? currentLocationListener;

  //
  static PublishSubject<Address> currenctAddressSubject =
      PublishSubject<Address>();
  // stream for delivery address
  static PublishSubject<DeliveryAddress> currenctDeliveryAddressSubject =
      PublishSubject<DeliveryAddress>();
  // static Stream<Address> get currenctAddressStream =>
  //     _currenctAddressSubject.stream;

  static Future<void> prepareLocationListener([bool oneTime = false]) async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      //
      bool requestPermission = true;
      if (!Platform.isIOS) {
        requestPermission = await showRequestDialog();
      }
      if (requestPermission) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
    }

    serviceEnabled = await location.serviceEnabled();
    if (serviceEnabled == null || serviceEnabled! == false) {
      serviceEnabled = await location.requestService();
      if (serviceEnabled == null || serviceEnabled! == false) {
        return;
      }
    }

    _startLocationListner(oneTime);
  }

  static Future<bool> showRequestDialog() async {
    //
    var requestResult = false;
    //
    await showDialog(
      context: AppService().navigatorKey.currentContext!,
      builder: (context) {
        return LocationPermissionDialog(
          onResult: (result) {
            requestResult = result;
          },
        );
      },
    );

    //
    return requestResult;
  }

  static void _startLocationListner([bool oneTime = false]) async {
    //
    //update location every 100meters
    // await location.changeSettings(distanceFilter: 50);
    // //listen
    // currentLocationListener =
    //     location.onLocationChanged.listen((LocationData currentLocation) {
    //   // Use current location
    //   _locationData = currentLocation;
    //   //
    //   geocodeCurrentLocation(true);
    // });

    //listen
    currentLocationListener = Geolocator.getPositionStream().listen((
      Position currentLocation,
    ) {
      // Use current location
      _locationData = LocationData.fromMap(currentLocation.toJson());
      //
      geocodeCurrentLocation(true);
    });

    //get the current location on send to listeners
    _locationData = await location.getLocation();
    geocodeCurrentLocation(oneTime);
  }

  Future<LocationData> getLocationData() async {
    LocationData locationData = await location.getLocation();
    return locationData;
  }

  //
  static Future<void> geocodeCurrentLocation([
    bool closeListener = false,
  ]) async {
    if (_locationData != null) {
      final coordinates = new Coordinates(
        _locationData?.latitude ?? 0.0,
        _locationData?.longitude ?? 0.0,
      );

      try {
        //
        final addresses = await GeocoderService().findAddressesFromCoordinates(
          coordinates,
        );
        //
        currenctAddress = addresses.first;
        //
        if (currenctAddress != null) {
          currenctAddressSubject.add(currenctAddress!);
          //set and save for next time
          final mDeliveryaddress = DeliveryAddress(
            name: currenctAddress!.featureName,
            address: currenctAddress!.addressLine,
            latitude: currenctAddress!.coordinates?.latitude,
            longitude: currenctAddress!.coordinates?.longitude,
          );
          if (deliveryaddress == null) {
            saveSelectedAddressLocally(mDeliveryaddress);
          }
        }
      } catch (error) {
        print("Error get location ==> $error");
      }
    }

    //
    if (closeListener) {
      print("Location listener closed");
      currentLocationListener?.cancel();
    }
  }

  //coordinates to address
  static Future<Address?> addressFromCoordinates({
    required double lat,
    required double lng,
  }) async {
    Address? address;
    final coordinates = new Coordinates(lat, lng);

    try {
      //
      final addresses = await GeocoderService().findAddressesFromCoordinates(
        coordinates,
      );
      //
      address = addresses.first;
    } catch (error) {
      print("Issue with addressFromCoordinates ==> $error");
    }
    return address;
  }

  //Helper methods

  //get current lat
  static double? get cLat {
    return LocationService.currenctAddress?.coordinates?.latitude;
  }

  //get current lng
  static double? get cLng {
    return LocationService.currenctAddress?.coordinates?.longitude;
  }

  //
  static saveSelectedAddressLocally(DeliveryAddress? mDeliveryaddress) async {
    deliveryaddress = mDeliveryaddress;
    if (mDeliveryaddress != null) {
      final pref = await LocalStorageService.getPrefs();
      await pref.setString(
        "LOCAL_ADDRESS",
        jsonEncode(mDeliveryaddress.toJson()),
      );
      //
      currenctDeliveryAddressSubject.add(mDeliveryaddress);
      //address
      final mAddress = Address(
        coordinates: Coordinates(
          mDeliveryaddress.latLng.latitude,
          mDeliveryaddress.latLng.longitude,
        ),
        addressLine: mDeliveryaddress.address,
        featureName: mDeliveryaddress.name,
        adminArea: mDeliveryaddress.state,
        subAdminArea: mDeliveryaddress.city,
        countryName: mDeliveryaddress.country,
      );
      currenctAddressSubject.add(mAddress);
    }
  }

  //
  static Future<DeliveryAddress?> getLocallySaveAddress() async {
    final pref = await LocalStorageService.getPrefs();
    final rawData = pref.getString("LOCAL_ADDRESS");
    if (rawData != null && rawData.isNotNullOrBlank) {
      return DeliveryAddress.fromJson(jsonDecode(rawData));
    }
    return null;
  }

  //MISC.
  static Future<double?> getFetchByLocationLat() async {
    final address = await getLocallySaveAddress();
    return address?.latitude ??
        LocationService.currenctAddress?.coordinates?.latitude;
  }

  static Future<double?> getFetchByLocationLng() async {
    final address = await getLocallySaveAddress();
    return address?.longitude ??
        LocationService.currenctAddress?.coordinates?.longitude;
  }

  //DEFAULT LOCATION MANAGEMENT
  /// Save default location to SharedPreferences
  static Future<void> saveDefaultLocation(double lat, double lng) async {
    try {
      final pref = await LocalStorageService.getPrefs();
      await pref.setDouble("DEFAULT_LAT", lat);
      await pref.setDouble("DEFAULT_LNG", lng);
      print("✅ Default location saved to storage: Lat=$lat, Lng=$lng");
    } catch (error) {
      print("❌ Error saving default location => $error");
    }
  }

  /// Get default location from SharedPreferences
  static Future<Map<String, double>?> getDefaultLocation() async {
    try {
      final pref = await LocalStorageService.getPrefs();
      final lat = pref.getDouble("DEFAULT_LAT");
      final lng = pref.getDouble("DEFAULT_LNG");
      if (lat != null && lng != null) {
        print("📍 Retrieved default location from storage: Lat=$lat, Lng=$lng");
        return {"lat": lat, "lng": lng};
      } else {
        print("📍 No default location found in storage");
      }
    } catch (error) {
      print("❌ Error getting default location => $error");
    }
    return null;
  }

  /// Fetch current location and save as default
  static Future<Map<String, double>?> fetchAndSaveDefaultLocation() async {
    try {
      print("📍 Checking location services...");

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("❌ Location services are disabled");
        return null;
      }
      print("✅ Location services are enabled");

      // Check location permission
      print("📍 Checking location permission...");
      LocationPermission permission = await Geolocator.checkPermission();
      print("📍 Current permission status: $permission");

      // Request permission if denied
      if (permission == LocationPermission.denied) {
        print("📍 Permission denied, requesting permission...");
        permission = await Geolocator.requestPermission();
        print("📍 Permission request result: $permission");

        if (permission == LocationPermission.denied) {
          print("❌ Location permission denied by user");
          return null;
        }
      }

      // Check if permission is permanently denied
      if (permission == LocationPermission.deniedForever) {
        print("❌ Location permission permanently denied");
        return null;
      }

      print("✅ Location permission granted");

      print("📍 Fetching location...");

      // Try to get last known position first (faster)
      Position? currentLocation = await Geolocator.getLastKnownPosition();

      if (currentLocation != null) {
        print(
          "✅ Got last known position: ${currentLocation.latitude}, ${currentLocation.longitude}",
        );
      } else {
        print("📍 No last known position, getting current position...");
        // If no last known position, get current position
        currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        print(
          "✅ Got current position: ${currentLocation.latitude}, ${currentLocation.longitude}",
        );
      }

      print("📍 Saving default location...");
      await saveDefaultLocation(
        currentLocation.latitude,
        currentLocation.longitude,
      );

      return {
        "lat": currentLocation.latitude,
        "lng": currentLocation.longitude,
      };
    } catch (error) {
      print("❌ Error fetching and saving default location => $error");
      return null;
    }
  }
}
