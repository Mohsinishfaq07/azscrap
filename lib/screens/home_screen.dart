import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../Provider/Categories Provider.dart';
import '../Provider/Scrap Provider.dart';
import '../Provider/User Provider.dart';
import '../constants.dart';
import '../model/Scrap_model.dart';
import 'bottom_navigation_bar.dart';
import 'complete_profile.dart';

class HomeScreen extends StatefulWidget {
  final String jwtToken;
  final String number;
  int check1;

  HomeScreen(
      {Key? key,
      required this.jwtToken,
      required this.number,
      required this.check1})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool is_registred = false;
  bool dailog = false;
  bool image_check = false;
  bool show_error = false;
  String ApiError = "";
  int moveToNext = 1;
  double _width = 90.w;
  double _height = 28.h;
  double sub_ctg_height = 0;
  String? city;
  String number = "";
  String weightUnit = "Per Ton";
  String category = "";
  int indx = 1;
  String subCategory = "";

  // String sub_ctg_icon = "";
  List<String> items2 = [
    'Abu Dhabi',
    'Dubai',
    'Sharjah',
    'Ras Al-Khaimah',
    'Fujairah',
    'Umm Al Quwain',
    'Ajman',
  ];
  List<String> items1 = [
    'Per Ton',
    'Don\'t Know',
  ];

  // final _titleKey = GlobalKey<FormState>();
  final _descriptionKey = GlobalKey<FormState>();
  final _weightKey = GlobalKey<FormState>();

  // final _priceKey = GlobalKey<FormState>();
  final _numberKey = GlobalKey<FormState>();
  final _addressKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController price = TextEditingController();

  // TextEditingController number = TextEditingController();
  // TextEditingController city = TextEditingController();
  TextEditingController address = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  Map images_url = {};
  XFile? scrap_img1;
  XFile? scrap_img2;
  XFile? scrap_img3;
  XFile? scrap_img4;
  bool image_loading = false;
  bool Ctg_loading = false;
  bool weight_edit = true;
  var ref;

