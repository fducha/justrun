String timeToString(int time) {
  int mins = time ~/ 60;
  String minStr = mins > 9 ? '$mins' : '0$mins';
  int secs = time - (mins * 60);
  String secStr = secs > 9 ? '$secs' : '0$secs';
  return minStr + ':' + secStr + ' min';
}