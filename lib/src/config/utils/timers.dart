Future wait(
  int duration, {
  bool milisec = false,
  bool sec = false,
}) async {
  inSec(int secs) {
    return Duration(seconds: duration);
  }

  inMilisec(int milisecs) {
    return Duration(milliseconds: duration);
  }

  Future.delayed(milisec
      ? inMilisec(duration)
      : sec
          ? inSec(duration)
          : inSec(duration));
}
