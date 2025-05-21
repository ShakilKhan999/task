import 'package:flutter/material.dart';
import 'package:flutter_noti/constents/app_strings.dart';
import 'package:flutter_noti/models/onboarding_model.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var pageIndex = 0.obs;
  final PageController pageController = PageController();
  final onboardingList = [
    OnboardingModel(
      imagePath: 'assets/gif/onboarding1.gif',
      title: AppStrings.onboardingTitle1,
      subtitle: AppStrings.onboardingSubtitle1,
    ),
    OnboardingModel(
      imagePath: 'assets/gif/onboarding2.gif',
      title: AppStrings.onboardingTitle2,
      subtitle: AppStrings.onboardingSubtitle2,
    ),
    OnboardingModel(
      imagePath: 'assets/gif/onboarding3.gif',
      title: AppStrings.onboardingTitle3,
      subtitle: AppStrings.onboardingSubtitle3,
    ),
  ];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
