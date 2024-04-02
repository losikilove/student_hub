enum EnumNumberPeople {
  one(value: 0),
  two_to_nine(value: 1),
  ten_to_nightynine(value: 2),
  hundred_to_thousand(value: 3),
  more_than_thousand(value: 4);

  final int value;

  const EnumNumberPeople({required this.value});
}
