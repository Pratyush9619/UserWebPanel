import 'dart:io';
import 'dart:typed_data';

import 'package:assingment/widget/style.dart';
import 'package:excel/excel.dart' as exp;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ViewExcel extends StatefulWidget {
  Reference path;
  ViewExcel({super.key, required this.path});

  @override
  State<ViewExcel> createState() => _ViewExcelState();
}

class _ViewExcelState extends State<ViewExcel> {
  List sheets = [];
  List sheetsForTitle = [];
  bool isLoad = true;
  List<List<dynamic>> sheetData = [];

  int sheetNumber = 0;
  @override
  void initState() {
    // sheetsForTitle = getFile();
    getFile().whenComplete(() {
      setState(() {
        isLoad = false;
        // sheetsForTitle = sheetData;
        // sheets = sheetData;
      });
    });
    super.initState();
  }

  // Future<List> getFile() async {
  //   const oneMegabyte = 10240 * 1024;
  //   var excel = exp.Excel.decodeBytes(
  //       (await widget.path.getData(oneMegabyte)) as List<int>);

  //   for (var table in excel.tables.keys) {
  //     List columns = [];
  //     for (var row in excel.tables[table]!.rows) {
  //       List rows = [];
  //       for (var cell in row) {
  //         rows.add(cell!.value);
  //       }
  //       columns.add(rows);
  //     }
  //     sheetData.add(columns);
  //   }
  //   return sheets;
  // }

  Future getFile() async {
    const oneMegabyte = 10240 * 1024;
    var excel = exp.Excel.decodeBytes(
        (await widget.path.getData(oneMegabyte)) as List<int>);

    for (var table in excel.tables.keys) {
      List columns = [];
      for (var row in excel.tables[table]!.rows) {
        List rows = [];
        for (var cell in row) {
          rows.add(cell!.value);
        }
        columns.add(rows);
      }
      sheetData.add(columns);
    }

    sheets = sheetData;
    sheetsForTitle = sheetData;
  }

  Future<void> assignFileValues() async {
    // sheetsForTitle.clear();
    // sheets.clear();
    sheetsForTitle = await getFile();
    sheets = await getFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: isLoad
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: sheetsForTitle[sheetNumber].length == 0
                        ? Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Sheet is empty",
                              style: title16,
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                children: List.generate(
                                  sheetsForTitle[sheetNumber][0].length,
                                  (index) => Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width * .1,
                                    height: MediaQuery.of(context).size.height *
                                        .05,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 5.0,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      border: Border(
                                        left: BorderSide(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                        right: BorderSide(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      sheetsForTitle[sheetNumber][0][index]
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: sheets[sheetNumber].length,
                                    itemBuilder: (context, col) {
                                      return Row(
                                        children: List.generate(
                                            sheets[sheetNumber][col].length,
                                            (index) {
                                          sheets[sheetNumber][0][index] = null;
                                          if (sheets[0][col][index] != null) {
                                            return Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .1,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .05,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical: 5.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color: white,
                                                border: const Border(
                                                    left: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.2,
                                                    ),
                                                    right: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.2,
                                                    ),
                                                    bottom: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.2,
                                                    )),
                                              ),
                                              child: Text(
                                                sheets[sheetNumber][col][index]
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          } else {
                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .1,
                                              height: 0,
                                              child: const Text(
                                                  "This is Empty cell"),
                                            );
                                          }
                                        }),
                                      );
                                    }),
                              ),
                            ],
                          ),
                  ),
                ),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: Row(
                      children: List.generate(2, (index) {
                        return InkWell(
                          onTap: () {
                            print("Before change" +
                                sheetsForTitle[sheetNumber].toString());
                            setState(() {
                              // sheets.clear();
                              // sheetsForTitle.clear();
                              sheetNumber = index;
                              // getFile();
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: 15,
                              right: 8,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text(
                              "Sheet ${index}",
                              style: tableheaderwhitecolor,
                            ),
                          ),
                        );
                      }),
                    )),
              ],
            ),
    ));
  }
}

List<List<dynamic>> convertSubstringsToStrings(
    List<List<dynamic>> listOfLists) {
  List<List<dynamic>> result = [];

  for (List<dynamic> sublist in listOfLists) {
    List<dynamic> convertedSublist =
        sublist.map((item) => item.toString()).toList();
    result.add(convertedSublist);
  }
  return result;
}

Widget TitleWidget(value) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(
      width: 2.0,
      color: Colors.black,
    )),
    child: Text(value),
  );
}

Widget CellWidget() {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(
      width: 2.0,
      color: Colors.black,
    )),
  );
}
