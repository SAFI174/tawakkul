class AsmaullahModel {
  String? id;
  String? ttl;
  String? dsc;

  AsmaullahModel({this.id, this.ttl, this.dsc});

  AsmaullahModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ttl = json['ttl'];
    dsc = json['dsc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ttl'] = ttl;
    data['dsc'] = dsc;
    return data;
  }
}