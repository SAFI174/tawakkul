import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:tawakkal/constants/json_path.dart';

import '../models/hadith40_model.dart';

class Hadith0Repository {
  static Future<List<Hadith40Model>> getAllAhadith() async {
    final jsonFile = await rootBundle.loadString(JsonPaths.hahdith40);
    final List<dynamic> jsonData = await json.decode(jsonFile);
    return jsonData.map((e) => Hadith40Model.fromJson(e)).toList();
  }
}
