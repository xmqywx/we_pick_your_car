import 'dart:async';

Function myDebounce(Function function, Duration delay) {
  Timer? timer;

  return () {
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(delay, () {
      function();
    });
  };
}
