import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import '../constants.dart';
import 'pdfexport.dart';

class PdfPreviewPage extends StatelessWidget {
  // final PdfDeta deta;
  //
  // const PdfPreviewPage({Key? key, required this.deta}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(),
      ),
    );
  }
}
