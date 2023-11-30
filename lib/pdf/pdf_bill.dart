import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/rent_req_model.dart';
import 'pdf_api.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfBillInvoice {
  static Future<File> generate(RentReqModel rentReq) async {
    final pdf = Document();
    final ByteData bytes1 = await rootBundle.load('assets/images/app_logo.png');
    final Uint8List img1 = bytes1.buffer.asUint8List();
    pw.Image imgty(Uint8List img) {
      return pw.Image(
          pw.MemoryImage(
            img,
          ),
          fit: pw.BoxFit.contain);
    }

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a6,
        build: (context) {
          return [
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    child: imgty(img1),
                  ),
                  SizedBox(width: 10),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('RENT RECEIPT',
                            style: TextStyle(
                                fontSize: 11, fontBold: Font.timesBold())),
                        Text(
                            '#17 Nanjund Reddy Layout, 1st Cross\nKonenagrahara, HAL post, Bangalore:560017',
                            style: const TextStyle(fontSize: 4)),
                      ]),
                  Spacer(),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date:  ${getFormatedDate(rentReq.createdOn)}',
                            style: const TextStyle(fontSize: 7)),
                        Text('No.  #${rentReq.bookingId}',
                            style: const TextStyle(fontSize: 7)),
                      ])
                ]),
            // Center(
            //   child: Text('RENT RECEIPT',
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            // ),
            SizedBox(height: 3 * PdfPageFormat.mm),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Received form:', style: const TextStyle(fontSize: 9)),
                  SizedBox(width: 10),
                  Text(rentReq.userName,
                      style: const TextStyle(
                          fontSize: 7, decoration: TextDecoration.underline)),
                ]),

            SizedBox(height: 1 * PdfPageFormat.mm),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('The Sum of:', style: const TextStyle(fontSize: 9)),
                  SizedBox(width: 10),
                  Text(rentReq.payable,
                      style: const TextStyle(
                          fontSize: 7, decoration: TextDecoration.underline)),
                  SizedBox(width: 5),
                  Text('Rupees', style: const TextStyle(fontSize: 7)),
                ]),

            SizedBox(height: 1 * PdfPageFormat.mm),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Received by:', style: const TextStyle(fontSize: 9)),
                  SizedBox(width: 10),
                  Text(' Rentiseazy ',
                      style: const TextStyle(
                          fontSize: 7, decoration: TextDecoration.underline)),
                ]),
            SizedBox(height: 1 * PdfPageFormat.mm),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Phone no:', style: const TextStyle(fontSize: 9)),
                  SizedBox(width: 10),
                  Text(rentReq.userPhone,
                      style: const TextStyle(
                          fontSize: 7, decoration: TextDecoration.underline)),
                ]),
            SizedBox(height: 1 * PdfPageFormat.mm),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('For the Period:',
                            style: const TextStyle(fontSize: 9)),
                        SizedBox(width: 10),
                        Text(lastMonth(rentReq.createdOn),
                            style: const TextStyle(
                                fontSize: 7,
                                decoration: TextDecoration.underline)),
                        SizedBox(width: 5),
                        Text('to', style: const TextStyle(fontSize: 7)),
                        SizedBox(width: 5),
                        Text(curentMonth(rentReq.createdOn),
                            style: const TextStyle(
                                fontSize: 7,
                                decoration: TextDecoration.underline)),
                      ]),
                  SizedBox(width: 5),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Paid by', style: const TextStyle(fontSize: 9)),
                        SizedBox(width: 10),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 8,
                                        width: 8,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            border: Border.all(width: 1))),
                                    SizedBox(width: 5),
                                    Text('Cash',
                                        style: const TextStyle(fontSize: 7)),
                                  ]),
                              SizedBox(height: 5),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 8,
                                        width: 8,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            border: Border.all(width: 1))),
                                    SizedBox(width: 5),
                                    Text('Online',
                                        style: const TextStyle(fontSize: 7)),
                                  ])
                            ])
                      ]),
                ]),
          ];
        },
      ),
    );

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }
}
