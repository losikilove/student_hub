enum EnumTypeFlag {
  newproject(value: 0),
  working(value: 1),
  archive(value: 2);

  final int value;

  const EnumTypeFlag({required this.value});

  static EnumTypeFlag toTypeFlag(int id) {
    if (id == EnumTypeFlag.newproject.value) {
      return EnumTypeFlag.newproject;
    }
    if (id == EnumTypeFlag.working.value) {
      return EnumTypeFlag.working;
    }

    if (id == EnumTypeFlag.archive.value) {
      return EnumTypeFlag.archive;
    }

    return EnumTypeFlag.working;
  }
}
