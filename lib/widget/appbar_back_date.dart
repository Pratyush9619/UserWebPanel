import 'package:assingment/Planning_Pages/safety_checklist.dart';
import 'package:assingment/overview/daily_project.dart';
import 'package:assingment/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../Authentication/auth_service.dart';
import '../Authentication/login_register.dart';

class CustomAppBarBackDate extends StatefulWidget {
  String? text;
  // final IconData? icon;
  final bool haveSynced;
  final bool haveSummary;
  final void Function()? store;
  VoidCallback? onTap;
  final void Function()? choosedate;
  bool havebottom;
  bool havedropdown;
  bool isdetailedTab;

  TabBar? tabBar;

  CustomAppBarBackDate(
      {super.key,
      this.text,
      this.haveSynced = false,
      this.haveSummary = false,
      this.store,
      this.onTap,
      this.choosedate,
      this.havedropdown = false,
      this.havebottom = false,
      this.isdetailedTab = false,
      this.tabBar});

  @override
  State<CustomAppBarBackDate> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBarBackDate> {
  dynamic userId;
  String? rangeStartDate = DateFormat.yMMMMd().format(DateTime.now());

  @override
  void initState() {
    getUserId().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: blue,
            title: Text(
              widget.text.toString(),
            ),
            actions: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        widget.choosedate!();
                      },
                      icon: const Icon(Icons.calendar_today)),
                  Text(
                    selectedDate!,
                    style: TextStyle(color: white, fontSize: 18),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 30)),
              widget.haveSummary
                  ? Padding(
                      padding:
                          const EdgeInsets.only(right: 40, top: 10, bottom: 10),
                      child: Container(
                        height: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),
                        child: TextButton(
                            onPressed: widget.onTap,
                            child: Text(
                              'View Summary',
                              style: TextStyle(color: white, fontSize: 20),
                            )),
                      ),
                    )
                  : Container(),
              widget.haveSynced
                  ? Padding(
                      padding:
                          const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                      child: Container(
                        height: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),
                        child: TextButton(
                            onPressed: () {
                              widget.store!();
                            },
                            child: Text(
                              'Sync Data',
                              style: TextStyle(color: white, fontSize: 20),
                            )),
                      ),
                    )
                  : Container(),
              Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: GestureDetector(
                      onTap: () {
                        onWillPop(context);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/logout.png',
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            userId ?? '',
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ))
                  //  IconButton(
                  //   icon: Icon(
                  //     Icons.logout_rounded,
                  //     size: 25,
                  //     color: white,
                  //   ),
                  //   onPressed: () {
                  //     onWillPop(context);
                  //   },
                  // )
                  ),
            ],
            bottom: widget.havebottom
                ? TabBar(
                    labelColor: Colors.yellow,
                    labelStyle: buttonWhite,
                    unselectedLabelColor: white,

                    //indicatorSize: TabBarIndicatorSize.label,
                    indicator: MaterialIndicator(
                      horizontalPadding: 24,
                      bottomLeftRadius: 8,
                      bottomRightRadius: 8,
                      color: almostblack,
                      paintingStyle: PaintingStyle.fill,
                    ),

                    tabs: const [
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                    ],
                  )
                : widget.isdetailedTab
                    ? TabBar(
                        labelColor: Colors.yellow,
                        labelStyle: buttonWhite,
                        unselectedLabelColor: white,

                        //indicatorSize: TabBarIndicatorSize.label,
                        indicator: MaterialIndicator(
                          horizontalPadding: 24,
                          bottomLeftRadius: 8,
                          bottomRightRadius: 8,
                          color: almostblack,
                          paintingStyle: PaintingStyle.fill,
                        ),

                        tabs: const [
                          Tab(text: "RFC Drawings of Civil Activities"),
                          Tab(
                              text:
                                  "EV Layout Drawings of Electrical Activities"),
                          Tab(text: "Shed Lighting Drawings & Specification"),
                        ],
                      )
                    : widget.tabBar));
  }

  Future<bool> onWillPop(BuildContext context) async {
    bool a = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Close TATA POWER?",
                      style: subtitle1White,
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              //color: blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //color: blue,
                            child: Center(
                                child: Text(
                              "No",
                              style: button.copyWith(color: blue),
                            )),
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            a = true;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginRegister(),
                                ));
                            // exit(0);
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //color: blue,
                            child: Center(
                                child: Text(
                              "Yes",
                              style: button,
                            )),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ));
    return a;
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }
}
