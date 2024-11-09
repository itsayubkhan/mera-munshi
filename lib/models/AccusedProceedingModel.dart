class AccusedProceedingModel {
  final int? id;
  final int accusedId;
  final String date;
  final String proceeding;

  AccusedProceedingModel({
    this.id,
    required this.accusedId,
    required this.date,
    required this.proceeding,
  });

  // Convert a model into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accusedId': accusedId,
      'date': date,
      'proceeding': proceeding,
    };
  }

  // Extract a model from a Map
  factory AccusedProceedingModel.fromMap(Map<String, dynamic> map) {
    return AccusedProceedingModel(
      id: map['id'],
      accusedId: map['accusedId'],
      date: map['date'],
      proceeding: map['proceeding'],
    );
  }
}
