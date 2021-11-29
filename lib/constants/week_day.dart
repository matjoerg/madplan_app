class Weekday {
  static const String monday = "Mandag";
  static const String tuesday = "Tirsdag";
  static const String wednesday = "Onsdag";
  static const String thursday = "Torsdag";
  static const String friday = "Fredag";
  static const String saturday = "Lørdag";
  static const String sunday = "Søndag";

  static String today = dateTimeDayToString(DateTime.now().day);
}

String dateTimeDayToString(int day) {
  switch (day) {
    case DateTime.monday:
      return Weekday.monday;
    case DateTime.tuesday:
      return Weekday.tuesday;
    case DateTime.wednesday:
      return Weekday.wednesday;
    case DateTime.thursday:
      return Weekday.thursday;
    case DateTime.friday:
      return Weekday.friday;
    case DateTime.saturday:
      return Weekday.saturday;
    case DateTime.sunday:
      return Weekday.sunday;
    default:
      return "";
  }
}
