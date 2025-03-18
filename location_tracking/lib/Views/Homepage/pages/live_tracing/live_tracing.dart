import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveTracing extends StatefulWidget {
  const LiveTracing({super.key});

  @override
  State<LiveTracing> createState() => _LiveTracingState();
}

class _LiveTracingState extends State<LiveTracing> {
  final LatLng latLang = const LatLng(22.3039, 70.8022);
  String? selectedVehicle;
  final List<String> vehicles = ["UP32HK3456", "UP32JK3156"];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(22.3039, 70.8022),
            zoom: 14,
          ),
        ),

        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedVehicle,
                      hint: const Text("Select Vehicle"),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedVehicle = value;
                        });
                      },
                      items:
                          vehicles
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Track",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
