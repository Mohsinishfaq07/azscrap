import 'package:flutter/material.dart';

class MessageModel{
  final String senderType;
  final String message;
  final String senderName;
  final String senderNumber;
        List? attachments;
        String TimeStamp;

  MessageModel({
    required this.senderType,
    required this.message,
    required this.senderName,
    required this.senderNumber,
    this.attachments,
    this.TimeStamp = "0000-00-00",
  });
}