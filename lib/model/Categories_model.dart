import 'package:flutter/material.dart';

import 'SubCategories_model.dart';

class CategoriesModel {
  final String catg_id;
  final String catg_name;
  final String catg_img;
  final List<Sub_categoriesModel> sub_categories;

  CategoriesModel({
  required this.catg_id,
    required this.catg_name,
    required this.catg_img,
    required this.sub_categories,
});

}
