// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaceLocationAdapter extends TypeAdapter<PlaceLocation> {
  @override
  final int typeId = 1;

  @override
  PlaceLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaceLocation(
      fields[0] as double,
      fields[1] as double,
      fields[2] as String,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlaceLocation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.idLoc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlaceTagAdapter extends TypeAdapter<PlaceTag> {
  @override
  final int typeId = 2;

  @override
  PlaceTag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaceTag(
      fields[0] as bool,
      fields[1] as bool,
      fields[2] as bool,
      fields[3] as bool,
      fields[4] as bool,
      fields[5] as bool,
      fields[6] as bool,
      fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PlaceTag obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.monument)
      ..writeByte(1)
      ..write(obj.city)
      ..writeByte(2)
      ..write(obj.experience)
      ..writeByte(3)
      ..write(obj.vacation)
      ..writeByte(4)
      ..write(obj.work)
      ..writeByte(5)
      ..write(obj.project)
      ..writeByte(6)
      ..write(obj.personal)
      ..writeByte(7)
      ..write(obj.vista);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceTagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IconsDataAdapter extends TypeAdapter<IconsData> {
  @override
  final int typeId = 3;

  @override
  IconsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IconsData(
      fields[0] as int,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, IconsData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.codePoint)
      ..writeByte(1)
      ..write(obj.fontFamily)
      ..writeByte(2)
      ..write(obj.fontPackage)
      ..writeByte(3)
      ..write(obj.textDirection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IconsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlaceAdapter extends TypeAdapter<Place> {
  @override
  final int typeId = 0;

  @override
  Place read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Place(
      id: fields[0] as String,
      title: fields[1] as String,
      location: fields[2] as PlaceLocation?,
      gallery: (fields[3] as List).cast<String>(),
      dates: (fields[4] as List).cast<String>(),
      tag: fields[5] as PlaceTag?,
      tagsOfPlaces: (fields[6] as Map).cast<String, bool>(),
      listIcons: (fields[7] as List).cast<IconsData>(),
    );
  }

  @override
  void write(BinaryWriter writer, Place obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.gallery)
      ..writeByte(4)
      ..write(obj.dates)
      ..writeByte(5)
      ..write(obj.tag)
      ..writeByte(6)
      ..write(obj.tagsOfPlaces)
      ..writeByte(7)
      ..write(obj.listIcons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
