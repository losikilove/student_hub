enum EnumTypeFlag {
  working(value: 0),
  archive(value: 1);

  final int value;

  const EnumTypeFlag({required this.value});

  static EnumTypeFlag toTypeFlag(int id) {
    if (id == EnumTypeFlag.working.value) {
      return EnumTypeFlag.working;
    }

    if (id == EnumTypeFlag.archive.value) {
      return EnumTypeFlag.archive;
    }

    return EnumTypeFlag.working;
  }
}
