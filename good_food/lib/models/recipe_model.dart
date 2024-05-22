import 'package:hive/hive.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

part 'recipe_model.g.dart';

@HiveType(typeId: 0)
class RecipeModel extends HiveObject {
  @HiveField(0)
  final String label;

  @HiveField(1)
  final String image;

  @HiveField(2)
  final String source;

  @HiveField(3)
  final String url;

  RecipeModel({
    required this.label,
    required this.image,
    required this.source,
    required this.url,
  });

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      label: map['label'],
      image: map['image'],
      source: map['source'],
      url: map['url'],
    );
  }
}
