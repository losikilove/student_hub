enum EnumProjectLenght {
  less_than_one_month(value: 0, name: 'Less than one month'),
  one_to_three_month(value: 1, name: '1 - 3 months'),
  three_to_six_month(value: 2, name: '3 - 6 months'),
  more_than_six_month(value: 3, name: 'More than 6 months');

  final int value;
  final String name;
  const EnumProjectLenght({required this.value, required this.name});

  static EnumProjectLenght toProjectLenght(int inputValue) {
    switch (inputValue) {
      case 0:
        return EnumProjectLenght.less_than_one_month;
      case 1:
        return EnumProjectLenght.one_to_three_month;
      case 2:
        return EnumProjectLenght.three_to_six_month;
      case 3:
        return EnumProjectLenght.more_than_six_month;
      default:
        // something went wrong
        return EnumProjectLenght.less_than_one_month;
    }
  }
}
