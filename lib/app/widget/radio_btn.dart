import 'package:flutter/material.dart';
import '../color/colors.dart';

class CustomRadioGroup extends StatefulWidget {
  final List<String> labels;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final double buttonWidth;
  final double buttonHeight;

  const CustomRadioGroup({
    Key? key,
    required this.labels,
    required this.initialValue,
    required this.onChanged,
    this.buttonWidth = 100.0,
    this.buttonHeight = 40.0,
  }) : super(key: key);

  @override
  _CustomRadioGroupState createState() => _CustomRadioGroupState();
}

class _CustomRadioGroupState extends State<CustomRadioGroup> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widget.labels.map((label) {
        int index = widget.labels.indexOf(label);
        return CustomRadioButton(
          label: label,
          value: label,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
            widget.onChanged(value);
          },
          width: widget.buttonWidth,
          height: widget.buttonHeight,
          isFirst: index == 0,
          isLast: index == widget.labels.length - 1,
        );
      }).toList(),
    );
  }
}

class CustomRadioButton extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final double width;
  final double height;
  final bool isFirst;
  final bool isLast;

  const CustomRadioButton({
    Key? key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.width = 100.0,
    this.height = 40.0,
    this.isFirst = false,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          onChanged(value);
        }
      },
      child: Container(
        // width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 30),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.logoBgc : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.logoBgc : Colors.grey,
          ),
          borderRadius: BorderRadius.horizontal(
            left: isFirst ? Radius.circular(4.0) : Radius.zero,
            right: isLast ? Radius.circular(4.0) : Radius.zero,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
