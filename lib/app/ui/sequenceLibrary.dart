import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_project/app/ui/importSequenceFromSaved.dart';
import 'package:web_project/centerConstraintBody.dart';
import 'package:web_project/color.dart';
import 'package:web_project/globalWidget.dart';

class SequenceLibrary extends StatefulWidget {
  const SequenceLibrary({super.key});

  @override
  State<SequenceLibrary> createState() => _SequenceLibraryState();
}

class _SequenceLibraryState extends State<SequenceLibrary> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: BaseAppBarMethod(context, "시퀀스 관리", () {
          Navigator.pop(context);
        },
            null,

            /// 탭바
            TabBar(
                indicatorColor: Palette.buttonOrange,
                unselectedLabelColor: Palette.gray66,
                labelColor: Palette.textOrange,
                tabs: [
                  /// 저장된 시퀀스 탭
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '저장된 시퀀스',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  /// 최근 시퀀스 탭
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '최근 시퀀스',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ])),

        /// 바디 시작
        body: CenterConstrainedBody(
          child: TabBarView(children: [
            /// 저장된 시퀀스 탭 내용
            Container(
              width: double.infinity,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 100,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImportSequenceFromSaved()),
                      ).then((value) => Navigator.pop(context));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                    tileColor: Palette.mainBackground,
                    title: Row(
                      children: [
                        Text('커스텀시퀀스 ${index + 1}'),
                        SizedBox(width: 10),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Palette.gray99, width: 1)),
                          child: Text(
                            '${2 * index}',
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  );
                },
              ),
            ),

            /// 최근 시퀀스 탭 내용
            Container(
              width: double.infinity,
              child: Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      tileColor: Palette.mainBackground,
                      title: Row(
                        children: [
                          Text('2022.03.22 22:31'),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Palette.gray99, width: 1)),
                            child: Text(
                              '40',
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    );
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
