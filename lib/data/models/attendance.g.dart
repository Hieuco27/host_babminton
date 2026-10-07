// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAttendanceCollection on Isar {
  IsarCollection<Attendance> get attendances => this.collection();
}

const AttendanceSchema = CollectionSchema(
  name: r'Attendance',
  id: 4618409064190326501,
  properties: {
    r'attendanceStatus': PropertySchema(
      id: 0,
      name: r'attendanceStatus',
      type: IsarType.byte,
      enumMap: _AttendanceattendanceStatusEnumValueMap,
    ),
    r'feeToPay': PropertySchema(
      id: 1,
      name: r'feeToPay',
      type: IsarType.long,
    ),
    r'guestName': PropertySchema(
      id: 2,
      name: r'guestName',
      type: IsarType.string,
    ),
    r'isMale': PropertySchema(
      id: 3,
      name: r'isMale',
      type: IsarType.bool,
    ),
    r'paymentStatus': PropertySchema(
      id: 4,
      name: r'paymentStatus',
      type: IsarType.byte,
      enumMap: _AttendancepaymentStatusEnumValueMap,
    )
  },
  estimateSize: _attendanceEstimateSize,
  serialize: _attendanceSerialize,
  deserialize: _attendanceDeserialize,
  deserializeProp: _attendanceDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'session': LinkSchema(
      id: 5944158040800884724,
      name: r'session',
      target: r'Session',
      single: true,
    ),
    r'member': LinkSchema(
      id: 4039794109549137749,
      name: r'member',
      target: r'Member',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _attendanceGetId,
  getLinks: _attendanceGetLinks,
  attach: _attendanceAttach,
  version: '3.1.0+1',
);

int _attendanceEstimateSize(
  Attendance object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.guestName.length * 3;
  return bytesCount;
}

void _attendanceSerialize(
  Attendance object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.attendanceStatus.index);
  writer.writeLong(offsets[1], object.feeToPay);
  writer.writeString(offsets[2], object.guestName);
  writer.writeBool(offsets[3], object.isMale);
  writer.writeByte(offsets[4], object.paymentStatus.index);
}

Attendance _attendanceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Attendance(
    attendanceStatus: _AttendanceattendanceStatusValueEnumMap[
            reader.readByteOrNull(offsets[0])] ??
        AttendanceStatus.notVoted,
    feeToPay: reader.readLongOrNull(offsets[1]) ?? 0,
    guestName: reader.readStringOrNull(offsets[2]) ?? '',
    isMale: reader.readBool(offsets[3]),
    paymentStatus: _AttendancepaymentStatusValueEnumMap[
            reader.readByteOrNull(offsets[4])] ??
        PaymentStatus.unpaid,
  );
  object.id = id;
  return object;
}

P _attendanceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_AttendanceattendanceStatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          AttendanceStatus.notVoted) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (_AttendancepaymentStatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          PaymentStatus.unpaid) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AttendanceattendanceStatusEnumValueMap = {
  'notVoted': 0,
  'present': 1,
  'absent': 2,
};
const _AttendanceattendanceStatusValueEnumMap = {
  0: AttendanceStatus.notVoted,
  1: AttendanceStatus.present,
  2: AttendanceStatus.absent,
};
const _AttendancepaymentStatusEnumValueMap = {
  'unpaid': 0,
  'paid': 1,
};
const _AttendancepaymentStatusValueEnumMap = {
  0: PaymentStatus.unpaid,
  1: PaymentStatus.paid,
};

