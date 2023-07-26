import 'package:assingment/Planning_Pages/quality_checklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../Authentication/auth_service.dart';
import '../FirebaseApi/firebase_api.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_Ironite_flooring.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_backfilling.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_ceiling.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_excavation.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_flooring.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_glazzing.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_inspection.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_massonary.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_painting.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_paving.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_proofing.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_roofing.dart';
import '../components/loading_page.dart';
import '../model/quality_checklistModel.dart';
import '../widget/custom_qualitycivil_textfield.dart';
import '../widget/quality_list.dart';
import '../widget/style.dart';

List<dynamic> excavationtabledatalist = [];
List<dynamic> backfillingtabledatalist = [];
List<dynamic> massonarytabledatalist = [];
List<dynamic> doorstabledatalist = [];
List<dynamic> ceillingtabledatalist = [];
List<dynamic> flooringtabledatalist = [];
List<dynamic> inspectiontabledatalist = [];
List<dynamic> inronitetabledatalist = [];
List<dynamic> paintingtabledatalist = [];
List<dynamic> pavingtabledatalist = [];
List<dynamic> roofingtabledatalist = [];
List<dynamic> proofingtabledatalist = [];

late QualityExcavationDataSource _qualityExcavationDataSource;
late QualityBackFillingDataSource _qualityBackFillingDataSource;
late QualityMassonaryDataSource _qualityMassonaryDataSource;
late QualityGlazzingDataSource _qualityGlazzingDataSource;
late QualityCeillingDataSource _qualityCeillingDataSource;
late QualityIroniteflooringDataSource _qualityIroniteflooringDataSource;
late QualityflooringDataSource _qualityflooringDataSource;
late QualityInspectionDataSource _qualityInspectionDataSource;
late QualityPaintingDataSource _qualityPaintingDataSource;
late QualityPavingDataSource _qualityPavingDataSource;
late QualityRoofingDataSource _qualityRoofingDataSource;
late QualityProofingDataSource _qualityProofingDataSource;

List<QualitychecklistModel> qualitylisttable1 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable2 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable3 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable4 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable5 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable6 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable7 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable8 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable9 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable10 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable11 = <QualitychecklistModel>[];
List<QualitychecklistModel> qualitylisttable12 = <QualitychecklistModel>[];

int? _selectedIndex = 0;
// String currentDate = DateFormat.yMMMMd().format(DateTime.now());
List clntitle = [
  'Exc',
  'BF',
  'Mass',
  'DWG',
  'FC',
  'F&T',
  'GI',
  'IF',
  'Painting',
  'Paving',
  'WCR',
  'Proofing'
];

late TextEditingController _field1Controller;
late TextEditingController _field2Controller;
late TextEditingController _field3Controller;
late TextEditingController _field4Controller;
late TextEditingController _field5Controller;
late TextEditingController _field6Controller;
late TextEditingController _field7Controller;
late TextEditingController _field8Controller;

class CivilQualityChecklist extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? currentDate;
  bool? isHeader;

  CivilQualityChecklist(
      {super.key,
      required this.cityName,
      required this.depoName,
      this.currentDate,
      this.isHeader = true});

  @override
  State<CivilQualityChecklist> createState() => _CivilQualityChecklistState();
}

class _CivilQualityChecklistState extends State<CivilQualityChecklist> {
  Stream? _fieldStream;
  Stream? _stream;
  Stream? _stream1;
  Stream? _stream2;
  Stream? _stream3;
  Stream? _stream4;
  Stream? _stream5;
  Stream? _stream6;
  Stream? _stream7;
  Stream? _stream8;
  Stream? _stream9;
  Stream? _stream10;
  Stream? _stream11;
  late DataGridController _dataGridController;
  bool _isloading = true;

  void initializeController() {
    _field1Controller = TextEditingController();
    _field2Controller = TextEditingController();
    _field3Controller = TextEditingController();
    _field4Controller = TextEditingController();
    _field5Controller = TextEditingController();
    _field6Controller = TextEditingController();
    _field7Controller = TextEditingController();
    _field8Controller = TextEditingController();
  }

