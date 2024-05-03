enum EnumTypeNotifyFlag {
  Offer(value: "0"),
  Interview(value: "1"),
  Submitted(value: "2"),
  Chat(value: "3");

  final String value;

  const EnumTypeNotifyFlag({required this.value});

  static EnumTypeNotifyFlag toStatusFlag(String id) {
    if (id == EnumTypeNotifyFlag.Offer.value) {
      return EnumTypeNotifyFlag.Offer;
    }

    if (id == EnumTypeNotifyFlag.Interview.value) {
      return EnumTypeNotifyFlag.Interview;
    }

    if (id == EnumTypeNotifyFlag.Submitted.value) {
      return EnumTypeNotifyFlag.Submitted;
    }

    if (id == EnumTypeNotifyFlag.Chat.value) {
      return EnumTypeNotifyFlag.Chat;
    }

    return EnumTypeNotifyFlag.Offer;
  }
}
