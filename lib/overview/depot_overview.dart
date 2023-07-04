// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Authentication/auth_service.dart';
import '../FirebaseApi/firebase_api.dart';
import '../KeysEvents/view_AllFiles.dart';
import '../components/loading_page.dart';
import '../datasource/depot_overviewdatasource.dart';
import '../model/depot_overview.dart';
import '../widget/chart_data.dart';
import '../widget/custom_appbar.dart';
import '../widget/custom_textfield.dart';
import '../widget/style.dart';

class DepotOverview extends StatefulWidget {
  String? cityName;
  String? depoName;

  DepotOverview({super.key, required this.cityName, required this.depoName});

  @override
  State<DepotOverview> createState() => _DepotOverviewState();
}

class _DepotOverviewState extends State<DepotOverview> {
  late DepotOverviewDatasource _employeeDataSource;
  List<DepotOverviewModel> _employees = <DepotOverviewModel>[];
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  FilePickerResult? result;
  FilePickerResult? result1;
  FilePickerResult? result2;
  // TextEditingController _addressController = TextEditingController();
  bool _isloading = true;
  late TextEditingController _addressController,
      _scopeController,
      _chargerController,
      _ratingController,
      _loadController,
      _powersourceController,
      _elctricalManagerNameController,
      _electricalEngineerController,
      _electricalVendorController,
      _civilManagerNameController,
      _civilEngineerController,
      _civilVendorController;

  // var address,
  //     scope,
  //     required,
  //     charger,
  //     load,
  //     powerSource,
  //     boqElectrical,
  //     boqCivil,
  //     managername,
  //     electmanagername,
  //     elecEng,
  //     elecVendor,
  //     civilmanagername,
  //     civilEng,
  //     civilVendor;

  Stream? _stream, _stream1;
  var alldata;
  Uint8List? fileBytes;
  Uint8List? fileBytes1;
  Uint8List? fileBytes2;
  dynamic userId;
  bool _isEdit = true;

  void initializeController() {
    _addressController = TextEditingController();
    _scopeController = TextEditingController();
    _chargerController = TextEditingController();
    _ratingController = TextEditingController();
    _loadController = TextEditingController();
    _powersourceController = TextEditingController();
    _elctricalManagerNameController = TextEditingController();
    _electricalEngineerController = TextEditingController();
    _electricalVendorController = TextEditingController();
    _civilManagerNameController = TextEditingController();
    _civilEngineerController = TextEditingController();
    _civilVendorController = TextEditingController();
  }

  @override
  void initState() {
    initializeController();
    getUserId().whenComplete(() {
      _employees = getEmployeeData();
      // ignore: use_build_context_synchronously
      _employeeDataSource = DepotOverviewDatasource(_employees, context);
      _dataGridController = DataGridController();
      _stream = FirebaseFirestore.instance
          .collection('OverviewCollectionTable')
          .doc(widget.depoName)
          .collection("OverviewTabledData")
          .doc(userId)
          .snapshots();

      _stream1 = FirebaseFirestore.instance
          .collection('OverviewCollection')
          .doc(widget.depoName)
          .collection('OverviewFieldData')
          .doc(userId)
          .snapshots();

      _fetchUserData();
      _isloading = false;
      setState(() {});
    });

    super.initState();
  }

