import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web_project/app/ui/memberInfo.dart';

class GlobalVariables {
  List resultList = [];
  List actionList = [];

  sortList() {
    print("GlobalVariables - sortList is called");
    var trueList = resultList.where((element) => element['isFavorite'] == true);
    for(var i in trueList){
      print("trueList i : ${i}");
    }
    List tList = trueList.toList();
    tList.sort(((a, b) => a['name'].compareTo(b['name'])));
    for (var i in tList) {
      print("tList i : ${i}");
    }

    var falseList = resultList.where((element) => element['isFavorite'] == false);
    for(var i in falseList){
      print("falseList i : ${i}");
    }
    List fList = falseList.toList();
    fList.sort(((a, b) => a['name'].compareTo(b['name'])));
    for (var i in tList) {
      print("tList i : ${i}");
    }

    var nullList = resultList.where((element) => element['isFavorite'] == null);
    List nList = nullList.toList();
    for(int i=0; i<nList.length; i++){
      nList[i]['isFavorite'] = false;
    }

    List combinedList = [];
    combinedList.addAll(fList);
    combinedList.addAll(nList);
    combinedList.where((element) => element['isFavorite'] == false);
    combinedList.sort((a,b) => a['name'].compareTo(b['name']));

    resultList = [];
    resultList.addAll(tList);
    resultList.addAll(combinedList);

    for (var i in resultList) {
      print("i['id'] : ${i}");
    }
  }
}
