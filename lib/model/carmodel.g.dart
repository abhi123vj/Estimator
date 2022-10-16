// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarModelAdapter extends TypeAdapter<CarModel> {
  @override
  final int typeId = 1;

  @override
  CarModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarModel(
      carsName: fields[0] as String,
      carItems: (fields[1] as List?)?.cast<CarItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, CarModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.carsName)
      ..writeByte(1)
      ..write(obj.carItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CarItemAdapter extends TypeAdapter<CarItem> {
  @override
  final int typeId = 2;

  @override
  CarItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarItem(
      itemName: fields[0] as String,
      itemPrice: fields[1] as String,
      itemCode: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CarItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.itemName)
      ..writeByte(1)
      ..write(obj.itemPrice)
      ..writeByte(2)
      ..write(obj.itemCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
