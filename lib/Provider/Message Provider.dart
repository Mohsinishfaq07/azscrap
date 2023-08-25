import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../model/messageModel.dart';

class MessageProvider with ChangeNotifier {
  List<MessageModel> _items = [];

  List<MessageModel> get items {
    return _items;
  }

  Future AddMessage(
      MessageModel message, String ticket_id, String Token) async {
    // var map = new Map<String, dynamic>();
    // map['senderType'] = message.senderType;
    // map['message'] = message.message;
    // map['senderName'] = message.senderName;
    // map['senderNumber'] = message.senderNumber;
    // map['attachments'] = message.senderNumber;
    Map<String, dynamic> map;
    map = {
      'senderType': message.senderType,
      'message': message.message,
      'senderName': message.senderName,
      'senderNumber': message.senderNumber,
    };
    for (int i = 0; i < message.attachments!.length; i++) {
      map.addAll({"attachments[$i]": message.attachments![i]});
    }
    http.Response response = await http.post(
        Uri.parse(
            'http://notifications.azscrap.com/notifications/api/user/send-message/$ticket_id'),
        headers: {
          "x-access-token": Token,
        },
        body: map);
    print(response.body);
    // print(json.decode(response.body)['statusMsg']);
    // print(json.decode(response.body)['statusCode']);
    // print(json.decode(response.body)['data']);
    if (json.decode(response.body)['statusCode'] == 200) {
      final new_message = MessageModel(
          senderType: message.senderType,
          message: message.message,
          senderName: message.senderName,
          senderNumber: message.senderNumber);
      _items.add(new_message);
      notifyListeners();
    }
    return json.decode(response.body)['statusCode'] == 200
        ? " message send successfully"
        : "message not send";
  }

  Future FetchChat(String ticket_id, String Token) async {
    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://notifications.azscrap.com/notifications/api/user/get-chat/$ticket_id'),
        headers: {
          "x-access-token": Token,
        },
      );
      print(json.decode(response.body)["data"]['ticket_chat']);
      List MessageData;
      Map MessageList = json.decode(response.body);
      Map ticket_chat_list = MessageList["data"];
      MessageData = ticket_chat_list['ticket_chat'];
      List<MessageModel> Messages = [];

      for (int s = 0; s < MessageData.length; s++) {
        MessageModel messsages = MessageModel(
          senderType: MessageData[s]["senderType"],
          message: MessageData[s]["message"],
          senderName: MessageData[s]["senderName"],
          senderNumber: MessageData[s]["senderNumber"],
          TimeStamp: MessageData[s]["timeStamp"],
        );
        Messages.add(messsages);
      }
      _items = Messages;
      notifyListeners();

      // print("The get Chat API response start from here");
      // print(response.body);
      // print(json.decode(response.body)["data"]["_id"]);
      print(json.decode(response.body));
      // print(json.decode(response.body)['data']);
      return json.decode(response.body)["data"]["_id"];
    } catch (e) {
      print(e);
    }
  }
}
