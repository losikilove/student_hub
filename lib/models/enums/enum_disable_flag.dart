enum EnumDisableFlag {
  enable(value: 0),
  disable(value: 1);

  final int value;

  const EnumDisableFlag({required this.value});

  static EnumDisableFlag toDisableFlag(int disableFlag) {
    switch (disableFlag) {
      case 0:
        return EnumDisableFlag.enable;
      case 1:
        return EnumDisableFlag.disable;
    }

    return EnumDisableFlag.disable;
  }
}
