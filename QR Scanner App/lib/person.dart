class Person {
  String? id;
  String? name;
  String? branch;
  String? year;
  bool? isClaimed;

  Person({this.id, this.name, this.branch, this.year, this.isClaimed});

  fromMap(Map<String, dynamic> map) {
    return Person(
        id: map['id'],
        name: map['name'],
        branch: map['branch'],
        year: map['year'],
        isClaimed: map['isClaimed']);
  }
}
