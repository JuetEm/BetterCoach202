import 'package:web_project/app/data/provider/auth_service.dart';
import 'package:web_project/app/data/provider/daylesson_service.dart';
import 'package:web_project/app/data/provider/lesson_service.dart';

class LessonRepository {
  LessonRepository();

  LessonService lessonService = LessonService();
  DayLessonService dayLessonService = DayLessonService();

  Future<List> getLessonActionNote(String uid, String memberId) async {
    List resultList = [];
    await lessonService.readMemberActionNote(uid, memberId).then((value){
      resultList.addAll(value);
    });
    return resultList;
  }

  Future<List> getLessonDaynNote(String uid, String memberId) async {
    List resultList = [];
    await dayLessonService.readLessonDayNote(uid,memberId).then((value){
      resultList.addAll(value);
    });
    return resultList;
  }

}