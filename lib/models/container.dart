import 'package:hive/hive.dart';

part 'container.g.dart';

@HiveType(typeId: 1)
class ContainerData {
  @HiveField(0)
  String key1;

  @HiveField(1)
  String value1;

  @HiveField(2)
  String key2;

  @HiveField(3)
  String value2;

  @HiveField(4)
  String key3;

  @HiveField(5)
  String value3;

  // @HiveField(3)

  // @HiveField(4)

  ContainerData({
    required this.key1,
    required this.value1,
    required this.key2,
    required this.value2,
    required this.key3,
    required this.value3,
  });
}
