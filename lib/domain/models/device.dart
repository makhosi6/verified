class Device {
  String? uuid;
  String? name;
  String? brand;

  Device({this.uuid, this.name, this.brand});

  Device.fromJson(Map<String, dynamic> json) {
    if (json['uuid'] is String) {
      uuid = json['uuid'];
    }
    if (json['name'] is String) {
      name = json['name'];
    }
    if (json['brand'] is String) {
      brand = json['brand'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['uuid'] = uuid;
    _data['name'] = name;
    _data['brand'] = brand;
    return _data;
  }
}
