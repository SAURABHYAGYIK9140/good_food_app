import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/recipe_model.dart';
import '../../services/Api.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class RecipeController extends GetxController {
  var allrecipe = <RecipeModel>[].obs;
  var wishlist = <RecipeModel>[].obs;
  var isLoading = true.obs;
  var isConnected = true.obs;
  int from = 0;
  int to = 10;
  String selectCat = "indian";

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
    getDataByCat(selectCat);
  }

  void loadWishlist() {
    var box = Hive.box<RecipeModel>('wishlist');
    wishlist.assignAll(box.values.toList());
  }

  // bool isRecipeInWishlist(String label) {
  //   var box = Hive.box<RecipeModel>('wishlist');
  //   return box.values.any((recipe) => recipe.label == label);
  // }
  bool isRecipeInWishlist(String label) {
    return wishlist.any((recipe) => recipe.label == label);
  }
  void addToWishlist(RecipeModel recipe) {
    var box = Hive.box<RecipeModel>('wishlist');
    box.add(recipe);
    wishlist.add(recipe);
  }

  void removeFromWishlist(RecipeModel recipe) {
    var box = Hive.box<RecipeModel>('wishlist');
    var key = box.keys.firstWhere((k) => box.get(k) == recipe, orElse: () => null);
    if (key != null) {
      box.delete(key);
      wishlist.remove(recipe);
    }
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      isConnected.value = false;
      Get.snackbar('No Internet', 'Please check your internet connection.');
    } else {
      isConnected.value = true;
    }
    // print("connectivityResult"+isConnected.value.toString());

  }

  Future<void> getDataByCat(String catname) async {
    await checkConnectivity();

    if (!isConnected.value) {
      return;
    }

    if (catname == 'all') {
      catname = "Indian";
    }
    selectCat = catname;
    isLoading.value = true;
    allrecipe.clear();
    from = 0;
    to = 10;

    http.Response response = await MyApi.getRecipeData(catname, from: from, to: to);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      jsonData["hits"].forEach((element) {
        RecipeModel recipeModel = RecipeModel.fromMap(element['recipe']);
        allrecipe.add(recipeModel);
      });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
    isLoading.value = false;
  }

  Future<void> getDataByCatByPage() async {
    await checkConnectivity();

    if (!isConnected.value) {
      return;
    }

    from += 10;
    to += 10;
    isLoading.value = true;

    print("toandfrom" + from.toString() + "-" + to.toString());
    http.Response response = await MyApi.getRecipeData(selectCat, from: from, to: to);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      jsonData["hits"].forEach((element) {
        RecipeModel recipeModel = RecipeModel.fromMap(element['recipe']);
        allrecipe.add(recipeModel);
      });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
    isLoading.value = false;
  }

}
