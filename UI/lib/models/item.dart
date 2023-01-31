class Item {
  final String image, trackName, albumName, artistName;
  int duration;

  Item({
    required this.image,
    required this.trackName,
    required this.albumName,
    required this.artistName,
    required this.duration,
  });
}

String duration2String(duration) {
  var mm = Duration(milliseconds: duration).inMinutes;
  var ss = Duration(milliseconds: duration).inSeconds - mm * 60;
  var time = '$mm:';
  if (ss < 10) {
    time += '0$ss';
  } else {
    time += '$ss';
  }
  return time;
}
