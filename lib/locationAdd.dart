import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_project/actionSelector.dart';
import 'package:web_project/localavailable_Info.dart';

import 'color.dart';

Map LocationMap = {};
List cityNameList = [];
Map districtMap = {};
List districtNameList = [];
List townList = [];

late Size screeSize;
late double width;
late double height;

List availableCityList = [];
List availableDistrictList = [];
List availableTownList = [];

String city = "";
String district = "";
String town = "";
String tmpDistrict = "";

List currentDistrict = [];

List resultList = [];

Color opTapedColor = Palette.backgroundOrange;
Color selectedColor = Palette.buttonOrange;

bool citySelected = false;
bool districtSelected = false;
bool townSelected = false;

bool cityOnTap = false;
bool districtOnTap = false;
bool townOnTap = false;

int cityOnTapIndex = 0;
int districtOnTapIndex = 0;
int townOnTapIndex = 0;

ScrollController districtScrollController = ScrollController();
ScrollController townScrollController = ScrollController();

class LocationAdd extends StatefulWidget {
  Map tmpLocationMap = {};
  List tmpResultList = [];
  LocationAdd({super.key});
  LocationAdd.getLocationMap(this.tmpLocationMap, this.tmpResultList,
      {super.key});

  @override
  State<LocationAdd> createState() => _LocationAddState();
}

