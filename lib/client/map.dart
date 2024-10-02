import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'indexclient.dart';

class GMapsyr extends StatefulWidget {
  const GMapsyr({super.key});

  @override
  _GMapsyrState createState() => _GMapsyrState();
}

class _GMapsyrState extends State<GMapsyr> {
  
   final Completer<GoogleMapController> completer = Completer();
  Position? position;
  @override
  void initState() {
    getcurrentposition();

    super.initState();
  }

  Future<void> getcurrentposition() async {
    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0),
          leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Homeclient();
              }));
            },
            icon: CircleAvatar(
              backgroundColor: Colors.blue[700],
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),
        body: position == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GoogleMap(
                mapType: MapType.normal,
                markers: {
                  Marker(
                      markerId: const MarkerId("0"),
                      infoWindow: const InfoWindow(title: "geant 0"),
                      position: LatLng(
                          position!.latitude, position!.longitude + 0.5)),
                  const Marker(
                      markerId: MarkerId("1"),
                      infoWindow: InfoWindow(title: "geant 1"),
                      position: LatLng(36.829962, 10.1938322)),
                  Marker(
                      markerId: const MarkerId("2"),
                      infoWindow: const InfoWindow(title: "geant 2"),
                      position: LatLng(
                        position!.latitude,
                        position!.longitude + 0.1,
                      )),
              
                          const Marker(
                      markerId: MarkerId("3"),
                      infoWindow: InfoWindow(title: "geant 3"),
                      position: LatLng( 36.7264635,10.2577426)),
               
  
                          const Marker(
                      markerId: MarkerId("4"),
                      infoWindow: InfoWindow(title: "geant 4"),
                      position: LatLng( 36.899945,10.124415)),
                     
                          const Marker(
                      markerId: MarkerId("5"),
                      infoWindow: InfoWindow(title: "geant 5"),
                      position: LatLng( 34.788961,10.780627)),
                      const Marker(
                      markerId: MarkerId("6"),
                      infoWindow: InfoWindow(title: "geant 6"),
                      position: LatLng( 35.502446,11.045721)),
                      const Marker(
                      markerId: MarkerId("7"),
                      infoWindow: InfoWindow(title: "geant 7"),
                      position: LatLng( 35.824503,10.634584)),
                      const Marker(
                      markerId: MarkerId("8"),
                      infoWindow: InfoWindow(title: "geant 8"),
                      position: LatLng( 33.817452,10.971162)),
                      const Marker(
                      markerId: MarkerId("9"),
                      infoWindow: InfoWindow(title: "geant 9"),
                      position: LatLng( 33.817452,10.971162)),
               
               
                },
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                initialCameraPosition: CameraPosition(
                    zoom: 16,
                    target: LatLng(
                      position!.latitude,
                      position!.longitude,
                    )),
                onMapCreated: (controller) {
                  completer.complete(controller);
                },
              ));
  } 
}
