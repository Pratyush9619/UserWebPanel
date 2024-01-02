import 'package:assingment/screen/demand%20energy%20management/bar_graph.dart';
import 'package:assingment/screen/demand%20energy%20management/demand_table.dart';
import 'package:flutter/material.dart';

class DemandEnergyScreen extends StatefulWidget {
  const DemandEnergyScreen({super.key});

  @override
  State<DemandEnergyScreen> createState() => _DemandEnergyScreenState();
}

class _DemandEnergyScreenState extends State<DemandEnergyScreen> {
  //Data table columns & rows
  List<String> columns = [
    'Sr.No.',
    'CityName',
    'Depot',
    'Energy Consumed\n(in kW)'
  ];
  List<List<dynamic>> rows = [
    [1, 'Delhi', 'Nehru Place', '1500'],
    [2, 'Delhi', 'Sukhdev Vihar', '2500'],
    [3, 'Delhi', 'KalKaji', '2400'],
    [4, 'Delhi', 'Subhash Place', '2300'],
    [5, 'Delhi', 'Wazirpur', '2550'],
    [6, 'Delhi', 'Rohini-1', '2500'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Expanded(
            child: DemandTable(columns: columns, rows: rows),
          ),
          const SizedBox(
            width: 20,
          ),
          const Expanded(
            child: BarGraphScreen(),
          )
        ],
      ),
    );
  }
}
