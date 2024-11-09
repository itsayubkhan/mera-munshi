class Causelist {
  final int? id; // Nullable to allow auto-incremented ID for new entries
  final int number;

  Causelist({this.id, required this.number});

  // Convert a Causelist object to a Map to insert into the database
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Will be null for new inserts
      'number': number,
    };
  }

  // Create a Causelist object from a Map (retrieved from the database)
  factory Causelist.fromMap(Map<String, dynamic> map) {
    return Causelist(
      id: map['id'] as int?,
      number: map['number'] as int,
    );
  }
}
