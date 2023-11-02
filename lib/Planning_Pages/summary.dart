import 'dart:convert';
import 'package:assingment/Planning_Pages/quality_checklist.dart';
import 'package:assingment/overview/daily_project.dart';
import 'package:assingment/widget/custom_appbar.dart';
import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../Authentication/auth_service.dart';
import '../components/loading_page.dart';
import '../datasource/dailyproject_datasource.dart';
import '../datasource/monthlyproject_datasource.dart';
import '../datasource/safetychecklist_datasource.dart';
import '../model/daily_projectModel.dart';
import '../model/monthly_projectModel.dart';
import '../model/safety_checklistModel.dart';
import '../provider/summary_provider.dart';
import '../widget/nodata_available.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:html' as html;

class ViewSummary extends StatefulWidget {
  String? depoName;
  String? cityName;
  String? id;
  String? selectedtab;
  bool isHeader;
  String? currentDate;
  dynamic userId;
  ViewSummary(
      {super.key,
      required this.depoName,
      required this.cityName,
      required this.id,
      this.userId,
      this.selectedtab,
      this.currentDate,
      this.isHeader = false});

  @override
  State<ViewSummary> createState() => _ViewSummaryState();
}

class _ViewSummaryState extends State<ViewSummary> {
  SummaryProvider? _summaryProvider;
  Future<List<DailyProjectModel>>? _dailydata;

  DateTime? startdate = DateTime.now();
  DateTime? enddate = DateTime.now();
  DateTime? rangestartDate;
  DateTime? rangeEndDate;

  List<MonthlyProjectModel> monthlyProject = <MonthlyProjectModel>[];
  List<SafetyChecklistModel> safetylisttable = <SafetyChecklistModel>[];
  late MonthlyDataSource monthlyDataSource;
  late SafetyChecklistDataSource _safetyChecklistDataSource;
  late DataGridController _dataGridController;
  List<DailyProjectModel> dailyproject = <DailyProjectModel>[];
  late DailyDataSource _dailyDataSource;
  List<dynamic> tabledata2 = [];
  Stream? _dailystream;
  var alldata;
  bool _isloading = false;
  dynamic userId;

