class DateTimeUtils {
  List<String> monthsList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<String> shortMonthsList = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  getMonth(int timeStamp, bool isShort) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timeStamp);
    int month = date.month;
    return isShort ? shortMonthsList[month] : monthsList[month];
  }

  getDate(int timeStamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timeStamp);
    return date.day;
  }

  getTime(int timeStamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timeStamp);
    String time = date.hour.toString() + ":" + date.minute.toString();
    return time;
  }

  getWholeDate(int timeStamp) {
    try {
      var date = new DateTime.fromMillisecondsSinceEpoch(timeStamp);
      String tim = monthsList[date.month - 1] +
          " " +
          date.day.toString() +
          "," +
          date.year.toString() +
          " " +
          getTime(timeStamp);
      return tim;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  String timeAgoSinceDate(int timeStamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timeStamp);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}