import 'package:shared_preferences/shared_preferences.dart';
class SharedPref {
  //SharedPreferences is used to store the data in the local storage.
  SharedPreferences? _sharedPrefences;

  SharedPref({required SharedPreferences pref}){
    _sharedPrefences=pref;
  }

  //below methods are for storing the key value pairs in local database
  void storeInt(String key, int value)
  {
    _sharedPrefences!.setInt(key, value);
  }
  void storeDouble(String key, double value)
  {
    _sharedPrefences!.setDouble(key, value);
  }
  void storeBool(String key, bool value)
  {
    _sharedPrefences!.setBool(key, value);
  }
  void storeString(String key, String value)
  {
    _sharedPrefences!.setString(key, value);
  }
  void storeStringList(String key, List<String> value)
  {
    _sharedPrefences!.setStringList(key, value);
  }

  //Below methods are used to retrieve data from local storage.
  int? retrieveInt(String key)
  {
    return _sharedPrefences!.getInt(key);
  }
  double? retrieveDouble(String key)
  {
    return _sharedPrefences!.getDouble(key);
  }
  bool? retrieveBool(String key)
  {
    return _sharedPrefences!.getBool(key);
  }
  String? retrieveString(String key)
  {
    return _sharedPrefences!.getString(key);
  }
  List<String>? retrieveStringList(String key)
  {
    return _sharedPrefences!.getStringList(key);
  }



}