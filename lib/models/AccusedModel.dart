// models/AccusedModel.dart

class AccusedModel {
  final int? id;
  final int caseId;
  final String profile;

  AccusedModel({
    this.id,
    required this.caseId,
    required this.profile,
  });

  // Convert an AccusedModel into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caseId': caseId,
      'profile': profile,
    };
  }

  // Create an AccusedModel from a Map.
  factory AccusedModel.fromMap(Map<String, dynamic> map) {
    return AccusedModel(
      id: map['id'],
      caseId: map['caseId'],
      profile: map['profile'],
    );
  }
}
