//StatusFlag 	Waitting = 0,
//	Offer = 1,
//	Hired = 2,
enum EnumStatusFlag {
  waitting(value: 0),
  active(value: 1),
  offer(value: 2),
  hired(value: 3);

  final int value;

  const EnumStatusFlag({required this.value});

  static EnumStatusFlag toStatusFlag(int id) {
    if (id == EnumStatusFlag.waitting.value) {
      return EnumStatusFlag.waitting;
    }

    if (id == EnumStatusFlag.active.value) {
      return EnumStatusFlag.active;
    }

    if (id == EnumStatusFlag.offer.value) {
      return EnumStatusFlag.offer;
    }

    if (id == EnumStatusFlag.hired.value) {
      return EnumStatusFlag.hired;
    }

    return EnumStatusFlag.waitting;
  }
}
