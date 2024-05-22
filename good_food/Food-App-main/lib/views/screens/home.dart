import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants/AppConstraints.dart';
import '../../controllers/ConnectivityController.dart';
import '../../controllers/recipe_controller/recipe_controller.dart';
import '../../models/recipe_model.dart';
import '../Widgets/Categoryitem.dart';
import '../Widgets/dishwidget.dart';
import '../screens/recipe_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import 'Wishlist.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipies = [];
  late String ingridients;
  bool _loading = false;
  String query = "";
  TextEditingController textEditingController = new TextEditingController();
  RecipeController mainController = Get.put(RecipeController());
  final ScrollController _scrollController = ScrollController();

  // final controller = Get.find<ConnectivityController>();

  @override
  void initState() {
    super.initState();

    if (mainController.isConnected.value) {
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final snackBar = SnackBar(
          content: const Text(
              'No Internet , Please check your internet connection.'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // Code to execute when the action is pressed
            },
          ),
        );

        // Show the SnackBar using the ScaffoldMessenger
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          mainController.getDataByCatByPage();
        }
      }
    });
  }

  Future<bool> checkConnectivity() async {
    bool isConnected = false; // Correct the type to `bool`

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      isConnected = false; // Use assignment operator
      Get.snackbar('No Internet', 'Please check your internet connection.', backgroundColor: Colors.red, // Change this to the desired color
        colorText: Colors.white,);
    } else {
      isConnected = true; // Use assignment operator
    }

    return isConnected; // Return `isConnected` directly
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    print("HomePage: didPopNext (returned from next page)");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: () {
            Get.to(Wishlist());
          },
          child: Text("See your wishlist")),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xff213A50), const Color(0xff071930)],
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomLeft,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 45,
                      left: 15,
                      right: 15,
                    ),
                    child: Text(
                      " Good Food 🥄🥣 ",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Overpass',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 2,
                      left: 15,
                      right: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: kIsWeb
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          " Recipe  ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Overpass',
                          ),
                        ),
                        Text(
                          "Finder App",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontFamily: 'Overpass',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      left: 20,
                      right: 20,
                    ),
                    child: const Text(
                      "What will you cook today?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Overpass',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      left: 20,
                      right: 20,
                    ),
                    child: const Text(
                      "Just Enter Ingredients you have and we will show the best recipe for you",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'OverpassRegular',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      left: 20,
                      right: 20,
                    ),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              onChanged: (value) {
                                if (value.length > 1) {
                                  mainController
                                      .getDataByCat(textEditingController.text);
                                }
                              },
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Overpass',
                              ),
                              decoration: InputDecoration(
                                suffix: InkWell(
                                    onTap: () {
                                      textEditingController.clear();
                                    },
                                    child: Icon(
                                      CupertinoIcons.multiply,
                                      color: Colors.white,
                                    )),
                                hintText: "Enter Ingredients",
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.5),
                                  fontFamily: 'Overpass',
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          InkWell(
                            onTap: () async {
                              if (textEditingController.text.isNotEmpty) {
                                mainController
                                    .getDataByCat(textEditingController.text);
                              } else {
                                print("not doing it");
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xffA2834D),
                                    const Color(0xffBC9A5F)
                                  ],
                                  begin: FractionalOffset.topRight,
                                  end: FractionalOffset.bottomLeft,
                                ),
                              ),
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.search,
                                      size: 18, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  CategoryItem(),
                  SizedBox(height: 25),
                  Obx(() => mainController.isLoading.value &&
                          mainController.allrecipe.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(child: CircularProgressIndicator()))
                      : mainController.allrecipe.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 150),
                                child: Text(
                                  "No recipes found",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
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
                                      controller: _scrollController,
                                      gridDelegate:
                                          SliverGridDelegateWithMaxCrossAxisExtent(
                                        mainAxisSpacing: 10.0,
                                        maxCrossAxisExtent: 200.0,
                                      ),
                                      itemCount:
                                          mainController.allrecipe.length,
                                      itemBuilder: (context, index) {
                                        return GridTile(
                                          child: RecipieTile(
                                            recipeModel:
                                                mainController.allrecipe[index],
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
