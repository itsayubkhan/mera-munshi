// models/CitationModel.dart

class CitationModel {
  final int? id;
  final int caseId;
  final String citation;
  final String description;

  CitationModel({
    this.id,
    required this.caseId,
    required this.citation,
    required this.description,
  });

  // Convert a CitationModel into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caseId': caseId,
      'citation': citation,
      'description': description,
    };
  }

  // Create a CitationModel from a Map.
  factory CitationModel.fromMap(Map<String, dynamic> map) {
    return CitationModel(
      id: map['id'],
      caseId: map['caseId'],
      citation: map['citation'],
      description: map['description'],
    );
  }
}
