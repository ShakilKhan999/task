import 'package:flutter_noti/screens/home_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  var currentAddress = ''.obs;
  var isLoading = false.obs;

  Future<void> getUserLocation() async {
    isLoading.value = true;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      currentAddress.value =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      isLoading.value = false;

      Get.to(() => const HomeScreen());
    } else {
      isLoading.value = false;
      Get.snackbar("Permission Denied", "Location permission is required.");
    }
  }
}
