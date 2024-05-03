enum EnumNotifyFlag {
  Unread(value: "0"),
  Read(value: "1");
  


  final String value;

  const EnumNotifyFlag({required this.value});

  static EnumNotifyFlag toStatusFlag(String id) {
    if (id == EnumNotifyFlag.Unread.value) {
      return EnumNotifyFlag.toStatusFlag(id);
    }

    if (id == EnumNotifyFlag.Read.value) {
      return EnumNotifyFlag.Read;
    }
    return EnumNotifyFlag.toStatusFlag(id);
  }
}
