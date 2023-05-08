// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessModelAdapter extends TypeAdapter<BusinessModel> {
  @override
  final int typeId = 1;

  @override
  BusinessModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessModel(
      uid: fields[0] as String,
      name: fields[1] as String,
      businessLogoUrl: fields[2] as String,
      workersUidList: (fields[3] as List).cast<String>(),
      adminsUidList: (fields[4] as List).cast<String>(),
      ownerUid: fields[5] as String,
      branchesUidList: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BusinessModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.businessLogoUrl)
      ..writeByte(3)
      ..write(obj.workersUidList)
      ..writeByte(4)
      ..write(obj.adminsUidList)
      ..writeByte(5)
      ..write(obj.ownerUid)
      ..writeByte(6)
      ..write(obj.branchesUidList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
