// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CrimesTable extends Crimes with TableInfo<$CrimesTable, Crime> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CrimesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _firNoMeta = const VerificationMeta('firNo');
  @override
  late final GeneratedColumn<String> firNo = GeneratedColumn<String>(
    'fir_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionMeta = const VerificationMeta(
    'section',
  );
  @override
  late final GeneratedColumn<String> section = GeneratedColumn<String>(
    'section',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subSectionMeta = const VerificationMeta(
    'subSection',
  );
  @override
  late final GeneratedColumn<String> subSection = GeneratedColumn<String>(
    'sub_section',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stationIdMeta = const VerificationMeta(
    'stationId',
  );
  @override
  late final GeneratedColumn<int> stationId = GeneratedColumn<int>(
    'station_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _districtMeta = const VerificationMeta(
    'district',
  );
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
    'district',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _policeStationMeta = const VerificationMeta(
    'policeStation',
  );
  @override
  late final GeneratedColumn<String> policeStation = GeneratedColumn<String>(
    'police_station',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateOccurredMeta = const VerificationMeta(
    'dateOccurred',
  );
  @override
  late final GeneratedColumn<DateTime> dateOccurred = GeneratedColumn<DateTime>(
    'date_occurred',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeOccurredMeta = const VerificationMeta(
    'timeOccurred',
  );
  @override
  late final GeneratedColumn<String> timeOccurred = GeneratedColumn<String>(
    'time_occurred',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeOccurredMeta = const VerificationMeta(
    'placeOccurred',
  );
  @override
  late final GeneratedColumn<String> placeOccurred = GeneratedColumn<String>(
    'place_occurred',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateRegisteredMeta = const VerificationMeta(
    'dateRegistered',
  );
  @override
  late final GeneratedColumn<DateTime> dateRegistered =
      GeneratedColumn<DateTime>(
        'date_registered',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _timeRegisteredMeta = const VerificationMeta(
    'timeRegistered',
  );
  @override
  late final GeneratedColumn<String> timeRegistered = GeneratedColumn<String>(
    'time_registered',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _crimeTypeMeta = const VerificationMeta(
    'crimeType',
  );
  @override
  late final GeneratedColumn<String> crimeType = GeneratedColumn<String>(
    'crime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  static const VerificationMeta _detailedDescriptionMeta =
      const VerificationMeta('detailedDescription');
  @override
  late final GeneratedColumn<String> detailedDescription =
      GeneratedColumn<String>(
        'detailed_description',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firNo,
    year,
    section,
    subSection,
    stationId,
    district,
    policeStation,
    dateOccurred,
    timeOccurred,
    placeOccurred,
    dateRegistered,
    timeRegistered,
    crimeType,
    status,
    detailedDescription,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'crimes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Crime> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fir_no')) {
      context.handle(
        _firNoMeta,
        firNo.isAcceptableOrUnknown(data['fir_no']!, _firNoMeta),
      );
    } else if (isInserting) {
      context.missing(_firNoMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('section')) {
      context.handle(
        _sectionMeta,
        section.isAcceptableOrUnknown(data['section']!, _sectionMeta),
      );
    }
    if (data.containsKey('sub_section')) {
      context.handle(
        _subSectionMeta,
        subSection.isAcceptableOrUnknown(data['sub_section']!, _subSectionMeta),
      );
    }
    if (data.containsKey('station_id')) {
      context.handle(
        _stationIdMeta,
        stationId.isAcceptableOrUnknown(data['station_id']!, _stationIdMeta),
      );
    }
    if (data.containsKey('district')) {
      context.handle(
        _districtMeta,
        district.isAcceptableOrUnknown(data['district']!, _districtMeta),
      );
    }
    if (data.containsKey('police_station')) {
      context.handle(
        _policeStationMeta,
        policeStation.isAcceptableOrUnknown(
          data['police_station']!,
          _policeStationMeta,
        ),
      );
    }
    if (data.containsKey('date_occurred')) {
      context.handle(
        _dateOccurredMeta,
        dateOccurred.isAcceptableOrUnknown(
          data['date_occurred']!,
          _dateOccurredMeta,
        ),
      );
    }
    if (data.containsKey('time_occurred')) {
      context.handle(
        _timeOccurredMeta,
        timeOccurred.isAcceptableOrUnknown(
          data['time_occurred']!,
          _timeOccurredMeta,
        ),
      );
    }
    if (data.containsKey('place_occurred')) {
      context.handle(
        _placeOccurredMeta,
        placeOccurred.isAcceptableOrUnknown(
          data['place_occurred']!,
          _placeOccurredMeta,
        ),
      );
    }
    if (data.containsKey('date_registered')) {
      context.handle(
        _dateRegisteredMeta,
        dateRegistered.isAcceptableOrUnknown(
          data['date_registered']!,
          _dateRegisteredMeta,
        ),
      );
    }
    if (data.containsKey('time_registered')) {
      context.handle(
        _timeRegisteredMeta,
        timeRegistered.isAcceptableOrUnknown(
          data['time_registered']!,
          _timeRegisteredMeta,
        ),
      );
    }
    if (data.containsKey('crime_type')) {
      context.handle(
        _crimeTypeMeta,
        crimeType.isAcceptableOrUnknown(data['crime_type']!, _crimeTypeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('detailed_description')) {
      context.handle(
        _detailedDescriptionMeta,
        detailedDescription.isAcceptableOrUnknown(
          data['detailed_description']!,
          _detailedDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Crime map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Crime(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      firNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fir_no'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      section: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section'],
      ),
      subSection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_section'],
      ),
      stationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}station_id'],
      ),
      district: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}district'],
      ),
      policeStation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}police_station'],
      ),
      dateOccurred: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_occurred'],
      ),
      timeOccurred: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_occurred'],
      ),
      placeOccurred: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_occurred'],
      ),
      dateRegistered: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_registered'],
      ),
      timeRegistered: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_registered'],
      ),
      crimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crime_type'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      detailedDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detailed_description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CrimesTable createAlias(String alias) {
    return $CrimesTable(attachedDatabase, alias);
  }
}

