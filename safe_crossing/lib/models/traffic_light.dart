class TrafficLight {
  final String id;
  final String status;

  TrafficLight(this.id, this.status);

  TrafficLight.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
      };
}
