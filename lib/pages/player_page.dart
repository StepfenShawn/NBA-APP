import 'package:flutter/material.dart';
import 'package:nba_app/api/api_service.dart';
import 'package:nba_app/models/player.dart';

class PlayerListPage extends StatefulWidget {
  final int teamId;
  final String teamName;

  const PlayerListPage({super.key, required this.teamId, required this.teamName});

  @override
  State<PlayerListPage> createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State<PlayerListPage> {
  List<Player> _players = [];
  bool _isLoading = true;
  String? _errorMessage;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      List<Player> players = await _apiService.fetchPlayersByTeam(widget.teamId);
      setState(() {
        _players = players;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.teamName} 球员'), backgroundColor: Colors.deepPurple),
      body: Center(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const CircularProgressIndicator();
    } else if (_errorMessage != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('出错了: $_errorMessage', style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _loadPlayers, child: const Text('重试')),
        ],
      );
    } else if (_players.isEmpty) {
      // 如果球员列表为空
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_basketball, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text('该球队暂无球员数据', style: TextStyle(fontSize: 18)),
        ],
      );
    } else {
      return ListView.builder(
        itemCount: _players.length,
        itemBuilder: (context, index) {
          final player = _players[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple[100],
              child: Text(
                player.firstName[0] + player.lastName[0],
                style: const TextStyle(color: Colors.deepPurple),
              ),
            ),
            title: Text(player.fullName),
            subtitle: Text('位置: ${player.position}'),
            trailing: Text(
              '${player.height ?? ''} / ${player.weight ?? ''}',
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(player.fullName),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('位置: ${player.position}'),
                      Text('身高: ${player.height ?? '未知'}'),
                      Text('体重: ${player.weight ?? '未知'}'),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('关闭')),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }
}
