// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/model/assets_req_model.dart';
import 'package:rentitezy/model/issues_model.dart';
import 'package:rentitezy/model/leads_model.dart';
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/const/appConfig.dart';
import '../utils/const/app_urls.dart';
import '../login/view/login_screen.dart';
import '../utils/const/widgets.dart';
import '../utils/view/rie_widgets.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _MyAgreeState();
}

class _MyAgreeState extends State<RequestScreen> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  late Future<List<IssuesModel>> futureFaq;
  late Future<List<AssetReqModel>> futureAssetsReq;
  late Future<List<LeadsModel>> futureLeadReq;
  bool isTenant = false;
  String userId = '';
  String tenantId = '';
  @override
  void initState() {
    futureFaq = fetchIssuesApi();
    futureAssetsReq = fetchAssetReqApi();
    futureLeadReq = fetchLeadHistory();
    super.initState();
  }

  Future<List<IssuesModel>> fetchIssuesApi() async {
    try {
      var sharedPreferences = await prefs;
      if (sharedPreferences.containsKey(Constants.userId)) {
        userId = GetStorage().read(Constants.userId).toString();
        var list = allIssuesGet(userId);
        futureFaq = Future.value(list);
        setState(() {});
        return list;
      } else {
        setState(() {});
        return [];
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<AssetReqModel>> fetchAssetReqApi() async {
    try {
      var sharedPreferences = await prefs;
      if (sharedPreferences.containsKey(Constants.userId)) {
        userId = GetStorage().read(Constants.userId).toString();
        var list = getAllAssetsReq(userId);
        futureAssetsReq = Future.value(list);
        setState(() {});
        return list;
      } else {
        setState(() {});
        return [];
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  int tabPos = 0;

  List<String> listTab = ['Property/0', 'Assets/1', 'Issues/2'];

  Widget tabItem(String title, int pos) {
    return GestureDetector(
      onTap: () {
        tabPos = pos;
        setState(() {});
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              title,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          height(0.005),
          Container(
            height: 2,
            width: 70,
            color: tabPos == pos ? Constants.primaryColor : null,
          )
        ],
      ),
    );
  }

//faqApi
  Widget listFaq(List<IssuesModel> faqModel) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          expandItemFaq(faqModel[index]),
      itemCount: faqModel.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

//faq list widget
  Widget expandItemFaq(IssuesModel faqModel) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            'Que : ${faqModel.question}',
            style: TextStyle(fontFamily: Constants.fontsFamily),
          ),
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.all(5),
          tilePadding: const EdgeInsets.all(5),
          children: [
            Text(
              'Status : ${faqModel.status}',
              style: TextStyle(fontFamily: Constants.fontsFamily),
            ),
            Text(
              convertToAgo(faqModel.createdOn),
              style: TextStyle(fontFamily: Constants.fontsFamily),
            )
          ],
        ),
      ),
    );
  }

//faq list
  Widget fetchMyFaq() {
    return FutureBuilder<List<IssuesModel>>(
        future: futureFaq,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return RIEWidgets.getLoader();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return RIEWidgets.getLoader();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return listFaq(snapshot.data!);
            } else if (snapshot.hasError) {
              return reloadErr(snapshot.error.toString(), (() {
                futureFaq = fetchIssuesApi();
              }));
            }
          }

          return RIEWidgets.getLoader();
        });
  }

//assets req Api
  Widget listAssetsReq(List<AssetReqModel> faqModel) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          expandItemAssets(faqModel[index]),
      itemCount: faqModel.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  //assets list widget
  Widget expandItemAssets(AssetReqModel faqModel) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            faqModel.assetsModel.brand,
            style: TextStyle(fontFamily: Constants.fontsFamily),
          ),
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.all(5),
          tilePadding: const EdgeInsets.all(5),
          children: [
            Text(
              faqModel.assetsModel.productName,
              style: TextStyle(fontFamily: Constants.fontsFamily),
            ),
            Text(
              '${Constants.currency}.${faqModel.assetsModel.price}',
              style: TextStyle(fontFamily: Constants.fontsFamily),
            ),
            Text(
              faqModel.status,
              style: TextStyle(fontFamily: Constants.fontsFamily),
            ),
            Text(
              convertToAgo(faqModel.createdOn),
              style: TextStyle(fontFamily: Constants.fontsFamily),
            )
          ],
        ),
      ),
    );
  }

