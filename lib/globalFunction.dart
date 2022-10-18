import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'action_service.dart';
import 'baseTableCalendar.dart';

class GlobalFunction {
  GlobalFunction();

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
    actionService.create("MAT", "supine", "Hundred", "Hundred", "Hundred");
    actionService.create("MAT", "supine", "Roll Up", "Roll Up", "Roll Up");
    actionService.create(
        "MAT", "supine", "Roll Over", "Roll Over", "Roll Over");
    actionService.create("MAT", "supine", "Single Leg Circles",
        "Single Leg Circles", "Single Leg Circles");
    actionService.create("MAT", "supine", "Rolling Like A Ball",
        "Rolling Like A Ball", "Rolling Like A Ball");
    actionService.create("MAT", "supine", "Single Leg Stretch",
        "Single Leg Stretch", "Single Leg Stretch");
    actionService.create("MAT", "supine", "Double Leg Stretch",
        "Double Leg Stretch", "Double Leg Stretch");
    actionService.create("MAT", "supine", "Scissors", "Scissors", "Scissors");
    actionService.create(
        "MAT", "supine", "Lower And Lift", "Lower And Lift", "Lower And Lift");
    actionService.create(
        "MAT", "supine", "Criss Cross", "Criss Cross", "Criss Cross");
    actionService.create("MAT", "sitting", "Spine Stretch Forward",
        "Spine Stretch Forward", "Spine Stretch Forward");
    actionService.create("MAT", "sitting", "Open Leg Rocker", "Open Leg Rocker",
        "Open Leg Rocker");
    actionService.create(
        "MAT", "supine", "Corkscrew", "Corkscrew", "Corkscrew");
    actionService.create("MAT", "supine", "Saw", "Saw", "Saw");
    actionService.create("MAT", "prone", "Swan Dive", "Swan Dive", "Swan Dive");
    actionService.create("MAT", "prone", "Single Leg Kicks", "Single Leg Kicks",
        "Single Leg Kicks");
    actionService.create("MAT", "prone", "Double Leg Kicks", "Double Leg Kicks",
        "Double Leg Kicks");
    actionService.create(
        "MAT", "kneeling", "Thigh Stretch", "Thigh Stretch", "Thigh Stretch");
    actionService.create(
        "MAT", "sitting", "Neck Pull", "Neck Pull", "Neck Pull");
    actionService.create(
        "MAT", "supine", "High Scissors", "High Scissors", "High Scissors");
    actionService.create(
        "MAT", "supine", "High Bicycle", "High Bicycle", "High Bicycle");
    actionService.create("MAT", "supine", "Shoulder Bridge", "Shoulder Bridge",
        "Shoulder Bridge");
    actionService.create(
        "MAT", "sitting", "Spine Twist", "Spine Twist", "Spine Twist");
    actionService.create(
        "MAT", "supine", "Jack Knife", "Jack Knife", "Jack Knife");
    actionService.create("MAT", "side lying", "Side Kick Front&Back",
        "Side Kick Front&Back", "Side Kick Front&Back");
    actionService.create("MAT", "side lying", "Side Kick Up&Down",
        "Side Kick Up&Down", "Side Kick Up&Down");
    actionService.create("MAT", "side lying", "Side Kick Small Circles",
        "Side Kick Small Circles", "Side Kick Small Circles");
    actionService.create("MAT", "side lying", "Side Kick Bicycle",
        "Side Kick Bicycle", "Side Kick Bicycle");
    actionService.create("MAT", "side lying", "Side Kick Developpe",
        "Side Kick Developpe", "Side Kick Developpe");
    actionService.create("MAT", "side lying", "Side Kick Inner Thigh",
        "Side Kick Inner Thigh", "Side Kick Inner Thigh");
    actionService.create("MAT", "side lying", "Side Kick Hot Potato",
        "Side Kick Hot Potato", "Side Kick Hot Potato");
    actionService.create("MAT", "side lying", "Side Kick Big Scissors",
        "Side Kick Big Scissors", "Side Kick Big Scissors");
    actionService.create("MAT", "side lying", "Side Kick Big Circles",
        "Side Kick Big Circles", "Side Kick Big Circles");
    actionService.create("MAT", "supine", "Teaser 1", "Teaser 1", "Teaser 1");
    actionService.create(
        "MAT", "supine", "Teaser 2,3", "Teaser 2,3", "Teaser 2,3");
    actionService.create(
        "MAT", "sitting", "Hip Circles", "Hip Circles", "Hip Circles");
    actionService.create("MAT", "prone", "Swimming", "Swimming", "Swimming");
    actionService.create(
        "MAT", "prone", "Leg Pull Front", "Leg Pull Front", "Leg Pull Front");
    actionService.create(
        "MAT", "prone", "Leg Pull Back", "Leg Pull Back", "Leg Pull Back");
    actionService.create("MAT", "kneeling", "Kneeling Side Kick",
        "Kneeling Side Kick", "Kneeling Side Kick");
    actionService.create(
        "MAT", "side lying", "Side Bend", "Side Bend", "Side Bend");
    actionService.create(
        "MAT", "sitting", "Boomerang", "Boomerang", "Boomerang");
    actionService.create("MAT", "sitting", "Seal", "Seal", "Seal");
    actionService.create("MAT", "kneeling", "Crab", "Crab", "Crab");
    actionService.create("MAT", "prone", "Rocking", "Rocking", "Rocking");
    actionService.create("MAT", "supine", "Control Balance", "Control Balance",
        "Control Balance");
    actionService.create("MAT", "standing", "Push Ups", "Push Ups", "Push Ups");
    actionService.create("RE", "supine", "Footwork Series", "Footwork Series",
        "Footwork Series");
    actionService.create("RE", "supine", "Hundred", "Hundred", "Hundred");
    actionService.create("RE", "supine", "Overhead", "Overhead", "Overhead");
    actionService.create(
        "RE", "supine", "Coordination", "Coordination", "Coordination");
    actionService.create("RE", "sitting", "Back Rowing Series",
        "Back Rowing Series", "Back Rowing Series");
    actionService.create("RE", "sitting", "Front Rowing Series",
        "Front Rowing Series", "Front Rowing Series");
    actionService.create("RE", "prone", "Swan", "Swan", "Swan");
    actionService.create("RE", "prone", "Long Box Pulling Strap",
        "Long Box Pulling Strap", "Long Box Pulling Strap");
    actionService.create("RE", "supine", "Long Box Backstroke",
        "Long Box Backstroke", "Long Box Backstroke");
    actionService.create("RE", "supine", "Long Box Teaser", "Long Box Teaser",
        "Long Box Teaser");
    actionService.create("RE", "sitting", "Long Box Horseback",
        "Long Box Horseback", "Long Box Horseback");
    actionService.create("RE", "sitting", "Short Box Series",
        "Short Box Series", "Short Box Series");
    actionService.create(
        "RE", "prone", "Long Stretch", "Long Stretch", "Long Stretch");
    actionService.create(
        "RE", "prone", "Down Stretch", "Down Stretch", "Down Stretch");
    actionService.create("RE", "standing", "Elephant", "Elephant", "Elephant");
    actionService.create("RE", "sitting", "Long Back Stretch",
        "Long Back Stretch", "Long Back Stretch");
    actionService.create("RE", "sitting", "Stomach Massage Series",
        "Stomach Massage Series", "Stomach Massage Series");
    actionService.create(
        "RE", "standing", "Tendon Stretch", "Tendon Stretch", "Tendon Stretch");
    actionService.create("RE", "supine", "Short Spine Massage",
        "Short Spine Massage", "Short Spine Massage");
    actionService.create(
        "RE", "supine", "Semi-Circle", "Semi-Circle", "Semi-Circle");
    actionService.create("RE", "kneeling", "Chest Expansion", "Chest Expansion",
        "Chest Expansion");
    actionService.create(
        "RE", "kneeling", "Thigh Stretch", "Thigh Stretch", "Thigh Stretch");
    actionService.create(
        "RE", "kneeling", "Arm Circles", "Arm Circles", "Arm Circles");
    actionService.create(
        "RE", "standing", "Snake&Twist", "Snake&Twist", "Snake&Twist");
    actionService.create("RE", "supine", "Corkscrew", "Corkscrew", "Corkscrew");
    actionService.create("RE", "supine", "Long Spine Massage",
        "Long Spine Massage", "Long Spine Massage");
    actionService.create(
        "RE", "supine", "Leg Circles", "Leg Circles", "Leg Circles");
    actionService.create("RE", "supine", "Frog", "Frog", "Frog");
    actionService.create("RE", "kneeling", "Knee Stretch Series",
        "Knee Stretch Series", "Knee Stretch Series");
    actionService.create("RE", "supine", "Running", "Running", "Running");
    actionService.create(
        "RE", "supine", "Pelvic Lift", "Pelvic Lift", "Pelvic Lift");
    actionService.create("RE", "prone", "Balance Control Front",
        "Balance Control Front", "Balance Control Front");
    actionService.create("RE", "supine", "Balance Control Back",
        "Balance Control Back", "Balance Control Back");
    actionService.create(
        "RE", "standing", "Side Split", "Side Split", "Side Split");
    actionService.create(
        "RE", "standing", "Front Split", "Front Split", "Front Split");
    actionService.create(
        "RE", "standing", "Russian Split", "Russian Split", "Russian Split");
    actionService.create(
        "CA", "sitting", "Roll Down", "Roll Down", "Roll Down");
    actionService.create("CA", "sitting", "Roll Down With One Arm",
        "Roll Down With One Arm", "Roll Down With One Arm");
    actionService.create("CA", "supine", "Airplane", "Airplane", "Airplane");
    actionService.create("CA", "supine", "Breathing", "Breathing", "Breathing");
    actionService.create("CA", "standing", "Standing Ballet Stretches",
        "Standing Ballet Stretches", "Standing Ballet Stretches");
    actionService.create("CA", "kneeling", "Kneeling Ballet Stretches",
        "Kneeling Ballet Stretches", "Kneeling Ballet Stretches");
    actionService.create("CA", "supine", "Shoulder And Chest Opener",
        "Shoulder And Chest Opener", "Shoulder And Chest Opener");
    actionService.create("CA", "supine", "Teaser", "Teaser", "Teaser");
    actionService.create(
        "CA", "sitting", "Sitting Cat", "Sitting Cat", "Sitting Cat");
    actionService.create(
        "CA", "kneeling", "Kneeling Cat", "Kneeling Cat", "Kneeling Cat");
    actionService.create(
        "CA", "standing", "Standing Cat", "Standing Cat", "Standing Cat");
    actionService.create("CA", "prone", "Swan", "Swan", "Swan");
    actionService.create("CA", "prone", "Full Swan", "Full Swan", "Full Swan");
    actionService.create(
        "CA", "sitting", "Push Through", "Push Through", "Push Through");
    actionService.create("CA", "sitting", "Mermaid", "Mermaid", "Mermaid");
    actionService.create(
        "CA", "supine", "Midback Series", "Midback Series", "Midback Series");
    actionService.create("CA", "sitting", "Back Rowing Series",
        "Back Rowing Series", "Back Rowing Series");
    actionService.create("CA", "sitting", "Front Rowing Series",
        "Front Rowing Series", "Front Rowing Series");
    actionService.create("CA", "standing", "Chest Expansion", "Chest Expansion",
        "Chest Expansion");
    actionService.create("CA", "supine", "Leg Spring Series",
        "Leg Spring Series", "Leg Spring Series");
    actionService.create("CA", "side lying", "Leg Spring Side Lying",
        "Leg Spring Side Lying", "Leg Spring Side Lying");
    actionService.create(
        "CA", "side lying", "Side Bend", "Side Bend", "Side Bend");
    actionService.create(
        "CA", "standing", "Spread Eagle", "Spread Eagle", "Spread Eagle");
    actionService.create("CA", "standing", "Hanging Pull Ups",
        "Hanging Pull Ups", "Hanging Pull Ups");
    actionService.create("CA", "supine", "Push Thru With Feet",
        "Push Thru With Feet", "Push Thru With Feet");
    actionService.create("CA", "supine", "Tower", "Tower", "Tower");
    actionService.create("CA", "supine", "Monkey", "Monkey", "Monkey");
    actionService.create(
        "CA", "side lying", "Hip Opener", "Hip Opener", "Hip Opener");
    actionService.create("CA", "standing", "Squat", "Squat", "Squat");
    actionService.create(
        "CA", "supine", "Half Hanging", "Half Hanging", "Half Hanging");
    actionService.create(
        "CA", "supine", "Full Hanging", "Full Hanging", "Full Hanging");
    actionService.create("CA", "supine", "Leg Spring Series",
        "Leg Spring Series", "Leg Spring Series");
    actionService.create("CA", "kneeling", "Kneeling Chest Expansion",
        "Kneeling Chest Expansion", "Kneeling Chest Expansion");
    actionService.create(
        "CA", "kneeling", "Thigh Stretch", "Thigh Stretch", "Thigh Stretch");
    actionService.create("CH", "sitting", "Footwork Series", "Footwork Series",
        "Footwork Series");
    actionService.create("CH", "sitting", "Single Leg Press",
        "Single Leg Press", "Single Leg Press");
    actionService.create(
        "CH", "standing", "Push Down", "Push Down", "Push Down");
    actionService.create("CH", "standing", "Pull Up", "Pull Up", "Pull Up");
    actionService.create("CH", "standing", "Standing Single Leg Press",
        "Standing Single Leg Press", "Standing Single Leg Press");
    actionService.create("CH", "sitting", "Spine Stretch Forward",
        "Spine Stretch Forward", "Spine Stretch Forward");
    actionService.create("CH", "sitting", "Press Down Teaser",
        "Press Down Teaser", "Press Down Teaser");
    actionService.create(
        "CH", "standing", "Going Up Front", "Going Up Front", "Going Up Front");
    actionService.create(
        "CH", "standing", "Knee Raises", "Knee Raises", "Knee Raises");
    actionService.create("CH", "prone", "Scapula Isolation Prone",
        "Scapula Isolation Prone", "Scapula Isolation Prone");
    actionService.create("CH", "prone", "One Arm Push Prone",
        "One Arm Push Prone", "One Arm Push Prone");
    actionService.create("CH", "sitting", "Triceps Press Sitting",
        "Triceps Press Sitting", "Triceps Press Sitting");
    actionService.create("CH", "standing", "Push Down With One Arm",
        "Push Down With One Arm", "Push Down With One Arm");
    actionService.create("CH", "standing", "Arm Frog", "Arm Frog", "Arm Frog");
    actionService.create("CH", "supine", "Roll Over", "Roll Over", "Roll Over");
    actionService.create(
        "CH", "supine", "Jack Knife", "Jack Knife", "Jack Knife");
    actionService.create("CH", "prone", "Swan Dive From Floor",
        "Swan Dive From Floor", "Swan Dive From Floor");
    actionService.create("CH", "prone", "Swan Dive", "Swan Dive", "Swan Dive");
    actionService.create("CH", "sitting", "Mermaid", "Mermaid", "Mermaid");
    actionService.create("CH", "kneeling", "Mermaid Kneeling",
        "Mermaid Kneeling", "Mermaid Kneeling");
    actionService.create(
        "CH", "sitting", "Horse Back", "Horse Back", "Horse Back");
    actionService.create(
        "CH", "standing", "Mountain Climb", "Mountain Climb", "Mountain Climb");
    actionService.create(
        "BA", "standing", "Ballet Stretch", "Ballet Stretch", "Ballet Stretch");
    actionService.create("BA", "standing", "Swedish Bar Stretch",
        "Swedish Bar Stretch", "Swedish Bar Stretch");
    actionService.create(
        "BA", "sitting", "Horse Back", "Horse Back", "Horse Back");
    actionService.create(
        "BA", "standing", "Side Bend", "Side Bend", "Side Bend");
    actionService.create(
        "BA", "standing", "Side Sit Up", "Side Sit Up", "Side Sit Up");
    actionService.create("BA", "sitting", "Short Box Series",
        "Short Box Series", "Short Box Series");
    actionService.create(
        "BA", "sitting", "Roll Down", "Roll Down", "Roll Down");
    actionService.create("BA", "prone", "Swan", "Swan", "Swan");
    actionService.create("BA", "prone", "Swan Dive", "Swan Dive", "Swan Dive");
    actionService.create("BA", "prone", "Prone Leg Series", "Prone Leg Series",
        "Prone Leg Series");
    actionService.create(
        "BA", "side lying", "Side Leg Lift", "Side Leg Lift", "Side Leg Lift");
    actionService.create("BA", "sitting", "Sitting Leg Series",
        "Sitting Leg Series", "Sitting Leg Series");
    actionService.create(
        "BA", "standing", "Lay Backs", "Lay Backs", "Lay Backs");
    actionService.create("BA", "standing", "Standing Roll Back",
        "Standing Roll Back", "Standing Roll Back");
    actionService.create("BA", "side lying", "Side Lying Stretch",
        "Side Lying Stretch", "Side Lying Stretch");
  }
}
