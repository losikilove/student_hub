class TextFormUtil {
  static bool isBlank(String string) {
    return string.trim().isEmpty;
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,20}$')
        .hasMatch(password);
  }
}
