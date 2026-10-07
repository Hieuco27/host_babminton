import 'package:isar/isar.dart';

part 'venue.g.dart';

// Sân, địa điểm
@collection
class Venue {
  Id id = Isar.autoIncrement;

  String name;
  String address;

  Venue({required this.name, this.address = ''});
}
