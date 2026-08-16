import 'package:aycel/features/auth/data/auth_repo.dart';
import 'package:aycel/features/auth/data/cubit/order_cubit/order_cubit.dart';
import 'package:aycel/features/auth/data/cubit/wishlist_cubit/wishlist_cubit.dart';
import 'package:aycel/features/auth/data/order_repo.dart';
import 'package:aycel/features/auth/data/wishlist_repo.dart';
import 'package:aycel/features/auth/views/edit_password.dart';
import 'package:aycel/features/auth/views/edit_profile.dart';
import 'package:aycel/features/auth/views/login_view.dart';
import 'package:aycel/features/auth/views/orders_view.dart';
import 'package:aycel/features/auth/views/profile_view.dart';
import 'package:aycel/features/auth/views/register_view.dart';
import 'package:aycel/features/auth/views/wishlist_view.dart';
import 'package:aycel/features/cart/data/cubit/cart_cubit.dart';
import 'package:aycel/features/cart/views/cart_view.dart';
import 'package:aycel/features/categories/data/cats_rebo.dart';
import 'package:aycel/features/checkout/data/checkout_repo.dart';
import 'package:aycel/features/checkout/data/cubit/checkout_cubit.dart';
import 'package:aycel/features/checkout/views/checkout_step_two.dart';
import 'package:aycel/features/checkout/views/checkout_view.dart';
import 'package:aycel/features/home/views/home_view.dart';
import 'package:aycel/features/order/order_view.dart';
import 'package:aycel/features/product/data/cart_product_repo.dart';
import 'package:aycel/features/product/data/cubit/cart_product_cubit.dart';
import 'package:aycel/features/product/data/cubit/product_cubit.dart';
import 'package:aycel/features/trake_order/data/cubit/track_cubit.dart';
import 'package:aycel/features/trake_order/data/track_repo.dart';
import 'package:aycel/features/trake_order/views/track_order_view.dart';
import 'package:aycel/root.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/cubit/auth_cubit.dart';
import '../../features/cart/data/cart_rebo.dart';
import '../../features/categories/data/cubit/cat_cubit.dart';
import '../../features/checkout/data/order_model.dart';
import '../../features/home/data/cubit/home_cubit.dart';
import '../../features/home/data/home_repo.dart';
import '../../features/categories/views/categories_products_view.dart';
import '../../features/product/data/product_repo.dart';
import '../../features/product/views/product_view.dart';
import '../../splash.dart';
import 'app_routes.dart';

class RouterGeneration {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // ====== Splash ======
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (context, state) => const Splash(),
      ),

      // ====== Auth Routes ======
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        builder: (context, state) => BlocProvider(
          create: (_) => AuthCubit(authRepo: AuthRepo()),
          child: const LoginView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.register,
        builder: (context, state) => BlocProvider(
          create: (_) => AuthCubit(authRepo: AuthRepo()),
          child: const RegisterView(),
        ),
      ),

      // ====== Home Routes ======
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: AppRoutes.cart,
        name: AppRoutes.cart,
        builder: (context, state) => BlocProvider(
          create: (_) => CartCubit(cartRepo: CartRepo())..getCartData(),
          child: const CartView(),
        ),
      ),

      GoRoute(
        path: AppRoutes.root,
        name: AppRoutes.root,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => HomeCubit(homeRepo: HomeRepo())..getHomeData(),
              ),
              BlocProvider(
                create: (_) => CartCubit(cartRepo: CartRepo())..getCartData(),
              ),
              BlocProvider(create: (_) => TrackCubit(trackRepo: TrackRepo())),
              BlocProvider(
                create: (_) => AuthCubit(authRepo: AuthRepo())..getProfile(),
                child: const ProfileView(),
              ),
            ],
            child: const RootView(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.product,
        name: AppRoutes.product,
        builder: (context, state) {
          final int productId = state.extra as int;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    ProductCubit(productRepo: ProductRepo())
                      ..getProduct(productId),
              ),
              BlocProvider(
                create: (_) => CartProductCubit(cartRepo: CartProductRepo()),
              ),
            ],
            child: const ProductView(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.cat_product,
        name: AppRoutes.cat_product,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => CatCubit(catsRepo: CatsRebo())..getCategories(),
            ),
          ],
          child: const CategoriesProductsView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        name: AppRoutes.checkout,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              CheckoutCubit(checkoutRepo: CheckoutRepo())..getCheckout(),
          child: const CheckoutView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.checkout_tow,
        name: AppRoutes.checkout_tow,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              CheckoutCubit(checkoutRepo: CheckoutRepo())..getCheckout(),
          child: const CheckoutStepTwo(),
        ),
      ),
      GoRoute(
        path: AppRoutes.order,
        name: AppRoutes.order,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          final order = extra['order'] as OrderModel;
          final isNew = extra['isNew'] as bool;
          return OrderView(order: order, isNew: isNew);
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: AppRoutes.editProfile,
        builder: (context, state) => BlocProvider(
          create: (_) => AuthCubit(authRepo: AuthRepo())..getProfile(),
          child: const EditProfile(),
        ),
      ),
      GoRoute(
        path: AppRoutes.editPassword,
        name: AppRoutes.editPassword,
        builder: (context, state) => BlocProvider(
          create: (_) => AuthCubit(authRepo: AuthRepo()),
          child: EditPassword(),
        ),
      ),
      GoRoute(
        path: AppRoutes.wishlist,
        name: AppRoutes.wishlist,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              WishlistCubit(wishlistRepo: WishlistRepo())..getProducts(),
          child: const WishlistView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.orders,
        name: AppRoutes.orders,
        builder: (context, state) => BlocProvider(
          create: (_) => OrderCubit(orderRepo: OrderRepo())..getOrders(),
          child: const OrdersView(),
        ),
      ),
    ],
  );
}
