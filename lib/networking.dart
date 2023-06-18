import 'dart:convert';
import 'package:http/http.dart';

String baseUrl = "https://api.openai.com/v1";
String modelsUrl = "https://api.openai.com/v1/models";
String chatUrl = "https://api.openai.com/v1/completions";

String apiKey = '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';

Future<Map> getModels() async {
  late final Uri url;
  url = Uri.parse(modelsUrl);
  try {
    final response = await get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      print(jsonData);
      return jsonData;
    } else if (response.statusCode == 401) {
      return {};
    } else {
      return {};
    }
  } on Exception catch (_) {
    return {};
  }
}

Future<Map> postChat(Map<String, dynamic> map) async {
  final url = Uri.parse(chatUrl);
  try {
    final response = await post(
      url,
      body: json.encode(map),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      print(jsonData);
      return jsonData;
    } else if (response.statusCode == 401) {
      return {};
    } else {
      return {};
    }
  } on Exception catch (_) {
    return {};
  }
}

Future<Map> getData() async {
  late final Uri url;
  url = Uri.parse(baseUrl);

  try {
    final response = await get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData;
    } else if (response.statusCode == 401) {
      return {};
    } else {
      return {};
    }
  } on Exception catch (_) {
    return {};
  }
}

Future<String> getDataString(String urlSuffix) async {
  late final Uri url;
  url = Uri.parse(baseUrl + urlSuffix);
  try {
    final response = await get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );
    if (response.statusCode == 200) {
      final String jsonData = response.body;
      return jsonData;
    } else if (response.statusCode == 401) {
      return getDataString(urlSuffix);
    } else {
      return '';
    }
  } on Exception catch (_) {
    return '';
  }
}

Future<bool> postData(Map<String, dynamic> map) async {
  final url = Uri.parse(baseUrl);
  try {
    final response = await post(url, body: json.encode(map), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      // final Map<String, dynamic> jsonData = jsonDecode(response.body);

      return true;
    } else if (response.statusCode == 401) {
      return false;
    } else {
      return false;
    }
  } on Exception catch (_) {
    return false;
  }
}

Future<bool> postDataString(String urlSuffix, String string) async {
  final url = Uri.parse(baseUrl + urlSuffix);
  try {
    final response = await post(
      url,
      body: json.encode(string),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } on Exception catch (_) {
    return false;
  }
}
