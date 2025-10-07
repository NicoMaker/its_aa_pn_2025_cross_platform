import 'package:its_aa_pn_2025_cross_platform/person.dart';

class Animal {
  Animal({
    required this.name,
    required this.birthDate,
    required this.lastVisitAt,
    required this.owner,
  });
  String name;
  DateTime birthDate;
  DateTime lastVisitAt;
  Person owner;
}