  initializeStream() {
    _stream = FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection('Exc TABLE')
        .doc(widget.currentDate)
        .snapshots();

    _stream1 = FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection('BackFilling TABLE')
        .doc(widget.currentDate)
        .snapshots();

    _stream2 = FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection('Massonary TABLE')
        .doc(widget.currentDate)
        .snapshots();

    _stream3 = FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection('Glazzing TABLE')
        .doc(widget.currentDate)
        .snapshots();

    _stream4 = FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection('Ceilling TABLE')
        .doc(widget.currentDate)
        .snapshots();

    _stream5 = FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection('Flooring TABLE')
        .doc(widget.currentDate)
        .snapshots();

    _stream6 = FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection('Inspection TABLE')
        .doc(widget.currentDate)
        .snapshots();

    _stream7 = FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection('Ironite TABLE')
        .doc(widget.currentDate)
        .snapshots();

    _stream8 = FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection('Painting TABLE')
        .doc(widget.currentDate)
        .snapshots();

    _stream9 = FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection('Paving TABLE')
        .doc(widget.currentDate)
        .snapshots();
    _stream10 = FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection('Roofing TABLE')
        .doc(widget.currentDate)
        .snapshots();

    _stream11 = FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection('Proofing TABLE')
        .doc(widget.currentDate)
        .snapshots();
  }

  initializeFieldStream() {
    FirebaseFirestore.instance
        .collection('QualityChecklistCollection')
        .doc(widget.depoName)
        .collection('${clntitle[_selectedIndex!]} TABLE')
        .doc(widget.currentDate);
  }

