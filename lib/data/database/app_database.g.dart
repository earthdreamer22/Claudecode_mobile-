// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfileTable extends UserProfile
    with TableInfo<$UserProfileTable, UserProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
      'age', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
      'height', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _mbtiMeta = const VerificationMeta('mbti');
  @override
  late final GeneratedColumn<String> mbti = GeneratedColumn<String>(
      'mbti', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _familyHistoryMeta =
      const VerificationMeta('familyHistory');
  @override
  late final GeneratedColumn<String> familyHistory = GeneratedColumn<String>(
      'family_history', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _existingConditionsMeta =
      const VerificationMeta('existingConditions');
  @override
  late final GeneratedColumn<String> existingConditions =
      GeneratedColumn<String>('existing_conditions', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('{}'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        age,
        gender,
        height,
        weight,
        mbti,
        familyHistory,
        existingConditions,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(Insertable<UserProfileData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('age')) {
      context.handle(
          _ageMeta, age.isAcceptableOrUnknown(data['age']!, _ageMeta));
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('mbti')) {
      context.handle(
          _mbtiMeta, mbti.isAcceptableOrUnknown(data['mbti']!, _mbtiMeta));
    }
    if (data.containsKey('family_history')) {
      context.handle(
          _familyHistoryMeta,
          familyHistory.isAcceptableOrUnknown(
              data['family_history']!, _familyHistoryMeta));
    }
    if (data.containsKey('existing_conditions')) {
      context.handle(
          _existingConditionsMeta,
          existingConditions.isAcceptableOrUnknown(
              data['existing_conditions']!, _existingConditionsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender'])!,
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight'])!,
      mbti: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mbti']),
      familyHistory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family_history'])!,
      existingConditions: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}existing_conditions'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UserProfileTable createAlias(String alias) {
    return $UserProfileTable(attachedDatabase, alias);
  }
}

class UserProfileData extends DataClass implements Insertable<UserProfileData> {
  final int id;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final String? mbti;
  final String familyHistory;
  final String existingConditions;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserProfileData(
      {required this.id,
      required this.age,
      required this.gender,
      required this.height,
      required this.weight,
      this.mbti,
      required this.familyHistory,
      required this.existingConditions,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['age'] = Variable<int>(age);
    map['gender'] = Variable<String>(gender);
    map['height'] = Variable<double>(height);
    map['weight'] = Variable<double>(weight);
    if (!nullToAbsent || mbti != null) {
      map['mbti'] = Variable<String>(mbti);
    }
    map['family_history'] = Variable<String>(familyHistory);
    map['existing_conditions'] = Variable<String>(existingConditions);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProfileCompanion toCompanion(bool nullToAbsent) {
    return UserProfileCompanion(
      id: Value(id),
      age: Value(age),
      gender: Value(gender),
      height: Value(height),
      weight: Value(weight),
      mbti: mbti == null && nullToAbsent ? const Value.absent() : Value(mbti),
      familyHistory: Value(familyHistory),
      existingConditions: Value(existingConditions),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfileData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileData(
      id: serializer.fromJson<int>(json['id']),
      age: serializer.fromJson<int>(json['age']),
      gender: serializer.fromJson<String>(json['gender']),
      height: serializer.fromJson<double>(json['height']),
      weight: serializer.fromJson<double>(json['weight']),
      mbti: serializer.fromJson<String?>(json['mbti']),
      familyHistory: serializer.fromJson<String>(json['familyHistory']),
      existingConditions:
          serializer.fromJson<String>(json['existingConditions']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'age': serializer.toJson<int>(age),
      'gender': serializer.toJson<String>(gender),
      'height': serializer.toJson<double>(height),
      'weight': serializer.toJson<double>(weight),
      'mbti': serializer.toJson<String?>(mbti),
      'familyHistory': serializer.toJson<String>(familyHistory),
      'existingConditions': serializer.toJson<String>(existingConditions),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProfileData copyWith(
          {int? id,
          int? age,
          String? gender,
          double? height,
          double? weight,
          Value<String?> mbti = const Value.absent(),
          String? familyHistory,
          String? existingConditions,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      UserProfileData(
        id: id ?? this.id,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        mbti: mbti.present ? mbti.value : this.mbti,
        familyHistory: familyHistory ?? this.familyHistory,
        existingConditions: existingConditions ?? this.existingConditions,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserProfileData copyWithCompanion(UserProfileCompanion data) {
    return UserProfileData(
      id: data.id.present ? data.id.value : this.id,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      height: data.height.present ? data.height.value : this.height,
      weight: data.weight.present ? data.weight.value : this.weight,
      mbti: data.mbti.present ? data.mbti.value : this.mbti,
      familyHistory: data.familyHistory.present
          ? data.familyHistory.value
          : this.familyHistory,
      existingConditions: data.existingConditions.present
          ? data.existingConditions.value
          : this.existingConditions,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileData(')
          ..write('id: $id, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('mbti: $mbti, ')
          ..write('familyHistory: $familyHistory, ')
          ..write('existingConditions: $existingConditions, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, age, gender, height, weight, mbti,
      familyHistory, existingConditions, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileData &&
          other.id == this.id &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.height == this.height &&
          other.weight == this.weight &&
          other.mbti == this.mbti &&
          other.familyHistory == this.familyHistory &&
          other.existingConditions == this.existingConditions &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfileCompanion extends UpdateCompanion<UserProfileData> {
  final Value<int> id;
  final Value<int> age;
  final Value<String> gender;
  final Value<double> height;
  final Value<double> weight;
  final Value<String?> mbti;
  final Value<String> familyHistory;
  final Value<String> existingConditions;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserProfileCompanion({
    this.id = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.height = const Value.absent(),
    this.weight = const Value.absent(),
    this.mbti = const Value.absent(),
    this.familyHistory = const Value.absent(),
    this.existingConditions = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserProfileCompanion.insert({
    this.id = const Value.absent(),
    required int age,
    required String gender,
    required double height,
    required double weight,
    this.mbti = const Value.absent(),
    this.familyHistory = const Value.absent(),
    this.existingConditions = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : age = Value(age),
        gender = Value(gender),
        height = Value(height),
        weight = Value(weight);
  static Insertable<UserProfileData> custom({
    Expression<int>? id,
    Expression<int>? age,
    Expression<String>? gender,
    Expression<double>? height,
    Expression<double>? weight,
    Expression<String>? mbti,
    Expression<String>? familyHistory,
    Expression<String>? existingConditions,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (mbti != null) 'mbti': mbti,
      if (familyHistory != null) 'family_history': familyHistory,
      if (existingConditions != null) 'existing_conditions': existingConditions,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserProfileCompanion copyWith(
      {Value<int>? id,
      Value<int>? age,
      Value<String>? gender,
      Value<double>? height,
      Value<double>? weight,
      Value<String?>? mbti,
      Value<String>? familyHistory,
      Value<String>? existingConditions,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UserProfileCompanion(
      id: id ?? this.id,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      mbti: mbti ?? this.mbti,
      familyHistory: familyHistory ?? this.familyHistory,
      existingConditions: existingConditions ?? this.existingConditions,
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
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (mbti.present) {
      map['mbti'] = Variable<String>(mbti.value);
    }
    if (familyHistory.present) {
      map['family_history'] = Variable<String>(familyHistory.value);
    }
    if (existingConditions.present) {
      map['existing_conditions'] = Variable<String>(existingConditions.value);
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
    return (StringBuffer('UserProfileCompanion(')
          ..write('id: $id, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('mbti: $mbti, ')
          ..write('familyHistory: $familyHistory, ')
          ..write('existingConditions: $existingConditions, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReceiptsTable extends Receipts
    with TableInfo<$ReceiptsTable, ReceiptData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES user_profile (id)'));
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rawOcrTextMeta =
      const VerificationMeta('rawOcrText');
  @override
  late final GeneratedColumn<String> rawOcrText = GeneratedColumn<String>(
      'raw_ocr_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parsedItemCountMeta =
      const VerificationMeta('parsedItemCount');
  @override
  late final GeneratedColumn<int> parsedItemCount = GeneratedColumn<int>(
      'parsed_item_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _receiptDateMeta =
      const VerificationMeta('receiptDate');
  @override
  late final GeneratedColumn<DateTime> receiptDate = GeneratedColumn<DateTime>(
      'receipt_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        imagePath,
        rawOcrText,
        parsedItemCount,
        totalAmount,
        receiptDate,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receipts';
  @override
  VerificationContext validateIntegrity(Insertable<ReceiptData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('raw_ocr_text')) {
      context.handle(
          _rawOcrTextMeta,
          rawOcrText.isAcceptableOrUnknown(
              data['raw_ocr_text']!, _rawOcrTextMeta));
    } else if (isInserting) {
      context.missing(_rawOcrTextMeta);
    }
    if (data.containsKey('parsed_item_count')) {
      context.handle(
          _parsedItemCountMeta,
          parsedItemCount.isAcceptableOrUnknown(
              data['parsed_item_count']!, _parsedItemCountMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    }
    if (data.containsKey('receipt_date')) {
      context.handle(
          _receiptDateMeta,
          receiptDate.isAcceptableOrUnknown(
              data['receipt_date']!, _receiptDateMeta));
    } else if (isInserting) {
      context.missing(_receiptDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReceiptData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReceiptData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path'])!,
      rawOcrText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}raw_ocr_text'])!,
      parsedItemCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parsed_item_count'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount']),
      receiptDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}receipt_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ReceiptsTable createAlias(String alias) {
    return $ReceiptsTable(attachedDatabase, alias);
  }
}

class ReceiptData extends DataClass implements Insertable<ReceiptData> {
  final int id;
  final int userId;
  final String imagePath;
  final String rawOcrText;
  final int parsedItemCount;
  final double? totalAmount;
  final DateTime receiptDate;
  final DateTime createdAt;
  const ReceiptData(
      {required this.id,
      required this.userId,
      required this.imagePath,
      required this.rawOcrText,
      required this.parsedItemCount,
      this.totalAmount,
      required this.receiptDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['image_path'] = Variable<String>(imagePath);
    map['raw_ocr_text'] = Variable<String>(rawOcrText);
    map['parsed_item_count'] = Variable<int>(parsedItemCount);
    if (!nullToAbsent || totalAmount != null) {
      map['total_amount'] = Variable<double>(totalAmount);
    }
    map['receipt_date'] = Variable<DateTime>(receiptDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReceiptsCompanion toCompanion(bool nullToAbsent) {
    return ReceiptsCompanion(
      id: Value(id),
      userId: Value(userId),
      imagePath: Value(imagePath),
      rawOcrText: Value(rawOcrText),
      parsedItemCount: Value(parsedItemCount),
      totalAmount: totalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(totalAmount),
      receiptDate: Value(receiptDate),
      createdAt: Value(createdAt),
    );
  }

  factory ReceiptData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReceiptData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      rawOcrText: serializer.fromJson<String>(json['rawOcrText']),
      parsedItemCount: serializer.fromJson<int>(json['parsedItemCount']),
      totalAmount: serializer.fromJson<double?>(json['totalAmount']),
      receiptDate: serializer.fromJson<DateTime>(json['receiptDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'imagePath': serializer.toJson<String>(imagePath),
      'rawOcrText': serializer.toJson<String>(rawOcrText),
      'parsedItemCount': serializer.toJson<int>(parsedItemCount),
      'totalAmount': serializer.toJson<double?>(totalAmount),
      'receiptDate': serializer.toJson<DateTime>(receiptDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReceiptData copyWith(
          {int? id,
          int? userId,
          String? imagePath,
          String? rawOcrText,
          int? parsedItemCount,
          Value<double?> totalAmount = const Value.absent(),
          DateTime? receiptDate,
          DateTime? createdAt}) =>
      ReceiptData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        imagePath: imagePath ?? this.imagePath,
        rawOcrText: rawOcrText ?? this.rawOcrText,
        parsedItemCount: parsedItemCount ?? this.parsedItemCount,
        totalAmount: totalAmount.present ? totalAmount.value : this.totalAmount,
        receiptDate: receiptDate ?? this.receiptDate,
        createdAt: createdAt ?? this.createdAt,
      );
  ReceiptData copyWithCompanion(ReceiptsCompanion data) {
    return ReceiptData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      rawOcrText:
          data.rawOcrText.present ? data.rawOcrText.value : this.rawOcrText,
      parsedItemCount: data.parsedItemCount.present
          ? data.parsedItemCount.value
          : this.parsedItemCount,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      receiptDate:
          data.receiptDate.present ? data.receiptDate.value : this.receiptDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('imagePath: $imagePath, ')
          ..write('rawOcrText: $rawOcrText, ')
          ..write('parsedItemCount: $parsedItemCount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('receiptDate: $receiptDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, imagePath, rawOcrText,
      parsedItemCount, totalAmount, receiptDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceiptData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.imagePath == this.imagePath &&
          other.rawOcrText == this.rawOcrText &&
          other.parsedItemCount == this.parsedItemCount &&
          other.totalAmount == this.totalAmount &&
          other.receiptDate == this.receiptDate &&
          other.createdAt == this.createdAt);
}

class ReceiptsCompanion extends UpdateCompanion<ReceiptData> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> imagePath;
  final Value<String> rawOcrText;
  final Value<int> parsedItemCount;
  final Value<double?> totalAmount;
  final Value<DateTime> receiptDate;
  final Value<DateTime> createdAt;
  const ReceiptsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.rawOcrText = const Value.absent(),
    this.parsedItemCount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.receiptDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ReceiptsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String imagePath,
    required String rawOcrText,
    this.parsedItemCount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    required DateTime receiptDate,
    this.createdAt = const Value.absent(),
  })  : userId = Value(userId),
        imagePath = Value(imagePath),
        rawOcrText = Value(rawOcrText),
        receiptDate = Value(receiptDate);
  static Insertable<ReceiptData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? imagePath,
    Expression<String>? rawOcrText,
    Expression<int>? parsedItemCount,
    Expression<double>? totalAmount,
    Expression<DateTime>? receiptDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (imagePath != null) 'image_path': imagePath,
      if (rawOcrText != null) 'raw_ocr_text': rawOcrText,
      if (parsedItemCount != null) 'parsed_item_count': parsedItemCount,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (receiptDate != null) 'receipt_date': receiptDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ReceiptsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<String>? imagePath,
      Value<String>? rawOcrText,
      Value<int>? parsedItemCount,
      Value<double?>? totalAmount,
      Value<DateTime>? receiptDate,
      Value<DateTime>? createdAt}) {
    return ReceiptsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imagePath: imagePath ?? this.imagePath,
      rawOcrText: rawOcrText ?? this.rawOcrText,
      parsedItemCount: parsedItemCount ?? this.parsedItemCount,
      totalAmount: totalAmount ?? this.totalAmount,
      receiptDate: receiptDate ?? this.receiptDate,
      createdAt: createdAt ?? this.createdAt,
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
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (rawOcrText.present) {
      map['raw_ocr_text'] = Variable<String>(rawOcrText.value);
    }
    if (parsedItemCount.present) {
      map['parsed_item_count'] = Variable<int>(parsedItemCount.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (receiptDate.present) {
      map['receipt_date'] = Variable<DateTime>(receiptDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('imagePath: $imagePath, ')
          ..write('rawOcrText: $rawOcrText, ')
          ..write('parsedItemCount: $parsedItemCount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('receiptDate: $receiptDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FoodItemsTable extends FoodItems
    with TableInfo<$FoodItemsTable, FoodItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _receiptIdMeta =
      const VerificationMeta('receiptId');
  @override
  late final GeneratedColumn<int> receiptId = GeneratedColumn<int>(
      'receipt_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES receipts (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _caloriesMeta =
      const VerificationMeta('calories');
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
      'calories', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sodiumMgMeta =
      const VerificationMeta('sodiumMg');
  @override
  late final GeneratedColumn<int> sodiumMg = GeneratedColumn<int>(
      'sodium_mg', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sugarGMeta = const VerificationMeta('sugarG');
  @override
  late final GeneratedColumn<double> sugarG = GeneratedColumn<double>(
      'sugar_g', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<double> fatG = GeneratedColumn<double>(
      'fat_g', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _proteinGMeta =
      const VerificationMeta('proteinG');
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
      'protein_g', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
      'carbs_g', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
      'added_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        receiptId,
        name,
        category,
        price,
        calories,
        sodiumMg,
        sugarG,
        fatG,
        proteinG,
        carbsG,
        quantity,
        addedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_items';
  @override
  VerificationContext validateIntegrity(Insertable<FoodItemData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('receipt_id')) {
      context.handle(_receiptIdMeta,
          receiptId.isAcceptableOrUnknown(data['receipt_id']!, _receiptIdMeta));
    } else if (isInserting) {
      context.missing(_receiptIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('calories')) {
      context.handle(_caloriesMeta,
          calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta));
    }
    if (data.containsKey('sodium_mg')) {
      context.handle(_sodiumMgMeta,
          sodiumMg.isAcceptableOrUnknown(data['sodium_mg']!, _sodiumMgMeta));
    }
    if (data.containsKey('sugar_g')) {
      context.handle(_sugarGMeta,
          sugarG.isAcceptableOrUnknown(data['sugar_g']!, _sugarGMeta));
    }
    if (data.containsKey('fat_g')) {
      context.handle(
          _fatGMeta, fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta));
    }
    if (data.containsKey('protein_g')) {
      context.handle(_proteinGMeta,
          proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta));
    }
    if (data.containsKey('carbs_g')) {
      context.handle(_carbsGMeta,
          carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodItemData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      receiptId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}receipt_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price']),
      calories: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}calories']),
      sodiumMg: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sodium_mg']),
      sugarG: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sugar_g']),
      fatG: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat_g']),
      proteinG: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}protein_g']),
      carbsG: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carbs_g']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      addedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_at'])!,
    );
  }

  @override
  $FoodItemsTable createAlias(String alias) {
    return $FoodItemsTable(attachedDatabase, alias);
  }
}

class FoodItemData extends DataClass implements Insertable<FoodItemData> {
  final int id;
  final int receiptId;
  final String name;
  final String category;
  final double? price;
  final int? calories;
  final int? sodiumMg;
  final double? sugarG;
  final double? fatG;
  final double? proteinG;
  final double? carbsG;
  final int quantity;
  final DateTime addedAt;
  const FoodItemData(
      {required this.id,
      required this.receiptId,
      required this.name,
      required this.category,
      this.price,
      this.calories,
      this.sodiumMg,
      this.sugarG,
      this.fatG,
      this.proteinG,
      this.carbsG,
      required this.quantity,
      required this.addedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['receipt_id'] = Variable<int>(receiptId);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    if (!nullToAbsent || calories != null) {
      map['calories'] = Variable<int>(calories);
    }
    if (!nullToAbsent || sodiumMg != null) {
      map['sodium_mg'] = Variable<int>(sodiumMg);
    }
    if (!nullToAbsent || sugarG != null) {
      map['sugar_g'] = Variable<double>(sugarG);
    }
    if (!nullToAbsent || fatG != null) {
      map['fat_g'] = Variable<double>(fatG);
    }
    if (!nullToAbsent || proteinG != null) {
      map['protein_g'] = Variable<double>(proteinG);
    }
    if (!nullToAbsent || carbsG != null) {
      map['carbs_g'] = Variable<double>(carbsG);
    }
    map['quantity'] = Variable<int>(quantity);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  FoodItemsCompanion toCompanion(bool nullToAbsent) {
    return FoodItemsCompanion(
      id: Value(id),
      receiptId: Value(receiptId),
      name: Value(name),
      category: Value(category),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      calories: calories == null && nullToAbsent
          ? const Value.absent()
          : Value(calories),
      sodiumMg: sodiumMg == null && nullToAbsent
          ? const Value.absent()
          : Value(sodiumMg),
      sugarG:
          sugarG == null && nullToAbsent ? const Value.absent() : Value(sugarG),
      fatG: fatG == null && nullToAbsent ? const Value.absent() : Value(fatG),
      proteinG: proteinG == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinG),
      carbsG:
          carbsG == null && nullToAbsent ? const Value.absent() : Value(carbsG),
      quantity: Value(quantity),
      addedAt: Value(addedAt),
    );
  }

  factory FoodItemData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodItemData(
      id: serializer.fromJson<int>(json['id']),
      receiptId: serializer.fromJson<int>(json['receiptId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      price: serializer.fromJson<double?>(json['price']),
      calories: serializer.fromJson<int?>(json['calories']),
      sodiumMg: serializer.fromJson<int?>(json['sodiumMg']),
      sugarG: serializer.fromJson<double?>(json['sugarG']),
      fatG: serializer.fromJson<double?>(json['fatG']),
      proteinG: serializer.fromJson<double?>(json['proteinG']),
      carbsG: serializer.fromJson<double?>(json['carbsG']),
      quantity: serializer.fromJson<int>(json['quantity']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'receiptId': serializer.toJson<int>(receiptId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'price': serializer.toJson<double?>(price),
      'calories': serializer.toJson<int?>(calories),
      'sodiumMg': serializer.toJson<int?>(sodiumMg),
      'sugarG': serializer.toJson<double?>(sugarG),
      'fatG': serializer.toJson<double?>(fatG),
      'proteinG': serializer.toJson<double?>(proteinG),
      'carbsG': serializer.toJson<double?>(carbsG),
      'quantity': serializer.toJson<int>(quantity),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  FoodItemData copyWith(
          {int? id,
          int? receiptId,
          String? name,
          String? category,
          Value<double?> price = const Value.absent(),
          Value<int?> calories = const Value.absent(),
          Value<int?> sodiumMg = const Value.absent(),
          Value<double?> sugarG = const Value.absent(),
          Value<double?> fatG = const Value.absent(),
          Value<double?> proteinG = const Value.absent(),
          Value<double?> carbsG = const Value.absent(),
          int? quantity,
          DateTime? addedAt}) =>
      FoodItemData(
        id: id ?? this.id,
        receiptId: receiptId ?? this.receiptId,
        name: name ?? this.name,
        category: category ?? this.category,
        price: price.present ? price.value : this.price,
        calories: calories.present ? calories.value : this.calories,
        sodiumMg: sodiumMg.present ? sodiumMg.value : this.sodiumMg,
        sugarG: sugarG.present ? sugarG.value : this.sugarG,
        fatG: fatG.present ? fatG.value : this.fatG,
        proteinG: proteinG.present ? proteinG.value : this.proteinG,
        carbsG: carbsG.present ? carbsG.value : this.carbsG,
        quantity: quantity ?? this.quantity,
        addedAt: addedAt ?? this.addedAt,
      );
  FoodItemData copyWithCompanion(FoodItemsCompanion data) {
    return FoodItemData(
      id: data.id.present ? data.id.value : this.id,
      receiptId: data.receiptId.present ? data.receiptId.value : this.receiptId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      price: data.price.present ? data.price.value : this.price,
      calories: data.calories.present ? data.calories.value : this.calories,
      sodiumMg: data.sodiumMg.present ? data.sodiumMg.value : this.sodiumMg,
      sugarG: data.sugarG.present ? data.sugarG.value : this.sugarG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemData(')
          ..write('id: $id, ')
          ..write('receiptId: $receiptId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('calories: $calories, ')
          ..write('sodiumMg: $sodiumMg, ')
          ..write('sugarG: $sugarG, ')
          ..write('fatG: $fatG, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('quantity: $quantity, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, receiptId, name, category, price,
      calories, sodiumMg, sugarG, fatG, proteinG, carbsG, quantity, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodItemData &&
          other.id == this.id &&
          other.receiptId == this.receiptId &&
          other.name == this.name &&
          other.category == this.category &&
          other.price == this.price &&
          other.calories == this.calories &&
          other.sodiumMg == this.sodiumMg &&
          other.sugarG == this.sugarG &&
          other.fatG == this.fatG &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.quantity == this.quantity &&
          other.addedAt == this.addedAt);
}

class FoodItemsCompanion extends UpdateCompanion<FoodItemData> {
  final Value<int> id;
  final Value<int> receiptId;
  final Value<String> name;
  final Value<String> category;
  final Value<double?> price;
  final Value<int?> calories;
  final Value<int?> sodiumMg;
  final Value<double?> sugarG;
  final Value<double?> fatG;
  final Value<double?> proteinG;
  final Value<double?> carbsG;
  final Value<int> quantity;
  final Value<DateTime> addedAt;
  const FoodItemsCompanion({
    this.id = const Value.absent(),
    this.receiptId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.price = const Value.absent(),
    this.calories = const Value.absent(),
    this.sodiumMg = const Value.absent(),
    this.sugarG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.quantity = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  FoodItemsCompanion.insert({
    this.id = const Value.absent(),
    required int receiptId,
    required String name,
    required String category,
    this.price = const Value.absent(),
    this.calories = const Value.absent(),
    this.sodiumMg = const Value.absent(),
    this.sugarG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.quantity = const Value.absent(),
    this.addedAt = const Value.absent(),
  })  : receiptId = Value(receiptId),
        name = Value(name),
        category = Value(category);
  static Insertable<FoodItemData> custom({
    Expression<int>? id,
    Expression<int>? receiptId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<double>? price,
    Expression<int>? calories,
    Expression<int>? sodiumMg,
    Expression<double>? sugarG,
    Expression<double>? fatG,
    Expression<double>? proteinG,
    Expression<double>? carbsG,
    Expression<int>? quantity,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receiptId != null) 'receipt_id': receiptId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (price != null) 'price': price,
      if (calories != null) 'calories': calories,
      if (sodiumMg != null) 'sodium_mg': sodiumMg,
      if (sugarG != null) 'sugar_g': sugarG,
      if (fatG != null) 'fat_g': fatG,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (quantity != null) 'quantity': quantity,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  FoodItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? receiptId,
      Value<String>? name,
      Value<String>? category,
      Value<double?>? price,
      Value<int?>? calories,
      Value<int?>? sodiumMg,
      Value<double?>? sugarG,
      Value<double?>? fatG,
      Value<double?>? proteinG,
      Value<double?>? carbsG,
      Value<int>? quantity,
      Value<DateTime>? addedAt}) {
    return FoodItemsCompanion(
      id: id ?? this.id,
      receiptId: receiptId ?? this.receiptId,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      calories: calories ?? this.calories,
      sodiumMg: sodiumMg ?? this.sodiumMg,
      sugarG: sugarG ?? this.sugarG,
      fatG: fatG ?? this.fatG,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (receiptId.present) {
      map['receipt_id'] = Variable<int>(receiptId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (sodiumMg.present) {
      map['sodium_mg'] = Variable<int>(sodiumMg.value);
    }
    if (sugarG.present) {
      map['sugar_g'] = Variable<double>(sugarG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<double>(fatG.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemsCompanion(')
          ..write('id: $id, ')
          ..write('receiptId: $receiptId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('calories: $calories, ')
          ..write('sodiumMg: $sodiumMg, ')
          ..write('sugarG: $sugarG, ')
          ..write('fatG: $fatG, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('quantity: $quantity, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $NutritionAnalysesTable extends NutritionAnalyses
    with TableInfo<$NutritionAnalysesTable, NutritionAnalysisData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutritionAnalysesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES user_profile (id)'));
  static const VerificationMeta _analysisDateMeta =
      const VerificationMeta('analysisDate');
  @override
  late final GeneratedColumn<DateTime> analysisDate = GeneratedColumn<DateTime>(
      'analysis_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dietCharacterMeta =
      const VerificationMeta('dietCharacter');
  @override
  late final GeneratedColumn<String> dietCharacter = GeneratedColumn<String>(
      'diet_character', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _purchasePatternsMeta =
      const VerificationMeta('purchasePatterns');
  @override
  late final GeneratedColumn<String> purchasePatterns = GeneratedColumn<String>(
      'purchase_patterns', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deficiencyWarningsMeta =
      const VerificationMeta('deficiencyWarnings');
  @override
  late final GeneratedColumn<String> deficiencyWarnings =
      GeneratedColumn<String>('deficiency_warnings', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _futureScenariosMeta =
      const VerificationMeta('futureScenarios');
  @override
  late final GeneratedColumn<String> futureScenarios = GeneratedColumn<String>(
      'future_scenarios', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _trendComparisonMeta =
      const VerificationMeta('trendComparison');
  @override
  late final GeneratedColumn<String> trendComparison = GeneratedColumn<String>(
      'trend_comparison', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        analysisDate,
        dietCharacter,
        purchasePatterns,
        deficiencyWarnings,
        futureScenarios,
        trendComparison,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrition_analyses';
  @override
  VerificationContext validateIntegrity(
      Insertable<NutritionAnalysisData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('analysis_date')) {
      context.handle(
          _analysisDateMeta,
          analysisDate.isAcceptableOrUnknown(
              data['analysis_date']!, _analysisDateMeta));
    } else if (isInserting) {
      context.missing(_analysisDateMeta);
    }
    if (data.containsKey('diet_character')) {
      context.handle(
          _dietCharacterMeta,
          dietCharacter.isAcceptableOrUnknown(
              data['diet_character']!, _dietCharacterMeta));
    } else if (isInserting) {
      context.missing(_dietCharacterMeta);
    }
    if (data.containsKey('purchase_patterns')) {
      context.handle(
          _purchasePatternsMeta,
          purchasePatterns.isAcceptableOrUnknown(
              data['purchase_patterns']!, _purchasePatternsMeta));
    } else if (isInserting) {
      context.missing(_purchasePatternsMeta);
    }
    if (data.containsKey('deficiency_warnings')) {
      context.handle(
          _deficiencyWarningsMeta,
          deficiencyWarnings.isAcceptableOrUnknown(
              data['deficiency_warnings']!, _deficiencyWarningsMeta));
    } else if (isInserting) {
      context.missing(_deficiencyWarningsMeta);
    }
    if (data.containsKey('future_scenarios')) {
      context.handle(
          _futureScenariosMeta,
          futureScenarios.isAcceptableOrUnknown(
              data['future_scenarios']!, _futureScenariosMeta));
    } else if (isInserting) {
      context.missing(_futureScenariosMeta);
    }
    if (data.containsKey('trend_comparison')) {
      context.handle(
          _trendComparisonMeta,
          trendComparison.isAcceptableOrUnknown(
              data['trend_comparison']!, _trendComparisonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NutritionAnalysisData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutritionAnalysisData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      analysisDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}analysis_date'])!,
      dietCharacter: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}diet_character'])!,
      purchasePatterns: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}purchase_patterns'])!,
      deficiencyWarnings: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}deficiency_warnings'])!,
      futureScenarios: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}future_scenarios'])!,
      trendComparison: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}trend_comparison']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $NutritionAnalysesTable createAlias(String alias) {
    return $NutritionAnalysesTable(attachedDatabase, alias);
  }
}

class NutritionAnalysisData extends DataClass
    implements Insertable<NutritionAnalysisData> {
  final int id;
  final int userId;
  final DateTime analysisDate;
  final String dietCharacter;
  final String purchasePatterns;
  final String deficiencyWarnings;
  final String futureScenarios;
  final String? trendComparison;
  final DateTime createdAt;
  const NutritionAnalysisData(
      {required this.id,
      required this.userId,
      required this.analysisDate,
      required this.dietCharacter,
      required this.purchasePatterns,
      required this.deficiencyWarnings,
      required this.futureScenarios,
      this.trendComparison,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['analysis_date'] = Variable<DateTime>(analysisDate);
    map['diet_character'] = Variable<String>(dietCharacter);
    map['purchase_patterns'] = Variable<String>(purchasePatterns);
    map['deficiency_warnings'] = Variable<String>(deficiencyWarnings);
    map['future_scenarios'] = Variable<String>(futureScenarios);
    if (!nullToAbsent || trendComparison != null) {
      map['trend_comparison'] = Variable<String>(trendComparison);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NutritionAnalysesCompanion toCompanion(bool nullToAbsent) {
    return NutritionAnalysesCompanion(
      id: Value(id),
      userId: Value(userId),
      analysisDate: Value(analysisDate),
      dietCharacter: Value(dietCharacter),
      purchasePatterns: Value(purchasePatterns),
      deficiencyWarnings: Value(deficiencyWarnings),
      futureScenarios: Value(futureScenarios),
      trendComparison: trendComparison == null && nullToAbsent
          ? const Value.absent()
          : Value(trendComparison),
      createdAt: Value(createdAt),
    );
  }

  factory NutritionAnalysisData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutritionAnalysisData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      analysisDate: serializer.fromJson<DateTime>(json['analysisDate']),
      dietCharacter: serializer.fromJson<String>(json['dietCharacter']),
      purchasePatterns: serializer.fromJson<String>(json['purchasePatterns']),
      deficiencyWarnings:
          serializer.fromJson<String>(json['deficiencyWarnings']),
      futureScenarios: serializer.fromJson<String>(json['futureScenarios']),
      trendComparison: serializer.fromJson<String?>(json['trendComparison']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'analysisDate': serializer.toJson<DateTime>(analysisDate),
      'dietCharacter': serializer.toJson<String>(dietCharacter),
      'purchasePatterns': serializer.toJson<String>(purchasePatterns),
      'deficiencyWarnings': serializer.toJson<String>(deficiencyWarnings),
      'futureScenarios': serializer.toJson<String>(futureScenarios),
      'trendComparison': serializer.toJson<String?>(trendComparison),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NutritionAnalysisData copyWith(
          {int? id,
          int? userId,
          DateTime? analysisDate,
          String? dietCharacter,
          String? purchasePatterns,
          String? deficiencyWarnings,
          String? futureScenarios,
          Value<String?> trendComparison = const Value.absent(),
          DateTime? createdAt}) =>
      NutritionAnalysisData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        analysisDate: analysisDate ?? this.analysisDate,
        dietCharacter: dietCharacter ?? this.dietCharacter,
        purchasePatterns: purchasePatterns ?? this.purchasePatterns,
        deficiencyWarnings: deficiencyWarnings ?? this.deficiencyWarnings,
        futureScenarios: futureScenarios ?? this.futureScenarios,
        trendComparison: trendComparison.present
            ? trendComparison.value
            : this.trendComparison,
        createdAt: createdAt ?? this.createdAt,
      );
  NutritionAnalysisData copyWithCompanion(NutritionAnalysesCompanion data) {
    return NutritionAnalysisData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      analysisDate: data.analysisDate.present
          ? data.analysisDate.value
          : this.analysisDate,
      dietCharacter: data.dietCharacter.present
          ? data.dietCharacter.value
          : this.dietCharacter,
      purchasePatterns: data.purchasePatterns.present
          ? data.purchasePatterns.value
          : this.purchasePatterns,
      deficiencyWarnings: data.deficiencyWarnings.present
          ? data.deficiencyWarnings.value
          : this.deficiencyWarnings,
      futureScenarios: data.futureScenarios.present
          ? data.futureScenarios.value
          : this.futureScenarios,
      trendComparison: data.trendComparison.present
          ? data.trendComparison.value
          : this.trendComparison,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutritionAnalysisData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('analysisDate: $analysisDate, ')
          ..write('dietCharacter: $dietCharacter, ')
          ..write('purchasePatterns: $purchasePatterns, ')
          ..write('deficiencyWarnings: $deficiencyWarnings, ')
          ..write('futureScenarios: $futureScenarios, ')
          ..write('trendComparison: $trendComparison, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      analysisDate,
      dietCharacter,
      purchasePatterns,
      deficiencyWarnings,
      futureScenarios,
      trendComparison,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutritionAnalysisData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.analysisDate == this.analysisDate &&
          other.dietCharacter == this.dietCharacter &&
          other.purchasePatterns == this.purchasePatterns &&
          other.deficiencyWarnings == this.deficiencyWarnings &&
          other.futureScenarios == this.futureScenarios &&
          other.trendComparison == this.trendComparison &&
          other.createdAt == this.createdAt);
}

class NutritionAnalysesCompanion
    extends UpdateCompanion<NutritionAnalysisData> {
  final Value<int> id;
  final Value<int> userId;
  final Value<DateTime> analysisDate;
  final Value<String> dietCharacter;
  final Value<String> purchasePatterns;
  final Value<String> deficiencyWarnings;
  final Value<String> futureScenarios;
  final Value<String?> trendComparison;
  final Value<DateTime> createdAt;
  const NutritionAnalysesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.analysisDate = const Value.absent(),
    this.dietCharacter = const Value.absent(),
    this.purchasePatterns = const Value.absent(),
    this.deficiencyWarnings = const Value.absent(),
    this.futureScenarios = const Value.absent(),
    this.trendComparison = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  NutritionAnalysesCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required DateTime analysisDate,
    required String dietCharacter,
    required String purchasePatterns,
    required String deficiencyWarnings,
    required String futureScenarios,
    this.trendComparison = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : userId = Value(userId),
        analysisDate = Value(analysisDate),
        dietCharacter = Value(dietCharacter),
        purchasePatterns = Value(purchasePatterns),
        deficiencyWarnings = Value(deficiencyWarnings),
        futureScenarios = Value(futureScenarios);
  static Insertable<NutritionAnalysisData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<DateTime>? analysisDate,
    Expression<String>? dietCharacter,
    Expression<String>? purchasePatterns,
    Expression<String>? deficiencyWarnings,
    Expression<String>? futureScenarios,
    Expression<String>? trendComparison,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (analysisDate != null) 'analysis_date': analysisDate,
      if (dietCharacter != null) 'diet_character': dietCharacter,
      if (purchasePatterns != null) 'purchase_patterns': purchasePatterns,
      if (deficiencyWarnings != null) 'deficiency_warnings': deficiencyWarnings,
      if (futureScenarios != null) 'future_scenarios': futureScenarios,
      if (trendComparison != null) 'trend_comparison': trendComparison,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  NutritionAnalysesCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<DateTime>? analysisDate,
      Value<String>? dietCharacter,
      Value<String>? purchasePatterns,
      Value<String>? deficiencyWarnings,
      Value<String>? futureScenarios,
      Value<String?>? trendComparison,
      Value<DateTime>? createdAt}) {
    return NutritionAnalysesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      analysisDate: analysisDate ?? this.analysisDate,
      dietCharacter: dietCharacter ?? this.dietCharacter,
      purchasePatterns: purchasePatterns ?? this.purchasePatterns,
      deficiencyWarnings: deficiencyWarnings ?? this.deficiencyWarnings,
      futureScenarios: futureScenarios ?? this.futureScenarios,
      trendComparison: trendComparison ?? this.trendComparison,
      createdAt: createdAt ?? this.createdAt,
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
    if (analysisDate.present) {
      map['analysis_date'] = Variable<DateTime>(analysisDate.value);
    }
    if (dietCharacter.present) {
      map['diet_character'] = Variable<String>(dietCharacter.value);
    }
    if (purchasePatterns.present) {
      map['purchase_patterns'] = Variable<String>(purchasePatterns.value);
    }
    if (deficiencyWarnings.present) {
      map['deficiency_warnings'] = Variable<String>(deficiencyWarnings.value);
    }
    if (futureScenarios.present) {
      map['future_scenarios'] = Variable<String>(futureScenarios.value);
    }
    if (trendComparison.present) {
      map['trend_comparison'] = Variable<String>(trendComparison.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutritionAnalysesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('analysisDate: $analysisDate, ')
          ..write('dietCharacter: $dietCharacter, ')
          ..write('purchasePatterns: $purchasePatterns, ')
          ..write('deficiencyWarnings: $deficiencyWarnings, ')
          ..write('futureScenarios: $futureScenarios, ')
          ..write('trendComparison: $trendComparison, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfileTable userProfile = $UserProfileTable(this);
  late final $ReceiptsTable receipts = $ReceiptsTable(this);
  late final $FoodItemsTable foodItems = $FoodItemsTable(this);
  late final $NutritionAnalysesTable nutritionAnalyses =
      $NutritionAnalysesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [userProfile, receipts, foodItems, nutritionAnalyses];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('receipts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('food_items', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$UserProfileTableCreateCompanionBuilder = UserProfileCompanion
    Function({
  Value<int> id,
  required int age,
  required String gender,
  required double height,
  required double weight,
  Value<String?> mbti,
  Value<String> familyHistory,
  Value<String> existingConditions,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$UserProfileTableUpdateCompanionBuilder = UserProfileCompanion
    Function({
  Value<int> id,
  Value<int> age,
  Value<String> gender,
  Value<double> height,
  Value<double> weight,
  Value<String?> mbti,
  Value<String> familyHistory,
  Value<String> existingConditions,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$UserProfileTableReferences
    extends BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileData> {
  $$UserProfileTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReceiptsTable, List<ReceiptData>>
      _receiptsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.receipts,
              aliasName:
                  $_aliasNameGenerator(db.userProfile.id, db.receipts.userId));

  $$ReceiptsTableProcessedTableManager get receiptsRefs {
    final manager = $$ReceiptsTableTableManager($_db, $_db.receipts)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_receiptsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$NutritionAnalysesTable,
      List<NutritionAnalysisData>> _nutritionAnalysesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.nutritionAnalyses,
          aliasName: $_aliasNameGenerator(
              db.userProfile.id, db.nutritionAnalyses.userId));

  $$NutritionAnalysesTableProcessedTableManager get nutritionAnalysesRefs {
    final manager =
        $$NutritionAnalysesTableTableManager($_db, $_db.nutritionAnalyses)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_nutritionAnalysesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UserProfileTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mbti => $composableBuilder(
      column: $table.mbti, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get familyHistory => $composableBuilder(
      column: $table.familyHistory, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get existingConditions => $composableBuilder(
      column: $table.existingConditions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> receiptsRefs(
      Expression<bool> Function($$ReceiptsTableFilterComposer f) f) {
    final $$ReceiptsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.receipts,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReceiptsTableFilterComposer(
              $db: $db,
              $table: $db.receipts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> nutritionAnalysesRefs(
      Expression<bool> Function($$NutritionAnalysesTableFilterComposer f) f) {
    final $$NutritionAnalysesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.nutritionAnalyses,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NutritionAnalysesTableFilterComposer(
              $db: $db,
              $table: $db.nutritionAnalyses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UserProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mbti => $composableBuilder(
      column: $table.mbti, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get familyHistory => $composableBuilder(
      column: $table.familyHistory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get existingConditions => $composableBuilder(
      column: $table.existingConditions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UserProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get mbti =>
      $composableBuilder(column: $table.mbti, builder: (column) => column);

  GeneratedColumn<String> get familyHistory => $composableBuilder(
      column: $table.familyHistory, builder: (column) => column);

  GeneratedColumn<String> get existingConditions => $composableBuilder(
      column: $table.existingConditions, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> receiptsRefs<T extends Object>(
      Expression<T> Function($$ReceiptsTableAnnotationComposer a) f) {
    final $$ReceiptsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.receipts,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReceiptsTableAnnotationComposer(
              $db: $db,
              $table: $db.receipts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> nutritionAnalysesRefs<T extends Object>(
      Expression<T> Function($$NutritionAnalysesTableAnnotationComposer a) f) {
    final $$NutritionAnalysesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.nutritionAnalyses,
            getReferencedColumn: (t) => t.userId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$NutritionAnalysesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.nutritionAnalyses,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$UserProfileTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProfileTable,
    UserProfileData,
    $$UserProfileTableFilterComposer,
    $$UserProfileTableOrderingComposer,
    $$UserProfileTableAnnotationComposer,
    $$UserProfileTableCreateCompanionBuilder,
    $$UserProfileTableUpdateCompanionBuilder,
    (UserProfileData, $$UserProfileTableReferences),
    UserProfileData,
    PrefetchHooks Function({bool receiptsRefs, bool nutritionAnalysesRefs})> {
  $$UserProfileTableTableManager(_$AppDatabase db, $UserProfileTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> age = const Value.absent(),
            Value<String> gender = const Value.absent(),
            Value<double> height = const Value.absent(),
            Value<double> weight = const Value.absent(),
            Value<String?> mbti = const Value.absent(),
            Value<String> familyHistory = const Value.absent(),
            Value<String> existingConditions = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserProfileCompanion(
            id: id,
            age: age,
            gender: gender,
            height: height,
            weight: weight,
            mbti: mbti,
            familyHistory: familyHistory,
            existingConditions: existingConditions,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int age,
            required String gender,
            required double height,
            required double weight,
            Value<String?> mbti = const Value.absent(),
            Value<String> familyHistory = const Value.absent(),
            Value<String> existingConditions = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserProfileCompanion.insert(
            id: id,
            age: age,
            gender: gender,
            height: height,
            weight: weight,
            mbti: mbti,
            familyHistory: familyHistory,
            existingConditions: existingConditions,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UserProfileTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {receiptsRefs = false, nutritionAnalysesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (receiptsRefs) db.receipts,
                if (nutritionAnalysesRefs) db.nutritionAnalyses
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (receiptsRefs)
                    await $_getPrefetchedData<UserProfileData,
                            $UserProfileTable, ReceiptData>(
                        currentTable: table,
                        referencedTable:
                            $$UserProfileTableReferences._receiptsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UserProfileTableReferences(db, table, p0)
                                .receiptsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (nutritionAnalysesRefs)
                    await $_getPrefetchedData<UserProfileData,
                            $UserProfileTable, NutritionAnalysisData>(
                        currentTable: table,
                        referencedTable: $$UserProfileTableReferences
                            ._nutritionAnalysesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UserProfileTableReferences(db, table, p0)
                                .nutritionAnalysesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UserProfileTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProfileTable,
    UserProfileData,
    $$UserProfileTableFilterComposer,
    $$UserProfileTableOrderingComposer,
    $$UserProfileTableAnnotationComposer,
    $$UserProfileTableCreateCompanionBuilder,
    $$UserProfileTableUpdateCompanionBuilder,
    (UserProfileData, $$UserProfileTableReferences),
    UserProfileData,
    PrefetchHooks Function({bool receiptsRefs, bool nutritionAnalysesRefs})>;
typedef $$ReceiptsTableCreateCompanionBuilder = ReceiptsCompanion Function({
  Value<int> id,
  required int userId,
  required String imagePath,
  required String rawOcrText,
  Value<int> parsedItemCount,
  Value<double?> totalAmount,
  required DateTime receiptDate,
  Value<DateTime> createdAt,
});
typedef $$ReceiptsTableUpdateCompanionBuilder = ReceiptsCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<String> imagePath,
  Value<String> rawOcrText,
  Value<int> parsedItemCount,
  Value<double?> totalAmount,
  Value<DateTime> receiptDate,
  Value<DateTime> createdAt,
});

final class $$ReceiptsTableReferences
    extends BaseReferences<_$AppDatabase, $ReceiptsTable, ReceiptData> {
  $$ReceiptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserProfileTable _userIdTable(_$AppDatabase db) => db.userProfile
      .createAlias($_aliasNameGenerator(db.receipts.userId, db.userProfile.id));

  $$UserProfileTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UserProfileTableTableManager($_db, $_db.userProfile)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$FoodItemsTable, List<FoodItemData>>
      _foodItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.foodItems,
              aliasName:
                  $_aliasNameGenerator(db.receipts.id, db.foodItems.receiptId));

  $$FoodItemsTableProcessedTableManager get foodItemsRefs {
    final manager = $$FoodItemsTableTableManager($_db, $_db.foodItems)
        .filter((f) => f.receiptId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_foodItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ReceiptsTableFilterComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rawOcrText => $composableBuilder(
      column: $table.rawOcrText, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get parsedItemCount => $composableBuilder(
      column: $table.parsedItemCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get receiptDate => $composableBuilder(
      column: $table.receiptDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UserProfileTableFilterComposer get userId {
    final $$UserProfileTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.userProfile,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserProfileTableFilterComposer(
              $db: $db,
              $table: $db.userProfile,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> foodItemsRefs(
      Expression<bool> Function($$FoodItemsTableFilterComposer f) f) {
    final $$FoodItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.foodItems,
        getReferencedColumn: (t) => t.receiptId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoodItemsTableFilterComposer(
              $db: $db,
              $table: $db.foodItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ReceiptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawOcrText => $composableBuilder(
      column: $table.rawOcrText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get parsedItemCount => $composableBuilder(
      column: $table.parsedItemCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get receiptDate => $composableBuilder(
      column: $table.receiptDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UserProfileTableOrderingComposer get userId {
    final $$UserProfileTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.userProfile,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserProfileTableOrderingComposer(
              $db: $db,
              $table: $db.userProfile,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReceiptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get rawOcrText => $composableBuilder(
      column: $table.rawOcrText, builder: (column) => column);

  GeneratedColumn<int> get parsedItemCount => $composableBuilder(
      column: $table.parsedItemCount, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get receiptDate => $composableBuilder(
      column: $table.receiptDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UserProfileTableAnnotationComposer get userId {
    final $$UserProfileTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.userProfile,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserProfileTableAnnotationComposer(
              $db: $db,
              $table: $db.userProfile,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> foodItemsRefs<T extends Object>(
      Expression<T> Function($$FoodItemsTableAnnotationComposer a) f) {
    final $$FoodItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.foodItems,
        getReferencedColumn: (t) => t.receiptId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoodItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.foodItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ReceiptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReceiptsTable,
    ReceiptData,
    $$ReceiptsTableFilterComposer,
    $$ReceiptsTableOrderingComposer,
    $$ReceiptsTableAnnotationComposer,
    $$ReceiptsTableCreateCompanionBuilder,
    $$ReceiptsTableUpdateCompanionBuilder,
    (ReceiptData, $$ReceiptsTableReferences),
    ReceiptData,
    PrefetchHooks Function({bool userId, bool foodItemsRefs})> {
  $$ReceiptsTableTableManager(_$AppDatabase db, $ReceiptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceiptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceiptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceiptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> imagePath = const Value.absent(),
            Value<String> rawOcrText = const Value.absent(),
            Value<int> parsedItemCount = const Value.absent(),
            Value<double?> totalAmount = const Value.absent(),
            Value<DateTime> receiptDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ReceiptsCompanion(
            id: id,
            userId: userId,
            imagePath: imagePath,
            rawOcrText: rawOcrText,
            parsedItemCount: parsedItemCount,
            totalAmount: totalAmount,
            receiptDate: receiptDate,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required String imagePath,
            required String rawOcrText,
            Value<int> parsedItemCount = const Value.absent(),
            Value<double?> totalAmount = const Value.absent(),
            required DateTime receiptDate,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ReceiptsCompanion.insert(
            id: id,
            userId: userId,
            imagePath: imagePath,
            rawOcrText: rawOcrText,
            parsedItemCount: parsedItemCount,
            totalAmount: totalAmount,
            receiptDate: receiptDate,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ReceiptsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({userId = false, foodItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (foodItemsRefs) db.foodItems],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable: $$ReceiptsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$ReceiptsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (foodItemsRefs)
                    await $_getPrefetchedData<ReceiptData, $ReceiptsTable,
                            FoodItemData>(
                        currentTable: table,
                        referencedTable:
                            $$ReceiptsTableReferences._foodItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ReceiptsTableReferences(db, table, p0)
                                .foodItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.receiptId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ReceiptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReceiptsTable,
    ReceiptData,
    $$ReceiptsTableFilterComposer,
    $$ReceiptsTableOrderingComposer,
    $$ReceiptsTableAnnotationComposer,
    $$ReceiptsTableCreateCompanionBuilder,
    $$ReceiptsTableUpdateCompanionBuilder,
    (ReceiptData, $$ReceiptsTableReferences),
    ReceiptData,
    PrefetchHooks Function({bool userId, bool foodItemsRefs})>;
typedef $$FoodItemsTableCreateCompanionBuilder = FoodItemsCompanion Function({
  Value<int> id,
  required int receiptId,
  required String name,
  required String category,
  Value<double?> price,
  Value<int?> calories,
  Value<int?> sodiumMg,
  Value<double?> sugarG,
  Value<double?> fatG,
  Value<double?> proteinG,
  Value<double?> carbsG,
  Value<int> quantity,
  Value<DateTime> addedAt,
});
typedef $$FoodItemsTableUpdateCompanionBuilder = FoodItemsCompanion Function({
  Value<int> id,
  Value<int> receiptId,
  Value<String> name,
  Value<String> category,
  Value<double?> price,
  Value<int?> calories,
  Value<int?> sodiumMg,
  Value<double?> sugarG,
  Value<double?> fatG,
  Value<double?> proteinG,
  Value<double?> carbsG,
  Value<int> quantity,
  Value<DateTime> addedAt,
});

final class $$FoodItemsTableReferences
    extends BaseReferences<_$AppDatabase, $FoodItemsTable, FoodItemData> {
  $$FoodItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ReceiptsTable _receiptIdTable(_$AppDatabase db) =>
      db.receipts.createAlias(
          $_aliasNameGenerator(db.foodItems.receiptId, db.receipts.id));

  $$ReceiptsTableProcessedTableManager get receiptId {
    final $_column = $_itemColumn<int>('receipt_id')!;

    final manager = $$ReceiptsTableTableManager($_db, $_db.receipts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_receiptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FoodItemsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sodiumMg => $composableBuilder(
      column: $table.sodiumMg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sugarG => $composableBuilder(
      column: $table.sugarG, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fatG => $composableBuilder(
      column: $table.fatG, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get proteinG => $composableBuilder(
      column: $table.proteinG, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbsG => $composableBuilder(
      column: $table.carbsG, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnFilters(column));

  $$ReceiptsTableFilterComposer get receiptId {
    final $$ReceiptsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.receiptId,
        referencedTable: $db.receipts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReceiptsTableFilterComposer(
              $db: $db,
              $table: $db.receipts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FoodItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sodiumMg => $composableBuilder(
      column: $table.sodiumMg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sugarG => $composableBuilder(
      column: $table.sugarG, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fatG => $composableBuilder(
      column: $table.fatG, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get proteinG => $composableBuilder(
      column: $table.proteinG, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbsG => $composableBuilder(
      column: $table.carbsG, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnOrderings(column));

  $$ReceiptsTableOrderingComposer get receiptId {
    final $$ReceiptsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.receiptId,
        referencedTable: $db.receipts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReceiptsTableOrderingComposer(
              $db: $db,
              $table: $db.receipts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FoodItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<int> get sodiumMg =>
      $composableBuilder(column: $table.sodiumMg, builder: (column) => column);

  GeneratedColumn<double> get sugarG =>
      $composableBuilder(column: $table.sugarG, builder: (column) => column);

  GeneratedColumn<double> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$ReceiptsTableAnnotationComposer get receiptId {
    final $$ReceiptsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.receiptId,
        referencedTable: $db.receipts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReceiptsTableAnnotationComposer(
              $db: $db,
              $table: $db.receipts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FoodItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FoodItemsTable,
    FoodItemData,
    $$FoodItemsTableFilterComposer,
    $$FoodItemsTableOrderingComposer,
    $$FoodItemsTableAnnotationComposer,
    $$FoodItemsTableCreateCompanionBuilder,
    $$FoodItemsTableUpdateCompanionBuilder,
    (FoodItemData, $$FoodItemsTableReferences),
    FoodItemData,
    PrefetchHooks Function({bool receiptId})> {
  $$FoodItemsTableTableManager(_$AppDatabase db, $FoodItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> receiptId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double?> price = const Value.absent(),
            Value<int?> calories = const Value.absent(),
            Value<int?> sodiumMg = const Value.absent(),
            Value<double?> sugarG = const Value.absent(),
            Value<double?> fatG = const Value.absent(),
            Value<double?> proteinG = const Value.absent(),
            Value<double?> carbsG = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
          }) =>
              FoodItemsCompanion(
            id: id,
            receiptId: receiptId,
            name: name,
            category: category,
            price: price,
            calories: calories,
            sodiumMg: sodiumMg,
            sugarG: sugarG,
            fatG: fatG,
            proteinG: proteinG,
            carbsG: carbsG,
            quantity: quantity,
            addedAt: addedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int receiptId,
            required String name,
            required String category,
            Value<double?> price = const Value.absent(),
            Value<int?> calories = const Value.absent(),
            Value<int?> sodiumMg = const Value.absent(),
            Value<double?> sugarG = const Value.absent(),
            Value<double?> fatG = const Value.absent(),
            Value<double?> proteinG = const Value.absent(),
            Value<double?> carbsG = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
          }) =>
              FoodItemsCompanion.insert(
            id: id,
            receiptId: receiptId,
            name: name,
            category: category,
            price: price,
            calories: calories,
            sodiumMg: sodiumMg,
            sugarG: sugarG,
            fatG: fatG,
            proteinG: proteinG,
            carbsG: carbsG,
            quantity: quantity,
            addedAt: addedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FoodItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({receiptId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (receiptId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.receiptId,
                    referencedTable:
                        $$FoodItemsTableReferences._receiptIdTable(db),
                    referencedColumn:
                        $$FoodItemsTableReferences._receiptIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FoodItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FoodItemsTable,
    FoodItemData,
    $$FoodItemsTableFilterComposer,
    $$FoodItemsTableOrderingComposer,
    $$FoodItemsTableAnnotationComposer,
    $$FoodItemsTableCreateCompanionBuilder,
    $$FoodItemsTableUpdateCompanionBuilder,
    (FoodItemData, $$FoodItemsTableReferences),
    FoodItemData,
    PrefetchHooks Function({bool receiptId})>;
typedef $$NutritionAnalysesTableCreateCompanionBuilder
    = NutritionAnalysesCompanion Function({
  Value<int> id,
  required int userId,
  required DateTime analysisDate,
  required String dietCharacter,
  required String purchasePatterns,
  required String deficiencyWarnings,
  required String futureScenarios,
  Value<String?> trendComparison,
  Value<DateTime> createdAt,
});
typedef $$NutritionAnalysesTableUpdateCompanionBuilder
    = NutritionAnalysesCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<DateTime> analysisDate,
  Value<String> dietCharacter,
  Value<String> purchasePatterns,
  Value<String> deficiencyWarnings,
  Value<String> futureScenarios,
  Value<String?> trendComparison,
  Value<DateTime> createdAt,
});

final class $$NutritionAnalysesTableReferences extends BaseReferences<
    _$AppDatabase, $NutritionAnalysesTable, NutritionAnalysisData> {
  $$NutritionAnalysesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UserProfileTable _userIdTable(_$AppDatabase db) =>
      db.userProfile.createAlias(
          $_aliasNameGenerator(db.nutritionAnalyses.userId, db.userProfile.id));

  $$UserProfileTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UserProfileTableTableManager($_db, $_db.userProfile)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$NutritionAnalysesTableFilterComposer
    extends Composer<_$AppDatabase, $NutritionAnalysesTable> {
  $$NutritionAnalysesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get analysisDate => $composableBuilder(
      column: $table.analysisDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dietCharacter => $composableBuilder(
      column: $table.dietCharacter, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchasePatterns => $composableBuilder(
      column: $table.purchasePatterns,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deficiencyWarnings => $composableBuilder(
      column: $table.deficiencyWarnings,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get futureScenarios => $composableBuilder(
      column: $table.futureScenarios,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trendComparison => $composableBuilder(
      column: $table.trendComparison,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UserProfileTableFilterComposer get userId {
    final $$UserProfileTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.userProfile,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserProfileTableFilterComposer(
              $db: $db,
              $table: $db.userProfile,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NutritionAnalysesTableOrderingComposer
    extends Composer<_$AppDatabase, $NutritionAnalysesTable> {
  $$NutritionAnalysesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get analysisDate => $composableBuilder(
      column: $table.analysisDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dietCharacter => $composableBuilder(
      column: $table.dietCharacter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchasePatterns => $composableBuilder(
      column: $table.purchasePatterns,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deficiencyWarnings => $composableBuilder(
      column: $table.deficiencyWarnings,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get futureScenarios => $composableBuilder(
      column: $table.futureScenarios,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trendComparison => $composableBuilder(
      column: $table.trendComparison,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UserProfileTableOrderingComposer get userId {
    final $$UserProfileTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.userProfile,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserProfileTableOrderingComposer(
              $db: $db,
              $table: $db.userProfile,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NutritionAnalysesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NutritionAnalysesTable> {
  $$NutritionAnalysesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get analysisDate => $composableBuilder(
      column: $table.analysisDate, builder: (column) => column);

  GeneratedColumn<String> get dietCharacter => $composableBuilder(
      column: $table.dietCharacter, builder: (column) => column);

  GeneratedColumn<String> get purchasePatterns => $composableBuilder(
      column: $table.purchasePatterns, builder: (column) => column);

  GeneratedColumn<String> get deficiencyWarnings => $composableBuilder(
      column: $table.deficiencyWarnings, builder: (column) => column);

  GeneratedColumn<String> get futureScenarios => $composableBuilder(
      column: $table.futureScenarios, builder: (column) => column);

  GeneratedColumn<String> get trendComparison => $composableBuilder(
      column: $table.trendComparison, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UserProfileTableAnnotationComposer get userId {
    final $$UserProfileTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.userProfile,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserProfileTableAnnotationComposer(
              $db: $db,
              $table: $db.userProfile,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NutritionAnalysesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NutritionAnalysesTable,
    NutritionAnalysisData,
    $$NutritionAnalysesTableFilterComposer,
    $$NutritionAnalysesTableOrderingComposer,
    $$NutritionAnalysesTableAnnotationComposer,
    $$NutritionAnalysesTableCreateCompanionBuilder,
    $$NutritionAnalysesTableUpdateCompanionBuilder,
    (NutritionAnalysisData, $$NutritionAnalysesTableReferences),
    NutritionAnalysisData,
    PrefetchHooks Function({bool userId})> {
  $$NutritionAnalysesTableTableManager(
      _$AppDatabase db, $NutritionAnalysesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NutritionAnalysesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NutritionAnalysesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NutritionAnalysesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<DateTime> analysisDate = const Value.absent(),
            Value<String> dietCharacter = const Value.absent(),
            Value<String> purchasePatterns = const Value.absent(),
            Value<String> deficiencyWarnings = const Value.absent(),
            Value<String> futureScenarios = const Value.absent(),
            Value<String?> trendComparison = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              NutritionAnalysesCompanion(
            id: id,
            userId: userId,
            analysisDate: analysisDate,
            dietCharacter: dietCharacter,
            purchasePatterns: purchasePatterns,
            deficiencyWarnings: deficiencyWarnings,
            futureScenarios: futureScenarios,
            trendComparison: trendComparison,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required DateTime analysisDate,
            required String dietCharacter,
            required String purchasePatterns,
            required String deficiencyWarnings,
            required String futureScenarios,
            Value<String?> trendComparison = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              NutritionAnalysesCompanion.insert(
            id: id,
            userId: userId,
            analysisDate: analysisDate,
            dietCharacter: dietCharacter,
            purchasePatterns: purchasePatterns,
            deficiencyWarnings: deficiencyWarnings,
            futureScenarios: futureScenarios,
            trendComparison: trendComparison,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$NutritionAnalysesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$NutritionAnalysesTableReferences._userIdTable(db),
                    referencedColumn:
                        $$NutritionAnalysesTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$NutritionAnalysesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NutritionAnalysesTable,
    NutritionAnalysisData,
    $$NutritionAnalysesTableFilterComposer,
    $$NutritionAnalysesTableOrderingComposer,
    $$NutritionAnalysesTableAnnotationComposer,
    $$NutritionAnalysesTableCreateCompanionBuilder,
    $$NutritionAnalysesTableUpdateCompanionBuilder,
    (NutritionAnalysisData, $$NutritionAnalysesTableReferences),
    NutritionAnalysisData,
    PrefetchHooks Function({bool userId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfileTableTableManager get userProfile =>
      $$UserProfileTableTableManager(_db, _db.userProfile);
  $$ReceiptsTableTableManager get receipts =>
      $$ReceiptsTableTableManager(_db, _db.receipts);
  $$FoodItemsTableTableManager get foodItems =>
      $$FoodItemsTableTableManager(_db, _db.foodItems);
  $$NutritionAnalysesTableTableManager get nutritionAnalyses =>
      $$NutritionAnalysesTableTableManager(_db, _db.nutritionAnalyses);
}
