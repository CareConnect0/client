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

class YearMonthGuardian {
  final int dependentId;
  final int year;
  final int month;

  YearMonthGuardian({
    required this.dependentId,
    required this.year,
    required this.month,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YearMonthGuardian &&
          runtimeType == other.runtimeType &&
          dependentId == other.dependentId &&
          year == other.year &&
          month == other.month;

  @override
  int get hashCode => dependentId.hashCode ^ year.hashCode ^ month.hashCode;
}
