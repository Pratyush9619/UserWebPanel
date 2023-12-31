import 'dart:developer';

import 'package:assingment/KeysEvents/Grid_DataTable.dart';
import 'package:assingment/Planning_Pages/electrical_quality_checklist.dart';
import 'package:assingment/Planning_Pages/summary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../Authentication/auth_service.dart';
import '../widget/style.dart';
import 'civil_quality_checklist.dart';

class QualityChecklist extends StatefulWidget {
  String? userId;
  String? cityName;
  String? depoName;
  String? currentDate;
  bool? isHeader;

  QualityChecklist(
      {super.key,
      this.userId,
      required this.cityName,
      required this.depoName,
      this.currentDate,
      this.isHeader = true});

  @override
  State<QualityChecklist> createState() => _QualityChecklistState();
}

TextEditingController ename = TextEditingController();
String selectedTabName = '';
String currentTabName = '';
String selectedDepot = '';
dynamic empName,
    distev,
    vendorname,
    date,
    olano,
    panel,
    serialno,
    depotname,
    customername;

dynamic alldata;
int? _selectedIndex = 0;
dynamic userId;
TextEditingController selectedDepoController = TextEditingController();

List<bool> listToSelectTab = [];
List<String> qualityFields = [
  'CivilChecklistField',
  'ElectricalChecklistField'
];

List<String> title = [
  'CHECKLIST FOR INSTALLATION OF PSS',
  'CHECKLIST FOR INSTALLATION OF RMU',
  'CHECKLIST FOR INSTALLATION OF  COVENTIONAL TRANSFORMER',
  'CHECKLIST FOR INSTALLATION OF CTPT METERING UNIT',
  'CHECKLIST FOR INSTALLATION OF ACDB',
  'CHECKLIST FOR  CABLE INSTALLATION ',
  'CHECKLIST FOR  CABLE DRUM / ROLL INSPECTION',
  'CHECKLIST FOR MCCB PANEL',
  'CHECKLIST FOR CHARGER PANEL',
  'CHECKLIST FOR INSTALLATION OF  EARTH PIT',
];

// ignore: non_constant_identifier_names
List<String> civil_title = [
  'CHECKLIST FOR INSTALLATION OF EXCAVATION WORK',
  'CHECKLIST FOR INSTALLATION OF EARTH WORK - BACKFILLING',
  'CHECKLIST FOR INSTALLATION OF BRICK & BLOCK MASSONARY',
  'CHECKLIST FOR INSTALLATION OF BLDG DOORS, WINDOWS, HARDWARE, GLAZING',
  'CHECKLIST FOR INSTALLATION OF FALSE CEILING',
  'CHECKLIST FOR FLOORING & TILING',
  'CHECKLIST FOR GROUT INSPECTION',
  'CHECKLIST FOR INRONITE FLOORING CHECK',
  'CHECKLIST FOR PAINTING',
  'CHECKLIST FOR PAVING WORK',
  'CHECKLIST FOR WALL CLADDING & ROOFING',
  'CHECKLIST FOR WALL WATER PROOFING',
];

// Main
class _QualityChecklistState extends State<QualityChecklist> {
  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.currentDate = DateFormat.yMMMMd().format(DateTime.now());

