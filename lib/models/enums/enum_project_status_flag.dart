enum EnumProjectStatusFlag {
  working(value: 0),
  success(value: 1),
  fail(value: 3);

  final int value;

  const EnumProjectStatusFlag({required this.value});

  static EnumProjectStatusFlag toLike(int id) {
    if (id == EnumProjectStatusFlag.success.value) {
      return EnumProjectStatusFlag.success;
    }

    if (id == EnumProjectStatusFlag.fail.value) {
      return EnumProjectStatusFlag.fail;
    }

    return EnumProjectStatusFlag.working;
  }
}
