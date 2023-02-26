import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/data/provider/ticketLibrary_service.dart';
import 'package:web_project/auth_service.dart';
import 'package:web_project/centerConstraintBody.dart';
import 'package:web_project/globalVariables.dart';

class TicketLibraryList extends StatefulWidget {
  const TicketLibraryList(this.ticketList, this.customFunction, {super.key});

  final List ticketList;
  final Function customFunction;

  @override
  State<TicketLibraryList> createState() => _TicketLibraryListState();
}

class _TicketLibraryListState extends State<TicketLibraryList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TicketLibraryService>(
      builder: (context, ticketLibraryService, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: CenterConstrainedBody(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                        child: Text("수강권 명",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      TextButton(
                        child: Text("완료"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ), */
                  ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.ticketList.length,
                    itemBuilder: (context, index) {
                      if (widget.ticketList[index]['uid'] ==
                          AuthService().currentUser()!.uid) {
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
                                    ticketLibraryService.delete(
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
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
