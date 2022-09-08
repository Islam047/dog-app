import 'package:flutter/foundation.dart';

class LogService {

  static const _borderStart = "┌──────────────────────────────────────────────────────────────────────";
  static const _borderFinish = "└──────────────────────────────────────────────────────────────────────";

  static const _info = '\x1B[48;5;2mℹ️message:  \x1B[0m';
  static const _debug = '\x1B[7m🐞️  message:  \x1B[0m';
  static const _error = '\x1B[41m⛔️message:  \x1B[0m';
  static const _warning = '\x1B[43m⚠️message:  \x1B[0m';
  static const _verbose = '\x1B[44m📜  message:  \x1B[0m';
  static const _wtf = '\x1B[45m❄️message:  \x1B[0m';
  static const _optional = '\x1B[46m🗺️  message:  \x1B[0m';

  static const _ansiInfoBegin = '\x1B[92m';
  static const _ansiDebugBegin = '\x1B[97m';
  static const _ansiErrorBegin = '\x1B[38;5;196m';
  static const _ansiWarningBegin = '\x1B[93m';
  static const _ansiVerboseBegin = '\x1B[94m';
  static const _ansiWtfBegin = '\x1B[95m';
  static const _ansiOptionalBegin = '\x1B[96m';

  static const _ansiEnd = '\x1B[0m';

  /// Log a message at level [info].
  static void i(String message) {
    if (kDebugMode) {
      print("$_ansiInfoBegin$_borderStart$_ansiEnd");
      print("$_info$_ansiInfoBegin\t$message$_ansiEnd");
      print("$_ansiInfoBegin$_borderFinish$_ansiEnd");
    }
  }

  /// Log a message at level [debug].
  static void d(String message) {
    if (kDebugMode) {
      print("$_ansiDebugBegin$_borderStart$_ansiEnd");
      print("$_debug$_ansiDebugBegin\t$message$_ansiEnd");
      print("$_ansiDebugBegin$_borderFinish$_ansiEnd");
    }
  }

  /// Log a message at level [error].
  static void e(String message) {
    if (kDebugMode) {
      print("$_ansiErrorBegin$_borderStart$_ansiEnd");
      print("$_error$_ansiErrorBegin\t$message$_ansiEnd");
      print("$_ansiErrorBegin$_borderFinish$_ansiEnd");
    }
  }

  /// Log a message at level [warning].
  static void w(String message) {
    if (kDebugMode) {
      print("$_ansiWarningBegin$_borderStart$_ansiEnd");
      print("$_warning$_ansiWarningBegin\t$message$_ansiEnd");
      print("$_ansiWarningBegin$_borderFinish$_ansiEnd");
    }
  }

  /// Log a message at level [verbose].
  static void v(String message) {
    if (kDebugMode) {
      print("$_ansiVerboseBegin$_borderStart$_ansiEnd");
      print("$_verbose$_ansiVerboseBegin\t$message$_ansiEnd");
      print("$_ansiVerboseBegin$_borderFinish$_ansiEnd");
    }
  }

  /// Log a message at level [optional].
  static void o(String message) {
    if (kDebugMode) {
      print("$_ansiOptionalBegin$_borderStart$_ansiEnd");
      print("$_optional$_ansiOptionalBegin\t$message$_ansiEnd");
      print("$_ansiOptionalBegin$_borderFinish$_ansiEnd");
    }
  }

  /// Log a message at level [wtf].
  static void wtf(String message) {
    if (kDebugMode) {
      print("$_ansiWtfBegin$_borderStart$_ansiEnd");
      print("$_wtf$_ansiWtfBegin\t$message$_ansiEnd");
      print("$_ansiWtfBegin$_borderFinish$_ansiEnd");
    }
  }
}