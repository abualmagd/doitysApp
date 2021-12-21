import 'dart:convert';

import 'package:doitys/data_api/auth.dart';
import 'package:doitys/models/user_model.dart';
import 'package:doitys/pages/one_challenge_view.dart';
import 'package:doitys/pages/one_post_view.dart';
import 'package:doitys/pages/profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _prefs;
  var auth=AuthUtil();

  var _textController=TextEditingController();

  var _isLoading=false;
  var _prefix='';
  var _suggestions;
  bool _searchOption=false;
  var _resistSuggestion;
  var _lastSearch;
   getLastSearch()async{
    _prefs=await SharedPreferences.getInstance();
    _lastSearch=_prefs.getString('lastSearch')??[];///return the saved last search
    _lastSearch=jsonDecode(_lastSearch);
  }
  addToLastSearch(int index){
     if(!_lastSearch.contains(_suggestions[index]))
    _lastSearch.insert(0,_suggestions[index]);
   var _last=jsonEncode(_lastSearch);
   _prefs.setString('lastSearch',_last);
  }

  updateLastSearch(){
    var _last=jsonEncode(_lastSearch);
    _prefs.setString('lastSearch',_last);
  }
  @override
  void initState(){
   getLastSearch();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        elevation: 0.0,
        leading: IconButton(onPressed:(){
          ///close the keyboard
          FocusScope.of(context).unfocus();
          _textController.clear();
          setState(() {
            _searchOption=false;
            _prefix='';
            _suggestions=null;
          });
          Navigator.pop(context);
        } , icon:Icon(Icons.arrow_back,color:Theme.of(context).shadowColor,),),
        title: SizedBox(
          width: 600,
          child: TextField(
            autofocus: true,
            style: const TextStyle(
              fontSize: 20,
            ),
            decoration:InputDecoration(
              suffix: IconButton(onPressed:(){
                _textController.clear();
                setState(() {
                  _searchOption=false;
                  _isLoading=false;
                  _prefix='';
                  _suggestions=null;
                });
              } , icon:Icon(Icons.clear,color:Theme.of(context).shadowColor,),),
              prefix: _searchOption?Padding(
                padding: const EdgeInsets.only(bottom:4.0,right: 4),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                    width: 50,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blueGrey.shade300,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(child: Text(_prefix,style: TextStyle(fontSize: 12),)),
                    )),
              ):SizedBox.shrink(),
              border: InputBorder.none,
              contentPadding:const EdgeInsets.only(bottom: 10),
            ),
            controller: _textController,
            onChanged:(value){
              if(_suggestions!=null) {
                _suggestions = _resistSuggestion;
                if(_prefix==''||_prefix=='people'&&_suggestions[0]['name']!=null) {
                  var _newSuggestion = _suggestions.where((map) =>
                  map['name']!.toLowerCase().contains(value.toLowerCase()) ? true : false)
                      .toList();
                  setState(() {
                    _suggestions = _newSuggestion;
                  });
                }else {
                  var _newSuggestion = _suggestions.where((map) =>
                  map['content']!.toLowerCase().contains(value.toLowerCase())
                      ? true
                      : false)
                      .toList();
                  setState(() {
                    _suggestions = _newSuggestion;
                  });

                  ///filter suggestion
                }
              }
            } ,
            textInputAction: TextInputAction.search,
            onEditingComplete: ()async{
              ///search supabase

              setState(() {
                _isLoading=true;
              });
              if(_prefix==''||_prefix=='people'){///search users by name
                print('search users');
                      _suggestions= await auth.searchUsers('%'+_textController.text.toLowerCase()+'%').whenComplete((){
                        setState(() {
                          _isLoading=false;
                        });
                      });
                          _resistSuggestion=_suggestions;

                      }
          if(_prefix=='posts'){
            print('search posts');
                    _suggestions= await auth.searchPosts(_textController.text.toLowerCase()).whenComplete((){
                      setState(() {
                        _isLoading=false;
                      });
                    });
                      _resistSuggestion=_suggestions;
                        print(_suggestions);
                      setState(() {

                      });}
          if(_prefix=='challenges') {
            print('search ch');
            _suggestions =
            await auth.searchChallenges(_textController.text.toLowerCase())
                .whenComplete(() {
              setState(() {
                _isLoading = false;
              });
            });
            _resistSuggestion = _suggestions;
              print(_suggestions);
            setState(() {

            });
          }
            },
          ),
        ),
        bottom:_searchOption==false? PreferredSize(

          preferredSize: Size(double.infinity,30),
          child:Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed:(){
                    setState(() {
                      _prefix='last';
                      _searchOption=true;
                      _suggestions=_lastSearch;
                    });
                    ///set state the search for users
                  }, child:Text('last')),
                TextButton(onPressed:(){
                  setState(() {
                    _prefix='people';
                    _searchOption=true;
                    _suggestions=null;
                  });
                  ///set state the search for users
                }, child:Text('people')),
                TextButton(onPressed:(){
                  setState(() {
                    _prefix='posts';
                    _searchOption=true;
                    _suggestions=null;
                  });
                  ///set state the search for posts
                }, child:Text('posts')),
                TextButton(onPressed:(){
                  setState(() {
                    _prefix='challenges';
                    _searchOption=true;
                    _suggestions=null;
                  });
                  ///set state the search for challenges
                }, child:Text('challenges')),

              ],),
              _isLoading?LinearProgressIndicator():SizedBox.shrink(),
            ],
          ),
        ):PreferredSize(child: Container(
          child: _isLoading?LinearProgressIndicator():SizedBox.shrink() ,
        ), preferredSize: Size(0,0)),
      ),
      body: AnimatedContainer(
        duration: Duration(microseconds: 600),
        curve: Curves.bounceInOut,
        child:_suggestions==null?
            Center():_suggestions.isEmpty?Center(child:Text('No items found',style: TextStyle(fontSize: 25),))
            :Column(
              children: [
                (_prefix=='last')?ListTile(
                  trailing:IconButton(icon: Icon(Icons.clear),onPressed:(){

                    setState(() {
                      _lastSearch=[];
                      _suggestions=[];
                    });
                  } ,),
                  title: Text('Clear the Last Search'),
                ):SizedBox.shrink(),
                Expanded(
                  child: ListView.builder(
          itemCount: _suggestions.length,
                    itemBuilder:(context,index)=>
                     Padding(
                       padding: const EdgeInsets.all(2.0),
                       child: Container(
                         decoration: BoxDecoration(
                           color: Colors.white70,
                           borderRadius: BorderRadius.circular(12),
                         ),
                         child: ListTile(
                           trailing:_prefix=='last'?IconButton(onPressed: () {
                             _lastSearch.removeAt(index);
                             updateLastSearch();
                             setState(() {

                             });
                           },icon: Icon(Icons.clear),):SizedBox.shrink(),
                          leading:_suggestions[index]['type']=='Author'?CircleAvatar(backgroundImage: NetworkImage(_suggestions[index]['avatar'],)):
                           const Icon(Icons.article),
                          title:_suggestions[index]['type']!='Author'? Text(_suggestions[index]['content']):Text(_suggestions[index]['name']),
                          subtitle: _suggestions[index]['type']=='Author'?Text(_suggestions[index]['display']):Text(''),
                           onTap:(){

                             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                               if(_suggestions[index]['type']=='Author'){
                                 Author _author=Author.fromData(_suggestions[index]);
                                 return Profile(_author);
                               }
                               if(_suggestions[index]['type']=='Post'){
                                 return PostPage(GlobalKey(),_suggestions[index]['id']);
                               }
                              return  SingelChallenge(key:GlobalKey(),challengeId:_suggestions[index]['id'],);
                             }));
                           addToLastSearch(index);
                            } ,
        ),
                       ),
                     ),
                  ),
                ),
              ],
            )
      ),

    );
  }
}
