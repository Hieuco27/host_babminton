import 'package:isar/isar.dart';
import 'session.dart';

part 'extra_fee.g.dart';

@collection
class ExtraFee {
  Id id = Isar.autoIncrement;

  final session = IsarLink<Session>();

  String name;
  int amount;

  ExtraFee({
    required this.name,
    required this.amount,
  });
}
