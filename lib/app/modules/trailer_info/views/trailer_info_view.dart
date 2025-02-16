// import 'package:flutter/material.dart';

// import 'package:get/get.dart';

// import '../controllers/trailer_info_controller.dart';

// class TrailerInfoView extends GetView<TrailerInfoController> {
//   const TrailerInfoView({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('TrailerInfoView'),
//         centerTitle: true,
//       ),
//       body: const Center(
//         child: Text(
//           'TrailerInfoView is working',
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class TrailerInfoView extends StatefulWidget {
  final Map arguments;
  const TrailerInfoView({super.key, required this.arguments});

  @override
  State<TrailerInfoView> createState() => _TrailerInfoViewState();
}

class _TrailerInfoViewState extends State<TrailerInfoView> {
  String model_number = "";
  String car_color = "";
  final List _imageFileDir = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListView(
          children: [
            // DetailTemplete(
            //   customer_name: "${widget.arguments['customer_name']}",
            //   customer_phone_number:
            //       "${widget.arguments['customer_phone_number']}",
            //   time_of_appointment: "${widget.arguments['time_of_appointment']}",
            //   start_postion: "${widget.arguments['start_position']}",
            //   end_position: "${widget.arguments['end_position']}",
            //   cost: "${widget.arguments['cost']}",
            //   status: "${widget.arguments['status']}",
            //   whether_to_pay: "${widget.arguments['whether_to_pay']}",
            //   arguments: widget.arguments,
            // ),
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
                      Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Enter vehicle information",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )),
                      const Divider(),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 40,
                        child: TextField(
                          decoration: const InputDecoration(
                            label: Text("Model number"),
                            hintText: "Model number",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => setState(() {
                            model_number = value;
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        height: 40,
                        child: TextField(
                          decoration: const InputDecoration(
                            label: Text("Color"),
                            hintText: "Color",
                            border: OutlineInputBorder(),
                            // suffixIcon: Icon(Icons.visibility)
                          ),
                          onChanged: (value) {
                            car_color = value;
                          },
                        ),
                      )
                    ],
                  ),
                )),
            const SizedBox(height: 10),
            // ImagePickerWidget(
            //   onImagesChanged: (List XFiles) {
            //     setState(() {
            //       _imageFileDir = XFiles;
            //     });
            //   },
            // ),
            const SizedBox(height: 10),
            _imageFileDir.isEmpty
                ? const Text("")
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed("/generate-signature");
                                },
                                child: const Text("Next")),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Back"))
                          ],
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
