import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../constants/AppConstraints.dart';

class MyApi{

  static Future<http.Response> get_curateddata_bycat(String search) async {
    var url = Uri.parse(AppConstraints.BASE_URL+"search?query="+search+"&per_page=10");
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Authorization': 'yI8j2TOVfpkAgIsmLLKSS4vIF4460ydNBKmjf6CD8HTfTJL8e8piKFYY'
    };
    print("catname_get_curateddata" + url.toString());

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();
    return http.Response(resBody, res.statusCode, headers: res.headers);

  }
  static Future<http.Response> getRecipeData(String catname, {int from = 0, int to = 10}) async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
    };

    var url = Uri.parse(
        'https://api.edamam.com/search?q=$catname&app_id=34230ec1&app_key=5a65775bc25428f6a845f3514b94f56c&from=$from&to=$to');

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      return http.Response(resBody, res.statusCode, headers: res.headers);
    } else {
      print(res.reasonPhrase);
      return http.Response(res.reasonPhrase ?? 'Unknown error', res.statusCode, headers: res.headers);
    }
  }

}