class TypeException implements Exception {
  TypeException(this.message);

  final String message;
}

enum Target {
  none,
  individual,
  all,
}

enum ActionRequired {
  none,
  fromStudent,
  fromTeacher,
}

enum UserType {
  none,
  teacher,
  student,
}

enum SectionNavigation {
  showStudent,
  modifyOneStudent,
  modifyAllStudents,
}
