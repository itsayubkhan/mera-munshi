// models/ProceedingModel.dart

class ProceedingModel {
  final int? id;
  final int caseId;
  final String data;
  final String proceeding;

  ProceedingModel({
    this.id,
    required this.caseId,
    required this.data,
    required this.proceeding,
  });

  // Convert a ProceedingModel into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caseId': caseId,
      'data': data,
      'proceeding': proceeding,
    };
  }

  // Create a ProceedingModel from a Map.
  factory ProceedingModel.fromMap(Map<String, dynamic> map) {
    return ProceedingModel(
      id: map['id'],
      caseId: map['caseId'],
      data: map['data'],
      proceeding: map['proceeding'],
    );
  }
}
