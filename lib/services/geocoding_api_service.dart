import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class GeocodingApiService {
  static const String apiKey = "AIzaSyAt4YfkHwNmHKhtVi43zfYx_bSneiN022U";

  // Cache to store recent geocoding results
  static final Map<String, String> _geocodingCache = {};
  static const int _maxCacheSize = 50;

  // Debounce timer to prevent excessive API calls
  static DateTime? _lastRequestTime;
  static const Duration _minRequestInterval = Duration(milliseconds: 500);

  /// Get formatted address from latitude and longitude with caching and debouncing
  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    // Round coordinates to 5 decimal places for caching (approx 1.1m precision)
    final String cacheKey =
        '${lat.toStringAsFixed(5)},${lng.toStringAsFixed(5)}';

    // Check cache first
    if (_geocodingCache.containsKey(cacheKey)) {
      log('Geocoding: Using cached result for $cacheKey');
      return _geocodingCache[cacheKey]!;
    }

    // Debounce: Ensure minimum time between requests
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest < _minRequestInterval) {
        final waitTime = _minRequestInterval - timeSinceLastRequest;
        await Future.delayed(waitTime);
      }
    }

    try {
      _lastRequestTime = DateTime.now();

      final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey&language=en",
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        log("Failed to call Google Geocoding API: ${response.statusCode}");
        throw Exception("Failed to fetch address");
      }

      // Decode response with UTF-8 to handle special characters properly
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (data["status"] != "OK") {
        log("Google Geocoding API Error: ${data['status']}");
        throw Exception("Geocoding error: ${data['status']}");
      }

      final address = data["results"][0]["formatted_address"] as String;

      // Store in cache
      _geocodingCache[cacheKey] = address;

      // Limit cache size
      if (_geocodingCache.length > _maxCacheSize) {
        final firstKey = _geocodingCache.keys.first;
        _geocodingCache.remove(firstKey);
      }

      log('Geocoding: Fetched and cached address for $cacheKey');
      return address;
    } catch (e) {
      log("Geocoding error: $e");
      rethrow;
    }
  }

  /// Search for places using autocomplete with debouncing
  static Future<List<PlaceSuggestion>> searchPlaces(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    // Debounce: Ensure minimum time between requests
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest < _minRequestInterval) {
        final waitTime = _minRequestInterval - timeSinceLastRequest;
        await Future.delayed(waitTime);
      }
    }

    try {
      _lastRequestTime = DateTime.now();

      final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(query)}&key=$apiKey&language=en",
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        log("Failed to call Google Places API: ${response.statusCode}");
        return [];
      }

      // Decode response with UTF-8 to handle special characters properly
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (data["status"] != "OK" && data["status"] != "ZERO_RESULTS") {
        log("Google Places API Error: ${data['status']}");
        return [];
      }

      final predictions = data["predictions"] as List;
      return predictions
          .map(
            (p) => PlaceSuggestion(
              placeId: p["place_id"],
              description: p["description"],
            ),
          )
          .toList();
    } catch (e) {
      log("Place search error: $e");
      return [];
    }
  }

  /// Get place details (lat/lng) from place ID
  static Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$apiKey",
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        log("Failed to call Google Place Details API: ${response.statusCode}");
        return null;
      }

      // Decode response with UTF-8 to handle special characters properly
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (data["status"] != "OK") {
        log("Google Place Details API Error: ${data['status']}");
        return null;
      }

      final location = data["result"]["geometry"]["location"];
      return PlaceDetails(lat: location["lat"], lng: location["lng"]);
    } catch (e) {
      log("Place details error: $e");
      return null;
    }
  }

  /// Clear the geocoding cache
  static void clearCache() {
    _geocodingCache.clear();
    log('Geocoding cache cleared');
  }
}

class PlaceSuggestion {
  final String placeId;
  final String description;

  PlaceSuggestion({required this.placeId, required this.description});
}

class PlaceDetails {
  final double lat;
  final double lng;

  PlaceDetails({required this.lat, required this.lng});
}
