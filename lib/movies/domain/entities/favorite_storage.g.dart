// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_storage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteStorageAdapter extends TypeAdapter<FavoriteStorage> {
  @override
  final int typeId = 1;

  @override
  FavoriteStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteStorage(
      moviesIds: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteStorage obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.moviesIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