class _LocationAddState extends State<LocationAdd> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocationMap = widget.tmpLocationMap;
    cityNameList = LocationMap.keys.toList();
    districtMap = LocationMap[cityNameList[0]];
    districtNameList = districtMap.keys.toList();
    townList = districtMap[districtNameList[0]];

    city = cityNameList[0];
    district = districtNameList[0];
    town = townList[0];

    resultList = widget.tmpResultList;
    resultList.forEach((element) {
      print(
          "locationAdd result => element.city : ${element.city}, element.district : ${element.district}, element.town : ${element.town}");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cityNameList = [];
    districtNameList = [];
    townList = [];

    cityOnTapIndex = 0;
    districtOnTapIndex = 0;
    townOnTapIndex = 0;

    currentDistrict = [];
    
  }

  @override
  Widget build(BuildContext context) {
    screeSize = MediaQuery.of(context).size;
    width = screeSize.width;
    height = screeSize.height;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Palette.secondaryBackground,
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: height * 0.7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: cityNameList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        // print("resultList.length : ${resultList.length}");
                        var element;
                        for (int i = 0; i < resultList.length; i++) {
                          element = resultList[i] as LocalAvailableInfo;
                          // resultList.forEach((element) {
                          // print("color element.city : ${element.city}");
                          if (element.city == cityNameList[index]) {
                            citySelected = true;
                            break;
                          } else {
                            citySelected = false;
                          }
                          // });
                        }
                        // print("cityOnTapIndex : ${cityOnTapIndex}");
                        // print("index : ${index}");
                        if (cityOnTapIndex == index) {
                          cityOnTap = true;
                        } else {
                          cityOnTap = false;
                        }
                        return InkWell(
                          onTap: () async {
                            setState(() {
                              cityOnTapIndex = index;
                              districtOnTapIndex = 0;
                              townOnTapIndex = 0;
                              district = "";

                              currentDistrict.clear();
                              city = cityNameList[index].toString();
                              districtMap = LocationMap[cityNameList[index]];
                              districtNameList = districtMap.keys.toList();
                              townList = districtMap[districtNameList[0]];
                              // print(cityNameList[index]);
                              // print("districtNameList : ${districtNameList}");
                            });
                            await districtScrollController.animateTo(
                                districtScrollController
                                    .position.minScrollExtent,
                                duration: Duration(milliseconds: 700),
                                curve: Curves.ease);
                            await townScrollController.animateTo(
                                townScrollController.position.minScrollExtent,
                                duration: Duration(milliseconds: 700),
                                curve: Curves.ease);
                          },
                          child: Container(
                            color: cityOnTap ? opTapedColor : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                cityNameList[index],
                                style: TextStyle(
                                  color: citySelected
                                      ? selectedColor
                                      : Colors.black,
                                ),
                              )),
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  color: Palette.grayB4,
                  width: 1,
                ),
                Expanded(
                  child: ListView.builder(
                      controller: districtScrollController,
                      itemCount: districtNameList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        var element;
                        for (int i = 0; i < resultList.length; i++) {
                          element = resultList[i] as LocalAvailableInfo;
                          // resultList.forEach((element) {
                          // print("color element.district : ${element.district}");
                          if ((element.city == city) &&
                              (element.district == districtNameList[index])) {
                            districtSelected = true;
                            break;
                          } else {
                            districtSelected = false;
                          }
                          // });
                        }
                        if (districtOnTapIndex == index) {
                          districtOnTap = true;
                        } else {
                          districtOnTap = false;
                        }
                        return InkWell(
                          onTap: () async {
                            setState(() {
                              currentDistrict.clear();
                              districtOnTapIndex = index;
                              district = districtNameList[index].toString();
                              townList = districtMap[districtNameList[index]];
                              // print("townList : ${townList}");
                            });
                            await townScrollController.animateTo(
                                townScrollController.position.minScrollExtent,
                                duration: Duration(milliseconds: 700),
                                curve: Curves.ease);
                          },
                          child: Container(
                            color: districtOnTap ? opTapedColor : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                districtNameList[index],
                                style: TextStyle(
                                  color: districtSelected
                                      ? selectedColor
                                      : Colors.black,
                                ),
                              )),
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  color: Palette.grayB4,
                  width: 1,
                ),
                Expanded(
                  child: ListView.builder(
                      controller: townScrollController,
                      itemCount: townList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (currentDistrict.isEmpty) {
                          for (int i = 0; i < townList.length; i++) {
                            if (townList[i].toString().contains("전체")) {
                              tmpDistrict =
                                  townList[i].toString().split("전체")[0].trim();
                            }
                            currentDistrict.add(tmpDistrict);
                            /* print("index : ${i}");
                            print(
                                "1-index[${i}] current tmpDistrict : ${tmpDistrict}");
                            print(
                                "currentDistrict[${i}] : ${currentDistrict[i]}"); */
                          }
                        }

                        var element;
                        for (int i = 0; i < resultList.length; i++) {
                          element = resultList[i] as LocalAvailableInfo;
                          // resultList.forEach((element) {
                          // print("color element.town : ${element.town}");
                          // print("color townList[${index}] : ${townList[index]}");
                          if ((element.city == city) &&
                              (element.district == currentDistrict[index]) &&
                              (element.town == townList[index])) {
                            townSelected = true;
                            break;
                          } else {
                            townSelected = false;
                          }
                          //});
                        }

                        if (townList[index].toString().contains("전체")) {
                          return Container();
                        }

                        if (townOnTapIndex == index) {
                          townOnTap = true;
                        } else {
                          townOnTap = false;
                        }
                        return InkWell(
                          onTap: () {
                            setState(() {
                              townOnTapIndex = index;
                              town = townList[index].toString();
                              print("2- current tmpDistrict : ${tmpDistrict}");
                              print("index : ${index}");
                              print(
                                  "currentDistrict[${index}] : ${currentDistrict[index]}");
                              LocalAvailableInfo localAvailableInfo =
                                  LocalAvailableInfo(
                                      city, currentDistrict[index], town);
                              // print("city : ${city}, district : ${district}, town : ${town}");
                              // print("localAvailableInfo.city : ${localAvailableInfo.city}, localAvailableInfo.district : ${localAvailableInfo.district}, localAvailableInfo.town : ${localAvailableInfo.town}");
                              var element;
                              bool isNotContained = true;
                              if (resultList.isEmpty) {
                                resultList.add(localAvailableInfo);
                                /* resultList.forEach((element) {
                                  print(
                                      "add element.city : ${element.city}, element.district : ${element.district}, element.town : ${element.town}");
                                }); */
                              } else {
                                for (int i = 0; i < resultList.length; i++) {
                                  element = resultList[i] as LocalAvailableInfo;
                                  /* print(
                                      "remove element.city : ${element.city}, element.district : ${element.district}, element.town : ${element.town}"); */
                                  if ((element.city == city) &&
                                      (element.district ==
                                          currentDistrict[index]) &&
                                      (element.town == town)) {
                                    resultList.removeAt(i);
                                    // print("remove");
                                    isNotContained = false;
                                    break;
                                  }
                                }

                                if (isNotContained) {
                                  resultList.add(localAvailableInfo);
                                  /* resultList.forEach((element) {
                                  print(
                                      "add element.city : ${element.city}, element.district : ${element.district}, element.town : ${element.town}");
                                }); */
                                  // print("add");
                                }
                              }
                              resultList.forEach((element) {
                                print(
                                    "result => element.city : ${element.city}, element.district : ${element.district}, element.town : ${element.town}");
                              });
                            });
                          },
                          child: Container(
                            color: townOnTap ? opTapedColor : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(townList[index],
                                style: TextStyle(
                                  color: townSelected
                                      ? selectedColor
                                      : Colors.black,
                                ),
                              )),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          Container(
            color: Palette.grayB4,
            height: 1,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 11, 0, 22),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(48.0),
                    ),
                    color: Palette.buttonOrange,
                  ),
                  height: 48,
                  width: 238,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "선택",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  print("선택 버튼");
                  // create action
                  if (resultList.isNotEmpty) {
                    // 신규 동작 추가 성공시 actionSelect로 이동
                    Navigator.pop(context, resultList);
                  } else {
                    // 빈 값 있을 때
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("지역을 선택 해주세요."),
                    ));
                  }
                }),
          )
        ],
      ),
    );
  }
}
