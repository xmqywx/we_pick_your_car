// import 'dart:html';

import 'package:flutter/material.dart';
import './details_templete.dart';
import 'package:get/get.dart';

class HaveInHandTemplete extends StatefulWidget {
  final Map arguments;
  HaveInHandTemplete({super.key, required this.arguments});

  @override
  State<HaveInHandTemplete> createState() => _HaveInHandTempleteState();
}

class _HaveInHandTempleteState extends State<HaveInHandTemplete> {
  bool _isExpanded = false;
  @override
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      children: <ExpansionPanel>[
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title:
                  Text("Pickup address : ${widget.arguments['end_position']}"),
            );
          },
          body: Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: ListBody(
              children: <Widget>[
                // DetailTemplete(
                //   customer_name: "${widget.arguments['customer_name'] ?? ''}",
                //   customer_phone_number:
                //       "${widget.arguments['customer_phone_number'] ?? ''}",
                //   time_of_appointment:
                //       "${widget.arguments['time_of_appointment'] ?? ''}",
                //   start_postion: "${widget.arguments['start_postion'] ?? ''}",
                //   end_position: "${widget.arguments['end_position'] ?? ''}",
                //   cost: "${widget.arguments['cost'] ?? ''}",
                //   status: "${widget.arguments['status'] ?? ''}",
                //   whether_to_pay: "${widget.arguments['whether_to_pay'] ?? ''}",
                // ),
                SizedBox(
                  height: 10,
                ),
                Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    elevation: 5,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 5, 16, 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Task situation",
                                style: TextStyle(
                                    fontSize: 18,
                                    height: 2,
                                    fontWeight: FontWeight.w500),
                              ),
                              Divider(
                                color: Colors.deepOrange,
                              ),
                              SizedBox(
                                height: 25,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Task start time",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "${widget.arguments['task_start_time']}",
                                      style: const TextStyle(
                                          color: Colors.blueGrey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          margin: const EdgeInsets.all(16),
                          height: 40,
                          child: ElevatedButton(
                              onPressed: () {
                                // Navigator.pushNamed(context, '/trailer_info',
                                //     arguments: widget.arguments);
                                Get.toNamed("/trailer-info",
                                    arguments: widget.arguments);
                              },
                              child: const Text("complete"))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isExpanded: _isExpanded,
          canTapOnHeader: true,
        ),
      ],
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          _isExpanded = !isExpanded;
        });
      },
      animationDuration: kThemeAnimationDuration,
    );
  }
}
