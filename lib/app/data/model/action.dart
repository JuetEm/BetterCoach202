class Action {
  final String otherPositionName;
  final String lowerCaseName;
  final String otherApparatusName;
  final String position;
  final String name;
  final String upperCaseName;
  final List nGramizedLowerCaseName;
  final String author;
  final String apparatus;
  final String id;

  Action(
      this.apparatus,
      this.otherApparatusName,
      this.position,
      this.otherPositionName,
      this.name,
      this.id,
      this.upperCaseName,
      this.lowerCaseName,
      this.nGramizedLowerCaseName,
      this.author);

  // static Action fromJason(Map<String> )
}
