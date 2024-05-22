import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/recipe_controller/recipe_controller.dart';
class CategoryItem extends StatefulWidget {
  const CategoryItem({Key? key}) : super(key: key);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  int selectedIndex = 0;
  RecipeController _recipeController=Get.put(RecipeController());

  List<String> categoryList = [
    "All",
    "Vegetarian",
    "Vegan",
    "Gluten-Free",
    "Paleo",
    "Keto",
    "Low-Carb",
    "Dairy-Free",
    "Nut-Free",
  ];


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          categoryList.length,
              (index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });

                _recipeController.getDataByCat(categoryList[selectedIndex]);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: index == selectedIndex ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  categoryList[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
