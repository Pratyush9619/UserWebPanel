import 'package:assingment/Planning_Pages/electrical_quality_checklist.dart';
import 'package:assingment/Planning_Pages/quality_checklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

String? selectedDate = DateFormat.yMMMMd().format(DateTime.now());
DateTime currentDate = DateTime.now();

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

List<String> tabForCivil = [
  'Exc',
  'BackFilling',
  'Massonary',
  'Glazzing',
  'Ceilling',
  'Flooring',
  'Inspection',
  'Ironite',
  'Painting',
  'Paving',
  'Roofing',
  'Proofing'
];

TextEditingController projectNameController = TextEditingController();
TextEditingController locationNameController = TextEditingController();
TextEditingController dateController = TextEditingController();
TextEditingController complonentController = TextEditingController();
TextEditingController gridController = TextEditingController();
TextEditingController vendorController = TextEditingController();
TextEditingController drawingController = TextEditingController();
TextEditingController fillingController = TextEditingController();

int? _selectedIndex = 0;

class CivilQualityChecklist extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? currentDate;
  bool? isHeader;
  Function? getBoolList;

  CivilQualityChecklist({
    super.key,
    required this.cityName,
    required this.depoName,
    this.currentDate,
    this.isHeader = true,
    this.getBoolList,
  });

  @override
  State<CivilQualityChecklist> createState() => _CivilQualityChecklistState();
}

class _CivilQualityChecklistState extends State<CivilQualityChecklist> {
  List<bool> civilTabBool = [];
  List<QualitychecklistModel> data = [];
  bool checkTable = true;

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
  late DataGridController _dataGridController;
  bool _isloading = false;

