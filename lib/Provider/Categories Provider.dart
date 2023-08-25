import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../model/Categories_model.dart';
import '../model/SubCategories_model.dart';

class CategoriesProvider with ChangeNotifier {
  List<CategoriesModel> _items = [];
  // List<categoriesModel> _items = [
  //   categoriesModel(
  //     catg_id: DateTime.now().toString(),
  //     catg_name: 'E-Waste',
  //     sub_categories: [
  //       Sub_categoriesModel(
  //           subcatg_Name: "Mix-E-waste Lot",
  //           subcatg_icon: 'assets/mix e waste lot.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Desktop", subcatg_icon: 'assets/desktop.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Server", subcatg_icon: 'assets/aluminium.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Electronics Board",
  //           subcatg_icon: 'assets/electric board.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Power Supply",
  //           subcatg_icon: 'assets/power supply.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Processors", subcatg_icon: 'assets/aluminium.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Graphic Card",
  //           subcatg_icon: 'assets/graphics-card.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "HardDisk", subcatg_icon: 'assets/hard-drive.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "RAM", subcatg_icon: 'assets/ram.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Toner & Catridgers",
  //           subcatg_icon: 'assets/aluminium.png'),
  //     ],
  //     catg_img: "assets/e_waste.png",
  //   ),
  //   categoriesModel(
  //     catg_id: DateTime.now().toString(),
  //     catg_name: 'Mix Scrap',
  //     sub_categories: [
  //       Sub_categoriesModel(
  //           subcatg_Name: "Miscellaneous",
  //           subcatg_icon: 'assets/miscellaneous.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Mix Scrap Lot",
  //           subcatg_icon: 'assets/mix_scrap.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Transformer",
  //           subcatg_icon: 'assets/transformer.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Power Cable",
  //           subcatg_icon: 'assets/power-cable.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Chiller / AC", subcatg_icon: 'assets/AC.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Motor", subcatg_icon: 'assets/electric-motor.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Generator's", subcatg_icon: 'assets/generator.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Batteries", subcatg_icon: 'assets/bettries.png'),
  //     ],
  //     catg_img: "assets/mix_scrap.png",
  //   ),
  //   categoriesModel(
  //     catg_id: DateTime.now().toString(),
  //     catg_name: 'Metals',
  //     sub_categories: [
  //       Sub_categoriesModel(
  //           subcatg_Name: "Copper", subcatg_icon: 'assets/copper_icon.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Iron", subcatg_icon: 'assets/iron_icon.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "GI Metal", subcatg_icon: 'assets/iron_icon.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Aluminium", subcatg_icon: 'assets/aluminium.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Stainless Steel",
  //           subcatg_icon: 'assets/stainless.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Nickel", subcatg_icon: 'assets/nickel.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Rhodium", subcatg_icon: 'assets/rhodium.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Titanium", subcatg_icon: 'assets/titanium.png'),
  //     ],
  //     catg_img: "assets/metal.png",
  //   ),
  //   categoriesModel(
  //     catg_id: DateTime.now().toString(),
  //     catg_name: 'Plastic-Recycling',
  //     sub_categories: [
  //       Sub_categoriesModel(
  //           subcatg_Name: "Mix-Plastic Lot",
  //           subcatg_icon: 'assets/plastic recycle.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "PVC", subcatg_icon: 'assets/pvc.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "ABS", subcatg_icon: 'assets/abs.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "HDPE", subcatg_icon: 'assets/hdpe.png'),
  //       Sub_categoriesModel(subcatg_Name: "PP", subcatg_icon: 'assets/pp.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "LDPE", subcatg_icon: 'assets/polyethylene-film.png'),
  //       Sub_categoriesModel(subcatg_Name: "PS", subcatg_icon: 'assets/ps.png'),
  //       Sub_categoriesModel(subcatg_Name: "PE", subcatg_icon: 'assets/pe.png'),
  //     ],
  //     catg_img: "assets/plastic_recycling.png",
  //   ),
  //   categoriesModel(
  //     catg_id: DateTime.now().toString(),
  //     catg_name: 'Telecommunication',
  //     sub_categories: [
  //       Sub_categoriesModel(
  //           subcatg_Name: "Exchange", subcatg_icon: 'assets/copper_icon.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "RRU/RRH", subcatg_icon: 'assets/iron_icon.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Antenna", subcatg_icon: 'assets/iron_icon.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Circuits Board",
  //           subcatg_icon: 'assets/aluminium.png'),
  //     ],
  //     catg_img: "assets/telecommunication.png",
  //   ),
  //   categoriesModel(
  //     catg_id: DateTime.now().toString(),
  //     catg_name: 'Precious-Metals',
  //     sub_categories: [
  //       Sub_categoriesModel(
  //           subcatg_Name: "Gold", subcatg_icon: 'assets/copper_icon.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "silver", subcatg_icon: 'assets/copper_icon.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Platinum", subcatg_icon: 'assets/copper_icon.png'),
  //       Sub_categoriesModel(
  //           subcatg_Name: "Palladium", subcatg_icon: 'assets/copper_icon.png'),
  //     ],
  //     catg_img: 'assets/perecious_metal.png',
  //   ),
  // ];

  List<CategoriesModel> get items {
    return _items;
  }

  Future FetchCategories(String token) async {
    try {
      http.Response response = await http.get(
        Uri.parse(
            'https://masterdata.azscrap.com/master-data/api/user/get-all-categories'),
        headers: {
          "x-access-token": token,
        },
      );
      List CtgRes;
      List SubCtg = [];
      Map CtgList = await json.decode(response.body);
      CtgRes = CtgList['data'];
      List<CategoriesModel> Cetagories = [];
      for (int s = 0; s < CtgRes.length; s++) {
        List<Sub_categoriesModel> Sub_Cetagories = [];
        // Sub_Cetagories.clear();
        SubCtg = CtgRes[s]["sub_categories"];
        for (int x = 0; x < SubCtg.length; x++) {
          Sub_categoriesModel sub_ctgs = Sub_categoriesModel(
            subcatg_Name: SubCtg[x]["sub_category_name"],
            subcatg_icon: SubCtg[x]["sub_category_icon"],
          );
          Sub_Cetagories.add(sub_ctgs);
        }
        // SubCtg.clear();
        CategoriesModel cetagories = CategoriesModel(
          catg_id: CtgRes[s]["_id"],
          catg_name: CtgRes[s]["category_name"],
          catg_img: CtgRes[s]["category_icon"],
          sub_categories: Sub_Cetagories,
        );
        Cetagories.add(cetagories);
        // Sub_Cetagories.clear();
        // Sub_Cetagories.clear();
        //   // print(ScrapRes[s]["scrap_images"]);
      }
      _items = Cetagories;

      print("The fetch categories API response start from here");
      // print((response.body));
      print(json.decode(response.body)['statusMsg']);
      print(json.decode(response.body)['statusCode']);
      // notifyListeners();
      // print(json.decode(response.body)['data']);
    } catch (error) {
      print(error);
    }
  }
}
