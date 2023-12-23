import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class EnergyManagementModel {
  EnergyManagementModel(
      {required this.srNo,
      required this.depotName,
      required this.vehicleNo,
      required this.pssNo,
      required this.chargerId,
      required this.startSoc,
      required this.endSoc,
      required this.startDate,
      required this.endDate,
      required this.totalTime,
      // this.dependency,
      required this.enrgyConsumed,
      required this.timeInterval});

  dynamic srNo;
  String depotName;
  dynamic vehicleNo;
  int pssNo;
  dynamic chargerId;
  int startSoc;
  int endSoc;
  String startDate;
  String endDate;
  String totalTime;
  double enrgyConsumed;
  dynamic timeInterval;

  // factory Employee.fromJson(Map<String, dynamic> json) {
  //   return Employee(
  //       srNo: json['srNo'],
  //       activity: json['Activity'],
  //       originalDuration: json['OriginalDuration'],
  //       startDate: json['StartDate'],
  //       endDate: json['EndDate'],
  //       actualstartDate: json['ActualStart'],
  //       actualendDate: json['ActualEnd'],
  //       actualDuration: json['ActualDuration'],
  //       delay: json['Delay'],
  //       reasonDelay: json['ReasonDelay'],
  //       unit: json['Unit'],
  //       scope: json['QtyScope'],
  //       qtyExecuted: json['QtyExecuted'],
  //       balanceQty: json['BalancedQty'],
  //       percProgress: json['Progress'],
  //       weightage: json['Weightage']);
  // }

  DataGridRow getDataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell<dynamic>(columnName: 'srNo', value: srNo),
      DataGridCell<String>(columnName: 'DepotName', value: depotName),
      DataGridCell<dynamic>(columnName: 'VehicleNo', value: vehicleNo),
      DataGridCell<int>(columnName: 'pssNo', value: pssNo),
      DataGridCell<int>(columnName: 'chargerId', value: chargerId),
      DataGridCell<int>(columnName: 'startSoc', value: startSoc),
      DataGridCell<int>(columnName: 'endSoc', value: endSoc),
      DataGridCell<String>(columnName: 'startDate', value: startDate),
      DataGridCell<String>(columnName: 'endDate', value: endDate),
      DataGridCell<String>(columnName: 'totalTime', value: totalTime),
      DataGridCell<double>(columnName: 'enrgyConsumed', value: enrgyConsumed),
      DataGridCell<dynamic>(columnName: 'timeInterval', value: timeInterval),
    ]);
  }
}