  @override
  void initState() {
    setBoolean();
    if (_selectedIndex == 0) {
      civilTabBool[0] = true;
      print(civilTabBool);
      widget.getBoolList!(civilTabBool, tabForCivil[_selectedIndex!]);
    }

    getUserId().whenComplete(() => {
          getControllersData(),
          getTableData().whenComplete(() => {
                qualitylisttable1 = checkTable ? excavation_getData() : data,
                _qualityExcavationDataSource = QualityExcavationDataSource(
                    qualitylisttable1, widget.depoName!, widget.cityName!),
                _dataGridController = DataGridController(),
              }),
        });

    super.initState();

    qualitylisttable2 = backfilling_getData();
    _qualityBackFillingDataSource = QualityBackFillingDataSource(
        qualitylisttable2, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();
    qualitylisttable3 = massonary_getData();
    _qualityMassonaryDataSource = QualityMassonaryDataSource(
        qualitylisttable3, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();
    qualitylisttable4 = glazzing_getData();
    _qualityGlazzingDataSource = QualityGlazzingDataSource(
        qualitylisttable4, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();
    qualitylisttable5 = ceilling_getData();
    _qualityCeillingDataSource = QualityCeillingDataSource(
        qualitylisttable5, widget.depoName!, widget.cityName!);
    qualitylisttable6 = florring_getData();
    _qualityflooringDataSource = QualityflooringDataSource(
        qualitylisttable6, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();
    qualitylisttable7 = inspection_getData();
    _qualityInspectionDataSource = QualityInspectionDataSource(
        qualitylisttable7, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();
    qualitylisttable8 = ironite_florring_getData();
    _qualityIroniteflooringDataSource = QualityIroniteflooringDataSource(
        qualitylisttable8, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();
    qualitylisttable9 = painting_getData();
    _qualityPaintingDataSource = QualityPaintingDataSource(
        qualitylisttable9, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();
    qualitylisttable10 = paving_getData();
    _qualityPavingDataSource = QualityPavingDataSource(
        qualitylisttable10, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();
    qualitylisttable11 = roofing_getData();
    _qualityRoofingDataSource = QualityRoofingDataSource(
        qualitylisttable11, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();
    qualitylisttable12 = proofing_getData();
    _qualityProofingDataSource = QualityProofingDataSource(
        qualitylisttable12, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();
  }

  @override
  Widget build(BuildContext context) {
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
              onTap: (value) async {
                _selectedIndex = value;
                checkTable = true;
                selectedDate =
                    DateFormat('MMMM dd, yyyy').format(DateTime.now());
                currentDate = DateTime.now();
                setBoolean();
                getControllersData();
                await getTableData();

                civilTabBool[value] = true;
                widget.getBoolList!(civilTabBool, tabForCivil[value]);
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
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('CivilChecklistField')
          .doc('${widget.depoName}')
          .collection('userId')
          .doc(userId)
          .collection(tabForCivil[_selectedIndex!])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                height: 80,
                decoration: BoxDecoration(color: lightblue),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/Tata-Power.jpeg',
                            height: 50, width: 100),
                        const Text('TATA POWER'),
                      ],
                    ),
                    Text(
                      civil_title[int.parse(_selectedIndex.toString())],
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.white)),
                        onPressed: () => _selectDate(context),
                        child: Text(
                          DateFormat('MMMM dd, yyyy').format(currentDate),
                          style: GoogleFonts.aBeeZee(
                              fontSize: 15, color: Colors.black),
                        )),
                    const Text('TPCL /DIST/EV/CHECKLIST ')
                  ],
                ),
              ),
              Container(
                  decoration: BoxDecoration(color: lightblue),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            color: lightblue,
                            width: 600,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const SizedBox(
                                    width: 150,
                                    child: Text(
                                      'Project',
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: SizedBox(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller:
                                                    projectNameController,
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          top: 0,
                                                          bottom: 0,
                                                          left: 5),
                                                ),
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          ),
                          Container(
                            color: lightblue,
                            width: 600,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const SizedBox(
                                    width: 150,
                                    child: Text(
                                      'Location',
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: SizedBox(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller:
                                                    locationNameController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 5)),
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          ),
                          Container(
                            color: lightblue,
                            width: 600,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: const Text(
                                      'Vendor / Sub Vendor',
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller: vendorController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 5)),
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          ),
                          Container(
                            color: lightblue,
                            width: 600,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: const Text(
                                      'Drawing No:',
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller: drawingController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 5)),
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            color: lightblue,
                            width: 600,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: Text(
                                      'Date',
                                    )),
                                SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller: dateController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 5)),
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          ),
                          Container(
                            color: lightblue,
                            width: 600,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: const Text(
                                      'Component of the Structure',
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller:
                                                    complonentController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 5)),
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          ),
                          Container(
                            color: lightblue,
                            width: 600,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: const Text(
                                      'Grid / Axis & Level',
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller: gridController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 5)),
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          ),
                          Container(
                            color: lightblue,
                            width: 600,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: const Text(
                                      'Type of Filling',
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller: fillingController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 5)),
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              Expanded(
                child: StreamBuilder(
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
                                                      : _selectedIndex == 9
                                                          ? _stream9
                                                          : _stream10,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingPage();
                    }
                    if (!snapshot.hasData || snapshot.data.exists == false) {
                      return widget.isHeader!
                          ? SfDataGridTheme(
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
                                      child: Text(
                                          'Checks(Before Start of Backfill Activity)',
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
                                      child: Text("Contractor’s Site Engineer",
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
                                      child: Text("Owner’s Site Engineer",
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
                                      child: Text(
                                          "Observation Comments by  Owner’s Engineer",
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
                                      child: Text('Upload',
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
                                    borderRadius: BorderRadius.circular(20),
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
                      // alldata = '';
                      // alldata = snapshot.data['data'] as List<dynamic>;
                      qualitylisttable1.clear();
                      alldata.forEach((element) {
                        qualitylisttable1
                            .add(QualitychecklistModel.fromJson(element));
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
                                                      : _selectedIndex == 7
                                                          ? _qualityIroniteflooringDataSource
                                                          : _selectedIndex == 8
                                                              ? _qualityPaintingDataSource
                                                              : _selectedIndex ==
                                                                      9
                                                                  ? _qualityPavingDataSource
                                                                  : _selectedIndex ==
                                                                          10
                                                                      ? _qualityRoofingDataSource
                                                                      : _qualityProofingDataSource,

                          allowEditing: true,
                          frozenColumnsCount: 2,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
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
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              allowEditing: false,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                      // here w3e have to put Nodata page
                      return LoadingPage();
                    }
                  },
                ),
              ),
            ],
          );
        } else {
          return LoadingPage();
        }
      },
    );
  }

  Future<void> setBoolean() async {
    List<bool> tempList = [];
    for (int i = 0; i < tabForCivil.length; i++) {
      tempList.add(false);
    }
    civilTabBool = tempList;
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != currentDate) {
      currentDate = picked;
      selectedDate = DateFormat.yMMMMd().format(currentDate);
      getControllersData();
      getTableData();
    }
  }

  Future<void> getControllersData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(selectedDate)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> controllerData =
          documentSnapshot.data() as Map<String, dynamic>;

      projectNameController.text = controllerData['projectName'] ?? '';
      locationNameController.text = controllerData['location'] ?? '';
      complonentController.text = controllerData['componentName'] ?? '';
      dateController.text = controllerData['date'] ?? '';
      drawingController.text = controllerData['drawing'] ?? '';
      gridController.text = controllerData['grid'] ?? '';
      vendorController.text = controllerData['vendor'] ?? '';
      fillingController.text = controllerData['filling'] ?? '';

      print('Data - $controllerData');
    } else {
      projectNameController.clear();
      locationNameController.clear();
      complonentController.clear();
      dateController.clear();
      drawingController.clear();
      gridController.clear();
      vendorController.clear();
      fillingController.clear();
    }
  }

  Future<void> getTableData() async {
    if (_isloading == false) {
      setState(() {
        _isloading = true;
      });
    }

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(selectedDate)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> tempData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapData = tempData['data'];

      data = mapData.map((map) => QualitychecklistModel.fromJson(map)).toList();
      checkTable = false;
    }

    if (_selectedIndex == 1) {
      qualitylisttable2 = checkTable ? backfilling_getData() : data;
      _qualityBackFillingDataSource = QualityBackFillingDataSource(
          qualitylisttable2, widget.depoName!, widget.cityName!);
      _dataGridController = DataGridController();
    } else if (_selectedIndex == 2) {
      qualitylisttable3 = checkTable ? massonary_getData() : data;
      _qualityMassonaryDataSource = QualityMassonaryDataSource(
          qualitylisttable3, widget.depoName!, widget.cityName!);
      _dataGridController = DataGridController();
    } else if (_selectedIndex == 3) {
      qualitylisttable4 = checkTable ? glazzing_getData() : data;
      _qualityGlazzingDataSource = QualityGlazzingDataSource(
          qualitylisttable4, widget.depoName!, widget.cityName!);
      _dataGridController = DataGridController();
    } else if (_selectedIndex == 4) {
      qualitylisttable5 = checkTable ? ceilling_getData() : data;
      _qualityCeillingDataSource = QualityCeillingDataSource(
          qualitylisttable5, widget.depoName!, widget.cityName!);
      _dataGridController = DataGridController();
    } else if (_selectedIndex == 5) {
      qualitylisttable6 = checkTable ? florring_getData() : data;
      _qualityflooringDataSource = QualityflooringDataSource(
          qualitylisttable6, widget.depoName!, widget.cityName!);
      _dataGridController = DataGridController();
    } else if (_selectedIndex == 6) {
      qualitylisttable7 = checkTable ? inspection_getData() : data;
      _qualityInspectionDataSource = QualityInspectionDataSource(
          qualitylisttable7, widget.depoName!, widget.cityName!);
      _dataGridController = DataGridController();
    } else if (_selectedIndex == 7) {
      qualitylisttable8 = checkTable ? ironite_florring_getData() : data;
      _qualityIroniteflooringDataSource = QualityIroniteflooringDataSource(
          qualitylisttable8, widget.depoName!, widget.cityName!);
      _dataGridController = DataGridController();
    } else if (_selectedIndex == 8) {
      qualitylisttable9 = checkTable ? painting_getData() : data;
      _qualityPaintingDataSource = QualityPaintingDataSource(
          qualitylisttable9, widget.depoName!, widget.cityName!);
      _dataGridController = DataGridController();
    } else if (_selectedIndex == 9) {
      qualitylisttable10 = checkTable ? paving_getData() : data;
      _qualityPavingDataSource = QualityPavingDataSource(
          qualitylisttable10, widget.depoName!, widget.cityName!);
      _dataGridController = DataGridController();
    } else if (_selectedIndex == 10) {
      print('roofing');
      qualitylisttable11 = checkTable ? roofing_getData() : data;
      _qualityRoofingDataSource = QualityRoofingDataSource(
          qualitylisttable11, widget.depoName!, widget.cityName!);
      _dataGridController = DataGridController();
    } else if (_selectedIndex == 11) {
      print('Proofing');
      qualitylisttable12 = checkTable ? proofing_getData() : data;
      _qualityProofingDataSource = QualityProofingDataSource(
          qualitylisttable12, widget.depoName!, widget.cityName!);
      _dataGridController = DataGridController();
    }

    _isloading = false;
    setState(() {});
  }
}

