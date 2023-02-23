import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/binding/ticketLibrary_service.dart';
import 'package:web_project/app/ui/ticketLibraryMake.dart';
import 'package:web_project/color.dart';
import 'package:web_project/globalWidget.dart';
import 'package:web_project/userInfo.dart';

class TicketLibrary extends StatefulWidget {
  const TicketLibrary({this.ticketLibraryList, super.key});

  final List? ticketLibraryList;

  @override
  State<TicketLibrary> createState() => _TicketLibraryState();
}

class _TicketLibraryState extends State<TicketLibrary> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TicketLibraryService>(builder: (context, TicketLibraryService, child) {
      return Scaffold(
        appBar: BaseAppBarMethod(context, "수강권 라이브러리", () {
          
          Navigator.pop(context);
        }, null),
        body: Column(
          children: [
            // 수강권 추가 버튼
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              color: Palette.mainBackground,
              child: TextButton(
                onPressed: () async {
                  var result = await // 저장하기 성공시 Home로 이동
                      Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TicketLibraryMake()),
                  ).then((value) {
                    print("수강권 추가 result");
                  });
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Palette.gray99, width: 2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "수강권 추가하기",
                        style: TextStyle(fontSize: 16, color: Palette.gray66),
                      ),
                      Icon(
                        Icons.add_circle_outline,
                        color: Palette.gray66,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.ticketLibraryList!.length,
              itemBuilder: (context, index){
                return null;
            } , separatorBuilder: (BuildContext context, int index) { return SizedBox.shrink(); }, ),
          ],
        ),
      );
    });
  }
}
