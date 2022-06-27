import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../all_students/students_screen.dart';
import '../../common/models/enum.dart';
import '../../common/models/exceptions.dart';
import '../../common/providers/theme_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/login-screen';

  void _proceedToNextScreen(BuildContext context, LoginType loginType) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);

    switch (loginType) {
      case LoginType.student:
        theme.changeTheme(LoginType.student);
        Navigator.of(context).pushReplacementNamed(StudentsScreen.routeName);
        break;
      case LoginType.teacher:
        theme.changeTheme(LoginType.teacher);
        Navigator.of(context).pushReplacementNamed(StudentsScreen.routeName);
        break;
      default:
        throw const NotImplemented('This theme is not implemented yet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Se connecter en tant que...'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      _proceedToNextScreen(context, LoginType.student),
                  style: ElevatedButton.styleFrom(
                      primary: studentTheme().colorScheme.primary),
                  child: const Text('Élève'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: teacherTheme().colorScheme.primary),
                  onPressed: () =>
                      _proceedToNextScreen(context, LoginType.teacher),
                  child: const Text('Enseignant'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