CivilstoreData(BuildContext context, String depoName, String currentDate,
    List<bool> isTabSelected, String selectedTabName) {
  Map<String, dynamic> excavationTableData = {};
  Map<String, dynamic> backfillingTableData = {};
  Map<String, dynamic> massonaryTableData = {};
  Map<String, dynamic> doorsTableData = {};
  Map<String, dynamic> ceillingTableData = {};
  Map<String, dynamic> flooringTableData = {};
  Map<String, dynamic> inspectionTableData = {};
  Map<String, dynamic> paintingTableData = {};
  Map<String, dynamic> pavingTableData = {};
  Map<String, dynamic> roofingTableData = {};
  Map<String, dynamic> proofingTableData = {};

  if (isTabSelected[0]) {
    print('$currentDate');
    for (var i in _qualityExcavationDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
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
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': excavationtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    excavationtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': complonentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[1]) {
    excavationTableData.clear();
    for (var i in _qualityBackFillingDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          backfillingTableData[data.columnName] = data.value ?? '';
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
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': backfillingtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    backfillingtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': complonentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[2]) {
    backfillingTableData.clear();
    for (var i in _qualityMassonaryDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
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
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': massonarytabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    massonarytabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': complonentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[3]) {
    massonaryTableData.clear();
    for (var i in _qualityGlazzingDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
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
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': doorstabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    doorstabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': complonentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[4]) {
    doorsTableData.clear();
    for (var i in _qualityCeillingDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' || data.columnName != 'Delete') {
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
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': ceillingtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    ceillingTableData.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': complonentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[5]) {
    ceillingTableData.clear();
    for (var i in _qualityflooringDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
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
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': flooringtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    flooringtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': complonentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[6]) {
    flooringTableData.clear();
    for (var i in _qualityInspectionDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
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
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': inspectiontabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    inspectiontabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': complonentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[7]) {
    inspectionTableData.clear();
    for (var i in _qualityflooringDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
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
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': flooringtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    flooringtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': complonentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[8]) {
    flooringTableData.clear();
    for (var i in _qualityPaintingDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
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
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': paintingtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    paintingtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': complonentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[9]) {
    paintingTableData.clear();
    for (var i in _qualityPavingDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
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
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': pavingtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    pavingtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': complonentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[10]) {
    pavingtabledatalist.clear();
    for (var i in _qualityRoofingDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
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
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': roofingtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    roofingtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': complonentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[11]) {
    roofingTableData.clear();
    for (var i in _qualityProofingDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
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
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': proofingtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    proofingtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': complonentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  }
}
