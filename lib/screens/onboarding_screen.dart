import 'package:flutter/material.dart';
import 'package:flutter_noti/constents/app_colors.dart';
import 'package:flutter_noti/constents/app_text_style.dart';
import 'package:flutter_noti/controllers/onboarding_controller.dart';
import 'package:flutter_noti/helpers/padding_helper.dart';
import 'package:flutter_noti/models/onboarding_model.dart';
import 'package:flutter_noti/screens/location_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../common_widgets/custom_button.dart';
import '../../helpers/space_helper.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final halfHeight = constraints.maxHeight / 2;
          return Stack(
            children: [
              PageView.builder(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => controller.pageIndex.value = index,
                itemCount: controller.onboardingList.length,
                itemBuilder: (_, index) {
                  final item = controller.onboardingList[index];
                  return Column(
                    children: [
                      _buildImageView(halfHeight, item),
                      _buildBottomView(halfHeight, item),
                    ],
                  );
                },
              ),
              _buildSkipButtonView(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomView(double halfHeight, OnboardingModel item) {
    return SizedBox(
      height: halfHeight,
      child: Padding(
        padding: PaddingHelper.horizontal16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpaceHelper.verticalSpace20,
            Text(
              item.title,
              key: ValueKey(item.title),
              style: AppTextStyle.titleText(),
            ),
            SpaceHelper.verticalSpace16,
            Text(
              item.subtitle,
              key: ValueKey(item.subtitle),
              style: AppTextStyle.subTitleText(),
            ),
            const Spacer(),
            Column(
              children: [
                _buildIndicatorView(),
                SpaceHelper.verticalSpace20,
                _buildNextButtonView(),
              ],
            ),
            SpaceHelper.verticalSpace30,
          ],
        ),
      ),
    );
  }

  Widget _buildNextButtonView() {
    return CustomButton(
      text: 'Next',
      onPressed: () {
        if (controller.pageIndex.value ==
            controller.onboardingList.length - 1) {
          Get.off(() => LocationScreen(), transition: Transition.leftToRight);
        } else {
          controller.pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  Widget _buildIndicatorView() {
    return SmoothPageIndicator(
      controller: controller.pageController,
      count: controller.onboardingList.length,
      effect: const WormEffect(
        dotColor: Colors.grey,
        activeDotColor: AppColors.buttonColor,
        dotHeight: 10,
        dotWidth: 10,
        spacing: 8,
      ),
    );
  }

  Widget _buildSkipButtonView() {
    return Positioned(
      top: 40.h,
      right: 20.w,
      child: GestureDetector(
        onTap: () => Get.off(() => LocationScreen()),
        child: Text('Skip',
            style: AppTextStyle.oxygen(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildImageView(double halfHeight, OnboardingModel item) {
    return SizedBox(
      height: halfHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
        child: Image.asset(
          item.imagePath,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
