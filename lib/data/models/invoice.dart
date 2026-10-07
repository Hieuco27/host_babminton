import 'package:isar/isar.dart';
import 'session.dart';

part 'invoice.g.dart';

@collection
class Invoice {
  Id id = Isar.autoIncrement;

  final session = IsarLink<Session>();

  int courtFee;
  int shuttlecockCount;
  int shuttlecockPrice;
  int maleFee;
  int femaleFee;

  Invoice({
    required this.courtFee,
    required this.shuttlecockCount,
    required this.shuttlecockPrice,
    required this.maleFee,
    required this.femaleFee,
  });
}
