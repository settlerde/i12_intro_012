class Todo {
  final String text;
  final String id;
  final bool isDone;

  Todo({
    required this.text,
    required this.id,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'id': id,
    'isDone': isDone,
  };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    text: json['text'] as String,
    id: json['id'] as String,
    isDone: json['isDone'] as bool,
  );

  Todo copyWith({
    String? text,
    String? id,
    bool? isDone,
  }) {
    return Todo(
      id: id ?? this.id,
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
    );
  }
}
