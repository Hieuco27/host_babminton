import 'package:isar/isar.dart';

part 'member.g.dart';

@collection
class Member {
  Id id = Isar.autoIncrement;

  String name;
  bool isMale;

  Member({
    required this.name,
    this.isMale = true,
  });
}
