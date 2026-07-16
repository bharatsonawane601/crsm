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
  static const VerificationMeta _dateOccurredToMeta = const VerificationMeta(
    'dateOccurredTo',
  );
  @override
  late final GeneratedColumn<DateTime> dateOccurredTo =
      GeneratedColumn<DateTime>(
        'date_occurred_to',
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
  static const VerificationMeta _timeOccurredToMeta = const VerificationMeta(
    'timeOccurredTo',
  );
  @override
  late final GeneratedColumn<String> timeOccurredTo = GeneratedColumn<String>(
    'time_occurred_to',
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
  static const VerificationMeta _remoteUidMeta = const VerificationMeta(
    'remoteUid',
  );
  @override
  late final GeneratedColumn<String> remoteUid = GeneratedColumn<String>(
    'remote_uid',
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
    defaultValue: const Constant('undetected'),
  );
  static const VerificationMeta _courtTypeMeta = const VerificationMeta(
    'courtType',
  );
  @override
  late final GeneratedColumn<String> courtType = GeneratedColumn<String>(
    'court_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caseStageMeta = const VerificationMeta(
    'caseStage',
  );
  @override
  late final GeneratedColumn<String> caseStage = GeneratedColumn<String>(
    'case_stage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('investigation'),
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
  static const VerificationMeta _firDateMeta = const VerificationMeta(
    'firDate',
  );
  @override
  late final GeneratedColumn<DateTime> firDate = GeneratedColumn<DateTime>(
    'fir_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firTimeMeta = const VerificationMeta(
    'firTime',
  );
  @override
  late final GeneratedColumn<String> firTime = GeneratedColumn<String>(
    'fir_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _infoReceivedDateMeta = const VerificationMeta(
    'infoReceivedDate',
  );
  @override
  late final GeneratedColumn<DateTime> infoReceivedDate =
      GeneratedColumn<DateTime>(
        'info_received_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _infoReceivedTimeMeta = const VerificationMeta(
    'infoReceivedTime',
  );
  @override
  late final GeneratedColumn<String> infoReceivedTime = GeneratedColumn<String>(
    'info_received_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gdDateMeta = const VerificationMeta('gdDate');
  @override
  late final GeneratedColumn<DateTime> gdDate = GeneratedColumn<DateTime>(
    'gd_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gdTimeMeta = const VerificationMeta('gdTime');
  @override
  late final GeneratedColumn<String> gdTime = GeneratedColumn<String>(
    'gd_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gdEntryNoMeta = const VerificationMeta(
    'gdEntryNo',
  );
  @override
  late final GeneratedColumn<String> gdEntryNo = GeneratedColumn<String>(
    'gd_entry_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurrenceDayMeta = const VerificationMeta(
    'occurrenceDay',
  );
  @override
  late final GeneratedColumn<String> occurrenceDay = GeneratedColumn<String>(
    'occurrence_day',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeOfInformationMeta = const VerificationMeta(
    'typeOfInformation',
  );
  @override
  late final GeneratedColumn<String> typeOfInformation =
      GeneratedColumn<String>(
        'type_of_information',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _beatNoMeta = const VerificationMeta('beatNo');
  @override
  late final GeneratedColumn<String> beatNo = GeneratedColumn<String>(
    'beat_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _directionDistanceMeta = const VerificationMeta(
    'directionDistance',
  );
  @override
  late final GeneratedColumn<String> directionDistance =
      GeneratedColumn<String>(
        'direction_distance',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _outsidePsNameMeta = const VerificationMeta(
    'outsidePsName',
  );
  @override
  late final GeneratedColumn<String> outsidePsName = GeneratedColumn<String>(
    'outside_ps_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outsidePsDistrictMeta = const VerificationMeta(
    'outsidePsDistrict',
  );
  @override
  late final GeneratedColumn<String> outsidePsDistrict =
      GeneratedColumn<String>(
        'outside_ps_district',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _delayReasonMeta = const VerificationMeta(
    'delayReason',
  );
  @override
  late final GeneratedColumn<String> delayReason = GeneratedColumn<String>(
    'delay_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inquestUdNoMeta = const VerificationMeta(
    'inquestUdNo',
  );
  @override
  late final GeneratedColumn<String> inquestUdNo = GeneratedColumn<String>(
    'inquest_ud_no',
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
    dateOccurredTo,
    timeOccurred,
    timeOccurredTo,
    placeOccurred,
    dateRegistered,
    timeRegistered,
    crimeType,
    remoteUid,
    status,
    courtType,
    caseStage,
    detailedDescription,
    firDate,
    firTime,
    infoReceivedDate,
    infoReceivedTime,
    gdDate,
    gdTime,
    gdEntryNo,
    occurrenceDay,
    typeOfInformation,
    beatNo,
    directionDistance,
    outsidePsName,
    outsidePsDistrict,
    delayReason,
    inquestUdNo,
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
    if (data.containsKey('date_occurred_to')) {
      context.handle(
        _dateOccurredToMeta,
        dateOccurredTo.isAcceptableOrUnknown(
          data['date_occurred_to']!,
          _dateOccurredToMeta,
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
    if (data.containsKey('time_occurred_to')) {
      context.handle(
        _timeOccurredToMeta,
        timeOccurredTo.isAcceptableOrUnknown(
          data['time_occurred_to']!,
          _timeOccurredToMeta,
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
    if (data.containsKey('remote_uid')) {
      context.handle(
        _remoteUidMeta,
        remoteUid.isAcceptableOrUnknown(data['remote_uid']!, _remoteUidMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('court_type')) {
      context.handle(
        _courtTypeMeta,
        courtType.isAcceptableOrUnknown(data['court_type']!, _courtTypeMeta),
      );
    }
    if (data.containsKey('case_stage')) {
      context.handle(
        _caseStageMeta,
        caseStage.isAcceptableOrUnknown(data['case_stage']!, _caseStageMeta),
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
    if (data.containsKey('fir_date')) {
      context.handle(
        _firDateMeta,
        firDate.isAcceptableOrUnknown(data['fir_date']!, _firDateMeta),
      );
    }
    if (data.containsKey('fir_time')) {
      context.handle(
        _firTimeMeta,
        firTime.isAcceptableOrUnknown(data['fir_time']!, _firTimeMeta),
      );
    }
    if (data.containsKey('info_received_date')) {
      context.handle(
        _infoReceivedDateMeta,
        infoReceivedDate.isAcceptableOrUnknown(
          data['info_received_date']!,
          _infoReceivedDateMeta,
        ),
      );
    }
    if (data.containsKey('info_received_time')) {
      context.handle(
        _infoReceivedTimeMeta,
        infoReceivedTime.isAcceptableOrUnknown(
          data['info_received_time']!,
          _infoReceivedTimeMeta,
        ),
      );
    }
    if (data.containsKey('gd_date')) {
      context.handle(
        _gdDateMeta,
        gdDate.isAcceptableOrUnknown(data['gd_date']!, _gdDateMeta),
      );
    }
    if (data.containsKey('gd_time')) {
      context.handle(
        _gdTimeMeta,
        gdTime.isAcceptableOrUnknown(data['gd_time']!, _gdTimeMeta),
      );
    }
    if (data.containsKey('gd_entry_no')) {
      context.handle(
        _gdEntryNoMeta,
        gdEntryNo.isAcceptableOrUnknown(data['gd_entry_no']!, _gdEntryNoMeta),
      );
    }
    if (data.containsKey('occurrence_day')) {
      context.handle(
        _occurrenceDayMeta,
        occurrenceDay.isAcceptableOrUnknown(
          data['occurrence_day']!,
          _occurrenceDayMeta,
        ),
      );
    }
    if (data.containsKey('type_of_information')) {
      context.handle(
        _typeOfInformationMeta,
        typeOfInformation.isAcceptableOrUnknown(
          data['type_of_information']!,
          _typeOfInformationMeta,
        ),
      );
    }
    if (data.containsKey('beat_no')) {
      context.handle(
        _beatNoMeta,
        beatNo.isAcceptableOrUnknown(data['beat_no']!, _beatNoMeta),
      );
    }
    if (data.containsKey('direction_distance')) {
      context.handle(
        _directionDistanceMeta,
        directionDistance.isAcceptableOrUnknown(
          data['direction_distance']!,
          _directionDistanceMeta,
        ),
      );
    }
    if (data.containsKey('outside_ps_name')) {
      context.handle(
        _outsidePsNameMeta,
        outsidePsName.isAcceptableOrUnknown(
          data['outside_ps_name']!,
          _outsidePsNameMeta,
        ),
      );
    }
    if (data.containsKey('outside_ps_district')) {
      context.handle(
        _outsidePsDistrictMeta,
        outsidePsDistrict.isAcceptableOrUnknown(
          data['outside_ps_district']!,
          _outsidePsDistrictMeta,
        ),
      );
    }
    if (data.containsKey('delay_reason')) {
      context.handle(
        _delayReasonMeta,
        delayReason.isAcceptableOrUnknown(
          data['delay_reason']!,
          _delayReasonMeta,
        ),
      );
    }
    if (data.containsKey('inquest_ud_no')) {
      context.handle(
        _inquestUdNoMeta,
        inquestUdNo.isAcceptableOrUnknown(
          data['inquest_ud_no']!,
          _inquestUdNoMeta,
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
      dateOccurredTo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_occurred_to'],
      ),
      timeOccurred: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_occurred'],
      ),
      timeOccurredTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_occurred_to'],
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
      remoteUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_uid'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      courtType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}court_type'],
      ),
      caseStage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}case_stage'],
      )!,
      detailedDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detailed_description'],
      ),
      firDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fir_date'],
      ),
      firTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fir_time'],
      ),
      infoReceivedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}info_received_date'],
      ),
      infoReceivedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}info_received_time'],
      ),
      gdDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}gd_date'],
      ),
      gdTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gd_time'],
      ),
      gdEntryNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gd_entry_no'],
      ),
      occurrenceDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occurrence_day'],
      ),
      typeOfInformation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_of_information'],
      ),
      beatNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}beat_no'],
      ),
      directionDistance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction_distance'],
      ),
      outsidePsName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outside_ps_name'],
      ),
      outsidePsDistrict: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outside_ps_district'],
      ),
      delayReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delay_reason'],
      ),
      inquestUdNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inquest_ud_no'],
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
  final DateTime? dateOccurredTo;
  final String? timeOccurred;
  final String? timeOccurredTo;
  final String? placeOccurred;
  final DateTime? dateRegistered;
  final String? timeRegistered;
  final String? crimeType;
  final String? remoteUid;
  final String status;
  final String? courtType;
  final String caseStage;
  final String? detailedDescription;
  final DateTime? firDate;
  final String? firTime;
  final DateTime? infoReceivedDate;
  final String? infoReceivedTime;
  final DateTime? gdDate;
  final String? gdTime;
  final String? gdEntryNo;
  final String? occurrenceDay;
  final String? typeOfInformation;
  final String? beatNo;
  final String? directionDistance;
  final String? outsidePsName;
  final String? outsidePsDistrict;
  final String? delayReason;
  final String? inquestUdNo;
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
    this.dateOccurredTo,
    this.timeOccurred,
    this.timeOccurredTo,
    this.placeOccurred,
    this.dateRegistered,
    this.timeRegistered,
    this.crimeType,
    this.remoteUid,
    required this.status,
    this.courtType,
    required this.caseStage,
    this.detailedDescription,
    this.firDate,
    this.firTime,
    this.infoReceivedDate,
    this.infoReceivedTime,
    this.gdDate,
    this.gdTime,
    this.gdEntryNo,
    this.occurrenceDay,
    this.typeOfInformation,
    this.beatNo,
    this.directionDistance,
    this.outsidePsName,
    this.outsidePsDistrict,
    this.delayReason,
    this.inquestUdNo,
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
    if (!nullToAbsent || dateOccurredTo != null) {
      map['date_occurred_to'] = Variable<DateTime>(dateOccurredTo);
    }
    if (!nullToAbsent || timeOccurred != null) {
      map['time_occurred'] = Variable<String>(timeOccurred);
    }
    if (!nullToAbsent || timeOccurredTo != null) {
      map['time_occurred_to'] = Variable<String>(timeOccurredTo);
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
    if (!nullToAbsent || remoteUid != null) {
      map['remote_uid'] = Variable<String>(remoteUid);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || courtType != null) {
      map['court_type'] = Variable<String>(courtType);
    }
    map['case_stage'] = Variable<String>(caseStage);
    if (!nullToAbsent || detailedDescription != null) {
      map['detailed_description'] = Variable<String>(detailedDescription);
    }
    if (!nullToAbsent || firDate != null) {
      map['fir_date'] = Variable<DateTime>(firDate);
    }
    if (!nullToAbsent || firTime != null) {
      map['fir_time'] = Variable<String>(firTime);
    }
    if (!nullToAbsent || infoReceivedDate != null) {
      map['info_received_date'] = Variable<DateTime>(infoReceivedDate);
    }
    if (!nullToAbsent || infoReceivedTime != null) {
      map['info_received_time'] = Variable<String>(infoReceivedTime);
    }
    if (!nullToAbsent || gdDate != null) {
      map['gd_date'] = Variable<DateTime>(gdDate);
    }
    if (!nullToAbsent || gdTime != null) {
      map['gd_time'] = Variable<String>(gdTime);
    }
    if (!nullToAbsent || gdEntryNo != null) {
      map['gd_entry_no'] = Variable<String>(gdEntryNo);
    }
    if (!nullToAbsent || occurrenceDay != null) {
      map['occurrence_day'] = Variable<String>(occurrenceDay);
    }
    if (!nullToAbsent || typeOfInformation != null) {
      map['type_of_information'] = Variable<String>(typeOfInformation);
    }
    if (!nullToAbsent || beatNo != null) {
      map['beat_no'] = Variable<String>(beatNo);
    }
    if (!nullToAbsent || directionDistance != null) {
      map['direction_distance'] = Variable<String>(directionDistance);
    }
    if (!nullToAbsent || outsidePsName != null) {
      map['outside_ps_name'] = Variable<String>(outsidePsName);
    }
    if (!nullToAbsent || outsidePsDistrict != null) {
      map['outside_ps_district'] = Variable<String>(outsidePsDistrict);
    }
    if (!nullToAbsent || delayReason != null) {
      map['delay_reason'] = Variable<String>(delayReason);
    }
    if (!nullToAbsent || inquestUdNo != null) {
      map['inquest_ud_no'] = Variable<String>(inquestUdNo);
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
      dateOccurredTo: dateOccurredTo == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOccurredTo),
      timeOccurred: timeOccurred == null && nullToAbsent
          ? const Value.absent()
          : Value(timeOccurred),
      timeOccurredTo: timeOccurredTo == null && nullToAbsent
          ? const Value.absent()
          : Value(timeOccurredTo),
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
      remoteUid: remoteUid == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUid),
      status: Value(status),
      courtType: courtType == null && nullToAbsent
          ? const Value.absent()
          : Value(courtType),
      caseStage: Value(caseStage),
      detailedDescription: detailedDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(detailedDescription),
      firDate: firDate == null && nullToAbsent
          ? const Value.absent()
          : Value(firDate),
      firTime: firTime == null && nullToAbsent
          ? const Value.absent()
          : Value(firTime),
      infoReceivedDate: infoReceivedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(infoReceivedDate),
      infoReceivedTime: infoReceivedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(infoReceivedTime),
      gdDate: gdDate == null && nullToAbsent
          ? const Value.absent()
          : Value(gdDate),
      gdTime: gdTime == null && nullToAbsent
          ? const Value.absent()
          : Value(gdTime),
      gdEntryNo: gdEntryNo == null && nullToAbsent
          ? const Value.absent()
          : Value(gdEntryNo),
      occurrenceDay: occurrenceDay == null && nullToAbsent
          ? const Value.absent()
          : Value(occurrenceDay),
      typeOfInformation: typeOfInformation == null && nullToAbsent
          ? const Value.absent()
          : Value(typeOfInformation),
      beatNo: beatNo == null && nullToAbsent
          ? const Value.absent()
          : Value(beatNo),
      directionDistance: directionDistance == null && nullToAbsent
          ? const Value.absent()
          : Value(directionDistance),
      outsidePsName: outsidePsName == null && nullToAbsent
          ? const Value.absent()
          : Value(outsidePsName),
      outsidePsDistrict: outsidePsDistrict == null && nullToAbsent
          ? const Value.absent()
          : Value(outsidePsDistrict),
      delayReason: delayReason == null && nullToAbsent
          ? const Value.absent()
          : Value(delayReason),
      inquestUdNo: inquestUdNo == null && nullToAbsent
          ? const Value.absent()
          : Value(inquestUdNo),
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
      dateOccurredTo: serializer.fromJson<DateTime?>(json['dateOccurredTo']),
      timeOccurred: serializer.fromJson<String?>(json['timeOccurred']),
      timeOccurredTo: serializer.fromJson<String?>(json['timeOccurredTo']),
      placeOccurred: serializer.fromJson<String?>(json['placeOccurred']),
      dateRegistered: serializer.fromJson<DateTime?>(json['dateRegistered']),
      timeRegistered: serializer.fromJson<String?>(json['timeRegistered']),
      crimeType: serializer.fromJson<String?>(json['crimeType']),
      remoteUid: serializer.fromJson<String?>(json['remoteUid']),
      status: serializer.fromJson<String>(json['status']),
      courtType: serializer.fromJson<String?>(json['courtType']),
      caseStage: serializer.fromJson<String>(json['caseStage']),
      detailedDescription: serializer.fromJson<String?>(
        json['detailedDescription'],
      ),
      firDate: serializer.fromJson<DateTime?>(json['firDate']),
      firTime: serializer.fromJson<String?>(json['firTime']),
      infoReceivedDate: serializer.fromJson<DateTime?>(
        json['infoReceivedDate'],
      ),
      infoReceivedTime: serializer.fromJson<String?>(json['infoReceivedTime']),
      gdDate: serializer.fromJson<DateTime?>(json['gdDate']),
      gdTime: serializer.fromJson<String?>(json['gdTime']),
      gdEntryNo: serializer.fromJson<String?>(json['gdEntryNo']),
      occurrenceDay: serializer.fromJson<String?>(json['occurrenceDay']),
      typeOfInformation: serializer.fromJson<String?>(
        json['typeOfInformation'],
      ),
      beatNo: serializer.fromJson<String?>(json['beatNo']),
      directionDistance: serializer.fromJson<String?>(
        json['directionDistance'],
      ),
      outsidePsName: serializer.fromJson<String?>(json['outsidePsName']),
      outsidePsDistrict: serializer.fromJson<String?>(
        json['outsidePsDistrict'],
      ),
      delayReason: serializer.fromJson<String?>(json['delayReason']),
      inquestUdNo: serializer.fromJson<String?>(json['inquestUdNo']),
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
      'dateOccurredTo': serializer.toJson<DateTime?>(dateOccurredTo),
      'timeOccurred': serializer.toJson<String?>(timeOccurred),
      'timeOccurredTo': serializer.toJson<String?>(timeOccurredTo),
      'placeOccurred': serializer.toJson<String?>(placeOccurred),
      'dateRegistered': serializer.toJson<DateTime?>(dateRegistered),
      'timeRegistered': serializer.toJson<String?>(timeRegistered),
      'crimeType': serializer.toJson<String?>(crimeType),
      'remoteUid': serializer.toJson<String?>(remoteUid),
      'status': serializer.toJson<String>(status),
      'courtType': serializer.toJson<String?>(courtType),
      'caseStage': serializer.toJson<String>(caseStage),
      'detailedDescription': serializer.toJson<String?>(detailedDescription),
      'firDate': serializer.toJson<DateTime?>(firDate),
      'firTime': serializer.toJson<String?>(firTime),
      'infoReceivedDate': serializer.toJson<DateTime?>(infoReceivedDate),
      'infoReceivedTime': serializer.toJson<String?>(infoReceivedTime),
      'gdDate': serializer.toJson<DateTime?>(gdDate),
      'gdTime': serializer.toJson<String?>(gdTime),
      'gdEntryNo': serializer.toJson<String?>(gdEntryNo),
      'occurrenceDay': serializer.toJson<String?>(occurrenceDay),
      'typeOfInformation': serializer.toJson<String?>(typeOfInformation),
      'beatNo': serializer.toJson<String?>(beatNo),
      'directionDistance': serializer.toJson<String?>(directionDistance),
      'outsidePsName': serializer.toJson<String?>(outsidePsName),
      'outsidePsDistrict': serializer.toJson<String?>(outsidePsDistrict),
      'delayReason': serializer.toJson<String?>(delayReason),
      'inquestUdNo': serializer.toJson<String?>(inquestUdNo),
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
    Value<DateTime?> dateOccurredTo = const Value.absent(),
    Value<String?> timeOccurred = const Value.absent(),
    Value<String?> timeOccurredTo = const Value.absent(),
    Value<String?> placeOccurred = const Value.absent(),
    Value<DateTime?> dateRegistered = const Value.absent(),
    Value<String?> timeRegistered = const Value.absent(),
    Value<String?> crimeType = const Value.absent(),
    Value<String?> remoteUid = const Value.absent(),
    String? status,
    Value<String?> courtType = const Value.absent(),
    String? caseStage,
    Value<String?> detailedDescription = const Value.absent(),
    Value<DateTime?> firDate = const Value.absent(),
    Value<String?> firTime = const Value.absent(),
    Value<DateTime?> infoReceivedDate = const Value.absent(),
    Value<String?> infoReceivedTime = const Value.absent(),
    Value<DateTime?> gdDate = const Value.absent(),
    Value<String?> gdTime = const Value.absent(),
    Value<String?> gdEntryNo = const Value.absent(),
    Value<String?> occurrenceDay = const Value.absent(),
    Value<String?> typeOfInformation = const Value.absent(),
    Value<String?> beatNo = const Value.absent(),
    Value<String?> directionDistance = const Value.absent(),
    Value<String?> outsidePsName = const Value.absent(),
    Value<String?> outsidePsDistrict = const Value.absent(),
    Value<String?> delayReason = const Value.absent(),
    Value<String?> inquestUdNo = const Value.absent(),
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
    dateOccurredTo: dateOccurredTo.present
        ? dateOccurredTo.value
        : this.dateOccurredTo,
    timeOccurred: timeOccurred.present ? timeOccurred.value : this.timeOccurred,
    timeOccurredTo: timeOccurredTo.present
        ? timeOccurredTo.value
        : this.timeOccurredTo,
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
    remoteUid: remoteUid.present ? remoteUid.value : this.remoteUid,
    status: status ?? this.status,
    courtType: courtType.present ? courtType.value : this.courtType,
    caseStage: caseStage ?? this.caseStage,
    detailedDescription: detailedDescription.present
        ? detailedDescription.value
        : this.detailedDescription,
    firDate: firDate.present ? firDate.value : this.firDate,
    firTime: firTime.present ? firTime.value : this.firTime,
    infoReceivedDate: infoReceivedDate.present
        ? infoReceivedDate.value
        : this.infoReceivedDate,
    infoReceivedTime: infoReceivedTime.present
        ? infoReceivedTime.value
        : this.infoReceivedTime,
    gdDate: gdDate.present ? gdDate.value : this.gdDate,
    gdTime: gdTime.present ? gdTime.value : this.gdTime,
    gdEntryNo: gdEntryNo.present ? gdEntryNo.value : this.gdEntryNo,
    occurrenceDay: occurrenceDay.present
        ? occurrenceDay.value
        : this.occurrenceDay,
    typeOfInformation: typeOfInformation.present
        ? typeOfInformation.value
        : this.typeOfInformation,
    beatNo: beatNo.present ? beatNo.value : this.beatNo,
    directionDistance: directionDistance.present
        ? directionDistance.value
        : this.directionDistance,
    outsidePsName: outsidePsName.present
        ? outsidePsName.value
        : this.outsidePsName,
    outsidePsDistrict: outsidePsDistrict.present
        ? outsidePsDistrict.value
        : this.outsidePsDistrict,
    delayReason: delayReason.present ? delayReason.value : this.delayReason,
    inquestUdNo: inquestUdNo.present ? inquestUdNo.value : this.inquestUdNo,
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
      dateOccurredTo: data.dateOccurredTo.present
          ? data.dateOccurredTo.value
          : this.dateOccurredTo,
      timeOccurred: data.timeOccurred.present
          ? data.timeOccurred.value
          : this.timeOccurred,
      timeOccurredTo: data.timeOccurredTo.present
          ? data.timeOccurredTo.value
          : this.timeOccurredTo,
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
      remoteUid: data.remoteUid.present ? data.remoteUid.value : this.remoteUid,
      status: data.status.present ? data.status.value : this.status,
      courtType: data.courtType.present ? data.courtType.value : this.courtType,
      caseStage: data.caseStage.present ? data.caseStage.value : this.caseStage,
      detailedDescription: data.detailedDescription.present
          ? data.detailedDescription.value
          : this.detailedDescription,
      firDate: data.firDate.present ? data.firDate.value : this.firDate,
      firTime: data.firTime.present ? data.firTime.value : this.firTime,
      infoReceivedDate: data.infoReceivedDate.present
          ? data.infoReceivedDate.value
          : this.infoReceivedDate,
      infoReceivedTime: data.infoReceivedTime.present
          ? data.infoReceivedTime.value
          : this.infoReceivedTime,
      gdDate: data.gdDate.present ? data.gdDate.value : this.gdDate,
      gdTime: data.gdTime.present ? data.gdTime.value : this.gdTime,
      gdEntryNo: data.gdEntryNo.present ? data.gdEntryNo.value : this.gdEntryNo,
      occurrenceDay: data.occurrenceDay.present
          ? data.occurrenceDay.value
          : this.occurrenceDay,
      typeOfInformation: data.typeOfInformation.present
          ? data.typeOfInformation.value
          : this.typeOfInformation,
      beatNo: data.beatNo.present ? data.beatNo.value : this.beatNo,
      directionDistance: data.directionDistance.present
          ? data.directionDistance.value
          : this.directionDistance,
      outsidePsName: data.outsidePsName.present
          ? data.outsidePsName.value
          : this.outsidePsName,
      outsidePsDistrict: data.outsidePsDistrict.present
          ? data.outsidePsDistrict.value
          : this.outsidePsDistrict,
      delayReason: data.delayReason.present
          ? data.delayReason.value
          : this.delayReason,
      inquestUdNo: data.inquestUdNo.present
          ? data.inquestUdNo.value
          : this.inquestUdNo,
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
          ..write('dateOccurredTo: $dateOccurredTo, ')
          ..write('timeOccurred: $timeOccurred, ')
          ..write('timeOccurredTo: $timeOccurredTo, ')
          ..write('placeOccurred: $placeOccurred, ')
          ..write('dateRegistered: $dateRegistered, ')
          ..write('timeRegistered: $timeRegistered, ')
          ..write('crimeType: $crimeType, ')
          ..write('remoteUid: $remoteUid, ')
          ..write('status: $status, ')
          ..write('courtType: $courtType, ')
          ..write('caseStage: $caseStage, ')
          ..write('detailedDescription: $detailedDescription, ')
          ..write('firDate: $firDate, ')
          ..write('firTime: $firTime, ')
          ..write('infoReceivedDate: $infoReceivedDate, ')
          ..write('infoReceivedTime: $infoReceivedTime, ')
          ..write('gdDate: $gdDate, ')
          ..write('gdTime: $gdTime, ')
          ..write('gdEntryNo: $gdEntryNo, ')
          ..write('occurrenceDay: $occurrenceDay, ')
          ..write('typeOfInformation: $typeOfInformation, ')
          ..write('beatNo: $beatNo, ')
          ..write('directionDistance: $directionDistance, ')
          ..write('outsidePsName: $outsidePsName, ')
          ..write('outsidePsDistrict: $outsidePsDistrict, ')
          ..write('delayReason: $delayReason, ')
          ..write('inquestUdNo: $inquestUdNo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    firNo,
    year,
    section,
    subSection,
    stationId,
    district,
    policeStation,
    dateOccurred,
    dateOccurredTo,
    timeOccurred,
    timeOccurredTo,
    placeOccurred,
    dateRegistered,
    timeRegistered,
    crimeType,
    remoteUid,
    status,
    courtType,
    caseStage,
    detailedDescription,
    firDate,
    firTime,
    infoReceivedDate,
    infoReceivedTime,
    gdDate,
    gdTime,
    gdEntryNo,
    occurrenceDay,
    typeOfInformation,
    beatNo,
    directionDistance,
    outsidePsName,
    outsidePsDistrict,
    delayReason,
    inquestUdNo,
    createdAt,
    updatedAt,
  ]);
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
          other.dateOccurredTo == this.dateOccurredTo &&
          other.timeOccurred == this.timeOccurred &&
          other.timeOccurredTo == this.timeOccurredTo &&
          other.placeOccurred == this.placeOccurred &&
          other.dateRegistered == this.dateRegistered &&
          other.timeRegistered == this.timeRegistered &&
          other.crimeType == this.crimeType &&
          other.remoteUid == this.remoteUid &&
          other.status == this.status &&
          other.courtType == this.courtType &&
          other.caseStage == this.caseStage &&
          other.detailedDescription == this.detailedDescription &&
          other.firDate == this.firDate &&
          other.firTime == this.firTime &&
          other.infoReceivedDate == this.infoReceivedDate &&
          other.infoReceivedTime == this.infoReceivedTime &&
          other.gdDate == this.gdDate &&
          other.gdTime == this.gdTime &&
          other.gdEntryNo == this.gdEntryNo &&
          other.occurrenceDay == this.occurrenceDay &&
          other.typeOfInformation == this.typeOfInformation &&
          other.beatNo == this.beatNo &&
          other.directionDistance == this.directionDistance &&
          other.outsidePsName == this.outsidePsName &&
          other.outsidePsDistrict == this.outsidePsDistrict &&
          other.delayReason == this.delayReason &&
          other.inquestUdNo == this.inquestUdNo &&
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
  final Value<DateTime?> dateOccurredTo;
  final Value<String?> timeOccurred;
  final Value<String?> timeOccurredTo;
  final Value<String?> placeOccurred;
  final Value<DateTime?> dateRegistered;
  final Value<String?> timeRegistered;
  final Value<String?> crimeType;
  final Value<String?> remoteUid;
  final Value<String> status;
  final Value<String?> courtType;
  final Value<String> caseStage;
  final Value<String?> detailedDescription;
  final Value<DateTime?> firDate;
  final Value<String?> firTime;
  final Value<DateTime?> infoReceivedDate;
  final Value<String?> infoReceivedTime;
  final Value<DateTime?> gdDate;
  final Value<String?> gdTime;
  final Value<String?> gdEntryNo;
  final Value<String?> occurrenceDay;
  final Value<String?> typeOfInformation;
  final Value<String?> beatNo;
  final Value<String?> directionDistance;
  final Value<String?> outsidePsName;
  final Value<String?> outsidePsDistrict;
  final Value<String?> delayReason;
  final Value<String?> inquestUdNo;
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
    this.dateOccurredTo = const Value.absent(),
    this.timeOccurred = const Value.absent(),
    this.timeOccurredTo = const Value.absent(),
    this.placeOccurred = const Value.absent(),
    this.dateRegistered = const Value.absent(),
    this.timeRegistered = const Value.absent(),
    this.crimeType = const Value.absent(),
    this.remoteUid = const Value.absent(),
    this.status = const Value.absent(),
    this.courtType = const Value.absent(),
    this.caseStage = const Value.absent(),
    this.detailedDescription = const Value.absent(),
    this.firDate = const Value.absent(),
    this.firTime = const Value.absent(),
    this.infoReceivedDate = const Value.absent(),
    this.infoReceivedTime = const Value.absent(),
    this.gdDate = const Value.absent(),
    this.gdTime = const Value.absent(),
    this.gdEntryNo = const Value.absent(),
    this.occurrenceDay = const Value.absent(),
    this.typeOfInformation = const Value.absent(),
    this.beatNo = const Value.absent(),
    this.directionDistance = const Value.absent(),
    this.outsidePsName = const Value.absent(),
    this.outsidePsDistrict = const Value.absent(),
    this.delayReason = const Value.absent(),
    this.inquestUdNo = const Value.absent(),
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
    this.dateOccurredTo = const Value.absent(),
    this.timeOccurred = const Value.absent(),
    this.timeOccurredTo = const Value.absent(),
    this.placeOccurred = const Value.absent(),
    this.dateRegistered = const Value.absent(),
    this.timeRegistered = const Value.absent(),
    this.crimeType = const Value.absent(),
    this.remoteUid = const Value.absent(),
    this.status = const Value.absent(),
    this.courtType = const Value.absent(),
    this.caseStage = const Value.absent(),
    this.detailedDescription = const Value.absent(),
    this.firDate = const Value.absent(),
    this.firTime = const Value.absent(),
    this.infoReceivedDate = const Value.absent(),
    this.infoReceivedTime = const Value.absent(),
    this.gdDate = const Value.absent(),
    this.gdTime = const Value.absent(),
    this.gdEntryNo = const Value.absent(),
    this.occurrenceDay = const Value.absent(),
    this.typeOfInformation = const Value.absent(),
    this.beatNo = const Value.absent(),
    this.directionDistance = const Value.absent(),
    this.outsidePsName = const Value.absent(),
    this.outsidePsDistrict = const Value.absent(),
    this.delayReason = const Value.absent(),
    this.inquestUdNo = const Value.absent(),
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
    Expression<DateTime>? dateOccurredTo,
    Expression<String>? timeOccurred,
    Expression<String>? timeOccurredTo,
    Expression<String>? placeOccurred,
    Expression<DateTime>? dateRegistered,
    Expression<String>? timeRegistered,
    Expression<String>? crimeType,
    Expression<String>? remoteUid,
    Expression<String>? status,
    Expression<String>? courtType,
    Expression<String>? caseStage,
    Expression<String>? detailedDescription,
    Expression<DateTime>? firDate,
    Expression<String>? firTime,
    Expression<DateTime>? infoReceivedDate,
    Expression<String>? infoReceivedTime,
    Expression<DateTime>? gdDate,
    Expression<String>? gdTime,
    Expression<String>? gdEntryNo,
    Expression<String>? occurrenceDay,
    Expression<String>? typeOfInformation,
    Expression<String>? beatNo,
    Expression<String>? directionDistance,
    Expression<String>? outsidePsName,
    Expression<String>? outsidePsDistrict,
    Expression<String>? delayReason,
    Expression<String>? inquestUdNo,
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
      if (dateOccurredTo != null) 'date_occurred_to': dateOccurredTo,
      if (timeOccurred != null) 'time_occurred': timeOccurred,
      if (timeOccurredTo != null) 'time_occurred_to': timeOccurredTo,
      if (placeOccurred != null) 'place_occurred': placeOccurred,
      if (dateRegistered != null) 'date_registered': dateRegistered,
      if (timeRegistered != null) 'time_registered': timeRegistered,
      if (crimeType != null) 'crime_type': crimeType,
      if (remoteUid != null) 'remote_uid': remoteUid,
      if (status != null) 'status': status,
      if (courtType != null) 'court_type': courtType,
      if (caseStage != null) 'case_stage': caseStage,
      if (detailedDescription != null)
        'detailed_description': detailedDescription,
      if (firDate != null) 'fir_date': firDate,
      if (firTime != null) 'fir_time': firTime,
      if (infoReceivedDate != null) 'info_received_date': infoReceivedDate,
      if (infoReceivedTime != null) 'info_received_time': infoReceivedTime,
      if (gdDate != null) 'gd_date': gdDate,
      if (gdTime != null) 'gd_time': gdTime,
      if (gdEntryNo != null) 'gd_entry_no': gdEntryNo,
      if (occurrenceDay != null) 'occurrence_day': occurrenceDay,
      if (typeOfInformation != null) 'type_of_information': typeOfInformation,
      if (beatNo != null) 'beat_no': beatNo,
      if (directionDistance != null) 'direction_distance': directionDistance,
      if (outsidePsName != null) 'outside_ps_name': outsidePsName,
      if (outsidePsDistrict != null) 'outside_ps_district': outsidePsDistrict,
      if (delayReason != null) 'delay_reason': delayReason,
      if (inquestUdNo != null) 'inquest_ud_no': inquestUdNo,
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
    Value<DateTime?>? dateOccurredTo,
    Value<String?>? timeOccurred,
    Value<String?>? timeOccurredTo,
    Value<String?>? placeOccurred,
    Value<DateTime?>? dateRegistered,
    Value<String?>? timeRegistered,
    Value<String?>? crimeType,
    Value<String?>? remoteUid,
    Value<String>? status,
    Value<String?>? courtType,
    Value<String>? caseStage,
    Value<String?>? detailedDescription,
    Value<DateTime?>? firDate,
    Value<String?>? firTime,
    Value<DateTime?>? infoReceivedDate,
    Value<String?>? infoReceivedTime,
    Value<DateTime?>? gdDate,
    Value<String?>? gdTime,
    Value<String?>? gdEntryNo,
    Value<String?>? occurrenceDay,
    Value<String?>? typeOfInformation,
    Value<String?>? beatNo,
    Value<String?>? directionDistance,
    Value<String?>? outsidePsName,
    Value<String?>? outsidePsDistrict,
    Value<String?>? delayReason,
    Value<String?>? inquestUdNo,
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
      dateOccurredTo: dateOccurredTo ?? this.dateOccurredTo,
      timeOccurred: timeOccurred ?? this.timeOccurred,
      timeOccurredTo: timeOccurredTo ?? this.timeOccurredTo,
      placeOccurred: placeOccurred ?? this.placeOccurred,
      dateRegistered: dateRegistered ?? this.dateRegistered,
      timeRegistered: timeRegistered ?? this.timeRegistered,
      crimeType: crimeType ?? this.crimeType,
      remoteUid: remoteUid ?? this.remoteUid,
      status: status ?? this.status,
      courtType: courtType ?? this.courtType,
      caseStage: caseStage ?? this.caseStage,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      firDate: firDate ?? this.firDate,
      firTime: firTime ?? this.firTime,
      infoReceivedDate: infoReceivedDate ?? this.infoReceivedDate,
      infoReceivedTime: infoReceivedTime ?? this.infoReceivedTime,
      gdDate: gdDate ?? this.gdDate,
      gdTime: gdTime ?? this.gdTime,
      gdEntryNo: gdEntryNo ?? this.gdEntryNo,
      occurrenceDay: occurrenceDay ?? this.occurrenceDay,
      typeOfInformation: typeOfInformation ?? this.typeOfInformation,
      beatNo: beatNo ?? this.beatNo,
      directionDistance: directionDistance ?? this.directionDistance,
      outsidePsName: outsidePsName ?? this.outsidePsName,
      outsidePsDistrict: outsidePsDistrict ?? this.outsidePsDistrict,
      delayReason: delayReason ?? this.delayReason,
      inquestUdNo: inquestUdNo ?? this.inquestUdNo,
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
    if (dateOccurredTo.present) {
      map['date_occurred_to'] = Variable<DateTime>(dateOccurredTo.value);
    }
    if (timeOccurred.present) {
      map['time_occurred'] = Variable<String>(timeOccurred.value);
    }
    if (timeOccurredTo.present) {
      map['time_occurred_to'] = Variable<String>(timeOccurredTo.value);
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
    if (remoteUid.present) {
      map['remote_uid'] = Variable<String>(remoteUid.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (courtType.present) {
      map['court_type'] = Variable<String>(courtType.value);
    }
    if (caseStage.present) {
      map['case_stage'] = Variable<String>(caseStage.value);
    }
    if (detailedDescription.present) {
      map['detailed_description'] = Variable<String>(detailedDescription.value);
    }
    if (firDate.present) {
      map['fir_date'] = Variable<DateTime>(firDate.value);
    }
    if (firTime.present) {
      map['fir_time'] = Variable<String>(firTime.value);
    }
    if (infoReceivedDate.present) {
      map['info_received_date'] = Variable<DateTime>(infoReceivedDate.value);
    }
    if (infoReceivedTime.present) {
      map['info_received_time'] = Variable<String>(infoReceivedTime.value);
    }
    if (gdDate.present) {
      map['gd_date'] = Variable<DateTime>(gdDate.value);
    }
    if (gdTime.present) {
      map['gd_time'] = Variable<String>(gdTime.value);
    }
    if (gdEntryNo.present) {
      map['gd_entry_no'] = Variable<String>(gdEntryNo.value);
    }
    if (occurrenceDay.present) {
      map['occurrence_day'] = Variable<String>(occurrenceDay.value);
    }
    if (typeOfInformation.present) {
      map['type_of_information'] = Variable<String>(typeOfInformation.value);
    }
    if (beatNo.present) {
      map['beat_no'] = Variable<String>(beatNo.value);
    }
    if (directionDistance.present) {
      map['direction_distance'] = Variable<String>(directionDistance.value);
    }
    if (outsidePsName.present) {
      map['outside_ps_name'] = Variable<String>(outsidePsName.value);
    }
    if (outsidePsDistrict.present) {
      map['outside_ps_district'] = Variable<String>(outsidePsDistrict.value);
    }
    if (delayReason.present) {
      map['delay_reason'] = Variable<String>(delayReason.value);
    }
    if (inquestUdNo.present) {
      map['inquest_ud_no'] = Variable<String>(inquestUdNo.value);
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
          ..write('dateOccurredTo: $dateOccurredTo, ')
          ..write('timeOccurred: $timeOccurred, ')
          ..write('timeOccurredTo: $timeOccurredTo, ')
          ..write('placeOccurred: $placeOccurred, ')
          ..write('dateRegistered: $dateRegistered, ')
          ..write('timeRegistered: $timeRegistered, ')
          ..write('crimeType: $crimeType, ')
          ..write('remoteUid: $remoteUid, ')
          ..write('status: $status, ')
          ..write('courtType: $courtType, ')
          ..write('caseStage: $caseStage, ')
          ..write('detailedDescription: $detailedDescription, ')
          ..write('firDate: $firDate, ')
          ..write('firTime: $firTime, ')
          ..write('infoReceivedDate: $infoReceivedDate, ')
          ..write('infoReceivedTime: $infoReceivedTime, ')
          ..write('gdDate: $gdDate, ')
          ..write('gdTime: $gdTime, ')
          ..write('gdEntryNo: $gdEntryNo, ')
          ..write('occurrenceDay: $occurrenceDay, ')
          ..write('typeOfInformation: $typeOfInformation, ')
          ..write('beatNo: $beatNo, ')
          ..write('directionDistance: $directionDistance, ')
          ..write('outsidePsName: $outsidePsName, ')
          ..write('outsidePsDistrict: $outsidePsDistrict, ')
          ..write('delayReason: $delayReason, ')
          ..write('inquestUdNo: $inquestUdNo, ')
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
  static const VerificationMeta _ageTextMeta = const VerificationMeta(
    'ageText',
  );
  @override
  late final GeneratedColumn<String> ageText = GeneratedColumn<String>(
    'age_text',
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
  static const VerificationMeta _fatherHusbandNameMeta = const VerificationMeta(
    'fatherHusbandName',
  );
  @override
  late final GeneratedColumn<String> fatherHusbandName =
      GeneratedColumn<String>(
        'father_husband_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _birthYearMeta = const VerificationMeta(
    'birthYear',
  );
  @override
  late final GeneratedColumn<int> birthYear = GeneratedColumn<int>(
    'birth_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nationalityMeta = const VerificationMeta(
    'nationality',
  );
  @override
  late final GeneratedColumn<String> nationality = GeneratedColumn<String>(
    'nationality',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occupationMeta = const VerificationMeta(
    'occupation',
  );
  @override
  late final GeneratedColumn<String> occupation = GeneratedColumn<String>(
    'occupation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _permanentAddressMeta = const VerificationMeta(
    'permanentAddress',
  );
  @override
  late final GeneratedColumn<String> permanentAddress = GeneratedColumn<String>(
    'permanent_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idTypeMeta = const VerificationMeta('idType');
  @override
  late final GeneratedColumn<String> idType = GeneratedColumn<String>(
    'id_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idNumberMeta = const VerificationMeta(
    'idNumber',
  );
  @override
  late final GeneratedColumn<String> idNumber = GeneratedColumn<String>(
    'id_number',
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
    ageText,
    address,
    mobile,
    email,
    aadhaarEnc,
    panEnc,
    passport,
    fatherHusbandName,
    birthYear,
    nationality,
    occupation,
    permanentAddress,
    idType,
    idNumber,
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
    if (data.containsKey('age_text')) {
      context.handle(
        _ageTextMeta,
        ageText.isAcceptableOrUnknown(data['age_text']!, _ageTextMeta),
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
    if (data.containsKey('father_husband_name')) {
      context.handle(
        _fatherHusbandNameMeta,
        fatherHusbandName.isAcceptableOrUnknown(
          data['father_husband_name']!,
          _fatherHusbandNameMeta,
        ),
      );
    }
    if (data.containsKey('birth_year')) {
      context.handle(
        _birthYearMeta,
        birthYear.isAcceptableOrUnknown(data['birth_year']!, _birthYearMeta),
      );
    }
    if (data.containsKey('nationality')) {
      context.handle(
        _nationalityMeta,
        nationality.isAcceptableOrUnknown(
          data['nationality']!,
          _nationalityMeta,
        ),
      );
    }
    if (data.containsKey('occupation')) {
      context.handle(
        _occupationMeta,
        occupation.isAcceptableOrUnknown(data['occupation']!, _occupationMeta),
      );
    }
    if (data.containsKey('permanent_address')) {
      context.handle(
        _permanentAddressMeta,
        permanentAddress.isAcceptableOrUnknown(
          data['permanent_address']!,
          _permanentAddressMeta,
        ),
      );
    }
    if (data.containsKey('id_type')) {
      context.handle(
        _idTypeMeta,
        idType.isAcceptableOrUnknown(data['id_type']!, _idTypeMeta),
      );
    }
    if (data.containsKey('id_number')) {
      context.handle(
        _idNumberMeta,
        idNumber.isAcceptableOrUnknown(data['id_number']!, _idNumberMeta),
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
      ageText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}age_text'],
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
      fatherHusbandName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}father_husband_name'],
      ),
      birthYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}birth_year'],
      ),
      nationality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nationality'],
      ),
      occupation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occupation'],
      ),
      permanentAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permanent_address'],
      ),
      idType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_type'],
      ),
      idNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_number'],
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
  final String? ageText;
  final String? address;
  final String? mobile;
  final String? email;
  final String? aadhaarEnc;
  final String? panEnc;
  final String? passport;
  final String? fatherHusbandName;
  final int? birthYear;
  final String? nationality;
  final String? occupation;
  final String? permanentAddress;
  final String? idType;
  final String? idNumber;
  const Complainant({
    required this.id,
    required this.crimeId,
    required this.name,
    this.gender,
    this.age,
    this.ageText,
    this.address,
    this.mobile,
    this.email,
    this.aadhaarEnc,
    this.panEnc,
    this.passport,
    this.fatherHusbandName,
    this.birthYear,
    this.nationality,
    this.occupation,
    this.permanentAddress,
    this.idType,
    this.idNumber,
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
    if (!nullToAbsent || ageText != null) {
      map['age_text'] = Variable<String>(ageText);
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
    if (!nullToAbsent || fatherHusbandName != null) {
      map['father_husband_name'] = Variable<String>(fatherHusbandName);
    }
    if (!nullToAbsent || birthYear != null) {
      map['birth_year'] = Variable<int>(birthYear);
    }
    if (!nullToAbsent || nationality != null) {
      map['nationality'] = Variable<String>(nationality);
    }
    if (!nullToAbsent || occupation != null) {
      map['occupation'] = Variable<String>(occupation);
    }
    if (!nullToAbsent || permanentAddress != null) {
      map['permanent_address'] = Variable<String>(permanentAddress);
    }
    if (!nullToAbsent || idType != null) {
      map['id_type'] = Variable<String>(idType);
    }
    if (!nullToAbsent || idNumber != null) {
      map['id_number'] = Variable<String>(idNumber);
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
      ageText: ageText == null && nullToAbsent
          ? const Value.absent()
          : Value(ageText),
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
      fatherHusbandName: fatherHusbandName == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherHusbandName),
      birthYear: birthYear == null && nullToAbsent
          ? const Value.absent()
          : Value(birthYear),
      nationality: nationality == null && nullToAbsent
          ? const Value.absent()
          : Value(nationality),
      occupation: occupation == null && nullToAbsent
          ? const Value.absent()
          : Value(occupation),
      permanentAddress: permanentAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(permanentAddress),
      idType: idType == null && nullToAbsent
          ? const Value.absent()
          : Value(idType),
      idNumber: idNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(idNumber),
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
      ageText: serializer.fromJson<String?>(json['ageText']),
      address: serializer.fromJson<String?>(json['address']),
      mobile: serializer.fromJson<String?>(json['mobile']),
      email: serializer.fromJson<String?>(json['email']),
      aadhaarEnc: serializer.fromJson<String?>(json['aadhaarEnc']),
      panEnc: serializer.fromJson<String?>(json['panEnc']),
      passport: serializer.fromJson<String?>(json['passport']),
      fatherHusbandName: serializer.fromJson<String?>(
        json['fatherHusbandName'],
      ),
      birthYear: serializer.fromJson<int?>(json['birthYear']),
      nationality: serializer.fromJson<String?>(json['nationality']),
      occupation: serializer.fromJson<String?>(json['occupation']),
      permanentAddress: serializer.fromJson<String?>(json['permanentAddress']),
      idType: serializer.fromJson<String?>(json['idType']),
      idNumber: serializer.fromJson<String?>(json['idNumber']),
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
      'ageText': serializer.toJson<String?>(ageText),
      'address': serializer.toJson<String?>(address),
      'mobile': serializer.toJson<String?>(mobile),
      'email': serializer.toJson<String?>(email),
      'aadhaarEnc': serializer.toJson<String?>(aadhaarEnc),
      'panEnc': serializer.toJson<String?>(panEnc),
      'passport': serializer.toJson<String?>(passport),
      'fatherHusbandName': serializer.toJson<String?>(fatherHusbandName),
      'birthYear': serializer.toJson<int?>(birthYear),
      'nationality': serializer.toJson<String?>(nationality),
      'occupation': serializer.toJson<String?>(occupation),
      'permanentAddress': serializer.toJson<String?>(permanentAddress),
      'idType': serializer.toJson<String?>(idType),
      'idNumber': serializer.toJson<String?>(idNumber),
    };
  }

  Complainant copyWith({
    int? id,
    int? crimeId,
    String? name,
    Value<String?> gender = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<String?> ageText = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> mobile = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> aadhaarEnc = const Value.absent(),
    Value<String?> panEnc = const Value.absent(),
    Value<String?> passport = const Value.absent(),
    Value<String?> fatherHusbandName = const Value.absent(),
    Value<int?> birthYear = const Value.absent(),
    Value<String?> nationality = const Value.absent(),
    Value<String?> occupation = const Value.absent(),
    Value<String?> permanentAddress = const Value.absent(),
    Value<String?> idType = const Value.absent(),
    Value<String?> idNumber = const Value.absent(),
  }) => Complainant(
    id: id ?? this.id,
    crimeId: crimeId ?? this.crimeId,
    name: name ?? this.name,
    gender: gender.present ? gender.value : this.gender,
    age: age.present ? age.value : this.age,
    ageText: ageText.present ? ageText.value : this.ageText,
    address: address.present ? address.value : this.address,
    mobile: mobile.present ? mobile.value : this.mobile,
    email: email.present ? email.value : this.email,
    aadhaarEnc: aadhaarEnc.present ? aadhaarEnc.value : this.aadhaarEnc,
    panEnc: panEnc.present ? panEnc.value : this.panEnc,
    passport: passport.present ? passport.value : this.passport,
    fatherHusbandName: fatherHusbandName.present
        ? fatherHusbandName.value
        : this.fatherHusbandName,
    birthYear: birthYear.present ? birthYear.value : this.birthYear,
    nationality: nationality.present ? nationality.value : this.nationality,
    occupation: occupation.present ? occupation.value : this.occupation,
    permanentAddress: permanentAddress.present
        ? permanentAddress.value
        : this.permanentAddress,
    idType: idType.present ? idType.value : this.idType,
    idNumber: idNumber.present ? idNumber.value : this.idNumber,
  );
  Complainant copyWithCompanion(ComplainantsCompanion data) {
    return Complainant(
      id: data.id.present ? data.id.value : this.id,
      crimeId: data.crimeId.present ? data.crimeId.value : this.crimeId,
      name: data.name.present ? data.name.value : this.name,
      gender: data.gender.present ? data.gender.value : this.gender,
      age: data.age.present ? data.age.value : this.age,
      ageText: data.ageText.present ? data.ageText.value : this.ageText,
      address: data.address.present ? data.address.value : this.address,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      email: data.email.present ? data.email.value : this.email,
      aadhaarEnc: data.aadhaarEnc.present
          ? data.aadhaarEnc.value
          : this.aadhaarEnc,
      panEnc: data.panEnc.present ? data.panEnc.value : this.panEnc,
      passport: data.passport.present ? data.passport.value : this.passport,
      fatherHusbandName: data.fatherHusbandName.present
          ? data.fatherHusbandName.value
          : this.fatherHusbandName,
      birthYear: data.birthYear.present ? data.birthYear.value : this.birthYear,
      nationality: data.nationality.present
          ? data.nationality.value
          : this.nationality,
      occupation: data.occupation.present
          ? data.occupation.value
          : this.occupation,
      permanentAddress: data.permanentAddress.present
          ? data.permanentAddress.value
          : this.permanentAddress,
      idType: data.idType.present ? data.idType.value : this.idType,
      idNumber: data.idNumber.present ? data.idNumber.value : this.idNumber,
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
          ..write('ageText: $ageText, ')
          ..write('address: $address, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('aadhaarEnc: $aadhaarEnc, ')
          ..write('panEnc: $panEnc, ')
          ..write('passport: $passport, ')
          ..write('fatherHusbandName: $fatherHusbandName, ')
          ..write('birthYear: $birthYear, ')
          ..write('nationality: $nationality, ')
          ..write('occupation: $occupation, ')
          ..write('permanentAddress: $permanentAddress, ')
          ..write('idType: $idType, ')
          ..write('idNumber: $idNumber')
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
    ageText,
    address,
    mobile,
    email,
    aadhaarEnc,
    panEnc,
    passport,
    fatherHusbandName,
    birthYear,
    nationality,
    occupation,
    permanentAddress,
    idType,
    idNumber,
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
          other.ageText == this.ageText &&
          other.address == this.address &&
          other.mobile == this.mobile &&
          other.email == this.email &&
          other.aadhaarEnc == this.aadhaarEnc &&
          other.panEnc == this.panEnc &&
          other.passport == this.passport &&
          other.fatherHusbandName == this.fatherHusbandName &&
          other.birthYear == this.birthYear &&
          other.nationality == this.nationality &&
          other.occupation == this.occupation &&
          other.permanentAddress == this.permanentAddress &&
          other.idType == this.idType &&
          other.idNumber == this.idNumber);
}

class ComplainantsCompanion extends UpdateCompanion<Complainant> {
  final Value<int> id;
  final Value<int> crimeId;
  final Value<String> name;
  final Value<String?> gender;
  final Value<int?> age;
  final Value<String?> ageText;
  final Value<String?> address;
  final Value<String?> mobile;
  final Value<String?> email;
  final Value<String?> aadhaarEnc;
  final Value<String?> panEnc;
  final Value<String?> passport;
  final Value<String?> fatherHusbandName;
  final Value<int?> birthYear;
  final Value<String?> nationality;
  final Value<String?> occupation;
  final Value<String?> permanentAddress;
  final Value<String?> idType;
  final Value<String?> idNumber;
  const ComplainantsCompanion({
    this.id = const Value.absent(),
    this.crimeId = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.age = const Value.absent(),
    this.ageText = const Value.absent(),
    this.address = const Value.absent(),
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.aadhaarEnc = const Value.absent(),
    this.panEnc = const Value.absent(),
    this.passport = const Value.absent(),
    this.fatherHusbandName = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.nationality = const Value.absent(),
    this.occupation = const Value.absent(),
    this.permanentAddress = const Value.absent(),
    this.idType = const Value.absent(),
    this.idNumber = const Value.absent(),
  });
  ComplainantsCompanion.insert({
    this.id = const Value.absent(),
    required int crimeId,
    required String name,
    this.gender = const Value.absent(),
    this.age = const Value.absent(),
    this.ageText = const Value.absent(),
    this.address = const Value.absent(),
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.aadhaarEnc = const Value.absent(),
    this.panEnc = const Value.absent(),
    this.passport = const Value.absent(),
    this.fatherHusbandName = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.nationality = const Value.absent(),
    this.occupation = const Value.absent(),
    this.permanentAddress = const Value.absent(),
    this.idType = const Value.absent(),
    this.idNumber = const Value.absent(),
  }) : crimeId = Value(crimeId),
       name = Value(name);
  static Insertable<Complainant> custom({
    Expression<int>? id,
    Expression<int>? crimeId,
    Expression<String>? name,
    Expression<String>? gender,
    Expression<int>? age,
    Expression<String>? ageText,
    Expression<String>? address,
    Expression<String>? mobile,
    Expression<String>? email,
    Expression<String>? aadhaarEnc,
    Expression<String>? panEnc,
    Expression<String>? passport,
    Expression<String>? fatherHusbandName,
    Expression<int>? birthYear,
    Expression<String>? nationality,
    Expression<String>? occupation,
    Expression<String>? permanentAddress,
    Expression<String>? idType,
    Expression<String>? idNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crimeId != null) 'crime_id': crimeId,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (age != null) 'age': age,
      if (ageText != null) 'age_text': ageText,
      if (address != null) 'address': address,
      if (mobile != null) 'mobile': mobile,
      if (email != null) 'email': email,
      if (aadhaarEnc != null) 'aadhaar_enc': aadhaarEnc,
      if (panEnc != null) 'pan_enc': panEnc,
      if (passport != null) 'passport': passport,
      if (fatherHusbandName != null) 'father_husband_name': fatherHusbandName,
      if (birthYear != null) 'birth_year': birthYear,
      if (nationality != null) 'nationality': nationality,
      if (occupation != null) 'occupation': occupation,
      if (permanentAddress != null) 'permanent_address': permanentAddress,
      if (idType != null) 'id_type': idType,
      if (idNumber != null) 'id_number': idNumber,
    });
  }

  ComplainantsCompanion copyWith({
    Value<int>? id,
    Value<int>? crimeId,
    Value<String>? name,
    Value<String?>? gender,
    Value<int?>? age,
    Value<String?>? ageText,
    Value<String?>? address,
    Value<String?>? mobile,
    Value<String?>? email,
    Value<String?>? aadhaarEnc,
    Value<String?>? panEnc,
    Value<String?>? passport,
    Value<String?>? fatherHusbandName,
    Value<int?>? birthYear,
    Value<String?>? nationality,
    Value<String?>? occupation,
    Value<String?>? permanentAddress,
    Value<String?>? idType,
    Value<String?>? idNumber,
  }) {
    return ComplainantsCompanion(
      id: id ?? this.id,
      crimeId: crimeId ?? this.crimeId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      ageText: ageText ?? this.ageText,
      address: address ?? this.address,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      aadhaarEnc: aadhaarEnc ?? this.aadhaarEnc,
      panEnc: panEnc ?? this.panEnc,
      passport: passport ?? this.passport,
      fatherHusbandName: fatherHusbandName ?? this.fatherHusbandName,
      birthYear: birthYear ?? this.birthYear,
      nationality: nationality ?? this.nationality,
      occupation: occupation ?? this.occupation,
      permanentAddress: permanentAddress ?? this.permanentAddress,
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
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
    if (ageText.present) {
      map['age_text'] = Variable<String>(ageText.value);
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
    if (fatherHusbandName.present) {
      map['father_husband_name'] = Variable<String>(fatherHusbandName.value);
    }
    if (birthYear.present) {
      map['birth_year'] = Variable<int>(birthYear.value);
    }
    if (nationality.present) {
      map['nationality'] = Variable<String>(nationality.value);
    }
    if (occupation.present) {
      map['occupation'] = Variable<String>(occupation.value);
    }
    if (permanentAddress.present) {
      map['permanent_address'] = Variable<String>(permanentAddress.value);
    }
    if (idType.present) {
      map['id_type'] = Variable<String>(idType.value);
    }
    if (idNumber.present) {
      map['id_number'] = Variable<String>(idNumber.value);
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
          ..write('ageText: $ageText, ')
          ..write('address: $address, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('aadhaarEnc: $aadhaarEnc, ')
          ..write('panEnc: $panEnc, ')
          ..write('passport: $passport, ')
          ..write('fatherHusbandName: $fatherHusbandName, ')
          ..write('birthYear: $birthYear, ')
          ..write('nationality: $nationality, ')
          ..write('occupation: $occupation, ')
          ..write('permanentAddress: $permanentAddress, ')
          ..write('idType: $idType, ')
          ..write('idNumber: $idNumber')
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
  static const VerificationMeta _ageTextMeta = const VerificationMeta(
    'ageText',
  );
  @override
  late final GeneratedColumn<String> ageText = GeneratedColumn<String>(
    'age_text',
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
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _relativeNameMeta = const VerificationMeta(
    'relativeName',
  );
  @override
  late final GeneratedColumn<String> relativeName = GeneratedColumn<String>(
    'relative_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _physicalJsonMeta = const VerificationMeta(
    'physicalJson',
  );
  @override
  late final GeneratedColumn<String> physicalJson = GeneratedColumn<String>(
    'physical_json',
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
    ageText,
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
    alias,
    relativeName,
    physicalJson,
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
    if (data.containsKey('age_text')) {
      context.handle(
        _ageTextMeta,
        ageText.isAcceptableOrUnknown(data['age_text']!, _ageTextMeta),
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
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
    }
    if (data.containsKey('relative_name')) {
      context.handle(
        _relativeNameMeta,
        relativeName.isAcceptableOrUnknown(
          data['relative_name']!,
          _relativeNameMeta,
        ),
      );
    }
    if (data.containsKey('physical_json')) {
      context.handle(
        _physicalJsonMeta,
        physicalJson.isAcceptableOrUnknown(
          data['physical_json']!,
          _physicalJsonMeta,
        ),
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
      ageText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}age_text'],
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
      alias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alias'],
      ),
      relativeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relative_name'],
      ),
      physicalJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}physical_json'],
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
  final String? ageText;
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
  final String? alias;
  final String? relativeName;
  final String? physicalJson;
  const AccusedData({
    required this.id,
    required this.crimeId,
    required this.name,
    this.gender,
    this.age,
    this.ageText,
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
    this.alias,
    this.relativeName,
    this.physicalJson,
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
    if (!nullToAbsent || ageText != null) {
      map['age_text'] = Variable<String>(ageText);
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
    if (!nullToAbsent || alias != null) {
      map['alias'] = Variable<String>(alias);
    }
    if (!nullToAbsent || relativeName != null) {
      map['relative_name'] = Variable<String>(relativeName);
    }
    if (!nullToAbsent || physicalJson != null) {
      map['physical_json'] = Variable<String>(physicalJson);
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
      ageText: ageText == null && nullToAbsent
          ? const Value.absent()
          : Value(ageText),
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
      alias: alias == null && nullToAbsent
          ? const Value.absent()
          : Value(alias),
      relativeName: relativeName == null && nullToAbsent
          ? const Value.absent()
          : Value(relativeName),
      physicalJson: physicalJson == null && nullToAbsent
          ? const Value.absent()
          : Value(physicalJson),
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
      ageText: serializer.fromJson<String?>(json['ageText']),
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
      alias: serializer.fromJson<String?>(json['alias']),
      relativeName: serializer.fromJson<String?>(json['relativeName']),
      physicalJson: serializer.fromJson<String?>(json['physicalJson']),
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
      'ageText': serializer.toJson<String?>(ageText),
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
      'alias': serializer.toJson<String?>(alias),
      'relativeName': serializer.toJson<String?>(relativeName),
      'physicalJson': serializer.toJson<String?>(physicalJson),
    };
  }

  AccusedData copyWith({
    int? id,
    int? crimeId,
    String? name,
    Value<String?> gender = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<String?> ageText = const Value.absent(),
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
    Value<String?> alias = const Value.absent(),
    Value<String?> relativeName = const Value.absent(),
    Value<String?> physicalJson = const Value.absent(),
  }) => AccusedData(
    id: id ?? this.id,
    crimeId: crimeId ?? this.crimeId,
    name: name ?? this.name,
    gender: gender.present ? gender.value : this.gender,
    age: age.present ? age.value : this.age,
    ageText: ageText.present ? ageText.value : this.ageText,
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
    alias: alias.present ? alias.value : this.alias,
    relativeName: relativeName.present ? relativeName.value : this.relativeName,
    physicalJson: physicalJson.present ? physicalJson.value : this.physicalJson,
  );
  AccusedData copyWithCompanion(AccusedCompanion data) {
    return AccusedData(
      id: data.id.present ? data.id.value : this.id,
      crimeId: data.crimeId.present ? data.crimeId.value : this.crimeId,
      name: data.name.present ? data.name.value : this.name,
      gender: data.gender.present ? data.gender.value : this.gender,
      age: data.age.present ? data.age.value : this.age,
      ageText: data.ageText.present ? data.ageText.value : this.ageText,
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
      alias: data.alias.present ? data.alias.value : this.alias,
      relativeName: data.relativeName.present
          ? data.relativeName.value
          : this.relativeName,
      physicalJson: data.physicalJson.present
          ? data.physicalJson.value
          : this.physicalJson,
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
          ..write('ageText: $ageText, ')
          ..write('address: $address, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('aadhaarEnc: $aadhaarEnc, ')
          ..write('panEnc: $panEnc, ')
          ..write('passport: $passport, ')
          ..write('arrestStatus: $arrestStatus, ')
          ..write('arrestDate: $arrestDate, ')
          ..write('arrestTime: $arrestTime, ')
          ..write('photoPath: $photoPath, ')
          ..write('alias: $alias, ')
          ..write('relativeName: $relativeName, ')
          ..write('physicalJson: $physicalJson')
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
    ageText,
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
    alias,
    relativeName,
    physicalJson,
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
          other.ageText == this.ageText &&
          other.address == this.address &&
          other.mobile == this.mobile &&
          other.email == this.email &&
          other.aadhaarEnc == this.aadhaarEnc &&
          other.panEnc == this.panEnc &&
          other.passport == this.passport &&
          other.arrestStatus == this.arrestStatus &&
          other.arrestDate == this.arrestDate &&
          other.arrestTime == this.arrestTime &&
          other.photoPath == this.photoPath &&
          other.alias == this.alias &&
          other.relativeName == this.relativeName &&
          other.physicalJson == this.physicalJson);
}

class AccusedCompanion extends UpdateCompanion<AccusedData> {
  final Value<int> id;
  final Value<int> crimeId;
  final Value<String> name;
  final Value<String?> gender;
  final Value<int?> age;
  final Value<String?> ageText;
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
  final Value<String?> alias;
  final Value<String?> relativeName;
  final Value<String?> physicalJson;
  const AccusedCompanion({
    this.id = const Value.absent(),
    this.crimeId = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.age = const Value.absent(),
    this.ageText = const Value.absent(),
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
    this.alias = const Value.absent(),
    this.relativeName = const Value.absent(),
    this.physicalJson = const Value.absent(),
  });
  AccusedCompanion.insert({
    this.id = const Value.absent(),
    required int crimeId,
    required String name,
    this.gender = const Value.absent(),
    this.age = const Value.absent(),
    this.ageText = const Value.absent(),
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
    this.alias = const Value.absent(),
    this.relativeName = const Value.absent(),
    this.physicalJson = const Value.absent(),
  }) : crimeId = Value(crimeId),
       name = Value(name);
  static Insertable<AccusedData> custom({
    Expression<int>? id,
    Expression<int>? crimeId,
    Expression<String>? name,
    Expression<String>? gender,
    Expression<int>? age,
    Expression<String>? ageText,
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
    Expression<String>? alias,
    Expression<String>? relativeName,
    Expression<String>? physicalJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crimeId != null) 'crime_id': crimeId,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (age != null) 'age': age,
      if (ageText != null) 'age_text': ageText,
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
      if (alias != null) 'alias': alias,
      if (relativeName != null) 'relative_name': relativeName,
      if (physicalJson != null) 'physical_json': physicalJson,
    });
  }

  AccusedCompanion copyWith({
    Value<int>? id,
    Value<int>? crimeId,
    Value<String>? name,
    Value<String?>? gender,
    Value<int?>? age,
    Value<String?>? ageText,
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
    Value<String?>? alias,
    Value<String?>? relativeName,
    Value<String?>? physicalJson,
  }) {
    return AccusedCompanion(
      id: id ?? this.id,
      crimeId: crimeId ?? this.crimeId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      ageText: ageText ?? this.ageText,
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
      alias: alias ?? this.alias,
      relativeName: relativeName ?? this.relativeName,
      physicalJson: physicalJson ?? this.physicalJson,
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
    if (ageText.present) {
      map['age_text'] = Variable<String>(ageText.value);
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
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (relativeName.present) {
      map['relative_name'] = Variable<String>(relativeName.value);
    }
    if (physicalJson.present) {
      map['physical_json'] = Variable<String>(physicalJson.value);
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
          ..write('ageText: $ageText, ')
          ..write('address: $address, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('aadhaarEnc: $aadhaarEnc, ')
          ..write('panEnc: $panEnc, ')
          ..write('passport: $passport, ')
          ..write('arrestStatus: $arrestStatus, ')
          ..write('arrestDate: $arrestDate, ')
          ..write('arrestTime: $arrestTime, ')
          ..write('photoPath: $photoPath, ')
          ..write('alias: $alias, ')
          ..write('relativeName: $relativeName, ')
          ..write('physicalJson: $physicalJson')
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  List<GeneratedColumn> get $columns => [
    id,
    crimeId,
    category,
    type,
    description,
    value,
  ];
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
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
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
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
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
  final String? category;
  final String? type;
  final String? description;
  final double? value;
  const StolenPropertyData({
    required this.id,
    required this.crimeId,
    this.category,
    this.type,
    this.description,
    this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['crime_id'] = Variable<int>(crimeId);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
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
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
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
      category: serializer.fromJson<String?>(json['category']),
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
      'category': serializer.toJson<String?>(category),
      'type': serializer.toJson<String?>(type),
      'description': serializer.toJson<String?>(description),
      'value': serializer.toJson<double?>(value),
    };
  }

  StolenPropertyData copyWith({
    int? id,
    int? crimeId,
    Value<String?> category = const Value.absent(),
    Value<String?> type = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<double?> value = const Value.absent(),
  }) => StolenPropertyData(
    id: id ?? this.id,
    crimeId: crimeId ?? this.crimeId,
    category: category.present ? category.value : this.category,
    type: type.present ? type.value : this.type,
    description: description.present ? description.value : this.description,
    value: value.present ? value.value : this.value,
  );
  StolenPropertyData copyWithCompanion(StolenPropertyCompanion data) {
    return StolenPropertyData(
      id: data.id.present ? data.id.value : this.id,
      crimeId: data.crimeId.present ? data.crimeId.value : this.crimeId,
      category: data.category.present ? data.category.value : this.category,
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
          ..write('category: $category, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, crimeId, category, type, description, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StolenPropertyData &&
          other.id == this.id &&
          other.crimeId == this.crimeId &&
          other.category == this.category &&
          other.type == this.type &&
          other.description == this.description &&
          other.value == this.value);
}

class StolenPropertyCompanion extends UpdateCompanion<StolenPropertyData> {
  final Value<int> id;
  final Value<int> crimeId;
  final Value<String?> category;
  final Value<String?> type;
  final Value<String?> description;
  final Value<double?> value;
  const StolenPropertyCompanion({
    this.id = const Value.absent(),
    this.crimeId = const Value.absent(),
    this.category = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.value = const Value.absent(),
  });
  StolenPropertyCompanion.insert({
    this.id = const Value.absent(),
    required int crimeId,
    this.category = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.value = const Value.absent(),
  }) : crimeId = Value(crimeId);
  static Insertable<StolenPropertyData> custom({
    Expression<int>? id,
    Expression<int>? crimeId,
    Expression<String>? category,
    Expression<String>? type,
    Expression<String>? description,
    Expression<double>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crimeId != null) 'crime_id': crimeId,
      if (category != null) 'category': category,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (value != null) 'value': value,
    });
  }

  StolenPropertyCompanion copyWith({
    Value<int>? id,
    Value<int>? crimeId,
    Value<String?>? category,
    Value<String?>? type,
    Value<String?>? description,
    Value<double?>? value,
  }) {
    return StolenPropertyCompanion(
      id: id ?? this.id,
      crimeId: crimeId ?? this.crimeId,
      category: category ?? this.category,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
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
          ..write('category: $category, ')
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
  static const VerificationMeta _officerDesignationMeta =
      const VerificationMeta('officerDesignation');
  @override
  late final GeneratedColumn<String> officerDesignation =
      GeneratedColumn<String>(
        'officer_designation',
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
  static const VerificationMeta _registeringOfficerNameMeta =
      const VerificationMeta('registeringOfficerName');
  @override
  late final GeneratedColumn<String> registeringOfficerName =
      GeneratedColumn<String>(
        'registering_officer_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _registeringOfficerRankMeta =
      const VerificationMeta('registeringOfficerRank');
  @override
  late final GeneratedColumn<String> registeringOfficerRank =
      GeneratedColumn<String>(
        'registering_officer_rank',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _registeringOfficerNoMeta =
      const VerificationMeta('registeringOfficerNo');
  @override
  late final GeneratedColumn<String> registeringOfficerNo =
      GeneratedColumn<String>(
        'registering_officer_no',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _actionTakenMeta = const VerificationMeta(
    'actionTaken',
  );
  @override
  late final GeneratedColumn<String> actionTaken = GeneratedColumn<String>(
    'action_taken',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _courtDispatchDateMeta = const VerificationMeta(
    'courtDispatchDate',
  );
  @override
  late final GeneratedColumn<DateTime> courtDispatchDate =
      GeneratedColumn<DateTime>(
        'court_dispatch_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _courtDispatchTimeMeta = const VerificationMeta(
    'courtDispatchTime',
  );
  @override
  late final GeneratedColumn<String> courtDispatchTime =
      GeneratedColumn<String>(
        'court_dispatch_time',
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
    officerDesignation,
    officerMobile,
    filedBy,
    preventiveAction,
    preventiveNo,
    preventiveDate,
    wantedAccused,
    registeringOfficerName,
    registeringOfficerRank,
    registeringOfficerNo,
    actionTaken,
    courtDispatchDate,
    courtDispatchTime,
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
    if (data.containsKey('officer_designation')) {
      context.handle(
        _officerDesignationMeta,
        officerDesignation.isAcceptableOrUnknown(
          data['officer_designation']!,
          _officerDesignationMeta,
        ),
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
    if (data.containsKey('registering_officer_name')) {
      context.handle(
        _registeringOfficerNameMeta,
        registeringOfficerName.isAcceptableOrUnknown(
          data['registering_officer_name']!,
          _registeringOfficerNameMeta,
        ),
      );
    }
    if (data.containsKey('registering_officer_rank')) {
      context.handle(
        _registeringOfficerRankMeta,
        registeringOfficerRank.isAcceptableOrUnknown(
          data['registering_officer_rank']!,
          _registeringOfficerRankMeta,
        ),
      );
    }
    if (data.containsKey('registering_officer_no')) {
      context.handle(
        _registeringOfficerNoMeta,
        registeringOfficerNo.isAcceptableOrUnknown(
          data['registering_officer_no']!,
          _registeringOfficerNoMeta,
        ),
      );
    }
    if (data.containsKey('action_taken')) {
      context.handle(
        _actionTakenMeta,
        actionTaken.isAcceptableOrUnknown(
          data['action_taken']!,
          _actionTakenMeta,
        ),
      );
    }
    if (data.containsKey('court_dispatch_date')) {
      context.handle(
        _courtDispatchDateMeta,
        courtDispatchDate.isAcceptableOrUnknown(
          data['court_dispatch_date']!,
          _courtDispatchDateMeta,
        ),
      );
    }
    if (data.containsKey('court_dispatch_time')) {
      context.handle(
        _courtDispatchTimeMeta,
        courtDispatchTime.isAcceptableOrUnknown(
          data['court_dispatch_time']!,
          _courtDispatchTimeMeta,
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
      officerDesignation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}officer_designation'],
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
      registeringOfficerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registering_officer_name'],
      ),
      registeringOfficerRank: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registering_officer_rank'],
      ),
      registeringOfficerNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registering_officer_no'],
      ),
      actionTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_taken'],
      ),
      courtDispatchDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}court_dispatch_date'],
      ),
      courtDispatchTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}court_dispatch_time'],
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
  final String? officerDesignation;
  final String? officerMobile;
  final String? filedBy;
  final String? preventiveAction;
  final String? preventiveNo;
  final DateTime? preventiveDate;
  final String? wantedAccused;
  final String? registeringOfficerName;
  final String? registeringOfficerRank;
  final String? registeringOfficerNo;
  final String? actionTaken;
  final DateTime? courtDispatchDate;
  final String? courtDispatchTime;
  const InvestigationData({
    required this.id,
    required this.crimeId,
    this.officerName,
    this.officerId,
    this.officerDesignation,
    this.officerMobile,
    this.filedBy,
    this.preventiveAction,
    this.preventiveNo,
    this.preventiveDate,
    this.wantedAccused,
    this.registeringOfficerName,
    this.registeringOfficerRank,
    this.registeringOfficerNo,
    this.actionTaken,
    this.courtDispatchDate,
    this.courtDispatchTime,
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
    if (!nullToAbsent || officerDesignation != null) {
      map['officer_designation'] = Variable<String>(officerDesignation);
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
    if (!nullToAbsent || registeringOfficerName != null) {
      map['registering_officer_name'] = Variable<String>(
        registeringOfficerName,
      );
    }
    if (!nullToAbsent || registeringOfficerRank != null) {
      map['registering_officer_rank'] = Variable<String>(
        registeringOfficerRank,
      );
    }
    if (!nullToAbsent || registeringOfficerNo != null) {
      map['registering_officer_no'] = Variable<String>(registeringOfficerNo);
    }
    if (!nullToAbsent || actionTaken != null) {
      map['action_taken'] = Variable<String>(actionTaken);
    }
    if (!nullToAbsent || courtDispatchDate != null) {
      map['court_dispatch_date'] = Variable<DateTime>(courtDispatchDate);
    }
    if (!nullToAbsent || courtDispatchTime != null) {
      map['court_dispatch_time'] = Variable<String>(courtDispatchTime);
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
      officerDesignation: officerDesignation == null && nullToAbsent
          ? const Value.absent()
          : Value(officerDesignation),
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
      registeringOfficerName: registeringOfficerName == null && nullToAbsent
          ? const Value.absent()
          : Value(registeringOfficerName),
      registeringOfficerRank: registeringOfficerRank == null && nullToAbsent
          ? const Value.absent()
          : Value(registeringOfficerRank),
      registeringOfficerNo: registeringOfficerNo == null && nullToAbsent
          ? const Value.absent()
          : Value(registeringOfficerNo),
      actionTaken: actionTaken == null && nullToAbsent
          ? const Value.absent()
          : Value(actionTaken),
      courtDispatchDate: courtDispatchDate == null && nullToAbsent
          ? const Value.absent()
          : Value(courtDispatchDate),
      courtDispatchTime: courtDispatchTime == null && nullToAbsent
          ? const Value.absent()
          : Value(courtDispatchTime),
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
      officerDesignation: serializer.fromJson<String?>(
        json['officerDesignation'],
      ),
      officerMobile: serializer.fromJson<String?>(json['officerMobile']),
      filedBy: serializer.fromJson<String?>(json['filedBy']),
      preventiveAction: serializer.fromJson<String?>(json['preventiveAction']),
      preventiveNo: serializer.fromJson<String?>(json['preventiveNo']),
      preventiveDate: serializer.fromJson<DateTime?>(json['preventiveDate']),
      wantedAccused: serializer.fromJson<String?>(json['wantedAccused']),
      registeringOfficerName: serializer.fromJson<String?>(
        json['registeringOfficerName'],
      ),
      registeringOfficerRank: serializer.fromJson<String?>(
        json['registeringOfficerRank'],
      ),
      registeringOfficerNo: serializer.fromJson<String?>(
        json['registeringOfficerNo'],
      ),
      actionTaken: serializer.fromJson<String?>(json['actionTaken']),
      courtDispatchDate: serializer.fromJson<DateTime?>(
        json['courtDispatchDate'],
      ),
      courtDispatchTime: serializer.fromJson<String?>(
        json['courtDispatchTime'],
      ),
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
      'officerDesignation': serializer.toJson<String?>(officerDesignation),
      'officerMobile': serializer.toJson<String?>(officerMobile),
      'filedBy': serializer.toJson<String?>(filedBy),
      'preventiveAction': serializer.toJson<String?>(preventiveAction),
      'preventiveNo': serializer.toJson<String?>(preventiveNo),
      'preventiveDate': serializer.toJson<DateTime?>(preventiveDate),
      'wantedAccused': serializer.toJson<String?>(wantedAccused),
      'registeringOfficerName': serializer.toJson<String?>(
        registeringOfficerName,
      ),
      'registeringOfficerRank': serializer.toJson<String?>(
        registeringOfficerRank,
      ),
      'registeringOfficerNo': serializer.toJson<String?>(registeringOfficerNo),
      'actionTaken': serializer.toJson<String?>(actionTaken),
      'courtDispatchDate': serializer.toJson<DateTime?>(courtDispatchDate),
      'courtDispatchTime': serializer.toJson<String?>(courtDispatchTime),
    };
  }

  InvestigationData copyWith({
    int? id,
    int? crimeId,
    Value<String?> officerName = const Value.absent(),
    Value<String?> officerId = const Value.absent(),
    Value<String?> officerDesignation = const Value.absent(),
    Value<String?> officerMobile = const Value.absent(),
    Value<String?> filedBy = const Value.absent(),
    Value<String?> preventiveAction = const Value.absent(),
    Value<String?> preventiveNo = const Value.absent(),
    Value<DateTime?> preventiveDate = const Value.absent(),
    Value<String?> wantedAccused = const Value.absent(),
    Value<String?> registeringOfficerName = const Value.absent(),
    Value<String?> registeringOfficerRank = const Value.absent(),
    Value<String?> registeringOfficerNo = const Value.absent(),
    Value<String?> actionTaken = const Value.absent(),
    Value<DateTime?> courtDispatchDate = const Value.absent(),
    Value<String?> courtDispatchTime = const Value.absent(),
  }) => InvestigationData(
    id: id ?? this.id,
    crimeId: crimeId ?? this.crimeId,
    officerName: officerName.present ? officerName.value : this.officerName,
    officerId: officerId.present ? officerId.value : this.officerId,
    officerDesignation: officerDesignation.present
        ? officerDesignation.value
        : this.officerDesignation,
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
    registeringOfficerName: registeringOfficerName.present
        ? registeringOfficerName.value
        : this.registeringOfficerName,
    registeringOfficerRank: registeringOfficerRank.present
        ? registeringOfficerRank.value
        : this.registeringOfficerRank,
    registeringOfficerNo: registeringOfficerNo.present
        ? registeringOfficerNo.value
        : this.registeringOfficerNo,
    actionTaken: actionTaken.present ? actionTaken.value : this.actionTaken,
    courtDispatchDate: courtDispatchDate.present
        ? courtDispatchDate.value
        : this.courtDispatchDate,
    courtDispatchTime: courtDispatchTime.present
        ? courtDispatchTime.value
        : this.courtDispatchTime,
  );
  InvestigationData copyWithCompanion(InvestigationCompanion data) {
    return InvestigationData(
      id: data.id.present ? data.id.value : this.id,
      crimeId: data.crimeId.present ? data.crimeId.value : this.crimeId,
      officerName: data.officerName.present
          ? data.officerName.value
          : this.officerName,
      officerId: data.officerId.present ? data.officerId.value : this.officerId,
      officerDesignation: data.officerDesignation.present
          ? data.officerDesignation.value
          : this.officerDesignation,
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
      registeringOfficerName: data.registeringOfficerName.present
          ? data.registeringOfficerName.value
          : this.registeringOfficerName,
      registeringOfficerRank: data.registeringOfficerRank.present
          ? data.registeringOfficerRank.value
          : this.registeringOfficerRank,
      registeringOfficerNo: data.registeringOfficerNo.present
          ? data.registeringOfficerNo.value
          : this.registeringOfficerNo,
      actionTaken: data.actionTaken.present
          ? data.actionTaken.value
          : this.actionTaken,
      courtDispatchDate: data.courtDispatchDate.present
          ? data.courtDispatchDate.value
          : this.courtDispatchDate,
      courtDispatchTime: data.courtDispatchTime.present
          ? data.courtDispatchTime.value
          : this.courtDispatchTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvestigationData(')
          ..write('id: $id, ')
          ..write('crimeId: $crimeId, ')
          ..write('officerName: $officerName, ')
          ..write('officerId: $officerId, ')
          ..write('officerDesignation: $officerDesignation, ')
          ..write('officerMobile: $officerMobile, ')
          ..write('filedBy: $filedBy, ')
          ..write('preventiveAction: $preventiveAction, ')
          ..write('preventiveNo: $preventiveNo, ')
          ..write('preventiveDate: $preventiveDate, ')
          ..write('wantedAccused: $wantedAccused, ')
          ..write('registeringOfficerName: $registeringOfficerName, ')
          ..write('registeringOfficerRank: $registeringOfficerRank, ')
          ..write('registeringOfficerNo: $registeringOfficerNo, ')
          ..write('actionTaken: $actionTaken, ')
          ..write('courtDispatchDate: $courtDispatchDate, ')
          ..write('courtDispatchTime: $courtDispatchTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    crimeId,
    officerName,
    officerId,
    officerDesignation,
    officerMobile,
    filedBy,
    preventiveAction,
    preventiveNo,
    preventiveDate,
    wantedAccused,
    registeringOfficerName,
    registeringOfficerRank,
    registeringOfficerNo,
    actionTaken,
    courtDispatchDate,
    courtDispatchTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvestigationData &&
          other.id == this.id &&
          other.crimeId == this.crimeId &&
          other.officerName == this.officerName &&
          other.officerId == this.officerId &&
          other.officerDesignation == this.officerDesignation &&
          other.officerMobile == this.officerMobile &&
          other.filedBy == this.filedBy &&
          other.preventiveAction == this.preventiveAction &&
          other.preventiveNo == this.preventiveNo &&
          other.preventiveDate == this.preventiveDate &&
          other.wantedAccused == this.wantedAccused &&
          other.registeringOfficerName == this.registeringOfficerName &&
          other.registeringOfficerRank == this.registeringOfficerRank &&
          other.registeringOfficerNo == this.registeringOfficerNo &&
          other.actionTaken == this.actionTaken &&
          other.courtDispatchDate == this.courtDispatchDate &&
          other.courtDispatchTime == this.courtDispatchTime);
}

class InvestigationCompanion extends UpdateCompanion<InvestigationData> {
  final Value<int> id;
  final Value<int> crimeId;
  final Value<String?> officerName;
  final Value<String?> officerId;
  final Value<String?> officerDesignation;
  final Value<String?> officerMobile;
  final Value<String?> filedBy;
  final Value<String?> preventiveAction;
  final Value<String?> preventiveNo;
  final Value<DateTime?> preventiveDate;
  final Value<String?> wantedAccused;
  final Value<String?> registeringOfficerName;
  final Value<String?> registeringOfficerRank;
  final Value<String?> registeringOfficerNo;
  final Value<String?> actionTaken;
  final Value<DateTime?> courtDispatchDate;
  final Value<String?> courtDispatchTime;
  const InvestigationCompanion({
    this.id = const Value.absent(),
    this.crimeId = const Value.absent(),
    this.officerName = const Value.absent(),
    this.officerId = const Value.absent(),
    this.officerDesignation = const Value.absent(),
    this.officerMobile = const Value.absent(),
    this.filedBy = const Value.absent(),
    this.preventiveAction = const Value.absent(),
    this.preventiveNo = const Value.absent(),
    this.preventiveDate = const Value.absent(),
    this.wantedAccused = const Value.absent(),
    this.registeringOfficerName = const Value.absent(),
    this.registeringOfficerRank = const Value.absent(),
    this.registeringOfficerNo = const Value.absent(),
    this.actionTaken = const Value.absent(),
    this.courtDispatchDate = const Value.absent(),
    this.courtDispatchTime = const Value.absent(),
  });
  InvestigationCompanion.insert({
    this.id = const Value.absent(),
    required int crimeId,
    this.officerName = const Value.absent(),
    this.officerId = const Value.absent(),
    this.officerDesignation = const Value.absent(),
    this.officerMobile = const Value.absent(),
    this.filedBy = const Value.absent(),
    this.preventiveAction = const Value.absent(),
    this.preventiveNo = const Value.absent(),
    this.preventiveDate = const Value.absent(),
    this.wantedAccused = const Value.absent(),
    this.registeringOfficerName = const Value.absent(),
    this.registeringOfficerRank = const Value.absent(),
    this.registeringOfficerNo = const Value.absent(),
    this.actionTaken = const Value.absent(),
    this.courtDispatchDate = const Value.absent(),
    this.courtDispatchTime = const Value.absent(),
  }) : crimeId = Value(crimeId);
  static Insertable<InvestigationData> custom({
    Expression<int>? id,
    Expression<int>? crimeId,
    Expression<String>? officerName,
    Expression<String>? officerId,
    Expression<String>? officerDesignation,
    Expression<String>? officerMobile,
    Expression<String>? filedBy,
    Expression<String>? preventiveAction,
    Expression<String>? preventiveNo,
    Expression<DateTime>? preventiveDate,
    Expression<String>? wantedAccused,
    Expression<String>? registeringOfficerName,
    Expression<String>? registeringOfficerRank,
    Expression<String>? registeringOfficerNo,
    Expression<String>? actionTaken,
    Expression<DateTime>? courtDispatchDate,
    Expression<String>? courtDispatchTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crimeId != null) 'crime_id': crimeId,
      if (officerName != null) 'officer_name': officerName,
      if (officerId != null) 'officer_id': officerId,
      if (officerDesignation != null) 'officer_designation': officerDesignation,
      if (officerMobile != null) 'officer_mobile': officerMobile,
      if (filedBy != null) 'filed_by': filedBy,
      if (preventiveAction != null) 'preventive_action': preventiveAction,
      if (preventiveNo != null) 'preventive_no': preventiveNo,
      if (preventiveDate != null) 'preventive_date': preventiveDate,
      if (wantedAccused != null) 'wanted_accused': wantedAccused,
      if (registeringOfficerName != null)
        'registering_officer_name': registeringOfficerName,
      if (registeringOfficerRank != null)
        'registering_officer_rank': registeringOfficerRank,
      if (registeringOfficerNo != null)
        'registering_officer_no': registeringOfficerNo,
      if (actionTaken != null) 'action_taken': actionTaken,
      if (courtDispatchDate != null) 'court_dispatch_date': courtDispatchDate,
      if (courtDispatchTime != null) 'court_dispatch_time': courtDispatchTime,
    });
  }

  InvestigationCompanion copyWith({
    Value<int>? id,
    Value<int>? crimeId,
    Value<String?>? officerName,
    Value<String?>? officerId,
    Value<String?>? officerDesignation,
    Value<String?>? officerMobile,
    Value<String?>? filedBy,
    Value<String?>? preventiveAction,
    Value<String?>? preventiveNo,
    Value<DateTime?>? preventiveDate,
    Value<String?>? wantedAccused,
    Value<String?>? registeringOfficerName,
    Value<String?>? registeringOfficerRank,
    Value<String?>? registeringOfficerNo,
    Value<String?>? actionTaken,
    Value<DateTime?>? courtDispatchDate,
    Value<String?>? courtDispatchTime,
  }) {
    return InvestigationCompanion(
      id: id ?? this.id,
      crimeId: crimeId ?? this.crimeId,
      officerName: officerName ?? this.officerName,
      officerId: officerId ?? this.officerId,
      officerDesignation: officerDesignation ?? this.officerDesignation,
      officerMobile: officerMobile ?? this.officerMobile,
      filedBy: filedBy ?? this.filedBy,
      preventiveAction: preventiveAction ?? this.preventiveAction,
      preventiveNo: preventiveNo ?? this.preventiveNo,
      preventiveDate: preventiveDate ?? this.preventiveDate,
      wantedAccused: wantedAccused ?? this.wantedAccused,
      registeringOfficerName:
          registeringOfficerName ?? this.registeringOfficerName,
      registeringOfficerRank:
          registeringOfficerRank ?? this.registeringOfficerRank,
      registeringOfficerNo: registeringOfficerNo ?? this.registeringOfficerNo,
      actionTaken: actionTaken ?? this.actionTaken,
      courtDispatchDate: courtDispatchDate ?? this.courtDispatchDate,
      courtDispatchTime: courtDispatchTime ?? this.courtDispatchTime,
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
    if (officerDesignation.present) {
      map['officer_designation'] = Variable<String>(officerDesignation.value);
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
    if (registeringOfficerName.present) {
      map['registering_officer_name'] = Variable<String>(
        registeringOfficerName.value,
      );
    }
    if (registeringOfficerRank.present) {
      map['registering_officer_rank'] = Variable<String>(
        registeringOfficerRank.value,
      );
    }
    if (registeringOfficerNo.present) {
      map['registering_officer_no'] = Variable<String>(
        registeringOfficerNo.value,
      );
    }
    if (actionTaken.present) {
      map['action_taken'] = Variable<String>(actionTaken.value);
    }
    if (courtDispatchDate.present) {
      map['court_dispatch_date'] = Variable<DateTime>(courtDispatchDate.value);
    }
    if (courtDispatchTime.present) {
      map['court_dispatch_time'] = Variable<String>(courtDispatchTime.value);
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
          ..write('officerDesignation: $officerDesignation, ')
          ..write('officerMobile: $officerMobile, ')
          ..write('filedBy: $filedBy, ')
          ..write('preventiveAction: $preventiveAction, ')
          ..write('preventiveNo: $preventiveNo, ')
          ..write('preventiveDate: $preventiveDate, ')
          ..write('wantedAccused: $wantedAccused, ')
          ..write('registeringOfficerName: $registeringOfficerName, ')
          ..write('registeringOfficerRank: $registeringOfficerRank, ')
          ..write('registeringOfficerNo: $registeringOfficerNo, ')
          ..write('actionTaken: $actionTaken, ')
          ..write('courtDispatchDate: $courtDispatchDate, ')
          ..write('courtDispatchTime: $courtDispatchTime')
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

class $IoCasesTable extends IoCases with TableInfo<$IoCasesTable, IoCase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IoCasesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _remoteUidMeta = const VerificationMeta(
    'remoteUid',
  );
  @override
  late final GeneratedColumn<String> remoteUid = GeneratedColumn<String>(
    'remote_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
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
  static const VerificationMeta _crimeCategoryMeta = const VerificationMeta(
    'crimeCategory',
  );
  @override
  late final GeneratedColumn<String> crimeCategory = GeneratedColumn<String>(
    'crime_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firNoMeta = const VerificationMeta('firNo');
  @override
  late final GeneratedColumn<String> firNo = GeneratedColumn<String>(
    'fir_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
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
  static const VerificationMeta _linkedCrimeUidMeta = const VerificationMeta(
    'linkedCrimeUid',
  );
  @override
  late final GeneratedColumn<String> linkedCrimeUid = GeneratedColumn<String>(
    'linked_crime_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerEmailMeta = const VerificationMeta(
    'ownerEmail',
  );
  @override
  late final GeneratedColumn<String> ownerEmail = GeneratedColumn<String>(
    'owner_email',
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
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
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
    remoteUid,
    title,
    crimeType,
    crimeCategory,
    firNo,
    year,
    district,
    policeStation,
    linkedCrimeUid,
    ownerEmail,
    status,
    dataJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'io_cases';
  @override
  VerificationContext validateIntegrity(
    Insertable<IoCase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_uid')) {
      context.handle(
        _remoteUidMeta,
        remoteUid.isAcceptableOrUnknown(data['remote_uid']!, _remoteUidMeta),
      );
    } else if (isInserting) {
      context.missing(_remoteUidMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('crime_type')) {
      context.handle(
        _crimeTypeMeta,
        crimeType.isAcceptableOrUnknown(data['crime_type']!, _crimeTypeMeta),
      );
    }
    if (data.containsKey('crime_category')) {
      context.handle(
        _crimeCategoryMeta,
        crimeCategory.isAcceptableOrUnknown(
          data['crime_category']!,
          _crimeCategoryMeta,
        ),
      );
    }
    if (data.containsKey('fir_no')) {
      context.handle(
        _firNoMeta,
        firNo.isAcceptableOrUnknown(data['fir_no']!, _firNoMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
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
    if (data.containsKey('linked_crime_uid')) {
      context.handle(
        _linkedCrimeUidMeta,
        linkedCrimeUid.isAcceptableOrUnknown(
          data['linked_crime_uid']!,
          _linkedCrimeUidMeta,
        ),
      );
    }
    if (data.containsKey('owner_email')) {
      context.handle(
        _ownerEmailMeta,
        ownerEmail.isAcceptableOrUnknown(data['owner_email']!, _ownerEmailMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
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
  IoCase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IoCase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_uid'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      crimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crime_type'],
      ),
      crimeCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crime_category'],
      ),
      firNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fir_no'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      district: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}district'],
      ),
      policeStation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}police_station'],
      ),
      linkedCrimeUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_crime_uid'],
      ),
      ownerEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_email'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
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
  $IoCasesTable createAlias(String alias) {
    return $IoCasesTable(attachedDatabase, alias);
  }
}

class IoCase extends DataClass implements Insertable<IoCase> {
  final int id;

  /// Stable, globally-unique case id (`io_<random hex>`) used as the identity on
  /// the central server for phone↔PC sync. Generated once, never reused.
  final String remoteUid;

  /// Display title (e.g. "गुन्हा रजि.नं 123/2026 — चोरी"). Optional; derived when blank.
  final String? title;

  /// Crime classification driving which forms apply. [crimeType] is the full
  /// "English / Marathi" label; [crimeCategory] is its parent category label.
  final String? crimeType;
  final String? crimeCategory;

  /// FIR identity (when known). A fresh case may leave these blank until filed.
  final String? firNo;
  final int? year;
  final String? district;
  final String? policeStation;

  /// When the case was opened from an existing central FIR, its remote_uid — so
  /// the two stay associated. Null for a fresh (scene-first) case.
  final String? linkedCrimeUid;

  /// The IO who owns the case (Google account email). Used for "own cases only".
  final String? ownerEmail;

  /// active | closed.
  final String status;

  /// Case-level shared data (a JSON map) — every field the government forms need
  /// that isn't per-person / per-exhibit: FIR header extras, death/PM details,
  /// medical, DNA, juvenile, final-report, modus-operandi, etc. Entered once and
  /// read by all the auto-filled forms. Per-person deep fields live on the
  /// party's valuesJson; per-item fields on the exhibit's valuesJson.
  final String? dataJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const IoCase({
    required this.id,
    required this.remoteUid,
    this.title,
    this.crimeType,
    this.crimeCategory,
    this.firNo,
    this.year,
    this.district,
    this.policeStation,
    this.linkedCrimeUid,
    this.ownerEmail,
    required this.status,
    this.dataJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_uid'] = Variable<String>(remoteUid);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || crimeType != null) {
      map['crime_type'] = Variable<String>(crimeType);
    }
    if (!nullToAbsent || crimeCategory != null) {
      map['crime_category'] = Variable<String>(crimeCategory);
    }
    if (!nullToAbsent || firNo != null) {
      map['fir_no'] = Variable<String>(firNo);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || district != null) {
      map['district'] = Variable<String>(district);
    }
    if (!nullToAbsent || policeStation != null) {
      map['police_station'] = Variable<String>(policeStation);
    }
    if (!nullToAbsent || linkedCrimeUid != null) {
      map['linked_crime_uid'] = Variable<String>(linkedCrimeUid);
    }
    if (!nullToAbsent || ownerEmail != null) {
      map['owner_email'] = Variable<String>(ownerEmail);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || dataJson != null) {
      map['data_json'] = Variable<String>(dataJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IoCasesCompanion toCompanion(bool nullToAbsent) {
    return IoCasesCompanion(
      id: Value(id),
      remoteUid: Value(remoteUid),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      crimeType: crimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(crimeType),
      crimeCategory: crimeCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(crimeCategory),
      firNo: firNo == null && nullToAbsent
          ? const Value.absent()
          : Value(firNo),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      district: district == null && nullToAbsent
          ? const Value.absent()
          : Value(district),
      policeStation: policeStation == null && nullToAbsent
          ? const Value.absent()
          : Value(policeStation),
      linkedCrimeUid: linkedCrimeUid == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedCrimeUid),
      ownerEmail: ownerEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerEmail),
      status: Value(status),
      dataJson: dataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(dataJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory IoCase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IoCase(
      id: serializer.fromJson<int>(json['id']),
      remoteUid: serializer.fromJson<String>(json['remoteUid']),
      title: serializer.fromJson<String?>(json['title']),
      crimeType: serializer.fromJson<String?>(json['crimeType']),
      crimeCategory: serializer.fromJson<String?>(json['crimeCategory']),
      firNo: serializer.fromJson<String?>(json['firNo']),
      year: serializer.fromJson<int?>(json['year']),
      district: serializer.fromJson<String?>(json['district']),
      policeStation: serializer.fromJson<String?>(json['policeStation']),
      linkedCrimeUid: serializer.fromJson<String?>(json['linkedCrimeUid']),
      ownerEmail: serializer.fromJson<String?>(json['ownerEmail']),
      status: serializer.fromJson<String>(json['status']),
      dataJson: serializer.fromJson<String?>(json['dataJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteUid': serializer.toJson<String>(remoteUid),
      'title': serializer.toJson<String?>(title),
      'crimeType': serializer.toJson<String?>(crimeType),
      'crimeCategory': serializer.toJson<String?>(crimeCategory),
      'firNo': serializer.toJson<String?>(firNo),
      'year': serializer.toJson<int?>(year),
      'district': serializer.toJson<String?>(district),
      'policeStation': serializer.toJson<String?>(policeStation),
      'linkedCrimeUid': serializer.toJson<String?>(linkedCrimeUid),
      'ownerEmail': serializer.toJson<String?>(ownerEmail),
      'status': serializer.toJson<String>(status),
      'dataJson': serializer.toJson<String?>(dataJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  IoCase copyWith({
    int? id,
    String? remoteUid,
    Value<String?> title = const Value.absent(),
    Value<String?> crimeType = const Value.absent(),
    Value<String?> crimeCategory = const Value.absent(),
    Value<String?> firNo = const Value.absent(),
    Value<int?> year = const Value.absent(),
    Value<String?> district = const Value.absent(),
    Value<String?> policeStation = const Value.absent(),
    Value<String?> linkedCrimeUid = const Value.absent(),
    Value<String?> ownerEmail = const Value.absent(),
    String? status,
    Value<String?> dataJson = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => IoCase(
    id: id ?? this.id,
    remoteUid: remoteUid ?? this.remoteUid,
    title: title.present ? title.value : this.title,
    crimeType: crimeType.present ? crimeType.value : this.crimeType,
    crimeCategory: crimeCategory.present
        ? crimeCategory.value
        : this.crimeCategory,
    firNo: firNo.present ? firNo.value : this.firNo,
    year: year.present ? year.value : this.year,
    district: district.present ? district.value : this.district,
    policeStation: policeStation.present
        ? policeStation.value
        : this.policeStation,
    linkedCrimeUid: linkedCrimeUid.present
        ? linkedCrimeUid.value
        : this.linkedCrimeUid,
    ownerEmail: ownerEmail.present ? ownerEmail.value : this.ownerEmail,
    status: status ?? this.status,
    dataJson: dataJson.present ? dataJson.value : this.dataJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  IoCase copyWithCompanion(IoCasesCompanion data) {
    return IoCase(
      id: data.id.present ? data.id.value : this.id,
      remoteUid: data.remoteUid.present ? data.remoteUid.value : this.remoteUid,
      title: data.title.present ? data.title.value : this.title,
      crimeType: data.crimeType.present ? data.crimeType.value : this.crimeType,
      crimeCategory: data.crimeCategory.present
          ? data.crimeCategory.value
          : this.crimeCategory,
      firNo: data.firNo.present ? data.firNo.value : this.firNo,
      year: data.year.present ? data.year.value : this.year,
      district: data.district.present ? data.district.value : this.district,
      policeStation: data.policeStation.present
          ? data.policeStation.value
          : this.policeStation,
      linkedCrimeUid: data.linkedCrimeUid.present
          ? data.linkedCrimeUid.value
          : this.linkedCrimeUid,
      ownerEmail: data.ownerEmail.present
          ? data.ownerEmail.value
          : this.ownerEmail,
      status: data.status.present ? data.status.value : this.status,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IoCase(')
          ..write('id: $id, ')
          ..write('remoteUid: $remoteUid, ')
          ..write('title: $title, ')
          ..write('crimeType: $crimeType, ')
          ..write('crimeCategory: $crimeCategory, ')
          ..write('firNo: $firNo, ')
          ..write('year: $year, ')
          ..write('district: $district, ')
          ..write('policeStation: $policeStation, ')
          ..write('linkedCrimeUid: $linkedCrimeUid, ')
          ..write('ownerEmail: $ownerEmail, ')
          ..write('status: $status, ')
          ..write('dataJson: $dataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteUid,
    title,
    crimeType,
    crimeCategory,
    firNo,
    year,
    district,
    policeStation,
    linkedCrimeUid,
    ownerEmail,
    status,
    dataJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IoCase &&
          other.id == this.id &&
          other.remoteUid == this.remoteUid &&
          other.title == this.title &&
          other.crimeType == this.crimeType &&
          other.crimeCategory == this.crimeCategory &&
          other.firNo == this.firNo &&
          other.year == this.year &&
          other.district == this.district &&
          other.policeStation == this.policeStation &&
          other.linkedCrimeUid == this.linkedCrimeUid &&
          other.ownerEmail == this.ownerEmail &&
          other.status == this.status &&
          other.dataJson == this.dataJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class IoCasesCompanion extends UpdateCompanion<IoCase> {
  final Value<int> id;
  final Value<String> remoteUid;
  final Value<String?> title;
  final Value<String?> crimeType;
  final Value<String?> crimeCategory;
  final Value<String?> firNo;
  final Value<int?> year;
  final Value<String?> district;
  final Value<String?> policeStation;
  final Value<String?> linkedCrimeUid;
  final Value<String?> ownerEmail;
  final Value<String> status;
  final Value<String?> dataJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const IoCasesCompanion({
    this.id = const Value.absent(),
    this.remoteUid = const Value.absent(),
    this.title = const Value.absent(),
    this.crimeType = const Value.absent(),
    this.crimeCategory = const Value.absent(),
    this.firNo = const Value.absent(),
    this.year = const Value.absent(),
    this.district = const Value.absent(),
    this.policeStation = const Value.absent(),
    this.linkedCrimeUid = const Value.absent(),
    this.ownerEmail = const Value.absent(),
    this.status = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  IoCasesCompanion.insert({
    this.id = const Value.absent(),
    required String remoteUid,
    this.title = const Value.absent(),
    this.crimeType = const Value.absent(),
    this.crimeCategory = const Value.absent(),
    this.firNo = const Value.absent(),
    this.year = const Value.absent(),
    this.district = const Value.absent(),
    this.policeStation = const Value.absent(),
    this.linkedCrimeUid = const Value.absent(),
    this.ownerEmail = const Value.absent(),
    this.status = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : remoteUid = Value(remoteUid);
  static Insertable<IoCase> custom({
    Expression<int>? id,
    Expression<String>? remoteUid,
    Expression<String>? title,
    Expression<String>? crimeType,
    Expression<String>? crimeCategory,
    Expression<String>? firNo,
    Expression<int>? year,
    Expression<String>? district,
    Expression<String>? policeStation,
    Expression<String>? linkedCrimeUid,
    Expression<String>? ownerEmail,
    Expression<String>? status,
    Expression<String>? dataJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteUid != null) 'remote_uid': remoteUid,
      if (title != null) 'title': title,
      if (crimeType != null) 'crime_type': crimeType,
      if (crimeCategory != null) 'crime_category': crimeCategory,
      if (firNo != null) 'fir_no': firNo,
      if (year != null) 'year': year,
      if (district != null) 'district': district,
      if (policeStation != null) 'police_station': policeStation,
      if (linkedCrimeUid != null) 'linked_crime_uid': linkedCrimeUid,
      if (ownerEmail != null) 'owner_email': ownerEmail,
      if (status != null) 'status': status,
      if (dataJson != null) 'data_json': dataJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  IoCasesCompanion copyWith({
    Value<int>? id,
    Value<String>? remoteUid,
    Value<String?>? title,
    Value<String?>? crimeType,
    Value<String?>? crimeCategory,
    Value<String?>? firNo,
    Value<int?>? year,
    Value<String?>? district,
    Value<String?>? policeStation,
    Value<String?>? linkedCrimeUid,
    Value<String?>? ownerEmail,
    Value<String>? status,
    Value<String?>? dataJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return IoCasesCompanion(
      id: id ?? this.id,
      remoteUid: remoteUid ?? this.remoteUid,
      title: title ?? this.title,
      crimeType: crimeType ?? this.crimeType,
      crimeCategory: crimeCategory ?? this.crimeCategory,
      firNo: firNo ?? this.firNo,
      year: year ?? this.year,
      district: district ?? this.district,
      policeStation: policeStation ?? this.policeStation,
      linkedCrimeUid: linkedCrimeUid ?? this.linkedCrimeUid,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      status: status ?? this.status,
      dataJson: dataJson ?? this.dataJson,
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
    if (remoteUid.present) {
      map['remote_uid'] = Variable<String>(remoteUid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (crimeType.present) {
      map['crime_type'] = Variable<String>(crimeType.value);
    }
    if (crimeCategory.present) {
      map['crime_category'] = Variable<String>(crimeCategory.value);
    }
    if (firNo.present) {
      map['fir_no'] = Variable<String>(firNo.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (policeStation.present) {
      map['police_station'] = Variable<String>(policeStation.value);
    }
    if (linkedCrimeUid.present) {
      map['linked_crime_uid'] = Variable<String>(linkedCrimeUid.value);
    }
    if (ownerEmail.present) {
      map['owner_email'] = Variable<String>(ownerEmail.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
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
    return (StringBuffer('IoCasesCompanion(')
          ..write('id: $id, ')
          ..write('remoteUid: $remoteUid, ')
          ..write('title: $title, ')
          ..write('crimeType: $crimeType, ')
          ..write('crimeCategory: $crimeCategory, ')
          ..write('firNo: $firNo, ')
          ..write('year: $year, ')
          ..write('district: $district, ')
          ..write('policeStation: $policeStation, ')
          ..write('linkedCrimeUid: $linkedCrimeUid, ')
          ..write('ownerEmail: $ownerEmail, ')
          ..write('status: $status, ')
          ..write('dataJson: $dataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $IoPartiesTable extends IoParties
    with TableInfo<$IoPartiesTable, IoParty> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IoPartiesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<int> caseId = GeneratedColumn<int>(
    'case_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES io_cases (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _valuesJsonMeta = const VerificationMeta(
    'valuesJson',
  );
  @override
  late final GeneratedColumn<String> valuesJson = GeneratedColumn<String>(
    'values_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    caseId,
    role,
    name,
    valuesJson,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'io_parties';
  @override
  VerificationContext validateIntegrity(
    Insertable<IoParty> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('case_id')) {
      context.handle(
        _caseIdMeta,
        caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_caseIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('values_json')) {
      context.handle(
        _valuesJsonMeta,
        valuesJson.isAcceptableOrUnknown(data['values_json']!, _valuesJsonMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IoParty map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IoParty(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      caseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}case_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      valuesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}values_json'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $IoPartiesTable createAlias(String alias) {
    return $IoPartiesTable(attachedDatabase, alias);
  }
}

class IoParty extends DataClass implements Insertable<IoParty> {
  final int id;
  final int caseId;

  /// panch | complainant | accused | deceased | witness | io.
  final String role;
  final String name;

  /// Extra structured fields (father/husband, age, address, mobile, occupation,
  /// idType/idNumber, thumbPhotoPath, encrypted id blobs, …) as a JSON map.
  final String? valuesJson;
  final int sortOrder;
  const IoParty({
    required this.id,
    required this.caseId,
    required this.role,
    required this.name,
    this.valuesJson,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['case_id'] = Variable<int>(caseId);
    map['role'] = Variable<String>(role);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || valuesJson != null) {
      map['values_json'] = Variable<String>(valuesJson);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  IoPartiesCompanion toCompanion(bool nullToAbsent) {
    return IoPartiesCompanion(
      id: Value(id),
      caseId: Value(caseId),
      role: Value(role),
      name: Value(name),
      valuesJson: valuesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(valuesJson),
      sortOrder: Value(sortOrder),
    );
  }

  factory IoParty.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IoParty(
      id: serializer.fromJson<int>(json['id']),
      caseId: serializer.fromJson<int>(json['caseId']),
      role: serializer.fromJson<String>(json['role']),
      name: serializer.fromJson<String>(json['name']),
      valuesJson: serializer.fromJson<String?>(json['valuesJson']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'caseId': serializer.toJson<int>(caseId),
      'role': serializer.toJson<String>(role),
      'name': serializer.toJson<String>(name),
      'valuesJson': serializer.toJson<String?>(valuesJson),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  IoParty copyWith({
    int? id,
    int? caseId,
    String? role,
    String? name,
    Value<String?> valuesJson = const Value.absent(),
    int? sortOrder,
  }) => IoParty(
    id: id ?? this.id,
    caseId: caseId ?? this.caseId,
    role: role ?? this.role,
    name: name ?? this.name,
    valuesJson: valuesJson.present ? valuesJson.value : this.valuesJson,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  IoParty copyWithCompanion(IoPartiesCompanion data) {
    return IoParty(
      id: data.id.present ? data.id.value : this.id,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      role: data.role.present ? data.role.value : this.role,
      name: data.name.present ? data.name.value : this.name,
      valuesJson: data.valuesJson.present
          ? data.valuesJson.value
          : this.valuesJson,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IoParty(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('role: $role, ')
          ..write('name: $name, ')
          ..write('valuesJson: $valuesJson, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, caseId, role, name, valuesJson, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IoParty &&
          other.id == this.id &&
          other.caseId == this.caseId &&
          other.role == this.role &&
          other.name == this.name &&
          other.valuesJson == this.valuesJson &&
          other.sortOrder == this.sortOrder);
}

class IoPartiesCompanion extends UpdateCompanion<IoParty> {
  final Value<int> id;
  final Value<int> caseId;
  final Value<String> role;
  final Value<String> name;
  final Value<String?> valuesJson;
  final Value<int> sortOrder;
  const IoPartiesCompanion({
    this.id = const Value.absent(),
    this.caseId = const Value.absent(),
    this.role = const Value.absent(),
    this.name = const Value.absent(),
    this.valuesJson = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  IoPartiesCompanion.insert({
    this.id = const Value.absent(),
    required int caseId,
    required String role,
    required String name,
    this.valuesJson = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : caseId = Value(caseId),
       role = Value(role),
       name = Value(name);
  static Insertable<IoParty> custom({
    Expression<int>? id,
    Expression<int>? caseId,
    Expression<String>? role,
    Expression<String>? name,
    Expression<String>? valuesJson,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (caseId != null) 'case_id': caseId,
      if (role != null) 'role': role,
      if (name != null) 'name': name,
      if (valuesJson != null) 'values_json': valuesJson,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  IoPartiesCompanion copyWith({
    Value<int>? id,
    Value<int>? caseId,
    Value<String>? role,
    Value<String>? name,
    Value<String?>? valuesJson,
    Value<int>? sortOrder,
  }) {
    return IoPartiesCompanion(
      id: id ?? this.id,
      caseId: caseId ?? this.caseId,
      role: role ?? this.role,
      name: name ?? this.name,
      valuesJson: valuesJson ?? this.valuesJson,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (caseId.present) {
      map['case_id'] = Variable<int>(caseId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (valuesJson.present) {
      map['values_json'] = Variable<String>(valuesJson.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IoPartiesCompanion(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('role: $role, ')
          ..write('name: $name, ')
          ..write('valuesJson: $valuesJson, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $IoExhibitsTable extends IoExhibits
    with TableInfo<$IoExhibitsTable, IoExhibit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IoExhibitsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<int> caseId = GeneratedColumn<int>(
    'case_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES io_cases (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seizedFromMeta = const VerificationMeta(
    'seizedFrom',
  );
  @override
  late final GeneratedColumn<String> seizedFrom = GeneratedColumn<String>(
    'seized_from',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exhibitNoMeta = const VerificationMeta(
    'exhibitNo',
  );
  @override
  late final GeneratedColumn<String> exhibitNo = GeneratedColumn<String>(
    'exhibit_no',
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
  static const VerificationMeta _valuesJsonMeta = const VerificationMeta(
    'valuesJson',
  );
  @override
  late final GeneratedColumn<String> valuesJson = GeneratedColumn<String>(
    'values_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    caseId,
    description,
    category,
    seizedFrom,
    exhibitNo,
    value,
    valuesJson,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'io_exhibits';
  @override
  VerificationContext validateIntegrity(
    Insertable<IoExhibit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('case_id')) {
      context.handle(
        _caseIdMeta,
        caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_caseIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('seized_from')) {
      context.handle(
        _seizedFromMeta,
        seizedFrom.isAcceptableOrUnknown(data['seized_from']!, _seizedFromMeta),
      );
    }
    if (data.containsKey('exhibit_no')) {
      context.handle(
        _exhibitNoMeta,
        exhibitNo.isAcceptableOrUnknown(data['exhibit_no']!, _exhibitNoMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('values_json')) {
      context.handle(
        _valuesJsonMeta,
        valuesJson.isAcceptableOrUnknown(data['values_json']!, _valuesJsonMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IoExhibit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IoExhibit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      caseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}case_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      seizedFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seized_from'],
      ),
      exhibitNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exhibit_no'],
      ),
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      ),
      valuesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}values_json'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $IoExhibitsTable createAlias(String alias) {
    return $IoExhibitsTable(attachedDatabase, alias);
  }
}

class IoExhibit extends DataClass implements Insertable<IoExhibit> {
  final int id;
  final int caseId;
  final String description;

  /// Category (two-wheeler / four-wheeler / jewellery / mobile / cash / other) to
  /// drive specialised labels (e.g. mobile-seal form) and report bucketing.
  final String? category;
  final String? seizedFrom;
  final String? exhibitNo;
  final double? value;

  /// Extra fields (make/model, IMEI, colour, marks, sealNo, …) as a JSON map.
  final String? valuesJson;
  final int sortOrder;
  const IoExhibit({
    required this.id,
    required this.caseId,
    required this.description,
    this.category,
    this.seizedFrom,
    this.exhibitNo,
    this.value,
    this.valuesJson,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['case_id'] = Variable<int>(caseId);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || seizedFrom != null) {
      map['seized_from'] = Variable<String>(seizedFrom);
    }
    if (!nullToAbsent || exhibitNo != null) {
      map['exhibit_no'] = Variable<String>(exhibitNo);
    }
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double>(value);
    }
    if (!nullToAbsent || valuesJson != null) {
      map['values_json'] = Variable<String>(valuesJson);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  IoExhibitsCompanion toCompanion(bool nullToAbsent) {
    return IoExhibitsCompanion(
      id: Value(id),
      caseId: Value(caseId),
      description: Value(description),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      seizedFrom: seizedFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(seizedFrom),
      exhibitNo: exhibitNo == null && nullToAbsent
          ? const Value.absent()
          : Value(exhibitNo),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      valuesJson: valuesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(valuesJson),
      sortOrder: Value(sortOrder),
    );
  }

  factory IoExhibit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IoExhibit(
      id: serializer.fromJson<int>(json['id']),
      caseId: serializer.fromJson<int>(json['caseId']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String?>(json['category']),
      seizedFrom: serializer.fromJson<String?>(json['seizedFrom']),
      exhibitNo: serializer.fromJson<String?>(json['exhibitNo']),
      value: serializer.fromJson<double?>(json['value']),
      valuesJson: serializer.fromJson<String?>(json['valuesJson']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'caseId': serializer.toJson<int>(caseId),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String?>(category),
      'seizedFrom': serializer.toJson<String?>(seizedFrom),
      'exhibitNo': serializer.toJson<String?>(exhibitNo),
      'value': serializer.toJson<double?>(value),
      'valuesJson': serializer.toJson<String?>(valuesJson),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  IoExhibit copyWith({
    int? id,
    int? caseId,
    String? description,
    Value<String?> category = const Value.absent(),
    Value<String?> seizedFrom = const Value.absent(),
    Value<String?> exhibitNo = const Value.absent(),
    Value<double?> value = const Value.absent(),
    Value<String?> valuesJson = const Value.absent(),
    int? sortOrder,
  }) => IoExhibit(
    id: id ?? this.id,
    caseId: caseId ?? this.caseId,
    description: description ?? this.description,
    category: category.present ? category.value : this.category,
    seizedFrom: seizedFrom.present ? seizedFrom.value : this.seizedFrom,
    exhibitNo: exhibitNo.present ? exhibitNo.value : this.exhibitNo,
    value: value.present ? value.value : this.value,
    valuesJson: valuesJson.present ? valuesJson.value : this.valuesJson,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  IoExhibit copyWithCompanion(IoExhibitsCompanion data) {
    return IoExhibit(
      id: data.id.present ? data.id.value : this.id,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      seizedFrom: data.seizedFrom.present
          ? data.seizedFrom.value
          : this.seizedFrom,
      exhibitNo: data.exhibitNo.present ? data.exhibitNo.value : this.exhibitNo,
      value: data.value.present ? data.value.value : this.value,
      valuesJson: data.valuesJson.present
          ? data.valuesJson.value
          : this.valuesJson,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IoExhibit(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('seizedFrom: $seizedFrom, ')
          ..write('exhibitNo: $exhibitNo, ')
          ..write('value: $value, ')
          ..write('valuesJson: $valuesJson, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    caseId,
    description,
    category,
    seizedFrom,
    exhibitNo,
    value,
    valuesJson,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IoExhibit &&
          other.id == this.id &&
          other.caseId == this.caseId &&
          other.description == this.description &&
          other.category == this.category &&
          other.seizedFrom == this.seizedFrom &&
          other.exhibitNo == this.exhibitNo &&
          other.value == this.value &&
          other.valuesJson == this.valuesJson &&
          other.sortOrder == this.sortOrder);
}

class IoExhibitsCompanion extends UpdateCompanion<IoExhibit> {
  final Value<int> id;
  final Value<int> caseId;
  final Value<String> description;
  final Value<String?> category;
  final Value<String?> seizedFrom;
  final Value<String?> exhibitNo;
  final Value<double?> value;
  final Value<String?> valuesJson;
  final Value<int> sortOrder;
  const IoExhibitsCompanion({
    this.id = const Value.absent(),
    this.caseId = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.seizedFrom = const Value.absent(),
    this.exhibitNo = const Value.absent(),
    this.value = const Value.absent(),
    this.valuesJson = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  IoExhibitsCompanion.insert({
    this.id = const Value.absent(),
    required int caseId,
    required String description,
    this.category = const Value.absent(),
    this.seizedFrom = const Value.absent(),
    this.exhibitNo = const Value.absent(),
    this.value = const Value.absent(),
    this.valuesJson = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : caseId = Value(caseId),
       description = Value(description);
  static Insertable<IoExhibit> custom({
    Expression<int>? id,
    Expression<int>? caseId,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? seizedFrom,
    Expression<String>? exhibitNo,
    Expression<double>? value,
    Expression<String>? valuesJson,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (caseId != null) 'case_id': caseId,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (seizedFrom != null) 'seized_from': seizedFrom,
      if (exhibitNo != null) 'exhibit_no': exhibitNo,
      if (value != null) 'value': value,
      if (valuesJson != null) 'values_json': valuesJson,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  IoExhibitsCompanion copyWith({
    Value<int>? id,
    Value<int>? caseId,
    Value<String>? description,
    Value<String?>? category,
    Value<String?>? seizedFrom,
    Value<String?>? exhibitNo,
    Value<double?>? value,
    Value<String?>? valuesJson,
    Value<int>? sortOrder,
  }) {
    return IoExhibitsCompanion(
      id: id ?? this.id,
      caseId: caseId ?? this.caseId,
      description: description ?? this.description,
      category: category ?? this.category,
      seizedFrom: seizedFrom ?? this.seizedFrom,
      exhibitNo: exhibitNo ?? this.exhibitNo,
      value: value ?? this.value,
      valuesJson: valuesJson ?? this.valuesJson,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (caseId.present) {
      map['case_id'] = Variable<int>(caseId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (seizedFrom.present) {
      map['seized_from'] = Variable<String>(seizedFrom.value);
    }
    if (exhibitNo.present) {
      map['exhibit_no'] = Variable<String>(exhibitNo.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (valuesJson.present) {
      map['values_json'] = Variable<String>(valuesJson.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IoExhibitsCompanion(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('seizedFrom: $seizedFrom, ')
          ..write('exhibitNo: $exhibitNo, ')
          ..write('value: $value, ')
          ..write('valuesJson: $valuesJson, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $IoFormsTable extends IoForms with TableInfo<$IoFormsTable, IoForm> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IoFormsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<int> caseId = GeneratedColumn<int>(
    'case_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES io_cases (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _formIdMeta = const VerificationMeta('formId');
  @override
  late final GeneratedColumn<String> formId = GeneratedColumn<String>(
    'form_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valuesJsonMeta = const VerificationMeta(
    'valuesJson',
  );
  @override
  late final GeneratedColumn<String> valuesJson = GeneratedColumn<String>(
    'values_json',
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
    defaultValue: const Constant('draft'),
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
    caseId,
    formId,
    title,
    valuesJson,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'io_forms';
  @override
  VerificationContext validateIntegrity(
    Insertable<IoForm> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('case_id')) {
      context.handle(
        _caseIdMeta,
        caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_caseIdMeta);
    }
    if (data.containsKey('form_id')) {
      context.handle(
        _formIdMeta,
        formId.isAcceptableOrUnknown(data['form_id']!, _formIdMeta),
      );
    } else if (isInserting) {
      context.missing(_formIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('values_json')) {
      context.handle(
        _valuesJsonMeta,
        valuesJson.isAcceptableOrUnknown(data['values_json']!, _valuesJsonMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
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
  IoForm map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IoForm(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      caseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}case_id'],
      )!,
      formId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      valuesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}values_json'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
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
  $IoFormsTable createAlias(String alias) {
    return $IoFormsTable(attachedDatabase, alias);
  }
}

class IoForm extends DataClass implements Insertable<IoForm> {
  final int id;
  final int caseId;

  /// The form spec id (see io_forms_catalog.dart), e.g. 'scene_panchnama'.
  final String formId;
  final String? title;

  /// field-id → value map for this form instance.
  final String? valuesJson;

  /// draft | complete.
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const IoForm({
    required this.id,
    required this.caseId,
    required this.formId,
    this.title,
    this.valuesJson,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['case_id'] = Variable<int>(caseId);
    map['form_id'] = Variable<String>(formId);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || valuesJson != null) {
      map['values_json'] = Variable<String>(valuesJson);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IoFormsCompanion toCompanion(bool nullToAbsent) {
    return IoFormsCompanion(
      id: Value(id),
      caseId: Value(caseId),
      formId: Value(formId),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      valuesJson: valuesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(valuesJson),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory IoForm.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IoForm(
      id: serializer.fromJson<int>(json['id']),
      caseId: serializer.fromJson<int>(json['caseId']),
      formId: serializer.fromJson<String>(json['formId']),
      title: serializer.fromJson<String?>(json['title']),
      valuesJson: serializer.fromJson<String?>(json['valuesJson']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'caseId': serializer.toJson<int>(caseId),
      'formId': serializer.toJson<String>(formId),
      'title': serializer.toJson<String?>(title),
      'valuesJson': serializer.toJson<String?>(valuesJson),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  IoForm copyWith({
    int? id,
    int? caseId,
    String? formId,
    Value<String?> title = const Value.absent(),
    Value<String?> valuesJson = const Value.absent(),
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => IoForm(
    id: id ?? this.id,
    caseId: caseId ?? this.caseId,
    formId: formId ?? this.formId,
    title: title.present ? title.value : this.title,
    valuesJson: valuesJson.present ? valuesJson.value : this.valuesJson,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  IoForm copyWithCompanion(IoFormsCompanion data) {
    return IoForm(
      id: data.id.present ? data.id.value : this.id,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      formId: data.formId.present ? data.formId.value : this.formId,
      title: data.title.present ? data.title.value : this.title,
      valuesJson: data.valuesJson.present
          ? data.valuesJson.value
          : this.valuesJson,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IoForm(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('formId: $formId, ')
          ..write('title: $title, ')
          ..write('valuesJson: $valuesJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    caseId,
    formId,
    title,
    valuesJson,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IoForm &&
          other.id == this.id &&
          other.caseId == this.caseId &&
          other.formId == this.formId &&
          other.title == this.title &&
          other.valuesJson == this.valuesJson &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class IoFormsCompanion extends UpdateCompanion<IoForm> {
  final Value<int> id;
  final Value<int> caseId;
  final Value<String> formId;
  final Value<String?> title;
  final Value<String?> valuesJson;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const IoFormsCompanion({
    this.id = const Value.absent(),
    this.caseId = const Value.absent(),
    this.formId = const Value.absent(),
    this.title = const Value.absent(),
    this.valuesJson = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  IoFormsCompanion.insert({
    this.id = const Value.absent(),
    required int caseId,
    required String formId,
    this.title = const Value.absent(),
    this.valuesJson = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : caseId = Value(caseId),
       formId = Value(formId);
  static Insertable<IoForm> custom({
    Expression<int>? id,
    Expression<int>? caseId,
    Expression<String>? formId,
    Expression<String>? title,
    Expression<String>? valuesJson,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (caseId != null) 'case_id': caseId,
      if (formId != null) 'form_id': formId,
      if (title != null) 'title': title,
      if (valuesJson != null) 'values_json': valuesJson,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  IoFormsCompanion copyWith({
    Value<int>? id,
    Value<int>? caseId,
    Value<String>? formId,
    Value<String?>? title,
    Value<String?>? valuesJson,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return IoFormsCompanion(
      id: id ?? this.id,
      caseId: caseId ?? this.caseId,
      formId: formId ?? this.formId,
      title: title ?? this.title,
      valuesJson: valuesJson ?? this.valuesJson,
      status: status ?? this.status,
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
    if (caseId.present) {
      map['case_id'] = Variable<int>(caseId.value);
    }
    if (formId.present) {
      map['form_id'] = Variable<String>(formId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (valuesJson.present) {
      map['values_json'] = Variable<String>(valuesJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
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
    return (StringBuffer('IoFormsCompanion(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('formId: $formId, ')
          ..write('title: $title, ')
          ..write('valuesJson: $valuesJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $IoMediaTable extends IoMedia with TableInfo<$IoMediaTable, IoMediaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IoMediaTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<int> caseId = GeneratedColumn<int>(
    'case_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES io_cases (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _formIdMeta = const VerificationMeta('formId');
  @override
  late final GeneratedColumn<String> formId = GeneratedColumn<String>(
    'form_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    caseId,
    formId,
    kind,
    filePath,
    caption,
    lat,
    lng,
    capturedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'io_media';
  @override
  VerificationContext validateIntegrity(
    Insertable<IoMediaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('case_id')) {
      context.handle(
        _caseIdMeta,
        caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_caseIdMeta);
    }
    if (data.containsKey('form_id')) {
      context.handle(
        _formIdMeta,
        formId.isAcceptableOrUnknown(data['form_id']!, _formIdMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IoMediaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IoMediaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      caseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}case_id'],
      )!,
      formId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form_id'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
    );
  }

  @override
  $IoMediaTable createAlias(String alias) {
    return $IoMediaTable(attachedDatabase, alias);
  }
}

class IoMediaData extends DataClass implements Insertable<IoMediaData> {
  final int id;
  final int caseId;

  /// Optional form the media belongs to (null = case-level scene gallery).
  final String? formId;

  /// photo | signature | audio | video.
  final String kind;
  final String filePath;
  final String? caption;

  /// Scene GPS at capture time (from the device), for the panchnama's location.
  final double? lat;
  final double? lng;
  final DateTime capturedAt;
  const IoMediaData({
    required this.id,
    required this.caseId,
    this.formId,
    required this.kind,
    required this.filePath,
    this.caption,
    this.lat,
    this.lng,
    required this.capturedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['case_id'] = Variable<int>(caseId);
    if (!nullToAbsent || formId != null) {
      map['form_id'] = Variable<String>(formId);
    }
    map['kind'] = Variable<String>(kind);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    map['captured_at'] = Variable<DateTime>(capturedAt);
    return map;
  }

  IoMediaCompanion toCompanion(bool nullToAbsent) {
    return IoMediaCompanion(
      id: Value(id),
      caseId: Value(caseId),
      formId: formId == null && nullToAbsent
          ? const Value.absent()
          : Value(formId),
      kind: Value(kind),
      filePath: Value(filePath),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      capturedAt: Value(capturedAt),
    );
  }

  factory IoMediaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IoMediaData(
      id: serializer.fromJson<int>(json['id']),
      caseId: serializer.fromJson<int>(json['caseId']),
      formId: serializer.fromJson<String?>(json['formId']),
      kind: serializer.fromJson<String>(json['kind']),
      filePath: serializer.fromJson<String>(json['filePath']),
      caption: serializer.fromJson<String?>(json['caption']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'caseId': serializer.toJson<int>(caseId),
      'formId': serializer.toJson<String?>(formId),
      'kind': serializer.toJson<String>(kind),
      'filePath': serializer.toJson<String>(filePath),
      'caption': serializer.toJson<String?>(caption),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
    };
  }

  IoMediaData copyWith({
    int? id,
    int? caseId,
    Value<String?> formId = const Value.absent(),
    String? kind,
    String? filePath,
    Value<String?> caption = const Value.absent(),
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    DateTime? capturedAt,
  }) => IoMediaData(
    id: id ?? this.id,
    caseId: caseId ?? this.caseId,
    formId: formId.present ? formId.value : this.formId,
    kind: kind ?? this.kind,
    filePath: filePath ?? this.filePath,
    caption: caption.present ? caption.value : this.caption,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    capturedAt: capturedAt ?? this.capturedAt,
  );
  IoMediaData copyWithCompanion(IoMediaCompanion data) {
    return IoMediaData(
      id: data.id.present ? data.id.value : this.id,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      formId: data.formId.present ? data.formId.value : this.formId,
      kind: data.kind.present ? data.kind.value : this.kind,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      caption: data.caption.present ? data.caption.value : this.caption,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IoMediaData(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('formId: $formId, ')
          ..write('kind: $kind, ')
          ..write('filePath: $filePath, ')
          ..write('caption: $caption, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('capturedAt: $capturedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    caseId,
    formId,
    kind,
    filePath,
    caption,
    lat,
    lng,
    capturedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IoMediaData &&
          other.id == this.id &&
          other.caseId == this.caseId &&
          other.formId == this.formId &&
          other.kind == this.kind &&
          other.filePath == this.filePath &&
          other.caption == this.caption &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.capturedAt == this.capturedAt);
}

class IoMediaCompanion extends UpdateCompanion<IoMediaData> {
  final Value<int> id;
  final Value<int> caseId;
  final Value<String?> formId;
  final Value<String> kind;
  final Value<String> filePath;
  final Value<String?> caption;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<DateTime> capturedAt;
  const IoMediaCompanion({
    this.id = const Value.absent(),
    this.caseId = const Value.absent(),
    this.formId = const Value.absent(),
    this.kind = const Value.absent(),
    this.filePath = const Value.absent(),
    this.caption = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.capturedAt = const Value.absent(),
  });
  IoMediaCompanion.insert({
    this.id = const Value.absent(),
    required int caseId,
    this.formId = const Value.absent(),
    required String kind,
    required String filePath,
    this.caption = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.capturedAt = const Value.absent(),
  }) : caseId = Value(caseId),
       kind = Value(kind),
       filePath = Value(filePath);
  static Insertable<IoMediaData> custom({
    Expression<int>? id,
    Expression<int>? caseId,
    Expression<String>? formId,
    Expression<String>? kind,
    Expression<String>? filePath,
    Expression<String>? caption,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<DateTime>? capturedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (caseId != null) 'case_id': caseId,
      if (formId != null) 'form_id': formId,
      if (kind != null) 'kind': kind,
      if (filePath != null) 'file_path': filePath,
      if (caption != null) 'caption': caption,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (capturedAt != null) 'captured_at': capturedAt,
    });
  }

  IoMediaCompanion copyWith({
    Value<int>? id,
    Value<int>? caseId,
    Value<String?>? formId,
    Value<String>? kind,
    Value<String>? filePath,
    Value<String?>? caption,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<DateTime>? capturedAt,
  }) {
    return IoMediaCompanion(
      id: id ?? this.id,
      caseId: caseId ?? this.caseId,
      formId: formId ?? this.formId,
      kind: kind ?? this.kind,
      filePath: filePath ?? this.filePath,
      caption: caption ?? this.caption,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      capturedAt: capturedAt ?? this.capturedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (caseId.present) {
      map['case_id'] = Variable<int>(caseId.value);
    }
    if (formId.present) {
      map['form_id'] = Variable<String>(formId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IoMediaCompanion(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('formId: $formId, ')
          ..write('kind: $kind, ')
          ..write('filePath: $filePath, ')
          ..write('caption: $caption, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('capturedAt: $capturedAt')
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
  late final $IoCasesTable ioCases = $IoCasesTable(this);
  late final $IoPartiesTable ioParties = $IoPartiesTable(this);
  late final $IoExhibitsTable ioExhibits = $IoExhibitsTable(this);
  late final $IoFormsTable ioForms = $IoFormsTable(this);
  late final $IoMediaTable ioMedia = $IoMediaTable(this);
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
    ioCases,
    ioParties,
    ioExhibits,
    ioForms,
    ioMedia,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'io_cases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('io_parties', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'io_cases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('io_exhibits', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'io_cases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('io_forms', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'io_cases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('io_media', kind: UpdateKind.delete)],
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
      Value<DateTime?> dateOccurredTo,
      Value<String?> timeOccurred,
      Value<String?> timeOccurredTo,
      Value<String?> placeOccurred,
      Value<DateTime?> dateRegistered,
      Value<String?> timeRegistered,
      Value<String?> crimeType,
      Value<String?> remoteUid,
      Value<String> status,
      Value<String?> courtType,
      Value<String> caseStage,
      Value<String?> detailedDescription,
      Value<DateTime?> firDate,
      Value<String?> firTime,
      Value<DateTime?> infoReceivedDate,
      Value<String?> infoReceivedTime,
      Value<DateTime?> gdDate,
      Value<String?> gdTime,
      Value<String?> gdEntryNo,
      Value<String?> occurrenceDay,
      Value<String?> typeOfInformation,
      Value<String?> beatNo,
      Value<String?> directionDistance,
      Value<String?> outsidePsName,
      Value<String?> outsidePsDistrict,
      Value<String?> delayReason,
      Value<String?> inquestUdNo,
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
      Value<DateTime?> dateOccurredTo,
      Value<String?> timeOccurred,
      Value<String?> timeOccurredTo,
      Value<String?> placeOccurred,
      Value<DateTime?> dateRegistered,
      Value<String?> timeRegistered,
      Value<String?> crimeType,
      Value<String?> remoteUid,
      Value<String> status,
      Value<String?> courtType,
      Value<String> caseStage,
      Value<String?> detailedDescription,
      Value<DateTime?> firDate,
      Value<String?> firTime,
      Value<DateTime?> infoReceivedDate,
      Value<String?> infoReceivedTime,
      Value<DateTime?> gdDate,
      Value<String?> gdTime,
      Value<String?> gdEntryNo,
      Value<String?> occurrenceDay,
      Value<String?> typeOfInformation,
      Value<String?> beatNo,
      Value<String?> directionDistance,
      Value<String?> outsidePsName,
      Value<String?> outsidePsDistrict,
      Value<String?> delayReason,
      Value<String?> inquestUdNo,
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

  ColumnFilters<DateTime> get dateOccurredTo => $composableBuilder(
    column: $table.dateOccurredTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeOccurred => $composableBuilder(
    column: $table.timeOccurred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeOccurredTo => $composableBuilder(
    column: $table.timeOccurredTo,
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

  ColumnFilters<String> get remoteUid => $composableBuilder(
    column: $table.remoteUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courtType => $composableBuilder(
    column: $table.courtType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caseStage => $composableBuilder(
    column: $table.caseStage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailedDescription => $composableBuilder(
    column: $table.detailedDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firDate => $composableBuilder(
    column: $table.firDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firTime => $composableBuilder(
    column: $table.firTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get infoReceivedDate => $composableBuilder(
    column: $table.infoReceivedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get infoReceivedTime => $composableBuilder(
    column: $table.infoReceivedTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get gdDate => $composableBuilder(
    column: $table.gdDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gdTime => $composableBuilder(
    column: $table.gdTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gdEntryNo => $composableBuilder(
    column: $table.gdEntryNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occurrenceDay => $composableBuilder(
    column: $table.occurrenceDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeOfInformation => $composableBuilder(
    column: $table.typeOfInformation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beatNo => $composableBuilder(
    column: $table.beatNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get directionDistance => $composableBuilder(
    column: $table.directionDistance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outsidePsName => $composableBuilder(
    column: $table.outsidePsName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outsidePsDistrict => $composableBuilder(
    column: $table.outsidePsDistrict,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get delayReason => $composableBuilder(
    column: $table.delayReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inquestUdNo => $composableBuilder(
    column: $table.inquestUdNo,
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

  ColumnOrderings<DateTime> get dateOccurredTo => $composableBuilder(
    column: $table.dateOccurredTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeOccurred => $composableBuilder(
    column: $table.timeOccurred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeOccurredTo => $composableBuilder(
    column: $table.timeOccurredTo,
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

  ColumnOrderings<String> get remoteUid => $composableBuilder(
    column: $table.remoteUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courtType => $composableBuilder(
    column: $table.courtType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caseStage => $composableBuilder(
    column: $table.caseStage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailedDescription => $composableBuilder(
    column: $table.detailedDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firDate => $composableBuilder(
    column: $table.firDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firTime => $composableBuilder(
    column: $table.firTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get infoReceivedDate => $composableBuilder(
    column: $table.infoReceivedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get infoReceivedTime => $composableBuilder(
    column: $table.infoReceivedTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get gdDate => $composableBuilder(
    column: $table.gdDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gdTime => $composableBuilder(
    column: $table.gdTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gdEntryNo => $composableBuilder(
    column: $table.gdEntryNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occurrenceDay => $composableBuilder(
    column: $table.occurrenceDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeOfInformation => $composableBuilder(
    column: $table.typeOfInformation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beatNo => $composableBuilder(
    column: $table.beatNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get directionDistance => $composableBuilder(
    column: $table.directionDistance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outsidePsName => $composableBuilder(
    column: $table.outsidePsName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outsidePsDistrict => $composableBuilder(
    column: $table.outsidePsDistrict,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get delayReason => $composableBuilder(
    column: $table.delayReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inquestUdNo => $composableBuilder(
    column: $table.inquestUdNo,
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

  GeneratedColumn<DateTime> get dateOccurredTo => $composableBuilder(
    column: $table.dateOccurredTo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeOccurred => $composableBuilder(
    column: $table.timeOccurred,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeOccurredTo => $composableBuilder(
    column: $table.timeOccurredTo,
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

  GeneratedColumn<String> get remoteUid =>
      $composableBuilder(column: $table.remoteUid, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get courtType =>
      $composableBuilder(column: $table.courtType, builder: (column) => column);

  GeneratedColumn<String> get caseStage =>
      $composableBuilder(column: $table.caseStage, builder: (column) => column);

  GeneratedColumn<String> get detailedDescription => $composableBuilder(
    column: $table.detailedDescription,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get firDate =>
      $composableBuilder(column: $table.firDate, builder: (column) => column);

  GeneratedColumn<String> get firTime =>
      $composableBuilder(column: $table.firTime, builder: (column) => column);

  GeneratedColumn<DateTime> get infoReceivedDate => $composableBuilder(
    column: $table.infoReceivedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get infoReceivedTime => $composableBuilder(
    column: $table.infoReceivedTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get gdDate =>
      $composableBuilder(column: $table.gdDate, builder: (column) => column);

  GeneratedColumn<String> get gdTime =>
      $composableBuilder(column: $table.gdTime, builder: (column) => column);

  GeneratedColumn<String> get gdEntryNo =>
      $composableBuilder(column: $table.gdEntryNo, builder: (column) => column);

  GeneratedColumn<String> get occurrenceDay => $composableBuilder(
    column: $table.occurrenceDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get typeOfInformation => $composableBuilder(
    column: $table.typeOfInformation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get beatNo =>
      $composableBuilder(column: $table.beatNo, builder: (column) => column);

  GeneratedColumn<String> get directionDistance => $composableBuilder(
    column: $table.directionDistance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outsidePsName => $composableBuilder(
    column: $table.outsidePsName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outsidePsDistrict => $composableBuilder(
    column: $table.outsidePsDistrict,
    builder: (column) => column,
  );

  GeneratedColumn<String> get delayReason => $composableBuilder(
    column: $table.delayReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get inquestUdNo => $composableBuilder(
    column: $table.inquestUdNo,
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
                Value<DateTime?> dateOccurredTo = const Value.absent(),
                Value<String?> timeOccurred = const Value.absent(),
                Value<String?> timeOccurredTo = const Value.absent(),
                Value<String?> placeOccurred = const Value.absent(),
                Value<DateTime?> dateRegistered = const Value.absent(),
                Value<String?> timeRegistered = const Value.absent(),
                Value<String?> crimeType = const Value.absent(),
                Value<String?> remoteUid = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> courtType = const Value.absent(),
                Value<String> caseStage = const Value.absent(),
                Value<String?> detailedDescription = const Value.absent(),
                Value<DateTime?> firDate = const Value.absent(),
                Value<String?> firTime = const Value.absent(),
                Value<DateTime?> infoReceivedDate = const Value.absent(),
                Value<String?> infoReceivedTime = const Value.absent(),
                Value<DateTime?> gdDate = const Value.absent(),
                Value<String?> gdTime = const Value.absent(),
                Value<String?> gdEntryNo = const Value.absent(),
                Value<String?> occurrenceDay = const Value.absent(),
                Value<String?> typeOfInformation = const Value.absent(),
                Value<String?> beatNo = const Value.absent(),
                Value<String?> directionDistance = const Value.absent(),
                Value<String?> outsidePsName = const Value.absent(),
                Value<String?> outsidePsDistrict = const Value.absent(),
                Value<String?> delayReason = const Value.absent(),
                Value<String?> inquestUdNo = const Value.absent(),
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
                dateOccurredTo: dateOccurredTo,
                timeOccurred: timeOccurred,
                timeOccurredTo: timeOccurredTo,
                placeOccurred: placeOccurred,
                dateRegistered: dateRegistered,
                timeRegistered: timeRegistered,
                crimeType: crimeType,
                remoteUid: remoteUid,
                status: status,
                courtType: courtType,
                caseStage: caseStage,
                detailedDescription: detailedDescription,
                firDate: firDate,
                firTime: firTime,
                infoReceivedDate: infoReceivedDate,
                infoReceivedTime: infoReceivedTime,
                gdDate: gdDate,
                gdTime: gdTime,
                gdEntryNo: gdEntryNo,
                occurrenceDay: occurrenceDay,
                typeOfInformation: typeOfInformation,
                beatNo: beatNo,
                directionDistance: directionDistance,
                outsidePsName: outsidePsName,
                outsidePsDistrict: outsidePsDistrict,
                delayReason: delayReason,
                inquestUdNo: inquestUdNo,
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
                Value<DateTime?> dateOccurredTo = const Value.absent(),
                Value<String?> timeOccurred = const Value.absent(),
                Value<String?> timeOccurredTo = const Value.absent(),
                Value<String?> placeOccurred = const Value.absent(),
                Value<DateTime?> dateRegistered = const Value.absent(),
                Value<String?> timeRegistered = const Value.absent(),
                Value<String?> crimeType = const Value.absent(),
                Value<String?> remoteUid = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> courtType = const Value.absent(),
                Value<String> caseStage = const Value.absent(),
                Value<String?> detailedDescription = const Value.absent(),
                Value<DateTime?> firDate = const Value.absent(),
                Value<String?> firTime = const Value.absent(),
                Value<DateTime?> infoReceivedDate = const Value.absent(),
                Value<String?> infoReceivedTime = const Value.absent(),
                Value<DateTime?> gdDate = const Value.absent(),
                Value<String?> gdTime = const Value.absent(),
                Value<String?> gdEntryNo = const Value.absent(),
                Value<String?> occurrenceDay = const Value.absent(),
                Value<String?> typeOfInformation = const Value.absent(),
                Value<String?> beatNo = const Value.absent(),
                Value<String?> directionDistance = const Value.absent(),
                Value<String?> outsidePsName = const Value.absent(),
                Value<String?> outsidePsDistrict = const Value.absent(),
                Value<String?> delayReason = const Value.absent(),
                Value<String?> inquestUdNo = const Value.absent(),
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
                dateOccurredTo: dateOccurredTo,
                timeOccurred: timeOccurred,
                timeOccurredTo: timeOccurredTo,
                placeOccurred: placeOccurred,
                dateRegistered: dateRegistered,
                timeRegistered: timeRegistered,
                crimeType: crimeType,
                remoteUid: remoteUid,
                status: status,
                courtType: courtType,
                caseStage: caseStage,
                detailedDescription: detailedDescription,
                firDate: firDate,
                firTime: firTime,
                infoReceivedDate: infoReceivedDate,
                infoReceivedTime: infoReceivedTime,
                gdDate: gdDate,
                gdTime: gdTime,
                gdEntryNo: gdEntryNo,
                occurrenceDay: occurrenceDay,
                typeOfInformation: typeOfInformation,
                beatNo: beatNo,
                directionDistance: directionDistance,
                outsidePsName: outsidePsName,
                outsidePsDistrict: outsidePsDistrict,
                delayReason: delayReason,
                inquestUdNo: inquestUdNo,
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
      Value<String?> ageText,
      Value<String?> address,
      Value<String?> mobile,
      Value<String?> email,
      Value<String?> aadhaarEnc,
      Value<String?> panEnc,
      Value<String?> passport,
      Value<String?> fatherHusbandName,
      Value<int?> birthYear,
      Value<String?> nationality,
      Value<String?> occupation,
      Value<String?> permanentAddress,
      Value<String?> idType,
      Value<String?> idNumber,
    });
typedef $$ComplainantsTableUpdateCompanionBuilder =
    ComplainantsCompanion Function({
      Value<int> id,
      Value<int> crimeId,
      Value<String> name,
      Value<String?> gender,
      Value<int?> age,
      Value<String?> ageText,
      Value<String?> address,
      Value<String?> mobile,
      Value<String?> email,
      Value<String?> aadhaarEnc,
      Value<String?> panEnc,
      Value<String?> passport,
      Value<String?> fatherHusbandName,
      Value<int?> birthYear,
      Value<String?> nationality,
      Value<String?> occupation,
      Value<String?> permanentAddress,
      Value<String?> idType,
      Value<String?> idNumber,
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

  ColumnFilters<String> get ageText => $composableBuilder(
    column: $table.ageText,
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

  ColumnFilters<String> get fatherHusbandName => $composableBuilder(
    column: $table.fatherHusbandName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permanentAddress => $composableBuilder(
    column: $table.permanentAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idType => $composableBuilder(
    column: $table.idType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
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

  ColumnOrderings<String> get ageText => $composableBuilder(
    column: $table.ageText,
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

  ColumnOrderings<String> get fatherHusbandName => $composableBuilder(
    column: $table.fatherHusbandName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permanentAddress => $composableBuilder(
    column: $table.permanentAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idType => $composableBuilder(
    column: $table.idType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
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

  GeneratedColumn<String> get ageText =>
      $composableBuilder(column: $table.ageText, builder: (column) => column);

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

  GeneratedColumn<String> get fatherHusbandName => $composableBuilder(
    column: $table.fatherHusbandName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get birthYear =>
      $composableBuilder(column: $table.birthYear, builder: (column) => column);

  GeneratedColumn<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get permanentAddress => $composableBuilder(
    column: $table.permanentAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idType =>
      $composableBuilder(column: $table.idType, builder: (column) => column);

  GeneratedColumn<String> get idNumber =>
      $composableBuilder(column: $table.idNumber, builder: (column) => column);

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
                Value<String?> ageText = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> mobile = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> aadhaarEnc = const Value.absent(),
                Value<String?> panEnc = const Value.absent(),
                Value<String?> passport = const Value.absent(),
                Value<String?> fatherHusbandName = const Value.absent(),
                Value<int?> birthYear = const Value.absent(),
                Value<String?> nationality = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<String?> permanentAddress = const Value.absent(),
                Value<String?> idType = const Value.absent(),
                Value<String?> idNumber = const Value.absent(),
              }) => ComplainantsCompanion(
                id: id,
                crimeId: crimeId,
                name: name,
                gender: gender,
                age: age,
                ageText: ageText,
                address: address,
                mobile: mobile,
                email: email,
                aadhaarEnc: aadhaarEnc,
                panEnc: panEnc,
                passport: passport,
                fatherHusbandName: fatherHusbandName,
                birthYear: birthYear,
                nationality: nationality,
                occupation: occupation,
                permanentAddress: permanentAddress,
                idType: idType,
                idNumber: idNumber,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int crimeId,
                required String name,
                Value<String?> gender = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> ageText = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> mobile = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> aadhaarEnc = const Value.absent(),
                Value<String?> panEnc = const Value.absent(),
                Value<String?> passport = const Value.absent(),
                Value<String?> fatherHusbandName = const Value.absent(),
                Value<int?> birthYear = const Value.absent(),
                Value<String?> nationality = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<String?> permanentAddress = const Value.absent(),
                Value<String?> idType = const Value.absent(),
                Value<String?> idNumber = const Value.absent(),
              }) => ComplainantsCompanion.insert(
                id: id,
                crimeId: crimeId,
                name: name,
                gender: gender,
                age: age,
                ageText: ageText,
                address: address,
                mobile: mobile,
                email: email,
                aadhaarEnc: aadhaarEnc,
                panEnc: panEnc,
                passport: passport,
                fatherHusbandName: fatherHusbandName,
                birthYear: birthYear,
                nationality: nationality,
                occupation: occupation,
                permanentAddress: permanentAddress,
                idType: idType,
                idNumber: idNumber,
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
      Value<String?> ageText,
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
      Value<String?> alias,
      Value<String?> relativeName,
      Value<String?> physicalJson,
    });
typedef $$AccusedTableUpdateCompanionBuilder =
    AccusedCompanion Function({
      Value<int> id,
      Value<int> crimeId,
      Value<String> name,
      Value<String?> gender,
      Value<int?> age,
      Value<String?> ageText,
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
      Value<String?> alias,
      Value<String?> relativeName,
      Value<String?> physicalJson,
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

  ColumnFilters<String> get ageText => $composableBuilder(
    column: $table.ageText,
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

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relativeName => $composableBuilder(
    column: $table.relativeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get physicalJson => $composableBuilder(
    column: $table.physicalJson,
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

  ColumnOrderings<String> get ageText => $composableBuilder(
    column: $table.ageText,
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

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relativeName => $composableBuilder(
    column: $table.relativeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get physicalJson => $composableBuilder(
    column: $table.physicalJson,
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

  GeneratedColumn<String> get ageText =>
      $composableBuilder(column: $table.ageText, builder: (column) => column);

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

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<String> get relativeName => $composableBuilder(
    column: $table.relativeName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get physicalJson => $composableBuilder(
    column: $table.physicalJson,
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
                Value<String?> ageText = const Value.absent(),
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
                Value<String?> alias = const Value.absent(),
                Value<String?> relativeName = const Value.absent(),
                Value<String?> physicalJson = const Value.absent(),
              }) => AccusedCompanion(
                id: id,
                crimeId: crimeId,
                name: name,
                gender: gender,
                age: age,
                ageText: ageText,
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
                alias: alias,
                relativeName: relativeName,
                physicalJson: physicalJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int crimeId,
                required String name,
                Value<String?> gender = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> ageText = const Value.absent(),
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
                Value<String?> alias = const Value.absent(),
                Value<String?> relativeName = const Value.absent(),
                Value<String?> physicalJson = const Value.absent(),
              }) => AccusedCompanion.insert(
                id: id,
                crimeId: crimeId,
                name: name,
                gender: gender,
                age: age,
                ageText: ageText,
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
                alias: alias,
                relativeName: relativeName,
                physicalJson: physicalJson,
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
      Value<String?> category,
      Value<String?> type,
      Value<String?> description,
      Value<double?> value,
    });
typedef $$StolenPropertyTableUpdateCompanionBuilder =
    StolenPropertyCompanion Function({
      Value<int> id,
      Value<int> crimeId,
      Value<String?> category,
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

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
                Value<String?> category = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double?> value = const Value.absent(),
              }) => StolenPropertyCompanion(
                id: id,
                crimeId: crimeId,
                category: category,
                type: type,
                description: description,
                value: value,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int crimeId,
                Value<String?> category = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double?> value = const Value.absent(),
              }) => StolenPropertyCompanion.insert(
                id: id,
                crimeId: crimeId,
                category: category,
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
      Value<String?> officerDesignation,
      Value<String?> officerMobile,
      Value<String?> filedBy,
      Value<String?> preventiveAction,
      Value<String?> preventiveNo,
      Value<DateTime?> preventiveDate,
      Value<String?> wantedAccused,
      Value<String?> registeringOfficerName,
      Value<String?> registeringOfficerRank,
      Value<String?> registeringOfficerNo,
      Value<String?> actionTaken,
      Value<DateTime?> courtDispatchDate,
      Value<String?> courtDispatchTime,
    });
typedef $$InvestigationTableUpdateCompanionBuilder =
    InvestigationCompanion Function({
      Value<int> id,
      Value<int> crimeId,
      Value<String?> officerName,
      Value<String?> officerId,
      Value<String?> officerDesignation,
      Value<String?> officerMobile,
      Value<String?> filedBy,
      Value<String?> preventiveAction,
      Value<String?> preventiveNo,
      Value<DateTime?> preventiveDate,
      Value<String?> wantedAccused,
      Value<String?> registeringOfficerName,
      Value<String?> registeringOfficerRank,
      Value<String?> registeringOfficerNo,
      Value<String?> actionTaken,
      Value<DateTime?> courtDispatchDate,
      Value<String?> courtDispatchTime,
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

  ColumnFilters<String> get officerDesignation => $composableBuilder(
    column: $table.officerDesignation,
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

  ColumnFilters<String> get registeringOfficerName => $composableBuilder(
    column: $table.registeringOfficerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registeringOfficerRank => $composableBuilder(
    column: $table.registeringOfficerRank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registeringOfficerNo => $composableBuilder(
    column: $table.registeringOfficerNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionTaken => $composableBuilder(
    column: $table.actionTaken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get courtDispatchDate => $composableBuilder(
    column: $table.courtDispatchDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courtDispatchTime => $composableBuilder(
    column: $table.courtDispatchTime,
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

  ColumnOrderings<String> get officerDesignation => $composableBuilder(
    column: $table.officerDesignation,
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

  ColumnOrderings<String> get registeringOfficerName => $composableBuilder(
    column: $table.registeringOfficerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registeringOfficerRank => $composableBuilder(
    column: $table.registeringOfficerRank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registeringOfficerNo => $composableBuilder(
    column: $table.registeringOfficerNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionTaken => $composableBuilder(
    column: $table.actionTaken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get courtDispatchDate => $composableBuilder(
    column: $table.courtDispatchDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courtDispatchTime => $composableBuilder(
    column: $table.courtDispatchTime,
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

  GeneratedColumn<String> get officerDesignation => $composableBuilder(
    column: $table.officerDesignation,
    builder: (column) => column,
  );

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

  GeneratedColumn<String> get registeringOfficerName => $composableBuilder(
    column: $table.registeringOfficerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get registeringOfficerRank => $composableBuilder(
    column: $table.registeringOfficerRank,
    builder: (column) => column,
  );

  GeneratedColumn<String> get registeringOfficerNo => $composableBuilder(
    column: $table.registeringOfficerNo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionTaken => $composableBuilder(
    column: $table.actionTaken,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get courtDispatchDate => $composableBuilder(
    column: $table.courtDispatchDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get courtDispatchTime => $composableBuilder(
    column: $table.courtDispatchTime,
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
                Value<String?> officerDesignation = const Value.absent(),
                Value<String?> officerMobile = const Value.absent(),
                Value<String?> filedBy = const Value.absent(),
                Value<String?> preventiveAction = const Value.absent(),
                Value<String?> preventiveNo = const Value.absent(),
                Value<DateTime?> preventiveDate = const Value.absent(),
                Value<String?> wantedAccused = const Value.absent(),
                Value<String?> registeringOfficerName = const Value.absent(),
                Value<String?> registeringOfficerRank = const Value.absent(),
                Value<String?> registeringOfficerNo = const Value.absent(),
                Value<String?> actionTaken = const Value.absent(),
                Value<DateTime?> courtDispatchDate = const Value.absent(),
                Value<String?> courtDispatchTime = const Value.absent(),
              }) => InvestigationCompanion(
                id: id,
                crimeId: crimeId,
                officerName: officerName,
                officerId: officerId,
                officerDesignation: officerDesignation,
                officerMobile: officerMobile,
                filedBy: filedBy,
                preventiveAction: preventiveAction,
                preventiveNo: preventiveNo,
                preventiveDate: preventiveDate,
                wantedAccused: wantedAccused,
                registeringOfficerName: registeringOfficerName,
                registeringOfficerRank: registeringOfficerRank,
                registeringOfficerNo: registeringOfficerNo,
                actionTaken: actionTaken,
                courtDispatchDate: courtDispatchDate,
                courtDispatchTime: courtDispatchTime,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int crimeId,
                Value<String?> officerName = const Value.absent(),
                Value<String?> officerId = const Value.absent(),
                Value<String?> officerDesignation = const Value.absent(),
                Value<String?> officerMobile = const Value.absent(),
                Value<String?> filedBy = const Value.absent(),
                Value<String?> preventiveAction = const Value.absent(),
                Value<String?> preventiveNo = const Value.absent(),
                Value<DateTime?> preventiveDate = const Value.absent(),
                Value<String?> wantedAccused = const Value.absent(),
                Value<String?> registeringOfficerName = const Value.absent(),
                Value<String?> registeringOfficerRank = const Value.absent(),
                Value<String?> registeringOfficerNo = const Value.absent(),
                Value<String?> actionTaken = const Value.absent(),
                Value<DateTime?> courtDispatchDate = const Value.absent(),
                Value<String?> courtDispatchTime = const Value.absent(),
              }) => InvestigationCompanion.insert(
                id: id,
                crimeId: crimeId,
                officerName: officerName,
                officerId: officerId,
                officerDesignation: officerDesignation,
                officerMobile: officerMobile,
                filedBy: filedBy,
                preventiveAction: preventiveAction,
                preventiveNo: preventiveNo,
                preventiveDate: preventiveDate,
                wantedAccused: wantedAccused,
                registeringOfficerName: registeringOfficerName,
                registeringOfficerRank: registeringOfficerRank,
                registeringOfficerNo: registeringOfficerNo,
                actionTaken: actionTaken,
                courtDispatchDate: courtDispatchDate,
                courtDispatchTime: courtDispatchTime,
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
typedef $$IoCasesTableCreateCompanionBuilder =
    IoCasesCompanion Function({
      Value<int> id,
      required String remoteUid,
      Value<String?> title,
      Value<String?> crimeType,
      Value<String?> crimeCategory,
      Value<String?> firNo,
      Value<int?> year,
      Value<String?> district,
      Value<String?> policeStation,
      Value<String?> linkedCrimeUid,
      Value<String?> ownerEmail,
      Value<String> status,
      Value<String?> dataJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$IoCasesTableUpdateCompanionBuilder =
    IoCasesCompanion Function({
      Value<int> id,
      Value<String> remoteUid,
      Value<String?> title,
      Value<String?> crimeType,
      Value<String?> crimeCategory,
      Value<String?> firNo,
      Value<int?> year,
      Value<String?> district,
      Value<String?> policeStation,
      Value<String?> linkedCrimeUid,
      Value<String?> ownerEmail,
      Value<String> status,
      Value<String?> dataJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$IoCasesTableReferences
    extends BaseReferences<_$AppDatabase, $IoCasesTable, IoCase> {
  $$IoCasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$IoPartiesTable, List<IoParty>>
  _ioPartiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ioParties,
    aliasName: 'io_cases__id__io_parties__case_id',
  );

  $$IoPartiesTableProcessedTableManager get ioPartiesRefs {
    final manager = $$IoPartiesTableTableManager(
      $_db,
      $_db.ioParties,
    ).filter((f) => f.caseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ioPartiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IoExhibitsTable, List<IoExhibit>>
  _ioExhibitsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ioExhibits,
    aliasName: 'io_cases__id__io_exhibits__case_id',
  );

  $$IoExhibitsTableProcessedTableManager get ioExhibitsRefs {
    final manager = $$IoExhibitsTableTableManager(
      $_db,
      $_db.ioExhibits,
    ).filter((f) => f.caseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ioExhibitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IoFormsTable, List<IoForm>> _ioFormsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ioForms,
    aliasName: 'io_cases__id__io_forms__case_id',
  );

  $$IoFormsTableProcessedTableManager get ioFormsRefs {
    final manager = $$IoFormsTableTableManager(
      $_db,
      $_db.ioForms,
    ).filter((f) => f.caseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ioFormsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IoMediaTable, List<IoMediaData>>
  _ioMediaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ioMedia,
    aliasName: 'io_cases__id__io_media__case_id',
  );

  $$IoMediaTableProcessedTableManager get ioMediaRefs {
    final manager = $$IoMediaTableTableManager(
      $_db,
      $_db.ioMedia,
    ).filter((f) => f.caseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ioMediaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IoCasesTableFilterComposer
    extends Composer<_$AppDatabase, $IoCasesTable> {
  $$IoCasesTableFilterComposer({
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

  ColumnFilters<String> get remoteUid => $composableBuilder(
    column: $table.remoteUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get crimeType => $composableBuilder(
    column: $table.crimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get crimeCategory => $composableBuilder(
    column: $table.crimeCategory,
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

  ColumnFilters<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get policeStation => $composableBuilder(
    column: $table.policeStation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedCrimeUid => $composableBuilder(
    column: $table.linkedCrimeUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerEmail => $composableBuilder(
    column: $table.ownerEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
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

  Expression<bool> ioPartiesRefs(
    Expression<bool> Function($$IoPartiesTableFilterComposer f) f,
  ) {
    final $$IoPartiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ioParties,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoPartiesTableFilterComposer(
            $db: $db,
            $table: $db.ioParties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ioExhibitsRefs(
    Expression<bool> Function($$IoExhibitsTableFilterComposer f) f,
  ) {
    final $$IoExhibitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ioExhibits,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoExhibitsTableFilterComposer(
            $db: $db,
            $table: $db.ioExhibits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ioFormsRefs(
    Expression<bool> Function($$IoFormsTableFilterComposer f) f,
  ) {
    final $$IoFormsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ioForms,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoFormsTableFilterComposer(
            $db: $db,
            $table: $db.ioForms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ioMediaRefs(
    Expression<bool> Function($$IoMediaTableFilterComposer f) f,
  ) {
    final $$IoMediaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ioMedia,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoMediaTableFilterComposer(
            $db: $db,
            $table: $db.ioMedia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IoCasesTableOrderingComposer
    extends Composer<_$AppDatabase, $IoCasesTable> {
  $$IoCasesTableOrderingComposer({
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

  ColumnOrderings<String> get remoteUid => $composableBuilder(
    column: $table.remoteUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get crimeType => $composableBuilder(
    column: $table.crimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get crimeCategory => $composableBuilder(
    column: $table.crimeCategory,
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

  ColumnOrderings<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get policeStation => $composableBuilder(
    column: $table.policeStation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedCrimeUid => $composableBuilder(
    column: $table.linkedCrimeUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerEmail => $composableBuilder(
    column: $table.ownerEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
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

class $$IoCasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IoCasesTable> {
  $$IoCasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteUid =>
      $composableBuilder(column: $table.remoteUid, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get crimeType =>
      $composableBuilder(column: $table.crimeType, builder: (column) => column);

  GeneratedColumn<String> get crimeCategory => $composableBuilder(
    column: $table.crimeCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firNo =>
      $composableBuilder(column: $table.firNo, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<String> get policeStation => $composableBuilder(
    column: $table.policeStation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedCrimeUid => $composableBuilder(
    column: $table.linkedCrimeUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerEmail => $composableBuilder(
    column: $table.ownerEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> ioPartiesRefs<T extends Object>(
    Expression<T> Function($$IoPartiesTableAnnotationComposer a) f,
  ) {
    final $$IoPartiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ioParties,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoPartiesTableAnnotationComposer(
            $db: $db,
            $table: $db.ioParties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ioExhibitsRefs<T extends Object>(
    Expression<T> Function($$IoExhibitsTableAnnotationComposer a) f,
  ) {
    final $$IoExhibitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ioExhibits,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoExhibitsTableAnnotationComposer(
            $db: $db,
            $table: $db.ioExhibits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ioFormsRefs<T extends Object>(
    Expression<T> Function($$IoFormsTableAnnotationComposer a) f,
  ) {
    final $$IoFormsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ioForms,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoFormsTableAnnotationComposer(
            $db: $db,
            $table: $db.ioForms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ioMediaRefs<T extends Object>(
    Expression<T> Function($$IoMediaTableAnnotationComposer a) f,
  ) {
    final $$IoMediaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ioMedia,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoMediaTableAnnotationComposer(
            $db: $db,
            $table: $db.ioMedia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IoCasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IoCasesTable,
          IoCase,
          $$IoCasesTableFilterComposer,
          $$IoCasesTableOrderingComposer,
          $$IoCasesTableAnnotationComposer,
          $$IoCasesTableCreateCompanionBuilder,
          $$IoCasesTableUpdateCompanionBuilder,
          (IoCase, $$IoCasesTableReferences),
          IoCase,
          PrefetchHooks Function({
            bool ioPartiesRefs,
            bool ioExhibitsRefs,
            bool ioFormsRefs,
            bool ioMediaRefs,
          })
        > {
  $$IoCasesTableTableManager(_$AppDatabase db, $IoCasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IoCasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IoCasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IoCasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> remoteUid = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> crimeType = const Value.absent(),
                Value<String?> crimeCategory = const Value.absent(),
                Value<String?> firNo = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String?> policeStation = const Value.absent(),
                Value<String?> linkedCrimeUid = const Value.absent(),
                Value<String?> ownerEmail = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> dataJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => IoCasesCompanion(
                id: id,
                remoteUid: remoteUid,
                title: title,
                crimeType: crimeType,
                crimeCategory: crimeCategory,
                firNo: firNo,
                year: year,
                district: district,
                policeStation: policeStation,
                linkedCrimeUid: linkedCrimeUid,
                ownerEmail: ownerEmail,
                status: status,
                dataJson: dataJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String remoteUid,
                Value<String?> title = const Value.absent(),
                Value<String?> crimeType = const Value.absent(),
                Value<String?> crimeCategory = const Value.absent(),
                Value<String?> firNo = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String?> policeStation = const Value.absent(),
                Value<String?> linkedCrimeUid = const Value.absent(),
                Value<String?> ownerEmail = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> dataJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => IoCasesCompanion.insert(
                id: id,
                remoteUid: remoteUid,
                title: title,
                crimeType: crimeType,
                crimeCategory: crimeCategory,
                firNo: firNo,
                year: year,
                district: district,
                policeStation: policeStation,
                linkedCrimeUid: linkedCrimeUid,
                ownerEmail: ownerEmail,
                status: status,
                dataJson: dataJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IoCasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ioPartiesRefs = false,
                ioExhibitsRefs = false,
                ioFormsRefs = false,
                ioMediaRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ioPartiesRefs) db.ioParties,
                    if (ioExhibitsRefs) db.ioExhibits,
                    if (ioFormsRefs) db.ioForms,
                    if (ioMediaRefs) db.ioMedia,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ioPartiesRefs)
                        await $_getPrefetchedData<
                          IoCase,
                          $IoCasesTable,
                          IoParty
                        >(
                          currentTable: table,
                          referencedTable: $$IoCasesTableReferences
                              ._ioPartiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IoCasesTableReferences(
                                db,
                                table,
                                p0,
                              ).ioPartiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.caseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ioExhibitsRefs)
                        await $_getPrefetchedData<
                          IoCase,
                          $IoCasesTable,
                          IoExhibit
                        >(
                          currentTable: table,
                          referencedTable: $$IoCasesTableReferences
                              ._ioExhibitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IoCasesTableReferences(
                                db,
                                table,
                                p0,
                              ).ioExhibitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.caseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ioFormsRefs)
                        await $_getPrefetchedData<
                          IoCase,
                          $IoCasesTable,
                          IoForm
                        >(
                          currentTable: table,
                          referencedTable: $$IoCasesTableReferences
                              ._ioFormsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IoCasesTableReferences(
                                db,
                                table,
                                p0,
                              ).ioFormsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.caseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ioMediaRefs)
                        await $_getPrefetchedData<
                          IoCase,
                          $IoCasesTable,
                          IoMediaData
                        >(
                          currentTable: table,
                          referencedTable: $$IoCasesTableReferences
                              ._ioMediaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IoCasesTableReferences(
                                db,
                                table,
                                p0,
                              ).ioMediaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.caseId == item.id,
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

typedef $$IoCasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IoCasesTable,
      IoCase,
      $$IoCasesTableFilterComposer,
      $$IoCasesTableOrderingComposer,
      $$IoCasesTableAnnotationComposer,
      $$IoCasesTableCreateCompanionBuilder,
      $$IoCasesTableUpdateCompanionBuilder,
      (IoCase, $$IoCasesTableReferences),
      IoCase,
      PrefetchHooks Function({
        bool ioPartiesRefs,
        bool ioExhibitsRefs,
        bool ioFormsRefs,
        bool ioMediaRefs,
      })
    >;
typedef $$IoPartiesTableCreateCompanionBuilder =
    IoPartiesCompanion Function({
      Value<int> id,
      required int caseId,
      required String role,
      required String name,
      Value<String?> valuesJson,
      Value<int> sortOrder,
    });
typedef $$IoPartiesTableUpdateCompanionBuilder =
    IoPartiesCompanion Function({
      Value<int> id,
      Value<int> caseId,
      Value<String> role,
      Value<String> name,
      Value<String?> valuesJson,
      Value<int> sortOrder,
    });

final class $$IoPartiesTableReferences
    extends BaseReferences<_$AppDatabase, $IoPartiesTable, IoParty> {
  $$IoPartiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IoCasesTable _caseIdTable(_$AppDatabase db) =>
      db.ioCases.createAlias('io_parties__case_id__io_cases__id');

  $$IoCasesTableProcessedTableManager get caseId {
    final $_column = $_itemColumn<int>('case_id')!;

    final manager = $$IoCasesTableTableManager(
      $_db,
      $_db.ioCases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IoPartiesTableFilterComposer
    extends Composer<_$AppDatabase, $IoPartiesTable> {
  $$IoPartiesTableFilterComposer({
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

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$IoCasesTableFilterComposer get caseId {
    final $$IoCasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.ioCases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoCasesTableFilterComposer(
            $db: $db,
            $table: $db.ioCases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IoPartiesTableOrderingComposer
    extends Composer<_$AppDatabase, $IoPartiesTable> {
  $$IoPartiesTableOrderingComposer({
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

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$IoCasesTableOrderingComposer get caseId {
    final $$IoCasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.ioCases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoCasesTableOrderingComposer(
            $db: $db,
            $table: $db.ioCases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IoPartiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IoPartiesTable> {
  $$IoPartiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$IoCasesTableAnnotationComposer get caseId {
    final $$IoCasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.ioCases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoCasesTableAnnotationComposer(
            $db: $db,
            $table: $db.ioCases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IoPartiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IoPartiesTable,
          IoParty,
          $$IoPartiesTableFilterComposer,
          $$IoPartiesTableOrderingComposer,
          $$IoPartiesTableAnnotationComposer,
          $$IoPartiesTableCreateCompanionBuilder,
          $$IoPartiesTableUpdateCompanionBuilder,
          (IoParty, $$IoPartiesTableReferences),
          IoParty,
          PrefetchHooks Function({bool caseId})
        > {
  $$IoPartiesTableTableManager(_$AppDatabase db, $IoPartiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IoPartiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IoPartiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IoPartiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> caseId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> valuesJson = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => IoPartiesCompanion(
                id: id,
                caseId: caseId,
                role: role,
                name: name,
                valuesJson: valuesJson,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int caseId,
                required String role,
                required String name,
                Value<String?> valuesJson = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => IoPartiesCompanion.insert(
                id: id,
                caseId: caseId,
                role: role,
                name: name,
                valuesJson: valuesJson,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IoPartiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({caseId = false}) {
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
                    if (caseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.caseId,
                                referencedTable: $$IoPartiesTableReferences
                                    ._caseIdTable(db),
                                referencedColumn: $$IoPartiesTableReferences
                                    ._caseIdTable(db)
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

typedef $$IoPartiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IoPartiesTable,
      IoParty,
      $$IoPartiesTableFilterComposer,
      $$IoPartiesTableOrderingComposer,
      $$IoPartiesTableAnnotationComposer,
      $$IoPartiesTableCreateCompanionBuilder,
      $$IoPartiesTableUpdateCompanionBuilder,
      (IoParty, $$IoPartiesTableReferences),
      IoParty,
      PrefetchHooks Function({bool caseId})
    >;
typedef $$IoExhibitsTableCreateCompanionBuilder =
    IoExhibitsCompanion Function({
      Value<int> id,
      required int caseId,
      required String description,
      Value<String?> category,
      Value<String?> seizedFrom,
      Value<String?> exhibitNo,
      Value<double?> value,
      Value<String?> valuesJson,
      Value<int> sortOrder,
    });
typedef $$IoExhibitsTableUpdateCompanionBuilder =
    IoExhibitsCompanion Function({
      Value<int> id,
      Value<int> caseId,
      Value<String> description,
      Value<String?> category,
      Value<String?> seizedFrom,
      Value<String?> exhibitNo,
      Value<double?> value,
      Value<String?> valuesJson,
      Value<int> sortOrder,
    });

final class $$IoExhibitsTableReferences
    extends BaseReferences<_$AppDatabase, $IoExhibitsTable, IoExhibit> {
  $$IoExhibitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IoCasesTable _caseIdTable(_$AppDatabase db) =>
      db.ioCases.createAlias('io_exhibits__case_id__io_cases__id');

  $$IoCasesTableProcessedTableManager get caseId {
    final $_column = $_itemColumn<int>('case_id')!;

    final manager = $$IoCasesTableTableManager(
      $_db,
      $_db.ioCases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IoExhibitsTableFilterComposer
    extends Composer<_$AppDatabase, $IoExhibitsTable> {
  $$IoExhibitsTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seizedFrom => $composableBuilder(
    column: $table.seizedFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exhibitNo => $composableBuilder(
    column: $table.exhibitNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$IoCasesTableFilterComposer get caseId {
    final $$IoCasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.ioCases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoCasesTableFilterComposer(
            $db: $db,
            $table: $db.ioCases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IoExhibitsTableOrderingComposer
    extends Composer<_$AppDatabase, $IoExhibitsTable> {
  $$IoExhibitsTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seizedFrom => $composableBuilder(
    column: $table.seizedFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exhibitNo => $composableBuilder(
    column: $table.exhibitNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$IoCasesTableOrderingComposer get caseId {
    final $$IoCasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.ioCases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoCasesTableOrderingComposer(
            $db: $db,
            $table: $db.ioCases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IoExhibitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IoExhibitsTable> {
  $$IoExhibitsTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get seizedFrom => $composableBuilder(
    column: $table.seizedFrom,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exhibitNo =>
      $composableBuilder(column: $table.exhibitNo, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$IoCasesTableAnnotationComposer get caseId {
    final $$IoCasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.ioCases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoCasesTableAnnotationComposer(
            $db: $db,
            $table: $db.ioCases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IoExhibitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IoExhibitsTable,
          IoExhibit,
          $$IoExhibitsTableFilterComposer,
          $$IoExhibitsTableOrderingComposer,
          $$IoExhibitsTableAnnotationComposer,
          $$IoExhibitsTableCreateCompanionBuilder,
          $$IoExhibitsTableUpdateCompanionBuilder,
          (IoExhibit, $$IoExhibitsTableReferences),
          IoExhibit,
          PrefetchHooks Function({bool caseId})
        > {
  $$IoExhibitsTableTableManager(_$AppDatabase db, $IoExhibitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IoExhibitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IoExhibitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IoExhibitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> caseId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> seizedFrom = const Value.absent(),
                Value<String?> exhibitNo = const Value.absent(),
                Value<double?> value = const Value.absent(),
                Value<String?> valuesJson = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => IoExhibitsCompanion(
                id: id,
                caseId: caseId,
                description: description,
                category: category,
                seizedFrom: seizedFrom,
                exhibitNo: exhibitNo,
                value: value,
                valuesJson: valuesJson,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int caseId,
                required String description,
                Value<String?> category = const Value.absent(),
                Value<String?> seizedFrom = const Value.absent(),
                Value<String?> exhibitNo = const Value.absent(),
                Value<double?> value = const Value.absent(),
                Value<String?> valuesJson = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => IoExhibitsCompanion.insert(
                id: id,
                caseId: caseId,
                description: description,
                category: category,
                seizedFrom: seizedFrom,
                exhibitNo: exhibitNo,
                value: value,
                valuesJson: valuesJson,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IoExhibitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({caseId = false}) {
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
                    if (caseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.caseId,
                                referencedTable: $$IoExhibitsTableReferences
                                    ._caseIdTable(db),
                                referencedColumn: $$IoExhibitsTableReferences
                                    ._caseIdTable(db)
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

typedef $$IoExhibitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IoExhibitsTable,
      IoExhibit,
      $$IoExhibitsTableFilterComposer,
      $$IoExhibitsTableOrderingComposer,
      $$IoExhibitsTableAnnotationComposer,
      $$IoExhibitsTableCreateCompanionBuilder,
      $$IoExhibitsTableUpdateCompanionBuilder,
      (IoExhibit, $$IoExhibitsTableReferences),
      IoExhibit,
      PrefetchHooks Function({bool caseId})
    >;
typedef $$IoFormsTableCreateCompanionBuilder =
    IoFormsCompanion Function({
      Value<int> id,
      required int caseId,
      required String formId,
      Value<String?> title,
      Value<String?> valuesJson,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$IoFormsTableUpdateCompanionBuilder =
    IoFormsCompanion Function({
      Value<int> id,
      Value<int> caseId,
      Value<String> formId,
      Value<String?> title,
      Value<String?> valuesJson,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$IoFormsTableReferences
    extends BaseReferences<_$AppDatabase, $IoFormsTable, IoForm> {
  $$IoFormsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IoCasesTable _caseIdTable(_$AppDatabase db) =>
      db.ioCases.createAlias('io_forms__case_id__io_cases__id');

  $$IoCasesTableProcessedTableManager get caseId {
    final $_column = $_itemColumn<int>('case_id')!;

    final manager = $$IoCasesTableTableManager(
      $_db,
      $_db.ioCases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IoFormsTableFilterComposer
    extends Composer<_$AppDatabase, $IoFormsTable> {
  $$IoFormsTableFilterComposer({
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

  ColumnFilters<String> get formId => $composableBuilder(
    column: $table.formId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
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

  $$IoCasesTableFilterComposer get caseId {
    final $$IoCasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.ioCases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoCasesTableFilterComposer(
            $db: $db,
            $table: $db.ioCases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IoFormsTableOrderingComposer
    extends Composer<_$AppDatabase, $IoFormsTable> {
  $$IoFormsTableOrderingComposer({
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

  ColumnOrderings<String> get formId => $composableBuilder(
    column: $table.formId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
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

  $$IoCasesTableOrderingComposer get caseId {
    final $$IoCasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.ioCases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoCasesTableOrderingComposer(
            $db: $db,
            $table: $db.ioCases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IoFormsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IoFormsTable> {
  $$IoFormsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get formId =>
      $composableBuilder(column: $table.formId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$IoCasesTableAnnotationComposer get caseId {
    final $$IoCasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.ioCases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoCasesTableAnnotationComposer(
            $db: $db,
            $table: $db.ioCases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IoFormsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IoFormsTable,
          IoForm,
          $$IoFormsTableFilterComposer,
          $$IoFormsTableOrderingComposer,
          $$IoFormsTableAnnotationComposer,
          $$IoFormsTableCreateCompanionBuilder,
          $$IoFormsTableUpdateCompanionBuilder,
          (IoForm, $$IoFormsTableReferences),
          IoForm,
          PrefetchHooks Function({bool caseId})
        > {
  $$IoFormsTableTableManager(_$AppDatabase db, $IoFormsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IoFormsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IoFormsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IoFormsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> caseId = const Value.absent(),
                Value<String> formId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> valuesJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => IoFormsCompanion(
                id: id,
                caseId: caseId,
                formId: formId,
                title: title,
                valuesJson: valuesJson,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int caseId,
                required String formId,
                Value<String?> title = const Value.absent(),
                Value<String?> valuesJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => IoFormsCompanion.insert(
                id: id,
                caseId: caseId,
                formId: formId,
                title: title,
                valuesJson: valuesJson,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IoFormsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({caseId = false}) {
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
                    if (caseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.caseId,
                                referencedTable: $$IoFormsTableReferences
                                    ._caseIdTable(db),
                                referencedColumn: $$IoFormsTableReferences
                                    ._caseIdTable(db)
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

typedef $$IoFormsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IoFormsTable,
      IoForm,
      $$IoFormsTableFilterComposer,
      $$IoFormsTableOrderingComposer,
      $$IoFormsTableAnnotationComposer,
      $$IoFormsTableCreateCompanionBuilder,
      $$IoFormsTableUpdateCompanionBuilder,
      (IoForm, $$IoFormsTableReferences),
      IoForm,
      PrefetchHooks Function({bool caseId})
    >;
typedef $$IoMediaTableCreateCompanionBuilder =
    IoMediaCompanion Function({
      Value<int> id,
      required int caseId,
      Value<String?> formId,
      required String kind,
      required String filePath,
      Value<String?> caption,
      Value<double?> lat,
      Value<double?> lng,
      Value<DateTime> capturedAt,
    });
typedef $$IoMediaTableUpdateCompanionBuilder =
    IoMediaCompanion Function({
      Value<int> id,
      Value<int> caseId,
      Value<String?> formId,
      Value<String> kind,
      Value<String> filePath,
      Value<String?> caption,
      Value<double?> lat,
      Value<double?> lng,
      Value<DateTime> capturedAt,
    });

final class $$IoMediaTableReferences
    extends BaseReferences<_$AppDatabase, $IoMediaTable, IoMediaData> {
  $$IoMediaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IoCasesTable _caseIdTable(_$AppDatabase db) =>
      db.ioCases.createAlias('io_media__case_id__io_cases__id');

  $$IoCasesTableProcessedTableManager get caseId {
    final $_column = $_itemColumn<int>('case_id')!;

    final manager = $$IoCasesTableTableManager(
      $_db,
      $_db.ioCases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IoMediaTableFilterComposer
    extends Composer<_$AppDatabase, $IoMediaTable> {
  $$IoMediaTableFilterComposer({
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

  ColumnFilters<String> get formId => $composableBuilder(
    column: $table.formId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$IoCasesTableFilterComposer get caseId {
    final $$IoCasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.ioCases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoCasesTableFilterComposer(
            $db: $db,
            $table: $db.ioCases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IoMediaTableOrderingComposer
    extends Composer<_$AppDatabase, $IoMediaTable> {
  $$IoMediaTableOrderingComposer({
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

  ColumnOrderings<String> get formId => $composableBuilder(
    column: $table.formId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$IoCasesTableOrderingComposer get caseId {
    final $$IoCasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.ioCases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoCasesTableOrderingComposer(
            $db: $db,
            $table: $db.ioCases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IoMediaTableAnnotationComposer
    extends Composer<_$AppDatabase, $IoMediaTable> {
  $$IoMediaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get formId =>
      $composableBuilder(column: $table.formId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  $$IoCasesTableAnnotationComposer get caseId {
    final $$IoCasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.ioCases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IoCasesTableAnnotationComposer(
            $db: $db,
            $table: $db.ioCases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IoMediaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IoMediaTable,
          IoMediaData,
          $$IoMediaTableFilterComposer,
          $$IoMediaTableOrderingComposer,
          $$IoMediaTableAnnotationComposer,
          $$IoMediaTableCreateCompanionBuilder,
          $$IoMediaTableUpdateCompanionBuilder,
          (IoMediaData, $$IoMediaTableReferences),
          IoMediaData,
          PrefetchHooks Function({bool caseId})
        > {
  $$IoMediaTableTableManager(_$AppDatabase db, $IoMediaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IoMediaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IoMediaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IoMediaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> caseId = const Value.absent(),
                Value<String?> formId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
              }) => IoMediaCompanion(
                id: id,
                caseId: caseId,
                formId: formId,
                kind: kind,
                filePath: filePath,
                caption: caption,
                lat: lat,
                lng: lng,
                capturedAt: capturedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int caseId,
                Value<String?> formId = const Value.absent(),
                required String kind,
                required String filePath,
                Value<String?> caption = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
              }) => IoMediaCompanion.insert(
                id: id,
                caseId: caseId,
                formId: formId,
                kind: kind,
                filePath: filePath,
                caption: caption,
                lat: lat,
                lng: lng,
                capturedAt: capturedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IoMediaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({caseId = false}) {
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
                    if (caseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.caseId,
                                referencedTable: $$IoMediaTableReferences
                                    ._caseIdTable(db),
                                referencedColumn: $$IoMediaTableReferences
                                    ._caseIdTable(db)
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

typedef $$IoMediaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IoMediaTable,
      IoMediaData,
      $$IoMediaTableFilterComposer,
      $$IoMediaTableOrderingComposer,
      $$IoMediaTableAnnotationComposer,
      $$IoMediaTableCreateCompanionBuilder,
      $$IoMediaTableUpdateCompanionBuilder,
      (IoMediaData, $$IoMediaTableReferences),
      IoMediaData,
      PrefetchHooks Function({bool caseId})
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
  $$IoCasesTableTableManager get ioCases =>
      $$IoCasesTableTableManager(_db, _db.ioCases);
  $$IoPartiesTableTableManager get ioParties =>
      $$IoPartiesTableTableManager(_db, _db.ioParties);
  $$IoExhibitsTableTableManager get ioExhibits =>
      $$IoExhibitsTableTableManager(_db, _db.ioExhibits);
  $$IoFormsTableTableManager get ioForms =>
      $$IoFormsTableTableManager(_db, _db.ioForms);
  $$IoMediaTableTableManager get ioMedia =>
      $$IoMediaTableTableManager(_db, _db.ioMedia);
}
