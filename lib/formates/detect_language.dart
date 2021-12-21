


RegExp ar=new RegExp(r"[^\u0621-\u064A]");
 /*extension ExtendedStrin on String?{


   bool get isArabic{
     return this!=null&& this!.isNotEmpty&&this!.toString().trim().contains(ar);
   }

 }*/
 RegExp rgx = new RegExp("[^a-zA-Z]");
RegExp rg=new RegExp(r"[^\s\w]");
 extension ExtendedStri on String{

   bool get isEnglish{
     return  this.isNotEmpty&&this.replaceAll(rg, '')
         .contains(rgx)&&this.replaceAll(ar, '').contains(rgx);
   }
 }


 bool isEnglish(var x){
   return x.isNotEmpty&&x.replaceAll(rg, '')
       .contains(rgx)&&x.replaceAll(ar, '').contains(rgx);
 }
