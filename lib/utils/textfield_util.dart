class TextfieldUtil {
  static const String regexEmail = '^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$';
  static const String regexPassword =
      '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%^&*])[a-zA-Z0-9!@#\$%^&*]{8,20}\$';
}
