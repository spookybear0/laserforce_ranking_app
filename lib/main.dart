import "package:flutter/material.dart";
import "package:laserforce_ranking_app/api.dart";
import "player.dart";
import "login.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "players.dart";

void main() {
  runApp(const LaserforceRanking());
}

class LaserforceRanking extends StatelessWidget {
  const LaserforceRanking({super.key});

  @override
  Widget build(BuildContext context) {
    Widget home = LoginPage();

    return MaterialApp(
      title: "Laserforce Ranking",
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(120, 169, 253, 1))
            .copyWith(
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(120, 169, 253, 1))
            .copyWith(
          brightness: Brightness.dark,
        ),
      ),

      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final bool isLoggedIn = snapshot.data ?? false;
            if (isLoggedIn) {
              home = const HomePage();
            }
            return home;
          }
        },
      )
    );
  }

  Future<bool> _checkLoginStatus() async {
    final storage = FlutterSecureStorage();
    final String? codename = await storage.read(key: "codename");

    LaserforceApi.codename = codename;
    LaserforceApi.password = await storage.read(key: "password");

    return codename != null;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final String title = "Laserforce Ranking";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _viewOwnProfile() async {
    if (LaserforceApi.codename != null) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PlayerPage(codename: LaserforceApi.codename!)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 110,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  "Laserforce Ranking",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text("Players"),
              textColor: Theme.of(context).colorScheme.onPrimary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayersPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: _viewOwnProfile,
        tooltip: "View own profile",
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.person, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
