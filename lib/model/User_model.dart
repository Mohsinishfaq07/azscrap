import 'dart:io';
import 'package:flutter/material.dart';

class UserModel {
  final String? user_id;
  final String user_number;
  String? user_name;
  String? user_email;
  String? company;
  String? emirates_id_front;
  String? emirates_id_back;
  String? emirate_id_expiry_date;
  String? trade_license_number;
  String? trade_license_image;
  String? trade_license_expiry_date;
  String? trn_number;
  String? trn_number_image;
  final bool verified;
  bool is_registered;

  UserModel({
    required this.user_id,
    required this.user_number,
    this.user_name,
    this.user_email,
    this.company,
    this.emirates_id_front,
    this.emirates_id_back,
    this.emirate_id_expiry_date,
    this.trade_license_number,
    this.trade_license_image,
    this.trade_license_expiry_date,
    this.trn_number,
    this.trn_number_image,
    this.verified = false,
    required this.is_registered,
  });
}