class CoachInfo {
  CoachInfo(
    this.uid,
    this.name,
    this.email,
    this.phonenumber,
    this.substituteYn,
    this.jobYn,
    this.gender,
    this.age,
    this.career,
    this.workingArea,
    this.classCenter,
    this.pilatesRelatedQualifications,
    this.otherRelatedQualifications,
    this.teacherIntro,
  );

  String uid;
  String name;
  String email;
  String phonenumber;
  bool substituteYn;
  bool jobYn;
  String gender;
  String age;
  String career;
  List workingArea;
  List classCenter;
  List pilatesRelatedQualifications;
  List otherRelatedQualifications;
  String teacherIntro;
}
