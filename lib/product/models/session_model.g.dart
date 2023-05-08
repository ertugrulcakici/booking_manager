// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionModelAdapter extends TypeAdapter<SessionModel> {
  @override
  final int typeId = 4;

  @override
  SessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionModel(
      addedBy: fields[0] as String,
      personCount: fields[1] as int,
      date: fields[2] as String,
      time: fields[3] as String,
      extra: fields[4] as double,
      discount: fields[5] as double,
      name: fields[6] as String,
      phone: fields[7] as String,
      branchUid: fields[8] as String,
      note: fields[9] as String,
      uid: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SessionModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.addedBy)
      ..writeByte(1)
      ..write(obj.personCount)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.extra)
      ..writeByte(5)
      ..write(obj.discount)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.phone)
      ..writeByte(8)
      ..write(obj.branchUid)
      ..writeByte(9)
      ..write(obj.note)
      ..writeByte(10)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
