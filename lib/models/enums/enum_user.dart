enum EnumUser {
  student,
  company;

  static EnumUser toRole(int id) {
    if (id == EnumUser.student.index) {
      return EnumUser.student;
    }

    if (id == EnumUser.company.index) {
      return EnumUser.company;
    }

    return EnumUser.company;
  }
}
