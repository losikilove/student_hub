enum EnumNumberPeople {
  one(value: 0, name: 'It\'s just me'),
  two_to_nine(value: 1, name: '2-9 employees'),
  ten_to_nightynine(value: 2, name: '10-99 employees'),
  hundred_to_thousand(value: 3, name: '100-1000 employees'),
  more_than_thousand(value: 4, name: 'More than 1000 employees');

  final int value;
  final String name;

  const EnumNumberPeople({required this.value, required this.name});

  static EnumNumberPeople toNumberPeople(int inputValue) {
    switch (inputValue) {
      case 0:
        return EnumNumberPeople.one;
      case 1:
        return EnumNumberPeople.two_to_nine;
      case 2:
        return EnumNumberPeople.ten_to_nightynine;
      case 3:
        return EnumNumberPeople.hundred_to_thousand;
      case 4:
        return EnumNumberPeople.more_than_thousand;
      default:
        // something went wrong
        return EnumNumberPeople.one;
    }
  }
}
