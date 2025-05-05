class PredictionHistory {
  final int age;
  final int education;
  final int income;
  final bool highBP;
  final bool highChol;
  final bool smoker;
  final bool stroke;
  final bool heartDisease;
  final bool physActivity;
  final bool fruits;
  final bool veggies;
  final bool alcohol;
  final int genHealth;
  final int mentHealth;
  final int physHealth;
  final bool diffWalk;
  final bool sex;
  final String? predictionResult;
  final DateTime timestamp;

  PredictionHistory({
    required this.age,
    required this.education,
    required this.income,
    required this.highBP,
    required this.highChol,
    required this.smoker,
    required this.stroke,
    required this.heartDisease,
    required this.physActivity,
    required this.fruits,
    required this.veggies,
    required this.alcohol,
    required this.genHealth,
    required this.mentHealth,
    required this.physHealth,
    required this.diffWalk,
    required this.sex,
    required this.predictionResult,
    required this.timestamp,
  });
}
