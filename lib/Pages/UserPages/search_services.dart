import 'package:carease/Components/carease_colors.dart';
import 'package:carease/Components/custom_progress_indicator.dart';
import 'package:carease/Components/text_button_orange.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Helpers/location_selection_page.dart';
import '../../Helpers/location_widget.dart';

class SearchServices extends StatefulWidget {
  const SearchServices({super.key});

  @override
  State<SearchServices> createState() => _SearchServicesState();
}

class _SearchServicesState extends State<SearchServices> {
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLocation = prefs.getString('user_location');

    if (savedLocation == null) {
      // Show location selector when user opens app for the first time
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openLocationSelector();
      });
    } else {
      setState(() {
        _currentAddress = savedLocation;
      });
    }
  }

  Future<void> _saveLocation(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_location', address);
    setState(() {
      _currentAddress = address;
    });
  }

  void _openLocationSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CareaseColors.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return LocationSelectionSheet(onLocationSelected: (address) {
          Navigator.pop(context);
          _saveLocation(address);
        });
      },
    );
  }

  void _openSearchPage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return Container(
        width: 500,
        height: MediaQuery.of(context).size.height * 1,
        padding: const EdgeInsets.all(25.0),
        child: Column(
            children: [
              const Text(
                "AI Suggestions",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20,),

            ]
        ),
      );
        },
    );
  }

  String shortenText(String text, {int maxLength = 40}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _openLocationSelector,
                    child: Row(
                      children: [
                        Icon(
                          Ionicons.location_outline,
                          color: CareaseColors.grey,
                        ),
                        const SizedBox(width: 5,),
                        Text(
                          shortenText(_currentAddress ?? "Fetching location..."),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: CareaseColors.grey,
                          ),
                        ),
                        Icon(
                          Ionicons.chevron_down,
                          color: CareaseColors.grey,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  Icon(
                    Ionicons.notifications_outline,

                  ),
                ],
              ),
              const SizedBox(height: 15,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome,',
                    style: TextStyle(
                      color: CareaseColors.greyDark,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Sahir Nadeem',
                    style: TextStyle(
                      color: CareaseColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              Text(
                'What service are you looking for today',
                style: TextStyle(
                  fontSize: 24,
                  color: CareaseColors.orangeLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: _openSearchPage,
                child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: CareaseColors.greyDark,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 15,),
                        Icon(Ionicons.search,size: 20,color: CareaseColors.grey,),
                        const SizedBox(width: 20,),
                        Text(
                          'Search for mechanic, electrition, etc ...',
                          style: TextStyle(
                            color: CareaseColors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
              const SizedBox(height: 15,),
              Center(
                child: Text(
                  'or browse the available services',
                  style: TextStyle(
                    fontSize: 12,
                    color: CareaseColors.greyDark,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: CareaseColors.greyDark,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categories',
                            style: TextStyle(
                              color: CareaseColors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            'See All',
                            style: TextStyle(
                              color: CareaseColors.orangeLight,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              //decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.red,
                            height: 80,
                            width: 80,
                          ),
                          Container(
                            color: Colors.green,
                            height: 80,
                            width: 80,
                          ),
                          Container(
                            color: Colors.blue,
                            height: 80,
                            width: 80,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.red,
                            height: 80,
                            width: 80,
                          ),
                          Container(
                            color: Colors.green,
                            height: 80,
                            width: 80,
                          ),
                          Container(
                            color: Colors.blue,
                            height: 80,
                            width: 80,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25,),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: CareaseColors.greyDark,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'App Insights',
                            style: TextStyle(
                              color: CareaseColors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Active Users',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: CareaseColors.greyDark,
                                ),
                              ),
                              Text(
                                '250K',
                                style: TextStyle(
                                  fontSize: 60,
                                  color: CareaseColors.grey,
                                  fontFamily: 'TallNumbers'
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Registered Workers',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: CareaseColors.greyDark,
                                ),
                              ),
                              Text(
                                '100K',
                                style: TextStyle(
                                  fontSize: 60,
                                  color: CareaseColors.grey,
                                  fontFamily: 'TallNumbers'
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class LocationSelectionSheet extends StatefulWidget {
  final Function(String) onLocationSelected;
  const LocationSelectionSheet({super.key, required this.onLocationSelected});
  @override
  State<LocationSelectionSheet> createState() => _LocationSelectionSheetState();
}

class _LocationSelectionSheetState extends State<LocationSelectionSheet> {
  late GoogleMapController _mapController;
  LatLng? _selectedPosition;
  String? _selectedAddress;
  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _selectedPosition = LatLng(position.latitude, position.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      _selectedAddress =
      "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}}";
    }

    setState(() => _isLoading = false);
    _mapController.animateCamera(CameraUpdate.newLatLng(_selectedPosition!));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.9;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: height,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: CareaseColors.greyDark,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Text(
            "Select Your Location",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(33.6844, 73.0479), // Default: Islamabad
                  zoom: 14.0,
                ),
                onMapCreated: (controller) => _mapController = controller,
                onTap: (position) async {
                  setState(() => _selectedPosition = position);
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                    position.latitude,
                    position.longitude,
                  );
                  if (placemarks.isNotEmpty) {
                    Placemark place = placemarks.first;
                    setState(() {
                      _selectedAddress =
                      "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}}";
                    });
                  }
                },
                markers: _selectedPosition != null
                    ? {
                  Marker(
                    markerId: const MarkerId('selected'),
                    position: _selectedPosition!,
                  ),
                }
                    : {},
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const CustomProgressIndicator(imagePath: 'lib/Images/loading_gear.png',size: 30,)
          else
            TextButtonOrange(
              onTap: _getCurrentLocation,
              buttonText: 'Use Current Location',
            ),
          const SizedBox(height: 10),
          if (_selectedAddress != null)
            ElevatedButton(
              onPressed: () {
                widget.onLocationSelected(_selectedAddress!);
              },
              child: Text("Confirm: $_selectedAddress"),
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}