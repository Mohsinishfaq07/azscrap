import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart';

Future<Uint8List> makePdf() async {
  final pdf = Document();
  pdf.addPage(
      Page(
          build: (context) {
            return Column(
                children: [
                  Container(
                    height: 60,
                    width: 500,
                    child: Center(child: Text("AGREEMENT", style: TextStyle(fontSize: 40, color: PdfColor(0.5,0,1),)),)
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    // height: 60,
                    width: 500,
                    child: Text("Title: Software Management\nLicense no: 70073302\nTicket no: 29675\nPhone no: 00393345123\nTRN/Tax no: 98798",
                        style: TextStyle(fontSize: 28,)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                      height: 60,
                      width: 500,
                      child: Center(child: Text("DETAILS", style: TextStyle(fontSize: 40, color: PdfColor(0.5,0,1),)),)
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    // height: 60,
                    width: 500,
                    child: Text("Location of material: America\nDetails of material: N/A\nPrice of material: N/A",
                        style: TextStyle(fontSize: 28,)),
                  ),
                ]
            );
          }
      ),
  );
  pdf.addPage(
    Page(build: (context){
      return Column(
          children: [
            Container(
                height: 60,
                width: 1000,
                child: Center(child: Text("TERMS AND CONDITIONS", style: TextStyle(fontSize: 38, color: PdfColor(0.5,0,1),)),)
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              // height: 60,
              width: 500,
              child: Text("The client shall provide to the company written notice of its finding that the software conforms to the Specifications within time and days of the delivery date.\n        If the software as delivered does not conform with the specifications the client shall within time of the delivery date notify the company in written of the ways on which it does not conform with the specifications. The company agrees that upon receiving such notice, it shall make reasonable efforts to correct any non-conformity.",
                  textAlign: TextAlign.justify, style: TextStyle(fontSize: 28,)),
            ),
          ]
      );
    }),
  );
  return pdf.save();
  }