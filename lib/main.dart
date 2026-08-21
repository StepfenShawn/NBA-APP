import 'package:flutter/material.dart';
import 'package:nba_app/api/api_service.dart';
import 'package:nba_app/models/team.dart';
import 'package:nba_app/pages/player_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NBA APP",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: "NBA Teams"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Team> _teams = [];
  bool _isLoading = true;
  String? _errorMsg;

  final ApiService _apiService = ApiService();

  Future<void> _loadTeams() async {
    final conference = _tabController.index == 0 ? Conference.east : Conference.west;
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      List<Team> teams = await _apiService.fetchTeams(conference);
      setState(() {
        _teams = teams;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _loadTeams();
      }
    });
    _loadTeams();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "East"),
            Tab(text: "West"),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [_buildBody(), _buildBody()]),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const CircularProgressIndicator();
    } else if (_errorMsg != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '出错了: $_errorMsg',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _loadTeams, child: const Text("retry")),
        ],
      );
    } else {
      return ListView.builder(
        itemCount: _teams.length,
        itemBuilder: (context, index) {
          final team = _teams[index];
          return ListTile(
            leading: CircleAvatar(child: Text(team.abbreviation)),
            title: Text(team.fullName),
            subtitle: Text(team.city),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerListPage(teamId: team.id, teamName: team.fullName),
                ),
              );
            },
          );
        },
      );
    }
  }
}
