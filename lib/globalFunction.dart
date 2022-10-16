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
    actionService.create("MAT", "supine", "Hundred", "HUNDRED", "hundred");
    actionService.create("MAT", "supine", "Roll Up", "ROLL UP", "roll up");
    actionService.create(
        "MAT", "supine", "Roll Over", "ROLL OVER", "roll over");
    actionService.create("MAT", "supine", "Single Leg Circles",
        "SINGLE LEG CIRCLES", "single leg circles");
    actionService.create("MAT", "supine", "Rolling Like A Ball",
        "ROLLING LIKE A BALL", "rolling like a ball");
    actionService.create("MAT", "supine", "Single Leg Stretch",
        "SINGLE LEG STRETCH", "single leg stretch");
    actionService.create("MAT", "supine", "Double Leg Stretch",
        "DOUBLE LEG STRETCH", "double leg stretch");
    actionService.create("MAT", "supine", "Sissors", "SISSORS", "sissors");
    actionService.create(
        "MAT", "supine", "Lower And Lift", "LOWER AND LIFT", "lower and lift");
    actionService.create(
        "MAT", "supine", "Criss Cross", "CRISS CROSS", "criss cross");
    actionService.create("MAT", "sitting", "Spine Stretch Forward",
        "SPINE STRETCH FORWARD", "spine stretch forward");
    actionService.create("MAT", "sitting", "Open Leg Rocker", "OPEN LEG ROCKER",
        "open leg rocker");
    actionService.create(
        "MAT", "supine", "Corkscrew", "CORKSCREW", "corkscrew");
    actionService.create("MAT", "supine", "Saw", "SAW", "saw");
    actionService.create("MAT", "prone", "Swan Dive", "SWAN DIVE", "swan dive");
    actionService.create("MAT", "prone", "Single Leg Kicks", "SINGLE LEG KICKS",
        "single leg kicks");
    actionService.create("MAT", "prone", "Double Leg Kicks", "DOUBLE LEG KICKS",
        "double leg kicks");
    actionService.create(
        "MAT", "kneeling", "Thigh Stretch", "THIGH STRETCH", "thigh stretch");
    actionService.create(
        "MAT", "sitting", "Neck Pull", "NECK PULL", "neck pull");
    actionService.create(
        "MAT", "supine", "High Scissors", "HIGH SCISSORS", "high scissors");
    actionService.create(
        "MAT", "supine", "High Bicycle", "HIGH BICYCLE", "high bicycle");
    actionService.create("MAT", "supine", "Shoulder Bridge", "SHOULDER BRIDGE",
        "shoulder bridge");
    actionService.create(
        "MAT", "sitting", "Spine Twist", "SPINE TWIST", "spine twist");
    actionService.create(
        "MAT", "supine", "Jack Knife", "JACK KNIFE", "jack knife");
    actionService.create("MAT", "side lying", "Side Kick Front&Back",
        "SIDE KICK FRONT&BACK", "side kick front&back");
    actionService.create("MAT", "side lying", "Side Kick Up&Down",
        "SIDE KICK UP&DOWN", "side kick up&down");
    actionService.create("MAT", "side lying", "Side Kick Small Circles",
        "SIDE KICK SMALL CIRCLES", "side kick small circles");
    actionService.create("MAT", "side lying", "Side Kick Bicycle",
        "SIDE KICK BICYCLE", "side kick bicycle");
    actionService.create("MAT", "side lying", "Side Kick Developpe",
        "SIDE KICK DEVELOPPE", "side kick developpe");
    actionService.create("MAT", "side lying", "Side Kick Inner Thigh",
        "SIDE KICK INNER THIGH", "side kick inner thigh");
    actionService.create("MAT", "side lying", "Side Kick Hot Potato",
        "SIDE KICK HOT POTATO", "side kick hot potato");
    actionService.create("MAT", "side lying", "Side Kick Big Scissors",
        "SIDE KICK BIG SCISSORS", "side kick big scissors");
    actionService.create("MAT", "side lying", "Side Kick Big Circles",
        "SIDE KICK BIG CIRCLES", "side kick big circles");
    actionService.create("MAT", "supine", "Teaser 1", "TEASER 1", "teaser 1");
    actionService.create(
        "MAT", "supine", "Teaser 2,3", "TEASER 2,3", "teaser 2,3");
    actionService.create(
        "MAT", "sitting", "Hip Circles", "HIP CIRCLES", "hip circles");
    actionService.create("MAT", "prone", "Swimming", "SWIMMING", "swimming");
    actionService.create(
        "MAT", "prone", "Leg Pull Front", "LEG PULL FRONT", "leg pull front");
    actionService.create(
        "MAT", "prone", "Leg Pull Back", "LEG PULL BACK", "leg pull back");
    actionService.create("MAT", "kneeling", "Kneeling Side Kick",
        "KNEELING SIDE KICK", "kneeling side kick");
    actionService.create(
        "MAT", "side lying", "Side Bend", "SIDE BEND", "side bend");
    actionService.create(
        "MAT", "sitting", "Boomerang", "BOOMERANG", "boomerang");
    actionService.create("MAT", "sitting", "Seal", "SEAL", "seal");
    actionService.create("MAT", "kneeling", "Crab", "CRAB", "crab");
    actionService.create("MAT", "prone", "Rocking", "ROCKING", "rocking");
    actionService.create("MAT", "supine", "Control Balance", "CONTROL BALANCE",
        "control balance");
    actionService.create("MAT", "standing", "Push Ups", "PUSH UPS", "push ups");
    actionService.create("RE", "supine", "Footwork Series", "FOOTWORK SERIES",
        "footwork series");
    actionService.create("RE", "supine", "Hundred", "HUNDRED", "hundred");
    actionService.create("RE", "supine", "Overhead", "OVERHEAD", "overhead");
    actionService.create(
        "RE", "supine", "Coordination", "COORDINATION", "coordination");
    actionService.create("RE", "sitting", "Back Rowing Series",
        "BACK ROWING SERIES", "back rowing series");
    actionService.create("RE", "sitting", "Front Rowing Series",
        "FRONT ROWING SERIES", "front rowing series");
    actionService.create("RE", "prone", "Swan", "SWAN", "swan");
    actionService.create("RE", "prone", "Long Box Pulling Strap",
        "LONG BOX PULLING STRAP", "long box pulling strap");
    actionService.create("RE", "supine", "Long Box Backstroke",
        "LONG BOX BACKSTROKE", "long box backstroke");
    actionService.create("RE", "supine", "Long Box Teaser", "LONG BOX TEASER",
        "long box teaser");
    actionService.create("RE", "sitting", "Long Box Horseback",
        "LONG BOX HORSEBACK", "long box horseback");
    actionService.create("RE", "sitting", "Short Box Series",
        "SHORT BOX SERIES", "short box series");
    actionService.create(
        "RE", "prone", "Long Stretch", "LONG STRETCH", "long stretch");
    actionService.create(
        "RE", "prone", "Down Stretch", "DOWN STRETCH", "down stretch");
    actionService.create("RE", "standing", "Elephant", "ELEPHANT", "elephant");
    actionService.create("RE", "sitting", "Long Back Stretch",
        "LONG BACK STRETCH", "long back stretch");
    actionService.create("RE", "sitting", "Stomach Massage Series",
        "STOMACH MASSAGE SERIES", "stomach massage series");
    actionService.create(
        "RE", "standing", "Tendon Stretch", "TENDON STRETCH", "tendon stretch");
    actionService.create("RE", "supine", "Short Spine Massage",
        "SHORT SPINE MASSAGE", "short spine massage");
    actionService.create(
        "RE", "supine", "Semi-Circle", "SEMI-CIRCLE", "semi-circle");
    actionService.create("RE", "kneeling", "Chest Expansion", "CHEST EXPANSION",
        "chest expansion");
    actionService.create(
        "RE", "kneeling", "Thigh Stretch", "THIGH STRETCH", "thigh stretch");
    actionService.create(
        "RE", "kneeling", "Arm Circles", "ARM CIRCLES", "arm circles");
    actionService.create(
        "RE", "standing", "Snake&Twist", "SNAKE&TWIST", "snake&twist");
    actionService.create("RE", "supine", "Corscrew", "CORSCREW", "corscrew");
    actionService.create("RE", "supine", "Long Spine Massage",
        "LONG SPINE MASSAGE", "long spine massage");
    actionService.create(
        "RE", "supine", "Leg Circles", "LEG CIRCLES", "leg circles");
    actionService.create("RE", "supine", "Frog", "FROG", "frog");
    actionService.create("RE", "kneeling", "Knee Stretch Series",
        "KNEE STRETCH SERIES", "knee stretch series");
    actionService.create("RE", "supine", "Running", "RUNNING", "running");
    actionService.create(
        "RE", "supine", "Pelvic Lift", "PELVIC LIFT", "pelvic lift");
    actionService.create("RE", "prone", "Balance Control Front",
        "BALANCE CONTROL FRONT", "balance control front");
    actionService.create("RE", "supine", "Balance Control Back",
        "BALANCE CONTROL BACK", "balance control back");
    actionService.create(
        "RE", "standing", "Side Split", "SIDE SPLIT", "side split");
    actionService.create(
        "RE", "standing", "Front Split", "FRONT SPLIT", "front split");
    actionService.create(
        "RE", "standing", "Russian Split", "RUSSIAN SPLIT", "russian split");
  }
}
