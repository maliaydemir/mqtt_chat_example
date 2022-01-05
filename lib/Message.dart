class Message {
  String name;
  String message;
  int type = 1;

  Message({required this.name, required this.message,required this.type});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
      name: json['name'] as String,
      message: json['message'] as String,
      type: json['type'] as int);

  Map<String, dynamic> toJson() => {
        'name': name,
        'message': message,
        'type': type,
      };
}