//assets list
  Widget fetchMyAssetsReq() {
    return FutureBuilder<List<AssetReqModel>>(
        future: futureAssetsReq,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return RIEWidgets.getLoader();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return RIEWidgets.getLoader();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return listAssetsReq(snapshot.data!);
            } else if (snapshot.hasError) {
              return reloadErr(snapshot.error.toString(), (() {
                futureAssetsReq = fetchAssetReqApi();
              }));
            }
          }

          return RIEWidgets.getLoader();
        });
  }

  Future<List<LeadsModel>> fetchLeadHistory() async {
    var sharedPreferences = await prefs;
    var list = getAllLeadReq(
        '${AppUrls.leads}?userId=${GetStorage().read(Constants.userId)}');
    futureLeadReq = Future.value(list);
    setState(() {});
    return list;
  }

  Widget fetchMyLeadReq() {
    return FutureBuilder<List<LeadsModel>>(
        future: futureLeadReq,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return RIEWidgets.getLoader();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return RIEWidgets.getLoader();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return listTLeadReq(snapshot.data!);
            } else if (snapshot.hasError) {
              return reloadErr(snapshot.error.toString(), (() {
                futureLeadReq = fetchLeadHistory();
              }));
            }
          }

          return RIEWidgets.getLoader();
        });
  }

  Widget listTLeadReq(List<LeadsModel> faqModel) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          expandItemLead(faqModel[index]),
      itemCount: faqModel.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  //lead list widget
  Widget expandItemLead(LeadsModel faqModel) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            faqModel.stage.toUpperCase(),
            style: TextStyle(fontFamily: Constants.fontsFamily),
          ),
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.all(5),
          tilePadding: const EdgeInsets.all(5),
          children: [
            Text(
              'Status ${faqModel.progress}',
              style: TextStyle(fontFamily: Constants.fontsFamily),
            ),
            FutureBuilder<List<PropertyModel>>(
                future: fetchAllProductsById(faqModel.proIds),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    return RIEWidgets.getLoader();
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return RIEWidgets.getLoader();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext ctxt, int index) =>
                              Text(snapshot.data![index].name));
                    } else if (snapshot.hasError) {
                      return reloadErr(snapshot.error.toString(), (() {
                        futureLeadReq = fetchLeadHistory();
                      }));
                    }
                  }

                  return RIEWidgets.getLoader();
                }),
            Text(
              convertToAgo(faqModel.createdOn),
              style: TextStyle(fontFamily: Constants.fontsFamily),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Constants.primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          child: Stack(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Our Request',
                style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ]),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 150,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Column(children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: listTab
                                  .map((e) => tabItem(e.split('/')[0],
                                      int.parse(e.split('/')[1])))
                                  .toList(),
                            ),
                          ),
                          Visibility(
                            visible: tabPos == 0,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height - 280,
                                  child: Align(
                                      alignment: Alignment.topCenter,
                                      child: (userId != 'null' &&
                                              userId != 'guest')
                                          ? fetchMyLeadReq()
                                          : Center(
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LoginScreen()),
                                                        (route) => false);
                                                  },
                                                  child: const Text('LOGIN')),
                                            )),
                                )),
                          ),
                          Visibility(
                            visible: tabPos == 1,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height - 280,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: fetchMyAssetsReq(),
                                  ),
                                )),
                          ),
                          Visibility(
                            visible: tabPos == 2,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height -
                                        280,
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child: fetchMyFaq()))),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ))
      ]),
    );
  }
}
