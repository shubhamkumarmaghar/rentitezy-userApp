import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../utils/model/agreement_det.dart';
import 'pdf_api.dart';

class PdfInvoice {
  static Future<File> generate(AgreementDet agreementDet) async {
    final pdf = Document();
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            Center(
              child: Text(agreementDet.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            SizedBox(height: 3 * PdfPageFormat.mm),
            Text(
                'This AGREEMENT is made and executed on ${agreementDet.executedOn} by and between ${agreementDet.between.toUpperCase()}.\nS/o  ${agreementDet.sof}, aged about ${agreementDet.about} years (the "Owner") residing at ${agreementDet.residingAt} via its authorized representative ${agreementDet.representative} ("the firm" or "firm") Hereinafter called as the "First Party",${'\n'}AND${'\n'}${agreementDet.firstParty}',
                style: const TextStyle(fontSize: 11)),
            SizedBox(height: 1 * PdfPageFormat.mm),
            Text(
                'Hereinafter called the "Tenant" or "the occupant"of the OTHER PART.',
                style: const TextStyle(fontSize: 11)),
            Text(
                'Whereas the Tenant are desirous of taking on lease Schedule Property located at ${agreementDet.propertyLocated}which is more fully described in the Schedule hereunder and hereinafter called the Schedule Premises.',
                style: const TextStyle(fontSize: 11)),
            SizedBox(height: 4 * PdfPageFormat.mm),
            Text('NOW THIS AGREEMENT WITNESSETH AS FOLLOWS:',
                style: const TextStyle(fontSize: 14)),
            SizedBox(height: 1 * PdfPageFormat.mm),
            Text(
                'The Tenant shall take on lease the Schedule Property on the terms and conditions hereinafter contained. ',
                style: const TextStyle(fontSize: 11)),
            SizedBox(height: 1 * PdfPageFormat.mm),
            Text(
                'The First party covenant with the Tenant that the Tenant on paying the residential rent amount hereby reserved shall be entitled to the peaceful possession and quiet enjoyment of the Schedule Property during the period of lease.',
                style: const TextStyle(fontSize: 11)),
            SizedBox(height: 1 * PdfPageFormat.mm),
            Text(
                'The First party shall be entitled to enter upon the Schedule Property with at all reasonable times with prior intimation to the Tenant and inspect the same to satisfy themselves that the Schedule Property is used in accordance with the terms of the lease',
                style: const TextStyle(fontSize: 11)),
            SizedBox(height: 1 * PdfPageFormat.mm),
            Text(
                'The Tenant shall use the property for legitimate and residential use only.${'\n'}The licensee shall be held responsible for conduct of his/her guests in the premise & its consequences thereafter.${'\n'}The licensee shall be responsible for his/her belongings in the scheduled premise. The owner or its representatives shall not be liable for any theft of personal belongings of the licensee. In case of theft/loss of any furnishing or appliance or furniture, tenant shall be held responsible & owner or its representative shall have the right to deduct money from security deposit towards compensation of the loss.${'\n'}Any criminal or offensive conduct that will entail the intervention of the Municipal Police or other Government agencies is prohibited hereunder;${'\n'}Any nuisance or disturbance to the other residents, partying causing disturbance to other occupants of the building, unruly behavior, and complaint by authorities would lead to immediate notice of termination to the tenant.',
                style: const TextStyle(fontSize: 11)),
            SizedBox(height: 1 * PdfPageFormat.mm),
            Text(
                'Any damage caused by tenant due to negligence will be borne by the tenant.',
                style: const TextStyle(fontSize: 11)),
            Text(
                'The term of this agreement in the First instance be for a period Eleven months commencing from ${agreementDet.commencingFrom} and ending on ${agreementDet.commencingEnding}',
                style: const TextStyle(fontSize: 11)),
            Text(
                'The Licensee have to pay monthly license amount of ${agreementDet.licenseAmount} on or before due date for each month for the Schedule Property via Rent is Easy authorized representative during the period of rent. For the sake of clarity, rent amount are Pre-paid for each rentable month. Rent including water bill and maintenance.',
                style: const TextStyle(fontSize: 11)),
            Text(
                'Service tax/GST applicable on any of the services shall be paid by the tenant, where applicable',
                style: const TextStyle(fontSize: 11)),
            Text(
                'On expiry of the rent period, the First Party and the tenant shall at the option of either Parties renew for an additional Eleven months or part thereof on the same terms and conditions, subject to license fee increase of 10% yearly or 5% every 6months subject to mutually agreed amount.',
                style: const TextStyle(fontSize: 11)),
            Text(
                'The Tenant has paid a total advance of ${agreementDet.totalAdvance} towards Security deposit which shall be refunded by the First party to the Tenant without interest simultaneously with the Tenant handing over vacant possession of the Schedule Property after deducting ${agreementDet.deducting} towards Painting charges, all or any damages to furniture & accessories   will be assessed and recharged/ deducted from your deposit, caused by the tenant irrespective of the duration of stay.',
                style: const TextStyle(fontSize: 11)),
            Text(
                'Drinking Water, electricity, Gas, TV cable charges, Internet and any other charges applicable / incurred for the Schedule Property shall be borne and paid by the tenant. The Tenant agrees to the division of maintenance responsibilities of the house between owner and tenant as per Annexure- A.',
                style: const TextStyle(fontSize: 11)),
            Text(
                'The Tenant shall not sublet or grant any lease or sub-lease in respect to the rented premises or make any structural changes or remove any fittings or fixtures in the Schedule Property without the written consent of the first party.',
                style: const TextStyle(fontSize: 11)),
            Text(
                'Termination:${'\n'}The First party shall have the right to terminate the rent in the event of:${'\n'}By efflux of time${'\n'}Non-adherence to the housing rules as per Annexure A${'\n'}The Licensee agrees that, in the event of failure to pay the rent due within 30 days from the day of due by the Tenant, style: const TextStyle(fontSize: 11)'),
            Text(
                'Notwithstanding anything herein before contained either the First party or the Tenant shall be entitled to terminate this rental agreement / lease by giving to the other party one month prior written notice in that behalf. If no notice is provided by the Tenant then the tenant is not liable to pay one month additional rent. On such termination, the Tenant shall quit and deliver the possession of the Schedule Property. ',
                style: const TextStyle(fontSize: 11)),
            Text(
                'The Lock-in period for this agreement is months, and if the Licensee wishes to terminate this agreement during the lock-in period, the Licensee would be charged ${agreementDet.licenseCharged}, towards breaking of Lock-in period.',
                style: const TextStyle(fontSize: 11)),
            Text(
                'Notice to vacate should be sent in writing. In the event of notice by ${agreementDet.notice1} and) ${agreementDet.notice1} and notify the caretaker of vacating the property. Any other mode of notice shall not be accepted.',
                style: const TextStyle(fontSize: 11)),
            Text(
                'Each of the Tenant is individually responsible to ensure all the terms in the agreement are fulfilled and all dues are fully cleared before vacating the property, the company can otherwise take appropriate action to recover the amount with a penalty Interest at 2% per month.',
                style: const TextStyle(fontSize: 11)),
            Text(
                'If any part of the agreement is invalid, the same shall not affect the remaining part of the agreement, and the agreement shall be construed as if such invalid portion had not been part of this Agreement.',
                style: const TextStyle(fontSize: 11)),
            Text(
                'Stamp duty and legal expenses towards agreement registration to be paid by Tenant.',
                style: const TextStyle(fontSize: 11)),
            Text(
                'All legal matter subject to Bengaluru (Karnataka) Jurisdiction only.',
                style: const TextStyle(fontSize: 11)),
            Text(
                'If SoWeRent withdraws the contract from the owner the tenants deposit will be fully refundable without any deduction. ',
                style: const TextStyle(fontSize: 11)),
            SizedBox(height: 5 * PdfPageFormat.mm),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
              border: TableBorder.all(width: 1.0),
              children: [
                TableRow(
                  children: [
                    Padding(
                      child: Text(
                        'Particulars of Tenant',
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                  ],
                ),
                TableRow(children: [
                  Text(
                    "Name",
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 10),
                  ),
                  Text(
                    ' ${agreementDet.between}',
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 10),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "S/o or D/o or W/o",
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 10),
                  ),
                  Text(
                    "",
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 10),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "Age",
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 10),
                  ),
                  Text(
                    "",
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 10),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "Office/Business Establishment address with contact no. & ID",
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 10),
                  ),
                  Text(
                    "",
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 10),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "Permanent Address",
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 10),
                  ),
                  Text(
                    "",
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 10),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "Mob (Emergency )",
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 10),
                  ),
                  Text(
                    "",
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 10),
                  ),
                ]),
                TableRow(children: [
                  Text(
                    "ID Proof& Photo",
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 10),
                  ),
                  Text(
                    "",
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 10),
                  ),
                ]),
              ],
            ),
            SizedBox(height: 5 * PdfPageFormat.mm),
            Center(
              child: Text('ANNEXURE A',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            SizedBox(height: 1 * PdfPageFormat.mm),
            Text('LICENSE FEE Payment Terms',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9)),
            Text(
                'Rent Payment Due Date             : Payable on or before 1st of every month or immediately on occupying the property, if your rent is pro-rated.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9)),
            Text(
                'Late Payment Charges: If rent not received with 5 days after due date, INR 50 would be levied for each day thereafter.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9)),
            Text('Owner Maintenance Responsibilities:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Text(
                'Structural Repairs except those necessitated by the damage caused by the tenant.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9)),
            Text('Changing plumbing pipes when necessary - external.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9)),
            Text(
                'Any major repair due to natural wear & tear of appliances and furniture. The tenant shall pay for such damages if they cause it.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9)),
            Text(
                'Any repair, replacement and maintenance issues arising during the first 7 days of the agreement period. Thereafter, the charges for such maintenance shall be borne by licensee.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9)),
            Text('Tenant Maintenance Responsibilities',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Text(
                'Pay utility bills, including Electricity, Waste Management, Cable Charges, Internet Charges any other bills applicable/ incurred to the scheduled property, directly to the respective corporations or to the vendors. Keeping the premises and home clean',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9)),
            Text(
                'All garbage must be disposed daily in bags after segregating Dry and Wet wastes in designated areas or to the municipal trucksChanging/repair of tap washers and taps ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9)),
            Text(
                'All minor expenses less than INR 500/- for each given instance',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9)),
            Center(
              child: Text('ANNEXURE  B',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            SizedBox(height: 5 * PdfPageFormat.mm),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
              border: TableBorder.all(width: 1.0),
              children: [
                TableRow(
                  children: [
                    Padding(
                      child: Text(
                        'Particulars of Tenant',
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                  ],
                ),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "Standard Fitting Provided",
                      textScaleFactor: 1,
                      style: const TextStyle(fontSize: 14),
                    ),
                  )
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "Wardrobes in room",
                      textScaleFactor: 1,
                      style: const TextStyle(fontSize: 10),
                    ),
                  )
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Kitchen",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "2",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Lights, as required",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Ceiling Fans in each rooms",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "2",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "CFL, Bulbs",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Geysers in All Bathrooms",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Calling Bell",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Cot",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Mattress",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Sofa",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Coffee Table",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Fridge",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "T V",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Pillow",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Blankets",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Bed Cover",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "2",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Pillow Cover",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "4",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Window curtain",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "4",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Plates",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Knife",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Lighter",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Tea Strainer",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Tea saucepan",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Kadai",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Serving Spoon -rice",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Serving Spoon -sambar",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Palta",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "4",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Fork",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "4",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Spoon",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "4",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Glass",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "4",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Bowls",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Pan",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "2",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Top with Lid Medium1+1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Top With Lid Big 1+1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "chakla ( Wooden chapati maker)",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Belan ( wooden rolling pin)",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Gas Pipe",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Regulator",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Cooker 5 ltr",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Gas Stove ",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Peeler",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Chopping Board",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Dust Bin",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "dust pan",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Broom",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Mug",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Bucket",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Toilet Brush ",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Mop",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Bathroom broom",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "1",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Keys For Main Door",
                        textScaleFactor: 1,
                        style: const TextStyle(fontSize: 10),
                      )),
                ]),
              ],
            ),
            SizedBox(height: 5 * PdfPageFormat.mm),
            Center(
              child: Text('SCHEDULE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            SizedBox(height: 2 * PdfPageFormat.mm),
            Text(
                'All that piece and parcel of the premises bearing on ${agreementDet.premisesBearing}, consisting of ${agreementDet.consisting} with covered Bike Parking provided with Electricity and water facilities with RCC Roofing House as per ANNEXURE B IN WITNESS WHEREOF the PARTIES have signed this AGREEMENT on the date and the year first written above in the presence of the following witnesses.',
                style: const TextStyle(fontSize: 12)),
            SizedBox(height: 2 * PdfPageFormat.mm),
            Text('WITNESS', style: const TextStyle(fontSize: 12)),
            SizedBox(height: 2 * PdfPageFormat.mm),
            Text('1.(Owner / Authorized Representative)',
                style: const TextStyle(fontSize: 9)),
            SizedBox(height: 2 * PdfPageFormat.mm),
            Text('2.(Licensee)', style: const TextStyle(fontSize: 9)),
            SizedBox(height: 3 * PdfPageFormat.mm),
          ];
        },
      ),
    );

    return PdfApi.saveDocument(name: 'rental_aggrement.pdf', pdf: pdf);
  }
}
