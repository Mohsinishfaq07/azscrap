// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../Provider/Scrap Provider.dart';
import '../constants.dart';
import '../model/Scrap_model.dart';

class EditTicket extends StatefulWidget {
  final String? scrap_id;
  final String JWToken;
  final String Number;

  const EditTicket(
      {Key? key,
      required this.scrap_id,
      required this.JWToken,
      required this.Number})
      : super(key: key);

  @override
  _EditTicketState createState() => _EditTicketState();
}

class _EditTicketState extends State<EditTicket> {
  final _formkey = GlobalKey<FormState>();
  bool is_loading = false;
  bool show_error = false;
  String dropdownValue = 'Per Ton';
  String dropdownValue2 = 'AED LS';
  String? city;
  String ApiStatus = "";
  String weight_unit = "Per Ton";
  final _weightKey = GlobalKey<FormState>();
  List<String> items2 = [
    'Abu Dhabi',
    'Dubai',
    'Sharjah',
    'Ras Al-Khaimah',
    'Fujairah',
    'Umm Al Quwain',
    'Ajman',
  ];

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  TextEditingController weight = TextEditingController();
  Map images_url = {};
  List newUrls = [];
  bool image_loading = false;
  bool weight_edit = true;
  int n = 1;
  var ref;
  List<String> items1 = [
    'Per Ton',
    'Don\'t Know',
  ];
  var _edited_scrap = ScrapModel(
      scrap_id: null,
      scrap_ctg: "",
      scrap_sub_ctg: "",
      // sub_ctg_icon: "",
      // scrap_title: "",
      scrap_description: "",
      scrap_weight: "0",
      // scrap_price: 0,
      phone_number: "0",
      scrap_images: [],
      scrap_city: "",
      scrap_address: "");

  void didChangeDependencies() {
    final scrap_id = widget.scrap_id;
    if (scrap_id != null) {
      _edited_scrap =
          Provider.of<ScrapProvider>(context, listen: false).findById(scrap_id);
      city = _edited_scrap.scrap_city;
      if (n == 1) {
        weight = TextEditingController()..text = _edited_scrap.scrap_weight;
        if (_edited_scrap.scrap_weight == "0") {
          weight_unit = 'Don\'t Know';
          weight_edit = false;
        }
      }
      n++;
    }
  }