  final List<PieChartData> chartData = [
    PieChartData('A1', 25, blue),
    PieChartData('A2', 38, Colors.lightBlue),
    PieChartData('A3', 34, green),
    PieChartData('A4', 52, Colors.yellow)
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: PreferredSize(
            // ignore: sort_child_properties_last
            child: CustomAppBar(
              text: '${widget.cityName} / ${widget.depoName} / Depot Overview',
              haveSynced: _isEdit,
              store: () {
                FirebaseFirestore.instance
                    .collection('OverviewCollection')
                    .doc(widget.depoName)
                    .collection("OverviewFieldData")
                    .doc(userId)
                    .set({
                  'address': _addressController.text,
                  'scope': _scopeController.text,
                  'required': _chargerController.text,
                  'charger': _ratingController.text,
                  'load': _loadController.text,
                  'powerSource': _powersourceController.text,
                  // 'ManagerName': managername ?? '',
                  'CivilManagerName': _civilManagerNameController.text,
                  'CivilEng': _civilEngineerController.text,
                  'CivilVendor': _civilVendorController.text,
                  'ElectricalManagerName': _elctricalManagerNameController.text,
                  'ElectricalEng': _electricalEngineerController.text,
                  'ElectricalVendor': _electricalVendorController.text,
                });
                FirebaseApi().defaultKeyEventsField(
                    'OverviewCollectionTable', widget.depoName!);
                FirebaseApi().nestedKeyEventsField('OverviewCollectionTable',
                    widget.depoName!, 'OverviewTabledData', userId);
                storeData();
              },
            ),
            preferredSize: const Size.fromHeight(50)),
        body:
            // Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Image.asset('assets/Depot.jpeg', alignment: Alignment.center),
            //       Text(
            //         'To BE Accessed By Admin and Project M anager',
            //         style: TextStyle(color: black, fontSize: 25),
            //       )
            //     ],
            //   ),
            // )

            _isloading
                ? LoadingPage()
                : Column(
                    children: [
                      // Container(
                      //   height: 40,
                      //   width: MediaQuery.of(context).size.width,
                      //   decoration: const BoxDecoration(color: Colors.blue),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Container(
                      //         padding: const EdgeInsets.all(5.0),
                      //         child: Text(
                      //             'Current Progress of Depot Infrastructure Work ',
                      //             style: TextStyle(color: white, fontSize: 18)),
                      //       ),
                      //       Container(
                      //         padding: const EdgeInsets.all(10),
                      //         child: Text(
                      //           '50 %',
                      //           style: TextStyle(color: white, fontSize: 18),
                      //           textAlign: TextAlign.center,
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),

                      Expanded(
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                width: 500,
                                child: Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: blue),
                                        child: Text(
                                          'Brief Overview of ${widget.depoName} E-Bus Depot',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: white),
                                        )),
                                    const SizedBox(height: 25),
                                    cards(),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'E-Bus Depot Name : ${widget.depoName}',
                                      style: formtext,
                                    ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     Text(
                                    //       'Project Manager: ',
                                    //       style: formtext,
                                    //     ),
                                    //     Container(
                                    //       // width: 250,
                                    //       height: 35,
                                    //       child: StreamBuilder(
                                    //         stream: _stream1,
                                    //         builder: (context, snapshot) {
                                    //           // if (snapshot.connectionState ==
                                    //           //     ConnectionState.waiting) {
                                    //           //   return Text('');
                                    //           // }
                                    //           if (snapshot.hasData) {
                                    //             managername = snapshot.data!
                                    //                     .data()
                                    //                     .toString()
                                    //                     .contains('ManagerName')
                                    //                 ? snapshot.data!
                                    //                         .get('ManagerName') ??
                                    //                     ''
                                    //                 : 'Enter Address';
                                    //             return Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(top: 8),
                                    //               child: Text(
                                    //                 managername,
                                    //                 style: formtext,
                                    //               ),
                                    //             );
                                    //           } else {
                                    //             return const Text('data');
                                    //           }
                                    //         },
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: blue),
                                        child: Text('Risk Register',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: white)),
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 12)),
                                    Expanded(
                                        child: StreamBuilder(
                                      stream: _stream,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData ||
                                            snapshot.data.exists == false) {
                                          return SfDataGrid(
                                            source: _employeeDataSource,
                                            allowEditing: true,
                                            frozenColumnsCount: 2,
                                            gridLinesVisibility:
                                                GridLinesVisibility.both,
                                            headerGridLinesVisibility:
                                                GridLinesVisibility.both,
                                            // checkboxColumnSettings:
                                            //     DataGridCheckboxColumnSettings(
                                            //         showCheckboxOnHeader: false),

                                            // showCheckboxColumn: true,
                                            selectionMode:
                                                SelectionMode.multiple,
                                            navigationMode:
                                                GridNavigationMode.cell,
                                            columnWidthMode:
                                                ColumnWidthMode.auto,
                                            editingGestureType:
                                                EditingGestureType.tap,
                                            controller: _dataGridController,

                                            // onQueryRowHeight: (details) {
                                            //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                            // },
                                            columns: [
                                              GridColumn(
                                                visible: false,
                                                columnName: 'srNo',
                                                autoFitPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                allowEditing: true,
                                                label: Container(
                                                  alignment: Alignment.center,
                                                  child: Text('Sr No',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: tableheader
                                                      //    textAlign: TextAlign.center,
                                                      ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Date',
                                                width: 160,
                                                allowEditing: false,
                                                label: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Risk On Date',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    style: tableheader,
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'RiskDescription',
                                                width: 180,
                                                allowEditing: true,
                                                label: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Risk Description',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'TypeRisk',
                                                width: 180,
                                                allowEditing: false,
                                                label: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Type',
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'impactRisk',
                                                width: 150,
                                                allowEditing: false,
                                                label: Container(
                                                  alignment: Alignment.center,
                                                  child: Text('Impact Risk',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Owner',
                                                allowEditing: true,
                                                width: 150,
                                                label: Column(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('Owner',
                                                          overflow: TextOverflow
                                                              .values.first,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16)),
                                                    ),
                                                    Text(
                                                        'Person Who will manage the risk',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12))
                                                  ],
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'MigratingRisk',
                                                allowEditing: true,
                                                columnWidthMode: ColumnWidthMode
                                                    .fitByCellValue,
                                                width: 150,
                                                label: Column(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          'Mitigation Action',
                                                          overflow: TextOverflow
                                                              .values.first,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16)),
                                                    ),
                                                    Text(
                                                        'Action to Mitigate the risk e.g reduce the likelihood',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12))
                                                  ],
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'ContigentAction',
                                                allowEditing: true,
                                                width: 180,
                                                label: Column(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16.0),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          'Contigent Action',
                                                          overflow: TextOverflow
                                                              .values.first,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16)),
                                                    ),
                                                    Text(
                                                        'Action to be taken if the risk happens',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12))
                                                  ],
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'ProgressionAction',
                                                allowEditing: true,
                                                width: 180,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Progression Action',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Reason',
                                                allowEditing: true,
                                                width: 150,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Remark',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'TargetDate',
                                                allowEditing: false,
                                                width: 160,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Target Completion Date Of Risk',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Status',
                                                allowEditing: false,
                                                width: 150,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Status',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Add',
                                                autoFitPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                allowEditing: false,
                                                width: 120,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Add Row',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      )
                                                      //    textAlign: TextAlign.center,
                                                      ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Delete',
                                                autoFitPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                allowEditing: false,
                                                width: 120,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Delete Row',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      )
                                                      //    textAlign: TextAlign.center,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          alldata = snapshot.data['data']
                                              as List<dynamic>;
                                          _employees.clear();
                                          alldata.forEach((element) {
                                            _employees.add(
                                                DepotOverviewModel.fromJson(
                                                    element));
                                            _employeeDataSource =
                                                DepotOverviewDatasource(
                                                    _employees, context);
                                            _dataGridController =
                                                DataGridController();
                                          });
                                          return SfDataGrid(
                                            source: _employeeDataSource,
                                            allowEditing: true,
                                            frozenColumnsCount: 2,
                                            gridLinesVisibility:
                                                GridLinesVisibility.both,
                                            headerGridLinesVisibility:
                                                GridLinesVisibility.both,
                                            // checkboxColumnSettings:
                                            //     DataGridCheckboxColumnSettings(
                                            //         showCheckboxOnHeader: false),

                                            // showCheckboxColumn: true,
                                            selectionMode:
                                                SelectionMode.multiple,
                                            navigationMode:
                                                GridNavigationMode.cell,
                                            columnWidthMode:
                                                ColumnWidthMode.auto,
                                            editingGestureType:
                                                EditingGestureType.tap,
                                            controller: _dataGridController,

                                            // onQueryRowHeight: (details) {
                                            //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                            // },
                                            columns: [
                                              GridColumn(
                                                visible: false,
                                                columnName: 'srNo',
                                                autoFitPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                allowEditing: true,
                                                label: Container(
                                                  alignment: Alignment.center,
                                                  child: Text('Sr No',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: tableheader
                                                      //    textAlign: TextAlign.center,
                                                      ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Date',
                                                width: 160,
                                                allowEditing: false,
                                                label: Container(
                                                  alignment: Alignment.center,
                                                  child: Text('Risk On Date',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'RiskDescription',
                                                width: 180,
                                                allowEditing: true,
                                                label: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Risk Description',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'TypeRisk',
                                                width: 180,
                                                allowEditing: false,
                                                label: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Type',
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'impactRisk',
                                                width: 150,
                                                allowEditing: false,
                                                label: Container(
                                                  alignment: Alignment.center,
                                                  child: Text('Impact Risk',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Owner',
                                                allowEditing: true,
                                                width: 150,
                                                label: Column(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('Owner',
                                                          overflow: TextOverflow
                                                              .values.first,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16)),
                                                    ),
                                                    Text(
                                                        'Person Who will manage the risk',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12))
                                                  ],
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'MigratingRisk',
                                                allowEditing: true,
                                                columnWidthMode: ColumnWidthMode
                                                    .fitByCellValue,
                                                width: 150,
                                                label: Column(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          'Mitigation Action',
                                                          overflow: TextOverflow
                                                              .values.first,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16)),
                                                    ),
                                                    Text(
                                                        'Action to Mitigate the risk e.g reduce the likelihood',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12))
                                                  ],
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'ContigentAction',
                                                allowEditing: true,
                                                width: 180,
                                                label: Column(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16.0),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          'Contigent Action',
                                                          overflow: TextOverflow
                                                              .values.first,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16)),
                                                    ),
                                                    Text(
                                                        'Action to be taken if the risk happens',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12))
                                                  ],
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'ProgressionAction',
                                                allowEditing: true,
                                                width: 180,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Progression Action',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Reason',
                                                allowEditing: true,
                                                width: 150,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Remark',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'TargetDate',
                                                allowEditing: false,
                                                width: 160,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Target Completion Date Of Risk',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Status',
                                                allowEditing: false,
                                                width: 150,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Status',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: tableheader),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Add',
                                                autoFitPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                allowEditing: false,
                                                width: 120,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Add Row',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: tableheader
                                                      //    textAlign: TextAlign.center,
                                                      ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Delete',
                                                autoFitPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                allowEditing: false,
                                                width: 120,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Delete Row',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: tableheader
                                                      //    textAlign: TextAlign.center,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
        // floatingActionButton: FloatingActionButton(
        //     child: Icon(Icons.add),
        //     onPressed: (() {
        //       _employees.add(
        //         DepotOverviewModel(
        //           srNo: 1,
        //           date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        //           riskDescription: 'dedd',
        //           typeRisk: 'Material Supply',
        //           impactRisk: 'High',
        //           owner: 'Pratyush',
        //           migrateAction: ' lkmlm',
        //           contigentAction: 'mlkmlk',
        //           progressAction: 'pending',
        //           reason: '',
        //           targetDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        //           status: 'Close',
        //         ),
        //       );
        //       _employeeDataSource.buildDataGridRows();
        //       _employeeDataSource.updateDatagridSource();
        //     })),
      ),
    );
  }

  cards() {
    return Expanded(
      child: Container(
        width: 550,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('OverviewCollection')
              .doc(widget.depoName)
              .collection("OverviewFieldData")
              .doc(userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 280,
                          child: Text('Depots location and Address ',
                              textAlign: TextAlign.start, style: formtext),
                        ),
                        Container(
                          width: 200,
                          child: CustomTextField(
                            controller: _addressController,
                          ),
                        ),
                        // Container(
                        //     width: 200,
                        //     height: 35,
                        //     child: TextFormField(
                        //         decoration: InputDecoration(
                        //           enabled: _isEdit,
                        //         ),
                        //         initialValue: snapshot.data!
                        //                 .data()
                        //                 .toString()
                        //                 .contains('address')
                        //             ? snapshot.data!.get('address') ?? ''
                        //             : 'Enter Address',
                        //         maxLines: 1,
                        //         textInputAction: TextInputAction.done,
                        //         minLines: 1,
                        //         autofocus: false,
                        //         textAlign: TextAlign.center,
                        //         style: const TextStyle(fontSize: 13),
                        //         onChanged: (value) {
                        //           address = value;
                        //         },
                        //         onSaved: (value) {
                        //           address = value;
                        //         })),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: Text('No of Buses in Scope',
                              textAlign: TextAlign.start, style: formtext),
                        ),
                        Container(
                          width: 200,
                          child: CustomTextField(
                            controller: _scopeController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: Text('No. of Charger Required ',
                              textAlign: TextAlign.start, style: formtext),
                        ),
                        Container(
                          width: 200,
                          child: CustomTextField(
                            controller: _chargerController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: Text('Rating Of charger ',
                              textAlign: TextAlign.start, style: formtext),
                        ),
                        Container(
                          width: 200,
                          child: CustomTextField(
                            controller: _ratingController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: Text('Required Sanctioned load ',
                              textAlign: TextAlign.start, style: formtext),
                        ),
                        Container(
                          width: 200,
                          child: CustomTextField(
                            controller: _loadController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 280,
                          child: Text('Existing Utility for power source ',
                              textAlign: TextAlign.start, style: formtext),
                        ),
                        Container(
                          width: 200,
                          child: CustomTextField(
                            controller: _powersourceController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: blue),
                          child: Text('Electrical',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 280,
                          child: Text(
                            'Project Manager ',
                            textAlign: TextAlign.start,
                            style: formtext,
                          ),
                        ),
                        Container(
                          width: 200,
                          child: CustomTextField(
                            controller: _elctricalManagerNameController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 280,
                          child: Text('Electrical Engineer ',
                              textAlign: TextAlign.start, style: formtext),
                        ),
                        Container(
                          width: 200,
                          child: CustomTextField(
                            controller: _electricalEngineerController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 280,
                          child: Text('Electrical Vendor',
                              textAlign: TextAlign.start, style: formtext),
                        ),
                        Container(
                          width: 200,
                          child: CustomTextField(
                            controller: _electricalVendorController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: blue),
                          child: Text('Civil',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 280,
                          child: Text('Project Manager ',
                              textAlign: TextAlign.start, style: formtext),
                        ),
                        Container(
                          width: 200,
                          child: CustomTextField(
                            controller: _civilManagerNameController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 280,
                          child: Text('Civil Engineer ',
                              textAlign: TextAlign.start, style: formtext),
                        ),
                        Container(
                          width: 200,
                          child: CustomTextField(
                            controller: _civilEngineerController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 280,
                          child: Text('Civil Vendor',
                              textAlign: TextAlign.start, style: formtext),
                        ),
                        Container(
                          width: 200,
                          child: CustomTextField(
                            controller: _civilVendorController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 30),
                          width: 280,
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'BOQ Electrical',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: black),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.any,
                                      withData: true,
                                      //     allowedExtensions: [
                                      //   'pdf',
                                      //   'jpg',
                                      //   'jpeg',
                                      //   'svg'
                                      // ]
                                    );
                                    fileBytes = result!.files.first.bytes;
                                    if (result == null) {
                                      print("No file selected");
                                    } else {
                                      setState(() {});
                                      result?.files.forEach((element) {
                                        print(element.name);
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Pick file',
                                    textAlign: TextAlign.end,
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(5),
                                width: 150,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: lightblue,
                                    border: Border.all(color: grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    if (result != null)
                                      Text(
                                        result!.files.first.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15, color: white),
                                      ),
                                  ],
                                )),
                            IconButton(
                                alignment: Alignment.bottomRight,
                                padding: const EdgeInsets.only(bottom: 5),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ViewAllPdf(
                                          title: '/BOQElectrical',
                                          cityName: widget.cityName!,
                                          depoName: widget.depoName!,
                                          userId: userId,
                                          docId: 'electrical')));
                                },
                                icon: Icon(Icons.folder, color: yellow))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 30),
                          width: 280,
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'BOQ Civil',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: black),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    result1 =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      withData: true,
                                      // allowedExtensions: ['pdf']
                                    );
                                    fileBytes1 = result1!.files.first.bytes;
                                    if (result == null) {
                                      print("No file selected");
                                    } else {
                                      setState(() {});
                                      result?.files.forEach((element) {
                                        print(element.name);
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Pick file',
                                    textAlign: TextAlign.end,
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(5),
                                width: 150,
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(color: grey),
                                    borderRadius: BorderRadius.circular(5),
                                    color: lightblue),
                                child: Row(
                                  children: [
                                    if (result1 != null)
                                      Text(
                                        result1!.files.first.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15, color: white),
                                      ),
                                  ],
                                )),
                            IconButton(
                                alignment: Alignment.bottomRight,
                                padding: EdgeInsets.only(bottom: 5),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ViewAllPdf(
                                          title: '/BOQCivil',
                                          cityName: widget.cityName!,
                                          depoName: widget.depoName!,
                                          userId: userId,
                                          docId: 'civil')));
                                },
                                icon: Icon(
                                  Icons.folder,
                                  color: yellow,
                                ))
                          ],
                        ),

                        // Container(
                        //     width: 200,
                        //     height: 80,
                        //     child: Column(
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             if (result1 != null)
                        //               const Padding(
                        //                 padding: const EdgeInsets.only(top: 10),
                        //               ),
                        //             ElevatedButton(
                        //                 onPressed: () async {
                        //                   result1 = await FilePicker.platform
                        //                       .pickFiles(withData: true);
                        //                   if (result1 == null) {
                        //                     print("No file selected");
                        //                   } else {
                        //                     setState(() {});
                        //                     result1?.files.forEach((element) {
                        //                       print(element.name);
                        //                     });
                        //                   }
                        //                 },
                        //                 child: const Text('Pick file')),
                        //             ElevatedButton(
                        //                 onPressed: () async {
                        //                   result1 = await FilePicker.platform
                        //                       .pickFiles(withData: true);
                        //                   if (result1 == null) {
                        //                     print("No file selected");
                        //                   } else {
                        //                     setState(() {});
                        //                     result1?.files.forEach((element) {
                        //                       print(element.name);
                        //                     });
                        //                   }
                        //                 },
                        //                 child: const Text('Pick file')),
                        //           ],
                        //         ),
                        //         Container(
                        //             child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             if (result1 != null)
                        //               Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Container(
                        //                   decoration: BoxDecoration(
                        //                       borderRadius:
                        //                           BorderRadius.circular(10)),
                        //                   width: 150,
                        //                   child: Text(
                        //                     result1!.files.first.name,
                        //                     overflow: TextOverflow.ellipsis,
                        //                     style: const TextStyle(
                        //                         fontSize: 14,
                        //                         fontWeight: FontWeight.bold),
                        //                   ),
                        //                 ),
                        //               ),
                        //           ],
                        //         )),
                        //       ],
                        //     )),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 30),
                          width: 280,
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Details of Survey Report',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: black),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    result2 =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      withData: true,
                                      // allowedExtensions: ['pdf']
                                    );
                                    fileBytes2 = result!.files.first.bytes;
                                    if (result2 == null) {
                                      print("No file selected");
                                    } else {
                                      setState(() {});
                                      result2?.files.forEach((element) {
                                        print(element.name);
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Pick file',
                                    textAlign: TextAlign.end,
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(5),
                                width: 150,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: lightblue,
                                    border: Border.all(color: grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    if (result2 != null)
                                      Text(
                                        result2!.files.first.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15, color: white),
                                      ),
                                  ],
                                )),
                            IconButton(
                                alignment: Alignment.bottomRight,
                                padding: const EdgeInsets.only(bottom: 5),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ViewAllPdf(
                                          title: '/BOQSurvey',
                                          cityName: widget.cityName!,
                                          depoName: widget.depoName!,
                                          userId: userId,
                                          docId: 'survey')));
                                },
                                icon: Icon(Icons.folder, color: yellow))
                          ],
                        ),
                        // TextFormField(
                        //     initialValue: snapshot.data!
                        //             .data()
                        //             .toString()
                        //             .contains('powerSource')
                        //         ? snapshot.data!.get('powerSource') ??
                        //             'Enter  PowerSource '
                        //         : 'Enter  PowerSource ',
                        //     textInputAction: TextInputAction.done,
                        //     minLines: 1,
                        //     autofocus: false,
                        //     textAlign: TextAlign.center,
                        //     style: TextStyle(fontSize: 15),
                        //     onChanged: (value) {
                        //       powerSource = value;
                        //     }),

                        // Container(
                        //     width: 200,
                        //     height: 100,
                        //     child: Column(
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             if (result != null)
                        //               const Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //               ),
                        //             ElevatedButton(
                        //                 onPressed: () async {
                        //                   result = await FilePicker.platform
                        //                       .pickFiles(
                        //                           type: FileType.custom,
                        //                           withData: true,
                        //                           allowedExtensions: ['pdf']);
                        //                   if (result == null) {
                        //                     print("No file selected");
                        //                   } else {
                        //                     setState(() {});
                        //                     result?.files.forEach((element) {
                        //                       print(element.name);
                        //                     });
                        //                   }
                        //                 },
                        //                 child: const Text(
                        //                   'Pick file',
                        //                   textAlign: TextAlign.end,
                        //                 )),
                        //             ElevatedButton(
                        //                 onPressed: () async {
                        //                   result = await FilePicker.platform
                        //                       .pickFiles(withData: true);
                        //                   if (result == null) {
                        //                     print("No file selected");
                        //                   } else {
                        //                     setState(() {});
                        //                     result?.files.forEach((element) {
                        //                       print(element.name);
                        //                     });
                        //                   }
                        //                 },
                        //                 child: Row(
                        //                   children: [
                        //                     if (result != null)
                        //                       Container(
                        //                         width: 65,
                        //                         child: Text(
                        //                           result!.files.first.name,
                        //                           overflow:
                        //                               TextOverflow.ellipsis,
                        //                           textAlign: TextAlign.end,
                        //                         ),
                        //                       )
                        //                   ],
                        //                 )),
                        //           ],
                        //         ),
                        //         Container(
                        //             width: 200,
                        //             height: 70,
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 if (result != null)
                        //                   Padding(
                        //                     padding: const EdgeInsets.all(8.0),
                        //                     child: Container(
                        //                       width: 170,
                        //                       child: Text(
                        //                         result!.files.first.name,
                        //                         overflow: TextOverflow.ellipsis,
                        //                         style: const TextStyle(
                        //                             fontSize: 16,
                        //                             fontWeight:
                        //                                 FontWeight.bold),
                        //                       ),
                        //                     ),
                        //                   ),
                        //               ],
                        //             )),
                        //       ],
                        //     )),
                      ],
                    ),

                    // Center(
                    //     child: SfCircularChart(
                    //   legend: Legend(
                    //       isVisible: true, position: LegendPosition.right),
                    //   series: [
                    //     PieSeries<PieChartData, String>(
                    //         dataLabelSettings:
                    //             const DataLabelSettings(isVisible: true),
                    //         dataSource: chartData,
                    //         pointColorMapper: (PieChartData data, _) =>
                    //             data.color,
                    //         xValueMapper: (PieChartData data, _) => data.x,
                    //         yValueMapper: (PieChartData data, _) => data.y)
                    //   ],
                    // ))
                  ],
                ),
              );
            }
            return LoadingPage();
          },
        ),
      ),
    );
  }

  // overviewDetails(String title, String subtitle) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Container(
  //         width: 250,
  //         child: Text(
  //           subtitle,
  //           textAlign: TextAlign.start,
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //       Container(
  //           width: 200,
  //           height: 35,
  //           child: TextFormField(
  //               initialValue: subtitle,
  //               textInputAction: TextInputAction.done,
  //               minLines: 1,
  //               autofocus: false,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(color: black, fontSize: 16),
  //               onChanged: (value) {
  //                 address = value;
  //               },
  //               onSaved: (value) {
  //                 address = value;
  //               })),
  //     ],
  //   );
  // }

  void storeData() {
    Map<String, dynamic> table_data = Map();
    for (var i in _employeeDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'Add' || data.columnName != 'Delete') {
          table_data[data.columnName] = data.value;
        }
      }
      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('OverviewCollectionTable')
        .doc(widget.depoName)
        .collection("OverviewTabledData")
        .doc(userId)
        .set({
      'data': tabledata2,
    }).whenComplete(() async {
      tabledata2.clear();
      if (fileBytes != null || fileBytes1 != null || fileBytes2 != null) {
        await FirebaseStorage.instance
            .ref(
                'BOQElectrical/${widget.cityName}/${widget.depoName}/$userId/electrical/${result!.files.first.name}')
            .putData(
              fileBytes!,
            );
        await FirebaseStorage.instance
            .ref(
                'BOQCivil/${widget.cityName}/${widget.depoName}/$userId/civil/${result1!.files.first.name}')
            .putData(
              fileBytes1!,
              //  SettableMetadata(contentType: 'application/pdf')
            );

        await FirebaseStorage.instance
            .ref(
                'BOQSurvey/${widget.cityName}/${widget.depoName}/$userId/survey/${result1!.files.first.name}')
            .putData(
              fileBytes2!,
              //  SettableMetadata(contentType: 'application/pdf')
            );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Data are synced'),
      backgroundColor: blue,
    ));
  }

  void _fetchUserData() async {
    await FirebaseFirestore.instance
        .collection('OverviewCollection')
        .doc(widget.depoName)
        .collection("OverviewFieldData")
        .doc(userId)
        .get()
        .then((ds) {
      setState(() {
        // managername = ds.data()!['ManagerName'];
        _addressController.text = ds.data()!['address'];
        _scopeController.text = ds.data()!['scope'];
        _chargerController.text = ds.data()!['required'];
        _ratingController.text = ds.data()!['charger'];
        _loadController.text = ds.data()!['load'];
        _powersourceController.text = ds.data()!['powerSource'];
        _elctricalManagerNameController.text =
            ds.data()!['ElectricalManagerName'];
        _electricalEngineerController.text = ds.data()!['ElectricalEng'];
        _electricalVendorController.text = ds.data()!['ElectricalVendor'];
        _civilManagerNameController.text = ds.data()!['CivilManagerName'];
        _civilEngineerController.text = ds.data()!['CivilEng'];
        _civilVendorController.text = ds.data()!['CivilVendor'];
      });
    });
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }
}

List<DepotOverviewModel> getEmployeeData() {
  return [
    DepotOverviewModel(
        srNo: 1,
        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        riskDescription: '',
        typeRisk: 'Material Supply',
        impactRisk: 'High',
        owner: '',
        migrateAction: ' ',
        contigentAction: '',
        progressAction: '',
        reason: '',
        targetDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        status: 'Close')
  ];
}
