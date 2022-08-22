import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Formatter {
  static String formatChatId(String researcherId, String participantId) =>
      "$researcherId+$participantId";

  static String formatTimeId() =>
      Timestamp.now().millisecondsSinceEpoch.toString();

  static String formatResearchId(String researcherId) =>
      researcherId + Timestamp.now().millisecondsSinceEpoch.toString();

  static String formatGroupId({required String title, required int number}) =>
      "Group $number - $title - ${formatTimeId()}";

  static String? parseDateNoTime(String? dateTime) {
    if (dateTime == null) {
      return null;
    } else if (dateTime.contains('Date')) {
      return dateTime.tr;
    }

    DateTime? date = DateTime.tryParse(dateTime);

    String month = '';
    String day = '';

    switch (date?.month) {
      case 1:
        month = 'Jan'.tr;
        break;
      case 2:
        month = 'Feb'.tr;
        break;
      case 3:
        month = 'Mar'.tr;
        break;
      case 4:
        month = 'Apr'.tr;
        break;
      case 5:
        month = 'May'.tr;
        break;
      case 6:
        month = 'Jun'.tr;
        break;
      case 7:
        month = 'Jul'.tr;
        break;
      case 8:
        month = 'Aug'.tr;
        break;
      case 9:
        month = 'Sep'.tr;
        break;
      case 10:
        month = 'Oct'.tr;
        break;
      case 11:
        month = 'Nov'.tr;
        break;
      case 12:
        month = 'Dec'.tr;
        break;
    }
    switch (date?.weekday) {
      case 1:
        day = 'Mon'.tr;
        break;
      case 2:
        day = 'Tue'.tr;
        break;
      case 3:
        day = 'Wed'.tr;
        break;
      case 4:
        day = 'Thu'.tr;
        break;
      case 5:
        day = 'Fri'.tr;
        break;
      case 6:
        day = 'Sat'.tr;
        break;
      case 7:
        day = 'Sun'.tr;
        break;
    }

    return '$day, $month ${date?.day}';

    return null;
  }

  static String parseDate(String dateTime) {
    if (dateTime.contains('Date')) return dateTime;

    DateTime? date = DateTime.tryParse(dateTime);

    String month = '';
    String day = '';
    String time = '${date?.hour}:${date?.minute}';

    if (date!.minute < 10) {
      time = time.substring(0, time.length - 1) + "0${date.minute}";
    }

    switch (date.month) {
      case 1:
        month = 'Jan'.tr;
        break;
      case 2:
        month = 'Feb'.tr;
        break;
      case 3:
        month = 'Mar'.tr;
        break;
      case 4:
        month = 'Apr'.tr;
        break;
      case 5:
        month = 'May'.tr;
        break;
      case 6:
        month = 'Jun'.tr;
        break;
      case 7:
        month = 'Jul'.tr;
        break;
      case 8:
        month = 'Aug'.tr;
        break;
      case 9:
        month = 'Sep'.tr;
        break;
      case 10:
        month = 'Oct'.tr;
        break;
      case 11:
        month = 'Nov'.tr;
        break;
      case 12:
        month = 'Dec'.tr;
        break;
    }
    switch (date.weekday) {
      case 1:
        day = 'Mon'.tr;
        break;
      case 2:
        day = 'Tue'.tr;
        break;
      case 3:
        day = 'Wed'.tr;
        break;
      case 4:
        day = 'Thu'.tr;
        break;
      case 5:
        day = 'Fri'.tr;
        break;
      case 6:
        day = 'Sat'.tr;
        break;
      case 7:
        day = 'Sun'.tr;
        break;
    }
    String prefix = 'th';
    prefix = date.day == 1
        ? 'st'
        : date.day == 2
            ? 'nd'
            : date.day == 3
                ? 'rd'
                : 'th';
    return '$day, $month ${date.day}$prefix, $time';
  }

  static String formatSinceLastMessage(Timestamp chatLastMessageDate) {
    final duration = DateTime.now().difference(chatLastMessageDate.toDate());
    return duration.inMinutes == 0
        ? "now".tr
        : duration.inMinutes < 60
            ? duration.inMinutes.toString() + "m".tr
            : duration.inHours < 24
                ? duration.inHours.toString() + "h".tr
                : duration.inDays.toString() + "d".tr;
  }

  /// get the difference between starts and ends in minutes
  static int formatDuration(String starts, String ends) {
    DateTime start = DateTime.parse(starts);
    int startsHours = start.hour;
    int startsMinutes = start.minute;

    int endsHours = int.parse(ends.split(':')[0]);
    int endsMin = int.parse(ends.split(':')[1]);

    if (startsHours == endsHours) {
      return endsMin - startsMinutes;
    } else if (startsHours == endsHours - 1) {
      return (60 - startsMinutes) + endsMin;
    } else {
      return 120;
    }
  }

  static String formatDateTime(DateTime dateTime) =>
      dateTime.toString().substring(0, 16);

  static String formatDate(DateTime dateTime) =>
      dateTime.toString().substring(0, 10);

  static String formatTime(DateTime time) => time.toString().substring(11, 16);

  static String formatSentAt(Timestamp timeStamp) {
    DateTime date = timeStamp.toDate();
    return ' ${date.hour}:${date.minute < 10 ? "0${date.minute}" : date.minute}';
  }

  static String formatStartingIn(String startDate) {
    String startingIn = "";
    DateTime today = DateTime.now();

    DateTime startDateTime = DateTime.parse(startDate);

    startingIn = startDateTime.difference(today).inDays.toString();
    if (startDateTime.difference(today).isNegative) {
      startingIn = 'research_will_begin_soon'.tr;
    } else if (startDateTime.difference(today).inDays == 0) {
      startingIn = '${"starting".tr} ${"today".tr}';
    } else if (startDateTime.difference(today).inDays == 1) {
      startingIn = '${"starting".tr} ${"tomorrow".tr}';
    } else {
      startingIn =
          '${"starting_in".tr} ${startDateTime.difference(today).inDays} ${"days".tr}';
    }

    return startingIn;
  }
}
