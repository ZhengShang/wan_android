import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:wan_android/model/home_page_json.dart';

class SearchRepository {
  static Future<Article> searchHotkey(String hotkey) async {
    print('start fetch hotKeys');
    final response = await http
        .get('http://www.wanandroid.com//hotkey/json')
        .timeout(Duration(seconds: 5));
    print('end fetch hotKeys. the body is => ${response.body}');
  }
}
