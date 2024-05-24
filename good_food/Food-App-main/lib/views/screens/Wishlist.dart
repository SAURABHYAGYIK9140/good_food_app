import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/recipe_controller/recipe_controller.dart';
import '../Widgets/dishwidget.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  RecipeController mainController = Get.put(RecipeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
      ),
      body: Obx(() =>
          mainController.isLoading.value && mainController.wishlist.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: CircularProgressIndicator()))
              : mainController.wishlist.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Text(
                          "No recipes found",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisSpacing: 10.0,
                                maxCrossAxisExtent: 200.0,
                              ),
                              itemCount: mainController.wishlist.length,
                              itemBuilder: (context, index) {
                                return GridTile(
                                  child: RecipieTile(
                                    recipeModel: mainController.wishlist[index],
                                  ),
                                );
                              },
                            ),
                          ),
                          if (mainController.isLoading.value)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    )),
    );
  }
}