  @override
  void initState() {
    super.initState();
    initializeController();
    getUserId().whenComplete(() {
      initializeStream();

      _isloading = false;
      setState(() {});
    });

    qualitylisttable1 = excavation_getData();
    _qualityExcavationDataSource = QualityExcavationDataSource(
        qualitylisttable1, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();

    qualitylisttable2 = backfilling_getData();
    _qualityBackFillingDataSource = QualityBackFillingDataSource(
        qualitylisttable2, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();

    qualitylisttable3 = massonary_getData();
    _qualityMassonaryDataSource = QualityMassonaryDataSource(
        qualitylisttable3, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();

    qualitylisttable4 = glazzing_getData();
    _qualityGlazzingDataSource = QualityGlazzingDataSource(
        qualitylisttable4, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();

    qualitylisttable5 = ceilling_getData();
    _qualityCeillingDataSource = QualityCeillingDataSource(
        qualitylisttable5, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();

    qualitylisttable6 = florring_getData();
    _qualityflooringDataSource = QualityflooringDataSource(
        qualitylisttable6, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();

    qualitylisttable7 = inspection_getData();
    _qualityInspectionDataSource = QualityInspectionDataSource(
        qualitylisttable7, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();

    qualitylisttable8 = ironite_florring_getData();
    _qualityIroniteflooringDataSource = QualityIroniteflooringDataSource(
        qualitylisttable8, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();

    qualitylisttable9 = painting_getData();
    _qualityPaintingDataSource = QualityPaintingDataSource(
        qualitylisttable9, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();

    qualitylisttable10 = paving_getData();
    _qualityPavingDataSource = QualityPavingDataSource(
        qualitylisttable10, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();

    qualitylisttable11 = roofing_getData();
    _qualityRoofingDataSource = QualityRoofingDataSource(
        qualitylisttable11, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();

    qualitylisttable12 = proofing_getData();
    _qualityProofingDataSource = QualityProofingDataSource(
        qualitylisttable12, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();
  }

  @override
  Widget build(BuildContext context) {
    _field1Controller.clear();
    _field2Controller.clear();
    _field3Controller.clear();
    _field4Controller.clear();
    _field5Controller.clear();
    _field6Controller.clear();
    _field7Controller.clear();
    _field8Controller.clear();

    retrieveFieldData();
    // print('pratyush++');
    return DefaultTabController(
        length: 12,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 20,
            bottom: TabBar(
              labelColor: Colors.yellow,
              labelStyle: buttonWhite,
              unselectedLabelColor: white,

              //indicatorSize: TabBarIndicatorSize.label,

              indicator: MaterialIndicator(
                horizontalPadding: 24,
                bottomLeftRadius: 8,
                bottomRightRadius: 8,
                color: almostblack,
                paintingStyle: PaintingStyle.fill,
              ),
              onTap: (value) {
                _selectedIndex = value;
                setState(() {});
              },
              tabs: const [
                Tab(text: "Exc"),
                Tab(text: "B.F"),
                Tab(text: "Mass"),
                Tab(text: "D.W.G"),
                Tab(text: "F.C"),
                Tab(text: "F&T"),
                Tab(text: "G.I"),
                Tab(text: "I.F"),
                Tab(text: "Painting"),
                Tab(text: "Paving"),
                Tab(text: "WC&R"),
                Tab(text: "Proofing"),
              ],
            ),
          ),
          body: _isloading
              ? LoadingPage()
              : TabBarView(children: [
                  civilupperScreen(),
                  civilupperScreen(),
                  civilupperScreen(),
                  civilupperScreen(),
                  civilupperScreen(),
                  civilupperScreen(),
                  civilupperScreen(),
                  civilupperScreen(),
                  civilupperScreen(),
                  civilupperScreen(),
                  civilupperScreen(),
                  civilupperScreen(),
                ]),
        ));
  }

  civilupperScreen() {
    return _isloading
        ? LoadingPage()
        :
        // StreamBuilder(
        //     stream: _fieldStream,
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return LoadingPage();
        //       }
        //       if (!snapshot.hasData) {
        //         return
        Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                height: 50,
                decoration: BoxDecoration(color: lightblue),
                child: Text(
                  civil_title[int.parse(_selectedIndex.toString())],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  decoration: BoxDecoration(color: lightblue),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _selectedIndex == 0
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomCivilTextField(
                                      controller: _field1Controller,
                                      title: 'Project'),
                                  CustomCivilTextField(
                                      controller: _field2Controller,
                                      title: 'P.O.No.'),
                                  CustomCivilTextField(
                                      controller: _field3Controller,
                                      title: 'Contractor'),
                                  CustomCivilTextField(
                                      controller: _field4Controller,
                                      title: 'Description'),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomCivilTextField(
                                      controller: _field1Controller,
                                      title: 'Vendor / Sub Vendor'),
                                  CustomCivilTextField(
                                      controller: _field2Controller,
                                      title: 'Date'),
                                  CustomCivilTextField(
                                      controller: _field3Controller,
                                      title: 'Grid / Axis Level'),
                                ],
                              ),
                        _selectedIndex == 0
                            ? Column(
                                children: [
                                  CustomCivilTextField(
                                      controller: _field5Controller,
                                      title: 'System / Bldg. '),
                                  CustomCivilTextField(
                                      controller: _field6Controller,
                                      title: 'Ref Document 1'),
                                  CustomCivilTextField(
                                      controller: _field7Controller,
                                      title: 'Ref Document 2'),
                                  CustomCivilTextField(
                                      controller: _field8Controller,
                                      title: 'Ref Document 3'),
                                ],
                              )
                            : Column(
                                children: [
                                  CustomCivilTextField(
                                      controller: _field4Controller,
                                      title: 'Location'),
                                  CustomCivilTextField(
                                      controller: _field5Controller,
                                      title: 'Drawing no.'),
                                  CustomCivilTextField(
                                      controller: _field6Controller,
                                      title: 'Component of the structure'),
                                ],
                              )
                      ])),
              Expanded(
                child: _isloading
                    ? LoadingPage()
                    : StreamBuilder(
                        stream: _selectedIndex == 0
                            ? _stream
                            : _selectedIndex == 1
                                ? _stream1
                                : _selectedIndex == 2
                                    ? _stream2
                                    : _selectedIndex == 3
                                        ? _stream3
                                        : _selectedIndex == 4
                                            ? _stream4
                                            : _selectedIndex == 5
                                                ? _stream5
                                                : _selectedIndex == 6
                                                    ? _stream6
                                                    : _selectedIndex == 7
                                                        ? _stream7
                                                        : _selectedIndex == 8
                                                            ? _stream8
                                                            : _selectedIndex ==
                                                                    9
                                                                ? _stream9
                                                                : _selectedIndex ==
                                                                        10
                                                                    ? _stream10
                                                                    : _stream11,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingPage();
                          } else if (!snapshot.hasData ||
                              snapshot.data.exists == false) {
                            return widget.isHeader!
                                ? SfDataGridTheme(
                                    data:
                                        SfDataGridThemeData(headerColor: blue),
                                    child: SfDataGrid(
                                      source: _selectedIndex == 0
                                          ? _qualityExcavationDataSource
                                          : _selectedIndex == 1
                                              ? _qualityBackFillingDataSource
                                              : _selectedIndex == 2
                                                  ? _qualityMassonaryDataSource
                                                  : _selectedIndex == 3
                                                      ? _qualityGlazzingDataSource
                                                      : _selectedIndex == 4
                                                          ? _qualityCeillingDataSource
                                                          : _selectedIndex == 5
                                                              ? _qualityflooringDataSource
                                                              : _selectedIndex ==
                                                                      6
                                                                  ? _qualityInspectionDataSource
                                                                  : _selectedIndex ==
                                                                          7
                                                                      ? _qualityIroniteflooringDataSource
                                                                      : _selectedIndex ==
                                                                              8
                                                                          ? _qualityPaintingDataSource
                                                                          : _selectedIndex == 9
                                                                              ? _qualityPavingDataSource
                                                                              : _qualityProofingDataSource,
                                      // _selectedIndex == 10
                                      //     ? _qualityRoofingDataSource
                                      //     : _qualityPROOFINGDataSource,

                                      //key: key,
                                      allowEditing: true,
                                      frozenColumnsCount: 2,
                                      gridLinesVisibility:
                                          GridLinesVisibility.both,
                                      headerGridLinesVisibility:
                                          GridLinesVisibility.both,
                                      selectionMode: SelectionMode.single,
                                      navigationMode: GridNavigationMode.cell,
                                      columnWidthMode: ColumnWidthMode.auto,
                                      editingGestureType:
                                          EditingGestureType.tap,
                                      controller: _dataGridController,

                                      // onQueryRowHeight: (details) {
                                      //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                      // },
                                      columns: [
                                        GridColumn(
                                          columnName: 'srNo',
                                          width: 80,
                                          autoFitPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16),
                                          allowEditing: false,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('Sr No',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          width: 350,
                                          columnName: 'checklist',
                                          allowEditing: false,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                                'Checks(Before Start of Backfill Activity)',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'responsibility',
                                          width: 250,
                                          allowEditing: true,
                                          label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                                "Contractor’s Site Engineer",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: white,
                                                )),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'reference',
                                          allowEditing: true,
                                          width: 250,
                                          label: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text("Owner’s Site Engineer",
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'observation',
                                          allowEditing: true,
                                          width: 200,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                                "Observation Comments by  Owner’s Engineer",
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'Upload',
                                          allowEditing: false,
                                          visible: true,
                                          width: 150,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('Upload',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'View',
                                          allowEditing: true,
                                          width: 150,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('View',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                      ],

                                      // stackedHeaderRows: [
                                      //   StackedHeaderRow(cells: [
                                      //     StackedHeaderCell(
                                      //         columnNames: ['SrNo'],
                                      //         child: Container(child: Text('Project')))
                                      //   ])
                                      // ],
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      padding: EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(color: blue)),
                                      child: const Text(
                                        '     No data available yet \n Please wait for admin process',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                          } else if (snapshot.hasData) {
                            alldata = '';
                            alldata = snapshot.data['data'] as List<dynamic>;
                            if (_selectedIndex == 0) {
                              qualitylisttable1.clear();
                              _dataGridController = DataGridController();
                            } else if (_selectedIndex == 1) {
                              qualitylisttable2.clear();
                              _dataGridController = DataGridController();
                            } else if (_selectedIndex == 2) {
                              qualitylisttable3.clear();
                              _dataGridController = DataGridController();
                            } else if (_selectedIndex == 3) {
                              qualitylisttable4.clear();
                            } else if (_selectedIndex == 4) {
                              qualitylisttable5.clear();
                              _dataGridController = DataGridController();
                            } else if (_selectedIndex == 5) {
                              qualitylisttable6.clear();
                              _dataGridController = DataGridController();
                            } else if (_selectedIndex == 6) {
                              qualitylisttable7.clear();
                              _dataGridController = DataGridController();
                              _dataGridController = DataGridController();
                            } else if (_selectedIndex == 7) {
                              qualitylisttable8.clear();
                              _dataGridController = DataGridController();
                              _dataGridController = DataGridController();
                            } else if (_selectedIndex == 8) {
                              qualitylisttable9.clear();
                              _dataGridController = DataGridController();
                            } else if (_selectedIndex == 9) {
                              qualitylisttable10.clear();
                              _dataGridController = DataGridController();
                            } else if (_selectedIndex == 10) {
                              qualitylisttable11.clear();
                              _dataGridController = DataGridController();
                            } else {
                              qualitylisttable12.clear();
                              _dataGridController = DataGridController();
                            }

                            alldata.forEach((element) {
                              if (_selectedIndex == 0) {
                                qualitylisttable1.add(
                                    QualitychecklistModel.fromJson(element));
                                _qualityExcavationDataSource =
                                    QualityExcavationDataSource(
                                        qualitylisttable1,
                                        widget.cityName!,
                                        widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 1) {
                                qualitylisttable2.add(
                                    QualitychecklistModel.fromJson(element));
                                _qualityBackFillingDataSource =
                                    QualityBackFillingDataSource(
                                        qualitylisttable2,
                                        widget.cityName!,
                                        widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 2) {
                                qualitylisttable3.add(
                                    QualitychecklistModel.fromJson(element));
                                _qualityMassonaryDataSource =
                                    QualityMassonaryDataSource(
                                        qualitylisttable3,
                                        widget.cityName!,
                                        widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 3) {
                                qualitylisttable4.add(
                                    QualitychecklistModel.fromJson(element));
                                _qualityGlazzingDataSource =
                                    QualityGlazzingDataSource(qualitylisttable4,
                                        widget.cityName!, widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 4) {
                                qualitylisttable5.add(
                                    QualitychecklistModel.fromJson(element));
                                _qualityCeillingDataSource =
                                    QualityCeillingDataSource(qualitylisttable5,
                                        widget.cityName!, widget.depoName!);

                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 5) {
                                qualitylisttable6.add(
                                    QualitychecklistModel.fromJson(element));
                                _qualityflooringDataSource =
                                    QualityflooringDataSource(qualitylisttable6,
                                        widget.cityName!, widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 6) {
                                qualitylisttable7.add(
                                    QualitychecklistModel.fromJson(element));
                                _qualityInspectionDataSource =
                                    QualityInspectionDataSource(
                                        qualitylisttable7,
                                        widget.cityName!,
                                        widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 7) {
                                qualitylisttable8.add(
                                    QualitychecklistModel.fromJson(element));

                                _qualityIroniteflooringDataSource =
                                    QualityIroniteflooringDataSource(
                                        qualitylisttable8,
                                        widget.cityName!,
                                        widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 8) {
                                qualitylisttable9.add(
                                    QualitychecklistModel.fromJson(element));

                                _qualityPaintingDataSource =
                                    QualityPaintingDataSource(qualitylisttable9,
                                        widget.cityName!, widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 9) {
                                qualitylisttable10.add(
                                    QualitychecklistModel.fromJson(element));
                                _qualityPavingDataSource =
                                    QualityPavingDataSource(qualitylisttable10,
                                        widget.cityName!, widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 10) {
                                qualitylisttable11.add(
                                    QualitychecklistModel.fromJson(element));
                                _qualityRoofingDataSource =
                                    QualityRoofingDataSource(qualitylisttable11,
                                        widget.cityName!, widget.depoName!);
                              } else {
                                qualitylisttable12.add(
                                    QualitychecklistModel.fromJson(element));
                                _qualityProofingDataSource =
                                    QualityProofingDataSource(
                                        qualitylisttable12,
                                        widget.cityName!,
                                        widget.depoName!);
                              }
                            });
                            return SfDataGridTheme(
                              data: SfDataGridThemeData(headerColor: blue),
                              child: SfDataGrid(
                                source: _selectedIndex == 0
                                    ? _qualityExcavationDataSource
                                    : _selectedIndex == 1
                                        ? _qualityBackFillingDataSource
                                        : _selectedIndex == 2
                                            ? _qualityMassonaryDataSource
                                            : _selectedIndex == 3
                                                ? _qualityGlazzingDataSource
                                                : _selectedIndex == 4
                                                    ? _qualityCeillingDataSource
                                                    : _selectedIndex == 5
                                                        ? _qualityflooringDataSource
                                                        : _selectedIndex == 6
                                                            ? _qualityInspectionDataSource
                                                            : _selectedIndex ==
                                                                    7
                                                                ? _qualityIroniteflooringDataSource
                                                                : _selectedIndex ==
                                                                        8
                                                                    ? _qualityPaintingDataSource
                                                                    : _selectedIndex ==
                                                                            9
                                                                        ? _qualityPavingDataSource
                                                                        : _selectedIndex ==
                                                                                10
                                                                            ? _qualityRoofingDataSource
                                                                            : _qualityProofingDataSource,

                                //key: key,
                                allowEditing: true,
                                frozenColumnsCount: 2,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                selectionMode: SelectionMode.single,
                                navigationMode: GridNavigationMode.cell,
                                columnWidthMode: ColumnWidthMode.auto,
                                editingGestureType: EditingGestureType.tap,
                                controller: _dataGridController,

                                // onQueryRowHeight: (details) {
                                //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                // },
                                columns: [
                                  GridColumn(
                                    columnName: 'srNo',
                                    width: 80,
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: false,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('Sr No',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: white)),
                                    ),
                                  ),
                                  GridColumn(
                                    width: 350,
                                    columnName: 'checklist',
                                    allowEditing: false,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('ACTIVITY',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: white)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'responsibility',
                                    width: 250,
                                    allowEditing: true,
                                    label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: Text('RESPONSIBILITY',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: white,
                                          )),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'reference',
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('DOCUMENT REFERENCE',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: white)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'observation',
                                    allowEditing: true,
                                    width: 200,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('OBSERVATION',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: white)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Upload',
                                    allowEditing: false,
                                    visible: true,
                                    width: 150,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('Upload.',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: white)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'View',
                                    allowEditing: true,
                                    width: 150,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('View',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: white)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return LoadingPage();
                          }
                        },
                      ),
              ),
            ],
          );
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }

  void retrieveFieldData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(widget.depoName)
        .collection('userId')
        .doc('ZW3210')
        .collection('${clntitle[_selectedIndex!]} TABLE')
        .doc(widget.currentDate)
        .get();

    Map<String, dynamic> tempMap =
        documentSnapshot.data() as Map<String, dynamic>;

    print(tempMap);

    _field1Controller.text = tempMap['Project'] ?? '';
    _field2Controller.text = tempMap['PO No'] ?? '';
    _field3Controller.text = tempMap['Contractor'] ?? '';
    _field4Controller.text = tempMap['Description'] ?? '';
    _field5Controller.text = tempMap['System'] ?? '';
    _field6Controller.text = tempMap['Ref Document1'] ?? '';
    _field7Controller.text = tempMap['Ref Document2'] ?? '';
    _field8Controller.text = tempMap['Ref Document3'] ?? '';
  }
}

civilstoreData(BuildContext context, String depoName, String currentDate) {
  Map<String, dynamic> excavationTableData = Map();
  Map<String, dynamic> backfillingTableData = Map();
  Map<String, dynamic> massonaryTableData = Map();
  Map<String, dynamic> doorsTableData = Map();
  Map<String, dynamic> ceillingTableData = Map();
  Map<String, dynamic> flooringTableData = Map();
  Map<String, dynamic> inspectionTableData = Map();
  Map<String, dynamic> inroniteTableData = Map();
  Map<String, dynamic> paintingTableData = Map();
  Map<String, dynamic> pavingTableData = Map();
  Map<String, dynamic> roofingTableData = Map();
  Map<String, dynamic> proofingTableData = Map();

  for (var i in _qualityExcavationDataSource.dataGridRows) {
    for (var data in i.getCells()) {
      if (data.columnName != 'Upload' ||
          data.columnName != 'View' ||
          data.columnName != 'Delete') {
        excavationTableData[data.columnName] = data.value;
      }
    }

    excavationtabledatalist.add(excavationTableData);
    excavationTableData = {};
  }

  FirebaseFirestore.instance
      .collection('CivilQualityChecklist')
      .doc(depoName)
      .collection('userId')
      .doc(userId)
      .collection('Exc TABLE')
      .doc(currentDate)
      .set({
    'data': excavationtabledatalist,
  }).whenComplete(() {
    excavationtabledatalist.clear();
    for (var i in _qualityBackFillingDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'Upload' ||
            data.columnName != 'View' ||
            data.columnName != 'Delete') {
          backfillingTableData[data.columnName] = data.value;
        }
      }
      backfillingtabledatalist.add(backfillingTableData);
      backfillingTableData = {};
    }

    FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection('BackFilling TABLE')
        .doc(currentDate)
        .set({
      'data': backfillingtabledatalist,
    }).whenComplete(() {
      backfillingtabledatalist.clear();
      for (var i in _qualityMassonaryDataSource.dataGridRows) {
        for (var data in i.getCells()) {
          if (data.columnName != 'Upload' ||
              data.columnName == 'View' ||
              data.columnName != 'Delete') {
            massonaryTableData[data.columnName] = data.value;
          }
        }

        massonarytabledatalist.add(massonaryTableData);
        massonaryTableData = {};
      }

      FirebaseFirestore.instance
          .collection('CivilQualityChecklist')
          .doc(depoName)
          .collection('userId')
          .doc(userId)
          .collection('Massonary TABLE')
          .doc(currentDate)
          .set({
        'data': massonarytabledatalist,
      }).whenComplete(() {
        massonarytabledatalist.clear();
        for (var i in _qualityGlazzingDataSource.dataGridRows) {
          for (var data in i.getCells()) {
            if (data.columnName != 'Upload' &&
                data.columnName != 'View' &&
                data.columnName != 'Delete') {
              doorsTableData[data.columnName] = data.value;
            }
          }
          doorstabledatalist.add(doorsTableData);
          doorsTableData = {};
        }

        FirebaseFirestore.instance
            .collection('CivilQualityChecklist')
            .doc(depoName)
            .collection('userId')
            .doc(userId)
            .collection('Glazzing TABLE')
            .doc(currentDate)
            .set({
          'data': doorstabledatalist,
        }).whenComplete(() {
          doorstabledatalist.clear();
          for (var i in _qualityCeillingDataSource.dataGridRows) {
            for (var data in i.getCells()) {
              if (data.columnName != 'Upload' &&
                  data.columnName != 'View' &&
                  data.columnName != 'Delete') {
                ceillingTableData[data.columnName] = data.value;
              }
            }
            ceillingtabledatalist.add(ceillingTableData);
            ceillingTableData = {};
          }

          FirebaseFirestore.instance
              .collection('CivilQualityChecklist')
              .doc(depoName)
              .collection('userId')
              .doc(userId)
              .collection('Ceilling TABLE')
              .doc(currentDate)
              .set({
            'data': ceillingtabledatalist,
          }).whenComplete(() {
            ceillingtabledatalist.clear();
            for (var i in _qualityflooringDataSource.dataGridRows) {
              for (var data in i.getCells()) {
                if (data.columnName != 'Upload' &&
                    data.columnName != 'View' &&
                    data.columnName != 'Delete') {
                  flooringTableData[data.columnName] = data.value;
                }
              }
              flooringtabledatalist.add(flooringTableData);
              flooringTableData = {};
            }

            FirebaseFirestore.instance
                .collection('CivilQualityChecklist')
                .doc(depoName)
                .collection('userId')
                .doc(userId)
                .collection('Flooring TABLE')
                .doc(currentDate)
                .set({
              'data': flooringtabledatalist,
            }).whenComplete(() {
              // for (var i in _qualityflooringDataSource.dataGridRows) {
              //   for (var data in i.getCells()) {
              //     if (data.columnName != 'Upload' ||
              //         data.columnName == 'View' ||
              //         data.columnName != 'Delete') {
              //       flooringTableData[data.columnName] = data.value;
              //     }
              //   }
              //   flooringtabledatalist.add(flooringTableData);
              //   flooringTableData = {};
              // }

              // FirebaseFirestore.instance
              //     .collection('QualityChecklist')
              //     .doc(depoName)
              //     .collection('FLOORING TABLE DATA')
              //     .doc('FLOORING DATA')
              //     .collection(userId)
              //     .doc(currentDate)
              //     .set({
              //   'data': flooringtabledatalist,
              // }).whenComplete(() {
              flooringtabledatalist.clear();
              for (var i in _qualityInspectionDataSource.dataGridRows) {
                for (var data in i.getCells()) {
                  if (data.columnName != 'Upload' &&
                      data.columnName != 'View' &&
                      data.columnName != 'Delete') {
                    inspectionTableData[data.columnName] = data.value;
                  }
                }
                inspectiontabledatalist.add(inspectionTableData);
                inspectionTableData = {};
              }

              FirebaseFirestore.instance
                  .collection('CivilQualityChecklist')
                  .doc(depoName)
                  .collection('userId')
                  .doc(userId)
                  .collection('Inspection TABLE')
                  .doc(currentDate)
                  .set({
                'data': inspectiontabledatalist,
              }).whenComplete(() {
                inspectiontabledatalist.clear();
                for (var i in _qualityIroniteflooringDataSource.dataGridRows) {
                  for (var data in i.getCells()) {
                    if (data.columnName != 'Upload' &&
                        data.columnName != 'View' &&
                        data.columnName != 'Delete') {
                      inroniteTableData[data.columnName] = data.value;
                    }
                  }
                  inronitetabledatalist.add(inroniteTableData);
                  inroniteTableData = {};
                }

                FirebaseFirestore.instance
                    .collection('CivilQualityChecklist')
                    .doc(depoName)
                    .collection('userId')
                    .doc(userId)
                    .collection('Ironite TABLE')
                    .doc(currentDate)
                    .set({
                  'data': inronitetabledatalist,
                }).whenComplete(() {
                  inronitetabledatalist.clear();
                  for (var i in _qualityPaintingDataSource.dataGridRows) {
                    for (var data in i.getCells()) {
                      if (data.columnName != 'Upload' &&
                          data.columnName != 'View' &&
                          data.columnName != 'Delete') {
                        paintingTableData[data.columnName] = data.value;
                      }
                    }
                    paintingtabledatalist.add(paintingTableData);
                    paintingTableData = {};
                  }

                  FirebaseFirestore.instance
                      .collection('CivilQualityChecklist')
                      .doc(depoName)
                      .collection('userId')
                      .doc(userId)
                      .collection('Painting TABLE')
                      .doc(currentDate)
                      .set({
                    'data': paintingtabledatalist,
                  }).whenComplete(() {
                    paintingtabledatalist.clear();
                    for (var i in _qualityPavingDataSource.dataGridRows) {
                      for (var data in i.getCells()) {
                        if (data.columnName != 'Upload' &&
                            data.columnName != 'View' &&
                            data.columnName != 'Delete') {
                          pavingTableData[data.columnName] = data.value;
                        }
                      }
                      pavingtabledatalist.add(pavingTableData);
                      pavingTableData = {};
                    }

                    FirebaseFirestore.instance
                        .collection('CivilQualityChecklist')
                        .doc(depoName)
                        .collection('userId')
                        .doc(userId)
                        .collection('Paving TABLE')
                        .doc(currentDate)
                        .set({
                      'data': pavingtabledatalist,
                    }).whenComplete(() {
                      pavingtabledatalist.clear();
                      for (var i in _qualityRoofingDataSource.dataGridRows) {
                        for (var data in i.getCells()) {
                          if (data.columnName != 'Upload' &&
                              data.columnName != 'View' &&
                              data.columnName != 'Delete') {
                            roofingTableData[data.columnName] = data.value;
                          }
                        }
                        roofingtabledatalist.add(roofingTableData);
                        roofingTableData = {};
                      }

                      FirebaseFirestore.instance
                          .collection('CivilQualityChecklist')
                          .doc(depoName)
                          .collection('userId')
                          .doc(userId)
                          .collection('Roofing TABLE')
                          .doc(currentDate)
                          .set({
                        'data': roofingtabledatalist,
                      }).whenComplete(() {
                        roofingtabledatalist.clear();
                        for (var i in _qualityProofingDataSource.dataGridRows) {
                          for (var data in i.getCells()) {
                            if (data.columnName != 'Upload' &&
                                data.columnName != 'View' &&
                                data.columnName != 'Delete') {
                              proofingTableData[data.columnName] = data.value;
                            }
                          }
                          proofingtabledatalist.add(proofingTableData);
                          proofingTableData = {};
                        }

                        FirebaseFirestore.instance
                            .collection('CivilQualityChecklist')
                            .doc(depoName)
                            .collection('userId')
                            .doc(userId)
                            .collection('Proofing TABLE')
                            .doc(currentDate)
                            .set({
                          'data': proofingtabledatalist,
                        }).whenComplete(() {
                          proofingtabledatalist.clear();
                          FirebaseApi().nestedKeyEventsField(
                              'CivilQualityChecklist',
                              depoName,
                              'userId',
                              userId);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Data are synced'),
                            backgroundColor: blue,
                          ));
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  });
}

storeFieldData(String depoName, String currentDate) {
  FirebaseFirestore.instance
      .collection('CivilChecklistField')
      .doc(depoName)
      .collection('userId')
      .doc(userId)
      .collection('${clntitle[_selectedIndex!]} TABLE')
      .doc(currentDate)
      .set({
    'Project': _field1Controller.text.toString(),
    'PO No': _field2Controller.text.toString(),
    'Contractor': _field3Controller.text.toString(),
    'Description': _field4Controller.text.toString(),
    'System': _field5Controller.text.toString(),
    'Ref Document1': _field6Controller.text.toString(),
    'Ref Document2': _field7Controller.text.toString(),
    'Ref Document3': _field8Controller.text.toString(),
  });

  FirebaseApi()
      .nestedKeyEventsField('CivilChecklistField', depoName, 'userId', userId);
}
