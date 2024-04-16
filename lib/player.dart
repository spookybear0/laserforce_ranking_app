import "package:flutter/material.dart";
import "package:laserforce_ranking_app/api.dart";
import "dart:convert";
import "package:fl_chart/fl_chart.dart";

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key, required this.codename});

  final String codename;

  @override
  PlayerPageState createState() => PlayerPageState(codename);
}

class PlayerPageState extends State<PlayerPage> {
  PlayerPageState(this.codename);

  final String codename;
  bool _isLoading = true;
  int _currentPageIndex = 0;
  dynamic playerData;

  @override
  void initState() {
    super.initState();
    getPlayerData();
  }

  void getPlayerData() {
    LaserforceApi.getPlayerData(codename, stats: true, recentGames: true).then((response) {
      setState(() {
        playerData = jsonDecode(response.body);
        _isLoading = false;
      });
    });
  }

  Widget buildStatisticsPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Text("Statistics", style: TextStyle(fontSize: 48)),
            const SizedBox(height: 32),
            // average role score chart (playerData["median_role_score"]), its a list of 5 elements, 1 for the
            // median score of each role [Commander, Heavy, Scout, Ammo, Medic]
            AspectRatio(
                aspectRatio: 2,
                child: BarChart(BarChartData(
                    barGroups: [
                      // create a bar for each role programatically
                      for (int i = 0; i < 5; i++)
                        BarChartGroupData(x: i, barRods: [
                          BarChartRodData(
                            toY:
                                playerData["median_role_score"][i].toDouble(),
                            color: Colors.blue,
                            width: 20,
                            borderRadius: BorderRadius.zero,
                          )
                        ])
                    ],
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 0:
                                  return const Image(
                                      image: AssetImage(
                                          "assets/sm5/roles/commander.png"),
                                      width: 50,
                                      height: 50);
                                case 1:
                                  return const Image(
                                      image: AssetImage(
                                          "assets/sm5/roles/heavy.png"),
                                      width: 50,
                                      height: 50);
                                case 2:
                                  return const Image(
                                      image: AssetImage(
                                          "assets/sm5/roles/scout.png"),
                                      width: 50,
                                      height: 50);
                                case 3:
                                  return const Image(
                                      image: AssetImage(
                                          "assets/sm5/roles/ammo.png"),
                                      width: 50,
                                      height: 50);
                                case 4:
                                  return const Image(
                                      image: AssetImage(
                                          "assets/sm5/roles/medic.png"),
                                      width: 50,
                                      height: 50);
                                default:
                                  return const Text("");
                              }
                            }),
                      ),
                    )))),
          ],
        ),
      ),
    );
  }

  Widget buildProfilePage() {
    int i = 0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ListView(
          children: [
            Column(
              children: [
                Text(codename, style: const TextStyle(fontSize: 48)),
                Text(playerData["player_id"],
                    style: const TextStyle(fontSize: 24)),
                Text(playerData["entity_id"],
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 32),
                Text("SM5 Rating: ${(playerData["sm5_ordinal"]).toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 24)),
                Text("Laserball Rating: ${(playerData["laserball_ordinal"]).toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 32),
                // recent games list
                if (playerData["recent_sm5_games"] != null)
                  Column(
                    children: [
                      const Text("Recent SM5 Games", style: TextStyle(fontSize: 24)),
                      const SizedBox(height: 16),
                      Table(
                        border: TableBorder.all(color: Theme.of(context).colorScheme.onInverseSurface),
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.inverseSurface,
                            ),
                            children: const [
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Center(
                                    child: Text("Game", style: TextStyle(fontSize: 18))
                                  )
                                )
                              ),
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Center(
                                    child: Text("Win/Loss", style: TextStyle(fontSize: 18), textAlign: TextAlign.center)
                                  )
                                )
                              ),
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Center(
                                    child: Text("Rating", style: TextStyle(fontSize: 18))
                                  )
                                )
                              ),
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Center(
                                    child: Text("Role", style: TextStyle(fontSize: 18))
                                  )
                                )
                              ),
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Center(
                                    child: Text("Score", style: TextStyle(fontSize: 18))
                                  )
                                )
                              ),
                            ]
                          ),
                          for (var game in playerData["recent_sm5_games"])
                            TableRow(
                              decoration: BoxDecoration(
                                color: ++i % 2 == 0 ? Theme.of(context).colorScheme.inverseSurface : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              children: [
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Center(
                                    child: Text(DateTime.fromMillisecondsSinceEpoch(game["start_time"].toInt() * 1000).toString().split(".")[0], style: const TextStyle(fontSize: 18), textAlign: TextAlign.center)
                                  )
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Center(
                                    child: Text(
                                      game["winner"].toString().toLowerCase() == (game["player_entity_start"]["team"].toString().toLowerCase()) ? "Win" : "Loss",
                                      style: TextStyle(fontSize: 18, color: game["winner"].toString().toLowerCase() == (game["player_entity_start"]["team"].toString().toLowerCase()) ? earthColor : fireColor),
                                    )
                                  )
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Center(
                                    child: Text(game["player_entity_end"]["current_rating"].toStringAsFixed(2), style: const TextStyle(fontSize: 18))
                                  )
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Center(
                                    child: Image.asset(roleToImagePath(roleFromValue(game["player_entity_start"]["role"])), width: 30, height: 30)
                                  )
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Center(
                                    child: Text(game["player_entity_end"]["score"].toString(), style: const TextStyle(fontSize: 18))
                                  )
                                ),
                              ]
                            ),
                        ],
                    ),
                  ]),
                const SizedBox(height: 32),
                  if (playerData["recent_laserball_games"] != null)
                    Column(
                      children: [
                        const Text("Recent Laserball Games", style: TextStyle(fontSize: 24)),
                        const SizedBox(height: 16),
                        Table(
                          border: TableBorder.all(color: Theme.of(context).colorScheme.onInverseSurface),
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.inverseSurface,
                              ),
                              children: const [
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Center(
                                      child: Text("Game", style: TextStyle(fontSize: 18))
                                    )
                                  )
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Center(
                                      child: Text("Win/Loss", style: TextStyle(fontSize: 18), textAlign: TextAlign.center)
                                    )
                                  )
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Center(
                                      child: Text("Rating", style: TextStyle(fontSize: 18))
                                    )  
                                  )
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Center(
                                      child: Text("Goals", style: TextStyle(fontSize: 18))
                                    )
                                  )
                                ),
                              ]
                            ),
                            for (var game in playerData["recent_laserball_games"])
                              TableRow(
                                decoration: BoxDecoration(
                                  color: ++i % 2 == 0 ? Theme.of(context).colorScheme.inverseSurface : Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                children: [
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Center(
                                      child: Text(DateTime.fromMillisecondsSinceEpoch(game["start_time"].toInt() * 1000).toString().split(".")[0], style: const TextStyle(fontSize: 18), textAlign: TextAlign.center)
                                    )
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Center(
                                      child: Text(
                                        game["winner"].toString().toLowerCase() == (game["player_entity_start"]["team"].toString().toLowerCase()) ? "Win" : "Loss",
                                        style: TextStyle(fontSize: 18, color: game["winner"].toString().toLowerCase() == (game["player_entity_start"]["team"].toString().toLowerCase()) ? earthColor : fireColor),
                                      )
                                    )
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Center(
                                      child: Text(game["player_entity_end"]["current_rating"].toStringAsFixed(2), style: const TextStyle(fontSize: 18))
                                    )
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Center(
                                      child: Text(game["player_entity_end"]["score"].toString(), style: const TextStyle(fontSize: 18))
                                    )
                                  ),
                                ]
                              ),
                          ],
                        )
                      ],
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // wait for player data to be fetched, show loading spinner
    if (playerData == null || _isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Widget page;

    switch (_currentPageIndex) {
      case 0:
        page = buildProfilePage();
      case 1:
        page = buildStatisticsPage();
      default:
        return const Center(
          child: Text("Invalid page index"),
        );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        title: Text("Player", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        // gray out the unselected item
        unselectedItemColor: Theme.of(context).colorScheme.surface,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: "Statistics"),
        ],
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            getPlayerData();
            _currentPageIndex = index;
          });
        },
      ),
    );
  }
}
