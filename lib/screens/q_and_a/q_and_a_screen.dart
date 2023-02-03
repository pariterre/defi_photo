import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/common/models/database.dart';
import '/common/models/enum.dart';
import '/common/models/section.dart';
import '/common/models/student.dart';
import '/common/providers/all_students.dart';
import '/common/widgets/main_drawer.dart';
import '/screens/all_students/students_screen.dart';
import 'main_metier_page.dart';
import 'question_and_answer_page.dart';
import 'widgets/metier_app_bar.dart';

class QAndAScreen extends StatefulWidget {
  const QAndAScreen({super.key});

  static const routeName = '/q-and-a-screen';

  @override
  State<QAndAScreen> createState() => _QAndAScreenState();
}

class _QAndAScreenState extends State<QAndAScreen> {
  UserType _userType = UserType.none;
  Student? _student;
  SectionNavigation _sectionNavigation = SectionNavigation.showStudent;

  final _pageController = PageController();
  var _currentPage = 0;
  VoidCallback? _switchQuestionModeCallback;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentUser =
        Provider.of<Database>(context, listen: false).currentUser!;
    _userType = currentUser.userType;
    if (_userType == UserType.student) {
      final allStudents = Provider.of<AllStudents>(context, listen: true);
      _student = allStudents.fromId(currentUser.studentId!);
    } else {
      _student = ModalRoute.of(context)!.settings.arguments as Student?;
    }

    _sectionNavigation = _userType == UserType.teacher && _student == null
        ? SectionNavigation.modifyAllStudents
        : SectionNavigation.showStudent;
  }

  void onPageChanged(BuildContext context, int page) {
    _currentPage = page;
    _switchQuestionModeCallback = _userType == UserType.student ||
            _sectionNavigation == SectionNavigation.modifyAllStudents ||
            page < 1
        ? null
        : () => _switchToQuestionManagerMode(context);
    setState(() {});
  }

  void onPageChangedRequest(int page) {
    _pageController.animateToPage(page + 1,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _onBackPressed() {
    if (_currentPage == 0) {
      // Replacement is used to force the redraw of the Notifier.
      // If the redrawing is ever fixed, this can be replaced by a pop.
      Navigator.of(context).pushReplacementNamed(StudentsScreen.routeName);
    }
    onPageChangedRequest(-1);
  }

  void _switchToQuestionManagerMode(BuildContext context) {
    if (_userType == UserType.student ||
        _sectionNavigation == SectionNavigation.modifyAllStudents) return;

    _sectionNavigation = _sectionNavigation == SectionNavigation.showStudent
        ? SectionNavigation.modifyOneStudent
        : SectionNavigation.showStudent;
    setState(() {});
  }

  AppBar _setAppBar(UserType loginType, Student? student) {
    final currentTheme = Theme.of(context).textTheme.titleLarge!;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(student != null ? student.toString() : 'Gestion des questions'),
          if (loginType == UserType.student)
            Text(
                _currentPage == 0
                    ? "Mon défi photo"
                    : Section.name(_currentPage - 1),
                style:
                    currentTheme.copyWith(fontSize: 15, color: onPrimaryColor)),
          if (loginType == UserType.teacher && student != null)
            Text(
              student.company.name,
              style: currentTheme.copyWith(fontSize: 15, color: onPrimaryColor),
            ),
        ],
      ),
      leading: (_student == null || loginType == UserType.student) &&
              _currentPage == 0
          ? null
          : BackButton(onPressed: _onBackPressed),
      actions: _switchQuestionModeCallback != null
          ? [
              IconButton(
                onPressed: _switchQuestionModeCallback,
                icon: Icon(_sectionNavigation != SectionNavigation.showStudent
                    ? Icons.save
                    : Icons.edit_rounded),
                iconSize: 30,
              ),
              const SizedBox(width: 15),
            ]
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _setAppBar(_userType, _student),
      body: Column(
        children: [
          MetierAppBar(
            selected: _currentPage - 1,
            onPageChanged: onPageChangedRequest,
            studentId: _student?.id,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (value) => onPageChanged(context, value),
              children: [
                MainMetierPage(
                    student: _student, onPageChanged: onPageChangedRequest),
                QuestionAndAnswerPage(0,
                    studentId: _student?.id,
                    sectionNavigation: _sectionNavigation),
                QuestionAndAnswerPage(1,
                    studentId: _student?.id,
                    sectionNavigation: _sectionNavigation),
                QuestionAndAnswerPage(2,
                    studentId: _student?.id,
                    sectionNavigation: _sectionNavigation),
                QuestionAndAnswerPage(3,
                    studentId: _student?.id,
                    sectionNavigation: _sectionNavigation),
                QuestionAndAnswerPage(4,
                    studentId: _student?.id,
                    sectionNavigation: _sectionNavigation),
                QuestionAndAnswerPage(5,
                    studentId: _student?.id,
                    sectionNavigation: _sectionNavigation),
              ],
            ),
          ),
        ],
      ),
      drawer: _student == null || _userType == UserType.student
          ? MainDrawer(student: _student)
          : null,
    );
  }
}
