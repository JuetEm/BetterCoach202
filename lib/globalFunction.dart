import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'action_service.dart';
import 'baseTableCalendar.dart';
import 'bottomSheetContent.dart';

class GlobalFunction {
  GlobalFunction();

  void showBottomSheetContent(BuildContext context,
      {Function? customEditFunction, Function? customDeleteFunction}) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (context) {
        return BottomSheetContent(
          customEditFunction: customEditFunction,
          customDeleteFunction: customDeleteFunction,
        );
      },
    );
  }

  void inititalizeBools(List<bool> boolList, bool initState) {
    for (int i = 0; i < boolList.length; i++) {
      boolList[i] = initState;
    }
  }

  void clearTextEditController(List<TextEditingController> controllerList) {
    for (int i = 0; i < controllerList.length; i++) {
      controllerList[i].clear();
    }
  }

  getWidgetSize(GlobalKey key) {
    if (key.currentContext != null) {
      final RenderBox renderBox =
          key.currentContext!.findRenderObject() as RenderBox;

      Size size = renderBox.size;
      return size;
    }
  }

  bool textNullCheck(
    BuildContext context,
    TextEditingController checkController,
    String controllerName,
  ) {
    bool notEmpty = true;
    if (!checkController.text.isNotEmpty) {
      print("${controllerName} is Empty");
      notEmpty = !notEmpty;

      // 로그인 성공
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${controllerName} 항목을 입력 해주세요."),
      ));
    }

    return notEmpty;
  }

  void getDateFromCalendar(BuildContext context,
      TextEditingController customController, String pageName) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BaseTableCalendar(
            pageName: pageName,
            eventList: [],
          ),
          fullscreenDialog: true,
        ));

    if (!(result == null)) {
      String formatedDate = DateFormat("yyyy-MM-dd")
          .format(DateTime(result.year, result.month, result.day));

      customController.text = formatedDate;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${pageName} : ${formatedDate}"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${pageName}을 선택해주세요."),
      ));
    }
  }

  void createDummy(ActionService actionService) {
    actionService.create(
        "MAT", "supine", "Ab Prep", "김주아", "Ab Prep", "Ab Prep");
    actionService.create(
        "MAT", "sitting", "Abs Series", "김주아", "Abs Series", "Abs Series");
    actionService.create("RE", "supine", "Adductor Stretch", "김주아",
        "Adductor Stretch", "Adductor Stretch");
    actionService.create(
        "CA", "supine", "Airplane", "김주아", "Airplane", "Airplane");
    actionService.create(
        "RE", "kneeling", "Arm Circles", "김주아", "Arm Circles", "Arm Circles");
    actionService.create(
        "CH", "standing", "Arm Frog", "김주아", "Arm Frog", "Arm Frog");
    actionService.create(
        "CA", "sitting", "Back Rowing", "김주아", "Back Rowing", "Back Rowing");
    actionService.create("RE", "sitting", "Back Rowing Prep", "김주아",
        "Back Rowing Prep", "Back Rowing Prep");
    actionService.create("CA", "sitting", "Back Rowing Prep Series", "김주아",
        "Back Rowing Prep Series", "Back Rowing Prep Series");
    actionService.create("RE", "sitting", "Balance Control Back", "김주아",
        "Balance Control Back", "Balance Control Back");
    actionService.create("RE", "plank", "Balance Control Front", "김주아",
        "Balance Control Front", "Balance Control Front");
    actionService.create("MAT", "sitting", "Balance Point", "김주아",
        "Balance Point", "Balance Point");
    actionService.create("BA", "standing", "Ballet Stretch", "김주아",
        "Ballet Stretch", "Ballet Stretch");
    actionService.create(
        "RE", "supine", "Bend&Stretch", "김주아", "Bend&Stretch", "Bend&Stretch");
    actionService.create(
        "MAT", "sitting", "Boomerang", "김주아", "Boomerang", "Boomerang");
    actionService.create("MAT", "prone", "Breast Stroke", "김주아",
        "Breast Stroke", "Breast Stroke");
    actionService.create(
        "MAT", "supine", "Breathing", "김주아", "Breathing", "Breathing");
    actionService.create(
        "CA", "supine", "Breathing", "김주아", "Breathing", "Breathing");
    actionService.create(
        "MAT", "quadruped", "Cat Stretch", "김주아", "Cat Stretch", "Cat Stretch");
    actionService.create("RE", "kneeling", "Chest Expansion", "김주아",
        "Chest Expansion", "Chest Expansion");
    actionService.create(
        "MAT", "side lying", "Clam Shell", "김주아", "Clam Shell", "Clam Shell");
    actionService.create("MAT", "supine", "Control Balance", "김주아",
        "Control Balance", "Control Balance");
    actionService.create(
        "RE", "supine", "Coordination", "김주아", "Coordination", "Coordination");
    actionService.create(
        "MAT", "supine", "Corkscrew", "김주아", "Corkscrew", "Corkscrew");
    actionService.create(
        "RE", "supine", "Corscrew", "김주아", "Corscrew", "Corscrew");
    actionService.create("MAT", "sitting", "Crab", "김주아", "Crab", "Crab");
    actionService.create(
        "MAT", "supine", "Criss Cross", "김주아", "Criss Cross", "Criss Cross");
    actionService.create("MAT", "prone", "Double Leg Kicks", "김주아",
        "Double Leg Kicks", "Double Leg Kicks");
    actionService.create("MAT", "supine", "Double Leg Stretch", "김주아",
        "Double Leg Stretch", "Double Leg Stretch");
    actionService.create("RE", "quadruped", "Down Stretch", "김주아",
        "Down Stretch", "Down Stretch");
    actionService.create(
        "RE", "standing", "Elephant", "김주아", "Elephant", "Elephant");
    actionService.create("RE", "supine", "Footwork Series", "김주아",
        "Footwork Series", "Footwork Series");
    actionService.create("CH", "sitting", "Footwork Series", "김주아",
        "Footwork Series", "Footwork Series");
    actionService.create("RE", "supine", "Frog", "김주아", "Frog", "Frog");
    actionService.create("MAT", "prone", "Frog Hip Extension", "김주아",
        "Frog Hip Extension", "Frog Hip Extension");
    actionService.create(
        "CA", "sitting", "Front Rowing", "김주아", "Front Rowing", "Front Rowing");
    actionService.create("RE", "sitting", "Front Rowing Prep", "김주아",
        "Front Rowing Prep", "Front Rowing Prep");
    actionService.create("CA", "sitting", "Front Rowing Prep Series", "김주아",
        "Front Rowing Prep Series", "Front Rowing Prep Series");
    actionService.create(
        "RE", "standing", "Front Split", "김주아", "Front Split", "Front Split");
    actionService.create(
        "CA", "supine", "Full Hanging", "김주아", "Full Hanging", "Full Hanging");
    actionService.create(
        "CA", "prone", "Full Swan", "김주아", "Full Swan", "Full Swan");
    actionService.create("CH", "standing", "Going Up Front", "김주아",
        "Going Up Front", "Going Up Front");
    actionService.create("CH", "standing", "Going Up Side", "김주아",
        "Going Up Side", "Going Up Side");
    actionService.create(
        "CA", "supine", "Half Hanging", "김주아", "Half Hanging", "Half Hanging");
    actionService.create("MAT", "sitting", "Half Roll Back", "김주아",
        "Half Roll Back", "Half Roll Back");
    actionService.create(
        "MAT", "prone", "Half Swan", "김주아", "Half Swan", "Half Swan");
    actionService.create("CH", "supine", "Hams Press Hips Down", "김주아",
        "Hams Press Hips Down", "Hams Press Hips Down");
    actionService.create("CH", "supine", "Hams Press Hips Up", "김주아",
        "Hams Press Hips Up", "Hams Press Hips Up");
    actionService.create("CA", "standing", "Hanging Pull Ups", "김주아",
        "Hanging Pull Ups", "Hanging Pull Ups");
    actionService.create(
        "MAT", "supine", "High Bicycle", "김주아", "High Bicycle", "High Bicycle");
    actionService.create("MAT", "supine", "High Scissors", "김주아",
        "High Scissors", "High Scissors");
    actionService.create(
        "MAT", "sitting", "Hip Circles", "김주아", "Hip Circles", "Hip Circles");
    actionService.create(
        "CA", "side lying", "Hip Opener", "김주아", "Hip Opener", "Hip Opener");
    actionService.create(
        "MAT", "supine", "Hip Release", "김주아", "Hip Release", "Hip Release");
    actionService.create(
        "MAT", "supine", "Hip Roll", "김주아", "Hip Roll", "Hip Roll");
    actionService.create(
        "CH", "sitting", "Horse Back", "김주아", "Horse Back", "Horse Back");
    actionService.create(
        "BA", "sitting", "Horse Back", "김주아", "Horse Back", "Horse Back");
    actionService.create(
        "MAT", "supine", "Hundred", "김주아", "Hundred", "Hundred");
    actionService.create(
        "RE", "supine", "Hundred", "김주아", "Hundred", "Hundred");
    actionService.create("MAT", "supine", "Imprinting Transition", "김주아",
        "Imprinting Transition", "Imprinting Transition");
    actionService.create(
        "MAT", "supine", "Jack Knife", "김주아", "Jack Knife", "Jack Knife");
    actionService.create(
        "CH", "supine", "Jack Knife", "김주아", "Jack Knife", "Jack Knife");
    actionService.create("CH", "standing", "Knee Raise Series", "김주아",
        "Knee Raise Series", "Knee Raise Series");
    actionService.create("RE", "quadruped", "Knee Stretch Arches", "김주아",
        "Knee Stretch Arches", "Knee Stretch Arches");
    actionService.create("RE", "quadruped", "Knee Stretch Knees Off", "김주아",
        "Knee Stretch Knees Off", "Knee Stretch Knees Off");
    actionService.create("RE", "quadruped", "Knee Stretch Round", "김주아",
        "Knee Stretch Round", "Knee Stretch Round");
    actionService.create("RE", "quadruped", "Knee Stretch Series", "김주아",
        "Knee Stretch Series", "Knee Stretch Series");
    actionService.create("CA", "kneeling", "Kneeling Ballet Stretches", "김주아",
        "Kneeling Ballet Stretches", "Kneeling Ballet Stretches");
    actionService.create("CA", "kneeling", "Kneeling Cat", "김주아",
        "Kneeling Cat", "Kneeling Cat");
    actionService.create("CA", "kneeling", "Kneeling Chest Expansion", "김주아",
        "Kneeling Chest Expansion", "Kneeling Chest Expansion");
    actionService.create("CH", "kneeling", "Kneeling Mermaid", "김주아",
        "Kneeling Mermaid", "Kneeling Mermaid");
    actionService.create("MAT", "kneeling", "Kneeling Side Kick", "김주아",
        "Kneeling Side Kick", "Kneeling Side Kick");
    actionService.create("CH", "kneeling", "Kneeling Side Kicks", "김주아",
        "Kneeling Side Kicks", "Kneeling Side Kicks");
    actionService.create(
        "BA", "standing", "Lay Backs", "김주아", "Lay Backs", "Lay Backs");
    actionService.create(
        "RE", "supine", "Leg Circles", "김주아", "Leg Circles", "Leg Circles");
    actionService.create("MAT", "plank", "Leg Pull Back", "김주아",
        "Leg Pull Back", "Leg Pull Back");
    actionService.create("MAT", "plank", "Leg Pull Front", "김주아",
        "Leg Pull Front", "Leg Pull Front");
    actionService.create("CA", "supine", "Leg Spring Series", "김주아",
        "Leg Spring Series", "Leg Spring Series");
    actionService.create("CA", "side lying", "Leg Spring Side Kick Series",
        "김주아", "Leg Spring Side Kick Series", "Leg Spring Side Kick Series");
    actionService.create("RE", "supine", "Leg Strap Series", "김주아",
        "Leg Strap Series", "Leg Strap Series");
    actionService.create("RE", "sitting", "Long Back Stretch", "김주아",
        "Long Back Stretch", "Long Back Stretch");
    actionService.create("RE", "prone", "Long Box Backstroke", "김주아",
        "Long Box Backstroke", "Long Box Backstroke");
    actionService.create("RE", "prone", "Long Box Horse Back", "김주아",
        "Long Box Horse Back", "Long Box Horse Back");
    actionService.create("RE", "prone", "Long Box Pulling Straps", "김주아",
        "Long Box Pulling Straps", "Long Box Pulling Straps");
    actionService.create("RE", "prone", "Long Box Series", "김주아",
        "Long Box Series", "Long Box Series");
    actionService.create("RE", "prone", "Long Box T Shape", "김주아",
        "Long Box T Shape", "Long Box T Shape");
    actionService.create("RE", "prone", "Long Box Teaser", "김주아",
        "Long Box Teaser", "Long Box Teaser");
    actionService.create("RE", "supine", "Long Spine Massage", "김주아",
        "Long Spine Massage", "Long Spine Massage");
    actionService.create(
        "RE", "plank", "Long Stretch", "김주아", "Long Stretch", "Long Stretch");
    actionService.create("RE", "plank", "Long Stretch Series", "김주아",
        "Long Stretch Series", "Long Stretch Series");
    actionService.create("MAT", "supine", "Lower And Lift", "김주아",
        "Lower And Lift", "Lower And Lift");
    actionService.create("RE", "supine", "Lower And Lift", "김주아",
        "Lower And Lift", "Lower And Lift");
    actionService.create("CH", "standing", "Lunge", "김주아", "Lunge", "Lunge");
    actionService.create(
        "MAT", "sitting", "Mermaid", "김주아", "Mermaid", "Mermaid");
    actionService.create(
        "CA", "sitting", "Mermaid", "김주아", "Mermaid", "Mermaid");
    actionService.create(
        "CH", "sitting", "Mermaid", "김주아", "Mermaid", "Mermaid");
    actionService.create("CA", "supine", "Midback Series", "김주아",
        "Midback Series", "Midback Series");
    actionService.create("CA", "supine", "Monkey", "김주아", "Monkey", "Monkey");
    actionService.create("CH", "standing", "Mountain Climb", "김주아",
        "Mountain Climb", "Mountain Climb");
    actionService.create(
        "MAT", "sitting", "Neck Pull", "김주아", "Neck Pull", "Neck Pull");
    actionService.create("CH", "prone", "One Arm Press", "김주아", "One Arm Press",
        "One Arm Press");
    actionService.create("MAT", "sitting", "Open Leg Rocker", "김주아",
        "Open Leg Rocker", "Open Leg Rocker");
    actionService.create(
        "RE", "supine", "Overhead", "김주아", "Overhead", "Overhead");
    actionService.create(
        "CA", "supine", "Parakeet", "김주아", "Parakeet", "Parakeet");
    actionService.create(
        "RE", "supine", "Pelvic Lift", "김주아", "Pelvic Lift", "Pelvic Lift");
    actionService.create("MAT", "supine", "Pelvic Movement", "김주아",
        "Pelvic Movement", "Pelvic Movement");
    actionService.create(
        "CA", "sitting", "Port De Bras", "김주아", "Port De Bras", "Port De Bras");
    actionService.create("CH", "sitting", "Press Down Teaser", "김주아",
        "Press Down Teaser", "Press Down Teaser");
    actionService.create("MAT", "prone", "Prone Heel Squeeze", "김주아",
        "Prone Heel Squeeze", "Prone Heel Squeeze");
    actionService.create("MAT", "prone", "Prone Leg Lift Series", "김주아",
        "Prone Leg Lift Series", "Prone Leg Lift Series");
    actionService.create("BA", "prone", "Prone Leg Lift Series", "김주아",
        "Prone Leg Lift Series", "Prone Leg Lift Series");
    actionService.create(
        "CH", "standing", "Pull Up", "김주아", "Pull Up", "Pull Up");
    actionService.create(
        "CH", "standing", "Push Down", "김주아", "Push Down", "Push Down");
    actionService.create("CH", "standing", "Push Down With One Arm", "김주아",
        "Push Down With One Arm", "Push Down With One Arm");
    actionService.create(
        "CA", "sitting", "Push Through", "김주아", "Push Through", "Push Through");
    actionService.create("CA", "supine", "Push Thru With Feet", "김주아",
        "Push Thru With Feet", "Push Thru With Feet");
    actionService.create(
        "MAT", "plank", "Push Ups", "김주아", "Push Ups", "Push Ups");
    actionService.create(
        "MAT", "prone", "Rocking", "김주아", "Rocking", "Rocking");
    actionService.create("CA", "sitting", "Roll Back Bar", "김주아",
        "Roll Back Bar", "Roll Back Bar");
    actionService.create("CA", "sitting", "Roll Back With One Arm", "김주아",
        "Roll Back With One Arm", "Roll Back With One Arm");
    actionService.create(
        "CA", "sitting", "Roll Down", "김주아", "Roll Down", "Roll Down");
    actionService.create("BA", "sitting", "Roll Down Round", "김주아",
        "Roll Down Round", "Roll Down Round");
    actionService.create("BA", "sitting", "Roll Down Straight", "김주아",
        "Roll Down Straight", "Roll Down Straight");
    actionService.create(
        "MAT", "supine", "Roll Over", "김주아", "Roll Over", "Roll Over");
    actionService.create(
        "CH", "supine", "Roll Over", "김주아", "Roll Over", "Roll Over");
    actionService.create(
        "CA", "supine", "Roll Up", "김주아", "Roll Up", "Roll Up");
    actionService.create("MAT", "sitting", "Rolling Like A Ball", "김주아",
        "Rolling Like A Ball", "Rolling Like A Ball");
    actionService.create("RE", "sitting", "Rowing 90 Degrees", "김주아",
        "Rowing 90 Degrees", "Rowing 90 Degrees");
    actionService.create("RE", "sitting", "Rowing From The Chest", "김주아",
        "Rowing From The Chest", "Rowing From The Chest");
    actionService.create("RE", "sitting", "Rowing From The Hips", "김주아",
        "Rowing From The Hips", "Rowing From The Hips");
    actionService.create("RE", "sitting", "Rowing Hug The Tree", "김주아",
        "Rowing Hug The Tree", "Rowing Hug The Tree");
    actionService.create("RE", "sitting", "Rowing Into The Sternum", "김주아",
        "Rowing Into The Sternum", "Rowing Into The Sternum");
    actionService.create("RE", "sitting", "Rowing Salute", "김주아",
        "Rowing Salute", "Rowing Salute");
    actionService.create("RE", "sitting", "Rowing Series", "김주아",
        "Rowing Series", "Rowing Series");
    actionService.create(
        "RE", "sitting", "Rowing Shave", "김주아", "Rowing Shave", "Rowing Shave");
    actionService.create(
        "RE", "supine", "Running", "김주아", "Running", "Running");
    actionService.create("RE", "standing", "Russian Split", "김주아",
        "Russian Split", "Russian Split");
    actionService.create("MAT", "sitting", "Saw", "김주아", "Saw", "Saw");
    actionService.create("CH", "prone", "Scapula Isolation", "김주아",
        "Scapula Isolation", "Scapula Isolation");
    actionService.create("MAT", "supine", "Scapula Movement", "김주아",
        "Scapula Movement", "Scapula Movement");
    actionService.create(
        "MAT", "supine", "Scissors", "김주아", "Scissors", "Scissors");
    actionService.create("MAT", "sitting", "Seal", "김주아", "Seal", "Seal");
    actionService.create(
        "RE", "supine", "Semi-Circle", "김주아", "Semi-Circle", "Semi-Circle");
    actionService.create("RE", "sitting", "Short Box Round", "김주아",
        "Short Box Round", "Short Box Round");
    actionService.create("RE", "sitting", "Short Box Series", "김주아",
        "Short Box Series", "Short Box Series");
    actionService.create("BA", "sitting", "Short Box Series", "김주아",
        "Short Box Series", "Short Box Series");
    actionService.create("RE", "sitting", "Short Box Side", "김주아",
        "Short Box Side", "Short Box Side");
    actionService.create("RE", "sitting", "Short Box Straight", "김주아",
        "Short Box Straight", "Short Box Straight");
    actionService.create("RE", "sitting", "Short Box Tree", "김주아",
        "Short Box Tree", "Short Box Tree");
    actionService.create("RE", "sitting", "Short Box Twist", "김주아",
        "Short Box Twist", "Short Box Twist");
    actionService.create("RE", "sitting", "Short Box Twist And Reach", "김주아",
        "Short Box Twist And Reach", "Short Box Twist And Reach");
    actionService.create("RE", "supine", "Short Spine Massage", "김주아",
        "Short Spine Massage", "Short Spine Massage");
    actionService.create("CA", "supine", "Shoulder And Chest Opener", "김주아",
        "Shoulder And Chest Opener", "Shoulder And Chest Opener");
    actionService.create("MAT", "supine", "Shoulder Bridge", "김주아",
        "Shoulder Bridge", "Shoulder Bridge");
    actionService.create("CA", "sitting", "Side Arm Sitting", "김주아",
        "Side Arm Sitting", "Side Arm Sitting");
    actionService.create(
        "MAT", "sitting", "Side Bend", "김주아", "Side Bend", "Side Bend");
    actionService.create(
        "CA", "side lying", "Side Bend", "김주아", "Side Bend", "Side Bend");
    actionService.create(
        "BA", "standing", "Side Bend", "김주아", "Side Bend", "Side Bend");
    actionService.create("MAT", "supine", "Side Kick Beats", "김주아",
        "Side Kick Beats", "Side Kick Beats");
    actionService.create("MAT", "side lying", "Side Kick Bicycle", "김주아",
        "Side Kick Bicycle", "Side Kick Bicycle");
    actionService.create("MAT", "side lying", "Side Kick Big Circles", "김주아",
        "Side Kick Big Circles", "Side Kick Big Circles");
    actionService.create("MAT", "side lying", "Side Kick Big Scissors", "김주아",
        "Side Kick Big Scissors", "Side Kick Big Scissors");
    actionService.create("MAT", "side lying", "Side Kick Developpe", "김주아",
        "Side Kick Developpe", "Side Kick Developpe");
    actionService.create("MAT", "side lying", "Side Kick Front Back", "김주아",
        "Side Kick Front Back", "Side Kick Front Back");
    actionService.create("MAT", "side lying", "Side Kick Hot Potato", "김주아",
        "Side Kick Hot Potato", "Side Kick Hot Potato");
    actionService.create("MAT", "side lying", "Side Kick Inner Thigh", "김주아",
        "Side Kick Inner Thigh", "Side Kick Inner Thigh");
    actionService.create("MAT", "side lying", "Side Kick Series", "김주아",
        "Side Kick Series", "Side Kick Series");
    actionService.create("MAT", "side lying", "Side Kick Small Circles", "김주아",
        "Side Kick Small Circles", "Side Kick Small Circles");
    actionService.create("MAT", "side lying", "Side Kick Up Down", "김주아",
        "Side Kick Up Down", "Side Kick Up Down");
    actionService.create("BA", "side lying", "Side Leg Lift", "김주아",
        "Side Leg Lift", "Side Leg Lift");
    actionService.create("BA", "side lying", "Side Lying Stretch", "김주아",
        "Side Lying Stretch", "Side Lying Stretch");
    actionService.create(
        "BA", "standing", "Side Sit Up", "김주아", "Side Sit Up", "Side Sit Up");
    actionService.create(
        "RE", "standing", "Side Split", "김주아", "Side Split", "Side Split");
    actionService.create("MAT", "supine", "Single Leg Circles", "김주아",
        "Single Leg Circles", "Single Leg Circles");
    actionService.create("MAT", "prone", "Single Leg Kicks", "김주아",
        "Single Leg Kicks", "Single Leg Kicks");
    actionService.create("CH", "sitting", "Single Leg Press", "김주아",
        "Single Leg Press", "Single Leg Press");
    actionService.create("MAT", "supine", "Single Leg Stretch", "김주아",
        "Single Leg Stretch", "Single Leg Stretch");
    actionService.create("CH", "sitting", "Sitthing Triceps Press", "김주아",
        "Sitthing Triceps Press", "Sitthing Triceps Press");
    actionService.create(
        "CA", "sitting", "Sitting Cat", "김주아", "Sitting Cat", "Sitting Cat");
    actionService.create("BA", "sitting", "Sitting Leg Series", "김주아",
        "Sitting Leg Series", "Sitting Leg Series");
    actionService.create("RE", "standing", "Snake", "김주아", "Snake", "Snake");
    actionService.create("MAT", "sitting", "Spine Stretch Forward", "김주아",
        "Spine Stretch Forward", "Spine Stretch Forward");
    actionService.create("CH", "sitting", "Spine Stretch Forward", "김주아",
        "Spine Stretch Forward", "Spine Stretch Forward");
    actionService.create(
        "MAT", "sitting", "Spine Twist", "김주아", "Spine Twist", "Spine Twist");
    actionService.create("CA", "standing", "Spread Eagle", "김주아",
        "Spread Eagle", "Spread Eagle");
    actionService.create("CA", "standing", "Squat", "김주아", "Squat", "Squat");
    actionService.create("CA", "standing", "Standing Ballet Stretches", "김주아",
        "Standing Ballet Stretches", "Standing Ballet Stretches");
    actionService.create("CA", "standing", "Standing Cat", "김주아",
        "Standing Cat", "Standing Cat");
    actionService.create("CA", "standing", "Standing Chest Expansion", "김주아",
        "Standing Chest Expansion", "Standing Chest Expansion");
    actionService.create("BA", "standing", "Standing Roll Back", "김주아",
        "Standing Roll Back", "Standing Roll Back");
    actionService.create("CH", "standing", "Standing Roll Down", "김주아",
        "Standing Roll Down", "Standing Roll Down");
    actionService.create("BA", "standing", "Standing Side Leg Lift", "김주아",
        "Standing Side Leg Lift", "Standing Side Leg Lift");
    actionService.create("CH", "standing", "Standing Single Leg Press", "김주아",
        "Standing Single Leg Press", "Standing Single Leg Press");
    actionService.create("CA", "standing", "Standing Spred Eagle", "김주아",
        "Standing Spred Eagle", "Standing Spred Eagle");
    actionService.create("RE", "sitting", "Stomach Massage Reach Up", "김주아",
        "Stomach Massage Reach Up", "Stomach Massage Reach Up");
    actionService.create("RE", "sitting", "Stomach Massage Round", "김주아",
        "Stomach Massage Round", "Stomach Massage Round");
    actionService.create("RE", "sitting", "Stomach Massage Series", "김주아",
        "Stomach Massage Series", "Stomach Massage Series");
    actionService.create("RE", "sitting", "Stomach Massage Straight", "김주아",
        "Stomach Massage Straight", "Stomach Massage Straight");
    actionService.create("RE", "sitting", "Stomach Massage Twist", "김주아",
        "Stomach Massage Twist", "Stomach Massage Twist");
    actionService.create("MAT", "prone", "Swan", "김주아", "Swan", "Swan");
    actionService.create("RE", "prone", "Swan", "김주아", "Swan", "Swan");
    actionService.create("CA", "prone", "Swan", "김주아", "Swan", "Swan");
    actionService.create("BA", "prone", "Swan", "김주아", "Swan", "Swan");
    actionService.create(
        "MAT", "prone", "Swan Dive", "김주아", "Swan Dive", "Swan Dive");
    actionService.create(
        "CH", "prone", "Swan Dive", "김주아", "Swan Dive", "Swan Dive");
    actionService.create(
        "BA", "prone", "Swan Dive", "김주아", "Swan Dive", "Swan Dive");
    actionService.create("CH", "prone", "Swan Dive From Floor", "김주아",
        "Swan Dive From Floor", "Swan Dive From Floor");
    actionService.create("BA", "standing", "Swedish Bar Stretch", "김주아",
        "Swedish Bar Stretch", "Swedish Bar Stretch");
    actionService.create(
        "MAT", "prone", "Swimming", "김주아", "Swimming", "Swimming");
    actionService.create("MAT", "supine", "Teaser", "김주아", "Teaser", "Teaser");
    actionService.create("CA", "supine", "Teaser", "김주아", "Teaser", "Teaser");
    actionService.create("RE", "standing", "Tendon Stretch", "김주아",
        "Tendon Stretch", "Tendon Stretch");
    actionService.create("CH", "standing", "Tendon Stretch", "김주아",
        "Tendon Stretch", "Tendon Stretch");
    actionService.create(
        "MAT", "supine", "The Hundred", "김주아", "The Hundred", "The Hundred");
    actionService.create(
        "MAT", "supine", "The Roll Up", "김주아", "The Roll Up", "The Roll Up");
    actionService.create("MAT", "kneeling", "Thigh Stretch", "김주아",
        "Thigh Stretch", "Thigh Stretch");
    actionService.create("RE", "kneeling", "Thigh Stretch", "김주아",
        "Thigh Stretch", "Thigh Stretch");
    actionService.create("CA", "kneeling", "Thigh Stretch", "김주아",
        "Thigh Stretch", "Thigh Stretch");
    actionService.create(
        "MAT", "supine", "Toe Tap", "김주아", "Toe Tap", "Toe Tap");
    actionService.create("CA", "supine", "Tower", "김주아", "Tower", "Tower");
    actionService.create("CH", "prone", "Triceps", "김주아", "Triceps", "Triceps");
    actionService.create("RE", "standing", "Twist", "김주아", "Twist", "Twist");
    actionService.create(
        "RE", "standing", "Up Stretch", "김주아", "Up Stretch", "Up Stretch");
    actionService.create("CA", "supine", "Upper Abs Curl", "김주아",
        "Upper Abs Curl", "Upper Abs Curl");

    // actionService.create("MAT", "supine", "Hundred", "HUNDRED", "hundred");
    // actionService.create("MAT", "supine", "Roll Up", "ROLL UP", "roll up");
    // actionService.create(
    //     "MAT", "supine", "Roll Over", "ROLL OVER", "roll over");
    // actionService.create("MAT", "supine", "Single Leg Circles",
    //     "SINGLE LEG CIRCLES", "single leg circles");
    // actionService.create("MAT", "supine", "Rolling Like A Ball",
    //     "ROLLING LIKE A BALL", "rolling like a ball");
    // actionService.create("MAT", "supine", "Single Leg Stretch",
    //     "SINGLE LEG STRETCH", "single leg stretch");
    // actionService.create("MAT", "supine", "Double Leg Stretch",
    //     "DOUBLE LEG STRETCH", "double leg stretch");
    // actionService.create("MAT", "supine", "Scissors", "SCISSORS", "scissors");
    // actionService.create(
    //     "MAT", "supine", "Lower And Lift", "LOWER AND LIFT", "lower and lift");
    // actionService.create(
    //     "MAT", "supine", "Criss Cross", "CRISS CROSS", "criss cross");
    // actionService.create("MAT", "sitting", "Spine Stretch Forward",
    //     "SPINE STRETCH FORWARD", "spine stretch forward");
    // actionService.create("MAT", "sitting", "Open Leg Rocker", "OPEN LEG ROCKER",
    //     "open leg rocker");
    // actionService.create(
    //     "MAT", "supine", "Corkscrew", "CORKSCREW", "corkscrew");
    // actionService.create("MAT", "supine", "Saw", "SAW", "saw");
    // actionService.create("MAT", "prone", "Swan Dive", "SWAN DIVE", "swan dive");
    // actionService.create("MAT", "prone", "Single Leg Kicks", "SINGLE LEG KICKS",
    //     "single leg kicks");
    // actionService.create("MAT", "prone", "Double Leg Kicks", "DOUBLE LEG KICKS",
    //     "double leg kicks");
    // actionService.create(
    //     "MAT", "kneeling", "Thigh Stretch", "THIGH STRETCH", "thigh stretch");
    // actionService.create(
    //     "MAT", "sitting", "Neck Pull", "NECK PULL", "neck pull");
    // actionService.create(
    //     "MAT", "supine", "High Scissors", "HIGH SCISSORS", "high scissors");
    // actionService.create(
    //     "MAT", "supine", "High Bicycle", "HIGH BICYCLE", "high bicycle");
    // actionService.create("MAT", "supine", "Shoulder Bridge", "SHOULDER BRIDGE",
    //     "shoulder bridge");
    // actionService.create(
    //     "MAT", "sitting", "Spine Twist", "SPINE TWIST", "spine twist");
    // actionService.create(
    //     "MAT", "supine", "Jack Knife", "JACK KNIFE", "jack knife");
    // actionService.create("MAT", "side lying", "Side Kick Front&Back",
    //     "SIDE KICK FRONT&BACK", "side kick front&back");
    // actionService.create("MAT", "side lying", "Side Kick Up&Down",
    //     "SIDE KICK UP&DOWN", "side kick up&down");
    // actionService.create("MAT", "side lying", "Side Kick Small Circles",
    //     "SIDE KICK SMALL CIRCLES", "side kick small circles");
    // actionService.create("MAT", "side lying", "Side Kick Bicycle",
    //     "SIDE KICK BICYCLE", "side kick bicycle");
    // actionService.create("MAT", "side lying", "Side Kick Developpe",
    //     "SIDE KICK DEVELOPPE", "side kick developpe");
    // actionService.create("MAT", "side lying", "Side Kick Inner Thigh",
    //     "SIDE KICK INNER THIGH", "side kick inner thigh");
    // actionService.create("MAT", "side lying", "Side Kick Hot Potato",
    //     "SIDE KICK HOT POTATO", "side kick hot potato");
    // actionService.create("MAT", "side lying", "Side Kick Big Scissors",
    //     "SIDE KICK BIG SCISSORS", "side kick big scissors");
    // actionService.create("MAT", "side lying", "Side Kick Big Circles",
    //     "SIDE KICK BIG CIRCLES", "side kick big circles");
    // actionService.create("MAT", "supine", "Teaser 1", "TEASER 1", "teaser 1");
    // actionService.create(
    //     "MAT", "supine", "Teaser 2,3", "TEASER 2,3", "teaser 2,3");
    // actionService.create(
    //     "MAT", "sitting", "Hip Circles", "HIP CIRCLES", "hip circles");
    // actionService.create("MAT", "prone", "Swimming", "SWIMMING", "swimming");
    // actionService.create(
    //     "MAT", "prone", "Leg Pull Front", "LEG PULL FRONT", "leg pull front");
    // actionService.create(
    //     "MAT", "prone", "Leg Pull Back", "LEG PULL BACK", "leg pull back");
    // actionService.create("MAT", "kneeling", "Kneeling Side Kick",
    //     "KNEELING SIDE KICK", "kneeling side kick");
    // actionService.create(
    //     "MAT", "side lying", "Side Bend", "SIDE BEND", "side bend");
    // actionService.create(
    //     "MAT", "sitting", "Boomerang", "BOOMERANG", "boomerang");
    // actionService.create("MAT", "sitting", "Seal", "SEAL", "seal");
    // actionService.create("MAT", "kneeling", "Crab", "CRAB", "crab");
    // actionService.create("MAT", "prone", "Rocking", "ROCKING", "rocking");
    // actionService.create("MAT", "supine", "Control Balance", "CONTROL BALANCE",
    //     "control balance");
    // actionService.create("MAT", "standing", "Push Ups", "PUSH UPS", "push ups");
    // actionService.create("RE", "supine", "Footwork Series", "FOOTWORK SERIES",
    //     "footwork series");
    // actionService.create("RE", "supine", "Hundred", "HUNDRED", "hundred");
    // actionService.create("RE", "supine", "Overhead", "OVERHEAD", "overhead");
    // actionService.create(
    //     "RE", "supine", "Coordination", "COORDINATION", "coordination");
    // actionService.create("RE", "sitting", "Back Rowing Series",
    //     "BACK ROWING SERIES", "back rowing series");
    // actionService.create("RE", "sitting", "Front Rowing Series",
    //     "FRONT ROWING SERIES", "front rowing series");
    // actionService.create("RE", "prone", "Swan", "SWAN", "swan");
    // actionService.create("RE", "prone", "Long Box Pulling Strap",
    //     "LONG BOX PULLING STRAP", "long box pulling strap");
    // actionService.create("RE", "supine", "Long Box Backstroke",
    //     "LONG BOX BACKSTROKE", "long box backstroke");
    // actionService.create("RE", "supine", "Long Box Teaser", "LONG BOX TEASER",
    //     "long box teaser");
    // actionService.create("RE", "sitting", "Long Box Horseback",
    //     "LONG BOX HORSEBACK", "long box horseback");
    // actionService.create("RE", "sitting", "Short Box Series",
    //     "SHORT BOX SERIES", "short box series");
    // actionService.create(
    //     "RE", "prone", "Long Stretch", "LONG STRETCH", "long stretch");
    // actionService.create(
    //     "RE", "prone", "Down Stretch", "DOWN STRETCH", "down stretch");
    // actionService.create("RE", "standing", "Elephant", "ELEPHANT", "elephant");
    // actionService.create("RE", "sitting", "Long Back Stretch",
    //     "LONG BACK STRETCH", "long back stretch");
    // actionService.create("RE", "sitting", "Stomach Massage Series",
    //     "STOMACH MASSAGE SERIES", "stomach massage series");
    // actionService.create(
    //     "RE", "standing", "Tendon Stretch", "TENDON STRETCH", "tendon stretch");
    // actionService.create("RE", "supine", "Short Spine Massage",
    //     "SHORT SPINE MASSAGE", "short spine massage");
    // actionService.create(
    //     "RE", "supine", "Semi-Circle", "SEMI-CIRCLE", "semi-circle");
    // actionService.create("RE", "kneeling", "Chest Expansion", "CHEST EXPANSION",
    //     "chest expansion");
    // actionService.create(
    //     "RE", "kneeling", "Thigh Stretch", "THIGH STRETCH", "thigh stretch");
    // actionService.create(
    //     "RE", "kneeling", "Arm Circles", "ARM CIRCLES", "arm circles");
    // actionService.create(
    //     "RE", "standing", "Snake&Twist", "SNAKE&TWIST", "snake&twist");
    // actionService.create("RE", "supine", "Corkscrew", "CORKSCREW", "corkscrew");
    // actionService.create("RE", "supine", "Long Spine Massage",
    //     "LONG SPINE MASSAGE", "long spine massage");
    // actionService.create(
    //     "RE", "supine", "Leg Circles", "LEG CIRCLES", "leg circles");
    // actionService.create("RE", "supine", "Frog", "FROG", "frog");
    // actionService.create("RE", "kneeling", "Knee Stretch Series",
    //     "KNEE STRETCH SERIES", "knee stretch series");
    // actionService.create("RE", "supine", "Running", "RUNNING", "running");
    // actionService.create(
    //     "RE", "supine", "Pelvic Lift", "PELVIC LIFT", "pelvic lift");
    // actionService.create("RE", "prone", "Balance Control Front",
    //     "BALANCE CONTROL FRONT", "balance control front");
    // actionService.create("RE", "supine", "Balance Control Back",
    //     "BALANCE CONTROL BACK", "balance control back");
    // actionService.create(
    //     "RE", "standing", "Side Split", "SIDE SPLIT", "side split");
    // actionService.create(
    //     "RE", "standing", "Front Split", "FRONT SPLIT", "front split");
    // actionService.create(
    //     "RE", "standing", "Russian Split", "RUSSIAN SPLIT", "russian split");
    // actionService.create(
    //     "CA", "sitting", "Roll Down", "ROLL DOWN", "roll down");
    // actionService.create("CA", "sitting", "Roll Down With One Arm",
    //     "ROLL DOWN WITH ONE ARM", "roll down with one arm");
    // actionService.create("CA", "supine", "Airplane", "AIRPLANE", "airplane");
    // actionService.create("CA", "supine", "Breathing", "BREATHING", "breathing");
    // actionService.create("CA", "standing", "Standing Ballet Stretches",
    //     "STANDING BALLET STRETCHES", "standing ballet stretches");
    // actionService.create("CA", "kneeling", "Kneeling Ballet Stretches",
    //     "KNEELING BALLET STRETCHES", "kneeling ballet stretches");
    // actionService.create("CA", "supine", "Shoulder And Chest Opener",
    //     "SHOULDER AND CHEST OPENER", "shoulder and chest opener");
    // actionService.create("CA", "supine", "Teaser", "TEASER", "teaser");
    // actionService.create(
    //     "CA", "sitting", "Sitting Cat", "SITTING CAT", "sitting cat");
    // actionService.create(
    //     "CA", "kneeling", "Kneeling Cat", "KNEELING CAT", "kneeling cat");
    // actionService.create(
    //     "CA", "standing", "Standing Cat", "STANDING CAT", "standing cat");
    // actionService.create("CA", "prone", "Swan", "SWAN", "swan");
    // actionService.create("CA", "prone", "Full Swan", "FULL SWAN", "full swan");
    // actionService.create(
    //     "CA", "sitting", "Push Through", "PUSH THROUGH", "push through");
    // actionService.create("CA", "sitting", "Mermaid", "MERMAID", "mermaid");
    // actionService.create(
    //     "CA", "supine", "Midback Series", "MIDBACK SERIES", "midback series");
    // actionService.create("CA", "sitting", "Back Rowing Series",
    //     "BACK ROWING SERIES", "back rowing series");
    // actionService.create("CA", "sitting", "Front Rowing Series",
    //     "FRONT ROWING SERIES", "front rowing series");
    // actionService.create("CA", "standing", "Chest Expansion", "CHEST EXPANSION",
    //     "chest expansion");
    // actionService.create("CA", "supine", "Leg Spring Series",
    //     "LEG SPRING SERIES", "leg spring series");
    // actionService.create("CA", "side lying", "Leg Spring Side Lying",
    //     "LEG SPRING SIDE LYING", "leg spring side lying");
    // actionService.create(
    //     "CA", "side lying", "Side Bend", "SIDE BEND", "side bend");
    // actionService.create(
    //     "CA", "standing", "Spread Eagle", "SPREAD EAGLE", "spread eagle");
    // actionService.create("CA", "standing", "Hanging Pull Ups",
    //     "HANGING PULL UPS", "hanging pull ups");
    // actionService.create("CA", "supine", "Push Thru With Feet",
    //     "PUSH THRU WITH FEET", "push thru with feet");
    // actionService.create("CA", "supine", "Tower", "TOWER", "tower");
    // actionService.create("CA", "supine", "Monkey", "MONKEY", "monkey");
    // actionService.create(
    //     "CA", "side lying", "Hip Opener", "HIP OPENER", "hip opener");
    // actionService.create("CA", "standing", "Squat", "SQUAT", "squat");
    // actionService.create(
    //     "CA", "supine", "Half Hanging", "HALF HANGING", "half hanging");
    // actionService.create(
    //     "CA", "supine", "Full Hanging", "FULL HANGING", "full hanging");
    // actionService.create("CA", "supine", "Leg Spring Series",
    //     "LEG SPRING SERIES", "leg spring series");
    // actionService.create("CA", "kneeling", "Kneeling Chest Expansion",
    //     "KNEELING CHEST EXPANSION", "kneeling chest expansion");
    // actionService.create(
    //     "CA", "kneeling", "Thigh Stretch", "THIGH STRETCH", "thigh stretch");
    // actionService.create("CH", "sitting", "Footwork Series", "FOOTWORK SERIES",
    //     "footwork series");
    // actionService.create("CH", "sitting", "Single Leg Press",
    //     "SINGLE LEG PRESS", "single leg press");
    // actionService.create(
    //     "CH", "standing", "Push Down", "PUSH DOWN", "push down");
    // actionService.create("CH", "standing", "Pull Up", "PULL UP", "pull up");
    // actionService.create("CH", "standing", "Standing Single Leg Press",
    //     "STANDING SINGLE LEG PRESS", "standing single leg press");
    // actionService.create("CH", "sitting", "Spine Stretch Forward",
    //     "SPINE STRETCH FORWARD", "spine stretch forward");
    // actionService.create("CH", "sitting", "Press Down Teaser",
    //     "PRESS DOWN TEASER", "press down teaser");
    // actionService.create(
    //     "CH", "standing", "Going Up Front", "GOING UP FRONT", "going up front");
    // actionService.create(
    //     "CH", "standing", "Knee Raises", "KNEE RAISES", "knee raises");
    // actionService.create("CH", "prone", "Scapula Isolation Prone",
    //     "SCAPULA ISOLATION PRONE", "scapula isolation prone");
    // actionService.create("CH", "prone", "One Arm Push Prone",
    //     "ONE ARM PUSH PRONE", "one arm push prone");
    // actionService.create("CH", "sitting", "Triceps Press Sitting",
    //     "TRICEPS PRESS SITTING", "triceps press sitting");
    // actionService.create("CH", "standing", "Push Down With One Arm",
    //     "PUSH DOWN WITH ONE ARM", "push down with one arm");
    // actionService.create("CH", "standing", "Arm Frog", "ARM FROG", "arm frog");
    // actionService.create("CH", "supine", "Roll Over", "ROLL OVER", "roll over");
    // actionService.create(
    //     "CH", "supine", "Jack Knife", "JACK KNIFE", "jack knife");
    // actionService.create("CH", "prone", "Swan Dive From Floor",
    //     "SWAN DIVE FROM FLOOR", "swan dive from floor");
    // actionService.create("CH", "prone", "Swan Dive", "SWAN DIVE", "swan dive");
    // actionService.create("CH", "sitting", "Mermaid", "MERMAID", "mermaid");
    // actionService.create("CH", "kneeling", "Mermaid Kneeling",
    //     "MERMAID KNEELING", "mermaid kneeling");
    // actionService.create(
    //     "CH", "sitting", "Horse Back", "HORSE BACK", "horse back");
    // actionService.create(
    //     "CH", "standing", "Mountain Climb", "MOUNTAIN CLIMB", "mountain climb");
    // actionService.create(
    //     "BA", "standing", "Ballet Stretch", "BALLET STRETCH", "ballet stretch");
    // actionService.create("BA", "standing", "Swedish Bar Stretch",
    //     "SWEDISH BAR STRETCH", "swedish bar stretch");
    // actionService.create(
    //     "BA", "sitting", "Horse Back", "HORSE BACK", "horse back");
    // actionService.create(
    //     "BA", "standing", "Side Bend", "SIDE BEND", "side bend");
    // actionService.create(
    //     "BA", "standing", "Side Sit Up", "SIDE SIT UP", "side sit up");
    // actionService.create("BA", "sitting", "Short Box Series",
    //     "SHORT BOX SERIES", "short box series");
    // actionService.create(
    //     "BA", "sitting", "Roll Down", "ROLL DOWN", "roll down");
    // actionService.create("BA", "prone", "Swan", "SWAN", "swan");
    // actionService.create("BA", "prone", "Swan Dive", "SWAN DIVE", "swan dive");
    // actionService.create("BA", "prone", "Prone Leg Series", "PRONE LEG SERIES",
    //     "prone leg series");
    // actionService.create(
    //     "BA", "side lying", "Side Leg Lift", "SIDE LEG LIFT", "side leg lift");
    // actionService.create("BA", "sitting", "Sitting Leg Series",
    //     "SITTING LEG SERIES", "sitting leg series");
    // actionService.create(
    //     "BA", "standing", "Lay Backs", "LAY BACKS", "lay backs");
    // actionService.create("BA", "standing", "Standing Roll Back",
    //     "STANDING ROLL BACK", "standing roll back");
    // actionService.create("BA", "side lying", "Side Lying Stretch",
    //     "SIDE LYING STRETCH", "side lying stretch");

    // actionService.create("MAT", "supine", "Ab Prep", "김주아");
    // actionService.create("MAT", "sitting", "Abs Series", "김주아");
    // actionService.create("RE", "supine", "Adductor Stretch", "김주아");
    // actionService.create("CA", "supine", "Airplane", "김주아");
    // actionService.create("RE", "kneeling", "Arm Circles", "김주아");
    // actionService.create("CH", "standing", "Arm Frog", "김주아");
    // actionService.create("CA", "sitting", "Back Rowing", "김주아");
    // actionService.create("RE", "sitting", "Back Rowing Prep", "김주아");
    // actionService.create("CA", "sitting", "Back Rowing Prep Series", "김주아");
    // actionService.create("RE", "sitting", "Balance Control Back", "김주아");
    // actionService.create("RE", "plank", "Balance Control Front", "김주아");
    // actionService.create("MAT", "sitting", "Balance Point", "김주아");
    // actionService.create("BA", "standing", "Ballet Stretch", "김주아");
    // actionService.create("RE", "supine", "Bend&Stretch", "김주아");
    // actionService.create("MAT", "sitting", "Boomerang", "김주아");
    // actionService.create("MAT", "prone", "Breast Stroke", "김주아");
    // actionService.create("MAT", "supine", "Breathing", "김주아");
    // actionService.create("CA", "supine", "Breathing", "김주아");
    // actionService.create("MAT", "quadruped", "Cat Stretch", "김주아");
    // actionService.create("RE", "kneeling", "Chest Expansion", "김주아");
    // actionService.create("MAT", "side lying", "Clam Shell", "김주아");
    // actionService.create("MAT", "supine", "Control Balance", "김주아");
    // actionService.create("RE", "supine", "Coordination", "김주아");
    // actionService.create("MAT", "supine", "Corkscrew", "김주아");
    // actionService.create("RE", "supine", "Corscrew", "김주아");
    // actionService.create("MAT", "sitting", "Crab", "김주아");
    // actionService.create("MAT", "supine", "Criss Cross", "김주아");
    // actionService.create("MAT", "prone", "Double Leg Kicks", "김주아");
    // actionService.create("MAT", "supine", "Double Leg Stretch", "김주아");
    // actionService.create("RE", "quadruped", "Down Stretch", "김주아");
    // actionService.create("RE", "standing", "Elephant", "김주아");
    // actionService.create("RE", "supine", "Footwork Series", "김주아");
    // actionService.create("CH", "sitting", "Footwork Series", "김주아");
    // actionService.create("RE", "supine", "Frog", "김주아");
    // actionService.create("MAT", "prone", "Frog Hip Extension", "김주아");
    // actionService.create("CA", "sitting", "Front Rowing", "김주아");
    // actionService.create("RE", "sitting", "Front Rowing Prep", "김주아");
    // actionService.create("CA", "sitting", "Front Rowing Prep Series", "김주아");
    // actionService.create("RE", "standing", "Front Split", "김주아");
    // actionService.create("CA", "supine", "Full Hanging", "김주아");
    // actionService.create("CA", "prone", "Full Swan", "김주아");
    // actionService.create("CH", "standing", "Going Up Front", "김주아");
    // actionService.create("CH", "standing", "Going Up Side", "김주아");
    // actionService.create("CA", "supine", "Half Hanging", "김주아");
    // actionService.create("MAT", "sitting", "Half Roll Back", "김주아");
    // actionService.create("MAT", "prone", "Half Swan", "김주아");
    // actionService.create("CH", "supine", "Hams Press Hips Down", "김주아");
    // actionService.create("CH", "supine", "Hams Press Hips Up", "김주아");
    // actionService.create("CA", "standing", "Hanging Pull Ups", "김주아");
    // actionService.create("MAT", "supine", "High Bicycle", "김주아");
    // actionService.create("MAT", "supine", "High Scissors", "김주아");
    // actionService.create("MAT", "sitting", "Hip Circles", "김주아");
    // actionService.create("CA", "side lying", "Hip Opener", "김주아");
    // actionService.create("MAT", "supine", "Hip Release", "김주아");
    // actionService.create("MAT", "supine", "Hip Roll", "김주아");
    // actionService.create("CH", "sitting", "Horse Back", "김주아");
    // actionService.create("BA", "sitting", "Horse Back", "김주아");
    // actionService.create("MAT", "supine", "Hundred", "김주아");
    // actionService.create("RE", "supine", "Hundred", "김주아");
    // actionService.create("MAT", "supine", "Imprinting Transition", "김주아");
    // actionService.create("MAT", "supine", "Jack Knife", "김주아");
    // actionService.create("CH", "supine", "Jack Knife", "김주아");
    // actionService.create("CH", "standing", "Knee Raise Series", "김주아");
    // actionService.create("RE", "quadruped", "Knee Stretch Arches", "김주아");
    // actionService.create("RE", "quadruped", "Knee Stretch Knees Off", "김주아");
    // actionService.create("RE", "quadruped", "Knee Stretch Round", "김주아");
    // actionService.create("RE", "quadruped", "Knee Stretch Series", "김주아");
    // actionService.create("CA", "kneeling", "Kneeling Ballet Stretches", "김주아");
    // actionService.create("CA", "kneeling", "Kneeling Cat", "김주아");
    // actionService.create("CA", "kneeling", "Kneeling Chest Expansion", "김주아");
    // actionService.create("CH", "kneeling", "Kneeling Mermaid", "김주아");
    // actionService.create("MAT", "kneeling", "Kneeling Side Kick", "김주아");
    // actionService.create("CH", "kneeling", "Kneeling Side Kicks", "김주아");
    // actionService.create("BA", "standing", "Lay Backs", "김주아");
    // actionService.create("RE", "supine", "Leg Circles", "김주아");
    // actionService.create("MAT", "plank", "Leg Pull Back", "김주아");
    // actionService.create("MAT", "plank", "Leg Pull Front", "김주아");
    // actionService.create("CA", "supine", "Leg Spring Series", "김주아");
    // actionService.create(
    //     "CA", "side lying", "Leg Spring Side Kick Series", "김주아");
    // actionService.create("RE", "supine", "Leg Strap Series", "김주아");
    // actionService.create("RE", "sitting", "Long Back Stretch", "김주아");
    // actionService.create("RE", "prone", "Long Box Backstroke", "김주아");
    // actionService.create("RE", "prone", "Long Box Horse Back", "김주아");
    // actionService.create("RE", "prone", "Long Box Pulling Straps", "김주아");
    // actionService.create("RE", "prone", "Long Box Series", "김주아");
    // actionService.create("RE", "prone", "Long Box T Shape", "김주아");
    // actionService.create("RE", "prone", "Long Box Teaser", "김주아");
    // actionService.create("RE", "supine", "Long Spine Massage", "김주아");
    // actionService.create("RE", "plank", "Long Stretch", "김주아");
    // actionService.create("RE", "plank", "Long Stretch Series", "김주아");
    // actionService.create("MAT", "supine", "Lower And Lift", "김주아");
    // actionService.create("RE", "supine", "Lower And Lift", "김주아");
    // actionService.create("CH", "standing", "Lunge", "김주아");
    // actionService.create("MAT", "sitting", "Mermaid", "김주아");
    // actionService.create("CA", "sitting", "Mermaid", "김주아");
    // actionService.create("CH", "sitting", "Mermaid", "김주아");
    // actionService.create("CA", "supine", "Midback Series", "김주아");
    // actionService.create("CA", "supine", "Monkey", "김주아");
    // actionService.create("CH", "standing", "Mountain Climb", "김주아");
    // actionService.create("MAT", "sitting", "Neck Pull", "김주아");
    // actionService.create("CH", "prone", "One Arm Press", "김주아");
    // actionService.create("MAT", "sitting", "Open Leg Rocker", "김주아");
    // actionService.create("RE", "supine", "Overhead", "김주아");
    // actionService.create("CA", "supine", "Parakeet", "김주아");
    // actionService.create("RE", "supine", "Pelvic Lift", "김주아");
    // actionService.create("MAT", "supine", "Pelvic Movement", "김주아");
    // actionService.create("CA", "sitting", "Port De Bras", "김주아");
    // actionService.create("CH", "sitting", "Press Down Teaser", "김주아");
    // actionService.create("MAT", "prone", "Prone Heel Squeeze", "김주아");
    // actionService.create("MAT", "prone", "Prone Leg Lift Series", "김주아");
    // actionService.create("BA", "prone", "Prone Leg Lift Series", "김주아");
    // actionService.create("CH", "standing", "Pull Up", "김주아");
    // actionService.create("CH", "standing", "Push Down", "김주아");
    // actionService.create("CH", "standing", "Push Down With One Arm", "김주아");
    // actionService.create("CA", "sitting", "Push Through", "김주아");
    // actionService.create("CA", "supine", "Push Thru With Feet", "김주아");
    // actionService.create("MAT", "plank", "Push Ups", "김주아");
    // actionService.create("MAT", "prone", "Rocking", "김주아");
    // actionService.create("CA", "sitting", "Roll Back Bar", "김주아");
    // actionService.create("CA", "sitting", "Roll Back With One Arm", "김주아");
    // actionService.create("CA", "sitting", "Roll Down", "김주아");
    // actionService.create("BA", "sitting", "Roll Down Round", "김주아");
    // actionService.create("BA", "sitting", "Roll Down Straight", "김주아");
    // actionService.create("MAT", "supine", "Roll Over", "김주아");
    // actionService.create("CH", "supine", "Roll Over", "김주아");
    // actionService.create("CA", "supine", "Roll Up", "김주아");
    // actionService.create("MAT", "sitting", "Rolling Like A Ball", "김주아");
    // actionService.create("RE", "sitting", "Rowing 90 Degrees", "김주아");
    // actionService.create("RE", "sitting", "Rowing From The Chest", "김주아");
    // actionService.create("RE", "sitting", "Rowing From The Hips", "김주아");
    // actionService.create("RE", "sitting", "Rowing Hug The Tree", "김주아");
    // actionService.create("RE", "sitting", "Rowing Into The Sternum", "김주아");
    // actionService.create("RE", "sitting", "Rowing Salute", "김주아");
    // actionService.create("RE", "sitting", "Rowing Series", "김주아");
    // actionService.create("RE", "sitting", "Rowing Shave", "김주아");
    // actionService.create("RE", "supine", "Running", "김주아");
    // actionService.create("RE", "standing", "Russian Split", "김주아");
    // actionService.create("MAT", "sitting", "Saw", "김주아");
    // actionService.create("CH", "prone", "Scapula Isolation", "김주아");
    // actionService.create("MAT", "supine", "Scapula Movement", "김주아");
    // actionService.create("MAT", "supine", "Scissors", "김주아");
    // actionService.create("MAT", "sitting", "Seal", "김주아");
    // actionService.create("RE", "supine", "Semi-Circle", "김주아");
    // actionService.create("RE", "sitting", "Short Box Round", "김주아");
    // actionService.create("RE", "sitting", "Short Box Series", "김주아");
    // actionService.create("BA", "sitting", "Short Box Series", "김주아");
    // actionService.create("RE", "sitting", "Short Box Side", "김주아");
    // actionService.create("RE", "sitting", "Short Box Straight", "김주아");
    // actionService.create("RE", "sitting", "Short Box Tree", "김주아");
    // actionService.create("RE", "sitting", "Short Box Twist", "김주아");
    // actionService.create("RE", "sitting", "Short Box Twist And Reach", "김주아");
    // actionService.create("RE", "supine", "Short Spine Massage", "김주아");
    // actionService.create("CA", "supine", "Shoulder And Chest Opener", "김주아");
    // actionService.create("MAT", "supine", "Shoulder Bridge", "김주아");
    // actionService.create("CA", "sitting", "Side Arm Sitting", "김주아");
    // actionService.create("MAT", "sitting", "Side Bend", "김주아");
    // actionService.create("CA", "side lying", "Side Bend", "김주아");
    // actionService.create("BA", "standing", "Side Bend", "김주아");
    // actionService.create("MAT", "supine", "Side Kick Beats", "김주아");
    // actionService.create("MAT", "side lying", "Side Kick Bicycle", "김주아");
    // actionService.create("MAT", "side lying", "Side Kick Big Circles", "김주아");
    // actionService.create("MAT", "side lying", "Side Kick Big Scissors", "김주아");
    // actionService.create("MAT", "side lying", "Side Kick Developpe", "김주아");
    // actionService.create("MAT", "side lying", "Side Kick Front Back", "김주아");
    // actionService.create("MAT", "side lying", "Side Kick Hot Potato", "김주아");
    // actionService.create("MAT", "side lying", "Side Kick Inner Thigh", "김주아");
    // actionService.create("MAT", "side lying", "Side Kick Series", "김주아");
    // actionService.create("MAT", "side lying", "Side Kick Small Circles", "김주아");
    // actionService.create("MAT", "side lying", "Side Kick Up Down", "김주아");
    // actionService.create("BA", "side lying", "Side Leg Lift", "김주아");
    // actionService.create("BA", "side lying", "Side Lying Stretch", "김주아");
    // actionService.create("BA", "standing", "Side Sit Up", "김주아");
    // actionService.create("RE", "standing", "Side Split", "김주아");
    // actionService.create("MAT", "supine", "Single Leg Circles", "김주아");
    // actionService.create("MAT", "prone", "Single Leg Kicks", "김주아");
    // actionService.create("CH", "sitting", "Single Leg Press", "김주아");
    // actionService.create("MAT", "supine", "Single Leg Stretch", "김주아");
    // actionService.create("CH", "sitting", "Sitthing Triceps Press", "김주아");
    // actionService.create("CA", "sitting", "Sitting Cat", "김주아");
    // actionService.create("BA", "sitting", "Sitting Leg Series", "김주아");
    // actionService.create("RE", "standing", "Snake", "김주아");
    // actionService.create("MAT", "sitting", "Spine Stretch Forward", "김주아");
    // actionService.create("CH", "sitting", "Spine Stretch Forward", "김주아");
    // actionService.create("MAT", "sitting", "Spine Twist", "김주아");
    // actionService.create("CA", "standing", "Spread Eagle", "김주아");
    // actionService.create("CA", "standing", "Squat", "김주아");
    // actionService.create("CA", "standing", "Standing Ballet Stretches", "김주아");
    // actionService.create("CA", "standing", "Standing Cat", "김주아");
    // actionService.create("CA", "standing", "Standing Chest Expansion", "김주아");
    // actionService.create("BA", "standing", "Standing Roll Back", "김주아");
    // actionService.create("CH", "standing", "Standing Roll Down", "김주아");
    // actionService.create("BA", "standing", "Standing Side Leg Lift", "김주아");
    // actionService.create("CH", "standing", "Standing Single Leg Press", "김주아");
    // actionService.create("CA", "standing", "Standing Spred Eagle", "김주아");
    // actionService.create("RE", "sitting", "Stomach Massage Reach Up", "김주아");
    // actionService.create("RE", "sitting", "Stomach Massage Round", "김주아");
    // actionService.create("RE", "sitting", "Stomach Massage Series", "김주아");
    // actionService.create("RE", "sitting", "Stomach Massage Straight", "김주아");
    // actionService.create("RE", "sitting", "Stomach Massage Twist", "김주아");
    // actionService.create("MAT", "prone", "Swan", "김주아");
    // actionService.create("RE", "prone", "Swan", "김주아");
    // actionService.create("CA", "prone", "Swan", "김주아");
    // actionService.create("BA", "prone", "Swan", "김주아");
    // actionService.create("MAT", "prone", "Swan Dive", "김주아");
    // actionService.create("CH", "prone", "Swan Dive", "김주아");
    // actionService.create("BA", "prone", "Swan Dive", "김주아");
    // actionService.create("CH", "prone", "Swan Dive From Floor", "김주아");
    // actionService.create("BA", "standing", "Swedish Bar Stretch", "김주아");
    // actionService.create("MAT", "prone", "Swimming", "김주아");
    // actionService.create("MAT", "supine", "Teaser", "김주아");
    // actionService.create("CA", "supine", "Teaser", "김주아");
    // actionService.create("RE", "standing", "Tendon Stretch", "김주아");
    // actionService.create("CH", "standing", "Tendon Stretch", "김주아");
    // actionService.create("MAT", "supine", "The Hundred", "김주아");
    // actionService.create("MAT", "supine", "The Roll Up", "김주아");
    // actionService.create("MAT", "kneeling", "Thigh Stretch", "김주아");
    // actionService.create("RE", "kneeling", "Thigh Stretch", "김주아");
    // actionService.create("CA", "kneeling", "Thigh Stretch", "김주아");
    // actionService.create("MAT", "supine", "Toe Tap", "김주아");
    // actionService.create("CA", "supine", "Tower", "김주아");
    // actionService.create("CH", "prone", "Triceps", "김주아");
    // actionService.create("RE", "standing", "Twist", "김주아");
    // actionService.create("RE", "standing", "Up Stretch", "김주아");
    // actionService.create("CA", "supine", "Upper Abs Curl", "김주아");
  }
}
