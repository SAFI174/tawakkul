import 'dart:convert';

import 'package:flutter/services.dart';

import '../../data/models/asmaullah_model.dart';

class AsmaullahRepository {
  Future<List<AsmaullahModel>> getAsmaullahData() async {
    final filePath = await rootBundle.loadString('assets/jsons/asmaullah.json');
    final List<dynamic> jsonData = await json.decode(filePath);
    return jsonData.map((e) => AsmaullahModel.fromJson(e)).toList();
  }
}
