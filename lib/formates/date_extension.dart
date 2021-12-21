
extension ExtendedDate on DateTime?{
  String get readable{
    return this!.year.toString()+"-"+this!.month.toString()+"-"+this!.day.toString();
  }

}

extension ExtendedD on DateTime{
  DateTime get ymd{
    return DateTime(this.year,this.month,this.day);
  }

}

extension ExtendedDt on DateTime{
  DateTime get yesterday{
    return DateTime.now().subtract(Duration(
      days:1,
    ));
  }

}

extension Extendedd on DateTime{

 String get styled{
   if(DateTime.now().difference(this).inMinutes<1){
     return 'now';
   }
   if(DateTime.now().difference(this).inMinutes<60){
     return DateTime.now().difference(this).inMinutes.toString()+' minute';
   }
   if(DateTime.now().difference(this).inHours<24){
       return DateTime.now().difference(this).inHours.toString()+' hour';
     }
   if(DateTime.now().difference(this).inDays<29){
     return DateTime.now().difference(this).inDays.toString()+' day';
   }
   if(DateTime.now().difference(this).inDays>29&&DateTime.now().difference(this).inDays<365){
     return (DateTime.now().difference(this).inDays/30).ceil().toString()+' month';
   }
   return (DateTime.now().difference(this).inDays/365).ceil().toString()+' year';
  }

}


String styled(var date){
  if(DateTime.now().difference(date).inMinutes<1){
    return 'now';
  }
  if(DateTime.now().difference(date).inMinutes<60){
    return DateTime.now().difference(date).inMinutes.toString()+' minute';
  }
  if(DateTime.now().difference(date).inHours<24){
    return DateTime.now().difference(date).inHours.toString()+' hour';
  }
  if(DateTime.now().difference(date).inDays<29){
    return DateTime.now().difference(date).inDays.toString()+' day';
  }
  if(DateTime.now().difference(date).inDays>29&&DateTime.now().difference(date).inDays<365){
    return (DateTime.now().difference(date).inDays/30).ceil().toString()+' month';
  }
  return (DateTime.now().difference(date).inDays/365).ceil().toString()+' year';
}
