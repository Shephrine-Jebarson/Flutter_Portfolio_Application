// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectLocalModelAdapter extends TypeAdapter<ProjectLocalModel> {
  @override
  final int typeId = 0;

  @override
  ProjectLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectLocalModel(
      id: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      techStack: fields[3] as String,
      platform: fields[4] as String,
      githubUrl: fields[5] as String?,
      liveUrl: fields[6] as String?,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectLocalModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.techStack)
      ..writeByte(4)
      ..write(obj.platform)
      ..writeByte(5)
      ..write(obj.githubUrl)
      ..writeByte(6)
      ..write(obj.liveUrl)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
