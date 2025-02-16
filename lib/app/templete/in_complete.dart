import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InComplete extends StatefulWidget {
  final String time;
  final String start_position;
  final String end_position;
  final String status;
  final String cost;
  final Map<String, String> detail_info;
  const InComplete(
      {super.key,
      this.time = "-",
      this.end_position = "-",
      this.start_position = "-",
      this.cost = "-",
      this.status = "-",
      required this.detail_info});

  @override
  State<InComplete> createState() => _InCompleteState();
}

class _InCompleteState extends State<InComplete> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 5, 16, 15),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "Pickup address : ${widget.end_position}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              SizedBox(
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: const Text(
                        "Time",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.time,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: const Text(
                        "Start position",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.start_position,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        "End position",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.end_position,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        "Status",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.status,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        "Cost",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.cost,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              // Navigator.pushNamed(context, '/pretreatment_detail',
                              //     arguments: widget.detail_info
                              // );
                              Get.toNamed("/pretreatment-detail",
                                  arguments: widget.detail_info);
                            },
                            child: const Text("View detail"))),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
