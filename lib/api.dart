import "package:http/http.dart" as http;
import "dart:convert";
import "package:flutter/material.dart";

// enum IntRole

enum IntRole {
  commander,
  heavy,
  scout,
  ammo,
  medic
}

IntRole roleFromValue(int value) {
  switch (value) {
    case 1: return IntRole.commander;
    case 2: return IntRole.heavy;
    case 3: return IntRole.scout;
    case 4: return IntRole.ammo;
    case 5: return IntRole.medic;
    default: throw ArgumentError(value);
  }
}

int roleToValue(IntRole role) {
  switch (role) {
    case IntRole.commander: return 1;
    case IntRole.heavy: return 2;
    case IntRole.scout: return 3;
    case IntRole.ammo: return 4;
    case IntRole.medic: return 5;
  }
}

// maybe move this

Color fireColor = const Color.fromRGBO(255, 69, 0, 1);
Color iceColor = const Color.fromRGBO(0, 150, 255, 1);
Color earthColor = const Color.fromRGBO(173, 255, 47, 1);

String roleToImagePath(IntRole role) {
  switch (role) {
    case IntRole.commander: return "assets/sm5/roles/commander.png";
    case IntRole.heavy: return "assets/sm5/roles/heavy.png";
    case IntRole.scout: return "assets/sm5/roles/scout.png";
    case IntRole.ammo: return "assets/sm5/roles/ammo.png";
    case IntRole.medic: return "assets/sm5/roles/medic.png";
  }
}

class LaserforceApi {
  static const String baseUrl = "https://laserforce.spoo.uk/api/";
  static String? codename;
  static String? password;

  static Future<http.Response> post(
      String endpoint, Map<String, dynamic> body) {
    var url = Uri.parse(baseUrl + endpoint);

    var headers = {
      "Content-Type": "application/json",
    };

    if (codename != null && password != null) {
      headers["Cookie"] = "codename=$codename; password=$password";
    }

    return http.post(url, body: jsonEncode(body), headers: headers);
  }

  static Future<http.Response> login(String codename, String password) {
    return post("login", {
      "codename": codename,
      "password": password,
    });
  }

  static Future<http.Response> getPlayerData(String codename,
      {bool stats = false, bool recentGames = false}) {
    return post("player/$codename", {
      "stats": stats,
      "recent_games": recentGames,
    });
  }
}
