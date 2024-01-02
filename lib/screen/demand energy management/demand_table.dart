import 'package:assingment/widget/style.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class DemandTable extends StatefulWidget {
  final List<dynamic> columns;
  final List<dynamic> rows;
  const DemandTable({super.key, required this.columns, required this.rows});

  @override
  State<DemandTable> createState() => _DemandTableState();
}

class _DemandTableState extends State<DemandTable> {
  final tableHeadingColor = Colors.blue;
  final tableRowColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: const EdgeInsets.only(left: 30, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 40, top: 70),
              child: const Text(
                'Depot Demand Energy Management Table',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Flexible(
              child: Container(
                height: 400,
                child: DataTable2(
                  columnSpacing: 15,
                  headingRowColor: MaterialStatePropertyAll(tableHeadingColor),
                  dataRowColor: MaterialStatePropertyAll(tableRowColor),
                  border: TableBorder.all(),
                  dividerThickness: 0,
                  dataRowHeight: 40,
                  headingRowHeight: 50,
                  headingTextStyle:
                      TextStyle(color: white, fontWeight: FontWeight.bold),
                  dataTextStyle:
                      TextStyle(fontWeight: FontWeight.bold, color: black),
                  columns: List.generate(
                    widget.columns.length,
                    (index) => DataColumn2(
                      fixedWidth: index == 0
                          ? 50
                          : index == 1
                              ? 170
                              : index == 3
                                  ? 140
                                  : null,
                      label: Text(
                        widget.columns[index],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  rows: List.generate(
                    widget.rows.length,
                    (rowNo) {
                      return DataRow2(
                        cells: List.generate(
                          widget.rows[0].length,
                          (cellNo) => DataCell(
                            Text(
                              widget.rows[rowNo][cellNo].toString(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