  Status_dailogbox() async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              height: 18.h,
              child: Padding(
                padding: EdgeInsets.zero,
                child: Container(
                  height: 17.5.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            ApiStatus == "Successful"
                                ? 'Scrap edited successful'
                                : "Scrap is not edited please try again",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 7.sp, horizontal: 12.sp),
                            child: Text(
                              'Ok'.toUpperCase(),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue[800]),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //
                        //     // ElevatedButton(
                        //     //   onPressed: () {
                        //     //     Navigator.pop(context);
                        //     //     Navigator.of(context).push(MaterialPageRoute(
                        //     //         builder: (context) => CompleteProfile(user_number: number,)));
                        //     //   },
                        //     //   child: Padding(
                        //     //     padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7.sp),
                        //     //     child: Text(
                        //     //       'Verify'.toUpperCase(),
                        //     //       style: TextStyle(fontSize: 20, color: Colors.white),
                        //     //     ),
                        //     //   ),
                        //     //   style: ButtonStyle(
                        //     //     backgroundColor: MaterialStateProperty.all(Colors.green[800]),
                        //     //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        //     //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        //     //       RoundedRectangleBorder(
                        //     //         borderRadius: BorderRadius.circular(25.0),
                        //     //       ),
                        //     //     ),
                        //     //   ),
                        //     // ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
      await get_images_url();
      // setState(() {
      //   _edited_scrap = ScrapModel(
      //     scrap_id: _edited_scrap.scrap_id,
      //     scrap_ctg: _edited_scrap.scrap_ctg,
      //     scrap_sub_ctg: _edited_scrap.scrap_sub_ctg,
      //     // sub_ctg_icon: _edited_scrap.sub_ctg_icon,
      //     // scrap_title: _edited_scrap.scrap_title,
      //     scrap_description: _edited_scrap.scrap_description,
      //     scrap_weight: _edited_scrap.scrap_weight,
      //     // scrap_price: _edited_scrap.scrap_price,
      //     phone_number: _edited_scrap.phone_number,
      //     scrap_images: images_url as List,
      //     // scrap_images: [""],
      //     scrap_city: _edited_scrap.scrap_city,
      //     scrap_address: _edited_scrap.scrap_address,
      //   );
      //   // int c= 0;
      //   // for (int i = _edited_scrap.scrap_images!.length; i < i+imageFileList!.length; i++){
      //   //   _edited_scrap.scrap_images![i].add(imageFileList[c]);
      //   //   c++;
      //   // }
      // });
    }
    // setState((){
    //   // chose_photo_dailogbox();
    // });
  }

  get_images_url() async {
    setState(() {
      image_loading = true;
    });
    if (imageFileList != null) {
      // Map<int, String> image_urlMap = images_url.asMap();
      for (var i = 0; i < imageFileList!.length; i++) {
        print(i);
        ref = await FirebaseStorage.instance
            .ref()
            .child("Scrap_Images")
            .child('${_edited_scrap.phone_number}')
            .child('${DateTime.now()}_image_${i}.jpg');
        await ref.putFile(File(imageFileList![i].path));
        images_url[i] = await ref.getDownloadURL();
        // print("Image Url No: ${i}: ");
        // print(images_url[i]);
        myUrls() {
          return images_url.entries.map((e) => e.value).toList();
        }

        newUrls = myUrls();
        var mergedList = [...?_edited_scrap.scrap_images, ...newUrls].toSet();
        print(mergedList);
        _edited_scrap.scrap_images = mergedList.toList();
      }
      // images_url = image_urlMap.values.toList();
    }
    setState(() {
      image_loading = false;
    });
  }

  // int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: Text(
            'Edit Ticket',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: is_loading
                ? Container(
                    height: 100.h,
                    width: 100.w,
                    child: Center(
                        child: SpinKitCircle(
                      size: 65,
                      color: kPrimaryColor,
                    )))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   child: Padding(
                      //       padding: EdgeInsets.symmetric(horizontal: 5.sp),
                      //       child: Text("Title", style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),)),
                      // ),
                      // Container(
                      //   height: MediaQuery.of(context).size.height*0.07,
                      //   width: MediaQuery.of(context).size.width*0.91,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(15),
                      //     color: Colors.grey[300],
                      //     border: Border.all(width: 1, color: Colors.grey),
                      //   ),
                      //   child: Padding(
                      //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      //     child: Text(
                      //       _edited_scrap.scrap_title,
                      //       style: TextStyle(
                      //         fontSize: 20,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Container(
                              width: 90.w,
                              child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.sp),
                                  child: Text(
                                    "Number",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[400]),
                                  )),
                            ),
                            TextFormField(
                              initialValue:
                                  _edited_scrap.phone_number.toString(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please provide phone number';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _edited_scrap = ScrapModel(
                                  scrap_id: _edited_scrap.scrap_id,
                                  scrap_ctg: _edited_scrap.scrap_ctg,
                                  scrap_sub_ctg: _edited_scrap.scrap_sub_ctg,
                                  // sub_ctg_icon: _edited_scrap.sub_ctg_icon,
                                  // scrap_title: _edited_scrap.scrap_title,
                                  scrap_description:
                                      _edited_scrap.scrap_description,
                                  scrap_weight: _edited_scrap.scrap_weight,
                                  // scrap_price: _edited_scrap.scrap_price,
                                  phone_number: value!,
                                  scrap_images: _edited_scrap.scrap_images,
                                  scrap_city: _edited_scrap.scrap_city,
                                  scrap_address: _edited_scrap.scrap_address,
                                );
                              },
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              minLines: 1,
                              autofocus: false,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                // prefixIcon: Container(
                                //   width: 60,
                                //   child: Row(
                                //     children: [
                                //       SizedBox(
                                //         width: 5,
                                //       ),
                                //       Text(
                                //         '+971',
                                //         style: TextStyle(fontSize: 14),
                                //       ),
                                //       SizedBox(
                                //         width: 15,
                                //       ),
                                //       Container(
                                //         height: 40,
                                //         decoration: BoxDecoration(
                                //             border: Border(
                                //                 right: BorderSide(
                                //                   width: 1,
                                //                   color: Colors.grey,
                                //                 ))),
                                //       )
                                //     ],
                                //   ),
                                // ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 20,
                            // ),
                            // Container(
                            //   width: 90.w,
                            //   child: Padding(
                            //       padding: EdgeInsets.symmetric(horizontal: 5.sp),
                            //       child: Text("Price", style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),)),
                            // ),
                            // TextFormField(
                            //   initialValue: _edited_scrap.scrap_price.toString(),
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Please enter scrap price';
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (value) {
                            //     _edited_scrap = ScrapModel(
                            //       scrap_id: _edited_scrap.scrap_id,
                            //       scrap_ctg: _edited_scrap.scrap_ctg,
                            //       scrap_sub_ctg: _edited_scrap.scrap_sub_ctg,
                            //       sub_ctg_icon: _edited_scrap.sub_ctg_icon,
                            //       scrap_title: _edited_scrap.scrap_title,
                            //       scrap_description: _edited_scrap.scrap_description,
                            //       scrap_weight: _edited_scrap.scrap_weight,
                            //       scrap_price: double.parse(value!),
                            //       phone_number: _edited_scrap.phone_number,
                            //       scrap_images: _edited_scrap.scrap_images,
                            //       scrap_city: _edited_scrap.scrap_city,
                            //       scrap_address: _edited_scrap.scrap_address,
                            //     );
                            //   },
                            //   keyboardType: TextInputType.number,
                            //   maxLines: 1,
                            //   minLines: 1,
                            //   autofocus: false,
                            //   style: TextStyle(fontSize: 18),
                            //   decoration: InputDecoration(
                            //     filled: true,
                            //     fillColor: Colors.grey[300],
                            //     enabledBorder: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(15),
                            //       borderSide: BorderSide(color: Colors.grey),
                            //     ),
                            //     focusedBorder: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(15),
                            //       borderSide: BorderSide(color: Colors.blue),
                            //     ),
                            //     prefixIcon: Container(
                            //       width: 60,
                            //       child: Row(
                            //         children: [
                            //           Icon(Icons.arrow_drop_down_sharp),
                            //           Text(
                            //             'LS',
                            //             style: TextStyle(fontSize: 14),
                            //           ),
                            //           SizedBox(
                            //             width: 15,
                            //           ),
                            //           Container(
                            //             height: 40,
                            //             decoration: BoxDecoration(
                            //                 border: Border(
                            //                     right: BorderSide(
                            //                       width: 1,
                            //                       color: Colors.grey,
                            //                     ))),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     suffixIcon: Padding(
                            //       padding: EdgeInsets.symmetric(vertical: 5.sp),
                            //       child: DropdownButtonHideUnderline(
                            //         child: DropdownButton<String>(
                            //           borderRadius: BorderRadius.circular(15),
                            //           autofocus: true,
                            //           isDense: false,
                            //           value: dropdownValue2,
                            //           // icon: const Icon(Icons.arrow_downward),
                            //           elevation: 4,
                            //           style: TextStyle(color: Colors.orange[700], fontSize: 14.sp),
                            //           onChanged: (String? newValue) {
                            //             setState(() {
                            //               dropdownValue2 = newValue!;
                            //             });
                            //           },
                            //           items: <String>['AED LS', 'AED TON', 'AED KG', 'don\'t know']
                            //               .map<DropdownMenuItem<String>>((String value) {
                            //             return DropdownMenuItem<String>(
                            //               value: value,
                            //               child: Text(value),
                            //             );
                            //           }).toList(),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 90.w,
                              child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.sp),
                                  child: Text(
                                    "Description",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[400]),
                                  )),
                            ),
                            TextFormField(
                              initialValue: _edited_scrap.scrap_description,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please write the description of the scrap';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _edited_scrap = ScrapModel(
                                  scrap_id: _edited_scrap.scrap_id,
                                  scrap_ctg: _edited_scrap.scrap_ctg,
                                  scrap_sub_ctg: _edited_scrap.scrap_sub_ctg,
                                  // sub_ctg_icon: _edited_scrap.sub_ctg_icon,
                                  // scrap_title: _edited_scrap.scrap_title,
                                  scrap_description: value!,
                                  scrap_weight: _edited_scrap.scrap_weight,
                                  // scrap_price: _edited_scrap.scrap_price,
                                  phone_number: _edited_scrap.phone_number,
                                  scrap_images: _edited_scrap.scrap_images,
                                  scrap_city: _edited_scrap.scrap_city,
                                  scrap_address: _edited_scrap.scrap_address,
                                );
                              },
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              maxLines: 4,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(15)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 90.w,
                              child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.sp),
                                  child: Text(
                                    "Weight",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[400]),
                                  )),
                            ),
                            Container(
                              height: 7.h,
                              width: 95.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 7.h,
                                    width: 48.w,
                                    child: Center(
                                      child: Form(
                                        key: _weightKey,
                                        child: TextFormField(
                                          // validator: (value) {
                                          //   if (weight_edit == true){
                                          //     if (value == '0' ||
                                          //         value == '00' ||
                                          //         value == '000' ||
                                          //         value == '0000' ||
                                          //         value == '00000' ||
                                          //         value == '000000' ||
                                          //         value == '0000000' ||
                                          //         value == '00000000' ||
                                          //         value == '000000000' ||
                                          //         value == '0000000000' || value!.isEmpty) {
                                          //       return 'Please enter valid weight';
                                          //     }
                                          //   }
                                          //   return null;
                                          // },
                                          controller: weight,
                                          onSaved: (value) {
                                            _edited_scrap = ScrapModel(
                                              scrap_id: _edited_scrap.scrap_id,
                                              scrap_ctg:
                                                  _edited_scrap.scrap_ctg,
                                              scrap_sub_ctg:
                                                  _edited_scrap.scrap_sub_ctg,
                                              // sub_ctg_icon: _edited_scrap.sub_ctg_icon,
                                              // scrap_title: _edited_scrap.scrap_title,
                                              scrap_description: _edited_scrap
                                                  .scrap_description,
                                              scrap_weight: weight.text,
                                              // scrap_price: _edited_scrap.scrap_price,
                                              phone_number:
                                                  _edited_scrap.phone_number,
                                              scrap_images:
                                                  _edited_scrap.scrap_images,
                                              scrap_city:
                                                  _edited_scrap.scrap_city,
                                              scrap_address:
                                                  _edited_scrap.scrap_address,
                                            );
                                          },
                                          keyboardType: TextInputType.number,
                                          autofocus: false,
                                          maxLines: 1,
                                          // initialValue: _edited_scrap.scrap_weight,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: weight.text == "0" &&
                                                      weight_edit == false
                                                  ? Colors.grey[300]
                                                  : Colors.black),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 5.sp,
                                                    vertical: 0.sp),
                                            // hintText: _edited_scrap.scrap_weight,
                                            enabled: weight_edit,
                                            // filled: true,
                                            // fillColor: Colors.blue[200],
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 7.h,
                                    width: 35.w,
                                    color: Colors.grey[300],
                                    child: Padding(
                                      padding: EdgeInsets.zero,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          isExpanded: true,
                                          // hint: Row(
                                          //   children: [
                                          //     SizedBox(
                                          //       width: 4,
                                          //     ),
                                          //     Expanded(
                                          //       child: Text(
                                          //         ' Select State',
                                          //         style: TextStyle(
                                          //           fontSize: 18,
                                          //           fontWeight: FontWeight.w400,
                                          //           color: Colors.grey[600],
                                          //         ),
                                          //         overflow: TextOverflow.ellipsis,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // items: demoCtg.
                                          items: items1
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item.toString(),
                                                    child: Text(
                                                      item.toString(),
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: weight_unit,
                                          onChanged: (value) {
                                            setState(() {
                                              weight_unit = value as String;
                                              if (weight_unit ==
                                                  'Don\'t Know') {
                                                weight_edit = false;
                                                weight = TextEditingController()
                                                  ..text = "0";
                                              } else {
                                                setState(() {
                                                  weight =
                                                      TextEditingController()
                                                        ..text = _edited_scrap
                                                            .scrap_weight;
                                                });
                                                weight_edit = true;
                                              }
                                              // autoF = true;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.arrow_drop_down_rounded,
                                          ),
                                          iconSize: 23,
                                          iconEnabledColor: Colors.black,
                                          iconDisabledColor: Colors.black,
                                          buttonHeight: 7.h,
                                          buttonWidth: 35.w,
                                          buttonPadding: EdgeInsets.only(
                                              left: 5.sp, right: 5.sp),
                                          buttonDecoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: Colors.grey[300],
                                          ),
                                          buttonElevation: 0,
                                          itemHeight: 4.4.h,
                                          itemPadding: EdgeInsets.only(
                                              left: 8.sp, right: 5.sp),
                                          dropdownMaxHeight: 200,
                                          dropdownWidth: 32.w,
                                          dropdownPadding: null,
                                          dropdownDecoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: Colors.white,
                                          ),
                                          dropdownElevation: 2,
                                          scrollbarRadius:
                                              const Radius.circular(40),
                                          scrollbarThickness: 6,
                                          scrollbarAlwaysShow: true,
                                          offset: const Offset(4, 10),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            if (show_error == true)
                              Container(
                                width: 85.w,
                                child: Text(
                                  "Please enter valid weight",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 90.w,
                              child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.sp),
                                  child: Text(
                                    "City",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[400]),
                                  )),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        ' Select State',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                // items: demoCtg.
                                items: items2
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.toString(),
                                          child: Text(
                                            item.toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: city,
                                onChanged: (value) {
                                  setState(() {
                                    city = value as String;
                                    _edited_scrap = ScrapModel(
                                      scrap_id: _edited_scrap.scrap_id,
                                      scrap_ctg: _edited_scrap.scrap_ctg,
                                      scrap_sub_ctg:
                                          _edited_scrap.scrap_sub_ctg,
                                      // sub_ctg_icon: _edited_scrap.sub_ctg_icon,
                                      // scrap_title: _edited_scrap.scrap_title,
                                      scrap_description:
                                          _edited_scrap.scrap_description,
                                      scrap_weight: _edited_scrap.scrap_weight,
                                      // scrap_price: _edited_scrap.scrap_price,
                                      phone_number: _edited_scrap.phone_number,
                                      scrap_images: _edited_scrap.scrap_images,
                                      scrap_city: city!,
                                      scrap_address:
                                          _edited_scrap.scrap_address,
                                    );
                                  });
                                },
                                icon: Icon(
                                  Icons.arrow_drop_down_rounded,
                                ),
                                iconSize: 25,
                                iconEnabledColor: Colors.black,
                                iconDisabledColor: Colors.black,
                                buttonHeight: 7.5.h,
                                buttonWidth: 95.w,
                                buttonPadding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                buttonDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  color: Colors.grey[300],
                                ),
                                buttonElevation: 0,
                                itemHeight: 40,
                                itemPadding:
                                    EdgeInsets.only(left: 12.sp, right: 12.sp),
                                dropdownMaxHeight: 200,
                                dropdownWidth: 260,
                                dropdownPadding: null,
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.grey[100],
                                ),
                                dropdownElevation: 2,
                                scrollbarRadius: const Radius.circular(40),
                                scrollbarThickness: 6,
                                scrollbarAlwaysShow: true,
                                offset: const Offset(10, 10),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 90.w,
                              child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.sp),
                                  child: Text(
                                    "Address",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[400]),
                                  )),
                            ),
                            TextFormField(
                              initialValue: _edited_scrap.scrap_address,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter complete address of your scrap';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _edited_scrap = ScrapModel(
                                  scrap_id: _edited_scrap.scrap_id,
                                  scrap_ctg: _edited_scrap.scrap_ctg,
                                  scrap_sub_ctg: _edited_scrap.scrap_sub_ctg,
                                  // sub_ctg_icon: _edited_scrap.sub_ctg_icon,
                                  // scrap_title: _edited_scrap.scrap_title,
                                  scrap_description:
                                      _edited_scrap.scrap_description,
                                  scrap_weight: _edited_scrap.scrap_weight,
                                  // scrap_price: _edited_scrap.scrap_price,
                                  phone_number: _edited_scrap.phone_number,
                                  scrap_images: _edited_scrap.scrap_images,
                                  scrap_city: _edited_scrap.scrap_city,
                                  scrap_address: value!,
                                );
                              },
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              maxLines: 4,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(15)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: 90.w,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.sp),
                            child: Text(
                              "Pictures",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.grey[400]),
                            )),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1.5, color: Colors.black87),
                        ),
                        child: image_loading
                            ? Center(
                                child: Container(
                                height: 14.h,
                                width: 24.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SpinKitWave(
                                        color: Colors.blue,
                                        type: SpinKitWaveType.start),
                                    SizedBox(height: 10),
                                    Text("Loading",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18))
                                  ],
                                ),
                              ))
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _edited_scrap.scrap_images!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      margin: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.black87),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 0,
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6.5),
                                              child: Image.network(
                                                _edited_scrap
                                                    .scrap_images![index],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: -8.sp,
                                            // bottom: 0,
                                            left: 20.w,
                                            // right: 0,
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    // Image.file(File(imageFileList![index].path)) == null;
                                                    _edited_scrap.scrap_images
                                                        ?.removeAt(index);
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.clear,
                                                  color: Colors.red,
                                                  size: 15.sp,
                                                )),
                                          ),
                                        ],
                                      ));
                                }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: TextButton(
                            onPressed: () => selectImages(),
                            child: Text(
                              'Add Picture',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue[800],
                                  decoration: TextDecoration.underline),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (weight_edit == true) {
                              if (weight.text == '0' ||
                                  weight.text == "00" ||
                                  weight.text == "000" ||
                                  weight.text == "0000" ||
                                  weight.text == "00000" ||
                                  weight.text == "000000" ||
                                  weight.text == "0000000" ||
                                  weight.text == "00000000" ||
                                  weight.text == "000000000" ||
                                  weight.text == "0000000000" ||
                                  weight.text.isEmpty) {
                                setState(() {
                                  show_error = true;
                                });
                              } else {
                                setState(() {
                                  show_error = false;
                                });
                              }
                            }
                            if (_formkey.currentState!.validate() &&
                                _weightKey.currentState!.validate() &&
                                show_error == false) {
                              setState(() {
                                is_loading = true;
                              });
                              _formkey.currentState!.save();
                              _weightKey.currentState!.save();
                              ApiStatus = await Provider.of<ScrapProvider>(
                                      context,
                                      listen: false)
                                  .UpdateScrap(_edited_scrap.scrap_id,
                                      _edited_scrap, widget.JWToken);
                              setState(() {
                                if (ApiStatus == "Successful") {
                                  ApiStatus = "Successful";
                                }
                              });
                              print(ApiStatus);
                              print(ApiStatus);
                              print(ApiStatus);
                              await Status_dailogbox();
                              setState(() {
                                is_loading = false;
                              });
                              // Navigator.pop(context);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 23),
                            child: Text(
                              'upload'.toUpperCase(),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue[800]),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
