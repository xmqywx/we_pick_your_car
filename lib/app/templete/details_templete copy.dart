import 'package:flutter/material.dart';
import '../services/format_date.dart';
import '../services/handle_status.dart';

class DetailTemplete extends StatefulWidget {
  final String customer_name;
  final String customer_phone_number;
  final String time_of_appointment;
  final String start_postion;
  final String end_position;
  final String cost;
  final String status;
  final String whether_to_pay;
  const DetailTemplete({
    super.key,
    required this.customer_name,
    required this.customer_phone_number,
    required this.time_of_appointment,
    required this.start_postion,
    required this.end_position,
    required this.cost,
    required this.status,
    required this.whether_to_pay,
  });

  @override
  State<DetailTemplete> createState() => _DetailTempleteState();
}

class _DetailTempleteState extends State<DetailTemplete> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Customer information",
                  style: TextStyle(
                      fontSize: 18, height: 2, fontWeight: FontWeight.w500),
                ),
                const Divider(
                  color: Colors.deepOrange,
                ),
                FilesMap(
                    attribute: "Customer name", value: widget.customer_name),
                FilesMap(
                    attribute: "Customer phone number",
                    value: widget.customer_phone_number),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order information",
                    style: TextStyle(
                        fontSize: 18, height: 2, fontWeight: FontWeight.w500),
                  ),
                  const Divider(
                    color: Colors.deepOrange,
                  ),
                  FilesMap(
                      attribute: "Time of appointment",
                      value:
                          handleFormatDateDDMMYYYY(widget.time_of_appointment)),
                  FilesMap(
                      attribute: "Pickup address", value: widget.start_postion),
                  FilesMap(attribute: "Cost", value: widget.cost),
                ],
              ),
            )),
        SizedBox(
          height: 10,
        ),
        Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order status",
                    style: TextStyle(
                        fontSize: 18, height: 2, fontWeight: FontWeight.w500),
                  ),
                  const Divider(
                    color: Colors.deepOrange,
                  ),
                  FilesMap(
                    attribute: "Status",
                    value: widget.status,
                  ),
                  FilesMap(
                      attribute: "Whether to pay",
                      value: widget.whether_to_pay),
                ],
              ),
            )),
      ],
    );
  }
}

class FilesMap extends StatefulWidget {
  final String attribute;
  final String value;
  const FilesMap({Key? key, required this.attribute, required this.value})
      : super(key: key);

  @override
  State<FilesMap> createState() => _FilesMapState();
}

class _FilesMapState extends State<FilesMap> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              widget.attribute,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Flexible(
            child: Text(
              widget.value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.blueGrey),
            ),
          ),
        ],
      ),
    );
  }
}