Id _attendanceGetId(Attendance object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _attendanceGetLinks(Attendance object) {
  return [object.session, object.member];
}

void _attendanceAttach(IsarCollection<dynamic> col, Id id, Attendance object) {
  object.id = id;
  object.session.attach(col, col.isar.collection<Session>(), r'session', id);
  object.member.attach(col, col.isar.collection<Member>(), r'member', id);
}

extension AttendanceQueryWhereSort
    on QueryBuilder<Attendance, Attendance, QWhere> {
  QueryBuilder<Attendance, Attendance, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AttendanceQueryWhere
    on QueryBuilder<Attendance, Attendance, QWhereClause> {
  QueryBuilder<Attendance, Attendance, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AttendanceQueryFilter
    on QueryBuilder<Attendance, Attendance, QFilterCondition> {
  QueryBuilder<Attendance, Attendance, QAfterFilterCondition>
      attendanceStatusEqualTo(AttendanceStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attendanceStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition>
      attendanceStatusGreaterThan(
    AttendanceStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'attendanceStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition>
      attendanceStatusLessThan(
    AttendanceStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'attendanceStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition>
      attendanceStatusBetween(
    AttendanceStatus lower,
    AttendanceStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'attendanceStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> feeToPayEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feeToPay',
        value: value,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition>
      feeToPayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'feeToPay',
        value: value,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> feeToPayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'feeToPay',
        value: value,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> feeToPayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'feeToPay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> guestNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'guestName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition>
      guestNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'guestName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> guestNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'guestName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> guestNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'guestName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition>
      guestNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'guestName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> guestNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'guestName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> guestNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'guestName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> guestNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'guestName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition>
      guestNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'guestName',
        value: '',
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition>
      guestNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'guestName',
        value: '',
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> isMaleEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMale',
        value: value,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition>
      paymentStatusEqualTo(PaymentStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition>
      paymentStatusGreaterThan(
    PaymentStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition>
      paymentStatusLessThan(
    PaymentStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition>
      paymentStatusBetween(
    PaymentStatus lower,
    PaymentStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AttendanceQueryObject
    on QueryBuilder<Attendance, Attendance, QFilterCondition> {}

extension AttendanceQueryLinks
    on QueryBuilder<Attendance, Attendance, QFilterCondition> {
  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> session(
      FilterQuery<Session> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'session');
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> sessionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'session', 0, true, 0, true);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> member(
      FilterQuery<Member> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'member');
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterFilterCondition> memberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'member', 0, true, 0, true);
    });
  }
}

extension AttendanceQuerySortBy
    on QueryBuilder<Attendance, Attendance, QSortBy> {
  QueryBuilder<Attendance, Attendance, QAfterSortBy> sortByAttendanceStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceStatus', Sort.asc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy>
      sortByAttendanceStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceStatus', Sort.desc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> sortByFeeToPay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeToPay', Sort.asc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> sortByFeeToPayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeToPay', Sort.desc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> sortByGuestName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guestName', Sort.asc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> sortByGuestNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guestName', Sort.desc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> sortByIsMale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMale', Sort.asc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> sortByIsMaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMale', Sort.desc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> sortByPaymentStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.asc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> sortByPaymentStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.desc);
    });
  }
}

extension AttendanceQuerySortThenBy
    on QueryBuilder<Attendance, Attendance, QSortThenBy> {
  QueryBuilder<Attendance, Attendance, QAfterSortBy> thenByAttendanceStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceStatus', Sort.asc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy>
      thenByAttendanceStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceStatus', Sort.desc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> thenByFeeToPay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeToPay', Sort.asc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> thenByFeeToPayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeToPay', Sort.desc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> thenByGuestName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guestName', Sort.asc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> thenByGuestNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guestName', Sort.desc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> thenByIsMale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMale', Sort.asc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> thenByIsMaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMale', Sort.desc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> thenByPaymentStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.asc);
    });
  }

  QueryBuilder<Attendance, Attendance, QAfterSortBy> thenByPaymentStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.desc);
    });
  }
}

extension AttendanceQueryWhereDistinct
    on QueryBuilder<Attendance, Attendance, QDistinct> {
  QueryBuilder<Attendance, Attendance, QDistinct> distinctByAttendanceStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attendanceStatus');
    });
  }

  QueryBuilder<Attendance, Attendance, QDistinct> distinctByFeeToPay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feeToPay');
    });
  }

  QueryBuilder<Attendance, Attendance, QDistinct> distinctByGuestName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'guestName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Attendance, Attendance, QDistinct> distinctByIsMale() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMale');
    });
  }

  QueryBuilder<Attendance, Attendance, QDistinct> distinctByPaymentStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentStatus');
    });
  }
}

extension AttendanceQueryProperty
    on QueryBuilder<Attendance, Attendance, QQueryProperty> {
  QueryBuilder<Attendance, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Attendance, AttendanceStatus, QQueryOperations>
      attendanceStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attendanceStatus');
    });
  }

  QueryBuilder<Attendance, int, QQueryOperations> feeToPayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feeToPay');
    });
  }

  QueryBuilder<Attendance, String, QQueryOperations> guestNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'guestName');
    });
  }

  QueryBuilder<Attendance, bool, QQueryOperations> isMaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMale');
    });
  }

  QueryBuilder<Attendance, PaymentStatus, QQueryOperations>
      paymentStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentStatus');
    });
  }
}
