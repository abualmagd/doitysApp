
extension ExtendedString on String?{

  bool get isValid{
    return this!=null&&this!.toString().trim().isNotEmpty;
  }

}
