class EducationUtil {
  static const determinedYear = 1910;

  static int numberOfYears() {
    return DateTime.now().year - determinedYear;
  }
}
