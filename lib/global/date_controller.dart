import 'package:get/get.dart';





class DateController extends GetxController{
  Rx<DateTime> _endDate=Rx(DateTime.now().add(Duration(days:1)));
  Rx<DateTime>  _startDate=Rx(DateTime.now());
  set endDate(DateTime value)=>_endDate.value=value;
  DateTime get endDate =>_endDate.value;

  set startDate(DateTime value)=>_startDate.value=value;
  DateTime get startDate =>_startDate.value;



  updateStartDate(var x){
    _startDate(x);
  }
  updateEndDate(var z){
    _endDate(z);
  }


}