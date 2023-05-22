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
      date: fields[11] as String,
      time: fields[12] as String,
      extra: fields[2] as double,
      discount: fields[3] as double,
      name: fields[4] as String,
      phone: fields[5] as String,
      branchUid: fields[6] as String,
      note: fields[7] as String,
      uid: fields[8] as String,
      subTotal: fields[9] as double,
      total: fields[10] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SessionModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.addedBy)
      ..writeByte(1)
      ..write(obj.personCount)
      ..writeByte(2)
      ..write(obj.extra)
      ..writeByte(3)
      ..write(obj.discount)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.branchUid)
      ..writeByte(7)
      ..write(obj.note)
      ..writeByte(8)
      ..write(obj.uid)
      ..writeByte(9)
      ..write(obj.subTotal)
      ..writeByte(10)
      ..write(obj.total)
      ..writeByte(11)
      ..write(obj.date)
      ..writeByte(12)
      ..write(obj.time);
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
