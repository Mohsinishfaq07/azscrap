import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../model/Scrap_model.dart';

class ScrapProvider with ChangeNotifier {
  List<ScrapModel> _items = [];

  List<ScrapModel> get items {
    return _items;
  }

  Future FetchScrap(String number, String token) async {
    try {
      http.Response response = await http.get(
        Uri.parse(
            'https://masterdata.azscrap.com/master-data/api/user/get-all-scrap/${number}'),
        headers: {
          "x-access-token": token,
        },
        // body:  json.encode({
        //   'phoneNumber': "0383748377",
        //   'sessionInfo': "this is token info",
        // }),
      );
      List ScrapRes;
      List Scrap_imgs = [];
      Map ScrapList = json.decode(response.body);
      ScrapRes = ScrapList['data'];
      List<ScrapModel> Scraps = [];
      for (int s = 0; s < ScrapRes.length; s++) {
        Scrap_imgs = ScrapRes[s]["scrap_images"];
        // print(Scrap_imgs);
        ScrapModel scrap = ScrapModel(
          scrap_id: ScrapRes[s]["_id"],
          scrap_ctg: ScrapRes[s]["scrap_ctg"],
          scrap_sub_ctg: ScrapRes[s]["scrap_sub_ctg"],
          scrap_description: ScrapRes[s]["scrap_description"],
          scrap_weight: ScrapRes[s]["scrap_weight"],
          phone_number: ScrapRes[s]["user_number"],
          scrap_price: double.parse(ScrapRes[s]["scrap_price"].toString()),
          scrap_images: Scrap_imgs,
          // scrap_images: ["",""],
          scrap_city: ScrapRes[s]["scrap_city"],
          scrap_address: ScrapRes[s]["scrap_address"],
          status: ScrapRes[s]["status"],
          is_accepted: ScrapRes[s]["isAccepted"],
          is_sold: ScrapRes[s]["sold"],
          TimeStamp: ScrapRes[s]["timeStamp"],
        );
        Scraps.add(scrap);
        // print(ScrapRes[s]["scrap_images"]);
      }
      _items = Scraps;

      // final ScrapData = Map<String, dynamic>.from(ScrapList);
      // final List <ScrapModel> loadedScrap = [];
      // loadedScrap.add(ScrapModel(
      //     scrap_id: ScrapData[1]("_id"),
      //     scrap_ctg: ScrapData[1]("scrap_ctg"),
      //     scrap_sub_ctg: ScrapData[1]("scrap_sub_ctg"),
      //     scrap_description: ScrapData[1]("scrap_description"),
      //     scrap_weight: ScrapData[1]("scrap_weight"),
      //     phone_number: ScrapData[1]("user_number"),
      //     scrap_images: ScrapData[1]("scrap_images"),
      //     scrap_city: ScrapData[1]("scrap_city"),
      //     scrap_address: ScrapData[1]("scrap_address"),
      // ));
      // _items = loadedScrap;
      notifyListeners();
      print("The fetch scrap API response start from here");
      print(json.decode(response.body)['statusMsg']);
      print(json.decode(response.body)['statusCode']);
      // print((response.body));
      // print(json.decode(response.body));
      // print(json.decode(response.body)['data']);
    } catch (error) {
      print(error);
    }
  }

