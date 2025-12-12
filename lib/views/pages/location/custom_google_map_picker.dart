import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fuodz/services/geocoding_api_service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CustomGoogleMapPicker extends StatefulWidget {
  final LatLng? initialPosition;
  final double initialZoom;

  const CustomGoogleMapPicker({
    Key? key,
    this.initialPosition,
    this.initialZoom = 14,
  }) : super(key: key);

  @override
  State<CustomGoogleMapPicker> createState() => _CustomGoogleMapPickerState();
}

class _CustomGoogleMapPickerState extends State<CustomGoogleMapPicker> {
  GoogleMapController? googleMapController;
  LatLng? selectedLatLng;
  String selectedAddress = "";
  bool isLoadingAddress = false;
  bool isSearching = false;

  // Search functionality
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<PlaceSuggestion> searchSuggestions = [];
  Timer? _searchDebounce;
  bool isLoadingSearch = false;

  @override
  void initState() {
    super.initState();
    selectedAddress = "Move the map to select a location...".tr();

    // Initialize with current location if available
    if (widget.initialPosition != null) {
      selectedLatLng = widget.initialPosition;
    } else {
      _goToUserLocation();
    }

    // Listen to search input
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    // Cancel previous timer
    _searchDebounce?.cancel();

    // Only search if there's text
    if (searchController.text.trim().isEmpty) {
      setState(() {
        searchSuggestions = [];
        isLoadingSearch = false;
      });
      return;
    }

    // Show loading
    setState(() {
      isLoadingSearch = true;
    });

    // Debounce search for 800ms to reduce API calls
    _searchDebounce = Timer(const Duration(milliseconds: 800), () {
      _performSearch(searchController.text);
    });
  }

  Future<void> _performSearch(String query) async {
    try {
      final suggestions = await GeocodingApiService.searchPlaces(query);
      if (mounted) {
        setState(() {
          searchSuggestions = suggestions;
          isLoadingSearch = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          searchSuggestions = [];
          isLoadingSearch = false;
        });
      }
    }
  }

  Future<void> _onSuggestionSelected(PlaceSuggestion suggestion) async {
    // Close keyboard
    searchFocusNode.unfocus();

    // Clear suggestions but keep the selected text
    setState(() {
      searchSuggestions = [];
      searchController.text = suggestion.description;
      isLoadingAddress = false;
    });

    try {
      // Get place details (lat/lng)
      final placeDetails = await GeocodingApiService.getPlaceDetails(
        suggestion.placeId,
      );

      if (placeDetails != null && googleMapController != null) {
        final newPosition = LatLng(placeDetails.lat, placeDetails.lng);

        // Animate camera to the selected location
        await googleMapController!.animateCamera(
          CameraUpdate.newLatLngZoom(newPosition, 16),
        );

        // Update selected position and address
        selectedLatLng = newPosition;
        selectedAddress = suggestion.description;

        setState(() {
          isLoadingAddress = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingAddress = false;
        selectedAddress = "Unable to fetch location details".tr();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition ?? const LatLng(30.0444, 31.2357),
              zoom: widget.initialZoom,
            ),
            onMapCreated: (controller) {
              googleMapController = controller;
              if (widget.initialPosition == null) {
                _goToUserLocation();
              }
            },
            onCameraMove: (position) {
              selectedLatLng = position.target;
            },
            onCameraIdle: () {
              if (selectedLatLng != null && !isSearching) {
                _getAddress(selectedLatLng!);
              }
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Center pin
          Center(
            child: Icon(
              Icons.location_pin,
              size: 45,
              color: Colors.red,
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),

          // Search bar at the top
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 15,
            right: 15,
            child: Column(
              children: [
                // Search input
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: TextField(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    decoration: InputDecoration(
                      hintText: "Search for a location...".tr(),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon:
                          searchController.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {
                                    searchSuggestions = [];
                                  });
                                },
                              )
                              : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  ),
                ),

                // Search suggestions
                if (searchSuggestions.isNotEmpty || isLoadingSearch)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    constraints: const BoxConstraints(maxHeight: 300),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child:
                        isLoadingSearch
                            ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                            : ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: searchSuggestions.length,
                              separatorBuilder:
                                  (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final suggestion = searchSuggestions[index];
                                return ListTile(
                                  leading: const Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  title: Text(
                                    suggestion.description,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  onTap: () {
                                    _onSuggestionSelected(suggestion);
                                  },
                                );
                              },
                            ),
                  ),
              ],
            ),
          ),

          // My location button
          Positioned(
            bottom: 180,
            right: 15,
            child: FloatingActionButton(
              mini: true,
              heroTag: "myLocationButton",
              backgroundColor: Colors.white,
              onPressed: _goToUserLocation,
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),

          // Address display and confirm button at the bottom
          Positioned(
            bottom: 30,
            left: 15,
            right: 15,
            child: Column(
              children: [
                // Address display
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      if (isLoadingAddress)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      if (isLoadingAddress) const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          selectedAddress,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Confirm button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        selectedLatLng != null && !isLoadingAddress
                            ? () {
                              Navigator.pop(context, {
                                "name": selectedAddress,
                                "lat": selectedLatLng!.latitude,
                                "lng": selectedLatLng!.longitude,
                              });
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Select this location".tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 15,
            child:
                searchSuggestions.isEmpty
                    ? FloatingActionButton(
                      mini: true,
                      heroTag: "backButton",
                      backgroundColor: Colors.white,
                      onPressed: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Future<void> _goToUserLocation() async {
    try {
      final locationData = await LocationService().getLocationData();

      if (locationData != null && googleMapController != null) {
        final userPosition = LatLng(
          locationData.latitude!,
          locationData.longitude!,
        );

        await googleMapController!.animateCamera(
          CameraUpdate.newLatLngZoom(userPosition, 16),
        );
      }
    } catch (e) {
      // Handle location permission errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Unable to get current location".tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _getAddress(LatLng latlng) async {
    setState(() {
      isLoadingAddress = true;
      isSearching = false;
    });

    try {
      final address = await GeocodingApiService.getAddressFromLatLng(
        latlng.latitude,
        latlng.longitude,
      );

      if (mounted) {
        setState(() {
          selectedAddress = address;
          isLoadingAddress = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          selectedAddress = "Unable to fetch address".tr();
          isLoadingAddress = false;
        });
      }
    }
  }
}
