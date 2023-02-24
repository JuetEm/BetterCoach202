import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/binding/memberTicket_service.dart';
import 'package:web_project/app/binding/ticketLibrary_service.dart';
import 'package:web_project/centerConstraintBody.dart';
import 'package:web_project/color.dart';
import 'package:web_project/globalVariables.dart';

class MemberTicketList extends StatefulWidget {
  const MemberTicketList(this.memberId ,this.ticketList, this.customFunction, {super.key});

  final String memberId;
  final List ticketList;
  final Function customFunction;

  @override
  State<MemberTicketList> createState() => _MemberTicketListState();
}

class _MemberTicketListState extends State<MemberTicketList> {

  @override
  void initState() {
    super.initState();
    print("widget.memberId : ${widget.memberId}");
    print("widget.ticketList : ${widget.ticketList}");
  }
  
  @override
  Widget build(BuildContext context) {
    widget.ticketList.forEach((element){print(element);},);
    return Consumer<MemberTicketService>(
      builder: (context, memberTicketService, child) {
        return Scaffold(
          body: Container(
            height: 500,
            width: 300,
            color: Palette.mainBackground,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // titleP
                SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.ticketList.length,
                    itemBuilder: (context, index) {
                      print("widget.ticketList[index] : ${widget.ticketList[index]}");
                    if(widget.ticketList[index]['memberId'] == widget.memberId){
                      return ListTile(
                        title: Text(widget.ticketList[index]['ticketTitle']),
                        trailing: IconButton(
                            onPressed: () {
                              var element;
                              for (int i = 0;
                                  i < widget.ticketList.length;
                                  i++) {
                                element = widget.ticketList[i];
                                if (element['id'] ==
                                    widget.ticketList[index]['id']) {
                                  memberTicketService.delete(
                                      docId: element['id'],
                                      onError: () {},
                                      onSuccess: () {});
                                  widget.ticketList.remove(element);
                                  break;
                                }
                              }
                              widget.customFunction();
                            },
                            icon: Icon(Icons.clear)),
                      );
                    }else{
                      return SizedBox.shrink();
                    }
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