  // Add_Scrap(ScrapModel scraps, String Number, String Token) async {
  //  var _arr = ['a','b','c'];
  //   // var map = new Map<String, dynamic>();
  //   // // map['scrap_id'] = DateTime.now().toString();
  //   // map['scrap_ctg'] = scraps.scrap_ctg;
  //   // map['scrap_sub_ctg'] = scraps.scrap_sub_ctg;
  //   // map['sub_ctg_icon'] = "asdf";
  //   // // map['scrap_id'] = scraps.scrap_title,
  //   // map['scrap_description'] = scraps.scrap_description;
  //   // map['scrap_weight'] = scraps.scrap_weight;
  //   // // map['scrap_id'] = scraps.scrap_price,
  //   // map['user_number'] = scraps.phone_number;
  //   // // map['scrap_images'] = scraps.scrap_images;
  //   // map['scrap_images'] = _arr.toString();
  //   // map['scrap_city'] = scraps.scrap_city;
  //   // map['scrap_address'] = scraps.scrap_address;
  //   // map['status'] = "true";
  //   // map['isAccepted'] = "true";
  //   // map['timeStamp'] = "12-02-2023";
  //
  //
  //   http.Response response = await http.post(
  //     Uri.parse('http://192.168.0.106:3001/api/user/add-scrap'),
  //     headers: {
  //       "x-access-token": Token,
  //     },
  //     body: json.encode(
  //         {
  //           'scrap_ctg' : scraps.scrap_ctg,
  //           'scrap_sub_ctg' : scraps.scrap_sub_ctg,
  //           'sub_ctg_icon' : "asdf",
  //           // map['scrap_id'] : scraps.scrap_title,
  //           'scrap_description' : scraps.scrap_description,
  //           'scrap_weight' : scraps.scrap_weight,
  //           // map['scrap_id'] = scraps.scrap_price,
  //           'user_number' : scraps.phone_number,
  //           // map['scrap_images'] = scraps.scrap_images;
  //           'scrap_images' : "dsd",
  //           'scrap_city' : scraps.scrap_city,
  //           'scrap_address' : scraps.scrap_address,
  //           'status' : "true",
  //           'isAccepted' : "true",
  //           'timeStamp' : "12-02-2023",
  //         },
  //     ),
  //   );
  //   print(response.body);
  //   print(json.decode(response.body)['statusMsg']);
  //   print(json.decode(response.body)['statusCode']);
  //   print(json.decode(response.body)['data']);
  //   print("This is the scrap id:");
  //   print(json.decode(response.body)['data']["_id"]);
  //   if (json.decode(response.body)['statusCode'] == 200){
  //     final newscrap = ScrapModel(
  //       scrap_id: json.decode(response.body)['data']["_id"],
  //       scrap_ctg: scraps.scrap_ctg,
  //       scrap_sub_ctg: scraps.scrap_sub_ctg,
  //       // sub_ctg_icon: scraps.sub_ctg_icon,
  //       // scrap_title: scraps.scrap_title,
  //       scrap_description: scraps.scrap_description,
  //       scrap_weight: scraps.scrap_weight,
  //       // scrap_price: scraps.scrap_price,
  //       phone_number: scraps.phone_number,
  //       scrap_images: scraps.scrap_images,
  //       scrap_city: scraps.scrap_city,
  //       scrap_address: scraps.scrap_address,
  //     );
  //     _items.add(newscrap);
  //     notifyListeners();
  //   }
  //   return json.decode(response.body)['statusCode'] == 200 ? "Ticket add succecc fully" : "Some thing went wrong";
  //   // notifyListeners();
  // }

  Add_Scrap(ScrapModel scraps, String Number, String Token) async {
    bool chakc = true;
    //
    // var map = new Map<String, dynamic>();
    // // map['scrap_id'] = DateTime.now().toString();
    // map['scrap_ctg'] = scraps.scrap_ctg;
    // map['scrap_sub_ctg'] = scraps.scrap_sub_ctg;
    // map['sub_ctg_icon'] = "asdf";
    // // map['scrap_id'] = scraps.scrap_title,
    // map['scrap_description'] = scraps.scrap_description;
    // map['scrap_weight'] = scraps.scrap_weight;
    // // map['scrap_id'] = scraps.scrap_price,
    // map['user_number'] = scraps.phone_number;
    // // map['scrap_images'] = scraps.scrap_images;
    // map['scrap_images'] = List<dynamic>.from(_arr.map((x) => x));
    // map['scrap_city'] = scraps.scrap_city;
    // map['scrap_address'] = scraps.scrap_address;
    // map['status'] = "true";
    // map['isAccepted'] = "true";
    // map['timeStamp'] = "12-02-2023";
    // var _arr = ['img1','img2','img3'];
    Map<String, dynamic> map;
    map = {
      'scrap_ctg': scraps.scrap_ctg,
      'scrap_sub_ctg': scraps.scrap_sub_ctg,
      'sub_ctg_icon': "asdf",
      'scrap_description': scraps.scrap_description,
      "scrap_weight": scraps.scrap_weight,
      "user_number": scraps.phone_number,
      "scrap_city": scraps.scrap_city,
      "scrap_address": scraps.scrap_address,
      // "status" : "true",
      //  "isAccepted" : chakc.toString(),
      "timeStamp": "12-02-2023"
    };
    for (int i = 0; i < scraps.scrap_images!.length; i++) {
      map.addAll({"scrap_images[$i]": scraps.scrap_images![i]});
    }

    http.Response response = await http.post(
      Uri.parse('https://tickets.azscrap.com/tickets/api/user/add-scrap'),
      headers: {
        "x-access-token": Token,
      },
      body: map,
      // Map<String, dynamic> tojson()=>
      //  {
      //    'scrap_ctg' : "jidjf",
      //    'scrap_sub_ctg' : "kdhfihd",
      //    'sub_ctg_icon' : "asdf",
      //    'scrap_description' : "isjd",
      //    "scrap_weight" : "23",
      //    "user_number" : "38947562947",
      //    "scrap_images" : ["dfd","dfdf"],
      //    "scrap_city" : "dosjfo",
      //    "scrap_address" : "jeojf",
      //    "status" : "true",
      //    "isAccepted" : "true",
      //    "timeStamp" : "12-02-2023"
      //  },

      // {
      //   'scrap_ctg' : scraps.scrap_ctg,
      //   'scrap_sub_ctg' : scraps.scrap_sub_ctg,
      //   'sub_ctg_icon' : "asdf",
      //   // map['scrap_id'] : scraps.scrap_title,
      //   'scrap_description' : scraps.scrap_description,
      //   'scrap_weight' : scraps.scrap_weight,
      //   // map['scrap_id'] = scraps.scrap_price,
      //   'user_number' : scraps.phone_number,
      //   // map['scrap_images'] = scraps.scrap_images;
      //   'scrap_images' : ['asd','adf'],
      //   'scrap_city' : scraps.scrap_city,
      //   'scrap_address' : scraps.scrap_address,
      //   'status' : "true",
      //   'isAccepted' : "true",
      //   'timeStamp' : "12-02-2023",
      // },
    );
    print(response.body);
    print(json.decode(response.body)['statusMsg']);
    print(json.decode(response.body)['statusCode']);
    print(json.decode(response.body)['data']);
    print("This is the scrap id:");
    print(json.decode(response.body)['data']["_id"]);
    if (json.decode(response.body)['statusCode'] == 200) {
      final newscrap = ScrapModel(
        scrap_id: json.decode(response.body)['data']["_id"],
        scrap_ctg: scraps.scrap_ctg,
        scrap_sub_ctg: scraps.scrap_sub_ctg,
        // sub_ctg_icon: scraps.sub_ctg_icon,
        // scrap_title: scraps.scrap_title,
        scrap_description: scraps.scrap_description,
        scrap_weight: scraps.scrap_weight,
        // scrap_price: scraps.scrap_price,
        phone_number: scraps.phone_number,
        scrap_images: scraps.scrap_images,
        scrap_city: scraps.scrap_city,
        scrap_address: scraps.scrap_address,
        TimeStamp: DateTime.now().toString(),
      );
      _items.add(newscrap);
      notifyListeners();
    }
    return json.decode(response.body)['statusCode'] == 200
        ? "Ticket add succecc fully"
        : "Some thing went wrong";
    // notifyListeners();
  }

