import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';

class LocationSelectionPage extends StatefulWidget {
  final Function(String)? onLocationSelected;
  const LocationSelectionPage({Key? key, this.onLocationSelected}) : super(key: key);

  @override
  State<LocationSelectionPage> createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  late GoogleMapController mapController;
  LatLng? selectedLocation;
  String? selectedAddress;

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      selectedLocation = LatLng(position.latitude, position.longitude);
    });
    await _getAddressFromLatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(selectedLocation!));
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    final placemarks = await placemarkFromCoordinates(lat, lng);
    final place = placemarks.first;
    setState(() {
      selectedAddress = "${place.locality}, ${place.country}";
    });
  }

  Future<void> _saveLocation() async {
    if (selectedAddress != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_location', selectedAddress!);
      widget.onLocationSelected?.call(selectedAddress!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition: const CameraPosition(
                target: LatLng(33.6844, 73.0479), // default to Islamabad
                zoom: 12,
              ),
              onTap: (LatLng position) async {
                setState(() => selectedLocation = position);
                await _getAddressFromLatLng(position.latitude, position.longitude);
              },
              markers: selectedLocation == null
                  ? {}
                  : {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: selectedLocation!,
                ),
              },
            ),
            if (selectedAddress != null)
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    selectedAddress!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.my_location),
                label: const Text('Select Current Location'),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _saveLocation,
                child: const Text('Confirm Location'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
