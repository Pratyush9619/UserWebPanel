import 'package:assingment/KeysEvents/Grid_DataTableA2.dart';
import 'package:assingment/KeysEvents/Grid_DataTableA3.dart';
import 'package:assingment/KeysEvents/Grid_DataTableA4.dart';
import 'package:assingment/KeysEvents/Grid_DataTableA6.dart';
import 'package:assingment/KeysEvents/view_AllFiles.dart';
import 'package:assingment/widget/nodata_available.dart';
import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gantt_chart/gantt_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../Authentication/auth_service.dart';
import '../KeysEvents/Grid_DataTable51.dart';
import '../KeysEvents/Grid_DataTableA10.dart';
import '../KeysEvents/Grid_DataTableA7.dart';
import '../KeysEvents/Grid_DataTableA8.dart';
import '../KeysEvents/Grid_DataTableA9.dart';
import '../components/loading_page.dart';
import '../datasource/key_datasource.dart';
import '../model/employee.dart';
import '../provider/key_provider.dart';
import '../widget/custom_appbar.dart';
import '../widget/keyEvents_data.dart';
import '../widget/keyboard_listener.dart';

void main() {
  runApp(KeyEvents2());
  initializeDateFormatting();
}

/// The application that contains datagrid on it.

/// The home page of the application which hosts the datagrid.
class KeyEvents2 extends StatefulWidget {
  /// Creates the home page.
  String? depoName;
  String? cityName;
  KeyEvents2({Key? key, this.depoName, this.cityName}) : super(key: key);

  @override
  _KeyEvents2State createState() => _KeyEvents2State();
}

class _KeyEvents2State extends State<KeyEvents2> {
  late KeyDataSourceKeyEvents _KeyDataSourceKeyEvents;
  List<Employee> _employees = <Employee>[];
  late DataGridController _dataGridController;
  //  List<DataGridRow> dataGridRows = [];
  DataGridRow? dataGridRow;
  RowColumnIndex? rowColumnIndex;
  GridColumn? column;
  List<dynamic> tabledata2 = [];
  Stream? yourstream;
  Stream? yourstream1;

  List<String> startdate = [];
  List<String> enddate = [];
  List<String> asstartdate = [];
  List<String> asenddate = [];
  String? actualstartdate;
  String? actualenddate;
  List<double> weight = [];
  List<ChartData> chartData = <ChartData>[];
  List<ChartData> chartData2 = <ChartData>[];
  String? sdate;
  String? edate;
  String? asdate;
  String? aedate;
  var alldata;
  bool _isLoading = true;
  bool _isInit = true;
  int? length;
  final scrollController = ScrollController();
  List<GanttEventBase> ganttdata = [];
  List<String> startDate = [];
  List<String> endDate = [];
  List<String> actualstart = [];
  List<String> actualend = [];

  String? sd;
  String? ed;
  String? as;
  String? ae;
  List<int> srNo = [];
  DateTime dateTime = DateTime.now();
  double totalvalue = 0.0;

  String? sdate1,
      sdate2,
      sdate3,
      sdate4,
      sdate5,
      sdate6,
      sdate7,
      sdate8,
      sdate9,
      sdate10;
  String? edate1,
      edate2,
      edate3,
      edate4,
      edate5,
      edate6,
      edate7,
      edate8,
      edate9,
      edate10;
  String? asdate1,
      asdate2,
      asdate3,
      asdate4,
      asdate5,
      asdate6,
      asdate7,
      asdate8,
      asdate9,
      asdate10;
  String? aedate1,
      aedate2,
      aedate3,
      aedate4,
      aedate5,
      aedate6,
      aedate7,
      aedate8,
      aedate9,
      aedate10;

  List<double> weight1 = [];
  List<double> weight2 = [];
  List<double> weight3 = [];
  List<double> weight4 = [];
  List<double> weight5 = [];
  List<double> weight6 = [];
  List<double> weight7 = [];
  List<double> weight8 = [];
  List<double> weight9 = [];
  List<double> weight10 = [];

  String? startdate1,
      enddate1,
      asstartdate1,
      asenddate1,
      actualstartdate1,
      actualenddate1;
  String? startdate2,
      enddate2,
      asstartdate2,
      asenddate2,
      actualstartdate2,
      actualenddate2;
  String? startdate3,
      enddate3,
      asstartdate3,
      asenddate3,
      actualstartdate3,
      actualenddate3;
  String? startdate4,
      enddate4,
      asstartdate4,
      asenddate4,
      actualstartdate4,
      actualenddate4;
  String? startdate5,
      enddate5,
      asstartdate5,
      asenddate5,
      actualstartdate5,
      actualenddate5;
  String? startdate6,
      enddate6,
      asstartdate6,
      asenddate6,
      actualstartdate6,
      actualenddate6;
  String? startdate7,
      enddate7,
      asstartdate7,
      asenddate7,
      actualstartdate7,
      actualenddate7;
  String? startdate8,
      enddate8,
      asstartdate8,
      asenddate8,
      actualstartdate8,
      actualenddate8;
  String? startdate9,
      enddate9,
      asstartdate9,
      asenddate9,
      actualstartdate9,
      actualenddate9;

