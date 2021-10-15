class DateTimeUtils {
  List<String> monthsList = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<String> shortMonthsList = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  String getMonth(int timeStamp, bool isShort) {
    final date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    final int month = date.month;
    return isShort ? shortMonthsList[month] : monthsList[month];
  }

  int getDate(int timeStamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    return date.day;
  }

  String getTime(int timeStamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    final String time = date.hour.toString() + ':' + date.minute.toString();
    return time;
  }

  String getWholeDate(int timeStamp) {
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
      final String tim = monthsList[date.month - 1] +
          ' ' +
          date.day.toString() +
          ',' +
          date.year.toString() +
          ' ' +
          getTime(timeStamp);
      return tim;
    } catch (e) {
      return e.toString();
    }
  }

  String timeAgoSinceDate(int timeStamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
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
