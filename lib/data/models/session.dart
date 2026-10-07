import 'package:isar/isar.dart';
import 'venue.dart';

part 'session.g.dart';

enum SessionStatus { draft, checkout, closed }

@collection
class Session {
  Id id = Isar.autoIncrement;

  String code;
  DateTime date;
  String startTime;
  String endTime;
  
  final venue = IsarLink<Venue>();

  int numberOfCourts;
  String? courtNumbers;
  int maxPlayers;
  int courtPricePerHour;
  int estimatedShuttlecockPrice;

  @enumerated
  SessionStatus status;
  
  DateTime? checkoutTime;

  Session({
    required this.code,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.numberOfCourts,
    this.courtNumbers,
    required this.maxPlayers,
    required this.courtPricePerHour,
    this.estimatedShuttlecockPrice = 0,
    this.status = SessionStatus.draft,
    this.checkoutTime,
  });
}