  @override
  void initState() {
    super.initState();
    _summaryProvider = Provider.of<SummaryProvider>(context, listen: false);

    Stream _stream = FirebaseFirestore.instance
        .collection('MonthlyProjectReport2')
        .doc('${widget.depoName}')
        // .collection('AllMonthData')
        .collection('userId')
        .doc(userId)
        .collection('Monthly Data')
        // .collection('MonthData')
        .doc(DateFormat.yMMM().format(startdate!))
        .snapshots();
    getUserId().then((value) {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _summaryProvider!
        .fetchdailydata(widget.depoName!, widget.userId, startdate!, enddate!);

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
              isDownload: true,
              donwloadFunction: _generatePDF,
              text:
                  ' ${widget.cityName} / ${widget.depoName} / ${widget.id} / View Summary'),
        ),
        // AppBar(
        //   title: Text(
        //       ' ${widget.cityName} / ${widget.depoName} / ${widget.id} / View Summary'),
        //   backgroundColor: blue,
        // ),
        body: _isloading
            ? LoadingPage()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.id == 'Daily Report'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 250,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: blue)),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          'Choose Date'),
                                                      content: SizedBox(
                                                        width: 400,
                                                        height: 500,
                                                        child:
                                                            SfDateRangePicker(
                                                          view:
                                                              DateRangePickerView
                                                                  .year,
                                                          showTodayButton:
                                                              false,
                                                          showActionButtons:
                                                              true,
                                                          selectionMode:
                                                              DateRangePickerSelectionMode
                                                                  .range,
                                                          onSelectionChanged:
                                                              (DateRangePickerSelectionChangedArgs
                                                                  args) {
                                                            if (args.value
                                                                is PickerDateRange) {
                                                              rangestartDate =
                                                                  args.value
                                                                      .startDate;
                                                              rangeEndDate =
                                                                  args.value
                                                                      .endDate;
                                                            }
                                                          },
                                                          onSubmit: (value) {
                                                            dailyproject
                                                                .clear();
                                                            setState(() {
                                                              startdate = DateTime.parse(
                                                                  rangestartDate
                                                                      .toString());
                                                              enddate = DateTime
                                                                  .parse(rangeEndDate
                                                                      .toString());
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          onCancel: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.today)),
                                            Text(widget.id == 'Monthly Report'
                                                ? DateFormat.yMMMM()
                                                    .format(startdate!)
                                                : DateFormat.yMMMMd()
                                                    .format(startdate!))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 250,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: blue)),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              DateFormat.yMMMMd()
                                                  .format(enddate!),
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 250,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: blue)),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('choose Date'),
                                              content: SizedBox(
                                                width: 400,
                                                height: 500,
                                                child: SfDateRangePicker(
                                                  view:
                                                      DateRangePickerView.year,
                                                  showTodayButton: false,
                                                  showActionButtons: true,
                                                  selectionMode:
                                                      DateRangePickerSelectionMode
                                                          .single,
                                                  onSelectionChanged:
                                                      (DateRangePickerSelectionChangedArgs
                                                          args) {
                                                    if (args.value
                                                        is PickerDateRange) {
                                                      rangestartDate =
                                                          args.value.startDate;
                                                    }
                                                  },
                                                  onSubmit: (value) {
                                                    setState(() {
                                                      startdate =
                                                          DateTime.parse(
                                                              value.toString());
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  onCancel: () {},
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.today)),
                                    Text(widget.id == 'Monthly Report'
                                        ? DateFormat.yMMMM().format(startdate!)
                                        : DateFormat.yMMMMd()
                                            .format(startdate!))
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                  widget.id == 'Monthly Report'
                      ? Expanded(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('MonthlyProjectReport2')
                                  .doc('${widget.depoName}')
                                  .collection('userId')
                                  .doc(widget.userId)
                                  .collection('Monthly Data')
                                  .doc(DateFormat.yMMM().format(startdate!))
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return LoadingPage();
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.exists == false) {
                                  return const NodataAvailable();
                                } else {
                                  alldata = '';
                                  alldata =
                                      snapshot.data!['data'] as List<dynamic>;
                                  monthlyProject.clear();
                                  alldata.forEach((element) {
                                    monthlyProject.add(
                                        MonthlyProjectModel.fromjson(element));
                                    monthlyDataSource = MonthlyDataSource(
                                        monthlyProject, context);
                                    _dataGridController = DataGridController();
                                  });
                                  return Column(
                                    children: [
                                      Expanded(
                                          child: SfDataGridTheme(
                                        data: SfDataGridThemeData(
                                            headerColor: lightblue),
                                        child: SfDataGrid(
                                            source: monthlyDataSource,
                                            allowEditing: true,
                                            frozenColumnsCount: 2,
                                            gridLinesVisibility:
                                                GridLinesVisibility.both,
                                            headerGridLinesVisibility:
                                                GridLinesVisibility.both,
                                            selectionMode: SelectionMode.single,
                                            navigationMode:
                                                GridNavigationMode.cell,
                                            columnWidthMode:
                                                ColumnWidthMode.auto,
                                            editingGestureType:
                                                EditingGestureType.tap,
                                            controller: _dataGridController,
                                            onQueryRowHeight: (details) {
                                              return details
                                                  .getIntrinsicRowHeight(
                                                      details.rowIndex);
                                            },
                                            columns: [
                                              GridColumn(
                                                columnName: 'ActivityNo',
                                                autoFitPadding: tablepadding,
                                                allowEditing: true,
                                                width: 160,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Activities SI. No as per Gant Chart',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: white),
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'ActivityDetails',
                                                autoFitPadding: tablepadding,
                                                allowEditing: true,
                                                width: 240,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Activities Details',
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: white)),
                                                ),
                                              ),
                                              // GridColumn(
                                              //   columnName: 'Months',
                                              //   auets.symmetric(
                                              //       tablepadding),                                        //   allowEditing: false,
                                              //   width: 200,
                                              //   label: Container(
                                              //     padding: const EdgeInsets.symmetric(
                                              //         horizontal: 8.0),
                                              //     alignment: Alignment.center,
                                              //     child: Text('Months',
                                              //         textAlign: TextAlign.center,
                                              //         overflow: TextOverflow.values.first,
                                              //         style: TextStyle(
                                              //             fontWeight: FontWeight.bold,
                                              //             fontSize: 16,
                                              //             color: white)),
                                              //   ),
                                              // ),
                                              // GridColumn(
                                              //   columnName: 'Duration',
                                              //                       //       const EdgeInsets.symmetric(tablepadding),
                                              //   allowEditing: false,
                                              //   width: 120,
                                              //   label: Container(
                                              //     padding:
                                              //         const EdgeInsets.symmetric(horizontal: 8.0),
                                              //     alignment: Alignment.center,
                                              //     child: Text('Duration in Days',
                                              //         textAlign: TextAlign.center,
                                              //         overflow: TextOverflow.values.first,
                                              //         style: TextStyle(
                                              //             fontWeight: FontWeight.bold,
                                              //             fontSize: 16,
                                              //             color: white)
                                              //         //    textAlign: TextAlign.center,
                                              //         ),
                                              //   ),
                                              // ),
                                              // GridColumn(
                                              //   columnName: 'StartDate',
                                              //                       //       const EdgeInsets.symmetric(tablepadding),
                                              //   allowEditing: false,
                                              //   width: 160,
                                              //   label: Container(
                                              //     padding:
                                              //         const EdgeInsets.symmetric(horizontal: 8.0),
                                              //     alignment: Alignment.center,
                                              //     child: Text('Start Date',
                                              //         overflow: TextOverflow.values.first,
                                              //         style: TextStyle(
                                              //             fontWeight: FontWeight.bold,
                                              //             fontSize: 16,
                                              //             color: white)
                                              //         //    textAlign: TextAlign.center,
                                              //         ),
                                              //   ),
                                              // ),
                                              // GridColumn(
                                              //   columnName: 'EndDate',
                                              //                       //       const EdgeInsets.symmetric(tablepadding),
                                              //   allowEditing: false,
                                              //   width: 120,
                                              //   label: Container(
                                              //     padding:
                                              //         const EdgeInsets.symmetric(horizontal: 8.0),
                                              //     alignment: Alignment.center,
                                              //     child: Text('End Date',
                                              //         overflow: TextOverflow.values.first,
                                              //         style: TextStyle(
                                              //             fontWeight: FontWeight.bold,
                                              //             fontSize: 16,
                                              //             color: white)
                                              //         //    textAlign: TextAlign.center,
                                              //         ),
                                              //   ),
                                              // ),
                                              GridColumn(
                                                columnName: 'Progress',
                                                autoFitPadding: tablepadding,
                                                allowEditing: true,
                                                width: 250,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Progress',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: white)
                                                      //    textAlign: TextAlign.center,
                                                      ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Status',
                                                autoFitPadding: tablepadding,
                                                allowEditing: true,
                                                width: 250,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Remark/Status',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: white)
                                                      //    textAlign: TextAlign.center,
                                                      ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Action',
                                                autoFitPadding: tablepadding,
                                                allowEditing: true,
                                                width: 250,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Next Month Action Plan',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: white)
                                                      //    textAlign: TextAlign.center,
                                                      ),
                                                ),
                                              ),
                                            ]),
                                      )),
                                    ],
                                  );
                                }
                              }),
                        )
                      : widget.id == 'Daily Report'
                          ? Expanded(
                              child: Consumer<SummaryProvider>(
                                builder: (context, value, child) {
                                  return FutureBuilder(
                                    future: _dailydata,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data == null ||
                                            snapshot.data!.length == 0) {
                                          return const Center(
                                            child: Text(
                                              "No Data Found!!",
                                              style: TextStyle(fontSize: 25.0),
                                            ),
                                          );
                                        } else {
                                          return LoadingPage();
                                        }
                                      } else {
                                        dailyproject = value.dailydata;
                                        _dailyDataSource = DailyDataSource(
                                          dailyproject,
                                          context,
                                          widget.cityName!,
                                          widget.depoName!,
                                          selectedDate!,
                                          widget.userId,
                                        );
                                        _dataGridController =
                                            DataGridController();

                                        return SfDataGridTheme(
                                          data: SfDataGridThemeData(
                                              headerColor: lightblue),
                                          child: SfDataGrid(
                                              source: _dailyDataSource,
                                              allowEditing: true,
                                              frozenColumnsCount: 2,
                                              gridLinesVisibility:
                                                  GridLinesVisibility.both,
                                              headerGridLinesVisibility:
                                                  GridLinesVisibility.both,
                                              selectionMode:
                                                  SelectionMode.single,
                                              navigationMode:
                                                  GridNavigationMode.cell,
                                              columnWidthMode:
                                                  ColumnWidthMode.auto,
                                              editingGestureType:
                                                  EditingGestureType.tap,
                                              controller: _dataGridController,
                                              onQueryRowHeight: (details) {
                                                return details
                                                    .getIntrinsicRowHeight(
                                                        details.rowIndex);
                                              },
                                              columns: [
                                                GridColumn(
                                                  columnName: 'Date',
                                                  visible: true,
                                                  autoFitPadding: tablepadding,
                                                  allowEditing: false,
                                                  width: 150,
                                                  label: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    alignment: Alignment.center,
                                                    child: Text('Date',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: white)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  visible: false,
                                                  columnName: 'SiNo',
                                                  autoFitPadding: tablepadding,
                                                  allowEditing: false,
                                                  width: 70,
                                                  label: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    alignment: Alignment.center,
                                                    child: Text('SI No.',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: white)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  columnName: 'TypeOfActivity',
                                                  autoFitPadding: tablepadding,
                                                  allowEditing: false,
                                                  width: 200,
                                                  label: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        'Type of Activity',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: white)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  columnName: 'ActivityDetails',
                                                  autoFitPadding: tablepadding,
                                                  allowEditing: false,
                                                  width: 220,
                                                  label: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        'Activity Details',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: white)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  columnName: 'Progress',
                                                  autoFitPadding: tablepadding,
                                                  allowEditing: false,
                                                  width: 320,
                                                  label: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    alignment: Alignment.center,
                                                    child: Text('Progress',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: white)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  columnName: 'Status',
                                                  autoFitPadding: tablepadding,
                                                  allowEditing: false,
                                                  width: 320,
                                                  label: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        'Remark / Status',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: white)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  visible: false,
                                                  columnName: 'upload',
                                                  autoFitPadding: tablepadding,
                                                  allowEditing: false,
                                                  width: 150,
                                                  label: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    alignment: Alignment.center,
                                                    child: Text('Upload Image',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: white)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  columnName: 'view',
                                                  autoFitPadding: tablepadding,
                                                  allowEditing: false,
                                                  width: 120,
                                                  label: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    alignment: Alignment.center,
                                                    child: Text('View Image',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: white)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  visible: false,
                                                  columnName: 'Add',
                                                  autoFitPadding: tablepadding,
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
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: white)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  columnName: 'Delete',
                                                  autoFitPadding: tablepadding,
                                                  allowEditing: false,
                                                  visible: false,
                                                  width: 120,
                                                  label: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    alignment: Alignment.center,
                                                    child: Text('Delete Row',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: white)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                              ]),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            )

                          // ? Expanded(
                          //     child: StreamBuilder(
                          //     stream: FirebaseFirestore.instance
                          //         .collection('DailyProjectReport')
                          //         .doc('${widget.depoName}')
                          //         .collection(widget.userId)
                          //         // .doc(DateFormat.yMMMMd().format(startdate!))
                          //         .snapshots(),
                          //     builder: (context, snapshot) {
                          //       if (snapshot.connectionState ==
                          //           ConnectionState.waiting) {
                          //         return LoadingPage();
                          //       } else if (!snapshot.hasData ||
                          //           snapshot.data!.docs == null) {
                          //         return const NodataAvailable();
                          //       } else {
                          //         alldata = '';

                          //         dailyproject.clear();
                          //         alldata.forEach((element) {
                          //           dailyproject
                          //               .add(DailyProjectModel.fromjson(element));
                          //           _dailyDataSource = DailyDataSource(
                          //               dailyproject, context, widget.depoName!);
                          //           _dataGridController = DataGridController();
                          //         });

                          //         for (int i = 0;
                          //             i < snapshot.data!.docs.length;
                          //             i++) {
                          //           // for (DateTime date = startdate!;
                          //           //     date.isBefore(
                          //           //         enddate!.add(Duration(days: 1)));
                          //           //     date.add(Duration(days: 1)))
                          //           //   print(snapshot.data);
                          //           alldata = snapshot.data!.docs[i]['data']
                          //               as List<dynamic>;
                          //           // alldata = snapshot.data!.docs[i]['data']
                          //           //     as List<dynamic>;
                          //           alldata.forEach((element) {
                          //             dailyproject
                          //                 .add(DailyProjectModel.fromjson(element));
                          //             _dailyDataSource = DailyDataSource(
                          //                 dailyproject, context, widget.depoName!);
                          //             _dataGridController = DataGridController();
                          //           });
                          //         }

                          //         return SfDataGridTheme(
                          //           data: SfDataGridThemeData(headerColor: lightblue),
                          //           child: SfDataGrid(
                          //               source: _dailyDataSource,
                          //               allowEditing: true,
                          //               frozenColumnsCount: 2,
                          //               gridLinesVisibility: GridLinesVisibility.both,
                          //               headerGridLinesVisibility:
                          //                   GridLinesVisibility.both,
                          //               selectionMode: SelectionMode.single,
                          //               navigationMode: GridNavigationMode.cell,
                          //               columnWidthMode: ColumnWidthMode.auto,
                          //               editingGestureType: EditingGestureType.tap,
                          //               controller: _dataGridController,
                          //               columns: [
                          //                 GridColumn(
                          //                   columnName: 'SiNo',
                          //                   autoFitPadding:
                          //
                          //                           tablepadding,
                          //                   allowEditing: true,
                          //                   width: 70,
                          //                   label: Container(
                          //                     padding: const EdgeInsets.symmetric(
                          //                         horizontal: 8.0),
                          //                     alignment: Alignment.center,
                          //                     child: Text('SI No.',
                          //                         overflow: TextOverflow.values.first,
                          //                         textAlign: TextAlign.center,
                          //                         style: TextStyle(
                          //                             fontWeight: FontWeight.bold,
                          //                             fontSize: 16,
                          //                             color: white)
                          //                         //    textAlign: TextAlign.center,
                          //                         ),
                          //                   ),
                          //                 ),
                          //                 GridColumn(
                          //                   columnName: 'TypeOfActivity',
                          //                   autoFitPadding:
                          //
                          //                           tablepadding,
                          //                   allowEditing: true,
                          //                   width: 200,
                          //                   label: Container(
                          //                     padding: const EdgeInsets.symmetric(
                          //                         horizontal: 8.0),
                          //                     alignment: Alignment.center,
                          //                     child: Text('Type of Activity',
                          //                         overflow: TextOverflow.values.first,
                          //                         style: TextStyle(
                          //                             fontWeight: FontWeight.bold,
                          //                             fontSize: 16,
                          //                             color: white)
                          //                         //    textAlign: TextAlign.center,
                          //                         ),
                          //                   ),
                          //                 ),
                          //                 GridColumn(
                          //                   columnName: 'ActivityDetails',
                          //                   autoFitPadding:
                          //
                          //                           tablepadding,
                          //                   allowEditing: true,
                          //                   width: 220,
                          //                   label: Container(
                          //                     padding: const EdgeInsets.symmetric(
                          //                         horizontal: 8.0),
                          //                     alignment: Alignment.center,
                          //                     child: Text('Activity Details',
                          //                         overflow: TextOverflow.values.first,
                          //                         style: TextStyle(
                          //                             fontWeight: FontWeight.bold,
                          //                             fontSize: 16,
                          //                             color: white)
                          //                         //    textAlign: TextAlign.center,
                          //                         ),
                          //                   ),
                          //                 ),
                          //                 GridColumn(
                          //                   columnName: 'Progress',
                          //                   autoFitPadding:
                          //
                          //                           tablepadding,
                          //                   allowEditing: true,
                          //                   width: 320,
                          //                   label: Container(
                          //                     padding: const EdgeInsets.symmetric(
                          //                         horizontal: 8.0),
                          //                     alignment: Alignment.center,
                          //                     child: Text('Progress',
                          //                         overflow: TextOverflow.values.first,
                          //                         style: TextStyle(
                          //                             fontWeight: FontWeight.bold,
                          //                             fontSize: 16,
                          //                             color: white)
                          //                         //    textAlign: TextAlign.center,
                          //                         ),
                          //                   ),
                          //                 ),
                          //                 GridColumn(
                          //                   columnName: 'Status',
                          //                   autoFitPadding:
                          //
                          //                           tablepadding,
                          //                   allowEditing: true,
                          //                   width: 320,
                          //                   label: Container(
                          //                     padding: const EdgeInsets.symmetric(
                          //                         horizontal: 8.0),
                          //                     alignment: Alignment.center,
                          //                     child: Text('Remark / Status',
                          //                         overflow: TextOverflow.values.first,
                          //                         style: TextStyle(
                          //                             fontWeight: FontWeight.bold,
                          //                             fontSize: 16,
                          //                             color: white)
                          //                         //    textAlign: TextAlign.center,
                          //                         ),
                          //                   ),
                          //                 ),
                          //                 GridColumn(
                          //                   columnName: 'Delete',
                          //                   autoFitPadding:
                          //
                          //                           tablepadding,
                          //                   allowEditing: true,
                          //                   visible: false,
                          //                   width: 120,
                          //                   label: Container(
                          //                     padding: const EdgeInsets.symmetric(
                          //                         horizontal: 8.0),
                          //                     alignment: Alignment.center,
                          //                     child: Text('Delete Row',
                          //                         overflow: TextOverflow.values.first,
                          //                         style: TextStyle(
                          //                             fontWeight: FontWeight.bold,
                          //                             fontSize: 16,
                          //                             color: white)
                          //                         //    textAlign: TextAlign.center,
                          //                         ),
                          //                   ),
                          //                 ),
                          //               ]),
                          //         );
                          //       }
                          //     },
                          //   ))

                          : widget.id == 'Quality Checklist'
                              ? Expanded(
                                  child: QualityChecklist(
                                      currentDate: DateFormat.yMMMMd()
                                          .format(startdate!),
                                      isHeader: widget.isHeader,
                                      cityName: widget.cityName,
                                      depoName: widget.depoName))
                              : Expanded(
                                  child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('SafetyChecklistTable2')
                                        .doc(widget.depoName!)
                                        .collection('userId')
                                        .doc(widget.userId)
                                        .collection('date')
                                        .doc(DateFormat.yMMMMd()
                                            .format(startdate!))
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return LoadingPage();
                                      }
                                      if (!snapshot.hasData ||
                                          snapshot.data!.exists == false) {
                                        return const NodataAvailable();
                                      } else {
                                        alldata = '';
                                        alldata = snapshot.data!['data']
                                            as List<dynamic>;
                                        print(alldata);
                                        safetylisttable.clear();
                                        alldata.forEach((element) {
                                          safetylisttable.add(
                                              SafetyChecklistModel.fromJson(
                                                  element));
                                          _safetyChecklistDataSource =
                                              SafetyChecklistDataSource(
                                                  safetylisttable,
                                                  widget.cityName!,
                                                  widget.depoName!,
                                                  userId);
                                          _dataGridController =
                                              DataGridController();
                                        });
                                        return SfDataGridTheme(
                                          data: SfDataGridThemeData(
                                              headerColor: blue),
                                          child: SfDataGrid(
                                            source: _safetyChecklistDataSource,
                                            //key: key,

                                            allowEditing: true,
                                            frozenColumnsCount: 2,
                                            gridLinesVisibility:
                                                GridLinesVisibility.both,
                                            headerGridLinesVisibility:
                                                GridLinesVisibility.both,
                                            selectionMode: SelectionMode.single,
                                            navigationMode:
                                                GridNavigationMode.cell,
                                            columnWidthMode:
                                                ColumnWidthMode.auto,
                                            editingGestureType:
                                                EditingGestureType.tap,
                                            controller: _dataGridController,
                                            onQueryRowHeight: (details) {
                                              return details
                                                  .getIntrinsicRowHeight(
                                                      details.rowIndex);
                                            },
                                            columns: [
                                              GridColumn(
                                                columnName: 'srNo',
                                                autoFitPadding: tablepadding,
                                                allowEditing: true,
                                                width: 80,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Sr No',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: white)),
                                                ),
                                              ),
                                              GridColumn(
                                                width: 550,
                                                columnName: 'Details',
                                                allowEditing: true,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Details of Enclosure ',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: white)),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Status',
                                                allowEditing: true,
                                                width: 230,
                                                label: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Status of Submission of information/ documents ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: white,
                                                      )),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Remark',
                                                allowEditing: true,
                                                width: 230,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Remarks',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: white)),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'Photo',
                                                allowEditing: false,
                                                visible: false,
                                                width: 160,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  alignment: Alignment.center,
                                                  child: Text('Upload Photo',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: white)),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'ViewPhoto',
                                                allowEditing: false,
                                                width: 180,
                                                label: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  alignment: Alignment.center,
                                                  child: Text('View Photo',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: white)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                )
                ],
              ));
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }

  Future<void> _generatePDF() async {
    setState(() {
      _isloading = true;
    });
    final headerStyle =
        pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);

    final fontData1 = await rootBundle.load('fonts/IBMPlexSans-Medium.ttf');
    final fontData2 = await rootBundle.load('fonts/IBMPlexSans-Bold.ttf');

    const cellStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 14,
    );

    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
    );

    List<pw.TableRow> rows = [];

    rows.add(pw.TableRow(children: [
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Sr No',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding:
              const pw.EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
          child: pw.Center(
              child: pw.Text('Details',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Status',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Remark',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Image1',
          ))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Image2',
          ))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Image3',
          ))),
    ]));

    List<dynamic> userData = [];

    if (alldata.isNotEmpty) {
      List<pw.Widget> imageUrls = [];

      for (Map<String, dynamic> mapData in alldata) {
        String images_Path =
            '/SafetyChecklist/${widget.cityName}/${widget.depoName}/${widget.userId}/$date/${mapData['srNo']}';
        ListResult result =
            await FirebaseStorage.instance.ref().child(images_Path).listAll();

        if (result.items.isNotEmpty) {
          for (var image in result.items) {
            String downloadUrl = await image.getDownloadURL();
            if (image.name.endsWith('.pdf')) {
              imageUrls.add(
                pw.Container(
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 100,
                    child: pw.UrlLink(
                        child: pw.Text(image.name), destination: downloadUrl)),
              );
            } else {
              final myImage = await networkImage(downloadUrl);
              imageUrls.add(
                pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 100,
                    child: pw.Center(
                      child: pw.Image(myImage),
                    )),
              );
            }
          }
          if (imageUrls.length < 3) {
            int imageLoop = 3 - imageUrls.length;
            for (int i = 0; i < imageLoop; i++) {
              imageUrls.add(
                pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 100,
                    child: pw.Text('')),
              );
            }
          } else {
            int imageLoop = 10 - imageUrls.length;
            for (int i = 0; i < imageLoop; i++) {
              imageUrls.add(
                pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 100,
                    child: pw.Text('')),
              );
            }
          }
        } else {
          for (int i = 0; i < 3; i++) {
            imageUrls.add(
              pw.Container(
                  padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                  width: 60,
                  height: 100,
                  child: pw.Text('')),
            );
          }
        }
        result.items.clear();

        //Text Rows of PDF Table
        rows.add(pw.TableRow(children: [
          pw.Container(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Center(
                  child: pw.Text(mapData['srNo'].toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Center(
                  child: pw.Text(mapData['Details'],
                      style: const pw.TextStyle(
                        fontSize: 13,
                      )))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['Status'],
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['Remark'].toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          imageUrls[0],
          imageUrls[1],
          imageUrls[2],
        ]));

        if (imageUrls.length - 3 > 0) {
          //Image Rows of PDF Table
          rows.add(pw.TableRow(children: [
            pw.Container(
                padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: pw.Text('')),
            pw.Container(
                padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                width: 60,
                height: 100,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      imageUrls[3],
                      imageUrls[4],
                    ])),
            imageUrls[5],
            imageUrls[6],
            imageUrls[7],
            imageUrls[8],
            imageUrls[9],
          ]));
        }
        imageUrls.clear();
      }
    }

    final pdf = pw.Document(
      pageMode: PdfPageMode.outlines,
    );

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
            base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
        pageFormat: const PdfPageFormat(1300, 900,
            marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
        orientation: pw.PageOrientation.natural,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child: pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Safety Report',
                          textScaleFactor: 2,
                          style: const pw.TextStyle(color: PdfColors.blue700)),
                      pw.Container(
                        width: 120,
                        height: 120,
                        child: pw.Image(profileImage),
                      ),
                    ]),
              ]));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text('User ID - ${widget.userId}',
                  // 'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.black)));
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Place:  ${widget.cityName}/${widget.depoName}',
                    textScaleFactor: 1.1,
                  ),
                  pw.Text(
                    'Date:  $date ',
                    textScaleFactor: 1.1,
                  )
                ]),
            pw.SizedBox(height: 20)
          ]),
          pw.SizedBox(height: 10),
          pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FixedColumnWidth(160),
                2: const pw.FixedColumnWidth(70),
                3: const pw.FixedColumnWidth(100),
                4: const pw.FixedColumnWidth(70),
                5: const pw.FixedColumnWidth(70),
                6: const pw.FixedColumnWidth(70),
              },
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              tableWidth: pw.TableWidth.max,
              border: pw.TableBorder.all(),
              children: rows)
        ],
      ),
    );

    final List<int> pdfData = await pdf.save();
    const String pdfPath = 'SafetyReport.pdf';

    // Save the PDF file to device storage
    if (kIsWeb) {
      html.AnchorElement(
          href: "data:application/octet-stream;base64,${base64Encode(pdfData)}")
        ..setAttribute("download", pdfPath)
        ..click();
    } else {
      const Text('Sorry it is not ready for mobile platform');
    }
    setState(() {
      _isloading = false;
    });
    // // For mobile platforms
    // final String dir = (await getApplicationDocumentsDirectory()).path;
    // final String path = '$dir/$pdfPath';
    // final File file = File(path);
    // await file.writeAsBytes(pdfData);
    //
    // // Open the PDF file for preview or download
    // OpenFile.open(file.path);
  }
}
