import 'package:aycel/core/constant/app_colors.dart';
import 'package:aycel/features/checkout/data/order_model.dart';
import 'package:aycel/features/shared_widgets/custom_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OrderView extends StatelessWidget {
  final OrderModel order;
  final bool isNew;

  const OrderView({
    super.key,
    required this.order,
    required this.isNew
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
            text:'order_details'.tr(),
          size: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),
            _buildCustomerInfo(),

            Gap( 16.h),

            _buildOrderStatus(),

            Gap( 16.h),

            _buildProducts(),

            Gap( 16.h),

            _buildPaymentInfo(),

            Gap( 16.h),

            _buildOrderSummary(),

            Gap( 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [


          Gap( 12.h),

          isNew ? Column(
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: AppColors.secondary,
                  size: 35.sp,
                ),
              ),
              CustomText(
                text:'order_received_successfully'.tr(),
                size: 18,
                fontWeight: FontWeight.bold,
              ),

              Gap( 6.h),

              CustomText(
                text:'thank_you_for_your_order'.tr(),
                textAlign: TextAlign.center,
                size: 13,
                color: Colors.grey,
              ),
            ],
          ) : const SizedBox.shrink(),


          Gap( 14.h),

          Divider(
            color: Colors.grey.shade200,
          ),

          Gap( 10.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem(
                title: 'order_number'.tr(),
                value: order.code ?? '-',
              ),

              _infoItem(
                title: 'status'.tr(),
                value: _statusText(order.status),
                valueColor: _statusColor(order.status),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus() {
    final status = order.status;

    // إذا كان الطلب ملغي
    if (status == 'cancelled') {
      return _sectionCard(
        title: 'order_status'.tr(),
        child: Column(
          children: [
            _statusStep(
              icon: Icons.receipt_long,
              title: 'order_received'.tr(),
              subtitle: 'order_received_description'.tr(),
              active: true,
            ),

            _statusLine(
              active: true,
            ),

            _statusStep(
              icon: Icons.cancel_outlined,
              title: 'cancelled'.tr(),
              subtitle: 'cancelled_description'.tr(),
              active: true,
            ),
          ],
        ),
      );
    }

    return _sectionCard(
      title: 'order_status'.tr(),
      child: Column(
        children: [
          // Pending
          _statusStep(
            icon: Icons.receipt_long,
            title: 'order_received'.tr(),
            subtitle: 'order_received_description'.tr(),
            active: true,
          ),

          _statusLine(
            active: status == 'processing' || status == 'completed',
          ),

          // Processing
          _statusStep(
            icon: Icons.inventory_2_outlined,
            title: 'processing'.tr(),
            subtitle: 'processing_description'.tr(),
            active: status == 'processing' || status == 'completed',
          ),

          _statusLine(
            active: status == 'completed',
          ),

          // Completed
          _statusStep(
            icon: Icons.check_circle_outline,
            title: 'completed'.tr(),
            subtitle: 'completed_description'.tr(),
            active: status == 'completed',
          ),
        ],
      ),
    );
  }
  Widget _statusStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool active,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: active
                ? AppColors.secondary
                : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 21.sp,
            color: active ? Colors.white : Colors.grey,
          ),
        ),

        Gap( 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text:title,
                size: 14,
                fontWeight: FontWeight.bold,
                color: active ? Colors.black : Colors.grey,
              ),

              Gap( 3.h),

              CustomText(
                text:subtitle,
                size: 12,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusLine({
    required bool active,
  }) {
    return Container(
      margin: EdgeInsets.only(
        right: 20.w,
      ),
      height: 25.h,
      width: 2.w,
      color: active
          ? AppColors.secondary
          : Colors.grey.shade200,
    );
  }

  Widget _buildProducts() {
    final items = order.items ?? [];

    return _sectionCard(
      title: 'products'.tr(args: ['${items.length}']),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: 14.h,
            ),
            child: _productItem(item),
          );
        }).toList(),
      ),
    );
  }

  Widget _productItem(OrderItemModel item) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xffFAFAFA),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.network(
              item.image ?? '',
              width: 75.w,
              height: 85.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 75.w,
                  height: 85.h,
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),

          Gap( 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: item.productName ?? 'product'.tr(),
                  size: 13,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                ),

                Gap(8.h),

                if (item.color != null)
                  CustomText(
                    text:'${'color'.tr()}: ${item.color}',
                    size: 11,
                    color: Colors.grey,
                  ),

                if (item.size != null)
                  CustomText(
                    text: '${'size'.tr()}: ${item.size}',
                    size: 11,
                    color: Colors.grey,
                  ),

                Gap( 8.h),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: '${item.price ?? 0} ₪',
                      size: 13,
                      fontWeight: FontWeight.bold,
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(6.r),
                      ),
                      child: CustomText(
                        text: '${'quantity'.tr()}: ${item.quantity ?? 0}',
                        size: 11,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return _sectionCard(
      title: 'payment_information'.tr(),
      child: Column(
        children: [
          _detailRow(
            icon: Icons.payment_outlined,
            title: 'payment_method'.tr(),
            value: _paymentMethodText(
              order.paymentMethod,
            ),
          ),

          Gap( 12.h),

          _detailRow(
            icon: Icons.calendar_today_outlined,
            title: 'order_date'.tr(),
            value: order.createdAt as String,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return _sectionCard(
      title: 'order_summary'.tr(),
      child: Column(
        children: [
          _priceRow(
            'subtotal'.tr(),
            order.subtotal,
          ),

          Gap( 10.h),



          Gap( 10.h),

          _priceRow(
            'discount'.tr(),
            order.discount,
          ),

          Gap( 10.h),

          _priceRow(
            'delivery_fee'.tr(),
            order.deleveryFee,
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 14.h,
            ),
            child: Divider(
              color: Colors.grey.shade200,
            ),
          ),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text:'total'.tr(),
                size: 16,
                fontWeight: FontWeight.bold,
              ),

              CustomText(
                text:'${order.total ?? 0} ₪',
                size: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          CustomText(
            text:title,
            size: 16,
            fontWeight: FontWeight.bold,
          ),

          Gap( 14.h),

          child,
        ],
      ),
    );
  }

  Widget _infoItem({
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          size: 11,
          color: Colors.grey,
        ),

        Gap( 4.h),

        CustomText(
          text:value,
          size: 13,
          fontWeight: FontWeight.bold,
          color: valueColor,
        ),
      ],
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius:
            BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
          ),
        ),

        Gap( 12.w),

        Expanded(
          child: CustomText(
            text: title,
            size: 13,
            color: Colors.grey.shade600,
          ),
        ),

        CustomText(
          text: value,
          size: 13,
          fontWeight: FontWeight.w600,
        )

      ],
    );
  }

  Widget _priceRow(
      String title,
      double? value,
      ) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text:title,
          size: 13,
          color: Colors.grey.shade600,
        ),

        CustomText(
          text:'${value ?? 0} ₪',
          size: 13,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  String _statusText(String? status) {
    switch (status) {
      case 'pending':
        return 'pending'.tr();

      case 'processing':
        return 'processing'.tr();

      case 'shipped':
        return 'shipped'.tr();

      case 'delivered':
        return 'delivered'.tr();

      case 'cancelled':
        return 'cancelled'.tr();

      default:
        return status ?? '-';
    }
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'delivered':
        return Colors.green;

      case 'shipped':
        return Colors.blue;

      case 'processing':
        return Colors.orange;

      case 'cancelled':
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  String _paymentMethodText(String? method) {
    switch (method) {
      case 'cod':
        return 'cash_on_delivery'.tr();

      case 'card':
        return 'credit_card'.tr();

      case 'paypal':
        return 'paypal'.tr();

      default:
        return method ?? '-';
    }
  }



  Widget _buildCustomerInfo() {
    print('FNAME: ${order.fname}');
    print('LNAME: ${order.lname}');
    print('EMAIL: ${order.email}');
    print('PHONE: ${order.phone}');
    return _sectionCard(
      title: 'customer_information'.tr(),
      child: Column(
        children: [
          _detailRow(
            icon: Icons.person_outline,
            title: 'name'.tr(),
            value: '${order.fname ?? ''} ${order.lname ?? ''}'.trim().isEmpty
                ? '-'
                : '${order.fname ?? ''} ${order.lname ?? ''}'.trim(),
          ),

          Gap( 12.h),

          _detailRow(
            icon: Icons.email_outlined,
            title: 'email'.tr(),
            value: order.email ?? '-',
          ),

          Gap( 12.h),

          _detailRow(
            icon: Icons.phone_outlined,
            title: 'phone'.tr(),
            value: order.phone ?? '-',
          ),

          Gap( 12.h),

          _detailRow(
            icon: Icons.location_on_outlined,
            title: 'city'.tr(),
            value: order.city ?? '-',
          ),

          Gap( 12.h),

          _detailRow(
            icon: Icons.home_outlined,
            title: 'address'.tr(),
            value: order.address ?? '-',
          ),
        ],
      ),
    );
  }
}