import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admu_student_app/constants/app_colors.dart';
import 'package:admu_student_app/constants/app_utils.dart';
import 'package:admu_student_app/models/class_schedule.dart';
import 'package:admu_student_app/models/subject.dart';
import 'package:admu_student_app/widgets/groups/input_group.dart';
import 'package:admu_student_app/widgets/groups/select_color.dart';
import 'package:admu_student_app/widgets/groups/select_days.dart';
import 'package:admu_student_app/widgets/groups/select_semester.dart';
import 'package:admu_student_app/widgets/groups/select_time.dart';
import 'package:admu_student_app/widgets/modals/alert.dart';
import 'package:admu_student_app/widgets/modals/custom_snack_bar.dart';
import 'package:admu_student_app/widgets/buttons.dart';

class AddClassPage extends StatefulWidget {
  final Subject subject;
  final bool inEnlistment;
  final bool isEditing;

  AddClassPage({
    this.inEnlistment = false,
    this.isEditing = false,
    this.subject,
  });

  @override
  _AddClassPageState createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  bool _shouldPop = false;

  TextEditingController _codeCtrl = TextEditingController();
  TextEditingController _sectionCtrl = TextEditingController();
  TextEditingController _yearCtrl = TextEditingController();
  TextEditingController _profCtrl = TextEditingController();

  int _semNum = 1;

  List<bool> _days = List.generate(6, (index) => false);
  TimeOfDay _timeStart;
  TimeOfDay _timeEnd;

  Color _color;

