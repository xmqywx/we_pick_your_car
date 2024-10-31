import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dismantlers_stats_controller.dart';

class DismantlersStatsView extends GetView<DismantlersStatsController> {
  const DismantlersStatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stats = controller.carCount.value;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dismantlers Stats'),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: controller.handleRefresh,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              children: [
                _buildStatSection(
                  title: "For Recycling Cars",
                  data: stats.forRecyclingCars,
                ),
                _buildStatSection(
                  title: "For Parts Cars",
                  data: stats.forPartsCars,
                ),
                _buildStatSection(
                  title: "All Cars",
                  data: stats.allCars,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildStatSection({
    required String title,
    required dynamic data,
  }) {
    if (data == null) return SizedBox.shrink();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8),
            _buildStatRow("Total Cars", data.total, Icons.directions_car),
            _buildStatRow("Disassembled", data.disassembled, Icons.build),
            _buildStatRow("Total Parts", data.parts?.total, Icons.settings),
            _buildStatRow("Dismentaled Parts", data.parts?.dismentaled,
                Icons.settings_backup_restore),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, dynamic value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value == null ? '----' : '$value',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