  ScrapModel findById(String id) {
    return _items.firstWhere((prod) => prod.scrap_id == id);
  }

  UpdateScrap(String? id, ScrapModel newScrap, String Token) async {
    final prodIndex = _items.indexWhere((prod) => prod.scrap_id == id);
    if (prodIndex >= 0) {
      Map<String, dynamic> map;
      // var map = new Map<String, dynamic>();
      // map['scrap_id'] = DateTime.now().toString();
      map = {
        'scrap_ctg': newScrap.scrap_ctg,
        'scrap_sub_ctg': newScrap.scrap_sub_ctg,
        'sub_ctg_icon': "asdf",
        // map['scrap_id'] = scraps.scrap_title,
        'scrap_description': newScrap.scrap_description,
        'scrap_weight': newScrap.scrap_weight,
        // map['scrap_id'] = scraps.scrap_price,
        'user_number': newScrap.phone_number,
        // map['scrap_images'] = scraps.scrap_images;
        // map['scrap_images'] = "List of images";
        'scrap_city': newScrap.scrap_city,
        'scrap_address': newScrap.scrap_address,
        //map['status'] = "true";
        //map['isAccepted'] = "true";
      };
      for (int i = 0; i < newScrap.scrap_images!.length; i++) {
        map.addAll({"scrap_images[$i]": newScrap.scrap_images![i]});
      }

      http.Response response = await http.post(
        Uri.parse(
            'https://tickets.azscrap.com/tickets/api/user/edit-scrap/${id}'),
        headers: {
          "x-access-token": Token,
        },
        body: map,
        // body:  json.encode({
        //   'phoneNumber': "0383748377",
        //   'sessionInfo': "this is token info",
        // }),
      );
      print(response.body);
      print(json.decode(response.body)['statusMsg']);
      print(json.decode(response.body)['statusCode']);
      print(json.decode(response.body)['data']);
      if (json.decode(response.body)['statusCode'] == 200) {
        _items[prodIndex] = newScrap;
        notifyListeners();
      }
      return json.decode(response.body)['statusCode'] == 200
          ? "Successful"
          : "Unsuccessful";
    } else {
      print('...');
    }
  }

  List<ScrapModel> un_sold() {
    List<ScrapModel> Un_Sold = [];
    if (_items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        if (_items[i].is_sold == false) {
          Un_Sold.add(_items[i]);
        }
      }
    }
    return Un_Sold;
  }

  List<ScrapModel> sold_ticket() {
    List<ScrapModel> Solds_Scrap = [];
    if (_items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        if (_items[i].is_sold == true) {
          Solds_Scrap.add(_items[i]);
        }
      }
    }
    return Solds_Scrap;
  }

  accept_scrap(String scrap_id, String JWToken) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
          'https://masterdata.azscrap.com/master-data/api/user/accept-scrap/$scrap_id',
        ),
        headers: {
          "x-access-token": JWToken,
        },
        // body:  json.encode({
        //   'phoneNumber': "0383748377",
        //   'sessionInfo': "this is token info",
        // }),
      );
      print(response.body);
      print(json.decode(response.body)['statusMsg']);
      json.decode(response.body)['statusCode'];
      json.decode(response.body)['statusMsg'];
      print(json.decode(response.body)['data']);
      // print("id:"+ id);
      // saveId(id);

      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => HomeScreen()));
    } catch (error) {
      print(error);
    }
  }
}