class Crime extends DataClass implements Insertable<Crime> {
  final int id;
  final String firNo;
  final int year;
  final String? section;
  final String? subSection;
  final int? stationId;
  final String? district;
  final String? policeStation;
  final DateTime? dateOccurred;
  final String? timeOccurred;
  final String? placeOccurred;
  final DateTime? dateRegistered;
  final String? timeRegistered;
  final String? crimeType;
  final String status;
  final String? detailedDescription;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Crime({
    required this.id,
    required this.firNo,
    required this.year,
    this.section,
    this.subSection,
    this.stationId,
    this.district,
    this.policeStation,
    this.dateOccurred,
    this.timeOccurred,
    this.placeOccurred,
    this.dateRegistered,
    this.timeRegistered,
    this.crimeType,
    required this.status,
    this.detailedDescription,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fir_no'] = Variable<String>(firNo);
    map['year'] = Variable<int>(year);
    if (!nullToAbsent || section != null) {
      map['section'] = Variable<String>(section);
    }
    if (!nullToAbsent || subSection != null) {
      map['sub_section'] = Variable<String>(subSection);
    }
    if (!nullToAbsent || stationId != null) {
      map['station_id'] = Variable<int>(stationId);
    }
    if (!nullToAbsent || district != null) {
      map['district'] = Variable<String>(district);
    }
    if (!nullToAbsent || policeStation != null) {
      map['police_station'] = Variable<String>(policeStation);
    }
    if (!nullToAbsent || dateOccurred != null) {
      map['date_occurred'] = Variable<DateTime>(dateOccurred);
    }
    if (!nullToAbsent || timeOccurred != null) {
      map['time_occurred'] = Variable<String>(timeOccurred);
    }
    if (!nullToAbsent || placeOccurred != null) {
      map['place_occurred'] = Variable<String>(placeOccurred);
    }
    if (!nullToAbsent || dateRegistered != null) {
      map['date_registered'] = Variable<DateTime>(dateRegistered);
    }
    if (!nullToAbsent || timeRegistered != null) {
      map['time_registered'] = Variable<String>(timeRegistered);
    }
    if (!nullToAbsent || crimeType != null) {
      map['crime_type'] = Variable<String>(crimeType);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || detailedDescription != null) {
      map['detailed_description'] = Variable<String>(detailedDescription);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CrimesCompanion toCompanion(bool nullToAbsent) {
    return CrimesCompanion(
      id: Value(id),
      firNo: Value(firNo),
      year: Value(year),
      section: section == null && nullToAbsent
          ? const Value.absent()
          : Value(section),
      subSection: subSection == null && nullToAbsent
          ? const Value.absent()
          : Value(subSection),
      stationId: stationId == null && nullToAbsent
          ? const Value.absent()
          : Value(stationId),
      district: district == null && nullToAbsent
          ? const Value.absent()
          : Value(district),
      policeStation: policeStation == null && nullToAbsent
          ? const Value.absent()
          : Value(policeStation),
      dateOccurred: dateOccurred == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOccurred),
      timeOccurred: timeOccurred == null && nullToAbsent
          ? const Value.absent()
          : Value(timeOccurred),
      placeOccurred: placeOccurred == null && nullToAbsent
          ? const Value.absent()
          : Value(placeOccurred),
      dateRegistered: dateRegistered == null && nullToAbsent
          ? const Value.absent()
          : Value(dateRegistered),
      timeRegistered: timeRegistered == null && nullToAbsent
          ? const Value.absent()
          : Value(timeRegistered),
      crimeType: crimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(crimeType),
      status: Value(status),
      detailedDescription: detailedDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(detailedDescription),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Crime.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Crime(
      id: serializer.fromJson<int>(json['id']),
      firNo: serializer.fromJson<String>(json['firNo']),
      year: serializer.fromJson<int>(json['year']),
      section: serializer.fromJson<String?>(json['section']),
      subSection: serializer.fromJson<String?>(json['subSection']),
      stationId: serializer.fromJson<int?>(json['stationId']),
      district: serializer.fromJson<String?>(json['district']),
      policeStation: serializer.fromJson<String?>(json['policeStation']),
      dateOccurred: serializer.fromJson<DateTime?>(json['dateOccurred']),
      timeOccurred: serializer.fromJson<String?>(json['timeOccurred']),
      placeOccurred: serializer.fromJson<String?>(json['placeOccurred']),
      dateRegistered: serializer.fromJson<DateTime?>(json['dateRegistered']),
      timeRegistered: serializer.fromJson<String?>(json['timeRegistered']),
      crimeType: serializer.fromJson<String?>(json['crimeType']),
      status: serializer.fromJson<String>(json['status']),
      detailedDescription: serializer.fromJson<String?>(
        json['detailedDescription'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firNo': serializer.toJson<String>(firNo),
      'year': serializer.toJson<int>(year),
      'section': serializer.toJson<String?>(section),
      'subSection': serializer.toJson<String?>(subSection),
      'stationId': serializer.toJson<int?>(stationId),
      'district': serializer.toJson<String?>(district),
      'policeStation': serializer.toJson<String?>(policeStation),
      'dateOccurred': serializer.toJson<DateTime?>(dateOccurred),
      'timeOccurred': serializer.toJson<String?>(timeOccurred),
      'placeOccurred': serializer.toJson<String?>(placeOccurred),
      'dateRegistered': serializer.toJson<DateTime?>(dateRegistered),
      'timeRegistered': serializer.toJson<String?>(timeRegistered),
      'crimeType': serializer.toJson<String?>(crimeType),
      'status': serializer.toJson<String>(status),
      'detailedDescription': serializer.toJson<String?>(detailedDescription),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Crime copyWith({
    int? id,
    String? firNo,
    int? year,
    Value<String?> section = const Value.absent(),
    Value<String?> subSection = const Value.absent(),
    Value<int?> stationId = const Value.absent(),
    Value<String?> district = const Value.absent(),
    Value<String?> policeStation = const Value.absent(),
    Value<DateTime?> dateOccurred = const Value.absent(),
    Value<String?> timeOccurred = const Value.absent(),
    Value<String?> placeOccurred = const Value.absent(),
    Value<DateTime?> dateRegistered = const Value.absent(),
    Value<String?> timeRegistered = const Value.absent(),
    Value<String?> crimeType = const Value.absent(),
    String? status,
    Value<String?> detailedDescription = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Crime(
    id: id ?? this.id,
    firNo: firNo ?? this.firNo,
    year: year ?? this.year,
    section: section.present ? section.value : this.section,
    subSection: subSection.present ? subSection.value : this.subSection,
    stationId: stationId.present ? stationId.value : this.stationId,
    district: district.present ? district.value : this.district,
    policeStation: policeStation.present
        ? policeStation.value
        : this.policeStation,
    dateOccurred: dateOccurred.present ? dateOccurred.value : this.dateOccurred,
    timeOccurred: timeOccurred.present ? timeOccurred.value : this.timeOccurred,
    placeOccurred: placeOccurred.present
        ? placeOccurred.value
        : this.placeOccurred,
    dateRegistered: dateRegistered.present
        ? dateRegistered.value
        : this.dateRegistered,
    timeRegistered: timeRegistered.present
        ? timeRegistered.value
        : this.timeRegistered,
    crimeType: crimeType.present ? crimeType.value : this.crimeType,
    status: status ?? this.status,
    detailedDescription: detailedDescription.present
        ? detailedDescription.value
        : this.detailedDescription,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Crime copyWithCompanion(CrimesCompanion data) {
    return Crime(
      id: data.id.present ? data.id.value : this.id,
      firNo: data.firNo.present ? data.firNo.value : this.firNo,
      year: data.year.present ? data.year.value : this.year,
      section: data.section.present ? data.section.value : this.section,
      subSection: data.subSection.present
          ? data.subSection.value
          : this.subSection,
      stationId: data.stationId.present ? data.stationId.value : this.stationId,
      district: data.district.present ? data.district.value : this.district,
      policeStation: data.policeStation.present
          ? data.policeStation.value
          : this.policeStation,
      dateOccurred: data.dateOccurred.present
          ? data.dateOccurred.value
          : this.dateOccurred,
      timeOccurred: data.timeOccurred.present
          ? data.timeOccurred.value
          : this.timeOccurred,
      placeOccurred: data.placeOccurred.present
          ? data.placeOccurred.value
          : this.placeOccurred,
      dateRegistered: data.dateRegistered.present
          ? data.dateRegistered.value
          : this.dateRegistered,
      timeRegistered: data.timeRegistered.present
          ? data.timeRegistered.value
          : this.timeRegistered,
      crimeType: data.crimeType.present ? data.crimeType.value : this.crimeType,
      status: data.status.present ? data.status.value : this.status,
      detailedDescription: data.detailedDescription.present
          ? data.detailedDescription.value
          : this.detailedDescription,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Crime(')
          ..write('id: $id, ')
          ..write('firNo: $firNo, ')
          ..write('year: $year, ')
          ..write('section: $section, ')
          ..write('subSection: $subSection, ')
          ..write('stationId: $stationId, ')
          ..write('district: $district, ')
          ..write('policeStation: $policeStation, ')
          ..write('dateOccurred: $dateOccurred, ')
          ..write('timeOccurred: $timeOccurred, ')
          ..write('placeOccurred: $placeOccurred, ')
          ..write('dateRegistered: $dateRegistered, ')
          ..write('timeRegistered: $timeRegistered, ')
          ..write('crimeType: $crimeType, ')
          ..write('status: $status, ')
          ..write('detailedDescription: $detailedDescription, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    firNo,
    year,
    section,
    subSection,
    stationId,
    district,
    policeStation,
    dateOccurred,
    timeOccurred,
    placeOccurred,
    dateRegistered,
    timeRegistered,
    crimeType,
    status,
    detailedDescription,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Crime &&
          other.id == this.id &&
          other.firNo == this.firNo &&
          other.year == this.year &&
          other.section == this.section &&
          other.subSection == this.subSection &&
          other.stationId == this.stationId &&
          other.district == this.district &&
          other.policeStation == this.policeStation &&
          other.dateOccurred == this.dateOccurred &&
          other.timeOccurred == this.timeOccurred &&
          other.placeOccurred == this.placeOccurred &&
          other.dateRegistered == this.dateRegistered &&
          other.timeRegistered == this.timeRegistered &&
          other.crimeType == this.crimeType &&
          other.status == this.status &&
          other.detailedDescription == this.detailedDescription &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CrimesCompanion extends UpdateCompanion<Crime> {
  final Value<int> id;
  final Value<String> firNo;
  final Value<int> year;
  final Value<String?> section;
  final Value<String?> subSection;
  final Value<int?> stationId;
  final Value<String?> district;
  final Value<String?> policeStation;
  final Value<DateTime?> dateOccurred;
  final Value<String?> timeOccurred;
  final Value<String?> placeOccurred;
  final Value<DateTime?> dateRegistered;
  final Value<String?> timeRegistered;
  final Value<String?> crimeType;
  final Value<String> status;
  final Value<String?> detailedDescription;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CrimesCompanion({
    this.id = const Value.absent(),
    this.firNo = const Value.absent(),
    this.year = const Value.absent(),
    this.section = const Value.absent(),
    this.subSection = const Value.absent(),
    this.stationId = const Value.absent(),
    this.district = const Value.absent(),
    this.policeStation = const Value.absent(),
    this.dateOccurred = const Value.absent(),
    this.timeOccurred = const Value.absent(),
    this.placeOccurred = const Value.absent(),
    this.dateRegistered = const Value.absent(),
    this.timeRegistered = const Value.absent(),
    this.crimeType = const Value.absent(),
    this.status = const Value.absent(),
    this.detailedDescription = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CrimesCompanion.insert({
    this.id = const Value.absent(),
    required String firNo,
    required int year,
    this.section = const Value.absent(),
    this.subSection = const Value.absent(),
    this.stationId = const Value.absent(),
    this.district = const Value.absent(),
    this.policeStation = const Value.absent(),
    this.dateOccurred = const Value.absent(),
    this.timeOccurred = const Value.absent(),
    this.placeOccurred = const Value.absent(),
    this.dateRegistered = const Value.absent(),
    this.timeRegistered = const Value.absent(),
    this.crimeType = const Value.absent(),
    this.status = const Value.absent(),
    this.detailedDescription = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : firNo = Value(firNo),
       year = Value(year);
  static Insertable<Crime> custom({
    Expression<int>? id,
    Expression<String>? firNo,
    Expression<int>? year,
    Expression<String>? section,
    Expression<String>? subSection,
    Expression<int>? stationId,
    Expression<String>? district,
    Expression<String>? policeStation,
    Expression<DateTime>? dateOccurred,
    Expression<String>? timeOccurred,
    Expression<String>? placeOccurred,
    Expression<DateTime>? dateRegistered,
    Expression<String>? timeRegistered,
    Expression<String>? crimeType,
    Expression<String>? status,
    Expression<String>? detailedDescription,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firNo != null) 'fir_no': firNo,
      if (year != null) 'year': year,
      if (section != null) 'section': section,
      if (subSection != null) 'sub_section': subSection,
      if (stationId != null) 'station_id': stationId,
      if (district != null) 'district': district,
      if (policeStation != null) 'police_station': policeStation,
      if (dateOccurred != null) 'date_occurred': dateOccurred,
      if (timeOccurred != null) 'time_occurred': timeOccurred,
      if (placeOccurred != null) 'place_occurred': placeOccurred,
      if (dateRegistered != null) 'date_registered': dateRegistered,
      if (timeRegistered != null) 'time_registered': timeRegistered,
      if (crimeType != null) 'crime_type': crimeType,
      if (status != null) 'status': status,
      if (detailedDescription != null)
        'detailed_description': detailedDescription,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CrimesCompanion copyWith({
    Value<int>? id,
    Value<String>? firNo,
    Value<int>? year,
    Value<String?>? section,
    Value<String?>? subSection,
    Value<int?>? stationId,
    Value<String?>? district,
    Value<String?>? policeStation,
    Value<DateTime?>? dateOccurred,
    Value<String?>? timeOccurred,
    Value<String?>? placeOccurred,
    Value<DateTime?>? dateRegistered,
    Value<String?>? timeRegistered,
    Value<String?>? crimeType,
    Value<String>? status,
    Value<String?>? detailedDescription,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CrimesCompanion(
      id: id ?? this.id,
      firNo: firNo ?? this.firNo,
      year: year ?? this.year,
      section: section ?? this.section,
      subSection: subSection ?? this.subSection,
      stationId: stationId ?? this.stationId,
      district: district ?? this.district,
      policeStation: policeStation ?? this.policeStation,
      dateOccurred: dateOccurred ?? this.dateOccurred,
      timeOccurred: timeOccurred ?? this.timeOccurred,
      placeOccurred: placeOccurred ?? this.placeOccurred,
      dateRegistered: dateRegistered ?? this.dateRegistered,
      timeRegistered: timeRegistered ?? this.timeRegistered,
      crimeType: crimeType ?? this.crimeType,
      status: status ?? this.status,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firNo.present) {
      map['fir_no'] = Variable<String>(firNo.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (section.present) {
      map['section'] = Variable<String>(section.value);
    }
    if (subSection.present) {
      map['sub_section'] = Variable<String>(subSection.value);
    }
    if (stationId.present) {
      map['station_id'] = Variable<int>(stationId.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (policeStation.present) {
      map['police_station'] = Variable<String>(policeStation.value);
    }
    if (dateOccurred.present) {
      map['date_occurred'] = Variable<DateTime>(dateOccurred.value);
    }
    if (timeOccurred.present) {
      map['time_occurred'] = Variable<String>(timeOccurred.value);
    }
    if (placeOccurred.present) {
      map['place_occurred'] = Variable<String>(placeOccurred.value);
    }
    if (dateRegistered.present) {
      map['date_registered'] = Variable<DateTime>(dateRegistered.value);
    }
    if (timeRegistered.present) {
      map['time_registered'] = Variable<String>(timeRegistered.value);
    }
    if (crimeType.present) {
      map['crime_type'] = Variable<String>(crimeType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (detailedDescription.present) {
      map['detailed_description'] = Variable<String>(detailedDescription.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CrimesCompanion(')
          ..write('id: $id, ')
          ..write('firNo: $firNo, ')
          ..write('year: $year, ')
          ..write('section: $section, ')
          ..write('subSection: $subSection, ')
          ..write('stationId: $stationId, ')
          ..write('district: $district, ')
          ..write('policeStation: $policeStation, ')
          ..write('dateOccurred: $dateOccurred, ')
          ..write('timeOccurred: $timeOccurred, ')
          ..write('placeOccurred: $placeOccurred, ')
          ..write('dateRegistered: $dateRegistered, ')
          ..write('timeRegistered: $timeRegistered, ')
          ..write('crimeType: $crimeType, ')
          ..write('status: $status, ')
          ..write('detailedDescription: $detailedDescription, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ComplainantsTable extends Complainants
    with TableInfo<$ComplainantsTable, Complainant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComplainantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _crimeIdMeta = const VerificationMeta(
    'crimeId',
  );
  @override
  late final GeneratedColumn<int> crimeId = GeneratedColumn<int>(
    'crime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crimes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
    'mobile',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aadhaarEncMeta = const VerificationMeta(
    'aadhaarEnc',
  );
  @override
  late final GeneratedColumn<String> aadhaarEnc = GeneratedColumn<String>(
    'aadhaar_enc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _panEncMeta = const VerificationMeta('panEnc');
  @override
  late final GeneratedColumn<String> panEnc = GeneratedColumn<String>(
    'pan_enc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passportMeta = const VerificationMeta(
    'passport',
  );
  @override
  late final GeneratedColumn<String> passport = GeneratedColumn<String>(
    'passport',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    crimeId,
    name,
    gender,
    age,
    address,
    mobile,
    email,
    aadhaarEnc,
    panEnc,
    passport,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'complainants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Complainant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('crime_id')) {
      context.handle(
        _crimeIdMeta,
        crimeId.isAcceptableOrUnknown(data['crime_id']!, _crimeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_crimeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('mobile')) {
      context.handle(
        _mobileMeta,
        mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('aadhaar_enc')) {
      context.handle(
        _aadhaarEncMeta,
        aadhaarEnc.isAcceptableOrUnknown(data['aadhaar_enc']!, _aadhaarEncMeta),
      );
    }
    if (data.containsKey('pan_enc')) {
      context.handle(
        _panEncMeta,
        panEnc.isAcceptableOrUnknown(data['pan_enc']!, _panEncMeta),
      );
    }
    if (data.containsKey('passport')) {
      context.handle(
        _passportMeta,
        passport.isAcceptableOrUnknown(data['passport']!, _passportMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Complainant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Complainant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      crimeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}crime_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      mobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      aadhaarEnc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aadhaar_enc'],
      ),
      panEnc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pan_enc'],
      ),
      passport: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}passport'],
      ),
    );
  }

  @override
  $ComplainantsTable createAlias(String alias) {
    return $ComplainantsTable(attachedDatabase, alias);
  }
}

class Complainant extends DataClass implements Insertable<Complainant> {
  final int id;
  final int crimeId;
  final String name;
  final String? gender;
  final int? age;
  final String? address;
  final String? mobile;
  final String? email;
  final String? aadhaarEnc;
  final String? panEnc;
  final String? passport;
  const Complainant({
    required this.id,
    required this.crimeId,
    required this.name,
    this.gender,
    this.age,
    this.address,
    this.mobile,
    this.email,
    this.aadhaarEnc,
    this.panEnc,
    this.passport,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['crime_id'] = Variable<int>(crimeId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || mobile != null) {
      map['mobile'] = Variable<String>(mobile);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || aadhaarEnc != null) {
      map['aadhaar_enc'] = Variable<String>(aadhaarEnc);
    }
    if (!nullToAbsent || panEnc != null) {
      map['pan_enc'] = Variable<String>(panEnc);
    }
    if (!nullToAbsent || passport != null) {
      map['passport'] = Variable<String>(passport);
    }
    return map;
  }

  ComplainantsCompanion toCompanion(bool nullToAbsent) {
    return ComplainantsCompanion(
      id: Value(id),
      crimeId: Value(crimeId),
      name: Value(name),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      mobile: mobile == null && nullToAbsent
          ? const Value.absent()
          : Value(mobile),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      aadhaarEnc: aadhaarEnc == null && nullToAbsent
          ? const Value.absent()
          : Value(aadhaarEnc),
      panEnc: panEnc == null && nullToAbsent
          ? const Value.absent()
          : Value(panEnc),
      passport: passport == null && nullToAbsent
          ? const Value.absent()
          : Value(passport),
    );
  }

  factory Complainant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Complainant(
      id: serializer.fromJson<int>(json['id']),
      crimeId: serializer.fromJson<int>(json['crimeId']),
      name: serializer.fromJson<String>(json['name']),
      gender: serializer.fromJson<String?>(json['gender']),
      age: serializer.fromJson<int?>(json['age']),
      address: serializer.fromJson<String?>(json['address']),
      mobile: serializer.fromJson<String?>(json['mobile']),
      email: serializer.fromJson<String?>(json['email']),
      aadhaarEnc: serializer.fromJson<String?>(json['aadhaarEnc']),
      panEnc: serializer.fromJson<String?>(json['panEnc']),
      passport: serializer.fromJson<String?>(json['passport']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'crimeId': serializer.toJson<int>(crimeId),
      'name': serializer.toJson<String>(name),
      'gender': serializer.toJson<String?>(gender),
      'age': serializer.toJson<int?>(age),
      'address': serializer.toJson<String?>(address),
      'mobile': serializer.toJson<String?>(mobile),
      'email': serializer.toJson<String?>(email),
      'aadhaarEnc': serializer.toJson<String?>(aadhaarEnc),
      'panEnc': serializer.toJson<String?>(panEnc),
      'passport': serializer.toJson<String?>(passport),
    };
  }

  Complainant copyWith({
    int? id,
    int? crimeId,
    String? name,
    Value<String?> gender = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> mobile = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> aadhaarEnc = const Value.absent(),
    Value<String?> panEnc = const Value.absent(),
    Value<String?> passport = const Value.absent(),
  }) => Complainant(
    id: id ?? this.id,
    crimeId: crimeId ?? this.crimeId,
    name: name ?? this.name,
    gender: gender.present ? gender.value : this.gender,
    age: age.present ? age.value : this.age,
    address: address.present ? address.value : this.address,
    mobile: mobile.present ? mobile.value : this.mobile,
    email: email.present ? email.value : this.email,
    aadhaarEnc: aadhaarEnc.present ? aadhaarEnc.value : this.aadhaarEnc,
    panEnc: panEnc.present ? panEnc.value : this.panEnc,
    passport: passport.present ? passport.value : this.passport,
  );
  Complainant copyWithCompanion(ComplainantsCompanion data) {
    return Complainant(
      id: data.id.present ? data.id.value : this.id,
      crimeId: data.crimeId.present ? data.crimeId.value : this.crimeId,
      name: data.name.present ? data.name.value : this.name,
      gender: data.gender.present ? data.gender.value : this.gender,
      age: data.age.present ? data.age.value : this.age,
      address: data.address.present ? data.address.value : this.address,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      email: data.email.present ? data.email.value : this.email,
      aadhaarEnc: data.aadhaarEnc.present
          ? data.aadhaarEnc.value
          : this.aadhaarEnc,
      panEnc: data.panEnc.present ? data.panEnc.value : this.panEnc,
      passport: data.passport.present ? data.passport.value : this.passport,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Complainant(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('age: $age, ')
          ..write('address: $address, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('aadhaarEnc: $aadhaarEnc, ')
          ..write('panEnc: $panEnc, ')
          ..write('passport: $passport')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    crimeId,
    name,
    gender,
    age,
    address,
    mobile,
    email,
    aadhaarEnc,
    panEnc,
    passport,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Complainant &&
          other.id == this.id &&
          other.crimeId == this.crimeId &&
          other.name == this.name &&
          other.gender == this.gender &&
          other.age == this.age &&
          other.address == this.address &&
          other.mobile == this.mobile &&
          other.email == this.email &&
          other.aadhaarEnc == this.aadhaarEnc &&
          other.panEnc == this.panEnc &&
          other.passport == this.passport);
}

class ComplainantsCompanion extends UpdateCompanion<Complainant> {
  final Value<int> id;
  final Value<int> crimeId;
  final Value<String> name;
  final Value<String?> gender;
  final Value<int?> age;
  final Value<String?> address;
  final Value<String?> mobile;
  final Value<String?> email;
  final Value<String?> aadhaarEnc;
  final Value<String?> panEnc;
  final Value<String?> passport;
  const ComplainantsCompanion({
    this.id = const Value.absent(),
    this.crimeId = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.age = const Value.absent(),
    this.address = const Value.absent(),
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.aadhaarEnc = const Value.absent(),
    this.panEnc = const Value.absent(),
    this.passport = const Value.absent(),
  });
  ComplainantsCompanion.insert({
    this.id = const Value.absent(),
    required int crimeId,
    required String name,
    this.gender = const Value.absent(),
    this.age = const Value.absent(),
    this.address = const Value.absent(),
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.aadhaarEnc = const Value.absent(),
    this.panEnc = const Value.absent(),
    this.passport = const Value.absent(),
  }) : crimeId = Value(crimeId),
       name = Value(name);
  static Insertable<Complainant> custom({
    Expression<int>? id,
    Expression<int>? crimeId,
    Expression<String>? name,
    Expression<String>? gender,
    Expression<int>? age,
    Expression<String>? address,
    Expression<String>? mobile,
    Expression<String>? email,
    Expression<String>? aadhaarEnc,
    Expression<String>? panEnc,
    Expression<String>? passport,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crimeId != null) 'crime_id': crimeId,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (age != null) 'age': age,
      if (address != null) 'address': address,
      if (mobile != null) 'mobile': mobile,
      if (email != null) 'email': email,
      if (aadhaarEnc != null) 'aadhaar_enc': aadhaarEnc,
      if (panEnc != null) 'pan_enc': panEnc,
      if (passport != null) 'passport': passport,
    });
  }

  ComplainantsCompanion copyWith({
    Value<int>? id,
    Value<int>? crimeId,
    Value<String>? name,
    Value<String?>? gender,
    Value<int?>? age,
    Value<String?>? address,
    Value<String?>? mobile,
    Value<String?>? email,
    Value<String?>? aadhaarEnc,
    Value<String?>? panEnc,
    Value<String?>? passport,
  }) {
    return ComplainantsCompanion(
      id: id ?? this.id,
      crimeId: crimeId ?? this.crimeId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      address: address ?? this.address,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      aadhaarEnc: aadhaarEnc ?? this.aadhaarEnc,
      panEnc: panEnc ?? this.panEnc,
      passport: passport ?? this.passport,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (crimeId.present) {
      map['crime_id'] = Variable<int>(crimeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (aadhaarEnc.present) {
      map['aadhaar_enc'] = Variable<String>(aadhaarEnc.value);
    }
    if (panEnc.present) {
      map['pan_enc'] = Variable<String>(panEnc.value);
    }
    if (passport.present) {
      map['passport'] = Variable<String>(passport.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComplainantsCompanion(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('age: $age, ')
          ..write('address: $address, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('aadhaarEnc: $aadhaarEnc, ')
          ..write('panEnc: $panEnc, ')
          ..write('passport: $passport')
          ..write(')'))
        .toString();
  }
}

class $AccusedTable extends Accused with TableInfo<$AccusedTable, AccusedData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccusedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _crimeIdMeta = const VerificationMeta(
    'crimeId',
  );
  @override
  late final GeneratedColumn<int> crimeId = GeneratedColumn<int>(
    'crime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crimes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
    'mobile',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aadhaarEncMeta = const VerificationMeta(
    'aadhaarEnc',
  );
  @override
  late final GeneratedColumn<String> aadhaarEnc = GeneratedColumn<String>(
    'aadhaar_enc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _panEncMeta = const VerificationMeta('panEnc');
  @override
  late final GeneratedColumn<String> panEnc = GeneratedColumn<String>(
    'pan_enc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passportMeta = const VerificationMeta(
    'passport',
  );
  @override
  late final GeneratedColumn<String> passport = GeneratedColumn<String>(
    'passport',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _arrestStatusMeta = const VerificationMeta(
    'arrestStatus',
  );
  @override
  late final GeneratedColumn<String> arrestStatus = GeneratedColumn<String>(
    'arrest_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _arrestDateMeta = const VerificationMeta(
    'arrestDate',
  );
  @override
  late final GeneratedColumn<DateTime> arrestDate = GeneratedColumn<DateTime>(
    'arrest_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _arrestTimeMeta = const VerificationMeta(
    'arrestTime',
  );
  @override
  late final GeneratedColumn<String> arrestTime = GeneratedColumn<String>(
    'arrest_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    crimeId,
    name,
    gender,
    age,
    address,
    mobile,
    email,
    aadhaarEnc,
    panEnc,
    passport,
    arrestStatus,
    arrestDate,
    arrestTime,
    photoPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accused';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccusedData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('crime_id')) {
      context.handle(
        _crimeIdMeta,
        crimeId.isAcceptableOrUnknown(data['crime_id']!, _crimeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_crimeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('mobile')) {
      context.handle(
        _mobileMeta,
        mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('aadhaar_enc')) {
      context.handle(
        _aadhaarEncMeta,
        aadhaarEnc.isAcceptableOrUnknown(data['aadhaar_enc']!, _aadhaarEncMeta),
      );
    }
    if (data.containsKey('pan_enc')) {
      context.handle(
        _panEncMeta,
        panEnc.isAcceptableOrUnknown(data['pan_enc']!, _panEncMeta),
      );
    }
    if (data.containsKey('passport')) {
      context.handle(
        _passportMeta,
        passport.isAcceptableOrUnknown(data['passport']!, _passportMeta),
      );
    }
    if (data.containsKey('arrest_status')) {
      context.handle(
        _arrestStatusMeta,
        arrestStatus.isAcceptableOrUnknown(
          data['arrest_status']!,
          _arrestStatusMeta,
        ),
      );
    }
    if (data.containsKey('arrest_date')) {
      context.handle(
        _arrestDateMeta,
        arrestDate.isAcceptableOrUnknown(data['arrest_date']!, _arrestDateMeta),
      );
    }
    if (data.containsKey('arrest_time')) {
      context.handle(
        _arrestTimeMeta,
        arrestTime.isAcceptableOrUnknown(data['arrest_time']!, _arrestTimeMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccusedData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccusedData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      crimeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}crime_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      mobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      aadhaarEnc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aadhaar_enc'],
      ),
      panEnc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pan_enc'],
      ),
      passport: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}passport'],
      ),
      arrestStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arrest_status'],
      ),
      arrestDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}arrest_date'],
      ),
      arrestTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arrest_time'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
    );
  }

  @override
  $AccusedTable createAlias(String alias) {
    return $AccusedTable(attachedDatabase, alias);
  }
}

class AccusedData extends DataClass implements Insertable<AccusedData> {
  final int id;
  final int crimeId;
  final String name;
  final String? gender;
  final int? age;
  final String? address;
  final String? mobile;
  final String? email;
  final String? aadhaarEnc;
  final String? panEnc;
  final String? passport;
  final String? arrestStatus;
  final DateTime? arrestDate;
  final String? arrestTime;
  final String? photoPath;
  const AccusedData({
    required this.id,
    required this.crimeId,
    required this.name,
    this.gender,
    this.age,
    this.address,
    this.mobile,
    this.email,
    this.aadhaarEnc,
    this.panEnc,
    this.passport,
    this.arrestStatus,
    this.arrestDate,
    this.arrestTime,
    this.photoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['crime_id'] = Variable<int>(crimeId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || mobile != null) {
      map['mobile'] = Variable<String>(mobile);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || aadhaarEnc != null) {
      map['aadhaar_enc'] = Variable<String>(aadhaarEnc);
    }
    if (!nullToAbsent || panEnc != null) {
      map['pan_enc'] = Variable<String>(panEnc);
    }
    if (!nullToAbsent || passport != null) {
      map['passport'] = Variable<String>(passport);
    }
    if (!nullToAbsent || arrestStatus != null) {
      map['arrest_status'] = Variable<String>(arrestStatus);
    }
    if (!nullToAbsent || arrestDate != null) {
      map['arrest_date'] = Variable<DateTime>(arrestDate);
    }
    if (!nullToAbsent || arrestTime != null) {
      map['arrest_time'] = Variable<String>(arrestTime);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  AccusedCompanion toCompanion(bool nullToAbsent) {
    return AccusedCompanion(
      id: Value(id),
      crimeId: Value(crimeId),
      name: Value(name),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      mobile: mobile == null && nullToAbsent
          ? const Value.absent()
          : Value(mobile),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      aadhaarEnc: aadhaarEnc == null && nullToAbsent
          ? const Value.absent()
          : Value(aadhaarEnc),
      panEnc: panEnc == null && nullToAbsent
          ? const Value.absent()
          : Value(panEnc),
      passport: passport == null && nullToAbsent
          ? const Value.absent()
          : Value(passport),
      arrestStatus: arrestStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(arrestStatus),
      arrestDate: arrestDate == null && nullToAbsent
          ? const Value.absent()
          : Value(arrestDate),
      arrestTime: arrestTime == null && nullToAbsent
          ? const Value.absent()
          : Value(arrestTime),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
    );
  }

  factory AccusedData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccusedData(
      id: serializer.fromJson<int>(json['id']),
      crimeId: serializer.fromJson<int>(json['crimeId']),
      name: serializer.fromJson<String>(json['name']),
      gender: serializer.fromJson<String?>(json['gender']),
      age: serializer.fromJson<int?>(json['age']),
      address: serializer.fromJson<String?>(json['address']),
      mobile: serializer.fromJson<String?>(json['mobile']),
      email: serializer.fromJson<String?>(json['email']),
      aadhaarEnc: serializer.fromJson<String?>(json['aadhaarEnc']),
      panEnc: serializer.fromJson<String?>(json['panEnc']),
      passport: serializer.fromJson<String?>(json['passport']),
      arrestStatus: serializer.fromJson<String?>(json['arrestStatus']),
      arrestDate: serializer.fromJson<DateTime?>(json['arrestDate']),
      arrestTime: serializer.fromJson<String?>(json['arrestTime']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'crimeId': serializer.toJson<int>(crimeId),
      'name': serializer.toJson<String>(name),
      'gender': serializer.toJson<String?>(gender),
      'age': serializer.toJson<int?>(age),
      'address': serializer.toJson<String?>(address),
      'mobile': serializer.toJson<String?>(mobile),
      'email': serializer.toJson<String?>(email),
      'aadhaarEnc': serializer.toJson<String?>(aadhaarEnc),
      'panEnc': serializer.toJson<String?>(panEnc),
      'passport': serializer.toJson<String?>(passport),
      'arrestStatus': serializer.toJson<String?>(arrestStatus),
      'arrestDate': serializer.toJson<DateTime?>(arrestDate),
      'arrestTime': serializer.toJson<String?>(arrestTime),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  AccusedData copyWith({
    int? id,
    int? crimeId,
    String? name,
    Value<String?> gender = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> mobile = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> aadhaarEnc = const Value.absent(),
    Value<String?> panEnc = const Value.absent(),
    Value<String?> passport = const Value.absent(),
    Value<String?> arrestStatus = const Value.absent(),
    Value<DateTime?> arrestDate = const Value.absent(),
    Value<String?> arrestTime = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
  }) => AccusedData(
    id: id ?? this.id,
    crimeId: crimeId ?? this.crimeId,
    name: name ?? this.name,
    gender: gender.present ? gender.value : this.gender,
    age: age.present ? age.value : this.age,
    address: address.present ? address.value : this.address,
    mobile: mobile.present ? mobile.value : this.mobile,
    email: email.present ? email.value : this.email,
    aadhaarEnc: aadhaarEnc.present ? aadhaarEnc.value : this.aadhaarEnc,
    panEnc: panEnc.present ? panEnc.value : this.panEnc,
    passport: passport.present ? passport.value : this.passport,
    arrestStatus: arrestStatus.present ? arrestStatus.value : this.arrestStatus,
    arrestDate: arrestDate.present ? arrestDate.value : this.arrestDate,
    arrestTime: arrestTime.present ? arrestTime.value : this.arrestTime,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
  );
  AccusedData copyWithCompanion(AccusedCompanion data) {
    return AccusedData(
      id: data.id.present ? data.id.value : this.id,
      crimeId: data.crimeId.present ? data.crimeId.value : this.crimeId,
      name: data.name.present ? data.name.value : this.name,
      gender: data.gender.present ? data.gender.value : this.gender,
      age: data.age.present ? data.age.value : this.age,
      address: data.address.present ? data.address.value : this.address,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      email: data.email.present ? data.email.value : this.email,
      aadhaarEnc: data.aadhaarEnc.present
          ? data.aadhaarEnc.value
          : this.aadhaarEnc,
      panEnc: data.panEnc.present ? data.panEnc.value : this.panEnc,
      passport: data.passport.present ? data.passport.value : this.passport,
      arrestStatus: data.arrestStatus.present
          ? data.arrestStatus.value
          : this.arrestStatus,
      arrestDate: data.arrestDate.present
          ? data.arrestDate.value
          : this.arrestDate,
      arrestTime: data.arrestTime.present
          ? data.arrestTime.value
          : this.arrestTime,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccusedData(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('age: $age, ')
          ..write('address: $address, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('aadhaarEnc: $aadhaarEnc, ')
          ..write('panEnc: $panEnc, ')
          ..write('passport: $passport, ')
          ..write('arrestStatus: $arrestStatus, ')
          ..write('arrestDate: $arrestDate, ')
          ..write('arrestTime: $arrestTime, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    crimeId,
    name,
    gender,
    age,
    address,
    mobile,
    email,
    aadhaarEnc,
    panEnc,
    passport,
    arrestStatus,
    arrestDate,
    arrestTime,
    photoPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccusedData &&
          other.id == this.id &&
          other.crimeId == this.crimeId &&
          other.name == this.name &&
          other.gender == this.gender &&
          other.age == this.age &&
          other.address == this.address &&
          other.mobile == this.mobile &&
          other.email == this.email &&
          other.aadhaarEnc == this.aadhaarEnc &&
          other.panEnc == this.panEnc &&
          other.passport == this.passport &&
          other.arrestStatus == this.arrestStatus &&
          other.arrestDate == this.arrestDate &&
          other.arrestTime == this.arrestTime &&
          other.photoPath == this.photoPath);
}

class AccusedCompanion extends UpdateCompanion<AccusedData> {
  final Value<int> id;
  final Value<int> crimeId;
  final Value<String> name;
  final Value<String?> gender;
  final Value<int?> age;
  final Value<String?> address;
  final Value<String?> mobile;
  final Value<String?> email;
  final Value<String?> aadhaarEnc;
  final Value<String?> panEnc;
  final Value<String?> passport;
  final Value<String?> arrestStatus;
  final Value<DateTime?> arrestDate;
  final Value<String?> arrestTime;
  final Value<String?> photoPath;
  const AccusedCompanion({
    this.id = const Value.absent(),
    this.crimeId = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.age = const Value.absent(),
    this.address = const Value.absent(),
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.aadhaarEnc = const Value.absent(),
    this.panEnc = const Value.absent(),
    this.passport = const Value.absent(),
    this.arrestStatus = const Value.absent(),
    this.arrestDate = const Value.absent(),
    this.arrestTime = const Value.absent(),
    this.photoPath = const Value.absent(),
  });
  AccusedCompanion.insert({
    this.id = const Value.absent(),
    required int crimeId,
    required String name,
    this.gender = const Value.absent(),
    this.age = const Value.absent(),
    this.address = const Value.absent(),
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.aadhaarEnc = const Value.absent(),
    this.panEnc = const Value.absent(),
    this.passport = const Value.absent(),
    this.arrestStatus = const Value.absent(),
    this.arrestDate = const Value.absent(),
    this.arrestTime = const Value.absent(),
    this.photoPath = const Value.absent(),
  }) : crimeId = Value(crimeId),
       name = Value(name);
  static Insertable<AccusedData> custom({
    Expression<int>? id,
    Expression<int>? crimeId,
    Expression<String>? name,
    Expression<String>? gender,
    Expression<int>? age,
    Expression<String>? address,
    Expression<String>? mobile,
    Expression<String>? email,
    Expression<String>? aadhaarEnc,
    Expression<String>? panEnc,
    Expression<String>? passport,
    Expression<String>? arrestStatus,
    Expression<DateTime>? arrestDate,
    Expression<String>? arrestTime,
    Expression<String>? photoPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crimeId != null) 'crime_id': crimeId,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (age != null) 'age': age,
      if (address != null) 'address': address,
      if (mobile != null) 'mobile': mobile,
      if (email != null) 'email': email,
      if (aadhaarEnc != null) 'aadhaar_enc': aadhaarEnc,
      if (panEnc != null) 'pan_enc': panEnc,
      if (passport != null) 'passport': passport,
      if (arrestStatus != null) 'arrest_status': arrestStatus,
      if (arrestDate != null) 'arrest_date': arrestDate,
      if (arrestTime != null) 'arrest_time': arrestTime,
      if (photoPath != null) 'photo_path': photoPath,
    });
  }

  AccusedCompanion copyWith({
    Value<int>? id,
    Value<int>? crimeId,
    Value<String>? name,
    Value<String?>? gender,
    Value<int?>? age,
    Value<String?>? address,
    Value<String?>? mobile,
    Value<String?>? email,
    Value<String?>? aadhaarEnc,
    Value<String?>? panEnc,
    Value<String?>? passport,
    Value<String?>? arrestStatus,
    Value<DateTime?>? arrestDate,
    Value<String?>? arrestTime,
    Value<String?>? photoPath,
  }) {
    return AccusedCompanion(
      id: id ?? this.id,
      crimeId: crimeId ?? this.crimeId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      address: address ?? this.address,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      aadhaarEnc: aadhaarEnc ?? this.aadhaarEnc,
      panEnc: panEnc ?? this.panEnc,
      passport: passport ?? this.passport,
      arrestStatus: arrestStatus ?? this.arrestStatus,
      arrestDate: arrestDate ?? this.arrestDate,
      arrestTime: arrestTime ?? this.arrestTime,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (crimeId.present) {
      map['crime_id'] = Variable<int>(crimeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (aadhaarEnc.present) {
      map['aadhaar_enc'] = Variable<String>(aadhaarEnc.value);
    }
    if (panEnc.present) {
      map['pan_enc'] = Variable<String>(panEnc.value);
    }
    if (passport.present) {
      map['passport'] = Variable<String>(passport.value);
    }
    if (arrestStatus.present) {
      map['arrest_status'] = Variable<String>(arrestStatus.value);
    }
    if (arrestDate.present) {
      map['arrest_date'] = Variable<DateTime>(arrestDate.value);
    }
    if (arrestTime.present) {
      map['arrest_time'] = Variable<String>(arrestTime.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccusedCompanion(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('age: $age, ')
          ..write('address: $address, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('aadhaarEnc: $aadhaarEnc, ')
          ..write('panEnc: $panEnc, ')
          ..write('passport: $passport, ')
          ..write('arrestStatus: $arrestStatus, ')
          ..write('arrestDate: $arrestDate, ')
          ..write('arrestTime: $arrestTime, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }
}

class $StolenPropertyTable extends StolenProperty
    with TableInfo<$StolenPropertyTable, StolenPropertyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StolenPropertyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _crimeIdMeta = const VerificationMeta(
    'crimeId',
  );
  @override
  late final GeneratedColumn<int> crimeId = GeneratedColumn<int>(
    'crime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crimes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, crimeId, type, description, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stolen_property';
  @override
  VerificationContext validateIntegrity(
    Insertable<StolenPropertyData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('crime_id')) {
      context.handle(
        _crimeIdMeta,
        crimeId.isAcceptableOrUnknown(data['crime_id']!, _crimeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_crimeIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StolenPropertyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StolenPropertyData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      crimeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}crime_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $StolenPropertyTable createAlias(String alias) {
    return $StolenPropertyTable(attachedDatabase, alias);
  }
}

class StolenPropertyData extends DataClass
    implements Insertable<StolenPropertyData> {
  final int id;
  final int crimeId;
  final String? type;
  final String? description;
  final double? value;
  const StolenPropertyData({
    required this.id,
    required this.crimeId,
    this.type,
    this.description,
    this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['crime_id'] = Variable<int>(crimeId);
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double>(value);
    }
    return map;
  }

  StolenPropertyCompanion toCompanion(bool nullToAbsent) {
    return StolenPropertyCompanion(
      id: Value(id),
      crimeId: Value(crimeId),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory StolenPropertyData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StolenPropertyData(
      id: serializer.fromJson<int>(json['id']),
      crimeId: serializer.fromJson<int>(json['crimeId']),
      type: serializer.fromJson<String?>(json['type']),
      description: serializer.fromJson<String?>(json['description']),
      value: serializer.fromJson<double?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'crimeId': serializer.toJson<int>(crimeId),
      'type': serializer.toJson<String?>(type),
      'description': serializer.toJson<String?>(description),
      'value': serializer.toJson<double?>(value),
    };
  }

  StolenPropertyData copyWith({
    int? id,
    int? crimeId,
    Value<String?> type = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<double?> value = const Value.absent(),
  }) => StolenPropertyData(
    id: id ?? this.id,
    crimeId: crimeId ?? this.crimeId,
    type: type.present ? type.value : this.type,
    description: description.present ? description.value : this.description,
    value: value.present ? value.value : this.value,
  );
  StolenPropertyData copyWithCompanion(StolenPropertyCompanion data) {
    return StolenPropertyData(
      id: data.id.present ? data.id.value : this.id,
      crimeId: data.crimeId.present ? data.crimeId.value : this.crimeId,
      type: data.type.present ? data.type.value : this.type,
      description: data.description.present
          ? data.description.value
          : this.description,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StolenPropertyData(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, crimeId, type, description, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StolenPropertyData &&
          other.id == this.id &&
          other.crimeId == this.crimeId &&
          other.type == this.type &&
          other.description == this.description &&
          other.value == this.value);
}

class StolenPropertyCompanion extends UpdateCompanion<StolenPropertyData> {
  final Value<int> id;
  final Value<int> crimeId;
  final Value<String?> type;
  final Value<String?> description;
  final Value<double?> value;
  const StolenPropertyCompanion({
    this.id = const Value.absent(),
    this.crimeId = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.value = const Value.absent(),
  });
  StolenPropertyCompanion.insert({
    this.id = const Value.absent(),
    required int crimeId,
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.value = const Value.absent(),
  }) : crimeId = Value(crimeId);
  static Insertable<StolenPropertyData> custom({
    Expression<int>? id,
    Expression<int>? crimeId,
    Expression<String>? type,
    Expression<String>? description,
    Expression<double>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crimeId != null) 'crime_id': crimeId,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (value != null) 'value': value,
    });
  }

  StolenPropertyCompanion copyWith({
    Value<int>? id,
    Value<int>? crimeId,
    Value<String?>? type,
    Value<String?>? description,
    Value<double?>? value,
  }) {
    return StolenPropertyCompanion(
      id: id ?? this.id,
      crimeId: crimeId ?? this.crimeId,
      type: type ?? this.type,
      description: description ?? this.description,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (crimeId.present) {
      map['crime_id'] = Variable<int>(crimeId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StolenPropertyCompanion(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $RecoveredPropertyTable extends RecoveredProperty
    with TableInfo<$RecoveredPropertyTable, RecoveredPropertyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecoveredPropertyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _crimeIdMeta = const VerificationMeta(
    'crimeId',
  );
  @override
  late final GeneratedColumn<int> crimeId = GeneratedColumn<int>(
    'crime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crimes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recoveryDateMeta = const VerificationMeta(
    'recoveryDate',
  );
  @override
  late final GeneratedColumn<DateTime> recoveryDate = GeneratedColumn<DateTime>(
    'recovery_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    crimeId,
    description,
    value,
    recoveryDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recovered_property';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecoveredPropertyData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('crime_id')) {
      context.handle(
        _crimeIdMeta,
        crimeId.isAcceptableOrUnknown(data['crime_id']!, _crimeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_crimeIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('recovery_date')) {
      context.handle(
        _recoveryDateMeta,
        recoveryDate.isAcceptableOrUnknown(
          data['recovery_date']!,
          _recoveryDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecoveredPropertyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecoveredPropertyData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      crimeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}crime_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      ),
      recoveryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recovery_date'],
      ),
    );
  }

  @override
  $RecoveredPropertyTable createAlias(String alias) {
    return $RecoveredPropertyTable(attachedDatabase, alias);
  }
}

class RecoveredPropertyData extends DataClass
    implements Insertable<RecoveredPropertyData> {
  final int id;
  final int crimeId;
  final String? description;
  final double? value;
  final DateTime? recoveryDate;
  const RecoveredPropertyData({
    required this.id,
    required this.crimeId,
    this.description,
    this.value,
    this.recoveryDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['crime_id'] = Variable<int>(crimeId);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double>(value);
    }
    if (!nullToAbsent || recoveryDate != null) {
      map['recovery_date'] = Variable<DateTime>(recoveryDate);
    }
    return map;
  }

  RecoveredPropertyCompanion toCompanion(bool nullToAbsent) {
    return RecoveredPropertyCompanion(
      id: Value(id),
      crimeId: Value(crimeId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      recoveryDate: recoveryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(recoveryDate),
    );
  }

  factory RecoveredPropertyData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecoveredPropertyData(
      id: serializer.fromJson<int>(json['id']),
      crimeId: serializer.fromJson<int>(json['crimeId']),
      description: serializer.fromJson<String?>(json['description']),
      value: serializer.fromJson<double?>(json['value']),
      recoveryDate: serializer.fromJson<DateTime?>(json['recoveryDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'crimeId': serializer.toJson<int>(crimeId),
      'description': serializer.toJson<String?>(description),
      'value': serializer.toJson<double?>(value),
      'recoveryDate': serializer.toJson<DateTime?>(recoveryDate),
    };
  }

  RecoveredPropertyData copyWith({
    int? id,
    int? crimeId,
    Value<String?> description = const Value.absent(),
    Value<double?> value = const Value.absent(),
    Value<DateTime?> recoveryDate = const Value.absent(),
  }) => RecoveredPropertyData(
    id: id ?? this.id,
    crimeId: crimeId ?? this.crimeId,
    description: description.present ? description.value : this.description,
    value: value.present ? value.value : this.value,
    recoveryDate: recoveryDate.present ? recoveryDate.value : this.recoveryDate,
  );
  RecoveredPropertyData copyWithCompanion(RecoveredPropertyCompanion data) {
    return RecoveredPropertyData(
      id: data.id.present ? data.id.value : this.id,
      crimeId: data.crimeId.present ? data.crimeId.value : this.crimeId,
      description: data.description.present
          ? data.description.value
          : this.description,
      value: data.value.present ? data.value.value : this.value,
      recoveryDate: data.recoveryDate.present
          ? data.recoveryDate.value
          : this.recoveryDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecoveredPropertyData(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('description: $description, ')
          ..write('value: $value, ')
          ..write('recoveryDate: $recoveryDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, crimeId, description, value, recoveryDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecoveredPropertyData &&
          other.id == this.id &&
          other.crimeId == this.crimeId &&
          other.description == this.description &&
          other.value == this.value &&
          other.recoveryDate == this.recoveryDate);
}

class RecoveredPropertyCompanion
    extends UpdateCompanion<RecoveredPropertyData> {
  final Value<int> id;
  final Value<int> crimeId;
  final Value<String?> description;
  final Value<double?> value;
  final Value<DateTime?> recoveryDate;
  const RecoveredPropertyCompanion({
    this.id = const Value.absent(),
    this.crimeId = const Value.absent(),
    this.description = const Value.absent(),
    this.value = const Value.absent(),
    this.recoveryDate = const Value.absent(),
  });
  RecoveredPropertyCompanion.insert({
    this.id = const Value.absent(),
    required int crimeId,
    this.description = const Value.absent(),
    this.value = const Value.absent(),
    this.recoveryDate = const Value.absent(),
  }) : crimeId = Value(crimeId);
  static Insertable<RecoveredPropertyData> custom({
    Expression<int>? id,
    Expression<int>? crimeId,
    Expression<String>? description,
    Expression<double>? value,
    Expression<DateTime>? recoveryDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crimeId != null) 'crime_id': crimeId,
      if (description != null) 'description': description,
      if (value != null) 'value': value,
      if (recoveryDate != null) 'recovery_date': recoveryDate,
    });
  }

  RecoveredPropertyCompanion copyWith({
    Value<int>? id,
    Value<int>? crimeId,
    Value<String?>? description,
    Value<double?>? value,
    Value<DateTime?>? recoveryDate,
  }) {
    return RecoveredPropertyCompanion(
      id: id ?? this.id,
      crimeId: crimeId ?? this.crimeId,
      description: description ?? this.description,
      value: value ?? this.value,
      recoveryDate: recoveryDate ?? this.recoveryDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (crimeId.present) {
      map['crime_id'] = Variable<int>(crimeId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (recoveryDate.present) {
      map['recovery_date'] = Variable<DateTime>(recoveryDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecoveredPropertyCompanion(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('description: $description, ')
          ..write('value: $value, ')
          ..write('recoveryDate: $recoveryDate')
          ..write(')'))
        .toString();
  }
}

class $InvestigationTable extends Investigation
    with TableInfo<$InvestigationTable, InvestigationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestigationTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _crimeIdMeta = const VerificationMeta(
    'crimeId',
  );
  @override
  late final GeneratedColumn<int> crimeId = GeneratedColumn<int>(
    'crime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crimes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _officerNameMeta = const VerificationMeta(
    'officerName',
  );
  @override
  late final GeneratedColumn<String> officerName = GeneratedColumn<String>(
    'officer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _officerIdMeta = const VerificationMeta(
    'officerId',
  );
  @override
  late final GeneratedColumn<String> officerId = GeneratedColumn<String>(
    'officer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _officerMobileMeta = const VerificationMeta(
    'officerMobile',
  );
  @override
  late final GeneratedColumn<String> officerMobile = GeneratedColumn<String>(
    'officer_mobile',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filedByMeta = const VerificationMeta(
    'filedBy',
  );
  @override
  late final GeneratedColumn<String> filedBy = GeneratedColumn<String>(
    'filed_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preventiveActionMeta = const VerificationMeta(
    'preventiveAction',
  );
  @override
  late final GeneratedColumn<String> preventiveAction = GeneratedColumn<String>(
    'preventive_action',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preventiveNoMeta = const VerificationMeta(
    'preventiveNo',
  );
  @override
  late final GeneratedColumn<String> preventiveNo = GeneratedColumn<String>(
    'preventive_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preventiveDateMeta = const VerificationMeta(
    'preventiveDate',
  );
  @override
  late final GeneratedColumn<DateTime> preventiveDate =
      GeneratedColumn<DateTime>(
        'preventive_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _wantedAccusedMeta = const VerificationMeta(
    'wantedAccused',
  );
  @override
  late final GeneratedColumn<String> wantedAccused = GeneratedColumn<String>(
    'wanted_accused',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    crimeId,
    officerName,
    officerId,
    officerMobile,
    filedBy,
    preventiveAction,
    preventiveNo,
    preventiveDate,
    wantedAccused,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'investigation';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvestigationData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('crime_id')) {
      context.handle(
        _crimeIdMeta,
        crimeId.isAcceptableOrUnknown(data['crime_id']!, _crimeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_crimeIdMeta);
    }
    if (data.containsKey('officer_name')) {
      context.handle(
        _officerNameMeta,
        officerName.isAcceptableOrUnknown(
          data['officer_name']!,
          _officerNameMeta,
        ),
      );
    }
    if (data.containsKey('officer_id')) {
      context.handle(
        _officerIdMeta,
        officerId.isAcceptableOrUnknown(data['officer_id']!, _officerIdMeta),
      );
    }
    if (data.containsKey('officer_mobile')) {
      context.handle(
        _officerMobileMeta,
        officerMobile.isAcceptableOrUnknown(
          data['officer_mobile']!,
          _officerMobileMeta,
        ),
      );
    }
    if (data.containsKey('filed_by')) {
      context.handle(
        _filedByMeta,
        filedBy.isAcceptableOrUnknown(data['filed_by']!, _filedByMeta),
      );
    }
    if (data.containsKey('preventive_action')) {
      context.handle(
        _preventiveActionMeta,
        preventiveAction.isAcceptableOrUnknown(
          data['preventive_action']!,
          _preventiveActionMeta,
        ),
      );
    }
    if (data.containsKey('preventive_no')) {
      context.handle(
        _preventiveNoMeta,
        preventiveNo.isAcceptableOrUnknown(
          data['preventive_no']!,
          _preventiveNoMeta,
        ),
      );
    }
    if (data.containsKey('preventive_date')) {
      context.handle(
        _preventiveDateMeta,
        preventiveDate.isAcceptableOrUnknown(
          data['preventive_date']!,
          _preventiveDateMeta,
        ),
      );
    }
    if (data.containsKey('wanted_accused')) {
      context.handle(
        _wantedAccusedMeta,
        wantedAccused.isAcceptableOrUnknown(
          data['wanted_accused']!,
          _wantedAccusedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvestigationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvestigationData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      crimeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}crime_id'],
      )!,
      officerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}officer_name'],
      ),
      officerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}officer_id'],
      ),
      officerMobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}officer_mobile'],
      ),
      filedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filed_by'],
      ),
      preventiveAction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preventive_action'],
      ),
      preventiveNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preventive_no'],
      ),
      preventiveDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}preventive_date'],
      ),
      wantedAccused: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wanted_accused'],
      ),
    );
  }

  @override
  $InvestigationTable createAlias(String alias) {
    return $InvestigationTable(attachedDatabase, alias);
  }
}

class InvestigationData extends DataClass
    implements Insertable<InvestigationData> {
  final int id;
  final int crimeId;
  final String? officerName;
  final String? officerId;
  final String? officerMobile;
  final String? filedBy;
  final String? preventiveAction;
  final String? preventiveNo;
  final DateTime? preventiveDate;
  final String? wantedAccused;
  const InvestigationData({
    required this.id,
    required this.crimeId,
    this.officerName,
    this.officerId,
    this.officerMobile,
    this.filedBy,
    this.preventiveAction,
    this.preventiveNo,
    this.preventiveDate,
    this.wantedAccused,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['crime_id'] = Variable<int>(crimeId);
    if (!nullToAbsent || officerName != null) {
      map['officer_name'] = Variable<String>(officerName);
    }
    if (!nullToAbsent || officerId != null) {
      map['officer_id'] = Variable<String>(officerId);
    }
    if (!nullToAbsent || officerMobile != null) {
      map['officer_mobile'] = Variable<String>(officerMobile);
    }
    if (!nullToAbsent || filedBy != null) {
      map['filed_by'] = Variable<String>(filedBy);
    }
    if (!nullToAbsent || preventiveAction != null) {
      map['preventive_action'] = Variable<String>(preventiveAction);
    }
    if (!nullToAbsent || preventiveNo != null) {
      map['preventive_no'] = Variable<String>(preventiveNo);
    }
    if (!nullToAbsent || preventiveDate != null) {
      map['preventive_date'] = Variable<DateTime>(preventiveDate);
    }
    if (!nullToAbsent || wantedAccused != null) {
      map['wanted_accused'] = Variable<String>(wantedAccused);
    }
    return map;
  }

  InvestigationCompanion toCompanion(bool nullToAbsent) {
    return InvestigationCompanion(
      id: Value(id),
      crimeId: Value(crimeId),
      officerName: officerName == null && nullToAbsent
          ? const Value.absent()
          : Value(officerName),
      officerId: officerId == null && nullToAbsent
          ? const Value.absent()
          : Value(officerId),
      officerMobile: officerMobile == null && nullToAbsent
          ? const Value.absent()
          : Value(officerMobile),
      filedBy: filedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(filedBy),
      preventiveAction: preventiveAction == null && nullToAbsent
          ? const Value.absent()
          : Value(preventiveAction),
      preventiveNo: preventiveNo == null && nullToAbsent
          ? const Value.absent()
          : Value(preventiveNo),
      preventiveDate: preventiveDate == null && nullToAbsent
          ? const Value.absent()
          : Value(preventiveDate),
      wantedAccused: wantedAccused == null && nullToAbsent
          ? const Value.absent()
          : Value(wantedAccused),
    );
  }

  factory InvestigationData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvestigationData(
      id: serializer.fromJson<int>(json['id']),
      crimeId: serializer.fromJson<int>(json['crimeId']),
      officerName: serializer.fromJson<String?>(json['officerName']),
      officerId: serializer.fromJson<String?>(json['officerId']),
      officerMobile: serializer.fromJson<String?>(json['officerMobile']),
      filedBy: serializer.fromJson<String?>(json['filedBy']),
      preventiveAction: serializer.fromJson<String?>(json['preventiveAction']),
      preventiveNo: serializer.fromJson<String?>(json['preventiveNo']),
      preventiveDate: serializer.fromJson<DateTime?>(json['preventiveDate']),
      wantedAccused: serializer.fromJson<String?>(json['wantedAccused']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'crimeId': serializer.toJson<int>(crimeId),
      'officerName': serializer.toJson<String?>(officerName),
      'officerId': serializer.toJson<String?>(officerId),
      'officerMobile': serializer.toJson<String?>(officerMobile),
      'filedBy': serializer.toJson<String?>(filedBy),
      'preventiveAction': serializer.toJson<String?>(preventiveAction),
      'preventiveNo': serializer.toJson<String?>(preventiveNo),
      'preventiveDate': serializer.toJson<DateTime?>(preventiveDate),
      'wantedAccused': serializer.toJson<String?>(wantedAccused),
    };
  }

  InvestigationData copyWith({
    int? id,
    int? crimeId,
    Value<String?> officerName = const Value.absent(),
    Value<String?> officerId = const Value.absent(),
    Value<String?> officerMobile = const Value.absent(),
    Value<String?> filedBy = const Value.absent(),
    Value<String?> preventiveAction = const Value.absent(),
    Value<String?> preventiveNo = const Value.absent(),
    Value<DateTime?> preventiveDate = const Value.absent(),
    Value<String?> wantedAccused = const Value.absent(),
  }) => InvestigationData(
    id: id ?? this.id,
    crimeId: crimeId ?? this.crimeId,
    officerName: officerName.present ? officerName.value : this.officerName,
    officerId: officerId.present ? officerId.value : this.officerId,
    officerMobile: officerMobile.present
        ? officerMobile.value
        : this.officerMobile,
    filedBy: filedBy.present ? filedBy.value : this.filedBy,
    preventiveAction: preventiveAction.present
        ? preventiveAction.value
        : this.preventiveAction,
    preventiveNo: preventiveNo.present ? preventiveNo.value : this.preventiveNo,
    preventiveDate: preventiveDate.present
        ? preventiveDate.value
        : this.preventiveDate,
    wantedAccused: wantedAccused.present
        ? wantedAccused.value
        : this.wantedAccused,
  );
  InvestigationData copyWithCompanion(InvestigationCompanion data) {
    return InvestigationData(
      id: data.id.present ? data.id.value : this.id,
      crimeId: data.crimeId.present ? data.crimeId.value : this.crimeId,
      officerName: data.officerName.present
          ? data.officerName.value
          : this.officerName,
      officerId: data.officerId.present ? data.officerId.value : this.officerId,
      officerMobile: data.officerMobile.present
          ? data.officerMobile.value
          : this.officerMobile,
      filedBy: data.filedBy.present ? data.filedBy.value : this.filedBy,
      preventiveAction: data.preventiveAction.present
          ? data.preventiveAction.value
          : this.preventiveAction,
      preventiveNo: data.preventiveNo.present
          ? data.preventiveNo.value
          : this.preventiveNo,
      preventiveDate: data.preventiveDate.present
          ? data.preventiveDate.value
          : this.preventiveDate,
      wantedAccused: data.wantedAccused.present
          ? data.wantedAccused.value
          : this.wantedAccused,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvestigationData(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('officerName: $officerName, ')
          ..write('officerId: $officerId, ')
          ..write('officerMobile: $officerMobile, ')
          ..write('filedBy: $filedBy, ')
          ..write('preventiveAction: $preventiveAction, ')
          ..write('preventiveNo: $preventiveNo, ')
          ..write('preventiveDate: $preventiveDate, ')
          ..write('wantedAccused: $wantedAccused')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    crimeId,
    officerName,
    officerId,
    officerMobile,
    filedBy,
    preventiveAction,
    preventiveNo,
    preventiveDate,
    wantedAccused,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvestigationData &&
          other.id == this.id &&
          other.crimeId == this.crimeId &&
          other.officerName == this.officerName &&
          other.officerId == this.officerId &&
          other.officerMobile == this.officerMobile &&
          other.filedBy == this.filedBy &&
          other.preventiveAction == this.preventiveAction &&
          other.preventiveNo == this.preventiveNo &&
          other.preventiveDate == this.preventiveDate &&
          other.wantedAccused == this.wantedAccused);
}

class InvestigationCompanion extends UpdateCompanion<InvestigationData> {
  final Value<int> id;
  final Value<int> crimeId;
  final Value<String?> officerName;
  final Value<String?> officerId;
  final Value<String?> officerMobile;
  final Value<String?> filedBy;
  final Value<String?> preventiveAction;
  final Value<String?> preventiveNo;
  final Value<DateTime?> preventiveDate;
  final Value<String?> wantedAccused;
  const InvestigationCompanion({
    this.id = const Value.absent(),
    this.crimeId = const Value.absent(),
    this.officerName = const Value.absent(),
    this.officerId = const Value.absent(),
    this.officerMobile = const Value.absent(),
    this.filedBy = const Value.absent(),
    this.preventiveAction = const Value.absent(),
    this.preventiveNo = const Value.absent(),
    this.preventiveDate = const Value.absent(),
    this.wantedAccused = const Value.absent(),
  });
  InvestigationCompanion.insert({
    this.id = const Value.absent(),
    required int crimeId,
    this.officerName = const Value.absent(),
    this.officerId = const Value.absent(),
    this.officerMobile = const Value.absent(),
    this.filedBy = const Value.absent(),
    this.preventiveAction = const Value.absent(),
    this.preventiveNo = const Value.absent(),
    this.preventiveDate = const Value.absent(),
    this.wantedAccused = const Value.absent(),
  }) : crimeId = Value(crimeId);
  static Insertable<InvestigationData> custom({
    Expression<int>? id,
    Expression<int>? crimeId,
    Expression<String>? officerName,
    Expression<String>? officerId,
    Expression<String>? officerMobile,
    Expression<String>? filedBy,
    Expression<String>? preventiveAction,
    Expression<String>? preventiveNo,
    Expression<DateTime>? preventiveDate,
    Expression<String>? wantedAccused,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crimeId != null) 'crime_id': crimeId,
      if (officerName != null) 'officer_name': officerName,
      if (officerId != null) 'officer_id': officerId,
      if (officerMobile != null) 'officer_mobile': officerMobile,
      if (filedBy != null) 'filed_by': filedBy,
      if (preventiveAction != null) 'preventive_action': preventiveAction,
      if (preventiveNo != null) 'preventive_no': preventiveNo,
      if (preventiveDate != null) 'preventive_date': preventiveDate,
      if (wantedAccused != null) 'wanted_accused': wantedAccused,
    });
  }

  InvestigationCompanion copyWith({
    Value<int>? id,
    Value<int>? crimeId,
    Value<String?>? officerName,
    Value<String?>? officerId,
    Value<String?>? officerMobile,
    Value<String?>? filedBy,
    Value<String?>? preventiveAction,
    Value<String?>? preventiveNo,
    Value<DateTime?>? preventiveDate,
    Value<String?>? wantedAccused,
  }) {
    return InvestigationCompanion(
      id: id ?? this.id,
      crimeId: crimeId ?? this.crimeId,
      officerName: officerName ?? this.officerName,
      officerId: officerId ?? this.officerId,
      officerMobile: officerMobile ?? this.officerMobile,
      filedBy: filedBy ?? this.filedBy,
      preventiveAction: preventiveAction ?? this.preventiveAction,
      preventiveNo: preventiveNo ?? this.preventiveNo,
      preventiveDate: preventiveDate ?? this.preventiveDate,
      wantedAccused: wantedAccused ?? this.wantedAccused,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (crimeId.present) {
      map['crime_id'] = Variable<int>(crimeId.value);
    }
    if (officerName.present) {
      map['officer_name'] = Variable<String>(officerName.value);
    }
    if (officerId.present) {
      map['officer_id'] = Variable<String>(officerId.value);
    }
    if (officerMobile.present) {
      map['officer_mobile'] = Variable<String>(officerMobile.value);
    }
    if (filedBy.present) {
      map['filed_by'] = Variable<String>(filedBy.value);
    }
    if (preventiveAction.present) {
      map['preventive_action'] = Variable<String>(preventiveAction.value);
    }
    if (preventiveNo.present) {
      map['preventive_no'] = Variable<String>(preventiveNo.value);
    }
    if (preventiveDate.present) {
      map['preventive_date'] = Variable<DateTime>(preventiveDate.value);
    }
    if (wantedAccused.present) {
      map['wanted_accused'] = Variable<String>(wantedAccused.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvestigationCompanion(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('officerName: $officerName, ')
          ..write('officerId: $officerId, ')
          ..write('officerMobile: $officerMobile, ')
          ..write('filedBy: $filedBy, ')
          ..write('preventiveAction: $preventiveAction, ')
          ..write('preventiveNo: $preventiveNo, ')
          ..write('preventiveDate: $preventiveDate, ')
          ..write('wantedAccused: $wantedAccused')
          ..write(')'))
        .toString();
  }
}

class $VerdictTable extends Verdict with TableInfo<$VerdictTable, VerdictData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VerdictTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _crimeIdMeta = const VerificationMeta(
    'crimeId',
  );
  @override
  late final GeneratedColumn<int> crimeId = GeneratedColumn<int>(
    'crime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crimes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _chargesheetNoMeta = const VerificationMeta(
    'chargesheetNo',
  );
  @override
  late final GeneratedColumn<String> chargesheetNo = GeneratedColumn<String>(
    'chargesheet_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chargesheetDateMeta = const VerificationMeta(
    'chargesheetDate',
  );
  @override
  late final GeneratedColumn<DateTime> chargesheetDate =
      GeneratedColumn<DateTime>(
        'chargesheet_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _rccNoMeta = const VerificationMeta('rccNo');
  @override
  late final GeneratedColumn<String> rccNo = GeneratedColumn<String>(
    'rcc_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finalOrderMeta = const VerificationMeta(
    'finalOrder',
  );
  @override
  late final GeneratedColumn<String> finalOrder = GeneratedColumn<String>(
    'final_order',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _foundGuiltyMeta = const VerificationMeta(
    'foundGuilty',
  );
  @override
  late final GeneratedColumn<bool> foundGuilty = GeneratedColumn<bool>(
    'found_guilty',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("found_guilty" IN (0, 1))',
    ),
  );
  static const VerificationMeta _punishmentMeta = const VerificationMeta(
    'punishment',
  );
  @override
  late final GeneratedColumn<String> punishment = GeneratedColumn<String>(
    'punishment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    crimeId,
    chargesheetNo,
    chargesheetDate,
    rccNo,
    finalOrder,
    foundGuilty,
    punishment,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verdict';
  @override
  VerificationContext validateIntegrity(
    Insertable<VerdictData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('crime_id')) {
      context.handle(
        _crimeIdMeta,
        crimeId.isAcceptableOrUnknown(data['crime_id']!, _crimeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_crimeIdMeta);
    }
    if (data.containsKey('chargesheet_no')) {
      context.handle(
        _chargesheetNoMeta,
        chargesheetNo.isAcceptableOrUnknown(
          data['chargesheet_no']!,
          _chargesheetNoMeta,
        ),
      );
    }
    if (data.containsKey('chargesheet_date')) {
      context.handle(
        _chargesheetDateMeta,
        chargesheetDate.isAcceptableOrUnknown(
          data['chargesheet_date']!,
          _chargesheetDateMeta,
        ),
      );
    }
    if (data.containsKey('rcc_no')) {
      context.handle(
        _rccNoMeta,
        rccNo.isAcceptableOrUnknown(data['rcc_no']!, _rccNoMeta),
      );
    }
    if (data.containsKey('final_order')) {
      context.handle(
        _finalOrderMeta,
        finalOrder.isAcceptableOrUnknown(data['final_order']!, _finalOrderMeta),
      );
    }
    if (data.containsKey('found_guilty')) {
      context.handle(
        _foundGuiltyMeta,
        foundGuilty.isAcceptableOrUnknown(
          data['found_guilty']!,
          _foundGuiltyMeta,
        ),
      );
    }
    if (data.containsKey('punishment')) {
      context.handle(
        _punishmentMeta,
        punishment.isAcceptableOrUnknown(data['punishment']!, _punishmentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VerdictData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerdictData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      crimeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}crime_id'],
      )!,
      chargesheetNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chargesheet_no'],
      ),
      chargesheetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}chargesheet_date'],
      ),
      rccNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rcc_no'],
      ),
      finalOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}final_order'],
      ),
      foundGuilty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}found_guilty'],
      ),
      punishment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}punishment'],
      ),
    );
  }

  @override
  $VerdictTable createAlias(String alias) {
    return $VerdictTable(attachedDatabase, alias);
  }
}

class VerdictData extends DataClass implements Insertable<VerdictData> {
  final int id;
  final int crimeId;
  final String? chargesheetNo;
  final DateTime? chargesheetDate;
  final String? rccNo;
  final String? finalOrder;
  final bool? foundGuilty;
  final String? punishment;
  const VerdictData({
    required this.id,
    required this.crimeId,
    this.chargesheetNo,
    this.chargesheetDate,
    this.rccNo,
    this.finalOrder,
    this.foundGuilty,
    this.punishment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['crime_id'] = Variable<int>(crimeId);
    if (!nullToAbsent || chargesheetNo != null) {
      map['chargesheet_no'] = Variable<String>(chargesheetNo);
    }
    if (!nullToAbsent || chargesheetDate != null) {
      map['chargesheet_date'] = Variable<DateTime>(chargesheetDate);
    }
    if (!nullToAbsent || rccNo != null) {
      map['rcc_no'] = Variable<String>(rccNo);
    }
    if (!nullToAbsent || finalOrder != null) {
      map['final_order'] = Variable<String>(finalOrder);
    }
    if (!nullToAbsent || foundGuilty != null) {
      map['found_guilty'] = Variable<bool>(foundGuilty);
    }
    if (!nullToAbsent || punishment != null) {
      map['punishment'] = Variable<String>(punishment);
    }
    return map;
  }

  VerdictCompanion toCompanion(bool nullToAbsent) {
    return VerdictCompanion(
      id: Value(id),
      crimeId: Value(crimeId),
      chargesheetNo: chargesheetNo == null && nullToAbsent
          ? const Value.absent()
          : Value(chargesheetNo),
      chargesheetDate: chargesheetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(chargesheetDate),
      rccNo: rccNo == null && nullToAbsent
          ? const Value.absent()
          : Value(rccNo),
      finalOrder: finalOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(finalOrder),
      foundGuilty: foundGuilty == null && nullToAbsent
          ? const Value.absent()
          : Value(foundGuilty),
      punishment: punishment == null && nullToAbsent
          ? const Value.absent()
          : Value(punishment),
    );
  }

  factory VerdictData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerdictData(
      id: serializer.fromJson<int>(json['id']),
      crimeId: serializer.fromJson<int>(json['crimeId']),
      chargesheetNo: serializer.fromJson<String?>(json['chargesheetNo']),
      chargesheetDate: serializer.fromJson<DateTime?>(json['chargesheetDate']),
      rccNo: serializer.fromJson<String?>(json['rccNo']),
      finalOrder: serializer.fromJson<String?>(json['finalOrder']),
      foundGuilty: serializer.fromJson<bool?>(json['foundGuilty']),
      punishment: serializer.fromJson<String?>(json['punishment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'crimeId': serializer.toJson<int>(crimeId),
      'chargesheetNo': serializer.toJson<String?>(chargesheetNo),
      'chargesheetDate': serializer.toJson<DateTime?>(chargesheetDate),
      'rccNo': serializer.toJson<String?>(rccNo),
      'finalOrder': serializer.toJson<String?>(finalOrder),
      'foundGuilty': serializer.toJson<bool?>(foundGuilty),
      'punishment': serializer.toJson<String?>(punishment),
    };
  }

  VerdictData copyWith({
    int? id,
    int? crimeId,
    Value<String?> chargesheetNo = const Value.absent(),
    Value<DateTime?> chargesheetDate = const Value.absent(),
    Value<String?> rccNo = const Value.absent(),
    Value<String?> finalOrder = const Value.absent(),
    Value<bool?> foundGuilty = const Value.absent(),
    Value<String?> punishment = const Value.absent(),
  }) => VerdictData(
    id: id ?? this.id,
    crimeId: crimeId ?? this.crimeId,
    chargesheetNo: chargesheetNo.present
        ? chargesheetNo.value
        : this.chargesheetNo,
    chargesheetDate: chargesheetDate.present
        ? chargesheetDate.value
        : this.chargesheetDate,
    rccNo: rccNo.present ? rccNo.value : this.rccNo,
    finalOrder: finalOrder.present ? finalOrder.value : this.finalOrder,
    foundGuilty: foundGuilty.present ? foundGuilty.value : this.foundGuilty,
    punishment: punishment.present ? punishment.value : this.punishment,
  );
  VerdictData copyWithCompanion(VerdictCompanion data) {
    return VerdictData(
      id: data.id.present ? data.id.value : this.id,
      crimeId: data.crimeId.present ? data.crimeId.value : this.crimeId,
      chargesheetNo: data.chargesheetNo.present
          ? data.chargesheetNo.value
          : this.chargesheetNo,
      chargesheetDate: data.chargesheetDate.present
          ? data.chargesheetDate.value
          : this.chargesheetDate,
      rccNo: data.rccNo.present ? data.rccNo.value : this.rccNo,
      finalOrder: data.finalOrder.present
          ? data.finalOrder.value
          : this.finalOrder,
      foundGuilty: data.foundGuilty.present
          ? data.foundGuilty.value
          : this.foundGuilty,
      punishment: data.punishment.present
          ? data.punishment.value
          : this.punishment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerdictData(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('chargesheetNo: $chargesheetNo, ')
          ..write('chargesheetDate: $chargesheetDate, ')
          ..write('rccNo: $rccNo, ')
          ..write('finalOrder: $finalOrder, ')
          ..write('foundGuilty: $foundGuilty, ')
          ..write('punishment: $punishment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    crimeId,
    chargesheetNo,
    chargesheetDate,
    rccNo,
    finalOrder,
    foundGuilty,
    punishment,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerdictData &&
          other.id == this.id &&
          other.crimeId == this.crimeId &&
          other.chargesheetNo == this.chargesheetNo &&
          other.chargesheetDate == this.chargesheetDate &&
          other.rccNo == this.rccNo &&
          other.finalOrder == this.finalOrder &&
          other.foundGuilty == this.foundGuilty &&
          other.punishment == this.punishment);
}

class VerdictCompanion extends UpdateCompanion<VerdictData> {
  final Value<int> id;
  final Value<int> crimeId;
  final Value<String?> chargesheetNo;
  final Value<DateTime?> chargesheetDate;
  final Value<String?> rccNo;
  final Value<String?> finalOrder;
  final Value<bool?> foundGuilty;
  final Value<String?> punishment;
  const VerdictCompanion({
    this.id = const Value.absent(),
    this.crimeId = const Value.absent(),
    this.chargesheetNo = const Value.absent(),
    this.chargesheetDate = const Value.absent(),
    this.rccNo = const Value.absent(),
    this.finalOrder = const Value.absent(),
    this.foundGuilty = const Value.absent(),
    this.punishment = const Value.absent(),
  });
  VerdictCompanion.insert({
    this.id = const Value.absent(),
    required int crimeId,
    this.chargesheetNo = const Value.absent(),
    this.chargesheetDate = const Value.absent(),
    this.rccNo = const Value.absent(),
    this.finalOrder = const Value.absent(),
    this.foundGuilty = const Value.absent(),
    this.punishment = const Value.absent(),
  }) : crimeId = Value(crimeId);
  static Insertable<VerdictData> custom({
    Expression<int>? id,
    Expression<int>? crimeId,
    Expression<String>? chargesheetNo,
    Expression<DateTime>? chargesheetDate,
    Expression<String>? rccNo,
    Expression<String>? finalOrder,
    Expression<bool>? foundGuilty,
    Expression<String>? punishment,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crimeId != null) 'crime_id': crimeId,
      if (chargesheetNo != null) 'chargesheet_no': chargesheetNo,
      if (chargesheetDate != null) 'chargesheet_date': chargesheetDate,
      if (rccNo != null) 'rcc_no': rccNo,
      if (finalOrder != null) 'final_order': finalOrder,
      if (foundGuilty != null) 'found_guilty': foundGuilty,
      if (punishment != null) 'punishment': punishment,
    });
  }

  VerdictCompanion copyWith({
    Value<int>? id,
    Value<int>? crimeId,
    Value<String?>? chargesheetNo,
    Value<DateTime?>? chargesheetDate,
    Value<String?>? rccNo,
    Value<String?>? finalOrder,
    Value<bool?>? foundGuilty,
    Value<String?>? punishment,
  }) {
    return VerdictCompanion(
      id: id ?? this.id,
      crimeId: crimeId ?? this.crimeId,
      chargesheetNo: chargesheetNo ?? this.chargesheetNo,
      chargesheetDate: chargesheetDate ?? this.chargesheetDate,
      rccNo: rccNo ?? this.rccNo,
      finalOrder: finalOrder ?? this.finalOrder,
      foundGuilty: foundGuilty ?? this.foundGuilty,
      punishment: punishment ?? this.punishment,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (crimeId.present) {
      map['crime_id'] = Variable<int>(crimeId.value);
    }
    if (chargesheetNo.present) {
      map['chargesheet_no'] = Variable<String>(chargesheetNo.value);
    }
    if (chargesheetDate.present) {
      map['chargesheet_date'] = Variable<DateTime>(chargesheetDate.value);
    }
    if (rccNo.present) {
      map['rcc_no'] = Variable<String>(rccNo.value);
    }
    if (finalOrder.present) {
      map['final_order'] = Variable<String>(finalOrder.value);
    }
    if (foundGuilty.present) {
      map['found_guilty'] = Variable<bool>(foundGuilty.value);
    }
    if (punishment.present) {
      map['punishment'] = Variable<String>(punishment.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerdictCompanion(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('chargesheetNo: $chargesheetNo, ')
          ..write('chargesheetDate: $chargesheetDate, ')
          ..write('rccNo: $rccNo, ')
          ..write('finalOrder: $finalOrder, ')
          ..write('foundGuilty: $foundGuilty, ')
          ..write('punishment: $punishment')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, Attachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _crimeIdMeta = const VerificationMeta(
    'crimeId',
  );
  @override
  late final GeneratedColumn<int> crimeId = GeneratedColumn<int>(
    'crime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crimes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileTypeMeta = const VerificationMeta(
    'fileType',
  );
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
    'file_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<DateTime> uploadedAt = GeneratedColumn<DateTime>(
    'uploaded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    crimeId,
    filePath,
    fileType,
    description,
    uploadedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('crime_id')) {
      context.handle(
        _crimeIdMeta,
        crimeId.isAcceptableOrUnknown(data['crime_id']!, _crimeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_crimeIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(
        _fileTypeMeta,
        fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      crimeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}crime_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      fileType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_type'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}uploaded_at'],
      )!,
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }
}

class Attachment extends DataClass implements Insertable<Attachment> {
  final int id;
  final int crimeId;
  final String filePath;
  final String? fileType;
  final String? description;
  final DateTime uploadedAt;
  const Attachment({
    required this.id,
    required this.crimeId,
    required this.filePath,
    this.fileType,
    this.description,
    required this.uploadedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['crime_id'] = Variable<int>(crimeId);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || fileType != null) {
      map['file_type'] = Variable<String>(fileType);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['uploaded_at'] = Variable<DateTime>(uploadedAt);
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: Value(id),
      crimeId: Value(crimeId),
      filePath: Value(filePath),
      fileType: fileType == null && nullToAbsent
          ? const Value.absent()
          : Value(fileType),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      uploadedAt: Value(uploadedAt),
    );
  }

  factory Attachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attachment(
      id: serializer.fromJson<int>(json['id']),
      crimeId: serializer.fromJson<int>(json['crimeId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileType: serializer.fromJson<String?>(json['fileType']),
      description: serializer.fromJson<String?>(json['description']),
      uploadedAt: serializer.fromJson<DateTime>(json['uploadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'crimeId': serializer.toJson<int>(crimeId),
      'filePath': serializer.toJson<String>(filePath),
      'fileType': serializer.toJson<String?>(fileType),
      'description': serializer.toJson<String?>(description),
      'uploadedAt': serializer.toJson<DateTime>(uploadedAt),
    };
  }

  Attachment copyWith({
    int? id,
    int? crimeId,
    String? filePath,
    Value<String?> fileType = const Value.absent(),
    Value<String?> description = const Value.absent(),
    DateTime? uploadedAt,
  }) => Attachment(
    id: id ?? this.id,
    crimeId: crimeId ?? this.crimeId,
    filePath: filePath ?? this.filePath,
    fileType: fileType.present ? fileType.value : this.fileType,
    description: description.present ? description.value : this.description,
    uploadedAt: uploadedAt ?? this.uploadedAt,
  );
  Attachment copyWithCompanion(AttachmentsCompanion data) {
    return Attachment(
      id: data.id.present ? data.id.value : this.id,
      crimeId: data.crimeId.present ? data.crimeId.value : this.crimeId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      description: data.description.present
          ? data.description.value
          : this.description,
      uploadedAt: data.uploadedAt.present
          ? data.uploadedAt.value
          : this.uploadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attachment(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('filePath: $filePath, ')
          ..write('fileType: $fileType, ')
          ..write('description: $description, ')
          ..write('uploadedAt: $uploadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, crimeId, filePath, fileType, description, uploadedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attachment &&
          other.id == this.id &&
          other.crimeId == this.crimeId &&
          other.filePath == this.filePath &&
          other.fileType == this.fileType &&
          other.description == this.description &&
          other.uploadedAt == this.uploadedAt);
}

class AttachmentsCompanion extends UpdateCompanion<Attachment> {
  final Value<int> id;
  final Value<int> crimeId;
  final Value<String> filePath;
  final Value<String?> fileType;
  final Value<String?> description;
  final Value<DateTime> uploadedAt;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.crimeId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileType = const Value.absent(),
    this.description = const Value.absent(),
    this.uploadedAt = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required int crimeId,
    required String filePath,
    this.fileType = const Value.absent(),
    this.description = const Value.absent(),
    this.uploadedAt = const Value.absent(),
  }) : crimeId = Value(crimeId),
       filePath = Value(filePath);
  static Insertable<Attachment> custom({
    Expression<int>? id,
    Expression<int>? crimeId,
    Expression<String>? filePath,
    Expression<String>? fileType,
    Expression<String>? description,
    Expression<DateTime>? uploadedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crimeId != null) 'crime_id': crimeId,
      if (filePath != null) 'file_path': filePath,
      if (fileType != null) 'file_type': fileType,
      if (description != null) 'description': description,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
    });
  }

  AttachmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? crimeId,
    Value<String>? filePath,
    Value<String?>? fileType,
    Value<String?>? description,
    Value<DateTime>? uploadedAt,
  }) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      crimeId: crimeId ?? this.crimeId,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      description: description ?? this.description,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (crimeId.present) {
      map['crime_id'] = Variable<int>(crimeId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<DateTime>(uploadedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('filePath: $filePath, ')
          ..write('fileType: $fileType, ')
          ..write('description: $description, ')
          ..write('uploadedAt: $uploadedAt')
          ..write(')'))
        .toString();
  }
}

class $CustomFieldsTable extends CustomFields
    with TableInfo<$CustomFieldsTable, CustomField> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomFieldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fieldNameMarathiMeta = const VerificationMeta(
    'fieldNameMarathi',
  );
  @override
  late final GeneratedColumn<String> fieldNameMarathi = GeneratedColumn<String>(
    'field_name_marathi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldNameEnglishMeta = const VerificationMeta(
    'fieldNameEnglish',
  );
  @override
  late final GeneratedColumn<String> fieldNameEnglish = GeneratedColumn<String>(
    'field_name_english',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldTypeMeta = const VerificationMeta(
    'fieldType',
  );
  @override
  late final GeneratedColumn<String> fieldType = GeneratedColumn<String>(
    'field_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionMeta = const VerificationMeta(
    'section',
  );
  @override
  late final GeneratedColumn<String> section = GeneratedColumn<String>(
    'section',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isRequiredMeta = const VerificationMeta(
    'isRequired',
  );
  @override
  late final GeneratedColumn<bool> isRequired = GeneratedColumn<bool>(
    'is_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_required" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dropdownOptionsJsonMeta =
      const VerificationMeta('dropdownOptionsJson');
  @override
  late final GeneratedColumn<String> dropdownOptionsJson =
      GeneratedColumn<String>(
        'dropdown_options_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fieldNameMarathi,
    fieldNameEnglish,
    fieldType,
    section,
    isRequired,
    dropdownOptionsJson,
    displayOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_fields';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomField> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('field_name_marathi')) {
      context.handle(
        _fieldNameMarathiMeta,
        fieldNameMarathi.isAcceptableOrUnknown(
          data['field_name_marathi']!,
          _fieldNameMarathiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fieldNameMarathiMeta);
    }
    if (data.containsKey('field_name_english')) {
      context.handle(
        _fieldNameEnglishMeta,
        fieldNameEnglish.isAcceptableOrUnknown(
          data['field_name_english']!,
          _fieldNameEnglishMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fieldNameEnglishMeta);
    }
    if (data.containsKey('field_type')) {
      context.handle(
        _fieldTypeMeta,
        fieldType.isAcceptableOrUnknown(data['field_type']!, _fieldTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldTypeMeta);
    }
    if (data.containsKey('section')) {
      context.handle(
        _sectionMeta,
        section.isAcceptableOrUnknown(data['section']!, _sectionMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionMeta);
    }
    if (data.containsKey('is_required')) {
      context.handle(
        _isRequiredMeta,
        isRequired.isAcceptableOrUnknown(data['is_required']!, _isRequiredMeta),
      );
    }
    if (data.containsKey('dropdown_options_json')) {
      context.handle(
        _dropdownOptionsJsonMeta,
        dropdownOptionsJson.isAcceptableOrUnknown(
          data['dropdown_options_json']!,
          _dropdownOptionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomField map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomField(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fieldNameMarathi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_name_marathi'],
      )!,
      fieldNameEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_name_english'],
      )!,
      fieldType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_type'],
      )!,
      section: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section'],
      )!,
      isRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_required'],
      )!,
      dropdownOptionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dropdown_options_json'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CustomFieldsTable createAlias(String alias) {
    return $CustomFieldsTable(attachedDatabase, alias);
  }
}

class CustomField extends DataClass implements Insertable<CustomField> {
  final int id;
  final String fieldNameMarathi;
  final String fieldNameEnglish;
  final String fieldType;
  final String section;
  final bool isRequired;
  final String? dropdownOptionsJson;
  final int displayOrder;
  final DateTime createdAt;
  const CustomField({
    required this.id,
    required this.fieldNameMarathi,
    required this.fieldNameEnglish,
    required this.fieldType,
    required this.section,
    required this.isRequired,
    this.dropdownOptionsJson,
    required this.displayOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['field_name_marathi'] = Variable<String>(fieldNameMarathi);
    map['field_name_english'] = Variable<String>(fieldNameEnglish);
    map['field_type'] = Variable<String>(fieldType);
    map['section'] = Variable<String>(section);
    map['is_required'] = Variable<bool>(isRequired);
    if (!nullToAbsent || dropdownOptionsJson != null) {
      map['dropdown_options_json'] = Variable<String>(dropdownOptionsJson);
    }
    map['display_order'] = Variable<int>(displayOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomFieldsCompanion toCompanion(bool nullToAbsent) {
    return CustomFieldsCompanion(
      id: Value(id),
      fieldNameMarathi: Value(fieldNameMarathi),
      fieldNameEnglish: Value(fieldNameEnglish),
      fieldType: Value(fieldType),
      section: Value(section),
      isRequired: Value(isRequired),
      dropdownOptionsJson: dropdownOptionsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(dropdownOptionsJson),
      displayOrder: Value(displayOrder),
      createdAt: Value(createdAt),
    );
  }

  factory CustomField.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomField(
      id: serializer.fromJson<int>(json['id']),
      fieldNameMarathi: serializer.fromJson<String>(json['fieldNameMarathi']),
      fieldNameEnglish: serializer.fromJson<String>(json['fieldNameEnglish']),
      fieldType: serializer.fromJson<String>(json['fieldType']),
      section: serializer.fromJson<String>(json['section']),
      isRequired: serializer.fromJson<bool>(json['isRequired']),
      dropdownOptionsJson: serializer.fromJson<String?>(
        json['dropdownOptionsJson'],
      ),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fieldNameMarathi': serializer.toJson<String>(fieldNameMarathi),
      'fieldNameEnglish': serializer.toJson<String>(fieldNameEnglish),
      'fieldType': serializer.toJson<String>(fieldType),
      'section': serializer.toJson<String>(section),
      'isRequired': serializer.toJson<bool>(isRequired),
      'dropdownOptionsJson': serializer.toJson<String?>(dropdownOptionsJson),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomField copyWith({
    int? id,
    String? fieldNameMarathi,
    String? fieldNameEnglish,
    String? fieldType,
    String? section,
    bool? isRequired,
    Value<String?> dropdownOptionsJson = const Value.absent(),
    int? displayOrder,
    DateTime? createdAt,
  }) => CustomField(
    id: id ?? this.id,
    fieldNameMarathi: fieldNameMarathi ?? this.fieldNameMarathi,
    fieldNameEnglish: fieldNameEnglish ?? this.fieldNameEnglish,
    fieldType: fieldType ?? this.fieldType,
    section: section ?? this.section,
    isRequired: isRequired ?? this.isRequired,
    dropdownOptionsJson: dropdownOptionsJson.present
        ? dropdownOptionsJson.value
        : this.dropdownOptionsJson,
    displayOrder: displayOrder ?? this.displayOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  CustomField copyWithCompanion(CustomFieldsCompanion data) {
    return CustomField(
      id: data.id.present ? data.id.value : this.id,
      fieldNameMarathi: data.fieldNameMarathi.present
          ? data.fieldNameMarathi.value
          : this.fieldNameMarathi,
      fieldNameEnglish: data.fieldNameEnglish.present
          ? data.fieldNameEnglish.value
          : this.fieldNameEnglish,
      fieldType: data.fieldType.present ? data.fieldType.value : this.fieldType,
      section: data.section.present ? data.section.value : this.section,
      isRequired: data.isRequired.present
          ? data.isRequired.value
          : this.isRequired,
      dropdownOptionsJson: data.dropdownOptionsJson.present
          ? data.dropdownOptionsJson.value
          : this.dropdownOptionsJson,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomField(')
          ..write('id: $id, ')
          ..write('fieldNameMarathi: $fieldNameMarathi, ')
          ..write('fieldNameEnglish: $fieldNameEnglish, ')
          ..write('fieldType: $fieldType, ')
          ..write('section: $section, ')
          ..write('isRequired: $isRequired, ')
          ..write('dropdownOptionsJson: $dropdownOptionsJson, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fieldNameMarathi,
    fieldNameEnglish,
    fieldType,
    section,
    isRequired,
    dropdownOptionsJson,
    displayOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomField &&
          other.id == this.id &&
          other.fieldNameMarathi == this.fieldNameMarathi &&
          other.fieldNameEnglish == this.fieldNameEnglish &&
          other.fieldType == this.fieldType &&
          other.section == this.section &&
          other.isRequired == this.isRequired &&
          other.dropdownOptionsJson == this.dropdownOptionsJson &&
          other.displayOrder == this.displayOrder &&
          other.createdAt == this.createdAt);
}

class CustomFieldsCompanion extends UpdateCompanion<CustomField> {
  final Value<int> id;
  final Value<String> fieldNameMarathi;
  final Value<String> fieldNameEnglish;
  final Value<String> fieldType;
  final Value<String> section;
  final Value<bool> isRequired;
  final Value<String?> dropdownOptionsJson;
  final Value<int> displayOrder;
  final Value<DateTime> createdAt;
  const CustomFieldsCompanion({
    this.id = const Value.absent(),
    this.fieldNameMarathi = const Value.absent(),
    this.fieldNameEnglish = const Value.absent(),
    this.fieldType = const Value.absent(),
    this.section = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.dropdownOptionsJson = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomFieldsCompanion.insert({
    this.id = const Value.absent(),
    required String fieldNameMarathi,
    required String fieldNameEnglish,
    required String fieldType,
    required String section,
    this.isRequired = const Value.absent(),
    this.dropdownOptionsJson = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : fieldNameMarathi = Value(fieldNameMarathi),
       fieldNameEnglish = Value(fieldNameEnglish),
       fieldType = Value(fieldType),
       section = Value(section);
  static Insertable<CustomField> custom({
    Expression<int>? id,
    Expression<String>? fieldNameMarathi,
    Expression<String>? fieldNameEnglish,
    Expression<String>? fieldType,
    Expression<String>? section,
    Expression<bool>? isRequired,
    Expression<String>? dropdownOptionsJson,
    Expression<int>? displayOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fieldNameMarathi != null) 'field_name_marathi': fieldNameMarathi,
      if (fieldNameEnglish != null) 'field_name_english': fieldNameEnglish,
      if (fieldType != null) 'field_type': fieldType,
      if (section != null) 'section': section,
      if (isRequired != null) 'is_required': isRequired,
      if (dropdownOptionsJson != null)
        'dropdown_options_json': dropdownOptionsJson,
      if (displayOrder != null) 'display_order': displayOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomFieldsCompanion copyWith({
    Value<int>? id,
    Value<String>? fieldNameMarathi,
    Value<String>? fieldNameEnglish,
    Value<String>? fieldType,
    Value<String>? section,
    Value<bool>? isRequired,
    Value<String?>? dropdownOptionsJson,
    Value<int>? displayOrder,
    Value<DateTime>? createdAt,
  }) {
    return CustomFieldsCompanion(
      id: id ?? this.id,
      fieldNameMarathi: fieldNameMarathi ?? this.fieldNameMarathi,
      fieldNameEnglish: fieldNameEnglish ?? this.fieldNameEnglish,
      fieldType: fieldType ?? this.fieldType,
      section: section ?? this.section,
      isRequired: isRequired ?? this.isRequired,
      dropdownOptionsJson: dropdownOptionsJson ?? this.dropdownOptionsJson,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fieldNameMarathi.present) {
      map['field_name_marathi'] = Variable<String>(fieldNameMarathi.value);
    }
    if (fieldNameEnglish.present) {
      map['field_name_english'] = Variable<String>(fieldNameEnglish.value);
    }
    if (fieldType.present) {
      map['field_type'] = Variable<String>(fieldType.value);
    }
    if (section.present) {
      map['section'] = Variable<String>(section.value);
    }
    if (isRequired.present) {
      map['is_required'] = Variable<bool>(isRequired.value);
    }
    if (dropdownOptionsJson.present) {
      map['dropdown_options_json'] = Variable<String>(
        dropdownOptionsJson.value,
      );
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomFieldsCompanion(')
          ..write('id: $id, ')
          ..write('fieldNameMarathi: $fieldNameMarathi, ')
          ..write('fieldNameEnglish: $fieldNameEnglish, ')
          ..write('fieldType: $fieldType, ')
          ..write('section: $section, ')
          ..write('isRequired: $isRequired, ')
          ..write('dropdownOptionsJson: $dropdownOptionsJson, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CustomFieldValuesTable extends CustomFieldValues
    with TableInfo<$CustomFieldValuesTable, CustomFieldValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomFieldValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _crimeIdMeta = const VerificationMeta(
    'crimeId',
  );
  @override
  late final GeneratedColumn<int> crimeId = GeneratedColumn<int>(
    'crime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crimes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _customFieldIdMeta = const VerificationMeta(
    'customFieldId',
  );
  @override
  late final GeneratedColumn<int> customFieldId = GeneratedColumn<int>(
    'custom_field_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES custom_fields (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, crimeId, customFieldId, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_field_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomFieldValue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('crime_id')) {
      context.handle(
        _crimeIdMeta,
        crimeId.isAcceptableOrUnknown(data['crime_id']!, _crimeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_crimeIdMeta);
    }
    if (data.containsKey('custom_field_id')) {
      context.handle(
        _customFieldIdMeta,
        customFieldId.isAcceptableOrUnknown(
          data['custom_field_id']!,
          _customFieldIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customFieldIdMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomFieldValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomFieldValue(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      crimeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}crime_id'],
      )!,
      customFieldId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_field_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $CustomFieldValuesTable createAlias(String alias) {
    return $CustomFieldValuesTable(attachedDatabase, alias);
  }
}

class CustomFieldValue extends DataClass
    implements Insertable<CustomFieldValue> {
  final int id;
  final int crimeId;
  final int customFieldId;
  final String? value;
  const CustomFieldValue({
    required this.id,
    required this.crimeId,
    required this.customFieldId,
    this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['crime_id'] = Variable<int>(crimeId);
    map['custom_field_id'] = Variable<int>(customFieldId);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  CustomFieldValuesCompanion toCompanion(bool nullToAbsent) {
    return CustomFieldValuesCompanion(
      id: Value(id),
      crimeId: Value(crimeId),
      customFieldId: Value(customFieldId),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory CustomFieldValue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomFieldValue(
      id: serializer.fromJson<int>(json['id']),
      crimeId: serializer.fromJson<int>(json['crimeId']),
      customFieldId: serializer.fromJson<int>(json['customFieldId']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'crimeId': serializer.toJson<int>(crimeId),
      'customFieldId': serializer.toJson<int>(customFieldId),
      'value': serializer.toJson<String?>(value),
    };
  }

  CustomFieldValue copyWith({
    int? id,
    int? crimeId,
    int? customFieldId,
    Value<String?> value = const Value.absent(),
  }) => CustomFieldValue(
    id: id ?? this.id,
    crimeId: crimeId ?? this.crimeId,
    customFieldId: customFieldId ?? this.customFieldId,
    value: value.present ? value.value : this.value,
  );
  CustomFieldValue copyWithCompanion(CustomFieldValuesCompanion data) {
    return CustomFieldValue(
      id: data.id.present ? data.id.value : this.id,
      crimeId: data.crimeId.present ? data.crimeId.value : this.crimeId,
      customFieldId: data.customFieldId.present
          ? data.customFieldId.value
          : this.customFieldId,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomFieldValue(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('customFieldId: $customFieldId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, crimeId, customFieldId, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomFieldValue &&
          other.id == this.id &&
          other.crimeId == this.crimeId &&
          other.customFieldId == this.customFieldId &&
          other.value == this.value);
}

class CustomFieldValuesCompanion extends UpdateCompanion<CustomFieldValue> {
  final Value<int> id;
  final Value<int> crimeId;
  final Value<int> customFieldId;
  final Value<String?> value;
  const CustomFieldValuesCompanion({
    this.id = const Value.absent(),
    this.crimeId = const Value.absent(),
    this.customFieldId = const Value.absent(),
    this.value = const Value.absent(),
  });
  CustomFieldValuesCompanion.insert({
    this.id = const Value.absent(),
    required int crimeId,
    required int customFieldId,
    this.value = const Value.absent(),
  }) : crimeId = Value(crimeId),
       customFieldId = Value(customFieldId);
  static Insertable<CustomFieldValue> custom({
    Expression<int>? id,
    Expression<int>? crimeId,
    Expression<int>? customFieldId,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crimeId != null) 'crime_id': crimeId,
      if (customFieldId != null) 'custom_field_id': customFieldId,
      if (value != null) 'value': value,
    });
  }

  CustomFieldValuesCompanion copyWith({
    Value<int>? id,
    Value<int>? crimeId,
    Value<int>? customFieldId,
    Value<String?>? value,
  }) {
    return CustomFieldValuesCompanion(
      id: id ?? this.id,
      crimeId: crimeId ?? this.crimeId,
      customFieldId: customFieldId ?? this.customFieldId,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (crimeId.present) {
      map['crime_id'] = Variable<int>(crimeId.value);
    }
    if (customFieldId.present) {
      map['custom_field_id'] = Variable<int>(customFieldId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomFieldValuesCompanion(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('customFieldId: $customFieldId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $StationsTable extends Stations with TableInfo<$StationsTable, Station> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMarathiMeta = const VerificationMeta(
    'nameMarathi',
  );
  @override
  late final GeneratedColumn<String> nameMarathi = GeneratedColumn<String>(
    'name_marathi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnglishMeta = const VerificationMeta(
    'nameEnglish',
  );
  @override
  late final GeneratedColumn<String> nameEnglish = GeneratedColumn<String>(
    'name_english',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _districtMeta = const VerificationMeta(
    'district',
  );
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
    'district',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameMarathi,
    nameEnglish,
    code,
    district,
    address,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Station> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_marathi')) {
      context.handle(
        _nameMarathiMeta,
        nameMarathi.isAcceptableOrUnknown(
          data['name_marathi']!,
          _nameMarathiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameMarathiMeta);
    }
    if (data.containsKey('name_english')) {
      context.handle(
        _nameEnglishMeta,
        nameEnglish.isAcceptableOrUnknown(
          data['name_english']!,
          _nameEnglishMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameEnglishMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('district')) {
      context.handle(
        _districtMeta,
        district.isAcceptableOrUnknown(data['district']!, _districtMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Station map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Station(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameMarathi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_marathi'],
      )!,
      nameEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_english'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      district: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}district'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
    );
  }

  @override
  $StationsTable createAlias(String alias) {
    return $StationsTable(attachedDatabase, alias);
  }
}

class Station extends DataClass implements Insertable<Station> {
  final int id;
  final String nameMarathi;
  final String nameEnglish;
  final String? code;
  final String? district;
  final String? address;
  const Station({
    required this.id,
    required this.nameMarathi,
    required this.nameEnglish,
    this.code,
    this.district,
    this.address,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_marathi'] = Variable<String>(nameMarathi);
    map['name_english'] = Variable<String>(nameEnglish);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || district != null) {
      map['district'] = Variable<String>(district);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    return map;
  }

  StationsCompanion toCompanion(bool nullToAbsent) {
    return StationsCompanion(
      id: Value(id),
      nameMarathi: Value(nameMarathi),
      nameEnglish: Value(nameEnglish),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      district: district == null && nullToAbsent
          ? const Value.absent()
          : Value(district),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
    );
  }

  factory Station.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Station(
      id: serializer.fromJson<int>(json['id']),
      nameMarathi: serializer.fromJson<String>(json['nameMarathi']),
      nameEnglish: serializer.fromJson<String>(json['nameEnglish']),
      code: serializer.fromJson<String?>(json['code']),
      district: serializer.fromJson<String?>(json['district']),
      address: serializer.fromJson<String?>(json['address']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameMarathi': serializer.toJson<String>(nameMarathi),
      'nameEnglish': serializer.toJson<String>(nameEnglish),
      'code': serializer.toJson<String?>(code),
      'district': serializer.toJson<String?>(district),
      'address': serializer.toJson<String?>(address),
    };
  }

  Station copyWith({
    int? id,
    String? nameMarathi,
    String? nameEnglish,
    Value<String?> code = const Value.absent(),
    Value<String?> district = const Value.absent(),
    Value<String?> address = const Value.absent(),
  }) => Station(
    id: id ?? this.id,
    nameMarathi: nameMarathi ?? this.nameMarathi,
    nameEnglish: nameEnglish ?? this.nameEnglish,
    code: code.present ? code.value : this.code,
    district: district.present ? district.value : this.district,
    address: address.present ? address.value : this.address,
  );
  Station copyWithCompanion(StationsCompanion data) {
    return Station(
      id: data.id.present ? data.id.value : this.id,
      nameMarathi: data.nameMarathi.present
          ? data.nameMarathi.value
          : this.nameMarathi,
      nameEnglish: data.nameEnglish.present
          ? data.nameEnglish.value
          : this.nameEnglish,
      code: data.code.present ? data.code.value : this.code,
      district: data.district.present ? data.district.value : this.district,
      address: data.address.present ? data.address.value : this.address,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Station(')
          ..write('id: $id, ')
          ..write('nameMarathi: $nameMarathi, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('code: $code, ')
          ..write('district: $district, ')
          ..write('address: $address')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nameMarathi, nameEnglish, code, district, address);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Station &&
          other.id == this.id &&
          other.nameMarathi == this.nameMarathi &&
          other.nameEnglish == this.nameEnglish &&
          other.code == this.code &&
          other.district == this.district &&
          other.address == this.address);
}

class StationsCompanion extends UpdateCompanion<Station> {
  final Value<int> id;
  final Value<String> nameMarathi;
  final Value<String> nameEnglish;
  final Value<String?> code;
  final Value<String?> district;
  final Value<String?> address;
  const StationsCompanion({
    this.id = const Value.absent(),
    this.nameMarathi = const Value.absent(),
    this.nameEnglish = const Value.absent(),
    this.code = const Value.absent(),
    this.district = const Value.absent(),
    this.address = const Value.absent(),
  });
  StationsCompanion.insert({
    this.id = const Value.absent(),
    required String nameMarathi,
    required String nameEnglish,
    this.code = const Value.absent(),
    this.district = const Value.absent(),
    this.address = const Value.absent(),
  }) : nameMarathi = Value(nameMarathi),
       nameEnglish = Value(nameEnglish);
  static Insertable<Station> custom({
    Expression<int>? id,
    Expression<String>? nameMarathi,
    Expression<String>? nameEnglish,
    Expression<String>? code,
    Expression<String>? district,
    Expression<String>? address,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameMarathi != null) 'name_marathi': nameMarathi,
      if (nameEnglish != null) 'name_english': nameEnglish,
      if (code != null) 'code': code,
      if (district != null) 'district': district,
      if (address != null) 'address': address,
    });
  }

  StationsCompanion copyWith({
    Value<int>? id,
    Value<String>? nameMarathi,
    Value<String>? nameEnglish,
    Value<String?>? code,
    Value<String?>? district,
    Value<String?>? address,
  }) {
    return StationsCompanion(
      id: id ?? this.id,
      nameMarathi: nameMarathi ?? this.nameMarathi,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      code: code ?? this.code,
      district: district ?? this.district,
      address: address ?? this.address,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameMarathi.present) {
      map['name_marathi'] = Variable<String>(nameMarathi.value);
    }
    if (nameEnglish.present) {
      map['name_english'] = Variable<String>(nameEnglish.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StationsCompanion(')
          ..write('id: $id, ')
          ..write('nameMarathi: $nameMarathi, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('code: $code, ')
          ..write('district: $district, ')
          ..write('address: $address')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('officer'),
  );
  static const VerificationMeta _stationIdMeta = const VerificationMeta(
    'stationId',
  );
  @override
  late final GeneratedColumn<int> stationId = GeneratedColumn<int>(
    'station_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    fullName,
    role,
    stationId,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('station_id')) {
      context.handle(
        _stationIdMeta,
        stationId.isAcceptableOrUnknown(data['station_id']!, _stationIdMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      stationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}station_id'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String email;
  final String? fullName;
  final String role;
  final int? stationId;
  final bool isActive;
  final DateTime createdAt;
  const User({
    required this.id,
    required this.email,
    this.fullName,
    required this.role,
    this.stationId,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || fullName != null) {
      map['full_name'] = Variable<String>(fullName);
    }
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || stationId != null) {
      map['station_id'] = Variable<int>(stationId);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      fullName: fullName == null && nullToAbsent
          ? const Value.absent()
          : Value(fullName),
      role: Value(role),
      stationId: stationId == null && nullToAbsent
          ? const Value.absent()
          : Value(stationId),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      fullName: serializer.fromJson<String?>(json['fullName']),
      role: serializer.fromJson<String>(json['role']),
      stationId: serializer.fromJson<int?>(json['stationId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'fullName': serializer.toJson<String?>(fullName),
      'role': serializer.toJson<String>(role),
      'stationId': serializer.toJson<int?>(stationId),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith({
    int? id,
    String? email,
    Value<String?> fullName = const Value.absent(),
    String? role,
    Value<int?> stationId = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    fullName: fullName.present ? fullName.value : this.fullName,
    role: role ?? this.role,
    stationId: stationId.present ? stationId.value : this.stationId,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      role: data.role.present ? data.role.value : this.role,
      stationId: data.stationId.present ? data.stationId.value : this.stationId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('fullName: $fullName, ')
          ..write('role: $role, ')
          ..write('stationId: $stationId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, email, fullName, role, stationId, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.email == this.email &&
          other.fullName == this.fullName &&
          other.role == this.role &&
          other.stationId == this.stationId &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> email;
  final Value<String?> fullName;
  final Value<String> role;
  final Value<int?> stationId;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.fullName = const Value.absent(),
    this.role = const Value.absent(),
    this.stationId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    this.fullName = const Value.absent(),
    this.role = const Value.absent(),
    this.stationId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : email = Value(email);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? fullName,
    Expression<String>? role,
    Expression<int>? stationId,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (fullName != null) 'full_name': fullName,
      if (role != null) 'role': role,
      if (stationId != null) 'station_id': stationId,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? email,
    Value<String?>? fullName,
    Value<String>? role,
    Value<int?>? stationId,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      stationId: stationId ?? this.stationId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (stationId.present) {
      map['station_id'] = Variable<int>(stationId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('fullName: $fullName, ')
          ..write('role: $role, ')
          ..write('stationId: $stationId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ReportTemplatesTable extends ReportTemplates
    with TableInfo<$ReportTemplatesTable, ReportTemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _templateJsonMeta = const VerificationMeta(
    'templateJson',
  );
  @override
  late final GeneratedColumn<String> templateJson = GeneratedColumn<String>(
    'template_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outputFormatMeta = const VerificationMeta(
    'outputFormat',
  );
  @override
  late final GeneratedColumn<String> outputFormat = GeneratedColumn<String>(
    'output_format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('docx'),
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    templateJson,
    outputFormat,
    isSystem,
    createdBy,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'report_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportTemplateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('template_json')) {
      context.handle(
        _templateJsonMeta,
        templateJson.isAcceptableOrUnknown(
          data['template_json']!,
          _templateJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_templateJsonMeta);
    }
    if (data.containsKey('output_format')) {
      context.handle(
        _outputFormatMeta,
        outputFormat.isAcceptableOrUnknown(
          data['output_format']!,
          _outputFormatMeta,
        ),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportTemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportTemplateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      templateJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_json'],
      )!,
      outputFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}output_format'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReportTemplatesTable createAlias(String alias) {
    return $ReportTemplatesTable(attachedDatabase, alias);
  }
}

class ReportTemplateRow extends DataClass
    implements Insertable<ReportTemplateRow> {
  final int id;
  final String name;
  final String? description;
  final String templateJson;
  final String outputFormat;
  final bool isSystem;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ReportTemplateRow({
    required this.id,
    required this.name,
    this.description,
    required this.templateJson,
    required this.outputFormat,
    required this.isSystem,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['template_json'] = Variable<String>(templateJson);
    map['output_format'] = Variable<String>(outputFormat);
    map['is_system'] = Variable<bool>(isSystem);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReportTemplatesCompanion toCompanion(bool nullToAbsent) {
    return ReportTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      templateJson: Value(templateJson),
      outputFormat: Value(outputFormat),
      isSystem: Value(isSystem),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReportTemplateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportTemplateRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      templateJson: serializer.fromJson<String>(json['templateJson']),
      outputFormat: serializer.fromJson<String>(json['outputFormat']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'templateJson': serializer.toJson<String>(templateJson),
      'outputFormat': serializer.toJson<String>(outputFormat),
      'isSystem': serializer.toJson<bool>(isSystem),
      'createdBy': serializer.toJson<String?>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReportTemplateRow copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? templateJson,
    String? outputFormat,
    bool? isSystem,
    Value<String?> createdBy = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ReportTemplateRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    templateJson: templateJson ?? this.templateJson,
    outputFormat: outputFormat ?? this.outputFormat,
    isSystem: isSystem ?? this.isSystem,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReportTemplateRow copyWithCompanion(ReportTemplatesCompanion data) {
    return ReportTemplateRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      templateJson: data.templateJson.present
          ? data.templateJson.value
          : this.templateJson,
      outputFormat: data.outputFormat.present
          ? data.outputFormat.value
          : this.outputFormat,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportTemplateRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('templateJson: $templateJson, ')
          ..write('outputFormat: $outputFormat, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    templateJson,
    outputFormat,
    isSystem,
    createdBy,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportTemplateRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.templateJson == this.templateJson &&
          other.outputFormat == this.outputFormat &&
          other.isSystem == this.isSystem &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ReportTemplatesCompanion extends UpdateCompanion<ReportTemplateRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> templateJson;
  final Value<String> outputFormat;
  final Value<bool> isSystem;
  final Value<String?> createdBy;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ReportTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.templateJson = const Value.absent(),
    this.outputFormat = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ReportTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required String templateJson,
    this.outputFormat = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       templateJson = Value(templateJson);
  static Insertable<ReportTemplateRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? templateJson,
    Expression<String>? outputFormat,
    Expression<bool>? isSystem,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (templateJson != null) 'template_json': templateJson,
      if (outputFormat != null) 'output_format': outputFormat,
      if (isSystem != null) 'is_system': isSystem,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ReportTemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? templateJson,
    Value<String>? outputFormat,
    Value<bool>? isSystem,
    Value<String?>? createdBy,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ReportTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      templateJson: templateJson ?? this.templateJson,
      outputFormat: outputFormat ?? this.outputFormat,
      isSystem: isSystem ?? this.isSystem,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (templateJson.present) {
      map['template_json'] = Variable<String>(templateJson.value);
    }
    if (outputFormat.present) {
      map['output_format'] = Variable<String>(outputFormat.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('templateJson: $templateJson, ')
          ..write('outputFormat: $outputFormat, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _changesJsonMeta = const VerificationMeta(
    'changesJson',
  );
  @override
  late final GeneratedColumn<String> changesJson = GeneratedColumn<String>(
    'changes_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    action,
    entityType,
    entityId,
    changesJson,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('changes_json')) {
      context.handle(
        _changesJsonMeta,
        changesJson.isAcceptableOrUnknown(
          data['changes_json']!,
          _changesJsonMeta,
        ),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      ),
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      ),
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      ),
      changesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}changes_json'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditLogData extends DataClass implements Insertable<AuditLogData> {
  final int id;
  final int? userId;
  final String action;
  final String? entityType;
  final int? entityId;
  final String? changesJson;
  final DateTime timestamp;
  const AuditLogData({
    required this.id,
    this.userId,
    required this.action,
    this.entityType,
    this.entityId,
    this.changesJson,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || entityType != null) {
      map['entity_type'] = Variable<String>(entityType);
    }
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<int>(entityId);
    }
    if (!nullToAbsent || changesJson != null) {
      map['changes_json'] = Variable<String>(changesJson);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      action: Value(action),
      entityType: entityType == null && nullToAbsent
          ? const Value.absent()
          : Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      changesJson: changesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(changesJson),
      timestamp: Value(timestamp),
    );
  }

  factory AuditLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String?>(json['entityType']),
      entityId: serializer.fromJson<int?>(json['entityId']),
      changesJson: serializer.fromJson<String?>(json['changesJson']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int?>(userId),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String?>(entityType),
      'entityId': serializer.toJson<int?>(entityId),
      'changesJson': serializer.toJson<String?>(changesJson),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  AuditLogData copyWith({
    int? id,
    Value<int?> userId = const Value.absent(),
    String? action,
    Value<String?> entityType = const Value.absent(),
    Value<int?> entityId = const Value.absent(),
    Value<String?> changesJson = const Value.absent(),
    DateTime? timestamp,
  }) => AuditLogData(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    action: action ?? this.action,
    entityType: entityType.present ? entityType.value : this.entityType,
    entityId: entityId.present ? entityId.value : this.entityId,
    changesJson: changesJson.present ? changesJson.value : this.changesJson,
    timestamp: timestamp ?? this.timestamp,
  );
  AuditLogData copyWithCompanion(AuditLogCompanion data) {
    return AuditLogData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      changesJson: data.changesJson.present
          ? data.changesJson.value
          : this.changesJson,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('changesJson: $changesJson, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    action,
    entityType,
    entityId,
    changesJson,
    timestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.changesJson == this.changesJson &&
          other.timestamp == this.timestamp);
}

class AuditLogCompanion extends UpdateCompanion<AuditLogData> {
  final Value<int> id;
  final Value<int?> userId;
  final Value<String> action;
  final Value<String?> entityType;
  final Value<int?> entityId;
  final Value<String?> changesJson;
  final Value<DateTime> timestamp;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.changesJson = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  AuditLogCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required String action,
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.changesJson = const Value.absent(),
    this.timestamp = const Value.absent(),
  }) : action = Value(action);
  static Insertable<AuditLogData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? changesJson,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (changesJson != null) 'changes_json': changesJson,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  AuditLogCompanion copyWith({
    Value<int>? id,
    Value<int?>? userId,
    Value<String>? action,
    Value<String?>? entityType,
    Value<int?>? entityId,
    Value<String?>? changesJson,
    Value<DateTime>? timestamp,
  }) {
    return AuditLogCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      changesJson: changesJson ?? this.changesJson,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (changesJson.present) {
      map['changes_json'] = Variable<String>(changesJson.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('changesJson: $changesJson, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CrimesTable crimes = $CrimesTable(this);
  late final $ComplainantsTable complainants = $ComplainantsTable(this);
  late final $AccusedTable accused = $AccusedTable(this);
  late final $StolenPropertyTable stolenProperty = $StolenPropertyTable(this);
  late final $RecoveredPropertyTable recoveredProperty =
      $RecoveredPropertyTable(this);
  late final $InvestigationTable investigation = $InvestigationTable(this);
  late final $VerdictTable verdict = $VerdictTable(this);
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  late final $CustomFieldsTable customFields = $CustomFieldsTable(this);
  late final $CustomFieldValuesTable customFieldValues =
      $CustomFieldValuesTable(this);
  late final $StationsTable stations = $StationsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ReportTemplatesTable reportTemplates = $ReportTemplatesTable(
    this,
  );
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    crimes,
    complainants,
    accused,
    stolenProperty,
    recoveredProperty,
    investigation,
    verdict,
    attachments,
    customFields,
    customFieldValues,
    stations,
    users,
    reportTemplates,
    auditLog,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'crimes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('complainants', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'crimes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('accused', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'crimes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stolen_property', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'crimes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recovered_property', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'crimes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('investigation', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'crimes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('verdict', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'crimes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('attachments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'crimes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('custom_field_values', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'custom_fields',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('custom_field_values', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CrimesTableCreateCompanionBuilder =
    CrimesCompanion Function({
      Value<int> id,
      required String firNo,
      required int year,
      Value<String?> section,
      Value<String?> subSection,
      Value<int?> stationId,
      Value<String?> district,
      Value<String?> policeStation,
      Value<DateTime?> dateOccurred,
      Value<String?> timeOccurred,
      Value<String?> placeOccurred,
      Value<DateTime?> dateRegistered,
      Value<String?> timeRegistered,
      Value<String?> crimeType,
      Value<String> status,
      Value<String?> detailedDescription,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CrimesTableUpdateCompanionBuilder =
    CrimesCompanion Function({
      Value<int> id,
      Value<String> firNo,
      Value<int> year,
      Value<String?> section,
      Value<String?> subSection,
      Value<int?> stationId,
      Value<String?> district,
      Value<String?> policeStation,
      Value<DateTime?> dateOccurred,
      Value<String?> timeOccurred,
      Value<String?> placeOccurred,
      Value<DateTime?> dateRegistered,
      Value<String?> timeRegistered,
      Value<String?> crimeType,
      Value<String> status,
      Value<String?> detailedDescription,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CrimesTableReferences
    extends BaseReferences<_$AppDatabase, $CrimesTable, Crime> {
  $$CrimesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ComplainantsTable, List<Complainant>>
  _complainantsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.complainants,
    aliasName: 'crimes__id__complainants__crime_id',
  );

  $$ComplainantsTableProcessedTableManager get complainantsRefs {
    final manager = $$ComplainantsTableTableManager(
      $_db,
      $_db.complainants,
    ).filter((f) => f.crimeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_complainantsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AccusedTable, List<AccusedData>>
  _accusedRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.accused,
    aliasName: 'crimes__id__accused__crime_id',
  );

  $$AccusedTableProcessedTableManager get accusedRefs {
    final manager = $$AccusedTableTableManager(
      $_db,
      $_db.accused,
    ).filter((f) => f.crimeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_accusedRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StolenPropertyTable, List<StolenPropertyData>>
  _stolenPropertyRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stolenProperty,
    aliasName: 'crimes__id__stolen_property__crime_id',
  );

  $$StolenPropertyTableProcessedTableManager get stolenPropertyRefs {
    final manager = $$StolenPropertyTableTableManager(
      $_db,
      $_db.stolenProperty,
    ).filter((f) => f.crimeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stolenPropertyRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecoveredPropertyTable,
    List<RecoveredPropertyData>
  >
  _recoveredPropertyRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recoveredProperty,
        aliasName: 'crimes__id__recovered_property__crime_id',
      );

  $$RecoveredPropertyTableProcessedTableManager get recoveredPropertyRefs {
    final manager = $$RecoveredPropertyTableTableManager(
      $_db,
      $_db.recoveredProperty,
    ).filter((f) => f.crimeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recoveredPropertyRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InvestigationTable, List<InvestigationData>>
  _investigationRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.investigation,
    aliasName: 'crimes__id__investigation__crime_id',
  );

  $$InvestigationTableProcessedTableManager get investigationRefs {
    final manager = $$InvestigationTableTableManager(
      $_db,
      $_db.investigation,
    ).filter((f) => f.crimeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_investigationRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VerdictTable, List<VerdictData>>
  _verdictRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.verdict,
    aliasName: 'crimes__id__verdict__crime_id',
  );

  $$VerdictTableProcessedTableManager get verdictRefs {
    final manager = $$VerdictTableTableManager(
      $_db,
      $_db.verdict,
    ).filter((f) => f.crimeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_verdictRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AttachmentsTable, List<Attachment>>
  _attachmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.attachments,
    aliasName: 'crimes__id__attachments__crime_id',
  );

  $$AttachmentsTableProcessedTableManager get attachmentsRefs {
    final manager = $$AttachmentsTableTableManager(
      $_db,
      $_db.attachments,
    ).filter((f) => f.crimeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_attachmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CustomFieldValuesTable, List<CustomFieldValue>>
  _customFieldValuesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.customFieldValues,
        aliasName: 'crimes__id__custom_field_values__crime_id',
      );

  $$CustomFieldValuesTableProcessedTableManager get customFieldValuesRefs {
    final manager = $$CustomFieldValuesTableTableManager(
      $_db,
      $_db.customFieldValues,
    ).filter((f) => f.crimeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _customFieldValuesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CrimesTableFilterComposer
    extends Composer<_$AppDatabase, $CrimesTable> {
  $$CrimesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firNo => $composableBuilder(
    column: $table.firNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subSection => $composableBuilder(
    column: $table.subSection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stationId => $composableBuilder(
    column: $table.stationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get policeStation => $composableBuilder(
    column: $table.policeStation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateOccurred => $composableBuilder(
    column: $table.dateOccurred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeOccurred => $composableBuilder(
    column: $table.timeOccurred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeOccurred => $composableBuilder(
    column: $table.placeOccurred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateRegistered => $composableBuilder(
    column: $table.dateRegistered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeRegistered => $composableBuilder(
    column: $table.timeRegistered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get crimeType => $composableBuilder(
    column: $table.crimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailedDescription => $composableBuilder(
    column: $table.detailedDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> complainantsRefs(
    Expression<bool> Function($$ComplainantsTableFilterComposer f) f,
  ) {
    final $$ComplainantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.complainants,
      getReferencedColumn: (t) => t.crimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComplainantsTableFilterComposer(
            $db: $db,
            $table: $db.complainants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> accusedRefs(
    Expression<bool> Function($$AccusedTableFilterComposer f) f,
  ) {
    final $$AccusedTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accused,
      getReferencedColumn: (t) => t.crimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccusedTableFilterComposer(
            $db: $db,
            $table: $db.accused,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stolenPropertyRefs(
    Expression<bool> Function($$StolenPropertyTableFilterComposer f) f,
  ) {
    final $$StolenPropertyTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stolenProperty,
      getReferencedColumn: (t) => t.crimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StolenPropertyTableFilterComposer(
            $db: $db,
            $table: $db.stolenProperty,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recoveredPropertyRefs(
    Expression<bool> Function($$RecoveredPropertyTableFilterComposer f) f,
  ) {
    final $$RecoveredPropertyTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recoveredProperty,
      getReferencedColumn: (t) => t.crimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecoveredPropertyTableFilterComposer(
            $db: $db,
            $table: $db.recoveredProperty,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> investigationRefs(
    Expression<bool> Function($$InvestigationTableFilterComposer f) f,
  ) {
    final $$InvestigationTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.investigation,
      getReferencedColumn: (t) => t.crimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvestigationTableFilterComposer(
            $db: $db,
            $table: $db.investigation,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> verdictRefs(
    Expression<bool> Function($$VerdictTableFilterComposer f) f,
  ) {
    final $$VerdictTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verdict,
      getReferencedColumn: (t) => t.crimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerdictTableFilterComposer(
            $db: $db,
            $table: $db.verdict,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> attachmentsRefs(
    Expression<bool> Function($$AttachmentsTableFilterComposer f) f,
  ) {
    final $$AttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.crimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> customFieldValuesRefs(
    Expression<bool> Function($$CustomFieldValuesTableFilterComposer f) f,
  ) {
    final $$CustomFieldValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customFieldValues,
      getReferencedColumn: (t) => t.crimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomFieldValuesTableFilterComposer(
            $db: $db,
            $table: $db.customFieldValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CrimesTableOrderingComposer
    extends Composer<_$AppDatabase, $CrimesTable> {
  $$CrimesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firNo => $composableBuilder(
    column: $table.firNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subSection => $composableBuilder(
    column: $table.subSection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stationId => $composableBuilder(
    column: $table.stationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get policeStation => $composableBuilder(
    column: $table.policeStation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateOccurred => $composableBuilder(
    column: $table.dateOccurred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeOccurred => $composableBuilder(
    column: $table.timeOccurred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeOccurred => $composableBuilder(
    column: $table.placeOccurred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateRegistered => $composableBuilder(
    column: $table.dateRegistered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeRegistered => $composableBuilder(
    column: $table.timeRegistered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get crimeType => $composableBuilder(
    column: $table.crimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailedDescription => $composableBuilder(
    column: $table.detailedDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CrimesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CrimesTable> {
  $$CrimesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firNo =>
      $composableBuilder(column: $table.firNo, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get section =>
      $composableBuilder(column: $table.section, builder: (column) => column);

  GeneratedColumn<String> get subSection => $composableBuilder(
    column: $table.subSection,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stationId =>
      $composableBuilder(column: $table.stationId, builder: (column) => column);

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<String> get policeStation => $composableBuilder(
    column: $table.policeStation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateOccurred => $composableBuilder(
    column: $table.dateOccurred,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeOccurred => $composableBuilder(
    column: $table.timeOccurred,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placeOccurred => $composableBuilder(
    column: $table.placeOccurred,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateRegistered => $composableBuilder(
    column: $table.dateRegistered,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeRegistered => $composableBuilder(
    column: $table.timeRegistered,
    builder: (column) => column,
  );

  GeneratedColumn<String> get crimeType =>
      $composableBuilder(column: $table.crimeType, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get detailedDescription => $composableBuilder(
    column: $table.detailedDescription,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> complainantsRefs<T extends Object>(
    Expression<T> Function($$ComplainantsTableAnnotationComposer a) f,
  ) {
    final $$ComplainantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.complainants,
      getReferencedColumn: (t) => t.crimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComplainantsTableAnnotationComposer(
            $db: $db,
            $table: $db.complainants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> accusedRefs<T extends Object>(
    Expression<T> Function($$AccusedTableAnnotationComposer a) f,
  ) {
    final $$AccusedTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accused,
      getReferencedColumn: (t) => t.crimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccusedTableAnnotationComposer(
            $db: $db,
            $table: $db.accused,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stolenPropertyRefs<T extends Object>(
    Expression<T> Function($$StolenPropertyTableAnnotationComposer a) f,
  ) {
    final $$StolenPropertyTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stolenProperty,
      getReferencedColumn: (t) => t.crimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StolenPropertyTableAnnotationComposer(
            $db: $db,
            $table: $db.stolenProperty,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recoveredPropertyRefs<T extends Object>(
    Expression<T> Function($$RecoveredPropertyTableAnnotationComposer a) f,
  ) {
    final $$RecoveredPropertyTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recoveredProperty,
          getReferencedColumn: (t) => t.crimeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecoveredPropertyTableAnnotationComposer(
                $db: $db,
                $table: $db.recoveredProperty,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> investigationRefs<T extends Object>(
    Expression<T> Function($$InvestigationTableAnnotationComposer a) f,
  ) {
    final $$InvestigationTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.investigation,
      getReferencedColumn: (t) => t.crimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvestigationTableAnnotationComposer(
            $db: $db,
            $table: $db.investigation,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> verdictRefs<T extends Object>(
    Expression<T> Function($$VerdictTableAnnotationComposer a) f,
  ) {
    final $$VerdictTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verdict,
      getReferencedColumn: (t) => t.crimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerdictTableAnnotationComposer(
            $db: $db,
            $table: $db.verdict,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> attachmentsRefs<T extends Object>(
    Expression<T> Function($$AttachmentsTableAnnotationComposer a) f,
  ) {
    final $$AttachmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.crimeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttachmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> customFieldValuesRefs<T extends Object>(
    Expression<T> Function($$CustomFieldValuesTableAnnotationComposer a) f,
  ) {
    final $$CustomFieldValuesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.customFieldValues,
          getReferencedColumn: (t) => t.crimeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CustomFieldValuesTableAnnotationComposer(
                $db: $db,
                $table: $db.customFieldValues,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CrimesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CrimesTable,
          Crime,
          $$CrimesTableFilterComposer,
          $$CrimesTableOrderingComposer,
          $$CrimesTableAnnotationComposer,
          $$CrimesTableCreateCompanionBuilder,
          $$CrimesTableUpdateCompanionBuilder,
          (Crime, $$CrimesTableReferences),
          Crime,
          PrefetchHooks Function({
            bool complainantsRefs,
            bool accusedRefs,
            bool stolenPropertyRefs,
            bool recoveredPropertyRefs,
            bool investigationRefs,
            bool verdictRefs,
            bool attachmentsRefs,
            bool customFieldValuesRefs,
          })
        > {
  $$CrimesTableTableManager(_$AppDatabase db, $CrimesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CrimesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CrimesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CrimesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> firNo = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String?> section = const Value.absent(),
                Value<String?> subSection = const Value.absent(),
                Value<int?> stationId = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String?> policeStation = const Value.absent(),
                Value<DateTime?> dateOccurred = const Value.absent(),
                Value<String?> timeOccurred = const Value.absent(),
                Value<String?> placeOccurred = const Value.absent(),
                Value<DateTime?> dateRegistered = const Value.absent(),
                Value<String?> timeRegistered = const Value.absent(),
                Value<String?> crimeType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> detailedDescription = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CrimesCompanion(
                id: id,
                firNo: firNo,
                year: year,
                section: section,
                subSection: subSection,
                stationId: stationId,
                district: district,
                policeStation: policeStation,
                dateOccurred: dateOccurred,
                timeOccurred: timeOccurred,
                placeOccurred: placeOccurred,
                dateRegistered: dateRegistered,
                timeRegistered: timeRegistered,
                crimeType: crimeType,
                status: status,
                detailedDescription: detailedDescription,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String firNo,
                required int year,
                Value<String?> section = const Value.absent(),
                Value<String?> subSection = const Value.absent(),
                Value<int?> stationId = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String?> policeStation = const Value.absent(),
                Value<DateTime?> dateOccurred = const Value.absent(),
                Value<String?> timeOccurred = const Value.absent(),
                Value<String?> placeOccurred = const Value.absent(),
                Value<DateTime?> dateRegistered = const Value.absent(),
                Value<String?> timeRegistered = const Value.absent(),
                Value<String?> crimeType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> detailedDescription = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CrimesCompanion.insert(
                id: id,
                firNo: firNo,
                year: year,
                section: section,
                subSection: subSection,
                stationId: stationId,
                district: district,
                policeStation: policeStation,
                dateOccurred: dateOccurred,
                timeOccurred: timeOccurred,
                placeOccurred: placeOccurred,
                dateRegistered: dateRegistered,
                timeRegistered: timeRegistered,
                crimeType: crimeType,
                status: status,
                detailedDescription: detailedDescription,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CrimesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                complainantsRefs = false,
                accusedRefs = false,
                stolenPropertyRefs = false,
                recoveredPropertyRefs = false,
                investigationRefs = false,
                verdictRefs = false,
                attachmentsRefs = false,
                customFieldValuesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (complainantsRefs) db.complainants,
                    if (accusedRefs) db.accused,
                    if (stolenPropertyRefs) db.stolenProperty,
                    if (recoveredPropertyRefs) db.recoveredProperty,
                    if (investigationRefs) db.investigation,
                    if (verdictRefs) db.verdict,
                    if (attachmentsRefs) db.attachments,
                    if (customFieldValuesRefs) db.customFieldValues,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (complainantsRefs)
                        await $_getPrefetchedData<
                          Crime,
                          $CrimesTable,
                          Complainant
                        >(
                          currentTable: table,
                          referencedTable: $$CrimesTableReferences
                              ._complainantsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CrimesTableReferences(
                                db,
                                table,
                                p0,
                              ).complainantsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.crimeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (accusedRefs)
                        await $_getPrefetchedData<
                          Crime,
                          $CrimesTable,
                          AccusedData
                        >(
                          currentTable: table,
                          referencedTable: $$CrimesTableReferences
                              ._accusedRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CrimesTableReferences(
                                db,
                                table,
                                p0,
                              ).accusedRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.crimeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stolenPropertyRefs)
                        await $_getPrefetchedData<
                          Crime,
                          $CrimesTable,
                          StolenPropertyData
                        >(
                          currentTable: table,
                          referencedTable: $$CrimesTableReferences
                              ._stolenPropertyRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CrimesTableReferences(
                                db,
                                table,
                                p0,
                              ).stolenPropertyRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.crimeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recoveredPropertyRefs)
                        await $_getPrefetchedData<
                          Crime,
                          $CrimesTable,
                          RecoveredPropertyData
                        >(
                          currentTable: table,
                          referencedTable: $$CrimesTableReferences
                              ._recoveredPropertyRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CrimesTableReferences(
                                db,
                                table,
                                p0,
                              ).recoveredPropertyRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.crimeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (investigationRefs)
                        await $_getPrefetchedData<
                          Crime,
                          $CrimesTable,
                          InvestigationData
                        >(
                          currentTable: table,
                          referencedTable: $$CrimesTableReferences
                              ._investigationRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CrimesTableReferences(
                                db,
                                table,
                                p0,
                              ).investigationRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.crimeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (verdictRefs)
                        await $_getPrefetchedData<
                          Crime,
                          $CrimesTable,
                          VerdictData
                        >(
                          currentTable: table,
                          referencedTable: $$CrimesTableReferences
                              ._verdictRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CrimesTableReferences(
                                db,
                                table,
                                p0,
                              ).verdictRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.crimeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (attachmentsRefs)
                        await $_getPrefetchedData<
                          Crime,
                          $CrimesTable,
                          Attachment
                        >(
                          currentTable: table,
                          referencedTable: $$CrimesTableReferences
                              ._attachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CrimesTableReferences(
                                db,
                                table,
                                p0,
                              ).attachmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.crimeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (customFieldValuesRefs)
                        await $_getPrefetchedData<
                          Crime,
                          $CrimesTable,
                          CustomFieldValue
                        >(
                          currentTable: table,
                          referencedTable: $$CrimesTableReferences
                              ._customFieldValuesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CrimesTableReferences(
                                db,
                                table,
                                p0,
                              ).customFieldValuesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.crimeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CrimesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CrimesTable,
      Crime,
      $$CrimesTableFilterComposer,
      $$CrimesTableOrderingComposer,
      $$CrimesTableAnnotationComposer,
      $$CrimesTableCreateCompanionBuilder,
      $$CrimesTableUpdateCompanionBuilder,
      (Crime, $$CrimesTableReferences),
      Crime,
      PrefetchHooks Function({
        bool complainantsRefs,
        bool accusedRefs,
        bool stolenPropertyRefs,
        bool recoveredPropertyRefs,
        bool investigationRefs,
        bool verdictRefs,
        bool attachmentsRefs,
        bool customFieldValuesRefs,
      })
    >;
typedef $$ComplainantsTableCreateCompanionBuilder =
    ComplainantsCompanion Function({
      Value<int> id,
      required int crimeId,
      required String name,
      Value<String?> gender,
      Value<int?> age,
      Value<String?> address,
      Value<String?> mobile,
      Value<String?> email,
      Value<String?> aadhaarEnc,
      Value<String?> panEnc,
      Value<String?> passport,
    });
typedef $$ComplainantsTableUpdateCompanionBuilder =
    ComplainantsCompanion Function({
      Value<int> id,
      Value<int> crimeId,
      Value<String> name,
      Value<String?> gender,
      Value<int?> age,
      Value<String?> address,
      Value<String?> mobile,
      Value<String?> email,
      Value<String?> aadhaarEnc,
      Value<String?> panEnc,
      Value<String?> passport,
    });

final class $$ComplainantsTableReferences
    extends BaseReferences<_$AppDatabase, $ComplainantsTable, Complainant> {
  $$ComplainantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CrimesTable _crimeIdTable(_$AppDatabase db) =>
      db.crimes.createAlias('complainants__crime_id__crimes__id');

  $$CrimesTableProcessedTableManager get crimeId {
    final $_column = $_itemColumn<int>('crime_id')!;

    final manager = $$CrimesTableTableManager(
      $_db,
      $_db.crimes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_crimeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ComplainantsTableFilterComposer
    extends Composer<_$AppDatabase, $ComplainantsTable> {
  $$ComplainantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aadhaarEnc => $composableBuilder(
    column: $table.aadhaarEnc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get panEnc => $composableBuilder(
    column: $table.panEnc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passport => $composableBuilder(
    column: $table.passport,
    builder: (column) => ColumnFilters(column),
  );

  $$CrimesTableFilterComposer get crimeId {
    final $$CrimesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableFilterComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComplainantsTableOrderingComposer
    extends Composer<_$AppDatabase, $ComplainantsTable> {
  $$ComplainantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aadhaarEnc => $composableBuilder(
    column: $table.aadhaarEnc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get panEnc => $composableBuilder(
    column: $table.panEnc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passport => $composableBuilder(
    column: $table.passport,
    builder: (column) => ColumnOrderings(column),
  );

  $$CrimesTableOrderingComposer get crimeId {
    final $$CrimesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableOrderingComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComplainantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComplainantsTable> {
  $$ComplainantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get aadhaarEnc => $composableBuilder(
    column: $table.aadhaarEnc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get panEnc =>
      $composableBuilder(column: $table.panEnc, builder: (column) => column);

  GeneratedColumn<String> get passport =>
      $composableBuilder(column: $table.passport, builder: (column) => column);

  $$CrimesTableAnnotationComposer get crimeId {
    final $$CrimesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableAnnotationComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComplainantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComplainantsTable,
          Complainant,
          $$ComplainantsTableFilterComposer,
          $$ComplainantsTableOrderingComposer,
          $$ComplainantsTableAnnotationComposer,
          $$ComplainantsTableCreateCompanionBuilder,
          $$ComplainantsTableUpdateCompanionBuilder,
          (Complainant, $$ComplainantsTableReferences),
          Complainant,
          PrefetchHooks Function({bool crimeId})
        > {
  $$ComplainantsTableTableManager(_$AppDatabase db, $ComplainantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComplainantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComplainantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComplainantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> crimeId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> mobile = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> aadhaarEnc = const Value.absent(),
                Value<String?> panEnc = const Value.absent(),
                Value<String?> passport = const Value.absent(),
              }) => ComplainantsCompanion(
                id: id,
                crimeId: crimeId,
                name: name,
                gender: gender,
                age: age,
                address: address,
                mobile: mobile,
                email: email,
                aadhaarEnc: aadhaarEnc,
                panEnc: panEnc,
                passport: passport,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int crimeId,
                required String name,
                Value<String?> gender = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> mobile = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> aadhaarEnc = const Value.absent(),
                Value<String?> panEnc = const Value.absent(),
                Value<String?> passport = const Value.absent(),
              }) => ComplainantsCompanion.insert(
                id: id,
                crimeId: crimeId,
                name: name,
                gender: gender,
                age: age,
                address: address,
                mobile: mobile,
                email: email,
                aadhaarEnc: aadhaarEnc,
                panEnc: panEnc,
                passport: passport,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ComplainantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({crimeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (crimeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.crimeId,
                                referencedTable: $$ComplainantsTableReferences
                                    ._crimeIdTable(db),
                                referencedColumn: $$ComplainantsTableReferences
                                    ._crimeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ComplainantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComplainantsTable,
      Complainant,
      $$ComplainantsTableFilterComposer,
      $$ComplainantsTableOrderingComposer,
      $$ComplainantsTableAnnotationComposer,
      $$ComplainantsTableCreateCompanionBuilder,
      $$ComplainantsTableUpdateCompanionBuilder,
      (Complainant, $$ComplainantsTableReferences),
      Complainant,
      PrefetchHooks Function({bool crimeId})
    >;
typedef $$AccusedTableCreateCompanionBuilder =
    AccusedCompanion Function({
      Value<int> id,
      required int crimeId,
      required String name,
      Value<String?> gender,
      Value<int?> age,
      Value<String?> address,
      Value<String?> mobile,
      Value<String?> email,
      Value<String?> aadhaarEnc,
      Value<String?> panEnc,
      Value<String?> passport,
      Value<String?> arrestStatus,
      Value<DateTime?> arrestDate,
      Value<String?> arrestTime,
      Value<String?> photoPath,
    });
typedef $$AccusedTableUpdateCompanionBuilder =
    AccusedCompanion Function({
      Value<int> id,
      Value<int> crimeId,
      Value<String> name,
      Value<String?> gender,
      Value<int?> age,
      Value<String?> address,
      Value<String?> mobile,
      Value<String?> email,
      Value<String?> aadhaarEnc,
      Value<String?> panEnc,
      Value<String?> passport,
      Value<String?> arrestStatus,
      Value<DateTime?> arrestDate,
      Value<String?> arrestTime,
      Value<String?> photoPath,
    });

final class $$AccusedTableReferences
    extends BaseReferences<_$AppDatabase, $AccusedTable, AccusedData> {
  $$AccusedTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CrimesTable _crimeIdTable(_$AppDatabase db) =>
      db.crimes.createAlias('accused__crime_id__crimes__id');

  $$CrimesTableProcessedTableManager get crimeId {
    final $_column = $_itemColumn<int>('crime_id')!;

    final manager = $$CrimesTableTableManager(
      $_db,
      $_db.crimes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_crimeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AccusedTableFilterComposer
    extends Composer<_$AppDatabase, $AccusedTable> {
  $$AccusedTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aadhaarEnc => $composableBuilder(
    column: $table.aadhaarEnc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get panEnc => $composableBuilder(
    column: $table.panEnc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passport => $composableBuilder(
    column: $table.passport,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arrestStatus => $composableBuilder(
    column: $table.arrestStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get arrestDate => $composableBuilder(
    column: $table.arrestDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arrestTime => $composableBuilder(
    column: $table.arrestTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  $$CrimesTableFilterComposer get crimeId {
    final $$CrimesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableFilterComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccusedTableOrderingComposer
    extends Composer<_$AppDatabase, $AccusedTable> {
  $$AccusedTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aadhaarEnc => $composableBuilder(
    column: $table.aadhaarEnc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get panEnc => $composableBuilder(
    column: $table.panEnc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passport => $composableBuilder(
    column: $table.passport,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arrestStatus => $composableBuilder(
    column: $table.arrestStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get arrestDate => $composableBuilder(
    column: $table.arrestDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arrestTime => $composableBuilder(
    column: $table.arrestTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  $$CrimesTableOrderingComposer get crimeId {
    final $$CrimesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableOrderingComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccusedTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccusedTable> {
  $$AccusedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get aadhaarEnc => $composableBuilder(
    column: $table.aadhaarEnc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get panEnc =>
      $composableBuilder(column: $table.panEnc, builder: (column) => column);

  GeneratedColumn<String> get passport =>
      $composableBuilder(column: $table.passport, builder: (column) => column);

  GeneratedColumn<String> get arrestStatus => $composableBuilder(
    column: $table.arrestStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get arrestDate => $composableBuilder(
    column: $table.arrestDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get arrestTime => $composableBuilder(
    column: $table.arrestTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  $$CrimesTableAnnotationComposer get crimeId {
    final $$CrimesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableAnnotationComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccusedTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccusedTable,
          AccusedData,
          $$AccusedTableFilterComposer,
          $$AccusedTableOrderingComposer,
          $$AccusedTableAnnotationComposer,
          $$AccusedTableCreateCompanionBuilder,
          $$AccusedTableUpdateCompanionBuilder,
          (AccusedData, $$AccusedTableReferences),
          AccusedData,
          PrefetchHooks Function({bool crimeId})
        > {
  $$AccusedTableTableManager(_$AppDatabase db, $AccusedTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccusedTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccusedTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccusedTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> crimeId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> mobile = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> aadhaarEnc = const Value.absent(),
                Value<String?> panEnc = const Value.absent(),
                Value<String?> passport = const Value.absent(),
                Value<String?> arrestStatus = const Value.absent(),
                Value<DateTime?> arrestDate = const Value.absent(),
                Value<String?> arrestTime = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
              }) => AccusedCompanion(
                id: id,
                crimeId: crimeId,
                name: name,
                gender: gender,
                age: age,
                address: address,
                mobile: mobile,
                email: email,
                aadhaarEnc: aadhaarEnc,
                panEnc: panEnc,
                passport: passport,
                arrestStatus: arrestStatus,
                arrestDate: arrestDate,
                arrestTime: arrestTime,
                photoPath: photoPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int crimeId,
                required String name,
                Value<String?> gender = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> mobile = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> aadhaarEnc = const Value.absent(),
                Value<String?> panEnc = const Value.absent(),
                Value<String?> passport = const Value.absent(),
                Value<String?> arrestStatus = const Value.absent(),
                Value<DateTime?> arrestDate = const Value.absent(),
                Value<String?> arrestTime = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
              }) => AccusedCompanion.insert(
                id: id,
                crimeId: crimeId,
                name: name,
                gender: gender,
                age: age,
                address: address,
                mobile: mobile,
                email: email,
                aadhaarEnc: aadhaarEnc,
                panEnc: panEnc,
                passport: passport,
                arrestStatus: arrestStatus,
                arrestDate: arrestDate,
                arrestTime: arrestTime,
                photoPath: photoPath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccusedTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({crimeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (crimeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.crimeId,
                                referencedTable: $$AccusedTableReferences
                                    ._crimeIdTable(db),
                                referencedColumn: $$AccusedTableReferences
                                    ._crimeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AccusedTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccusedTable,
      AccusedData,
      $$AccusedTableFilterComposer,
      $$AccusedTableOrderingComposer,
      $$AccusedTableAnnotationComposer,
      $$AccusedTableCreateCompanionBuilder,
      $$AccusedTableUpdateCompanionBuilder,
      (AccusedData, $$AccusedTableReferences),
      AccusedData,
      PrefetchHooks Function({bool crimeId})
    >;
typedef $$StolenPropertyTableCreateCompanionBuilder =
    StolenPropertyCompanion Function({
      Value<int> id,
      required int crimeId,
      Value<String?> type,
      Value<String?> description,
      Value<double?> value,
    });
typedef $$StolenPropertyTableUpdateCompanionBuilder =
    StolenPropertyCompanion Function({
      Value<int> id,
      Value<int> crimeId,
      Value<String?> type,
      Value<String?> description,
      Value<double?> value,
    });

final class $$StolenPropertyTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StolenPropertyTable,
          StolenPropertyData
        > {
  $$StolenPropertyTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CrimesTable _crimeIdTable(_$AppDatabase db) =>
      db.crimes.createAlias('stolen_property__crime_id__crimes__id');

  $$CrimesTableProcessedTableManager get crimeId {
    final $_column = $_itemColumn<int>('crime_id')!;

    final manager = $$CrimesTableTableManager(
      $_db,
      $_db.crimes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_crimeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StolenPropertyTableFilterComposer
    extends Composer<_$AppDatabase, $StolenPropertyTable> {
  $$StolenPropertyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  $$CrimesTableFilterComposer get crimeId {
    final $$CrimesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableFilterComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StolenPropertyTableOrderingComposer
    extends Composer<_$AppDatabase, $StolenPropertyTable> {
  $$StolenPropertyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  $$CrimesTableOrderingComposer get crimeId {
    final $$CrimesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableOrderingComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StolenPropertyTableAnnotationComposer
    extends Composer<_$AppDatabase, $StolenPropertyTable> {
  $$StolenPropertyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$CrimesTableAnnotationComposer get crimeId {
    final $$CrimesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableAnnotationComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StolenPropertyTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StolenPropertyTable,
          StolenPropertyData,
          $$StolenPropertyTableFilterComposer,
          $$StolenPropertyTableOrderingComposer,
          $$StolenPropertyTableAnnotationComposer,
          $$StolenPropertyTableCreateCompanionBuilder,
          $$StolenPropertyTableUpdateCompanionBuilder,
          (StolenPropertyData, $$StolenPropertyTableReferences),
          StolenPropertyData,
          PrefetchHooks Function({bool crimeId})
        > {
  $$StolenPropertyTableTableManager(
    _$AppDatabase db,
    $StolenPropertyTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StolenPropertyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StolenPropertyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StolenPropertyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> crimeId = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double?> value = const Value.absent(),
              }) => StolenPropertyCompanion(
                id: id,
                crimeId: crimeId,
                type: type,
                description: description,
                value: value,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int crimeId,
                Value<String?> type = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double?> value = const Value.absent(),
              }) => StolenPropertyCompanion.insert(
                id: id,
                crimeId: crimeId,
                type: type,
                description: description,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StolenPropertyTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({crimeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (crimeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.crimeId,
                                referencedTable: $$StolenPropertyTableReferences
                                    ._crimeIdTable(db),
                                referencedColumn:
                                    $$StolenPropertyTableReferences
                                        ._crimeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StolenPropertyTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StolenPropertyTable,
      StolenPropertyData,
      $$StolenPropertyTableFilterComposer,
      $$StolenPropertyTableOrderingComposer,
      $$StolenPropertyTableAnnotationComposer,
      $$StolenPropertyTableCreateCompanionBuilder,
      $$StolenPropertyTableUpdateCompanionBuilder,
      (StolenPropertyData, $$StolenPropertyTableReferences),
      StolenPropertyData,
      PrefetchHooks Function({bool crimeId})
    >;
typedef $$RecoveredPropertyTableCreateCompanionBuilder =
    RecoveredPropertyCompanion Function({
      Value<int> id,
      required int crimeId,
      Value<String?> description,
      Value<double?> value,
      Value<DateTime?> recoveryDate,
    });
typedef $$RecoveredPropertyTableUpdateCompanionBuilder =
    RecoveredPropertyCompanion Function({
      Value<int> id,
      Value<int> crimeId,
      Value<String?> description,
      Value<double?> value,
      Value<DateTime?> recoveryDate,
    });

final class $$RecoveredPropertyTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecoveredPropertyTable,
          RecoveredPropertyData
        > {
  $$RecoveredPropertyTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CrimesTable _crimeIdTable(_$AppDatabase db) =>
      db.crimes.createAlias('recovered_property__crime_id__crimes__id');

  $$CrimesTableProcessedTableManager get crimeId {
    final $_column = $_itemColumn<int>('crime_id')!;

    final manager = $$CrimesTableTableManager(
      $_db,
      $_db.crimes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_crimeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecoveredPropertyTableFilterComposer
    extends Composer<_$AppDatabase, $RecoveredPropertyTable> {
  $$RecoveredPropertyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recoveryDate => $composableBuilder(
    column: $table.recoveryDate,
    builder: (column) => ColumnFilters(column),
  );

  $$CrimesTableFilterComposer get crimeId {
    final $$CrimesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableFilterComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecoveredPropertyTableOrderingComposer
    extends Composer<_$AppDatabase, $RecoveredPropertyTable> {
  $$RecoveredPropertyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recoveryDate => $composableBuilder(
    column: $table.recoveryDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$CrimesTableOrderingComposer get crimeId {
    final $$CrimesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableOrderingComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecoveredPropertyTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecoveredPropertyTable> {
  $$RecoveredPropertyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get recoveryDate => $composableBuilder(
    column: $table.recoveryDate,
    builder: (column) => column,
  );

  $$CrimesTableAnnotationComposer get crimeId {
    final $$CrimesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableAnnotationComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecoveredPropertyTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecoveredPropertyTable,
          RecoveredPropertyData,
          $$RecoveredPropertyTableFilterComposer,
          $$RecoveredPropertyTableOrderingComposer,
          $$RecoveredPropertyTableAnnotationComposer,
          $$RecoveredPropertyTableCreateCompanionBuilder,
          $$RecoveredPropertyTableUpdateCompanionBuilder,
          (RecoveredPropertyData, $$RecoveredPropertyTableReferences),
          RecoveredPropertyData,
          PrefetchHooks Function({bool crimeId})
        > {
  $$RecoveredPropertyTableTableManager(
    _$AppDatabase db,
    $RecoveredPropertyTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecoveredPropertyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecoveredPropertyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecoveredPropertyTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> crimeId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double?> value = const Value.absent(),
                Value<DateTime?> recoveryDate = const Value.absent(),
              }) => RecoveredPropertyCompanion(
                id: id,
                crimeId: crimeId,
                description: description,
                value: value,
                recoveryDate: recoveryDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int crimeId,
                Value<String?> description = const Value.absent(),
                Value<double?> value = const Value.absent(),
                Value<DateTime?> recoveryDate = const Value.absent(),
              }) => RecoveredPropertyCompanion.insert(
                id: id,
                crimeId: crimeId,
                description: description,
                value: value,
                recoveryDate: recoveryDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecoveredPropertyTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({crimeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (crimeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.crimeId,
                                referencedTable:
                                    $$RecoveredPropertyTableReferences
                                        ._crimeIdTable(db),
                                referencedColumn:
                                    $$RecoveredPropertyTableReferences
                                        ._crimeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecoveredPropertyTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecoveredPropertyTable,
      RecoveredPropertyData,
      $$RecoveredPropertyTableFilterComposer,
      $$RecoveredPropertyTableOrderingComposer,
      $$RecoveredPropertyTableAnnotationComposer,
      $$RecoveredPropertyTableCreateCompanionBuilder,
      $$RecoveredPropertyTableUpdateCompanionBuilder,
      (RecoveredPropertyData, $$RecoveredPropertyTableReferences),
      RecoveredPropertyData,
      PrefetchHooks Function({bool crimeId})
    >;
typedef $$InvestigationTableCreateCompanionBuilder =
    InvestigationCompanion Function({
      Value<int> id,
      required int crimeId,
      Value<String?> officerName,
      Value<String?> officerId,
      Value<String?> officerMobile,
      Value<String?> filedBy,
      Value<String?> preventiveAction,
      Value<String?> preventiveNo,
      Value<DateTime?> preventiveDate,
      Value<String?> wantedAccused,
    });
typedef $$InvestigationTableUpdateCompanionBuilder =
    InvestigationCompanion Function({
      Value<int> id,
      Value<int> crimeId,
      Value<String?> officerName,
      Value<String?> officerId,
      Value<String?> officerMobile,
      Value<String?> filedBy,
      Value<String?> preventiveAction,
      Value<String?> preventiveNo,
      Value<DateTime?> preventiveDate,
      Value<String?> wantedAccused,
    });

final class $$InvestigationTableReferences
    extends
        BaseReferences<_$AppDatabase, $InvestigationTable, InvestigationData> {
  $$InvestigationTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CrimesTable _crimeIdTable(_$AppDatabase db) =>
      db.crimes.createAlias('investigation__crime_id__crimes__id');

  $$CrimesTableProcessedTableManager get crimeId {
    final $_column = $_itemColumn<int>('crime_id')!;

    final manager = $$CrimesTableTableManager(
      $_db,
      $_db.crimes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_crimeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InvestigationTableFilterComposer
    extends Composer<_$AppDatabase, $InvestigationTable> {
  $$InvestigationTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get officerName => $composableBuilder(
    column: $table.officerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get officerId => $composableBuilder(
    column: $table.officerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get officerMobile => $composableBuilder(
    column: $table.officerMobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filedBy => $composableBuilder(
    column: $table.filedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preventiveAction => $composableBuilder(
    column: $table.preventiveAction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preventiveNo => $composableBuilder(
    column: $table.preventiveNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get preventiveDate => $composableBuilder(
    column: $table.preventiveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wantedAccused => $composableBuilder(
    column: $table.wantedAccused,
    builder: (column) => ColumnFilters(column),
  );

  $$CrimesTableFilterComposer get crimeId {
    final $$CrimesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableFilterComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvestigationTableOrderingComposer
    extends Composer<_$AppDatabase, $InvestigationTable> {
  $$InvestigationTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get officerName => $composableBuilder(
    column: $table.officerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get officerId => $composableBuilder(
    column: $table.officerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get officerMobile => $composableBuilder(
    column: $table.officerMobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filedBy => $composableBuilder(
    column: $table.filedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preventiveAction => $composableBuilder(
    column: $table.preventiveAction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preventiveNo => $composableBuilder(
    column: $table.preventiveNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get preventiveDate => $composableBuilder(
    column: $table.preventiveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wantedAccused => $composableBuilder(
    column: $table.wantedAccused,
    builder: (column) => ColumnOrderings(column),
  );

  $$CrimesTableOrderingComposer get crimeId {
    final $$CrimesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableOrderingComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvestigationTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvestigationTable> {
  $$InvestigationTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get officerName => $composableBuilder(
    column: $table.officerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get officerId =>
      $composableBuilder(column: $table.officerId, builder: (column) => column);

  GeneratedColumn<String> get officerMobile => $composableBuilder(
    column: $table.officerMobile,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filedBy =>
      $composableBuilder(column: $table.filedBy, builder: (column) => column);

  GeneratedColumn<String> get preventiveAction => $composableBuilder(
    column: $table.preventiveAction,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preventiveNo => $composableBuilder(
    column: $table.preventiveNo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get preventiveDate => $composableBuilder(
    column: $table.preventiveDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get wantedAccused => $composableBuilder(
    column: $table.wantedAccused,
    builder: (column) => column,
  );

  $$CrimesTableAnnotationComposer get crimeId {
    final $$CrimesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableAnnotationComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvestigationTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvestigationTable,
          InvestigationData,
          $$InvestigationTableFilterComposer,
          $$InvestigationTableOrderingComposer,
          $$InvestigationTableAnnotationComposer,
          $$InvestigationTableCreateCompanionBuilder,
          $$InvestigationTableUpdateCompanionBuilder,
          (InvestigationData, $$InvestigationTableReferences),
          InvestigationData,
          PrefetchHooks Function({bool crimeId})
        > {
  $$InvestigationTableTableManager(_$AppDatabase db, $InvestigationTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvestigationTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvestigationTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvestigationTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> crimeId = const Value.absent(),
                Value<String?> officerName = const Value.absent(),
                Value<String?> officerId = const Value.absent(),
                Value<String?> officerMobile = const Value.absent(),
                Value<String?> filedBy = const Value.absent(),
                Value<String?> preventiveAction = const Value.absent(),
                Value<String?> preventiveNo = const Value.absent(),
                Value<DateTime?> preventiveDate = const Value.absent(),
                Value<String?> wantedAccused = const Value.absent(),
              }) => InvestigationCompanion(
                id: id,
                crimeId: crimeId,
                officerName: officerName,
                officerId: officerId,
                officerMobile: officerMobile,
                filedBy: filedBy,
                preventiveAction: preventiveAction,
                preventiveNo: preventiveNo,
                preventiveDate: preventiveDate,
                wantedAccused: wantedAccused,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int crimeId,
                Value<String?> officerName = const Value.absent(),
                Value<String?> officerId = const Value.absent(),
                Value<String?> officerMobile = const Value.absent(),
                Value<String?> filedBy = const Value.absent(),
                Value<String?> preventiveAction = const Value.absent(),
                Value<String?> preventiveNo = const Value.absent(),
                Value<DateTime?> preventiveDate = const Value.absent(),
                Value<String?> wantedAccused = const Value.absent(),
              }) => InvestigationCompanion.insert(
                id: id,
                crimeId: crimeId,
                officerName: officerName,
                officerId: officerId,
                officerMobile: officerMobile,
                filedBy: filedBy,
                preventiveAction: preventiveAction,
                preventiveNo: preventiveNo,
                preventiveDate: preventiveDate,
                wantedAccused: wantedAccused,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvestigationTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({crimeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (crimeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.crimeId,
                                referencedTable: $$InvestigationTableReferences
                                    ._crimeIdTable(db),
                                referencedColumn: $$InvestigationTableReferences
                                    ._crimeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InvestigationTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvestigationTable,
      InvestigationData,
      $$InvestigationTableFilterComposer,
      $$InvestigationTableOrderingComposer,
      $$InvestigationTableAnnotationComposer,
      $$InvestigationTableCreateCompanionBuilder,
      $$InvestigationTableUpdateCompanionBuilder,
      (InvestigationData, $$InvestigationTableReferences),
      InvestigationData,
      PrefetchHooks Function({bool crimeId})
    >;
typedef $$VerdictTableCreateCompanionBuilder =
    VerdictCompanion Function({
      Value<int> id,
      required int crimeId,
      Value<String?> chargesheetNo,
      Value<DateTime?> chargesheetDate,
      Value<String?> rccNo,
      Value<String?> finalOrder,
      Value<bool?> foundGuilty,
      Value<String?> punishment,
    });
typedef $$VerdictTableUpdateCompanionBuilder =
    VerdictCompanion Function({
      Value<int> id,
      Value<int> crimeId,
      Value<String?> chargesheetNo,
      Value<DateTime?> chargesheetDate,
      Value<String?> rccNo,
      Value<String?> finalOrder,
      Value<bool?> foundGuilty,
      Value<String?> punishment,
    });

final class $$VerdictTableReferences
    extends BaseReferences<_$AppDatabase, $VerdictTable, VerdictData> {
  $$VerdictTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CrimesTable _crimeIdTable(_$AppDatabase db) =>
      db.crimes.createAlias('verdict__crime_id__crimes__id');

  $$CrimesTableProcessedTableManager get crimeId {
    final $_column = $_itemColumn<int>('crime_id')!;

    final manager = $$CrimesTableTableManager(
      $_db,
      $_db.crimes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_crimeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VerdictTableFilterComposer
    extends Composer<_$AppDatabase, $VerdictTable> {
  $$VerdictTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chargesheetNo => $composableBuilder(
    column: $table.chargesheetNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get chargesheetDate => $composableBuilder(
    column: $table.chargesheetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rccNo => $composableBuilder(
    column: $table.rccNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get finalOrder => $composableBuilder(
    column: $table.finalOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get foundGuilty => $composableBuilder(
    column: $table.foundGuilty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get punishment => $composableBuilder(
    column: $table.punishment,
    builder: (column) => ColumnFilters(column),
  );

  $$CrimesTableFilterComposer get crimeId {
    final $$CrimesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableFilterComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VerdictTableOrderingComposer
    extends Composer<_$AppDatabase, $VerdictTable> {
  $$VerdictTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chargesheetNo => $composableBuilder(
    column: $table.chargesheetNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get chargesheetDate => $composableBuilder(
    column: $table.chargesheetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rccNo => $composableBuilder(
    column: $table.rccNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finalOrder => $composableBuilder(
    column: $table.finalOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get foundGuilty => $composableBuilder(
    column: $table.foundGuilty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get punishment => $composableBuilder(
    column: $table.punishment,
    builder: (column) => ColumnOrderings(column),
  );

  $$CrimesTableOrderingComposer get crimeId {
    final $$CrimesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableOrderingComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VerdictTableAnnotationComposer
    extends Composer<_$AppDatabase, $VerdictTable> {
  $$VerdictTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get chargesheetNo => $composableBuilder(
    column: $table.chargesheetNo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get chargesheetDate => $composableBuilder(
    column: $table.chargesheetDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rccNo =>
      $composableBuilder(column: $table.rccNo, builder: (column) => column);

  GeneratedColumn<String> get finalOrder => $composableBuilder(
    column: $table.finalOrder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get foundGuilty => $composableBuilder(
    column: $table.foundGuilty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get punishment => $composableBuilder(
    column: $table.punishment,
    builder: (column) => column,
  );

  $$CrimesTableAnnotationComposer get crimeId {
    final $$CrimesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableAnnotationComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VerdictTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VerdictTable,
          VerdictData,
          $$VerdictTableFilterComposer,
          $$VerdictTableOrderingComposer,
          $$VerdictTableAnnotationComposer,
          $$VerdictTableCreateCompanionBuilder,
          $$VerdictTableUpdateCompanionBuilder,
          (VerdictData, $$VerdictTableReferences),
          VerdictData,
          PrefetchHooks Function({bool crimeId})
        > {
  $$VerdictTableTableManager(_$AppDatabase db, $VerdictTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VerdictTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VerdictTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VerdictTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> crimeId = const Value.absent(),
                Value<String?> chargesheetNo = const Value.absent(),
                Value<DateTime?> chargesheetDate = const Value.absent(),
                Value<String?> rccNo = const Value.absent(),
                Value<String?> finalOrder = const Value.absent(),
                Value<bool?> foundGuilty = const Value.absent(),
                Value<String?> punishment = const Value.absent(),
              }) => VerdictCompanion(
                id: id,
                crimeId: crimeId,
                chargesheetNo: chargesheetNo,
                chargesheetDate: chargesheetDate,
                rccNo: rccNo,
                finalOrder: finalOrder,
                foundGuilty: foundGuilty,
                punishment: punishment,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int crimeId,
                Value<String?> chargesheetNo = const Value.absent(),
                Value<DateTime?> chargesheetDate = const Value.absent(),
                Value<String?> rccNo = const Value.absent(),
                Value<String?> finalOrder = const Value.absent(),
                Value<bool?> foundGuilty = const Value.absent(),
                Value<String?> punishment = const Value.absent(),
              }) => VerdictCompanion.insert(
                id: id,
                crimeId: crimeId,
                chargesheetNo: chargesheetNo,
                chargesheetDate: chargesheetDate,
                rccNo: rccNo,
                finalOrder: finalOrder,
                foundGuilty: foundGuilty,
                punishment: punishment,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VerdictTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({crimeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (crimeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.crimeId,
                                referencedTable: $$VerdictTableReferences
                                    ._crimeIdTable(db),
                                referencedColumn: $$VerdictTableReferences
                                    ._crimeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VerdictTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VerdictTable,
      VerdictData,
      $$VerdictTableFilterComposer,
      $$VerdictTableOrderingComposer,
      $$VerdictTableAnnotationComposer,
      $$VerdictTableCreateCompanionBuilder,
      $$VerdictTableUpdateCompanionBuilder,
      (VerdictData, $$VerdictTableReferences),
      VerdictData,
      PrefetchHooks Function({bool crimeId})
    >;
typedef $$AttachmentsTableCreateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<int> id,
      required int crimeId,
      required String filePath,
      Value<String?> fileType,
      Value<String?> description,
      Value<DateTime> uploadedAt,
    });
typedef $$AttachmentsTableUpdateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<int> id,
      Value<int> crimeId,
      Value<String> filePath,
      Value<String?> fileType,
      Value<String?> description,
      Value<DateTime> uploadedAt,
    });

final class $$AttachmentsTableReferences
    extends BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment> {
  $$AttachmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CrimesTable _crimeIdTable(_$AppDatabase db) =>
      db.crimes.createAlias('attachments__crime_id__crimes__id');

  $$CrimesTableProcessedTableManager get crimeId {
    final $_column = $_itemColumn<int>('crime_id')!;

    final manager = $$CrimesTableTableManager(
      $_db,
      $_db.crimes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_crimeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CrimesTableFilterComposer get crimeId {
    final $$CrimesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableFilterComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CrimesTableOrderingComposer get crimeId {
    final $$CrimesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableOrderingComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );

  $$CrimesTableAnnotationComposer get crimeId {
    final $$CrimesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableAnnotationComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttachmentsTable,
          Attachment,
          $$AttachmentsTableFilterComposer,
          $$AttachmentsTableOrderingComposer,
          $$AttachmentsTableAnnotationComposer,
          $$AttachmentsTableCreateCompanionBuilder,
          $$AttachmentsTableUpdateCompanionBuilder,
          (Attachment, $$AttachmentsTableReferences),
          Attachment,
          PrefetchHooks Function({bool crimeId})
        > {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> crimeId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String?> fileType = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> uploadedAt = const Value.absent(),
              }) => AttachmentsCompanion(
                id: id,
                crimeId: crimeId,
                filePath: filePath,
                fileType: fileType,
                description: description,
                uploadedAt: uploadedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int crimeId,
                required String filePath,
                Value<String?> fileType = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> uploadedAt = const Value.absent(),
              }) => AttachmentsCompanion.insert(
                id: id,
                crimeId: crimeId,
                filePath: filePath,
                fileType: fileType,
                description: description,
                uploadedAt: uploadedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AttachmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({crimeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (crimeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.crimeId,
                                referencedTable: $$AttachmentsTableReferences
                                    ._crimeIdTable(db),
                                referencedColumn: $$AttachmentsTableReferences
                                    ._crimeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttachmentsTable,
      Attachment,
      $$AttachmentsTableFilterComposer,
      $$AttachmentsTableOrderingComposer,
      $$AttachmentsTableAnnotationComposer,
      $$AttachmentsTableCreateCompanionBuilder,
      $$AttachmentsTableUpdateCompanionBuilder,
      (Attachment, $$AttachmentsTableReferences),
      Attachment,
      PrefetchHooks Function({bool crimeId})
    >;
typedef $$CustomFieldsTableCreateCompanionBuilder =
    CustomFieldsCompanion Function({
      Value<int> id,
      required String fieldNameMarathi,
      required String fieldNameEnglish,
      required String fieldType,
      required String section,
      Value<bool> isRequired,
      Value<String?> dropdownOptionsJson,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
    });
typedef $$CustomFieldsTableUpdateCompanionBuilder =
    CustomFieldsCompanion Function({
      Value<int> id,
      Value<String> fieldNameMarathi,
      Value<String> fieldNameEnglish,
      Value<String> fieldType,
      Value<String> section,
      Value<bool> isRequired,
      Value<String?> dropdownOptionsJson,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
    });

final class $$CustomFieldsTableReferences
    extends BaseReferences<_$AppDatabase, $CustomFieldsTable, CustomField> {
  $$CustomFieldsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CustomFieldValuesTable, List<CustomFieldValue>>
  _customFieldValuesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.customFieldValues,
        aliasName: 'custom_fields__id__custom_field_values__custom_field_id',
      );

  $$CustomFieldValuesTableProcessedTableManager get customFieldValuesRefs {
    final manager = $$CustomFieldValuesTableTableManager(
      $_db,
      $_db.customFieldValues,
    ).filter((f) => f.customFieldId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _customFieldValuesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomFieldsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomFieldsTable> {
  $$CustomFieldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldNameMarathi => $composableBuilder(
    column: $table.fieldNameMarathi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldNameEnglish => $composableBuilder(
    column: $table.fieldNameEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldType => $composableBuilder(
    column: $table.fieldType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dropdownOptionsJson => $composableBuilder(
    column: $table.dropdownOptionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> customFieldValuesRefs(
    Expression<bool> Function($$CustomFieldValuesTableFilterComposer f) f,
  ) {
    final $$CustomFieldValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customFieldValues,
      getReferencedColumn: (t) => t.customFieldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomFieldValuesTableFilterComposer(
            $db: $db,
            $table: $db.customFieldValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomFieldsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomFieldsTable> {
  $$CustomFieldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldNameMarathi => $composableBuilder(
    column: $table.fieldNameMarathi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldNameEnglish => $composableBuilder(
    column: $table.fieldNameEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldType => $composableBuilder(
    column: $table.fieldType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dropdownOptionsJson => $composableBuilder(
    column: $table.dropdownOptionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomFieldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomFieldsTable> {
  $$CustomFieldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fieldNameMarathi => $composableBuilder(
    column: $table.fieldNameMarathi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldNameEnglish => $composableBuilder(
    column: $table.fieldNameEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldType =>
      $composableBuilder(column: $table.fieldType, builder: (column) => column);

  GeneratedColumn<String> get section =>
      $composableBuilder(column: $table.section, builder: (column) => column);

  GeneratedColumn<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dropdownOptionsJson => $composableBuilder(
    column: $table.dropdownOptionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> customFieldValuesRefs<T extends Object>(
    Expression<T> Function($$CustomFieldValuesTableAnnotationComposer a) f,
  ) {
    final $$CustomFieldValuesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.customFieldValues,
          getReferencedColumn: (t) => t.customFieldId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CustomFieldValuesTableAnnotationComposer(
                $db: $db,
                $table: $db.customFieldValues,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CustomFieldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomFieldsTable,
          CustomField,
          $$CustomFieldsTableFilterComposer,
          $$CustomFieldsTableOrderingComposer,
          $$CustomFieldsTableAnnotationComposer,
          $$CustomFieldsTableCreateCompanionBuilder,
          $$CustomFieldsTableUpdateCompanionBuilder,
          (CustomField, $$CustomFieldsTableReferences),
          CustomField,
          PrefetchHooks Function({bool customFieldValuesRefs})
        > {
  $$CustomFieldsTableTableManager(_$AppDatabase db, $CustomFieldsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomFieldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomFieldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomFieldsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fieldNameMarathi = const Value.absent(),
                Value<String> fieldNameEnglish = const Value.absent(),
                Value<String> fieldType = const Value.absent(),
                Value<String> section = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<String?> dropdownOptionsJson = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomFieldsCompanion(
                id: id,
                fieldNameMarathi: fieldNameMarathi,
                fieldNameEnglish: fieldNameEnglish,
                fieldType: fieldType,
                section: section,
                isRequired: isRequired,
                dropdownOptionsJson: dropdownOptionsJson,
                displayOrder: displayOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fieldNameMarathi,
                required String fieldNameEnglish,
                required String fieldType,
                required String section,
                Value<bool> isRequired = const Value.absent(),
                Value<String?> dropdownOptionsJson = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomFieldsCompanion.insert(
                id: id,
                fieldNameMarathi: fieldNameMarathi,
                fieldNameEnglish: fieldNameEnglish,
                fieldType: fieldType,
                section: section,
                isRequired: isRequired,
                dropdownOptionsJson: dropdownOptionsJson,
                displayOrder: displayOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomFieldsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({customFieldValuesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (customFieldValuesRefs) db.customFieldValues,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (customFieldValuesRefs)
                    await $_getPrefetchedData<
                      CustomField,
                      $CustomFieldsTable,
                      CustomFieldValue
                    >(
                      currentTable: table,
                      referencedTable: $$CustomFieldsTableReferences
                          ._customFieldValuesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomFieldsTableReferences(
                            db,
                            table,
                            p0,
                          ).customFieldValuesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.customFieldId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomFieldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomFieldsTable,
      CustomField,
      $$CustomFieldsTableFilterComposer,
      $$CustomFieldsTableOrderingComposer,
      $$CustomFieldsTableAnnotationComposer,
      $$CustomFieldsTableCreateCompanionBuilder,
      $$CustomFieldsTableUpdateCompanionBuilder,
      (CustomField, $$CustomFieldsTableReferences),
      CustomField,
      PrefetchHooks Function({bool customFieldValuesRefs})
    >;
typedef $$CustomFieldValuesTableCreateCompanionBuilder =
    CustomFieldValuesCompanion Function({
      Value<int> id,
      required int crimeId,
      required int customFieldId,
      Value<String?> value,
    });
typedef $$CustomFieldValuesTableUpdateCompanionBuilder =
    CustomFieldValuesCompanion Function({
      Value<int> id,
      Value<int> crimeId,
      Value<int> customFieldId,
      Value<String?> value,
    });

final class $$CustomFieldValuesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CustomFieldValuesTable,
          CustomFieldValue
        > {
  $$CustomFieldValuesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CrimesTable _crimeIdTable(_$AppDatabase db) =>
      db.crimes.createAlias('custom_field_values__crime_id__crimes__id');

  $$CrimesTableProcessedTableManager get crimeId {
    final $_column = $_itemColumn<int>('crime_id')!;

    final manager = $$CrimesTableTableManager(
      $_db,
      $_db.crimes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_crimeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CustomFieldsTable _customFieldIdTable(_$AppDatabase db) => db
      .customFields
      .createAlias('custom_field_values__custom_field_id__custom_fields__id');

  $$CustomFieldsTableProcessedTableManager get customFieldId {
    final $_column = $_itemColumn<int>('custom_field_id')!;

    final manager = $$CustomFieldsTableTableManager(
      $_db,
      $_db.customFields,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customFieldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CustomFieldValuesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomFieldValuesTable> {
  $$CustomFieldValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  $$CrimesTableFilterComposer get crimeId {
    final $$CrimesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableFilterComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomFieldsTableFilterComposer get customFieldId {
    final $$CustomFieldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customFieldId,
      referencedTable: $db.customFields,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomFieldsTableFilterComposer(
            $db: $db,
            $table: $db.customFields,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomFieldValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomFieldValuesTable> {
  $$CustomFieldValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  $$CrimesTableOrderingComposer get crimeId {
    final $$CrimesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableOrderingComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomFieldsTableOrderingComposer get customFieldId {
    final $$CustomFieldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customFieldId,
      referencedTable: $db.customFields,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomFieldsTableOrderingComposer(
            $db: $db,
            $table: $db.customFields,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomFieldValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomFieldValuesTable> {
  $$CustomFieldValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$CrimesTableAnnotationComposer get crimeId {
    final $$CrimesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.crimeId,
      referencedTable: $db.crimes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CrimesTableAnnotationComposer(
            $db: $db,
            $table: $db.crimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomFieldsTableAnnotationComposer get customFieldId {
    final $$CustomFieldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customFieldId,
      referencedTable: $db.customFields,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomFieldsTableAnnotationComposer(
            $db: $db,
            $table: $db.customFields,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomFieldValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomFieldValuesTable,
          CustomFieldValue,
          $$CustomFieldValuesTableFilterComposer,
          $$CustomFieldValuesTableOrderingComposer,
          $$CustomFieldValuesTableAnnotationComposer,
          $$CustomFieldValuesTableCreateCompanionBuilder,
          $$CustomFieldValuesTableUpdateCompanionBuilder,
          (CustomFieldValue, $$CustomFieldValuesTableReferences),
          CustomFieldValue,
          PrefetchHooks Function({bool crimeId, bool customFieldId})
        > {
  $$CustomFieldValuesTableTableManager(
    _$AppDatabase db,
    $CustomFieldValuesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomFieldValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomFieldValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomFieldValuesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> crimeId = const Value.absent(),
                Value<int> customFieldId = const Value.absent(),
                Value<String?> value = const Value.absent(),
              }) => CustomFieldValuesCompanion(
                id: id,
                crimeId: crimeId,
                customFieldId: customFieldId,
                value: value,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int crimeId,
                required int customFieldId,
                Value<String?> value = const Value.absent(),
              }) => CustomFieldValuesCompanion.insert(
                id: id,
                crimeId: crimeId,
                customFieldId: customFieldId,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomFieldValuesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({crimeId = false, customFieldId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (crimeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.crimeId,
                                referencedTable:
                                    $$CustomFieldValuesTableReferences
                                        ._crimeIdTable(db),
                                referencedColumn:
                                    $$CustomFieldValuesTableReferences
                                        ._crimeIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (customFieldId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.customFieldId,
                                referencedTable:
                                    $$CustomFieldValuesTableReferences
                                        ._customFieldIdTable(db),
                                referencedColumn:
                                    $$CustomFieldValuesTableReferences
                                        ._customFieldIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CustomFieldValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomFieldValuesTable,
      CustomFieldValue,
      $$CustomFieldValuesTableFilterComposer,
      $$CustomFieldValuesTableOrderingComposer,
      $$CustomFieldValuesTableAnnotationComposer,
      $$CustomFieldValuesTableCreateCompanionBuilder,
      $$CustomFieldValuesTableUpdateCompanionBuilder,
      (CustomFieldValue, $$CustomFieldValuesTableReferences),
      CustomFieldValue,
      PrefetchHooks Function({bool crimeId, bool customFieldId})
    >;
typedef $$StationsTableCreateCompanionBuilder =
    StationsCompanion Function({
      Value<int> id,
      required String nameMarathi,
      required String nameEnglish,
      Value<String?> code,
      Value<String?> district,
      Value<String?> address,
    });
typedef $$StationsTableUpdateCompanionBuilder =
    StationsCompanion Function({
      Value<int> id,
      Value<String> nameMarathi,
      Value<String> nameEnglish,
      Value<String?> code,
      Value<String?> district,
      Value<String?> address,
    });

class $$StationsTableFilterComposer
    extends Composer<_$AppDatabase, $StationsTable> {
  $$StationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameMarathi => $composableBuilder(
    column: $table.nameMarathi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StationsTableOrderingComposer
    extends Composer<_$AppDatabase, $StationsTable> {
  $$StationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameMarathi => $composableBuilder(
    column: $table.nameMarathi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StationsTable> {
  $$StationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameMarathi => $composableBuilder(
    column: $table.nameMarathi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);
}

class $$StationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StationsTable,
          Station,
          $$StationsTableFilterComposer,
          $$StationsTableOrderingComposer,
          $$StationsTableAnnotationComposer,
          $$StationsTableCreateCompanionBuilder,
          $$StationsTableUpdateCompanionBuilder,
          (Station, BaseReferences<_$AppDatabase, $StationsTable, Station>),
          Station,
          PrefetchHooks Function()
        > {
  $$StationsTableTableManager(_$AppDatabase db, $StationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameMarathi = const Value.absent(),
                Value<String> nameEnglish = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String?> address = const Value.absent(),
              }) => StationsCompanion(
                id: id,
                nameMarathi: nameMarathi,
                nameEnglish: nameEnglish,
                code: code,
                district: district,
                address: address,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameMarathi,
                required String nameEnglish,
                Value<String?> code = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String?> address = const Value.absent(),
              }) => StationsCompanion.insert(
                id: id,
                nameMarathi: nameMarathi,
                nameEnglish: nameEnglish,
                code: code,
                district: district,
                address: address,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StationsTable,
      Station,
      $$StationsTableFilterComposer,
      $$StationsTableOrderingComposer,
      $$StationsTableAnnotationComposer,
      $$StationsTableCreateCompanionBuilder,
      $$StationsTableUpdateCompanionBuilder,
      (Station, BaseReferences<_$AppDatabase, $StationsTable, Station>),
      Station,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String email,
      Value<String?> fullName,
      Value<String> role,
      Value<int?> stationId,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> email,
      Value<String?> fullName,
      Value<String> role,
      Value<int?> stationId,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stationId => $composableBuilder(
    column: $table.stationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stationId => $composableBuilder(
    column: $table.stationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get stationId =>
      $composableBuilder(column: $table.stationId, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> fullName = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int?> stationId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                email: email,
                fullName: fullName,
                role: role,
                stationId: stationId,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String email,
                Value<String?> fullName = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int?> stationId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                email: email,
                fullName: fullName,
                role: role,
                stationId: stationId,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$ReportTemplatesTableCreateCompanionBuilder =
    ReportTemplatesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      required String templateJson,
      Value<String> outputFormat,
      Value<bool> isSystem,
      Value<String?> createdBy,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ReportTemplatesTableUpdateCompanionBuilder =
    ReportTemplatesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<String> templateJson,
      Value<String> outputFormat,
      Value<bool> isSystem,
      Value<String?> createdBy,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ReportTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $ReportTemplatesTable> {
  $$ReportTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateJson => $composableBuilder(
    column: $table.templateJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outputFormat => $composableBuilder(
    column: $table.outputFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReportTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportTemplatesTable> {
  $$ReportTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateJson => $composableBuilder(
    column: $table.templateJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outputFormat => $composableBuilder(
    column: $table.outputFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReportTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportTemplatesTable> {
  $$ReportTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get templateJson => $composableBuilder(
    column: $table.templateJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outputFormat => $composableBuilder(
    column: $table.outputFormat,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReportTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportTemplatesTable,
          ReportTemplateRow,
          $$ReportTemplatesTableFilterComposer,
          $$ReportTemplatesTableOrderingComposer,
          $$ReportTemplatesTableAnnotationComposer,
          $$ReportTemplatesTableCreateCompanionBuilder,
          $$ReportTemplatesTableUpdateCompanionBuilder,
          (
            ReportTemplateRow,
            BaseReferences<
              _$AppDatabase,
              $ReportTemplatesTable,
              ReportTemplateRow
            >,
          ),
          ReportTemplateRow,
          PrefetchHooks Function()
        > {
  $$ReportTemplatesTableTableManager(
    _$AppDatabase db,
    $ReportTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> templateJson = const Value.absent(),
                Value<String> outputFormat = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ReportTemplatesCompanion(
                id: id,
                name: name,
                description: description,
                templateJson: templateJson,
                outputFormat: outputFormat,
                isSystem: isSystem,
                createdBy: createdBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                required String templateJson,
                Value<String> outputFormat = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ReportTemplatesCompanion.insert(
                id: id,
                name: name,
                description: description,
                templateJson: templateJson,
                outputFormat: outputFormat,
                isSystem: isSystem,
                createdBy: createdBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReportTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportTemplatesTable,
      ReportTemplateRow,
      $$ReportTemplatesTableFilterComposer,
      $$ReportTemplatesTableOrderingComposer,
      $$ReportTemplatesTableAnnotationComposer,
      $$ReportTemplatesTableCreateCompanionBuilder,
      $$ReportTemplatesTableUpdateCompanionBuilder,
      (
        ReportTemplateRow,
        BaseReferences<_$AppDatabase, $ReportTemplatesTable, ReportTemplateRow>,
      ),
      ReportTemplateRow,
      PrefetchHooks Function()
    >;
typedef $$AuditLogTableCreateCompanionBuilder =
    AuditLogCompanion Function({
      Value<int> id,
      Value<int?> userId,
      required String action,
      Value<String?> entityType,
      Value<int?> entityId,
      Value<String?> changesJson,
      Value<DateTime> timestamp,
    });
typedef $$AuditLogTableUpdateCompanionBuilder =
    AuditLogCompanion Function({
      Value<int> id,
      Value<int?> userId,
      Value<String> action,
      Value<String?> entityType,
      Value<int?> entityId,
      Value<String?> changesJson,
      Value<DateTime> timestamp,
    });

class $$AuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changesJson => $composableBuilder(
    column: $table.changesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changesJson => $composableBuilder(
    column: $table.changesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get changesJson => $composableBuilder(
    column: $table.changesJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$AuditLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogTable,
          AuditLogData,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (
            AuditLogData,
            BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>,
          ),
          AuditLogData,
          PrefetchHooks Function()
        > {
  $$AuditLogTableTableManager(_$AppDatabase db, $AuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String?> entityType = const Value.absent(),
                Value<int?> entityId = const Value.absent(),
                Value<String?> changesJson = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => AuditLogCompanion(
                id: id,
                userId: userId,
                action: action,
                entityType: entityType,
                entityId: entityId,
                changesJson: changesJson,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                required String action,
                Value<String?> entityType = const Value.absent(),
                Value<int?> entityId = const Value.absent(),
                Value<String?> changesJson = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => AuditLogCompanion.insert(
                id: id,
                userId: userId,
                action: action,
                entityType: entityType,
                entityId: entityId,
                changesJson: changesJson,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogTable,
      AuditLogData,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (
        AuditLogData,
        BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>,
      ),
      AuditLogData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CrimesTableTableManager get crimes =>
      $$CrimesTableTableManager(_db, _db.crimes);
  $$ComplainantsTableTableManager get complainants =>
      $$ComplainantsTableTableManager(_db, _db.complainants);
  $$AccusedTableTableManager get accused =>
      $$AccusedTableTableManager(_db, _db.accused);
  $$StolenPropertyTableTableManager get stolenProperty =>
      $$StolenPropertyTableTableManager(_db, _db.stolenProperty);
  $$RecoveredPropertyTableTableManager get recoveredProperty =>
      $$RecoveredPropertyTableTableManager(_db, _db.recoveredProperty);
  $$InvestigationTableTableManager get investigation =>
      $$InvestigationTableTableManager(_db, _db.investigation);
  $$VerdictTableTableManager get verdict =>
      $$VerdictTableTableManager(_db, _db.verdict);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db, _db.attachments);
  $$CustomFieldsTableTableManager get customFields =>
      $$CustomFieldsTableTableManager(_db, _db.customFields);
  $$CustomFieldValuesTableTableManager get customFieldValues =>
      $$CustomFieldValuesTableTableManager(_db, _db.customFieldValues);
  $$StationsTableTableManager get stations =>
      $$StationsTableTableManager(_db, _db.stations);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ReportTemplatesTableTableManager get reportTemplates =>
      $$ReportTemplatesTableTableManager(_db, _db.reportTemplates);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
}
