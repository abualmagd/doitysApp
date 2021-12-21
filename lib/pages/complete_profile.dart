import 'dart:async';

import 'package:doitys/data_api/auth.dart';
import 'package:doitys/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({Key? key}) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

var _formKey = GlobalKey<FormState>();

String? _displayName;

bool duplicate = false;
Timer? watch;
Timer? verify;
FocusNode _focusNode = FocusNode();
TextEditingController _userNameController = TextEditingController();
TextEditingController _locationController =
    TextEditingController(text: 'Location');
AuthUtil auth = AuthUtil();
var _client = Get.find<SupabaseClient>();

class _CompleteProfileState extends State<CompleteProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: context.theme.primaryColor,
          ),
          SingleChildScrollView(
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  color: context.theme.backgroundColor,
                ),
                height: MediaQuery.of(context).size.height * .80,
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        'complete yor profile',
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      height: 12,
                      width: MediaQuery.of(context).size.width * .90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Colors.grey),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 12,
                          width: MediaQuery.of(context).size.width * .30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, right: 12, left: 12),
                            child: TextFormField(
                              focusNode: _focusNode,
                              controller: _userNameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "enter user name";
                                } else if (value.length < 3) {
                                  return 'your name is so short';
                                } else if (duplicate) {
                                  return "sorry user name is used";
                                } else if (value.length > 16) {
                                  return " your name cannot be more 15 alphabets";
                                } else if (value.isNotEmpty) {
                                  Pattern pattern = "^[a-zA-Z0-9 _]*\$";
                                  RegExp regex = new RegExp(pattern.toString());
                                  if (!regex.hasMatch(value))
                                    return 'allow only alphabets numbers and _';
                                }
                                return null;
                              },
                              onChanged: onchangevalidate,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              maxLines: 1,
                              minLines: 1,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                hintText: ('UserName '),
                                hintStyle: TextStyle(color: Colors.black),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 12, left: 12),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "enter your displayName";
                                }
                                return null;
                              },
                              onSaved: (val) {
                                _displayName = val;
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              maxLines: 1,
                              minLines: 1,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                hintText: ('DisplayName '),
                                hintStyle: TextStyle(color: Colors.black),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 12, left: 12),
                            child: TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: _locationController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                  maxLines: 1,
                                  minLines: 1,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a city';
                                  }
                                },
                                onSuggestionSelected: (suggestion) {
                                  _locationController.text = suggestion.toString();
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(suggestion.toString()),
                                  );
                                },
                                suggestionsCallback: (pattern) {
                                  return CitiesService.getSuggestions(pattern);
                                },
                               ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Material(
                        elevation: 2,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Container(
                          width: 320,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.purple,
                          ),
                          child: TextButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  if (duplicate == false) {
                                    var _id = _client.auth.currentUser!.id;
                                    var _email = _client.auth.currentUser!.email;
                                    await auth.saveUser(
                                        _id,
                                        _email,
                                        "@" + _userNameController.text,
                                        _displayName!,_locationController.text.toLowerCase());
                                    showLoaderDialog(context);
                                    Navigator.pop(context);

                                    Fluttertoast.showToast(
                                        msg: 'success '
                                            '\n your profile is complete ',
                                        timeInSecForIosWeb: 2,
                                        backgroundColor: Colors.green);

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => MyHomePage()));
                                  }
                                } else {
                                  print('error');
                                }
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500),
                              )),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Duration? duration;

  onchangevalidate(val) async {
    if (watch != null) {
      watch!.cancel();
    }
    setState(() {
      duration = Duration(milliseconds: 500);
    });

    watch = Timer(duration!, () async {
      await userNameValid("@" + _userNameController.text.toLowerCase().trim())
          .then((result) {
        if (result == false) {
          setState(() {
            duplicate = false;
          });
          watch!.cancel();
        } else if (result == true) {
          setState(() {
            duplicate = true;
          });
          watch!.cancel();
          print('done');
        }
      });
    });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Container(
        height: 85,
        width: 35,
        color: Colors.transparent,
        child: new Column(
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Loading..."),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  userNameValid(String name) async {
    bool duplic = false;
    var _cleint = Get.find<SupabaseClient>();

    await _cleint
        .from('app_users')
        .select()
        .eq('name', name)
        .execute(count: CountOption.exact, head: true)
        .then((data) {
      print(data.count);
      if (data.count == 1 || data.count! > 1) {
        return duplic = true;
      }
      return duplic;
    });
    return duplic;
  }
}



class CitiesService {
  static final List<String> countries = [
    "Afghanistan",
    "Albania",
    "Algeria",
    "Andorra",
    "Angola",
    "Anguilla",
    "Antigua &amp; Barbuda",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bermuda",
    "Bhutan",
    "Bolivia",
    "Bosnia &amp; Herzegovina",
    "Botswana",
    "Brazil",
    "British Virgin Islands",
    "Brunei",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cambodia",
    "Cameroon",
    "Cape Verde",
    "Cayman Islands",
    "Chad",
    "Chile",
    "China",
    "Colombia",
    "Congo",
    "Cook Islands",
    "Costa Rica",
    "Cote D Ivoire",
    "Croatia",
    "Cruise Ship",
    "Cuba",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Estonia",
    "Ethiopia",
    "Falkland Islands",
    "Faroe Islands",
    "Fiji",
    "Finland",
    "France",
    "French Polynesia",
    "French West Indies",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Gibraltar",
    "Greece",
    "Greenland",
    "Grenada",
    "Guam",
    "Guatemala",
    "Guernsey",
    "Guinea",
    "Guinea Bissau",
    "Guyana",
    "Haiti",
    "Honduras",
    "Hong Kong",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran",
    "Iraq",
    "Ireland",
    "Isle of Man",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jersey",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kuwait",
    "Kyrgyz Republic",
    "Laos",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Macau",
    "Macedonia",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Mauritania",
    "Mauritius",
    "Mexico",
    "Moldova",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Montserrat",
    "Morocco",
    "Mozambique",
    "Namibia",
    "Nepal",
    "Netherlands",
    "Netherlands Antilles",
    "New Caledonia",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "Norway",
    "Oman",
    "Pakistan",
    "Palestine",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Poland",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Reunion",
    "Romania",
    "Russia",
    "Rwanda",
    "Saint Pierre &amp; Miquelon",
    "Samoa",
    "San Marino",
    "Satellite",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "South Africa",
    "South Korea",
    "Spain",
    "Sri Lanka",
    "St Kitts &amp; Nevis",
    "St Lucia",
    "St Vincent",
    "St. Lucia",
    "Sudan",
    "Suriname",
    "Swaziland",
    "Sweden",
    "Switzerland",
    "Syria",
    "Taiwan",
    "Tajikistan",
    "Tanzania",
    "Thailand",
    "Timor L'Este",
    "Togo",
    "Tonga",
    "Trinidad &amp; Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Turks &amp; Caicos",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "Uruguay",
    "Uzbekistan",
    "Venezuela",
    "Vietnam",
    "Virgin Islands (US)",
    "Yemen",
    "Zambia",
    "Zimbabwe"
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(countries);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
