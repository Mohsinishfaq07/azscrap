import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Provider/User Provider.dart';
import '../constants.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({Key? key}) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).items;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text("User Detail"),
        centerTitle: true,
      ),
      body: Container(
        height: 100.h,
        width: 100.w,
        // color: Colors.grey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: 90.w,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Text(
                      "Name",
                      style:
                          TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    )),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.91,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[300],
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    user[0].user_name.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: 90.w,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Text(
                      "Email",
                      style:
                          TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    )),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.91,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[300],
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    user[0].user_email.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: 90.w,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Text(
                      "Number",
                      style:
                          TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    )),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.91,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[300],
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    user[0].user_number.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: 90.w,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Text(
                      "Company",
                      style:
                          TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    )),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.91,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[300],
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    user[0].company.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: 90.w,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Text(
                      "Trade License Number",
                      style:
                          TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    )),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.91,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[300],
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    user[0].trade_license_number.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: 90.w,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Text(
                      "TRN Number",
                      style:
                          TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    )),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.91,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[300],
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    user[0].trn_number.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: 90.w,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Text(
                      "Emirates ID Front",
                      style:
                          TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    )),
              ),
              Container(
                height: 18.h,
                width: 70.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.network(
                    user[0].emirates_id_front!,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: 90.w,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Text(
                      "Emirates ID Back",
                      style:
                          TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    )),
              ),
              Container(
                height: 18.h,
                width: 70.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.network(
                    user[0].emirates_id_back!,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: 90.w,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Text(
                      "Emirates ID Expiry Date",
                      style:
                          TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    )),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.91,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[300],
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    user[0].emirate_id_expiry_date!,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: 90.w,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Text(
                      "Trade License",
                      style:
                          TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    )),
              ),
              Container(
                height: 18.h,
                width: 70.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.network(
                    user[0].trade_license_image!,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: 90.w,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Text(
                      "Trade License Expiry Date",
                      style:
                          TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    )),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.91,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[300],
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    user[0].trade_license_expiry_date!,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: 90.w,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Text(
                      "TRN/TAX Number",
                      style:
                          TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    )),
              ),
              Container(
                height: 18.h,
                width: 70.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.network(
                    user[0].trn_number_image!,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
