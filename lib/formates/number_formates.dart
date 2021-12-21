

class NumberFormatting{

 String compact(int x){
    if(x>10000&&x<1000000){
      var result =(x/1000).toStringAsFixed(2)+"K";
      return result;
    }else if(x>=1000000){
      var result =(x/1000000).toStringAsFixed(2)+"M";
      return result;
    }
      return x.toString();
  }
}

