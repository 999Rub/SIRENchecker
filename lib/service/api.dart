import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  // String siren = '399134691';
  //String token = 'bf96b255-8239-33b3-9fcd-07043eb3a821';

  Future<Siren> checkIfSirenExist(String siren) async {
    Future<http.Response> fetchAlbum() async {
      final response = await http.get(
          Uri.parse('https://api.insee.fr/entreprises/sirene/V3/siren/$siren'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer bf96b255-8239-33b3-9fcd-07043eb3a821',
          });

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(response.statusCode);
      }
    }

    http.Response statu = await fetchAlbum();

    if (statu.statusCode == 200) {
      return Siren.fromJson(jsonDecode(statu.body));
    } else {
      return Siren(name: 'Inconnue');
    }
  }
}

class Siren {
  String name;

  Siren({required this.name});

  Siren.fromJson(Map<String, dynamic> json)
      : name = json['uniteLegale']['periodesUniteLegale'][0]
            ['denominationUniteLegale'];
}
