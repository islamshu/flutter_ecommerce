import 'package:aycel/features/product/data/cubit/favorite_cubit.dart';
import 'package:aycel/features/product/data/cubit/favorite_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagesWidget extends StatelessWidget {
  const ImagesWidget({
    super.key,
    required this.image,
    this.onFavorite, required this.productId,
  });
  final int productId;
  final String image;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 400.h,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(),
          child:GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return Dialog(
                    backgroundColor: Colors.black,
                    insetPadding: EdgeInsets.zero,
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) {
                          return const Icon(
                            Icons.error,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                return const Icon(Icons.error);
              },
            ),
          ),
        ),

        BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {

            final cubit = context.read<FavoriteCubit>();
            final fav = cubit.isFavorite(productId);

            final loading =
                state is FavoriteLoading && state.productId == productId;

            return Positioned(
              top: 20.h,
              left: 10.w,
              child: GestureDetector(
                onTap: loading ? null : () => cubit.toggle(productId),
                child: Container(
                  width: 35.w,
                  height: 35.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: loading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CupertinoActivityIndicator(),
                    )
                        : Icon(
                      fav
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      color: fav ? Colors.red : Colors.black87,
                      size: fav ? 28.sp : 20.sp,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}