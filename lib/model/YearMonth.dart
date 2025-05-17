class YearMonth {
  final int year;
  final int month;

  YearMonth(this.year, this.month);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YearMonth &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month;

  @override
  int get hashCode => year.hashCode ^ month.hashCode;
}
