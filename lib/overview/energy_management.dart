import 'package:assingment/Planning_Pages/quality_checklist.dart';
import 'package:assingment/datasource/energymanagement_datasource.dart';
import 'package:assingment/model/energy_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../FirebaseApi/firebase_api.dart';
import '../components/Loading_page.dart';
import '../widget/custom_appbar.dart';
import '../widget/style.dart';

class EnergyManagement extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? userId;
  EnergyManagement(
      {super.key,
      required this.cityName,
      required this.depoName,
      required this.userId});

  @override
  State<EnergyManagement> createState() => _EnergyManagementState();
}

class _EnergyManagementState extends State<EnergyManagement> {
  late EnergyManagementDatasource _energyManagementdatasource;
  late DataGridController _dataGridController;
  final List<EnergyManagementModel> _energyManagement =
      <EnergyManagementModel>[];
  Stream? _stream;
  bool _isloading = true;
  List<dynamic> tabledata2 = [];
  int currentMonth = DateTime.now().month;
  @override
  void initState() {
    String monthName =
        DateFormat('MMMM').format(DateTime(2000, currentMonth, 1));
    _stream = FirebaseFirestore.instance
        .collection('EnergyManagementTable')
        .doc(widget.depoName)
        .collection('Year')
        .doc(DateTime.now().year.toString())
        .collection('Months')
        .doc(monthName)
        .collection('Date')
        .doc(DateFormat.yMMMMd().format(DateTime.now()))
        .collection('UserId')
        .doc(widget.userId)
        .snapshots();
    _energyManagementdatasource = EnergyManagementDatasource(_energyManagement,
        context, widget.userId!, widget.cityName, widget.depoName);
    _dataGridController = DataGridController();
    _isloading = false;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          // ignore: sort_child_properties_last
          child: CustomAppBar(
            showDepoBar: true,
            toOverview: true,
            cityname: widget.cityName,
            text:
                '${widget.cityName}/${widget.depoName}/Depot Energy Management',
            haveSynced: true,
            store: () {
              //   FirebaseFirestore.instance
              //       .collection('OverviewCollection')
              //       .doc(widget.depoName)
              //       .collection("OverviewFieldData")
              //       .doc(userId)
              //       .set({
              //     'address': _addressController.text,
              //     'scope': _scopeController.text,
              //     'required': _chargerController.text,
              //     'charger': _ratingController.text,
              //     'load': _loadController.text,
              //     'powerSource': _powersourceController.text,
              //     // 'ManagerName': managername ?? '',
              //     'CivilManagerName': _civilManagerNameController.text,
              //     'CivilEng': _civilEngineerController.text,
              //     'CivilVendor': _civilVendorController.text,
              //     'ElectricalManagerName': _elctricalManagerNameController.text,
              //     'ElectricalEng': _electricalEngineerController.text,
              //     'ElectricalVendor': _electricalVendorController.text,
              //   }, SetOptions(merge: true));
              // FirebaseApi().defaultKeyEventsField(
              //     'OverviewCollectionTable', widget.depoName!);
              FirebaseApi().energydefaultKeyEventsField('EnergyManagementTable',
                  widget.depoName!, 'Year', DateTime.now().year.toString());
              FirebaseApi().energynestedKeyEventsField(
                  'EnergyManagementTable',
                  widget.depoName!,
                  'Year',
                  DateTime.now().year.toString(),
                  'Months',
                  DateFormat('MMMM').format(DateTime(2000, currentMonth, 1)));
              storeData();
            },
          ),
          preferredSize: const Size.fromHeight(50)),
      body: _isloading
          ? LoadingPage()
          : SfDataGridTheme(
              data: SfDataGridThemeData(headerColor: lightblue),
              child: StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.exists == false) {
                    _energyManagementdatasource = EnergyManagementDatasource(
                        _energyManagement,
                        context,
                        widget.userId!,
                        widget.cityName,
                        widget.depoName);
                    _dataGridController = DataGridController();
                    return SfDataGrid(
                      source: _energyManagementdatasource,
                      allowEditing: true,
                      frozenColumnsCount: 2,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      // checkboxColumnSettings:
                      //     DataGridCheckboxColumnSettings(
                      //         showCheckboxOnHeader: false),

                      // showCheckboxColumn: true,
                      selectionMode: SelectionMode.multiple,
                      navigationMode: GridNavigationMode.cell,
                      columnWidthMode: ColumnWidthMode.auto,
                      editingGestureType: EditingGestureType.tap,
                      controller: _dataGridController,

                      // onQueryRowHeight: (details) {
                      //   return details.rowIndex == 0 ? 60.0 : 49.0;
                      // },
                      columns: [
                        GridColumn(
                          visible: true,
                          columnName: 'srNo',
                          allowEditing: false,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('Sr No',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor
                                //    textAlign: TextAlign.center,
                                ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'DepotName',
                          width: 180,
                          allowEditing: false,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('Depot Name',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'VehicleNo',
                          width: 180,
                          allowEditing: true,
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Veghicle No',
                                textAlign: TextAlign.center,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'pssNo',
                          width: 80,
                          allowEditing: true,
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('PSS No', style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'chargerId',
                          width: 80,
                          allowEditing: true,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('Charger ID',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'startSoc',
                          allowEditing: true,
                          width: 80,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('Start SOC',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'endSoc',
                          allowEditing: true,
                          columnWidthMode: ColumnWidthMode.fitByCellValue,
                          width: 80,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('End SOC',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'startDate',
                          allowEditing: false,
                          width: 150,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('Start Date & Time',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'endDate',
                          allowEditing: false,
                          width: 150,
                          label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text('End Date & Time',
                                  overflow: TextOverflow.values.first,
                                  style: tableheaderwhitecolor),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'totalTime',
                          allowEditing: false,
                          width: 180,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('Total time of Charging',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'enrgyConsumed',
                          allowEditing: true,
                          width: 160,
                          label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Text('Engery Consumed (inkW)',
                                overflow: TextOverflow.values.first,
                                textAlign: TextAlign.center,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'timeInterval',
                          allowEditing: true,
                          width: 150,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('Interval',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                      ],
                    );
                  } else {
                    alldata = snapshot.data!['data'] as List<dynamic>;
                    _energyManagement.clear();
                    _energyManagementdatasource.buildDataGridRows();
                    _energyManagementdatasource.updateDatagridSource();
                    alldata.forEach((element) {
                      _energyManagement
                          .add(EnergyManagementModel.fromJson(element));
                      _energyManagementdatasource = EnergyManagementDatasource(
                          _energyManagement,
                          context,
                          widget.userId!,
                          widget.cityName,
                          widget.depoName);
                      _dataGridController = DataGridController();
                      _energyManagementdatasource.buildDataGridRows();
                      _energyManagementdatasource.updateDatagridSource();
                    });
                    return SfDataGrid(
                      source: _energyManagementdatasource,
                      allowEditing: true,
                      frozenColumnsCount: 2,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      // checkboxColumnSettings:
                      //     DataGridCheckboxColumnSettings(
                      //         showCheckboxOnHeader: false),

                      // showCheckboxColumn: true,
                      selectionMode: SelectionMode.multiple,
                      navigationMode: GridNavigationMode.cell,
                      columnWidthMode: ColumnWidthMode.auto,
                      editingGestureType: EditingGestureType.tap,
                      controller: _dataGridController,

                      // onQueryRowHeight: (details) {
                      //   return details.rowIndex == 0 ? 60.0 : 49.0;
                      // },
                      columns: [
                        GridColumn(
                          visible: true,
                          columnName: 'srNo',
                          allowEditing: false,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('Sr No',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor
                                //    textAlign: TextAlign.center,
                                ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'DepotName',
                          width: 180,
                          allowEditing: false,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('Depot Name',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'VehicleNo',
                          width: 180,
                          allowEditing: true,
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Veghicle No',
                                textAlign: TextAlign.center,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'pssNo',
                          width: 80,
                          allowEditing: true,
                          label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('PSS No', style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'chargerId',
                          width: 80,
                          allowEditing: true,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('Charger ID',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'startSoc',
                          allowEditing: true,
                          width: 80,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('Start SOC',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'endSoc',
                          allowEditing: true,
                          columnWidthMode: ColumnWidthMode.fitByCellValue,
                          width: 80,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('End SOC',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'startDate',
                          allowEditing: false,
                          width: 150,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('Start Date & Time',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'endDate',
                          allowEditing: false,
                          width: 150,
                          label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text('End Date & Time',
                                  overflow: TextOverflow.values.first,
                                  style: tableheaderwhitecolor),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'totalTime',
                          allowEditing: false,
                          width: 180,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('Total time of Charging',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'enrgyConsumed',
                          allowEditing: true,
                          width: 160,
                          label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Text('Engery Consumed (inkW)',
                                overflow: TextOverflow.values.first,
                                textAlign: TextAlign.center,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                        GridColumn(
                          columnName: 'timeInterval',
                          allowEditing: true,
                          width: 150,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text('Interval',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (() {
            _energyManagement.add(EnergyManagementModel(
                srNo: _energyManagement.length + 1,
                depotName: widget.depoName.toString(),
                vehicleNo: 'vehicleNo',
                pssNo: 1,
                chargerId: 1,
                startSoc: 1,
                endSoc: 1,
                startDate: DateFormat('hh:mm').format(DateTime.now()),
                endDate: DateFormat('hh:mm').format(DateTime.now()),
                totalTime: DateFormat('hh:mm').format(DateTime.now()),
                enrgyConsumed: 1500.00,
                timeInterval: '4:00-10:00'));
            _energyManagementdatasource.buildDataGridRows();
            _energyManagementdatasource.updateDatagridSource();
          })),
    );
  }

  void storeData() {
    Map<String, dynamic> tableData = Map();
    String monthName =
        DateFormat('MMMM').format(DateTime(2000, currentMonth, 1));
    for (var i in _energyManagementdatasource.dataGridRows) {
      for (var data in i.getCells()) {
        tableData[data.columnName] = data.value;
      }
      tabledata2.add(tableData);
      tableData = {};
    }

    FirebaseFirestore.instance
        .collection('EnergyManagementTable')
        .doc(widget.depoName)
        .collection('Year')
        .doc(DateTime.now().year.toString())
        .collection('Months')
        .doc(monthName)
        .collection('Date')
        .doc(DateFormat.yMMMMd().format(DateTime.now()))
        .collection('UserId')
        .doc(widget.userId)
        .set({
      'data': tabledata2,
    }).whenComplete(() async {
      tabledata2.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }
}
