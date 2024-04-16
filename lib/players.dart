import "package:flutter/material.dart";

class PlayersPage extends StatelessWidget {
    PlayersPage({super.key});

    final List<String> players = [

    ];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
                title: Text("Players", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
            ),
            body: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(players[index]),
                    );
                },
            ),
        );
    }
}
