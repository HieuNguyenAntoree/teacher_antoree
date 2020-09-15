import 'package:intl/intl.dart';


class UtilsFunction{
  static UtilsFunction _instance;

  static UtilsFunction getInstance() {
    if (_instance == null) {
      // keep local instance till it is fully initialized.
      return new UtilsFunction._();
    }
    return _instance;
  }
  UtilsFunction._();

  static convertDateTimeToString(DateTime date){
    String str = DateFormat('dd-MM-yyyy').format(date);
    return str;
  }

  static gender(int gender){
    if (gender == 1) {
      return "Male";
    }else if(gender == 2){
      return "Female";
    }else{
      return "Other";
    }
  }
}