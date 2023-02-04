class Item {
  final String image, trackName, albumName, artistName, url;
  int duration, trackId;

  Item({
    required this.trackId,
    required this.image,
    required this.trackName,
    required this.albumName,
    required this.artistName,
    required this.duration,
    required this.url,
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

class searchItem {
  final String trackName, artistName;
  final int trackId;
  searchItem({
    required this.trackId,
    required this.trackName,
    required this.artistName,
  });
}
