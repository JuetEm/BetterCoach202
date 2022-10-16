import 'package:flutter/material.dart';

import 'globalWidget.dart';

class ActionSelector extends StatefulWidget {
  const ActionSelector({super.key});

  @override
  State<ActionSelector> createState() => _ActionSelectorState();
}

class _ActionSelectorState extends State<ActionSelector> {
  bool isReformerSelected = false;
  bool isCadillacSelected = false;
  bool isChairSelected = false;
  bool isLadderBarrelSelected = false;
  bool isSpringBoardSelected = false;
  bool isSpineCorrectorSelected = false;
  bool isMatSelected = false;

  @override
  Widget build(BuildContext context) {
    final chips = [
      FilterChip(
        label: Text("CADILLAC"),
        selected: isCadillacSelected,
        onSelected: (value) {
          setState(
            () {
              isCadillacSelected = !isCadillacSelected;
            },
          );
        },
      ),
      FilterChip(
        label: Text("REFORMER"),
        selected: isReformerSelected,
        onSelected: (value) {
          setState(
            () {
              isReformerSelected = !isReformerSelected;
            },
          );
        },
      ),
      FilterChip(
        label: Text("CHAIR"),
        selected: isChairSelected,
        onSelected: (value) {
          setState(
            () {
              isChairSelected = !isChairSelected;
            },
          );
        },
      ),
      FilterChip(
        label: Text("LADDER BARREL"),
        selected: isLadderBarrelSelected,
        onSelected: (value) {
          setState(
            () {
              isLadderBarrelSelected = !isLadderBarrelSelected;
            },
          );
        },
      ),
      FilterChip(
        label: Text("SPRING BOARD"),
        selected: isSpringBoardSelected,
        onSelected: (value) {
          setState(
            () {
              isSpringBoardSelected = !isSpringBoardSelected;
            },
          );
        },
      ),
      FilterChip(
        label: Text("SPINE CORRECTOR"),
        selected: isSpineCorrectorSelected,
        onSelected: (value) {
          setState(
            () {
              isSpineCorrectorSelected = !isSpineCorrectorSelected;
            },
          );
        },
      ),
      FilterChip(
        label: Text("MAT"),
        selected: isMatSelected,
        onSelected: (value) {
          setState(
            () {
              isMatSelected = !isMatSelected;
            },
          );
        },
      ),
    ];

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: Scaffold(
        appBar: BaseAppBarMethod(context, "동작선택", null),
        body: Center(
          child: Wrap(
            children: [
              for (final chip in chips)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: chip,
                ),
            ],
          ),
        ),
        // bottomNavigationBar: BaseBottomAppBar(),
      ),
    );
  }
}
