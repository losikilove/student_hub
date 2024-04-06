enum EnumUser {
  student(value: 0),
  company(value: 1);

  final int value;

  const EnumUser({required this.value});

  static EnumUser toRole(int id) {
    if (id == EnumUser.student.value) {
      return EnumUser.student;
    }

    if (id == EnumUser.company.value) {
      return EnumUser.company;
    }

    return EnumUser.company;
  }
}