  void verification_dailogbox() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.18,
              child: Padding(
                padding: EdgeInsets.all(5.sp),
                child: Container(
                  // height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.sp),
                          child: Text(
                            'You are not registered yet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 7.sp),
                                child: Text(
                                  'Later'.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue[800]),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
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
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CompleteProfile(
                                          user_number: widget.number,
                                          JWToken: widget.jwtToken,
                                        )));
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green[800]),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 7.sp),
                                child: Text(
                                  'Register'.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void didChangeDependencies() async {
    setState(() {
      number = widget.number;
      Ctg_loading = true;
    });
    if (widget.check1 == 1) {
      final user =
          Provider.of<UserProvider>(context, listen: false).items;
      is_registred = user[0].is_registered;
      await Provider.of<CategoriesProvider>(context, listen: false)
          .FetchCategories(widget.jwtToken);
      await Provider.of<ScrapProvider>(context, listen: false)
          .FetchScrap(widget.number, widget.jwtToken);

      if (is_registred == false) {
        Future.delayed(const Duration(seconds: 1), () {
          verification_dailogbox();
        });
      }
    }
    setState(() {
      widget.check1 = 2;
      Ctg_loading = false;
    });
    // super.mounted;
  }

  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = XFile(photo.path);
      final image_indx = imageFileList!.length;
      print(image_indx);
      print(image_indx);
      setState(() {
        imageFileList!.insert(image_indx, tempImage);
      });
      // setState(() {
      //   imageFileList![image_indx] = tempImage;
      //   // if (scrap_img1 == null){
      //   //   scrap_img1 = tempImage;
      //   //   imageFileList = [tempImage];
      //   // }else if (scrap_img2 == null){
      //   //   scrap_img2 = tempImage;
      //   //   imageFileList = [scrap_img1!, tempImage];
      //   // }else if (scrap_img3 == null){
      //   //   scrap_img3 = tempImage;
      //   //   imageFileList = [scrap_img1!, scrap_img2!, tempImage];
      //   // }else {
      //   //   scrap_img4 = tempImage;
      //   //   imageFileList = [scrap_img1!, scrap_img2!, scrap_img3!, tempImage];
      //   //   // chose_photo_dailogbox();
      //   // }
      // });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      setState(() {
        imageFileList!.addAll(selectedImages);
      });
    }
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
            .child('${widget.number}')
            .child('${DateTime.now()}_image_${i}.jpg');
        await ref.putFile(File(imageFileList![i].path));
        images_url[i] = await ref.getDownloadURL();
        print("Image Url No: ${i}: ");
        print(images_url[i]);
        // hashMap.set(`image${i}`, images_url[i])
        // initState() {
        //   // TODO: implement initState
        //   super.initState();
        //
        // }
      }
      // images_url = image_urlMap.values.toList();
    }
    setState(() {
      image_loading = false;
    });
    imageFileList!.clear();
  }

  @override
  Widget build(BuildContext context) {
    final ctgData = Provider.of<CategoriesProvider>(context);
    final cetagories = ctgData.items;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF4271B7),
        title: const Text(
          "Sell",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        height: 90.h,
        width: 100.w,
        // color: Colors.red,
        child: Stack(
          // alignment: Alignment.bottomCenter,
          children: [
            Ctg_loading
                ? const CircularProgressIndicator()
                : SizedBox(
                    height: 80.h,
                    width: 100.w,
                    child: GridView.builder(
                        physics: const ScrollPhysics(),
                        padding: EdgeInsets.only(
                            top: 120.sp, left: 20.sp, right: 20.sp),
                        // shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 1.1,
                            crossAxisSpacing: 14.sp,
                            mainAxisSpacing: 14.sp),
                        itemCount: cetagories.length,
                        // itemCount: 4,
                        itemBuilder: (BuildContext ctx, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                dailog = true;
                                category = cetagories[index].catg_name;
                                indx = index;
                                if (cetagories[index].sub_categories.length <=
                                    3) {
                                  _height = 40.h;
                                  sub_ctg_height = 26.h;
                                } else if (cetagories[indx]
                                        .sub_categories
                                        .length <=
                                    6) {
                                  _height = 41.h;
                                  sub_ctg_height = 28.h;
                                } else if (cetagories[indx]
                                        .sub_categories
                                        .length <=
                                    9) {
                                  _height = 55.h;
                                  sub_ctg_height = 42.h;
                                } else if (cetagories[indx]
                                        .sub_categories
                                        .length <=
                                    12) {
                                  _height = 66.h;
                                  sub_ctg_height = 52.h;
                                }
                              });
                            },
                            child: Container(
                                alignment: Alignment.bottomCenter,
                                margin: const EdgeInsets.only(top: 10),
                                // width: MediaQuery.of(context).size.width / 2.3,
                                decoration: BoxDecoration(
                                    color: Color(0xFFF1F2F3),
                                    border: Border.all(
                                        color: Color(0xFFD1D3D4), width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 12.h,
                                            width: 24.w,
                                            // color: Colors.red,
                                            child: Image.network(
                                              cetagories[index].catg_img,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12.sp,
                                          ),
                                          Text(
                                            cetagories[index].catg_name,
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        }),
                  ),
            if (dailog == true)
              Align(
                alignment: Alignment.center,
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      height: _height,
                      width: _width,
                      // height: move_next == 1? 30.h : 60.h,
                      // width: 92.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    dailog = false;
                                    moveToNext = 1;
                                    _height = 28.h;
                                    title.clear();
                                    description.clear();
                                    weight.clear();
                                    price.clear();
                                    address.clear();
                                    city = null;
                                    imageFileList!.clear();
                                    images_url.clear();
                                  });
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.grey[500],
                                ),
                                iconSize: 25.0,
                              ),
                            ),
                            if (moveToNext == 1)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Text(
                                  "Choose The Metal",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18.sp, color: kPrimaryColor),
                                ),
                              ),
                            // if (move_next == 2)
                            //   Padding(
                            //     padding: EdgeInsets.symmetric(horizontal: 5.w),
                            //     child: Text("Add a suitable title for your material", textAlign: TextAlign.center,
                            //       style: TextStyle(fontSize: 18.sp, color: kPrimaryColor, fontWeight: FontWeight.w500),
                            //     ),
                            //   ),
                            if (moveToNext == 3)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Text(
                                  "Add a description for your scrap",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            if (moveToNext == 4)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Text(
                                  "Add Total Weight for your material",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            // if (move_next == 5)
                            //   Padding(
                            //     padding: EdgeInsets.symmetric(horizontal: 5.w),
                            //     child: Text("How much would you like to sell your material for", textAlign: TextAlign.center,
                            //       style: TextStyle(fontSize: 18.sp, color: kPrimaryColor, fontWeight: FontWeight.w500),
                            //     ),
                            //   ),
                            if (moveToNext == 6)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Text(
                                  "Please add your phone number here for the means of contact",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            if (moveToNext == 7)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Text(
                                  "Post Clear Picture of your material",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            if (moveToNext == 8)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Text(
                                  "Please provide your address for the inspection of your material",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            if (moveToNext == 9)
                              Image.asset(
                                'assets/confirm.png',
                                height: 60,
                                width: 60,
                              ),
                            SizedBox(height: 2.h),
                            if (moveToNext == 1)
                              Container(
                                // duration: Duration(seconds: 2),
                                height: sub_ctg_height,
                                width: 90.w,
                                color: Colors.white,
                                child: GridView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount:
                                      cetagories[indx].sub_categories.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 1.sp,
                                    mainAxisSpacing: 1.sp,
                                    childAspectRatio: 0.75.sp,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          moveToNext = 3;
                                          _height = 44.h;
                                          // move_next = 2;
                                          // _height = 35.h;
                                          // _width = 90.w;
                                          subCategory = cetagories[indx]
                                              .sub_categories[index]
                                              .subcatg_Name;
                                          // sub_ctg_icon = cetagories[indx].sub_categories[index].subcatg_icon;
                                        });
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10.0),
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.blueAccent
                                                    .withOpacity(0.3)),
                                            child: Image.network(
                                                cetagories[indx]
                                                    .sub_categories[index]
                                                    .subcatg_icon),
                                          ),
                                          SizedBox(
                                            height: 4.sp,
                                          ),
                                          Text(
                                            cetagories[indx]
                                                .sub_categories[index]
                                                .subcatg_Name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                // child: ListView.builder(
                                //   padding: EdgeInsets.symmetric(horizontal: 11.sp),
                                //   scrollDirection: Axis.horizontal,
                                //     itemCount: 3,
                                //     // itemCount: cetagories[indx].sub_categories.length,
                                //     itemBuilder: (BuildContext context,int index){
                                //       return GestureDetector(
                                //         onTap: () {
                                //           setState(() {
                                //             move_next = 3;
                                //             _height = 44.h;
                                //             // move_next = 2;
                                //             // _height = 35.h;
                                //             // _width = 90.w;
                                //             sub_category = cetagories[indx].sub_categories[index].subcatg_Name;
                                //             sub_ctg_icon = cetagories[indx].sub_categories[index].subcatg_icon;
                                //           });
                                //         },
                                //         child: Container(
                                //           margin: EdgeInsets.symmetric(horizontal: 12.sp),
                                //           child:   Column(
                                //                   children: [
                                //                    Container(
                                //                         padding: EdgeInsets.all(10.0),
                                //                         height: 70,
                                //                         width: 70,
                                //                         decoration: BoxDecoration(
                                //                             borderRadius:
                                //                                 BorderRadius.circular(10),
                                //                             color: Colors.blueAccent.withOpacity(0.3)),
                                //                         child: Image.asset(
                                //                             cetagories[indx].sub_categories[index].subcatg_icon),
                                //                       ),
                                //                     SizedBox(
                                //                       height: 5,
                                //                     ),
                                //                     Text(
                                //                       cetagories[indx].sub_categories[index].subcatg_Name,
                                //                       style: TextStyle(
                                //                           fontSize: 18, color: Colors.black),
                                //                     )
                                //                   ],
                                //                 ),
                                //         ),
                                //       );
                                //     }
                                // ),
                              ),
                            // if (move_next == 2)
                            //   Padding(
                            //     padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
                            //     child: Form(
                            //       key: _titleKey,
                            //       child: TextFormField(
                            //         validator: (value) {
                            //           if (value == null || value.isEmpty) {
                            //             return 'Please enter suitable title';
                            //           }
                            //           return null;
                            //         },
                            //         controller: title,
                            //         keyboardType: TextInputType.text,
                            //         autofocus: true,
                            //         maxLines: 1,
                            //         style: TextStyle(fontSize: 16),
                            //         decoration: InputDecoration(
                            //           hintText: 'e.g 10 top copper for sale',
                            //           filled: true,
                            //           fillColor: Colors.grey[200],
                            //           enabledBorder: OutlineInputBorder(
                            //               borderSide: BorderSide(color: Colors.white),
                            //               borderRadius: BorderRadius.circular(15)),
                            //           focusedBorder: OutlineInputBorder(
                            //               borderSide: BorderSide(color: Colors.blue),
                            //               borderRadius: BorderRadius.circular(15)),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            if (moveToNext == 3)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Form(
                                  key: _descriptionKey,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter description for your scrap';
                                      }
                                      return null;
                                    },
                                    controller: description,
                                    keyboardType: TextInputType.text,
                                    autofocus: true,
                                    maxLines: 5,
                                    style: const TextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                      hintText:
                                          'e.g 12 kg pure copper or aluminium',
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              const BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              const BorderSide(color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  ),
                                ),
                              ),
                            if (moveToNext == 4)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.sp),
                                child: Container(
                                  height: 7.h,
                                  width: 95.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 7.h,
                                        width: 48.w,
                                        child: Center(
                                          child: Form(
                                            key: _weightKey,
                                            child: TextFormField(
                                              // validator: (value) {
                                              //   if (value == '0' ||
                                              //       value == '00' ||
                                              //       value == '000' ||
                                              //       value == '0000' ||
                                              //       value == '00000' ||
                                              //       value == '000000' ||
                                              //       value == '0000000' ||
                                              //       value == '00000000' ||
                                              //       value == '000000000' ||
                                              //       value == '0000000000') {
                                              //     return 'Please enter valid weight';
                                              //   }
                                              //   if (value == null ||
                                              //       value.isEmpty &&
                                              //           weight_edit == true) {
                                              //     setState(() {
                                              //       weight_edit == false;
                                              //     });
                                              //     return 'Enter weight of your material';
                                              //   }
                                              //
                                              //   if (weight_edit == false) {
                                              //     return 'Please Enter Valid Weight';
                                              //   }
                                              //   return null;
                                              // },
                                              controller: weight,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                              autofocus: true,
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 18),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 5.sp,
                                                        vertical: 0.sp),
                                                enabled: weight_edit,
                                                // filled: true,
                                                // fillColor: Colors.blue[200],
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7.h,
                                        width: 35.w,
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
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ))
                                                  .toList(),
                                              value: weightUnit,
                                              onChanged: (value) {
                                                setState(() {
                                                  weightUnit = value as String;
                                                  if (weightUnit ==
                                                      'Don\'t Know') {
                                                    weight_edit = false;
                                                    weight.clear();
                                                  } else {
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
                                                color: Colors.grey[200],
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
                              ),
                            if (show_error == true && moveToNext == 4)
                              Container(
                                width: 80.w,
                                child: Text(
                                  "Please enter valid weight",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            // if (move_next == 5)
                            //   Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 10),
                            //     child: Form(
                            //       key: _priceKey,
                            //       child: TextFormField(
                            //         validator: (value) {
                            //           if (value == null || value.isEmpty) {
                            //             return 'Please enter price of your material';
                            //           }
                            //           return null;
                            //         },
                            //         controller: price,
                            //         keyboardType: TextInputType.number,
                            //         autofocus: true,
                            //         maxLines: 1,
                            //         style: TextStyle(fontSize: 18),
                            //         decoration: InputDecoration(
                            //           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            //           hintText: 'e.g 1100',
                            //           filled: true,
                            //           fillColor: Colors.grey[200],
                            //           enabledBorder: OutlineInputBorder(
                            //               borderSide: BorderSide(color: Colors.white),
                            //               borderRadius: BorderRadius.circular(15)),
                            //           focusedBorder: OutlineInputBorder(
                            //               borderSide: BorderSide(color: Colors.blue),
                            //               borderRadius: BorderRadius.circular(15)),
                            //           suffixIcon: Padding(
                            //             padding: EdgeInsets.symmetric(vertical: 5.sp),
                            //             child: DropdownButtonHideUnderline(
                            //               child: DropdownButton<String>(
                            //                 borderRadius: BorderRadius.circular(15),
                            //                 autofocus: true,
                            //                 isDense: false,
                            //                 value: dropdownValue2,
                            //                 // icon: const Icon(Icons.arrow_downward),
                            //                 elevation: 4,
                            //                 style: TextStyle(color: Colors.orange[700], fontSize: 18),
                            //                 // underline: Container(
                            //                 //   height: 2,
                            //                 //   color: Colors.deepPurpleAccent,
                            //                 // ),
                            //                 onChanged: (String? newValue) {
                            //                   setState(() {
                            //                     dropdownValue2 = newValue!;
                            //                     // Navigator.pop(context);
                            //                     // weight_of_material_dailogbox();
                            //                   });
                            //                 },
                            //                 items: <String>['AED LS', 'AED TON', 'AED KG', 'don\'t know']
                            //                     .map<DropdownMenuItem<String>>((String value) {
                            //                   return DropdownMenuItem<String>(
                            //                     value: value,
                            //                     child: Text(value),
                            //                   );
                            //                 }).toList(),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            if (moveToNext == 6)
                              Container(
                                height: 50,
                                margin: EdgeInsets.all(15),
                                width: MediaQuery.of(context).size.width / 1.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                    color: Colors.black45,
                                    width: 1.0,
                                  ),
                                ),
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Form(
                                      key: _numberKey,
                                      child: TextFormField(
                                        initialValue: Provider.of<UserProvider>(
                                                context,
                                                listen: false)
                                            .items[0]
                                            .user_number
                                            .toString(),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your contact number';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          number = value!;
                                        },
                                        // controller: number,
                                        keyboardType: TextInputType.number,
                                        maxLines: 1,
                                        minLines: 1,
                                        autofocus: true,
                                        style: TextStyle(fontSize: 18),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 0),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    )),
                              ),
                            if (moveToNext == 7)
                              Container(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () => showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                contentPadding: EdgeInsets.zero,
                                                content: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.15,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          selectImages();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'From Gallery',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 1.5,
                                                        width: 150,
                                                        color: Colors.black54,
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          pickImage(ImageSource
                                                              .camera);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'From Camera',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 17.h,
                                              width: 34.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(70),
                                                  color: Colors.white),
                                              child: Image.asset(
                                                  'assets/camera_icon.jpg'),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 4.h,
                                              width: 35.w,
                                              decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Upload Picture',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 16.h,
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      decoration: const BoxDecoration(
                                          // border: Border.all(color: Colors.grey, width: 2)
                                          ),
                                      child: image_loading
                                          ? Center(
                                              child: SizedBox(
                                              height: 14.h,
                                              width: 24.w,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: const [
                                                  SpinKitWave(
                                                      color: Colors.blue,
                                                      type: SpinKitWaveType
                                                          .start),
                                                  SizedBox(height: 10),
                                                  Text("Loading",
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18))
                                                ],
                                              ),
                                            ))
                                          : Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: imageFileList!.isEmpty || imageFileList!.length == 0
                                                  ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 13.h,
                                                        width: 35.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: image_check
                                                              ? Colors.redAccent[
                                                                  100]
                                                              : Colors.blueAccent[
                                                                  100],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15),
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons
                                                                .wallpaper_rounded,
                                                            size: 50.sp,
                                                            color: Colors
                                                                .white,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 13.h,
                                                        width: 35.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: image_check
                                                              ? Colors.redAccent[
                                                                  100]
                                                              : Colors.blueAccent[
                                                                  100],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15),
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons
                                                                .wallpaper_rounded,
                                                            size: 50.sp,
                                                            color: Colors
                                                                .white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          imageFileList!.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Container(
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    left: 3,
                                                                    right: 3,
                                                                    top: 5,
                                                                    bottom: 5),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black87),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7),
                                                            ),
                                                            height: 14.h,
                                                            width: 35.w,
                                                            child: Stack(
                                                              children: [
                                                                Positioned(
                                                                  top: 0,
                                                                  bottom: 0,
                                                                  left: 0,
                                                                  right: 0,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6.5),
                                                                    child: Image
                                                                        .file(
                                                                      File(
                                                                        imageFileList![index]
                                                                            .path,
                                                                      ),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      height:
                                                                          14.h,
                                                                      width:
                                                                          35.w,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: -8.sp,
                                                                  // bottom: 0,
                                                                  left: 24.w,
                                                                  // right: 0,
                                                                  child:
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              // Image.file(File(imageFileList![index].path)) == null;
                                                                              imageFileList?.removeAt(index);
                                                                            });
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.clear,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                15.sp,
                                                                          )),
                                                                ),
                                                              ],
                                                            ));
                                                      }),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            if (moveToNext == 8)
                              Form(
                                key: _addressKey,
                                child: Column(
                                  children: [
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        isExpanded: true,
                                        hint: Row(
                                          children: [
                                            const SizedBox(
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
                                            .map((item) =>
                                                DropdownMenuItem<String>(
                                                  value: item.toString(),
                                                  child: Text(
                                                    item.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ))
                                            .toList(),
                                        value: city,
                                        onChanged: (value) {
                                          setState(() {
                                            city = value as String;
                                            // autoF = true;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.arrow_drop_down_rounded,
                                        ),
                                        iconSize: 25,
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.black,
                                        buttonHeight:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        buttonWidth:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        buttonPadding: const EdgeInsets.only(
                                            left: 14, right: 14),
                                        buttonDecoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          color: Colors.white,
                                        ),
                                        buttonElevation: 0,
                                        itemHeight: 40,
                                        itemPadding: const EdgeInsets.only(
                                            left: 14, right: 14),
                                        dropdownMaxHeight: 200,
                                        dropdownWidth: 260,
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
                                        offset: const Offset(10, 10),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter complete address of material';
                                          }
                                          return null;
                                        },
                                        controller: address,
                                        keyboardType: TextInputType.text,
                                        autofocus: false,
                                        maxLines: 3,
                                        style: const TextStyle(fontSize: 16),
                                        decoration: InputDecoration(
                                          hintText:
                                              'e.g Ajman industrial area, metee',
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (moveToNext == 9)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: ApiError != "Some thing went wrong"
                                    ? Text(
                                        "Ticket has been Successfully Submitted",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Text(
                                        "Some thing went wrong please try again",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                              ),
                            SizedBox(
                              height: 3.h,
                            ),
                            if (moveToNext != 1)
                              Row(
                                mainAxisAlignment: moveToNext == 9
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.spaceAround,
                                children: [
                                  if (moveToNext != 9)
                                    ElevatedButton(
                                      onPressed: () {
                                        if (moveToNext == 9) {
                                          setState(() {
                                            moveToNext = 8;
                                            _height = 50.h;
                                          });
                                        } else if (moveToNext == 8) {
                                          setState(() {
                                            moveToNext = 7;
                                            _height = 66.h;
                                          });
                                        } else if (moveToNext == 7) {
                                          setState(() {
                                            moveToNext = 6;
                                            _height = 41.h;
                                          });
                                        } else if (moveToNext == 6) {
                                          setState(() {
                                            moveToNext = 4;
                                            _height = 34.h;
                                          });
                                        }
                                        // else if (move_next == 5){
                                        //    setState(() {
                                        //      move_next = 4;
                                        //      // _height = 44.h;
                                        //    });
                                        //  }
                                        else if (moveToNext == 4) {
                                          setState(() {
                                            moveToNext = 3;
                                            _height = 44.h;
                                          });
                                        } else if (moveToNext == 3) {
                                          setState(() {
                                            moveToNext = 1;
                                            if (cetagories[indx]
                                                    .sub_categories
                                                    .length <=
                                                3) {
                                              _height = 40.h;
                                              sub_ctg_height = 26.h;
                                            } else if (cetagories[indx]
                                                    .sub_categories
                                                    .length <=
                                                6) {
                                              _height = 41.h;
                                              sub_ctg_height = 28.h;
                                            } else if (cetagories[indx]
                                                    .sub_categories
                                                    .length <=
                                                9) {
                                              _height = 55.h;
                                              sub_ctg_height = 42.h;
                                            } else if (cetagories[indx]
                                                    .sub_categories
                                                    .length <=
                                                12) {
                                              _height = 66.h;
                                              sub_ctg_height = 52.h;
                                            }
                                            // move_next = 2;
                                            // _height = 34.h;
                                          });
                                        }
                                        // else if (move_next == 2){
                                        //    setState(() {
                                        //      move_next = 1;
                                        //      _height = 28.h;
                                        //    });
                                        //  }
                                      },
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all(0),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.sp,
                                              horizontal: 0.sp),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.arrow_back_ios_rounded,
                                                color: Colors.blue,
                                              ),
                                              Text(
                                                'Back'.toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )),
                                    ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // if (move_next == 2 && _titleKey.currentState!.validate()){
                                      //   setState(() {
                                      //     move_next = 3;
                                      //     _height = 44.h;
                                      //   });
                                      // }
                                      if (moveToNext == 3 &&
                                          _descriptionKey.currentState!
                                              .validate()) {
                                        setState(() {
                                          moveToNext = 4;
                                          _height = 34.h;
                                        });
                                      } else if (moveToNext == 4) {
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
                                              moveToNext = 6;
                                              _height = 40.h;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            weight = TextEditingController()
                                              ..text = "0";
                                            show_error = false;
                                            moveToNext = 6;
                                            _height = 40.h;
                                          });
                                        }
                                        // setState(() {
                                        //
                                        //   // move_next = 5;
                                        //   // _height = 34.h;
                                        // });
                                      }
                                      // else if (move_next == 5 && _priceKey.currentState!.validate()){
                                      //    setState(() {
                                      //      move_next = 6;
                                      //      _height = 40.h;
                                      //    });
                                      //  }
                                      else if (moveToNext == 6 &&
                                          _numberKey.currentState!.validate()) {
                                        _numberKey.currentState!.save();
                                        setState(() {
                                          moveToNext = 7;
                                          _height = 66.h;
                                        });
                                      } else if (moveToNext == 7) {
                                        if (imageFileList!.isEmpty) {
                                          setState(() {
                                            image_check = true;
                                          });
                                        } else {
                                          await get_images_url();
                                          setState(() {
                                            moveToNext = 8;
                                            _height = 50.h;
                                          });
                                        }
                                      } else if (moveToNext == 8 &&
                                          _addressKey.currentState!
                                              .validate()) {
                                        ApiError =
                                            await Provider.of<ScrapProvider>(
                                                    context,
                                                    listen: false)
                                                .Add_Scrap(
                                          ScrapModel(
                                            scrap_id: null,
                                            scrap_ctg: category,
                                            scrap_sub_ctg: subCategory,
                                            // sub_ctg_icon: sub_ctg_icon,
                                            // scrap_title: title.text,
                                            scrap_description: description.text,
                                            scrap_weight: weight.text,
                                            // scrap_price: double.parse(price.text),
                                            phone_number: number,
                                            scrap_images:
                                                images_url.values.toList(),
                                            scrap_city: city.toString(),
                                            scrap_address: address.text,
                                          ),
                                          widget.number,
                                          widget.jwtToken,
                                        );
                                        setState(() {
                                          moveToNext = 9;
                                          _height = 34.h;
                                        });
                                        setState(() {
                                          if (ApiError ==
                                              "Some thing went wrong") {
                                            ApiError = "Some thing went wrong";
                                          }
                                        });
                                        print(ApiError);
                                        print(ApiError);
                                        print(ApiError);
                                      } else if (moveToNext == 9) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyNavigationBar(
                                                      jwtToken: widget.jwtToken,
                                                      number: widget.number,
                                                      index: 2,
                                                    )));
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue[800]),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12.sp, horizontal: 10.sp),
                                      child: Text(
                                        moveToNext == 9
                                            ? "Tickets"
                                            : 'Next'.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