  double? perc2 = 0,
      perc3 = 0,
      perc4 = 0,
      perc5 = 0,
      perc6 = 0,
      perc7 = 0,
      perc8 = 0,
      perc9 = 0,
      perc10 = 0;
  int balanceQty2 = 0,
      balanceQty3 = 0,
      balanceQty4 = 0,
      balanceQty5 = 0,
      balanceQty6 = 0,
      balanceQty7 = 0,
      balanceQty8 = 0,
      balanceQty9 = 0,
      balanceQty10 = 0;
  int scope2 = 0,
      scope3 = 0,
      scope4 = 0,
      scope5 = 0,
      scope6 = 0,
      scope7 = 0,
      scope8 = 0,
      scope9 = 0,
      scope10 = 0;
  int totalBalanceQty2 = 0,
      totalBalanceQty3 = 0,
      totalBalanceQty4 = 0,
      totalBalanceQty5 = 0,
      totalBalanceQty6 = 0,
      totalBalanceQty7 = 0,
      totalBalanceQty8 = 0,
      totalBalanceQty9 = 0,
      totalBalanceQty10 = 0;
  int totalscope2 = 0,
      totalscope3 = 0,
      totalscope4 = 0,
      totalscope5 = 0,
      totalscope6 = 0,
      totalscope7 = 0,
      totalscope8 = 0,
      totalscope9 = 0,
      totalscope10 = 0;

  dynamic userId;
  String? activity;
  List<String> allstartDate = [];
  List<String> allendDate = [];
  List<String> allactualstart = [];
  List<String> allactualEnd = [];
  List<String> allsrNo = [];
  double? totalPecProgress = 0.0;
  List<int> indicesToSkip = [0, 2, 8, 12, 16, 27, 33, 39, 65, 76];

  @override
  void initState() {
    getUserId().whenComplete(() {
      yourstream = FirebaseFirestore.instance
          .collection('KeyEventsTable')
          .doc(widget.depoName!)
          .collection('KeyDataTable')
          .doc(userId)
          .collection('KeyAllEvents')
          .doc('keyEvents')
          // .doc('${widget.depoName}')
          .snapshots();

      _isLoading = false;
      setState(() {});
    });

    super.initState();
  }

  List<Widget> menuwidget = [];

