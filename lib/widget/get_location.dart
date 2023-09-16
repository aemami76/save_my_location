import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as pubhttp;
import 'package:location/location.dart';
import 'package:save_my_locations/controller/controller.dart';

class GetLocation extends ConsumerWidget {
  const GetLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? address = ref.read(newData).address;

    bool isGettingData = ref.watch(gettingLocation);

    void takeLocation() async {
      String apiKey = 'unFc92NLc7UDEzgpKYtI5qGzf063YjKj';

      Location location = Location();
      LocationData locationData;
      ref.watch(newData.notifier).getAddress = null;

      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      ref.read(gettingLocation.notifier).state = true;
      locationData = await location.getLocation();

      final lat = locationData.latitude;
      final lon = locationData.longitude;

      final geoGetterUrl =
          Uri.parse("https://geocode.maps.co/reverse?lat=$lat&lon=$lon");
      final response = await pubhttp.get(geoGetterUrl);
      ref.read(newData.notifier).getAddress =
          jsonDecode(response.body)["display_name"];

      // ref.read(newData.notifier).getAddressPic =
      //     'https://www.mapquestapi.com/staticmap/v5/map?key=$apiKey&center=$lat,$lon,MA&size=170,170@2x';

      File imageFile = await DefaultCacheManager().getSingleFile(
          'https://www.mapquestapi.com/staticmap/v5/map?key=$apiKey&center=$lat,$lon,MA&size=170,170@2x');
      ref.read(newData.notifier).getAddressPic = imageFile.path;

      ref.read(gettingLocation.notifier).state = false;
    }

    Widget content() {
      if (address == null) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            isGettingData ? const CircularProgressIndicator() : Container(),
            ElevatedButton.icon(
              onPressed: takeLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Location'),
            ),
            // ElevatedButton.icon(
            //     onPressed: selectPicture,
            //     icon: const Icon(Icons.picture_in_picture_alt_rounded),
            //     label: const Text('Select Picture.')),
          ],
        );
      } else {
        return Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              left: 0,
              child: Opacity(
                opacity: 0.7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Image.file(
                      File(ref.watch(newData).addressPic!), fit: BoxFit.cover,
                      width: double.infinity, height: double.infinity,
                      // FadeInImage.memoryNetwork(
                      //   placeholder: kTransparentImage,
                      //   image: ref.watch(newData).addressPic!,
                      //   fit: BoxFit.cover,
                      //   width: double.infinity,
                      //   height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '\nAddress:\n $address',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        backgroundColor: Color.fromRGBO(123, 234, 255, 0.45),
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                        onPressed: takeLocation,
                        icon: const Icon(Icons.location_on),
                        label: const Text('Get Location')),
                    // ElevatedButton.icon(
                    //     onPressed: selectPicture,
                    //     icon: const Icon(Icons.picture_in_picture_alt_rounded),
                    //     label: const Text('Select Picture.')),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    }

    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Card(
          elevation: 20,
          child: Container(
            height: 200,
            width: double.infinity,
            alignment: Alignment.center,
            child: content(),
          ),
        ));
  }
}
