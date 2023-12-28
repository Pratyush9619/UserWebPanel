import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EnergyProvider extends ChangeNotifier {
  List<dynamic> intervalListData = [''];
  List<dynamic> energyListData = [0];

  List<dynamic> get intervalData => intervalListData;
  List<dynamic> get energyData => energyListData;

  fetchGraphData(String depoName, dynamic userId) {
    final List<dynamic> timeIntervalList = [];
    final List<dynamic> energyConsumedList = [];
    timeIntervalList.clear();
    energyConsumedList.clear();
    int currentMonth = DateTime.now().month;
    String monthName =
        DateFormat('MMMM').format(DateTime(2000, currentMonth, 1));

    FirebaseFirestore.instance
        .collection('EnergyManagementTable')
        .doc(depoName)
        .collection('Year')
        .doc(DateTime.now().year.toString())
        .collection('Months')
        .doc(monthName)
        .collection('Date')
        .doc(DateFormat.yMMMMd().format(DateTime.now()))
        .collection('UserId')
        .doc(userId)
        .get()
        .then((value) {
      var alldata = value.data();
      if (value.data() != null) {
        for (int i = 0; i < value.data()!['data'].length; i++) {
          timeIntervalList.add(value.data()!['data'][i]['timeInterval']);
          energyConsumedList.add(value.data()!['data'][i]['energyConsumed']);
        }

        intervalListData = timeIntervalList;
        energyListData = energyConsumedList;

        notifyListeners();
      } else {
        intervalListData = [''];
        energyListData = [0];

        notifyListeners();
      }
    });
  }
}
