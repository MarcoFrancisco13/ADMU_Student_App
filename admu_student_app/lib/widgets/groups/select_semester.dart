import 'package:flutter/material.dart';

import 'package:admu_student_app/constants/app_colors.dart';
import 'package:admu_student_app/widgets/buttons.dart';

class SelectSemesterGroup extends StatefulWidget {
  final String label;
  final int selected;
  final Function(int) onValueChange;

  SelectSemesterGroup({
    this.label = 'Semester',
    this.selected,
    this.onValueChange,
  });

  @override
  _SelectSemesterGroupState createState() => _SelectSemesterGroupState();
}

class _SelectSemesterGroupState extends State<SelectSemesterGroup> {
  int _selected = 1;

  @override
  void initState() {
    super.initState();

    if (widget.selected != null) _selected = widget.selected;
  }

  void _onSemSelect(int val) {
    setState(() {
      _selected = val;

      if (widget.onValueChange != null) widget.onValueChange(_selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool shouldShrink =
        ((MediaQuery.of(context).size.width - 16 * 2 - 20) / 2) <
            (56 * 3 + 4 * 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label
        Text(
          widget.label,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: AppColors.GRAY_LIGHT[2]),
        ),
        SizedBox(height: 8),

        // buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShrinkingButton(
              selected: _selected == 0 ? true : false,
              text: 'IS',
              onPressed: () => _onSemSelect(0),
              shrink: shouldShrink,
            ),
            SizedBox(width: 4),
            ShrinkingButton(
              selected: _selected == 1 ? true : false,
              text: '1',
              onPressed: () => _onSemSelect(1),
              shrink: shouldShrink,
            ),
            SizedBox(width: 4),
            ShrinkingButton(
              selected: _selected == 2 ? true : false,
              text: '2',
              onPressed: () => _onSemSelect(2),
              shrink: shouldShrink,
            ),
          ],
        ),
      ],
    );
  }
}
