import 'package:flutter/material.dart';
import 'package:flutter_noti/common_widgets/custom_button.dart';
import 'package:flutter_noti/constents/app_colors.dart';
import 'package:flutter_noti/constents/app_text_style.dart';
import 'package:flutter_noti/controllers/location_controller.dart';
import 'package:flutter_noti/helpers/padding_helper.dart';
import 'package:flutter_noti/helpers/space_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_noti/controllers/home_controller.dart';
import 'package:flutter_noti/services/notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final notiService = Get.find<NotiService>();
    final controller = Get.put(HomeController(notiService: notiService));
    final LocationController locationController = Get.put(LocationController());
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: PaddingHelper.horizontal16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SpaceHelper.verticalSpace30,
                _buildLocationView(locationController),
                _buildAddAlarmButton(controller, context),
                SpaceHelper.verticalSpace30,
                _buildAlarmTextHeading(),
                SpaceHelper.verticalSpace10,
                _buildAlarmsList(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlarmTextHeading() {
    return Text('Alarms',
        style:
            AppTextStyle.poppins(fontSize: 18.sp, fontWeight: FontWeight.w500));
  }

  Widget _buildLocationView(LocationController locationController) {
    return Padding(
      padding: EdgeInsets.only(left: 30.w, right: 30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Location',
            style: AppTextStyle.titleText(
                fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SpaceHelper.verticalSpace10,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/location_icon.png',
                height: 24.sp,
                width: 24.w,
              ),
              SpaceHelper.horizontalSpace3,
              Expanded(
                child: Text(
                  locationController.currentAddress.value,
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.titleText(
                      fontSize: 14.sp, fontWeight: FontWeight.w400),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAddAlarmButton(HomeController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 30.h),
      child: CustomButton(
        height: 40.h,
        text: 'Add Alarm',
        backgroundColor: AppColors.addAlarmButtonColor,
        onPressed: () => _showDateTimePicker(controller, context),
      ),
    );
  }

  Widget _buildAlarmsList(HomeController controller) {
    return Obx(() => controller.alarms.isEmpty
        ? Center(
            child: Padding(
              padding: EdgeInsets.all(16.0.sp),
              child: Text(
                'No alarms set',
                style: AppTextStyle.poppins(
                    fontSize: 20.sp, fontWeight: FontWeight.w500),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.alarms.length,
            itemBuilder: (context, index) {
              final alarm = controller.alarms[index];
              return Obx(() => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.addAlarmButtonColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.formatTime(alarm.dateTime),
                          style: AppTextStyle.poppins(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              controller.formatDate(alarm.dateTime),
                              style: AppTextStyle.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SpaceHelper.horizontalSpace3,
                            Switch(
                              value: alarm.isActive.value,
                              onChanged: (_) => controller.toggleAlarm(alarm),
                              activeTrackColor: AppColors.buttonColor,
                            ),
                          ],
                        )
                      ],
                    ),
                  ));
            },
          ));
  }

  Future<void> _showDateTimePicker(
      HomeController controller, BuildContext context) async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (selectedDate == null || !context.mounted) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null || !context.mounted) return;

    final dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    controller.addAlarm(dateTime);
  }
}
