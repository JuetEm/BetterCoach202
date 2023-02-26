class UserInfo {
  const UserInfo(
    this.docId,
    this.uid,
    this.name,
    this.registerDate,
    this.phoneNumber,
    this.registerType,
    this.goal,
    this.selectedGoals,
    this.bodyAnalyzed,
    this.selectedBodyAnalyzed,
    this.medicalHistories,
    this.selectedMedicalHistories,
    this.info,
    this.note,
    this.comment,
    this.isActive,
    this.isFavorite,
  );
  final String docId;
  final String uid;
  final String name;
  final String registerDate;
  final String phoneNumber;
  final String registerType;
  final String goal;
  final List<String> selectedGoals;
  final String bodyAnalyzed;
  final List<String> selectedBodyAnalyzed;
  final String medicalHistories;
  final List<String> selectedMedicalHistories;
  final String info;
  final String note;
  final String comment;
  final bool isActive;
  final bool isFavorite;
}
