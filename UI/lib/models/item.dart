class Item {
  final String image, name, artistName;
  var release;

  Item(
      {required this.image,
      required this.name,
      required this.artistName,
      this.release});
}
