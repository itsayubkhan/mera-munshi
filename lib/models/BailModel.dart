// models/BailProceedingModel.dart

class BailProceedingModel {
  final int? id;
  final int caseId;
  final String data;
  final String proceeding;

  BailProceedingModel({
    this.id,
    required this.caseId,
    required this.data,
    required this.proceeding,
  });

  // Convert a BailProceedingModel into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caseId': caseId,
      'data': data,
      'proceeding': proceeding,
    };
  }

  // Create a BailProceedingModel from a Map.
  factory BailProceedingModel.fromMap(Map<String, dynamic> map) {
    return BailProceedingModel(
      id: map['id'],
      caseId: map['caseId'],
      data: map['data'],
      proceeding: map['proceeding'],
    );
  }
}
