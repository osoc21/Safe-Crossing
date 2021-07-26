class TrafficLight {
  final String id;
  final String state;

  TrafficLight(this.id, this.state);

  TrafficLight.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        state = json['state'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'state': state,
      };
}
