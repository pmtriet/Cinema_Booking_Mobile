class DateItem {
  final int id;
  final String shortDay;
  final String displayDate;
  final String fullDay;
  bool isSelected;

  DateItem(
      {required this.id,
      required this.shortDay,
      required this.displayDate,
      required this.fullDay,
      required this.isSelected});
}
