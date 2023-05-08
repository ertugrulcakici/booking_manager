// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BranchModelAdapter extends TypeAdapter<BranchModel> {
  @override
  final int typeId = 1;

  @override
  BranchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BranchModel(
      uid: fields[0] as String,
      relatedBusinessUid: fields[1] as String,
      name: fields[2] as String,
      unitPrice: fields[3] as num,
      workingHoursList: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BranchModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.relatedBusinessUid)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.unitPrice)
      ..writeByte(4)
      ..write(obj.workingHoursList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BranchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
