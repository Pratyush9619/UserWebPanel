import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../model/energy_management.dart';

class EnergyManagementDatasource extends DataGridSource {
  BuildContext mainContext;
  String userId;
  String? cityName;
  String? depoName;

  EnergyManagementDatasource(this._energyManagement, this.mainContext,
      this.userId, this.cityName, this.depoName) {
    buildDataGridRows();
  }
  void buildDataGridRows() {
    dataGridRows = _energyManagement
        .map<DataGridRow>((dataGridRow) => dataGridRow.getDataGridRow())
        .toList();
  }

  @override
  List<EnergyManagementModel> _energyManagement = [];

  List<DataGridRow> dataGridRows = [];

  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();
  final DataGridController _dataGridController = DataGridController();

  @override
  List<DataGridRow> get rows => dataGridRows;

  final DateRangePickerController _controller = DateRangePickerController();
  int? balnceQtyValue;
  double? perc;
  String? startformattedTime = '12:30';
  String? endformattedTime = '15:45';

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    DateTime? rangeStartDate = DateTime.now();
    DateTime? date;
    Duration difference;

    TimeOfDay? _selectedTime = TimeOfDay.now();

    final int dataRowIndex = dataGridRows.indexOf(row);
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      difference = DateTime.parse('2023-01-01 $endformattedTime')
          .difference(DateTime.parse('2023-01-01 $startformattedTime'));
      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: (dataGridCell.columnName == 'startDate')
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        _selectedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: mainContext, //context of current state
                        );
                        if (_selectedTime != null) {
                          DateTime parsedTime = DateFormat.jm().parse(
                              // ignore: use_build_context_synchronously
                              _selectedTime!.format(mainContext).toString());
                          //converting to DateTime so that we can further format on different pattern.
                          print(parsedTime); //output 1970-01-01 22:53:00.000
                          // ignore: unrelated_type_equality_checks
                          dataGridRows[dataRowIndex].getCells()[6] ==
                              DateFormat('HH:mm').format(parsedTime);

                          startformattedTime =
                              DateFormat('HH:mm').format(parsedTime);
                          _energyManagement[dataRowIndex].startDate =
                              startformattedTime.toString();
                          // print(startformattedTime); //output 14:59:00

                          buildDataGridRows();
                          notifyListeners();
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                    Text(dataGridCell.value.toString()),
                  ],
                )
              : (dataGridCell.columnName == 'endDate')
                  ? Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            _selectedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: mainContext, //context of current state
                            );
                            if (_selectedTime != null) {
                              DateTime parsedTime = DateFormat.jm().parse(
                                  // ignore: use_build_context_synchronously
                                  _selectedTime!
                                      .format(mainContext)
                                      .toString());
                              //converting to DateTime so that we can further format on different pattern.
                              print(
                                  parsedTime); //output 1970-01-01 22:53:00.000
                              endformattedTime =
                                  DateFormat('HH:mm').format(parsedTime);
                              _energyManagement[dataRowIndex].endDate =
                                  endformattedTime.toString(); //output 14:59:00
                              buildDataGridRows();
                              notifyListeners();
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                        ),
                        Text(dataGridCell.value.toString()),
                      ],
                    )
                  : (dataGridCell.columnName == 'totalTime')
                      ? Text(difference.toString())
                      : Text(
                          dataGridCell.value.toString(),
                          textAlign: TextAlign.center,
                        ));
    }).toList());
  }

  void updateDatagridSource() {
    notifyListeners();
  }

  void updateDataGrid({required RowColumnIndex rowColumnIndex}) {
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }

  @override
  void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }
    if (column.columnName == 'srNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'srNo', value: newCellValue);
      _energyManagement[dataRowIndex].srNo = newCellValue;
    } else if (column.columnName == 'DepotName') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'DepotName', value: newCellValue);
      _energyManagement[dataRowIndex].depotName = newCellValue.toString();
    } else if (column.columnName == 'VehicleNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'VehicleNo', value: newCellValue);
      _energyManagement[dataRowIndex].vehicleNo = newCellValue;
    } else if (column.columnName == 'PssNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'PssNo', value: newCellValue);
      _energyManagement[dataRowIndex].pssNo = newCellValue;
    } else if (column.columnName == 'ChargerId') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'ChargerId', value: newCellValue);
      _energyManagement[dataRowIndex].chargerId = newCellValue;
    } else if (column.columnName == 'StartSoc') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'StartSoc', value: newCellValue);
      _energyManagement[dataRowIndex].startSoc = newCellValue;
    } else if (column.columnName == 'EndSoc') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'EndSoc', value: newCellValue);
      _energyManagement[dataRowIndex].endSoc = newCellValue;
    } else if (column.columnName == 'SatrtDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<DateTime>(columnName: 'SatrtDate', value: newCellValue);
      _energyManagement[dataRowIndex].startDate = newCellValue;
    } else if (column.columnName == 'EndDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'EndDate', value: newCellValue);
      _energyManagement[dataRowIndex].endDate = newCellValue;
    } else if (column.columnName == 'totalTime') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<DateTime>(columnName: 'totalTime', value: newCellValue);
      _energyManagement[dataRowIndex].totalTime = newCellValue;
    } else if (column.columnName == 'enrgyConsumed') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<DateTime>(
              columnName: 'enrgyConsumed', value: newCellValue);
      _energyManagement[dataRowIndex].enrgyConsumed = newCellValue;
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(
              columnName: 'timeInterval', value: newCellValue);
      _energyManagement[dataRowIndex].timeInterval = newCellValue;
    }
  }

  @override
  bool canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    // Return false, to retain in edit mode.
    return true; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    final bool isNumericType = column.columnName == 'OriginalDuration' ||
        column.columnName == 'srNo' ||
        // column.columnName == 'EndDate' ||
        // column.columnName == 'ActualStart' ||
        // column.columnName == 'ActualEnd' ||
        column.columnName == 'ActualDuration' ||
        column.columnName == 'Delay' ||
        column.columnName == 'Unit' ||
        column.columnName == 'QtyScope' ||
        column.columnName == 'QtyExecuted' ||
        column.columnName == 'BalancedQty' ||
        column.columnName == 'Progress' ||
        column.columnName == 'Weightage';

    final bool isDateTimeType = column.columnName == 'StartDate' ||
        column.columnName == 'EndDate' ||
        column.columnName == 'ActualStart' ||
        column.columnName == 'ActualEnd';
    // Holds regular expression pattern based on the column type.
    final RegExp regExp =
        _getRegExp(isNumericType, isDateTimeType, column.columnName);

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        decoration: const InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp),
        ],
        keyboardType: isNumericType
            ? TextInputType.number
            : isDateTimeType
                ? TextInputType.datetime
                : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = double.parse(value);
            } else if (isDateTimeType) {
              newCellValue = value;
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          /// Call [CellSubmit] callback to fire the canSubmitCell and
          /// onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
    );
  }

  RegExp _getRegExp(
      bool isNumericKeyBoard, bool isDateTimeBoard, String columnName) {
    return isNumericKeyBoard
        ? RegExp('[0-9.]')
        : isDateTimeBoard
            ? RegExp('[0-9-]')
            : RegExp('[a-zA-Z0-9.@!#^&*(){+-}%|<>?_=+,/ )]');
  }
}
