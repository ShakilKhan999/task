import 'package:flutter/material.dart';
import 'package:flutter_noti/common_widgets/custom_button.dart';
import 'package:flutter_noti/constents/app_colors.dart';
import 'package:flutter_noti/constents/app_text_style.dart';
import 'package:flutter_noti/controllers/location_controller.dart';
import 'package:flutter_noti/helpers/padding_helper.dart';
import 'package:flutter_noti/helpers/space_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LocationScreen extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());

  LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: PaddingHelper.horizontal16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHedingTextView(),
            _buildImageView(),
            SpaceHelper.verticalSpace30,
            _buildBottomView(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomView() {
    return Obx(() => locationController.isLoading.value
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.buttonColor,
            ),
          )
        : Column(
            children: [
              _buildLocationButton(),
              SpaceHelper.verticalSpace20,
              _buildHomeButtonView()
            ],
          ));
  }

  Widget _buildHomeButtonView() {
    return CustomButton(
        text: 'Home',
        backgroundColor: AppColors.secondButtonColor,
        onPressed: () {
          locationController.getUserLocation();
        });
  }

  Widget _buildLocationButton() {
    return CustomButton(
        text: 'Use Current Location',
        iconPath: 'assets/images/location_icon.png',
        backgroundColor: AppColors.secondButtonColor,
        onPressed: () {
          locationController.getUserLocation();
        });
  }

  Widget _buildImageView() =>
      Image.asset('assets/images/morning2-transformed 1.png');

  Widget _buildHedingTextView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome! Your\nPersonalized Alarm',
          style: AppTextStyle.titleText(fontWeight: FontWeight.w600),
          textAlign: TextAlign.left,
        ),
        SpaceHelper.verticalSpace10,
        Text(
          'Allow us to sync your sunset alarm \nbased on your location.',
          textAlign: TextAlign.left,
          style: AppTextStyle.titleText(
              fontSize: 16.sp, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