  @override
  void initState() {
    super.initState();

    if (widget.subject != null) {
      _codeCtrl.text = widget.subject.code;
      _sectionCtrl.text = widget.subject.section;
      _yearCtrl.text = '${widget.subject.yearNum}';
      _profCtrl.text = '${widget.subject.profName}';

      _semNum = widget.subject.semNum;

      _days = widget.subject.days;

      _timeStart = TimeOfDay(
        hour: widget.subject.start ~/ 100,
        minute: widget.subject.start % 100,
      );
      _timeEnd = TimeOfDay(
        hour: widget.subject.end ~/ 100,
        minute: widget.subject.end % 100,
      );

      _color = widget.subject.color;
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _sectionCtrl.dispose();
    _yearCtrl.dispose();
    _profCtrl.dispose();

    super.dispose();
  }

  void _onSemesterChange(int val) {
    setState(() {
      _semNum = val;
    });
  }

  void _onDaysChange(List<bool> sel) {
    setState(() {
      _days = sel;
    });
  }

  void _onStartTimeChange(TimeOfDay tod) {
    setState(() {
      _timeStart = tod;
    });
  }

  void _onEndTimeChange(TimeOfDay tod) {
    setState(() {
      _timeEnd = tod;
    });
  }

  void _onColorChange(Color c) {
    setState(() {
      _color = c;
    });
  }

  Future<bool> _onBack() async {
    if (_shouldPop) return true;

    bool willPop = false;

    await AlertModal.showAlert(
      context,
      header: 'Discard changes?',
      acceptText: 'Discard',
      onAccept: () {
        Navigator.of(context).pop();
        willPop = true;
      },
    );

    return willPop;
  }

  void _onSave() async {
    if (_yearCtrl.text.isEmpty)
      return await AlertModal.showIncompleteError(context);
    if (!AppUtils.isPositiveInteger(_yearCtrl.text))
      return await AlertModal.showDecimalOrNegativeError(context);
    int yearNum = int.parse(_yearCtrl.text);

    if (_codeCtrl.text.isEmpty ||
        _color == null ||
        _timeStart == null ||
        _timeEnd == null) return await AlertModal.showIncompleteError(context);

    if (widget.inEnlistment && _sectionCtrl.text.isEmpty)
      return await AlertModal.showIncompleteError(context);

    int counter = 0;
    for (bool b in _days) counter += b ? 1 : 0;
    if (counter == 0)
      return await AlertModal.showIncompleteError(context);

    if (!AppUtils.timeIsBefore(_timeStart, _timeEnd))
      return await AlertModal.showInverseTimeError(context);

    if (widget.isEditing) {
      Provider.of<ClassSchedule>(context, listen: false).editSubject(
        widget.subject,
        _codeCtrl.text,
        _sectionCtrl.text,
        yearNum,
        _semNum,
        _color,
        _days,
        _timeStart,
        _timeEnd,
        widget.inEnlistment, // in enlistment
        _profCtrl.text,
      );

      CustomSnackBar.showSnackBar(context, 'Class edited!');
    } else {
      Provider.of<ClassSchedule>(context, listen: false).addSubject(
        _codeCtrl.text,
        _sectionCtrl.text,
        yearNum,
        _semNum,
        _color,
        _days,
        _timeStart,
        _timeEnd,
        widget.inEnlistment, // in enlistment
        _profCtrl.text,
      );

      CustomSnackBar.showSnackBar(context, 'Class added!');
    }

    _shouldPop = true;
    Navigator.of(context).pop();
  }

  void _onDelete() async {
    await AlertModal.showAlert(
      context,
      header: 'Delete ${widget.subject.code}?',
      onAccept: () {
        Provider.of<ClassSchedule>(context, listen: false)
            .deleteSubject(widget.subject);

        CustomSnackBar.showSnackBar(context, 'Class deleted!');

        _shouldPop = true;
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Scaffold scaffold = Scaffold(
      backgroundColor: AppColors.PRIMARY_MAIN,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          onPressed: _onBack,
          iconSize: 32,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _onSave,
              child: Text(
                'Done',
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.GRAY_LIGHT[2],
                    ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
        child: Column(
          children: [
            // header
            Center(
              child: Text(
                '${widget.isEditing ? 'Edit' : 'Add'} Class',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Colors.white),
              ),
            ),
            SizedBox(height: 24),

            // course code and section
            Row(
              children: [
                // course code
                Expanded(
                  child: InputGroup(
                    'Course Code*',
                    _codeCtrl,
                    hint: 'COURSE101',
                  ),
                ),
                if (widget.inEnlistment) SizedBox(width: 20),

                // section
                if (widget.inEnlistment)
                  Expanded(
                    child: InputGroup(
                      'Section*',
                      _sectionCtrl,
                      hint: 'A',
                    ),
                  ),
              ],
            ),
            SizedBox(height: 24),

            // year level and sem
            Row(
              children: [
                // year
                Expanded(
                    child: InputGroup(
                  'Year Level*',
                  _yearCtrl,
                  length: 1,
                  hint: '1',
                )),
                SizedBox(width: 20),

                // sem
                Expanded(
                  child: SelectSemesterGroup(
                    label: 'Semester*',
                    selected: _semNum,
                    onValueChange: _onSemesterChange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // select color
            SelectColor(
              label: 'Color Code*',
              color: _color,
              onColorChange: _onColorChange,
            ),
            SizedBox(height: 24),

            // days
            SelectDaysGroup(
              label: 'Date*',
              selected: _days,
              onChange: _onDaysChange,
            ),
            SizedBox(height: 24),

            // start and end time
            Row(
              children: [
                // start
                Expanded(
                  child: SelectTimeGroup(
                    'Start*',
                    time: _timeStart,
                    onTimeChange: _onStartTimeChange,
                  ),
                ),
                SizedBox(width: 20),

                // end
                Expanded(
                  child: SelectTimeGroup(
                    'End*',
                    time: _timeEnd,
                    onTimeChange: _onEndTimeChange,
                  ),
                ),
              ],
            ),

            if (widget.inEnlistment) SizedBox(height: 24),
            // professor in enlistment
            if (widget.inEnlistment) InputGroup('Name of Professor', _profCtrl),

            SizedBox(height: 48),
            // delete button
            if (widget.isEditing)
              CustomButton(
                ButtonSize.medium,
                'Delete Class',
                AppColors.SECONDARY_MAIN,
                AppColors.GRAY_LIGHT[2],
                _onDelete,
              ),
          ],
        ),
      ),
    );

    return WillPopScope(
      onWillPop: _onBack,
      child: scaffold,
    );
  }
}
