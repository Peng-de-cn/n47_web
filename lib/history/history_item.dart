class HistoryItem {
  final int id;
  final String title;
  final String date;
  final String description;
  final String image;
  final bool isHistory;

  HistoryItem(
      {required this.id,
      required this.title,
      required this.date,
      required this.description,
      required this.image,
      required this.isHistory});
}
