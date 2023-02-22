import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'color.dart';

class TicketWidget extends StatefulWidget {
  final Function customFunctionOnTap;
  final Function? customFunctionOnHover;
  final int ticketCountLeft;
  final int ticketCountAll;
  final String ticketTitle;
  final String ticketDescription;
  final String ticketStartDate;
  final String ticketEndDate;
  final int ticketDateLeft;

  TicketWidget(
      {Key? key,
      required this.customFunctionOnTap,
      this.customFunctionOnHover,
      required this.ticketCountLeft,
      required this.ticketCountAll,
      required this.ticketTitle,
      required this.ticketDescription,
      required this.ticketStartDate,
      required this.ticketEndDate,
      required this.ticketDateLeft})
      : super(key: key);

  @override
  State<TicketWidget> createState() => _TicketWidgetState();
}

class _TicketWidgetState extends State<TicketWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 280,
      height: 140,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 1, color: Palette.buttonOrange)),
        child: InkWell(
          onHover: (value) {
            widget.customFunctionOnHover ?? () {};
          },
          onTap: () {
            widget.customFunctionOnTap();
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("남은 횟수",
                          style:
                              TextStyle(color: Palette.gray66, fontSize: 12)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.ticketCountLeft}",
                            style: TextStyle(
                                color: Palette.textOrange,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    widget.ticketCountAll >= 100 ? 20 : 28),
                          ),
                          Text(
                            "/",
                            style: TextStyle(
                                color: Palette.textOrange,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    widget.ticketCountAll >= 100 ? 20 : 28),
                          ),
                          Text(
                            "${widget.ticketCountAll}",
                            style: TextStyle(
                                color: Palette.gray99,
                                fontSize:
                                    widget.ticketCountAll >= 100 ? 20 : 28),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                    width: 1, color: Palette.grayEE, height: double.infinity),
                Container(
                    width: 160,
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.ticketTitle}",
                            style: TextStyle(
                                color: Palette.gray00,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        SizedBox(height: 5),
                        Text(
                          "${widget.ticketDescription}",
                          style: TextStyle(fontSize: 12, color: Palette.gray66),
                        ),
                        SizedBox(height: 5),
                        Text("시작일: ${widget.ticketStartDate}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            )),
                        Row(
                          children: [
                            Text("종료일: ${widget.ticketEndDate}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                )),
                            Text(
                              " (D-${widget.ticketDateLeft})",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color:
                                      true ? Palette.textRed : Palette.gray66),
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
