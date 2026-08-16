import 'package:aycel/features/home/data/models/slider_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared_widgets/loadin_widget.dart';

class SliderWidget extends StatelessWidget {
  SliderWidget({super.key, required this.sliders});

  final List<SliderModel> sliders;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 400.h,
      child: CarouselSlider(
        items: sliders
            .map(
              (slider) => CachedNetworkImage(
                imageUrl: slider.image,
                width: double.infinity,
                fit: BoxFit.fill,
                placeholder: (context, url) => const Center(
                  child: LoadinWidget(),
                ),
                errorWidget: (context, url, error) {
                  return const Icon(Icons.broken_image);
                },
              ),
            )
            .toList(),
        options: CarouselOptions(
          height: 520.h,
          viewportFraction: 1,
          enlargeCenterPage: false,
          autoPlay: true,
        ),
      ),
    );
  }
}