  @override
  Widget build(BuildContext context) {
    menuwidget = [
      StatutoryAprovalA2(
        userid: userId,
        depoName: widget.depoName,
        cityName: widget.cityName,
        keyEvents: '',
      ),
      StatutoryAprovalA3(
        userid: userId,
        depoName: widget.depoName,
        cityName: widget.cityName,
      ),
      StatutoryAprovalA4(
        userid: userId,
        depoName: widget.depoName,
        cityName: widget.cityName,
      ),
      StatutoryAproval(
        userid: userId,
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      // StatutoryAprovalA5(
      //   userid: userId,
      //   cityName: widget.cityName,
      //   depoName: widget.depoName,
      // ),
      StatutoryAprovalA6(
        userid: userId,
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      StatutoryAprovalA7(
        userid: userId,
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      StatutoryAprovalA8(
        userid: userId,
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      StatutoryAprovalA9(
        userid: userId,
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      StatutoryAprovalA10(
        userid: userId,
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
    ];
    return _isLoading
        ? LoadingPage()
        : keyBoardArrow(
            scrollController: scrollController,
            myScaffold: Scaffold(
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: CustomAppBar(
                      isprogress: true,
                      showDepoBar: true,
                      toPlanning: true,
                      cityname: widget.cityName,
                      text: '${widget.cityName} / ${widget.depoName}',
                      haveSynced: true,
                      store: () {
                        storeData();
                      },
                    )),

                //  AppBar(
                //   title: Text(
                //       '${widget.cityName} / ${widget.depoName} / Key Events  '),
                //   backgroundColor: blue,
                // ),
                body: StreamBuilder(
                    stream: yourstream,
                    builder: (context, snapshot) {
                      ganttdata = [];
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingPage();
                      }
                      if (!snapshot.hasData || snapshot.data.exists == false) {
                        // Parse the date string into a DateTime object
                        // List<String> dateParts = sdate2!.split('-');
                        // int day = int.parse(dateParts[0]);
                        // int month = int.parse(dateParts[1]);
                        // int year = int.parse(dateParts[2]);

                        // dateTime = DateTime(year, month, day);
                        // List<String> dateParts = sdate1!.split('-');
                        // int day = int.parse(dateParts[0]);
                        // int month = int.parse(dateParts[1]);
                        // int year = int.parse(dateParts[2]);

                        // dateTime = DateTime(year, month, day);
                        int durationParse(String fromtime, String todate) {
                          DateTime startdate =
                              DateFormat('dd-MM-yyyy').parse(fromtime);
                          DateTime enddate =
                              DateFormat('dd-MM-yyyy').parse(todate);
                          return enddate.difference(startdate).inDays;
                        }

                        _employees = getKeyEventsData();
                        _KeyDataSourceKeyEvents =
                            KeyDataSourceKeyEvents(_employees, context);
                        _dataGridController = DataGridController();

                        return SizedBox(
                            height: 580,
                            child: Row(children: [
                              Expanded(
                                child: SfDataGrid(
                                  source: _KeyDataSourceKeyEvents,
                                  allowEditing: true,
                                  frozenColumnsCount: 2,
                                  editingGestureType: EditingGestureType.tap,
                                  headerGridLinesVisibility:
                                      GridLinesVisibility.both,
                                  gridLinesVisibility: GridLinesVisibility.both,
                                  selectionMode: SelectionMode.single,
                                  navigationMode: GridNavigationMode.cell,
                                  columnWidthMode: ColumnWidthMode.auto,
                                  controller: _dataGridController,
                                  // onQueryRowHeight: (details) {
                                  //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                  // },
                                  columns: [
                                    GridColumn(
                                      columnName: 'srNo',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: false,
                                      width: 60,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Sr No',
                                          overflow: TextOverflow.values.first,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),

                                          //    textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Activity',
                                      width: 200,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Activity',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'OriginalDuration',
                                      width: 80,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Original Duration',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'StartDate',
                                      allowEditing: false,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Start Date',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'EndDate',
                                      allowEditing: false,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          'End  Date',
                                          overflow: TextOverflow.values.first,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ActualStart',
                                      allowEditing: false,
                                      width: 150,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Actual Start',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ActualEnd',
                                      allowEditing: false,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          'Actual End',
                                          overflow: TextOverflow.values.first,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ActualDuration',
                                      allowEditing: false,
                                      width: 80,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Actual Duration',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Delay',
                                      allowEditing: false,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Delay',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ReasonDelay',
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'ReasonDelay',
                                          overflow: TextOverflow.values.first,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Unit',
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Unit',
                                          overflow: TextOverflow.values.first,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'QtyScope',
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Oty as per scope',
                                          overflow: TextOverflow.values.first,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'QtyExecuted',
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Qty executed',
                                          overflow: TextOverflow.values.first,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'BalancedQty',
                                      label: Container(
                                        width: 150,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Balanced Qty',
                                          overflow: TextOverflow.values.first,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Progress',
                                      allowEditing: false,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '% of Progress',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Weightage',
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Weightage',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  width: 450,
                                  child: GanttChartView(
                                      scrollController: scrollController,
                                      scrollPhysics:
                                          const BouncingScrollPhysics(),
                                      maxDuration: null,
                                      // const Duration(days: 30 * 2),
                                      // optional, set to null for infinite horizontal scroll
                                      startDate:
                                          DateTime(2023, 8, 1), //required
                                      dayWidth: 40, //column width for each day
                                      dayHeaderHeight: 35,
                                      eventHeight: 25, //row height for events

                                      stickyAreaWidth: 80, //sticky area width
                                      showStickyArea:
                                          true, //show sticky area or not
                                      showDays: true, //show days or not
                                      startOfTheWeek: WeekDay
                                          .monday, //custom start of the week
                                      weekHeaderHeight: 30,
                                      weekEnds: const {
                                        // WeekDay.saturday,
                                        // WeekDay.sunday
                                      }, //custom weekends
                                      isExtraHoliday: (context, day) {
                                        //define custom holiday logic for each day
                                        return DateUtils.isSameDay(
                                            DateTime(2023, 7, 1), day);
                                      },
                                      events: ganttdata))
                            ]));
                      } else {
                        alldata = snapshot.data['data'] as List<dynamic>;

                        for (int i = 0; i < alldata.length; i++) {
                          _employees.clear();
                          allstartDate.clear();
                          allactualEnd.clear();
                          allsrNo.clear();
                          alldata.asMap().forEach((index, element) {
                            double totalWeightage = 0.0;
                            int totalScope = 0;
                            int totalbalanceQty = 0;
                            if (!indicesToSkip.contains(index)) {
                              _employees.add(Employee.fromJson(element));
                              allstartDate.add(alldata[index]['StartDate']);
                              allendDate.add(alldata[index]['EndDate']);
                              allactualstart.add(alldata[index]['ActualStart']);
                              allactualEnd.add(alldata[index]['ActualEnd']!);
                              allsrNo.add(alldata[index]['srNo']);

                              double weightage = alldata[index]['Weightage'];
                              totalWeightage = totalWeightage + weightage;

                              int scope = alldata[index]['QtyScope'];
                              totalScope = totalScope + scope;

                              int balncQty = alldata[index]['BalancedQty'];
                              totalbalanceQty = totalbalanceQty + balncQty;
                              totalWeightage = totalWeightage + weightage;
                      
                              totalPecProgress =
                                  totalbalanceQty / totalScope * totalWeightage;

                              print('total+$totalPecProgress');
                              Provider.of<KeyProvider>(context, listen: false)
                                  .saveProgressValue(totalPecProgress!);
                            } else if (index == 0) {
                              dynamic srNo = alldata[index]['srNo'];
                              sdate1 = alldata[1]['StartDate'];
                              edate1 = alldata[1]['EndDate'];
                              asdate1 = alldata[1]['ActualStart'];
                              aedate1 = alldata[1]['ActualEnd'];
                              activity = alldata[index]['Activity'];

                              allstartDate.add(sdate1!);
                              allendDate.add(edate1!);
                              allactualstart.add(asdate1!);
                              allactualEnd.add(aedate1!);
                              allsrNo.add(srNo);
                              double totalweightage = 0;
                              for (int i = 1; i < 2; i++) {
                                double weightage = alldata[i]['Weightage'];
                                totalweightage = totalweightage + weightage;
                              }
                              _employees.add(Employee(
                                  srNo: srNo,
                                  activity: activity!,
                                  originalDuration:
                                      durationParse(sdate1!, edate1!),
                                  startDate: sdate1,
                                  endDate: edate1,
                                  actualstartDate: asdate1,
                                  actualendDate: aedate1,
                                  actualDuration:
                                      durationParse(asdate1!, aedate1!),
                                  delay: durationParse(edate1!, aedate1!),
                                  reasonDelay: 'reasonDelay',
                                  unit: 1,
                                  scope: 5,
                                  qtyExecuted: 2,
                                  balanceQty: 2,
                                  percProgress: 0.5,
                                  weightage: totalweightage));
                            } else if (index == 2) {
                              dynamic srNo = alldata[index]['srNo'];
                              sdate1 = alldata[3]['StartDate'];
                              edate1 = alldata[7]['EndDate'];
                              asdate1 = alldata[3]['ActualStart'];
                              aedate1 = alldata[7]['ActualEnd'];
                              var acti = alldata[index]['Activity'];
                              allstartDate.add(sdate1!);
                              allendDate.add(edate1!);
                              allactualstart.add(asdate1!);
                              allactualEnd.add(aedate1!);
                              allsrNo.add(srNo);
                              double totalweightage = 0;
                              int totalScope = 0;
                              int totalExecuted = 0;
                              int totalbalanceQty = 0;
                              for (int i = 3; i < 8; i++) {
                                int scope = alldata[i]['QtyScope'];
                                int executed = alldata[i]['QtyExecuted'];
                                double weightage = alldata[i]['Weightage'];
                                totalweightage = totalweightage + weightage;
                                totalScope = totalScope + scope;
                                totalExecuted = totalExecuted + executed;
                                totalbalanceQty = totalScope - totalExecuted;
                              }
                              _employees.add(Employee(
                                  srNo: srNo,
                                  activity: acti!,
                                  originalDuration:
                                      durationParse(sdate1!, edate1!),
                                  startDate: sdate1,
                                  endDate: edate1,
                                  actualstartDate: asdate1,
                                  actualendDate: aedate1,
                                  actualDuration:
                                      durationParse(asdate1!, aedate1!),
                                  delay: durationParse(edate1!, aedate1!),
                                  reasonDelay: 'reasonDelay',
                                  unit: 1,
                                  scope: totalScope,
                                  qtyExecuted: totalExecuted,
                                  balanceQty: totalbalanceQty,
                                  percProgress: 0.5,
                                  weightage: totalweightage));
                            } else if (index == 8) {
                              dynamic srNo = alldata[index]['srNo'];
                              sdate1 = alldata[9]['StartDate'];
                              edate1 = alldata[11]['EndDate'];
                              asdate1 = alldata[9]['ActualStart'];
                              aedate1 = alldata[11]['ActualEnd'];
                              var acti = alldata[index]['Activity'];
                              allstartDate.add(sdate1!);
                              allendDate.add(edate1!);
                              allactualstart.add(asdate1!);
                              allactualEnd.add(aedate1!);
                              allsrNo.add(srNo);
                              double totalweightage = 0;
                              for (int i = 9; i < 12; i++) {
                                double weightage = alldata[i]['Weightage'];
                                totalweightage = totalweightage + weightage;
                              }
                              _employees.add(Employee(
                                  srNo: srNo,
                                  activity: acti!,
                                  originalDuration:
                                      durationParse(sdate1!, edate1!),
                                  startDate: sdate1,
                                  endDate: edate1,
                                  actualstartDate: asdate1,
                                  actualendDate: aedate1,
                                  actualDuration:
                                      durationParse(asdate1!, aedate1!),
                                  delay: durationParse(edate1!, aedate1!),
                                  reasonDelay: 'reasonDelay',
                                  unit: 1,
                                  scope: 2,
                                  qtyExecuted: 5,
                                  balanceQty: 2,
                                  percProgress: 0.5,
                                  weightage: 2));
                            } else if (index == 12) {
                              dynamic srNo = alldata[index]['srNo'];
                              sdate1 = alldata[13]['StartDate'];
                              edate1 = alldata[15]['EndDate'];
                              asdate1 = alldata[13]['ActualStart'];
                              aedate1 = alldata[15]['ActualEnd'];
                              var acti = alldata[index]['Activity'];
                              allstartDate.add(sdate1!);
                              allendDate.add(edate1!);
                              allactualstart.add(asdate1!);
                              allactualEnd.add(aedate1!);
                              allsrNo.add(srNo);
                              double totalweightage = 0;
                              for (int i = 13; i < 16; i++) {
                                double weightage = alldata[i]['Weightage'];
                                totalweightage = totalweightage + weightage;
                              }
                              _employees.add(Employee(
                                  srNo: srNo,
                                  activity: acti!,
                                  originalDuration:
                                      durationParse(sdate1!, edate1!),
                                  startDate: sdate1,
                                  endDate: edate1,
                                  actualstartDate: asdate1,
                                  actualendDate: aedate1,
                                  actualDuration:
                                      durationParse(asdate1!, aedate1!),
                                  delay: durationParse(edate1!, aedate1!),
                                  reasonDelay: 'reasonDelay',
                                  unit: 1,
                                  scope: 2,
                                  qtyExecuted: 5,
                                  balanceQty: 2,
                                  percProgress: 0.5,
                                  weightage: totalweightage));
                            } else if (index == 16) {
                              dynamic srNo = alldata[index]['srNo'];
                              sdate1 = alldata[17]['StartDate'];
                              edate1 = alldata[26]['EndDate'];
                              asdate1 = alldata[17]['ActualStart'];
                              aedate1 = alldata[26]['ActualEnd'];
                              var acti = alldata[index]['Activity'];
                              allstartDate.add(sdate1!);
                              allendDate.add(edate1!);
                              allactualstart.add(asdate1!);
                              allactualEnd.add(aedate1!);
                              allsrNo.add(srNo);
                              double totalweightage = 0;
                              for (int i = 17; i < 27; i++) {
                                double weightage = alldata[i]['Weightage'];
                                totalweightage = totalweightage + weightage;
                              }
                              _employees.add(Employee(
                                  srNo: srNo,
                                  activity: acti!,
                                  originalDuration:
                                      durationParse(sdate1!, edate1!),
                                  startDate: sdate1,
                                  endDate: edate1,
                                  actualstartDate: asdate1,
                                  actualendDate: aedate1,
                                  actualDuration:
                                      durationParse(asdate1!, aedate1!),
                                  delay: durationParse(edate1!, aedate1!),
                                  reasonDelay: 'reasonDelay',
                                  unit: 1,
                                  scope: 2,
                                  qtyExecuted: 5,
                                  balanceQty: 2,
                                  percProgress: 0.5,
                                  weightage: totalweightage));
                            } else if (index == 27) {
                              dynamic srNo = alldata[index]['srNo'];
                              sdate1 = alldata[28]['StartDate'];
                              edate1 = alldata[32]['EndDate'];
                              asdate1 = alldata[28]['ActualStart'];
                              aedate1 = alldata[32]['ActualEnd'];
                              var acti = alldata[index]['Activity'];
                              allstartDate.add(sdate1!);
                              allendDate.add(edate1!);
                              allactualstart.add(asdate1!);
                              allactualEnd.add(aedate1!);
                              allsrNo.add(srNo);
                              double totalweightage = 0;
                              for (int i = 28; i < 33; i++) {
                                double weightage = alldata[i]['Weightage'];
                                totalweightage = totalweightage + weightage;
                              }
                              _employees.add(Employee(
                                  srNo: srNo,
                                  activity: acti!,
                                  originalDuration:
                                      durationParse(sdate1!, edate1!),
                                  startDate: sdate1,
                                  endDate: edate1,
                                  actualstartDate: asdate1,
                                  actualendDate: aedate1,
                                  actualDuration:
                                      durationParse(asdate1!, aedate1!),
                                  delay: durationParse(edate1!, aedate1!),
                                  reasonDelay: 'reasonDelay',
                                  unit: 1,
                                  scope: 2,
                                  qtyExecuted: 5,
                                  balanceQty: 2,
                                  percProgress: 0.5,
                                  weightage: totalweightage));
                            } else if (index == 33) {
                              dynamic srNo = alldata[index]['srNo'];
                              sdate1 = alldata[34]['StartDate'];
                              edate1 = alldata[38]['EndDate'];
                              asdate1 = alldata[34]['ActualStart'];
                              aedate1 = alldata[38]['ActualEnd'];
                              var acti = alldata[index]['Activity'];
                              allstartDate.add(sdate1!);
                              allendDate.add(edate1!);
                              allactualstart.add(asdate1!);
                              allactualEnd.add(aedate1!);
                              allsrNo.add(srNo);
                              double totalweightage = 0;
                              for (int i = 34; i < 39; i++) {
                                double weightage = alldata[i]['Weightage'];
                                totalweightage = totalweightage + weightage;
                              }
                              _employees.add(Employee(
                                  srNo: srNo,
                                  activity: acti!,
                                  originalDuration:
                                      durationParse(sdate1!, edate1!),
                                  startDate: sdate1,
                                  endDate: edate1,
                                  actualstartDate: asdate1,
                                  actualendDate: aedate1,
                                  actualDuration:
                                      durationParse(asdate1!, aedate1!),
                                  delay: durationParse(edate1!, aedate1!),
                                  reasonDelay: 'reasonDelay',
                                  unit: 1,
                                  scope: 2,
                                  qtyExecuted: 5,
                                  balanceQty: 2,
                                  percProgress: 0.5,
                                  weightage: totalweightage));
                            } else if (index == 39) {
                              dynamic srNo = alldata[index]['srNo'];
                              sdate1 = alldata[40]['StartDate'];
                              edate1 = alldata[64]['EndDate'];
                              asdate1 = alldata[40]['ActualStart'];
                              aedate1 = alldata[64]['ActualEnd'];
                              var acti = alldata[index]['Activity'];
                              allstartDate.add(sdate1!);
                              allendDate.add(edate1!);
                              allactualstart.add(asdate1!);
                              allactualEnd.add(aedate1!);
                              allsrNo.add(srNo);
                              double totalweightage = 0;
                              for (int i = 40; i < 65; i++) {
                                double weightage = alldata[i]['Weightage'];
                                totalweightage = totalweightage + weightage;
                              }
                              _employees.add(Employee(
                                  srNo: srNo,
                                  activity: acti!,
                                  originalDuration:
                                      durationParse(sdate1!, edate1!),
                                  startDate: sdate1,
                                  endDate: edate1,
                                  actualstartDate: asdate1,
                                  actualendDate: aedate1,
                                  actualDuration:
                                      durationParse(asdate1!, aedate1!),
                                  delay: durationParse(edate1!, aedate1!),
                                  reasonDelay: 'reasonDelay',
                                  unit: 1,
                                  scope: 2,
                                  qtyExecuted: 5,
                                  balanceQty: 2,
                                  percProgress: 0.5,
                                  weightage: totalweightage));
                            } else if (index == 65) {
                              dynamic srNo = alldata[index]['srNo'];
                              sdate1 = alldata[66]['StartDate'];
                              edate1 = alldata[75]['EndDate'];
                              asdate1 = alldata[66]['ActualStart'];
                              aedate1 = alldata[75]['ActualEnd'];
                              var acti = alldata[index]['Activity'];
                              allstartDate.add(sdate1!);
                              allendDate.add(edate1!);
                              allactualstart.add(asdate1!);
                              allactualEnd.add(aedate1!);
                              allsrNo.add(srNo);
                              double totalweightage = 0;
                              for (int i = 66; i < 76; i++) {
                                double weightage = alldata[i]['Weightage'];
                                totalweightage = totalweightage + weightage;
                              }
                              _employees.add(Employee(
                                  srNo: srNo,
                                  activity: acti!,
                                  originalDuration:
                                      durationParse(sdate1!, edate1!),
                                  startDate: sdate1,
                                  endDate: edate1,
                                  actualstartDate: asdate1,
                                  actualendDate: aedate1,
                                  actualDuration:
                                      durationParse(asdate1!, aedate1!),
                                  delay: durationParse(edate1!, aedate1!),
                                  reasonDelay: 'reasonDelay',
                                  unit: 1,
                                  scope: 2,
                                  qtyExecuted: 5,
                                  balanceQty: 2,
                                  percProgress: 0.5,
                                  weightage: totalweightage));
                            } else if (index == 76) {
                              dynamic srNo = alldata[index]['srNo'];
                              sdate1 = alldata[77]['StartDate'];
                              edate1 = alldata[78]['EndDate'];
                              asdate1 = alldata[77]['ActualStart'];
                              aedate1 = alldata[78]['ActualEnd'];
                              var acti = alldata[index]['Activity'];
                              allstartDate.add(sdate1!);
                              allendDate.add(edate1!);
                              allactualstart.add(asdate1!);
                              allactualEnd.add(aedate1!);
                              allsrNo.add(srNo);
                              double totalweightage = 0;
                              for (int i = 77; i < 79; i++) {
                                double weightage = alldata[i]['Weightage'];
                                totalweightage = totalweightage + weightage;
                              }
                              _employees.add(Employee(
                                  srNo: srNo,
                                  activity: acti!,
                                  originalDuration:
                                      durationParse(sdate1!, edate1!),
                                  startDate: sdate1,
                                  endDate: edate1,
                                  actualstartDate: asdate1,
                                  actualendDate: aedate1,
                                  actualDuration:
                                      durationParse(asdate1!, aedate1!),
                                  delay: durationParse(edate1!, aedate1!),
                                  reasonDelay: 'reasonDelay',
                                  unit: 1,
                                  scope: 2,
                                  qtyExecuted: 5,
                                  balanceQty: 2,
                                  percProgress: 0.5,
                                  weightage: totalweightage));
                            }
                          });
                        }

                        _KeyDataSourceKeyEvents =
                            KeyDataSourceKeyEvents(_employees, context);
                        _dataGridController = DataGridController();
                        // _employees = getDefaultEmployeeData();
                        // _employees.add(Employee(
                        //     srNo: 1,
                        //     activity: 'Letter of Award reveived  from TML',
                        //     originalDuration: 0,
                        //     startDate: sdate1,
                        //     endDate: edate1,
                        //     actualstartDate: asdate1,
                        //     actualendDate: aedate1,
                        //     actualDuration: 1,
                        //     delay: 2,
                        //     reasonDelay: 'reasonDelay',
                        //     unit: 1,
                        //     scope: 2,
                        //     qtyExecuted: 5,
                        //     balanceQty: 2,
                        //     percProgress: 0.5,
                        //     weightage: 2));

                        // _employees.add(KeyDataSourceKeyEvents.(element));
                        //     _KeyDataSourceKeyEvents =
                        //         KeyDataSourceKeyEvents(_employees, context);
                        //     _dataGridController = DataGridController();

                        List<String> dateParts = sdate1!.split('-');
                        int day = int.parse(dateParts[0]);
                        int month = int.parse(dateParts[1]);
                        int year = int.parse(dateParts[2]);

                        dateTime = DateTime(year, month, day);

                        // ganttdata.add(GanttAbsoluteEvent(
                        //   extra: 'hd',
                        //   suggestedColor: yellow,
                        //   displayNameBuilder: (context) {
                        //     int sr = 1;
                        //     return sr.toString();
                        //   },
                        //   startDate: DateTime.now(),
                        //   endDate: DateTime.now(),
                        // ));

                        // ganttdata.add(GanttAbsoluteEvent(
                        //   suggestedColor: green,
                        //   displayNameBuilder: (context) {
                        //     return '';
                        //   },
                        //   startDate: DateTime.now(),
                        //   endDate: DateTime.now(),
                        //   //displayName: yAxis[i].toString()
                        // ));

                        for (int i = 0; i < allstartDate.length; i++) {
                          ganttdata.add(GanttAbsoluteEvent(
                            suggestedColor: yellow,
                            displayNameBuilder: (context) {
                              // int sr = i + 2;
                              // int ss = sr + 1;
                              return allsrNo[i];
                            },
                            startDate:
                                DateFormat('dd-MM-yyyy').parse(allstartDate[i]),
                            endDate:
                                DateFormat('dd-MM-yyyy').parse(allendDate[i]),
                          ));

                          ganttdata.add(GanttAbsoluteEvent(
                            suggestedColor: DateFormat('dd-MM-yyyy')
                                    .parse(allactualEnd[i])
                                    .isBefore(DateFormat('dd-MM-yyyy')
                                        .parse(allendDate[i])
                                        .add(const Duration(days: 1)))
                                ? green
                                : red,
                            displayNameBuilder: (context) {
                              return '';
                            },
                            startDate: DateFormat('dd-MM-yyyy')
                                .parse(allactualstart[i]),
                            endDate:
                                DateFormat('dd-MM-yyyy').parse(allactualEnd[i]),
                            //displayName: yAxis[i].toString()
                          ));
                        }

                        return SizedBox(
                            // height: 580,
                            child: Row(children: [
                          Expanded(
                            child: SfDataGrid(
                              source: _KeyDataSourceKeyEvents,
                              allowEditing: true,
                              frozenColumnsCount: 2,
                              editingGestureType: EditingGestureType.tap,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              gridLinesVisibility: GridLinesVisibility.both,
                              selectionMode: SelectionMode.single,
                              navigationMode: GridNavigationMode.cell,
                              columnWidthMode: ColumnWidthMode.auto,
                              controller: _dataGridController,
                              // onQueryRowHeight: (details) {
                              //   return details.rowIndex == 0 ? 60.0 : 49.0;
                              // },
                              columns: [
                                GridColumn(
                                  columnName: 'srNo',
                                  autoFitPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  allowEditing: false,
                                  width: 60,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Sr No',
                                      overflow: TextOverflow.values.first,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),

                                      //    textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Activity',
                                  width: 200,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Activity',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'OriginalDuration',
                                  width: 80,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Original Duration',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'StartDate',
                                  allowEditing: false,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Start Date',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'EndDate',
                                  allowEditing: false,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'End  Date',
                                      overflow: TextOverflow.values.first,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'ActualStart',
                                  allowEditing: false,
                                  width: 150,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Actual Start',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'ActualEnd',
                                  allowEditing: false,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Actual End',
                                      overflow: TextOverflow.values.first,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'ActualDuration',
                                  allowEditing: false,
                                  width: 80,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Actual Duration',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Delay',
                                  allowEditing: false,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Delay',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'ReasonDelay',
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'ReasonDelay',
                                      overflow: TextOverflow.values.first,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Unit',
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Unit',
                                      overflow: TextOverflow.values.first,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'QtyScope',
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Oty as per scope',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'QtyExecuted',
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Qty executed',
                                      overflow: TextOverflow.values.first,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'BalancedQty',
                                  label: Container(
                                    width: 150,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Balanced Qty',
                                      overflow: TextOverflow.values.first,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Progress',
                                  allowEditing: false,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '% of Progress',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Weightage',
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Weightage',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Container(
                                width: 450,
                                child: GanttChartView(
                                    scrollController: scrollController,
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                    maxDuration: null,
                                    // const Duration(days: 30 * 2),
                                    // optional, set to null for infinite horizontal scroll
                                    startDate: dateTime, //required
                                    dayWidth: 40, //column width for each day
                                    dayHeaderHeight: 35,
                                    eventHeight: 25, //row height for events

                                    stickyAreaWidth: 80, //sticky area width
                                    showStickyArea:
                                        true, //show sticky area or not
                                    showDays: true, //show days or not
                                    startOfTheWeek: WeekDay
                                        .monday, //custom start of the week
                                    weekHeaderHeight: 30,
                                    weekEnds: const {
                                      // WeekDay.saturday,
                                      // WeekDay.sunday
                                    }, //custom weekends
                                    isExtraHoliday: (context, day) {
                                      //define custom holiday logic for each day
                                      return DateUtils.isSameDay(
                                          DateTime(2023, 7, 1), day);
                                    },
                                    events: ganttdata)),
                          )
                        ]));
                      }
                    })));

    //     ? LoadingPage()
    //     :
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
      setState(() {});
    });
  }

  List<Employee> getDefaultData() {
    return [
      Employee(
        srNo: 1,
        activity: 'Initial Survey Of Depot With TML & STA Team.',
        originalDuration: 1,
        startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualDuration: 0,
        delay: 0,
        reasonDelay: '',
        unit: 0,
        scope: 0,
        qtyExecuted: 0,
        balanceQty: 0,
        percProgress: 0,
        weightage: 0.5,
      ),
    ];
  }

  List<Employee> getDefaultEmployeeData() {
    return [
      Employee(
          srNo: 'A1',
          activity: 'Letter of Award reveived  from TML',
          originalDuration: 0,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          reasonDelay: '',
          delay: 0,
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0),
      Employee(
          srNo: 'A2',
          activity:
              'Site Survey, Job scope finalization  and Proposed layout submission',
          originalDuration: 16,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          reasonDelay: '',
          delay: 0,
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0),
      // totalweightage),
      Employee(
          srNo: 'A3',
          activity:
              'Detailed Engineering for Approval of  Civil & Electrical  Layout, GA Drawing from TML',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          reasonDelay: '',
          delay: 0,
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0),
      Employee(
          srNo: 'A4',
          activity: 'Site Mobalization activity Completed',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0),
      Employee(
          srNo: 'A5',
          activity: 'Approval of statutory clearances of BUS Depot',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0),
      Employee(
          srNo: 'A6',
          activity: 'Procurement of Order Finalisation Completed',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0),
      Employee(
          srNo: 'A7',
          activity: 'Receipt of all Materials at Site',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0),
      Employee(
          srNo: 'A8',
          activity: 'Civil Infra Development completed at Bus Depot',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0),
      Employee(
          srNo: 'A9',
          activity: 'Electrical Infra Development completed at Bus Depot',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0),
      Employee(
        srNo: 'A10',
        activity: 'Bus Depot work Completed & Handover to TML',
        originalDuration: 1,
        startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualDuration: 0,
        delay: 0,
        reasonDelay: '',
        unit: 0,
        scope: 0,
        qtyExecuted: 0,
        balanceQty: 0,
        percProgress: 0,
        weightage: 0,
      ),
    ];
  }

  int durationParse(String fromtime, String todate) {
    DateTime startdate = DateFormat('dd-MM-yyyy').parse(fromtime);
    DateTime enddate = DateFormat('dd-MM-yyyy').parse(todate);
    return enddate.difference(startdate).inDays;
  }

  List<Employee> getEmployeeData() {
    return [
      Employee(
          srNo: 'A1',
          activity: 'Letter of Award reveived  from TML',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 100,
          weightage: 0),
      Employee(
          srNo: 'A2',
          activity:
              'Site Survey, Job scope finalization  and Proposed layout submission',
          originalDuration: durationParse(
              sdate2 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
              edate2 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
          startDate: sdate2 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: edate2 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate:
              asdate2 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate:
              aedate2 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: durationParse(
              asdate2 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
              aedate2 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
          delay: durationParse(
              edate2 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
              aedate2 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
          reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: perc2!.toStringAsFixed(2),
          weightage: weight2.isNotEmpty
              ? double.parse(weight2[0].toStringAsFixed(4))
              : 0.0),
      Employee(
        srNo: 'A3',
        activity:
            'Detailed Engineering for Approval of  Civil & Electrical  Layout, GA Drawing from TML',
        originalDuration: durationParse(
            sdate3 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            edate3 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        startDate: sdate3 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        endDate: edate3 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualstartDate:
            asdate3 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualendDate:
            aedate3 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualDuration: durationParse(
            asdate3 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate3 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        delay: durationParse(
            edate3 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate3 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        reasonDelay: '',
        unit: 0,
        scope: 0,
        qtyExecuted: 0,
        balanceQty: 0,
        percProgress: perc3!.toStringAsFixed(2),
        weightage: weight3.isNotEmpty
            ? double.parse(weight3[0].toStringAsFixed(4))
            : 0.0,
      ),
      Employee(
        srNo: 'A4',
        activity: 'Site Mobalization activity Completed',
        originalDuration: durationParse(
            sdate4 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            edate4 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        startDate: sdate4 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        endDate: edate4 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualstartDate:
            asdate4 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualendDate:
            aedate4 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualDuration: durationParse(
            asdate4 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate4 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        delay: durationParse(
            edate4 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate4 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        reasonDelay: '',
        unit: 0,
        scope: 0,
        qtyExecuted: 0,
        balanceQty: 0,
        percProgress: perc4!.toStringAsFixed(2),
        weightage: weight4.isNotEmpty
            ? double.parse(weight4[0].toStringAsFixed(4))
            : 0.0,
      ),
      Employee(
        srNo: 'A5',
        activity: 'Approval of statutory clearances of BUS Depot',
        originalDuration: durationParse(
            sdate5 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            edate5 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        startDate: sdate5 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        endDate: edate5 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualstartDate:
            asdate5 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualendDate:
            aedate5 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualDuration: durationParse(
            asdate5 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate5 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        delay: durationParse(
            edate5 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate5 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        reasonDelay: '',
        unit: 0,
        scope: 0,
        qtyExecuted: 0,
        balanceQty: 0,
        percProgress: perc5!.toStringAsFixed(2),
        weightage: weight5.isNotEmpty
            ? double.parse(weight5[0].toStringAsFixed(4))
            : 0.0,
      ),
      Employee(
        srNo: 'A6',
        activity: 'Procurement of Order Finalisation Completed',
        originalDuration: durationParse(
            sdate6 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            edate6 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        startDate: sdate6 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        endDate: edate6 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualstartDate:
            asdate6 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualendDate:
            aedate6 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualDuration: durationParse(
            asdate6 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate6 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        delay: durationParse(
            edate6 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate6 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        reasonDelay: '',
        unit: 0,
        scope: 0,
        qtyExecuted: 0,
        balanceQty: 0,
        percProgress: perc6!.toStringAsFixed(2),
        weightage: weight6.isNotEmpty
            ? double.parse(weight6[0].toStringAsFixed(4))
            : 0.0,
      ),
      Employee(
        srNo: 'A7',
        activity: 'Receipt of all Materials at Site',
        originalDuration: durationParse(
            sdate7 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            edate7 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        startDate: sdate7 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        endDate: edate7 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualstartDate:
            asdate7 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualendDate:
            aedate7 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualDuration: durationParse(
            asdate7 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate7 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        delay: durationParse(
            edate7 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate7 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        reasonDelay: '',
        unit: 0,
        scope: 0,
        qtyExecuted: 0,
        balanceQty: 0,
        percProgress: perc7!.toStringAsFixed(2),
        weightage: weight7.isNotEmpty
            ? double.parse(weight7[0].toStringAsFixed(4))
            : 0.0,
      ),
      Employee(
        srNo: 'A8',
        activity: 'Civil Infra Development completed at Bus Depot',
        originalDuration: durationParse(
            sdate8 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            edate8 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        startDate: sdate8 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        endDate: edate8 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualstartDate:
            asdate8 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualendDate:
            aedate8 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualDuration: durationParse(
            asdate8 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate8 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        delay: 0,
        reasonDelay: '',
        unit: 0,
        scope: 0,
        qtyExecuted: 0,
        balanceQty: 0,
        percProgress: perc8!.toStringAsFixed(2),
        weightage: weight8.isNotEmpty
            ? double.parse(weight8[0].toStringAsFixed(4))
            : 0.0,
      ),
      Employee(
        srNo: 'A9',
        activity: 'Electrical Infra Development completed at Bus Depot',
        originalDuration: durationParse(
            sdate9 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            edate9 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        startDate: sdate9 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        endDate: edate9 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualstartDate:
            asdate9 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualendDate:
            aedate9 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualDuration: durationParse(
            asdate9 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate9 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        delay: durationParse(
            edate2 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate2 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        reasonDelay: '',
        unit: 0,
        scope: 0,
        qtyExecuted: 0,
        balanceQty: 0,
        percProgress: perc9!.toStringAsFixed(2),
        weightage: weight9.isNotEmpty
            ? double.parse(weight9[0].toStringAsFixed(4))
            : 0.0,
      ),
      Employee(
        srNo: 'A10',
        activity: 'Bus Depot work Completed & Handover to TML',
        originalDuration: durationParse(
            sdate10 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            edate10 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        startDate: sdate10 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        endDate: edate10 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualstartDate:
            asdate10 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualendDate:
            aedate10 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualDuration: durationParse(
            asdate10 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate10 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        delay: durationParse(
            edate10 ?? DateFormat('dd-MM-yyyy').format(DateTime.now()),
            aedate10 ?? DateFormat('dd-MM-yyyy').format(DateTime.now())),
        reasonDelay: '',
        unit: 0,
        scope: 0,
        qtyExecuted: 0,
        balanceQty: 0,
        percProgress: perc10!.toStringAsFixed(2),
        weightage: weight10.isNotEmpty
            ? double.parse(weight10[0].toStringAsFixed(4))
            : 0.0,
      ),
    ];
  }

  legends(Color color, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: 80,
              height: 28,
              color: color,
              padding: const EdgeInsets.all(5),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w900),
              )),
        ],
      ),
    );
  }

  void storeData() {
    Map<String, dynamic> tableData = {};
    for (var i in _KeyDataSourceKeyEvents.dataGridRows) {
      for (var data in i.getCells()) {
        tableData[data.columnName] = data.value;
      }
      tabledata2.add(tableData);
      // print(tabledata2);
      tableData = {};
    }

    FirebaseFirestore.instance
        .collection('KeyEventsTable')
        .doc(widget.depoName!)
        .collection('KeyDataTable')
        .doc(userId)
        .collection('KeyAllEvents')
        .doc('keyEvents')
        // .collection(widget.userid!)
        // .doc('${widget.depoName}${widget.keyEvents}')
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      tabledata2.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final String x;
  final double y;
  final Color y1;
}
