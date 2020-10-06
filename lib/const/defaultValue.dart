import 'package:intl/intl.dart';  //for date format
class VALUES {
  static const COURSE_STATUSES_OPEN = 0;
  static const COURSE_STATUSES_DELAY = 6;
  static const COURSE_STATUSES_CLOSED = 10;
  static const COURSE_STATUSES_ALL = -1;

  static const COURSE_STATUSES_OPEN_STR = "Open";
  static const COURSE_STATUSES_DELAY_STR = "Delay";
  static const COURSE_STATUSES_CLOSED_STR = "Closed";
  static const COURSE_STATUSES_ALL_STR = "All";

  static const DELAY_TIME = 20;
  static const SCHEDULE_DAYS = 7;
  static DateFormat FORMAT_DATE_API = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  static DateFormat FORMAT_DATE_yyyy_mm_dd = DateFormat("yyyy-MM-dd");
}

class STRINGS{
  static const ERROR_TITLE = "ERORR";
  static const LOGIN_TEXT = "Tiếng Anh 1 kèm 1 cùng Antoree";
  static const LOGIN_EMAIL_HINT = "Nhập email / số điện thoại của bạn";
  static const LOGIN_PASS_HINT = "Nhập Test Code đã nhận qua email";
  static const LOGIN_LOGIN_STATUS = "Duy trì đăng nhập";
  static const LOGIN_BUTTON = "Đăng nhập";
  static const LOGIN_PASS_VALID = "Password should contains more then 5 characters";
  static const LOGIN_EMAIL_VALID = "Email is invalid";
  static const EMPTY_LIST = "List is empty";
  static const TEACHER_STRING = "Giáo viên";
  static const NO_SCHEDULE = "You don't' have schedule in next 30 days, so you can't' connect the feature.";
}

class IMAGES{
  static const String LOGIN_TOPIMAGE = "assets/images/1.login/login_topimg.png";
  static const String LOGIN_ACCOUNT = "assets/images/1.login/login_account.png";
  static const String LOGIN_PASS = "assets/images/1.login/login_pass.png";
  static const String LOGIN_CHECKBOX = "assets/images/1.login/login_checkbox.png";
  static const String LOGIN_BUTTON = "assets/images/1.login/login_button.png";
  static const String LOGIN_UNCHECKBOX = "assets/images/1.login/login_uncheckbox.png";

  static const String HOME_CALL_GRAY = "assets/images/2.home/call_gray.png";
  static const String HOME_CALL_GREEN = "assets/images/2.home/call_green.png";
  static const String HOME_CANCEL = "assets/images/2.home/home_cancel.png";
  static const String HOME_LOGO = "assets/images/2.home/home_logo.png";
  static const String HOME_LOGOUT = "assets/images/2.home/home_logout.png";
  static const String HOME_NOTI = "assets/images/2.home/home_noti.png";
  static const String HOME_NOTI_OFF = "assets/images/2.home/home_noti_off.png";
  static const String HOME_PENCIL = "assets/images/2.home/home_pencil.png";
  static const String HOME_AVATAR = "assets/images/2.home/home_avatar.png";

  static const String RATING_TOPIMAGE = "assets/images/6.rating/rating_topimage.png";

  static const String NOTIFCATION_CANCEL = "assets/images/8.notification/notification_cancel.png";

  static const String CALENDAR_NEXT = "assets/images/4.calendar/calendar_back_active.png";
  static const String CALENDAR_NEXT_UN = "assets/images/4.calendar/calendar_back_unactive.png";
  static const String CALENDAR_BACK = "assets/images/4.calendar/calendar_next_active.png";
  static const String CALENDAR_BACK_UN = "assets/images/4.calendar/calendar_next_unactive.png";
  static const String CALENDAR_CANCEL_UNACTIVE = "assets/images/4.calendar/calendar_cancel_grey.png";
  static const String CALENDAR_CANCEL_ACTIVE = "assets/images/4.calendar/calendar_cancel_green.png";
  static const String CALENDAR_CALL_UNACTIVE = "assets/images/4.calendar/calendar_call_grey.png";
  static const String CALENDAR_CALL_ACTIVE = "assets/images/4.calendar/calendar_call_white.png";
  static const String CALENDAR_CALL_BACK = "assets/images/4.calendar/calendar_back.png";

  static const String ARROW_DOWN = "assets/images/9.teacher/arrowdown.png";
  static const String ARROW_UP = "assets/images/9.teacher/arrowup.png";
  static const String ICON_SQUARE = "assets/images/9.teacher/iconsquare.png";

}

enum TEACHER_TYPE {
  UNKNOWN,
  PHILIPPINE,
  VIETNAM,
  NATIVE,
}

class TEACHER_TYPE_STRING {
  static const String ALL = 'Tất cả';
  static const String VIETNAM = 'Giáo viên Việt Nam';
  static const String PHILIPINES = 'Giáo viên Philipines';
  static const String PREMIUM = 'Giáo viên Premium';
  static const String NATIVE = 'Giáo viên Native';
  static const String UNKNOWN = 'Giáo viên';
}

extension TeacherExtension on TEACHER_TYPE {
  String get displayTitle {
    switch (this) {
      case TEACHER_TYPE.NATIVE:
        return TEACHER_TYPE_STRING.NATIVE;
      case TEACHER_TYPE.VIETNAM:
        return TEACHER_TYPE_STRING.VIETNAM;
      case TEACHER_TYPE.PHILIPPINE:
        return TEACHER_TYPE_STRING.PHILIPINES;
      case TEACHER_TYPE.UNKNOWN:
        return TEACHER_TYPE_STRING.UNKNOWN;
      default:
        return TEACHER_TYPE_STRING.UNKNOWN;
    }
  }
}

class SCHEDULE_STATUS{
  static const int UNKNOWN = -1;// UNKNOWN(-1),
  static const int ACTIVE = 1;//  ACTIVE(1),
  static const int CANCEL = 2;// CANCEL(2),
  static const int DONE = 3;// DONE(3),
}

class SCHEDULE_STATUS_TEXT{
  static const String UNKNOWN = "UNKNOWN";
  static const String ACTIVE = "ACTIVE";
  static const String CANCEL = "CANCEL";
  static const String DONE = "DONE";
}

class TIMESHEET_STATUS{
  static const int AVAILABLE = 1;// AVAILABLE(1)
  static const int UNAVAILABLE = 2;//  UNAVAILABLE(2)
  static const int CANCELED = 3;// CANCELED(3)
  static const int MEETING = 4;// MEETING(4)
}




