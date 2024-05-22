import 'package:Good_food/utils/route_pages/page_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect.dart';
import 'package:get/get.dart';

import '../../binding/recipe_binding/recipe_binding.dart';
import '../../binding/splash_binding/SplashBinding.dart';
import '../../views/screens/SplashPage.dart';
import '../../views/screens/Wishlist.dart';
import '../../views/screens/home.dart';
import '../../views/screens/recipe_view.dart';

class MyPages
{
  static List<GetPage> get list => [
    GetPage(
        name: MyPagesName.splashFile,
        page: () => SplashPage(),
        binding: SplashBinding()),
    GetPage(
        name: MyPagesName.homescreen,
        page: () => Home(),
      binding: RecipeBinding()
    ),
    GetPage(
        name: MyPagesName.recipefullview,
        page: () => RecipeView(),
    ),
    GetPage(
        name: MyPagesName.wishlist,
        page: () => Wishlist(),
    )

  ];
}