    final scaffoldKey = GlobalKey<ScaffoldState>();
    return SafeArea(
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading:
                  widget.isHeader! ? widget.isHeader! : false,
              backgroundColor: blue,
              title: widget.isHeader!
                  ? Text(
                      '${widget.cityName} / ${widget.depoName} / Quality Checklist')
                  : const Text(''),
              actions: [
                Container(
                  margin: const EdgeInsets.all(5.0),
                  padding:
                      const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                  width: 200,
                  height: 30,
                  child: TypeAheadField(
                      animationStart: BorderSide.strokeAlignCenter,
                      hideOnLoading: true,
                      suggestionsCallback: (pattern) async {
                        return await getDepoList(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(
                            suggestion.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        selectedDepoController.text = suggestion.toString();
                        selectedDepot = suggestion.toString();

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QualityChecklist(
                                cityName: widget.cityName,
                                depoName: selectedDepot,
                              ),
                            ));
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.all(5.0),
                            hintText: 'Go To Depot'),
                        style: const TextStyle(fontSize: 15),
                        controller: selectedDepoController,
                      )),
                ),
                widget.isHeader!
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 10, top: 10, bottom: 10),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewSummary(
                                            depoName: widget.depoName,
                                            cityName: widget.cityName,
                                            id: 'Quality Checklist',
                                            selectedtab:
                                                _selectedIndex.toString(),
                                            isHeader: false,
                                          ),
                                        ));
                                  },
                                  child: Text(
                                    'View Summary',
                                    style:
                                        TextStyle(color: white, fontSize: 20),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20, top: 10, bottom: 10),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: lightblue),
                              child: TextButton(
                                  onPressed: () {
                                    // FirebaseFirestore.instance
                                    //     .collection('CivilChecklistField')
                                    //     .doc('${widget.depoName}')
                                    //     .collection('userId')
                                    //     .doc(userId)
                                    //     .collection(currentTabName)
                                    //     .doc(widget.currentDate)
                                    //     .set({
                                    //   'EmployeeName':
                                    //       empName ?? 'Enter Employee Name',
                                    //   'Dist EV': distev ?? 'Enter Dist EV',
                                    //   'VendorName':
                                    //       vendorname ?? 'Enter Vendor Name',
                                    //   'Date': date ?? 'Enter Date',
                                    //   'OlaNo': olano ?? 'Enter Ola No',
                                    //   'PanelNo': panel ?? 'Enter Panel',
                                    //   'DepotName':
                                    //       depotname ?? 'Enter depot Name Name',
                                    //   'CustomerName':
                                    //       customername ?? 'Enter Customer Name'
                                    // });
                                    _selectedIndex == 0
                                        ? CivilstoreData(
                                            context,
                                            widget.depoName!,
                                            widget.currentDate!,
                                            listToSelectTab,
                                            selectedTabName)
                                        : storeData(
                                            context,
                                            widget.depoName!,
                                            widget.currentDate!,
                                            listToSelectTab);
                                  },
                                  child: Text(
                                    'Sync Data',
                                    style:
                                        TextStyle(color: white, fontSize: 20),
                                  )),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 40),
                              child: GestureDetector(
                                  onTap: () {
                                    onWillPop(context);
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/logout.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        userId ?? '',
                                        style: const TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ))),
                        ],
                      )
                    : Container(),
              ],
              // leading:
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 50),
                child: Column(
                  children: [
                    TabBar(
                      labelColor: white,
                      labelStyle: buttonWhite,
                      unselectedLabelColor: Colors.black,
                      indicator: MaterialIndicator(
                          horizontalPadding: 24,
                          bottomLeftRadius: 8,
                          bottomRightRadius: 8,
                          color: white,
                          paintingStyle: PaintingStyle.fill),
                      tabs: const [
                        Tab(text: 'Civil Engineer'),
                        Tab(text: 'Electrical Engineer'),
                      ],
                      onTap: (value) {
                        _selectedIndex = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(children: [
              CivilQualityChecklist(
                cityName: widget.cityName,
                depoName: widget.depoName,
                getBoolList: getBoolList,
              ),
              ElectricalQualityChecklist(
                  cityName: widget.cityName,
                  depoName: widget.depoName,
                  userId: userId,
                  getBoolList: getBoolList),
            ]),
          )),
    );
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }

  void getBoolList(List<bool> boolList, String tabName) {
    listToSelectTab = boolList;
    selectedTabName = tabName;
    print(listToSelectTab);
  }

  Future<List<dynamic>> getDepoList(String pattern) async {
    List<dynamic> depoList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('DepoName')
        .doc(widget.cityName)
        .collection('AllDepots')
        .get();

    depoList = querySnapshot.docs.map((deponame) => deponame.id).toList();

    if (pattern.isNotEmpty) {
      depoList = depoList
          .where((element) => element
              .toString()
              .toUpperCase()
              .startsWith(pattern.toUpperCase()))
          .toList();
    }

    return depoList;
  }
}
