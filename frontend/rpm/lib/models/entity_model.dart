class Entity {
  Entity({
    required this.id,
    required this.code,
    required this.description,
    required this.type,
    required this.parentId,
  });

  String code;
  String description;
  int id;
  int parentId;
  String type;
}
