import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:web_project/app/ui/ticketLibraryMake.dart';

import 'color.dart';

/// 티켓 위젯
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

  const TicketWidget(
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
  bool _toggle = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
                width: 2,
                color: ticketCountLeft == 0
                    ? Palette.grayEE
                    : Palette.backgroundOrange)),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTapDown: (details) {
            setState(() {
              _toggle = true;
            });
          },
          onTapUp: (details) {
            setState(() {
              _toggle = false;
            });
          },
          onHover: (value) {
            widget.customFunctionOnHover ?? () {};
          },
          onTap: () {
            widget.customFunctionOnTap();
          },
          child: Container(
            width: 280,
            height: 140,
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
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
                                color: ticketCountLeft == 0
                                    ? Palette.gray99
                                    : Palette.textOrange,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    widget.ticketCountAll >= 100 ? 20 : 28),
                          ),
                          Text(
                            "/",
                            style: TextStyle(
                                color: ticketCountLeft == 0
                                    ? Palette.gray99
                                    : Palette.textOrange,
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
                        SizedBox(height: 10),
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
                                  color: widget.ticketDateLeft <= 7
                                      ? Palette.textRed
                                      : Palette.gray66),
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ).animate(target: _toggle ? 0.5 : 0).scaleXY(end: 0.9),
    );
  }
}

/// 티켓 추가하기 버튼 위젯
class AddTicketWidget extends StatefulWidget {
  final Function customFunctionOnTap;

  const AddTicketWidget({
    Key? key,
    required this.customFunctionOnTap,
  }) : super(key: key);

  @override
  State<AddTicketWidget> createState() => _AddTicketWidgetState();
}

class _AddTicketWidgetState extends State<AddTicketWidget> {
  bool _toggle = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 2, color: Palette.grayEE)),
        child: InkWell(
          onTapDown: (details) {
            setState(() {
              _toggle = true;
            });
          },
          onTapUp: (details) {
            setState(() {
              _toggle = false;
            });
          },
          onHover: (value) {
            print("수강권 추가 onHover!!");
          },
          onTap: () {
            widget.customFunctionOnTap();
          },
          child: Container(
            width: 280,
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "수강권 추가하기",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Palette.gray99),
                ),
                Icon(
                  Icons.add_circle_outline,
                  color: Palette.gray99,
                )
              ],
            ),
          ),
        ),
      ).animate(target: _toggle ? 0.5 : 0).scaleXY(end: 0.9),
    );
  }
}
