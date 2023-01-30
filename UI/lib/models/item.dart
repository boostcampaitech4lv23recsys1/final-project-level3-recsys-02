class Item {
  final String image, name, albumName, artistName;
  int duration;

  Item({
    required this.image,
    required this.name,
    required this.albumName,
    required this.artistName,
    required this.duration,
  });
}

String duration2String(duration) {
  var seconds = (duration / 1000) % 60;
  var minutes = ((duration / (1000 * 60)) % 60) * 10;

  return '$minutes:$seconds';
}