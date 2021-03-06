import 'package:flutter/material.dart';

import 'package:admu_student_app/constants/app_colors.dart';
import 'package:admu_student_app/models/ls_directory.dart';
import 'package:admu_student_app/models/user_cache.dart';
import 'package:admu_student_app/widgets/drawer/office_drop_down.dart';
import 'package:admu_student_app/widgets/help_button.dart';
import 'package:admu_student_app/widgets/modals/help.dart';
import 'package:admu_student_app/widgets/custom_drop_down.dart';

class DirectoryPage extends StatefulWidget {
  @override
  _DirectoryPageState createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  bool _isSearching = false;

  TextEditingController _searchCtrl = TextEditingController();

  int _selected = -1;

  @override
  void initState() {
    super.initState();

    if (UserCache.lsDirectory) {
      UserCache.lsDirectory = false;
      UserCache.save();

      WidgetsBinding.instance.addPostFrameCallback((_) => _showHowTo());
    }

    _searchCtrl.addListener(_updateList);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();

    super.dispose();
  }

  void _showHowTo() async {
    await HelpModal.showHelp(
      context,
      title: 'LS Directory',
      strings: [
        'Pick the school or office the department belongs to.',
        'Find the department based on the schedules displayed.',
        'If what you\'re looking for is unavailable, you can check their own websites and pages.',
      ],
    );
  }

  void _updateList() {
    setState(() {
      if (_searchCtrl.text.isNotEmpty)
        _isSearching = true;
      else
        _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data =
        LSDirectory.getFiltered(_searchCtrl.text, _isSearching);

    if (_selected > data.length) _selected = -1;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
          iconSize: 32,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 40, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // header
                Expanded(
                  child: Text('LS Directory',
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: AppColors.GRAY_DARK[0])),
                ),

                // help button
                HelpButton(onTap: _showHowTo),
              ],
            ),
            SizedBox(height: 24),

            // search bar
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.GRAY_LIGHT[1],
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    height: 48, // ?
                    child: Center(
                      child: TextField(
                        controller: _searchCtrl,
                        keyboardType: TextInputType.multiline,
                        onTap: () {
                          setState(() {
                            if (!_isSearching) _selected = -1;
                            _isSearching = true;
                          });
                        },
                        decoration: InputDecoration(
                          // prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          hintText: 'Search',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: AppColors.GRAY_DARK[2]),
                          counterText:
                              "", // Disables maxLength showing in Field
                        ),
                      ),
                    ),
                  ),
                ),

                // cancel text
                _isSearching ? SizedBox(width: 16) : Container(),
                _isSearching
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            _isSearching = false;
                            _selected = -1;
                            _searchCtrl.text = '';
                          });
                        },
                        child: Text(
                          'Cancel',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.PRIMARY_MAIN,
                              ),
                        ),
                      )
                    : Container(),
                _isSearching ? SizedBox(width: 5) : Container(),
              ],
            ),
            SizedBox(height: 16),

            // dropdown of groups
            if (!_isSearching)
              OfficeDropDown(
                data,
                (i) {
                  setState(() {
                    _selected = i;
                  });
                },
              ),

            if (_isSearching)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (_, index) {
                  List<Widget> emails = [];

                  for (String e in data[index]['emails'].cast<String>())
                    emails.add(
                      Text(
                        'Email: $e',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: AppColors.GRAY_DARK[0]),
                      ),
                    );

                  return Container(
                    margin: EdgeInsets.only(top: 24),
                    child: CustomDropDown(
                      title: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text('${data[index]['name']}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: AppColors.GRAY_DARK[0])),
                      ),
                      childrenPadding: EdgeInsets.fromLTRB(32, 16, 16, 16),
                      expandedAlignment: Alignment.centerLeft,
                      children: emails,
                    ),
                  );
                },
              ),

            // offices
            _selected != -1
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data[_selected]['offices'].length,
                    itemBuilder: (_, index) {
                      List<Widget> emails = [];

                      Map<String, dynamic> officeData = data[_selected]
                              ['offices'][index]
                          .cast<String, dynamic>();
                      List<String> rawEmails =
                          officeData['emails'].cast<String>();

                      for (String e in rawEmails)
                        emails.add(
                          Text(
                            'Email: $e',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: AppColors.GRAY_DARK[0]),
                          ),
                        );

                      return Container(
                        margin: EdgeInsets.only(top: 24),
                        child: CustomDropDown(
                          title: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text('${officeData['name']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: AppColors.GRAY_DARK[0])),
                          ),
                          childrenPadding: EdgeInsets.fromLTRB(32, 16, 16, 16),
                          expandedAlignment: Alignment.centerLeft,
                          children: emails,
                        ),
                      );
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
