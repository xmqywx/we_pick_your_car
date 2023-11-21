import '../color/colors.dart';

Map<int, Map<String, dynamic>> containerStatus = {
  0: {
    "label": 'Not Started',
    "color": AppColors.accentColor,
    "fields": [
      {"label": "Container No.", "prop": "containerNumber"},
      {"label": "Commence date", "prop": "startDeliverTime"},
    ],
    "op": ['edit', 'delete', 'add']
  },
  1: {
    "label": 'Loading',
    "color": AppColors.darkGreenColor,
    "fields": [
      {"label": "Container No.", "prop": "containerNumber"},
      {"label": "Commence date", "prop": "startDeliverTime"},
    ],
    "op": ['edit', 'add']
  },
  2: {
    "label": 'Sealed',
    "color": AppColors.darkGreyColor,
    "fields": [
      {"label": "Container No.", "prop": "containerNumber"},
      {"label": "Commence date", "prop": "startDeliverTime"},
      {"label": "Seal Number", "prop": "sealNumber"},
      {"label": "Seal Date", "prop": "sealDate"},
    ],
    "op": []
  }
};
List<Map<String, dynamic>> containerStatusItem = [
  {"label": 'Not Started', "value": 0},
  {"label": 'Loading', "value": 1},
  {"label": 'Sealed', "value": 2},
];
