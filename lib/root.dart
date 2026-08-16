import 'package:aycel/features/cart/views/cart_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'core/constant/app_assets.dart';
import 'features/auth/views/profile_view.dart';

import 'features/cart/data/cart_rebo.dart';
import 'features/cart/data/cubit/cart_cubit.dart';
import 'features/home/data/cubit/home_cubit.dart';
import 'features/home/views/home_view.dart';
import 'features/trake_order/views/track_order_view.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  late final PageController _pageController;

  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeView(),
    CartView(),
    TrackOrderView(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changePage(int index) {
    setState(() => _currentIndex = index);

    if (index == 0) {
      context.read<HomeCubit>().getHomeData();
    }
    if(index == 1){
      context.read<CartCubit>().getCartData();
    }
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(24);

    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: const Color(0xffF8F8F8),

        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _screens,
        ),

        bottomNavigationBar: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(radius),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(radius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: NavigationBar(
                height: 72,
                elevation: 0,
                backgroundColor: Colors.white,
                selectedIndex: _currentIndex,
                indicatorColor: Colors.grey.shade400,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                onDestinationSelected: _changePage,
                destinations: [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'home'.tr(),
                  ),
                  NavigationDestination(
                    icon: Icon(CupertinoIcons.cart),
                    selectedIcon: Icon(CupertinoIcons.cart_fill),
                    label: 'cart'.tr(),
                  ),
                  NavigationDestination(
                    icon: SvgPicture.asset(
                      AppAssets.track_order,
                      width: 20,
                      height: 20,
                    ),
                    selectedIcon: SvgPicture.asset(
                      AppAssets.track_order_fill,
                      width: 20,
                      height: 20,
                    ),
                    label: 'order_track'.tr(),
                  ),

                  NavigationDestination(
                    icon: Icon(CupertinoIcons.person),
                    selectedIcon: Icon(CupertinoIcons.person_fill),
                    label: 'profile'.tr(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
