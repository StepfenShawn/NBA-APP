import 'package:http/http.dart' as http;
import 'package:nba_app/models/team.dart';
import 'dart:convert';

class ApiService {
  static const String apiKey = 'e22a4fc0-13e3-4189-b192-19110c0a807b';
  static const String baseUrl = 'https://api.balldontlie.io';

  Future<List<Team>> fetchTeams() async {
    final url = Uri.parse('$baseUrl/v1/teams');
    try {
      final response = await http.get(url, headers: {'Authorization': apiKey});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<Team> teams = (data['data'] as List)
            .map((teamJson) => Team.fromJson(teamJson))
            .toList();

        return teams;
      } else {
        throw Exception("获取球队失败: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('网络请求出错: $e');
    }
  }
}
