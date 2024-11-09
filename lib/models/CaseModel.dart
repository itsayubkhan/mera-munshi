// models/CaseModel.dart

class ModelClass {
  final int? id;
  final String casetitle;
  final String courtname;
  final String casefor;
  final String provisions;
  final String selectedcasetype;
  final String nature;
  final String? cpnumber;

  ModelClass({
    this.id,
    this.cpnumber,
    required this.casetitle,
    required this.courtname,
    required this.casefor,
    required this.provisions,
    required this.selectedcasetype,
    required this.nature,
  });

  // Convert a ModelClass into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cpnumber': cpnumber,
      'casetitle': casetitle,
      'courtname': courtname,
      'casefor': casefor,
      'provisions': provisions,
      'selectedcasetype': selectedcasetype,
      'nature': nature,
    };
  }

  // Create a ModelClass from a Map
  factory ModelClass.fromMap(Map<String, dynamic> map) {
    return ModelClass(
      id: map['id'],
      cpnumber: map['cpnumber'],
      casetitle: map['casetitle'] ?? '',
      courtname: map['courtname'] ?? '',
      casefor: map['casefor'] ?? '',
      provisions: map['provisions'] ?? '',
      selectedcasetype: map['selectedcasetype'] ?? '',
      nature: map['nature'] ?? '',
    );
  }
}
