import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  ApiService({required this.sirensiret});
  // String siren = '399134691';
  //String token = 'bf96b255-8239-33b3-9fcd-07043eb3a821';
  String sirensiret;

  Future checkIfSirenExist() async {
    Future<http.Response> fetchAlbum() async {
      final response = await http.get(
          Uri.parse(sirensiret.length > 9
              ? 'https://api.insee.fr/entreprises/sirene/V3/siret/$sirensiret'
              : 'https://api.insee.fr/entreprises/sirene/V3/siren/$sirensiret'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ff23022b-8c28-3dab-aaa5-f1429a41c51a',
          });

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(response.statusCode);
      }
    }

    http.Response statu = await fetchAlbum();

    if (statu.statusCode == 200) {
      if (sirensiret.length > 9) {
        return Siret.fromJson(jsonDecode(statu.body));
      } else {
        return Siren.fromJson(jsonDecode(statu.body));
      }
    } else {
      return Siren(
          name: 'Inconnue',
          creation: "N'existe pas",
          categorie: "Aucune catégorie");
    }
  }
}

class Siren {
  String name;
  String creation;
  String categorie;

  Siren({
    required this.name,
    required this.creation,
    required this.categorie,
  });

  Siren.fromJson(Map<String, dynamic> json)
      : name = json['uniteLegale']['periodesUniteLegale'][0]
            ['denominationUniteLegale'],
        creation = json['uniteLegale']['dateCreationUniteLegale'],
        categorie = json['uniteLegale']['categorieEntreprise'];
}

class Siret {
  String name;
  String creation;
  String categorie;
  String ville;
  String codepostal;

  Siret(
      {required this.name,
      required this.creation,
      required this.categorie,
      required this.ville,
      required this.codepostal});

  Siret.fromJson(Map<String, dynamic> json)
      : name = json['etablissement']['uniteLegale']['denominationUniteLegale'],
        creation =
            json['etablissement']['uniteLegale']['dateCreationUniteLegale'],
        categorie = json['etablissement']['uniteLegale']['categorieEntreprise'],
        ville = json['etablissement']['adresseEtablissement']
            ['libelleCommuneEtablissement'],
        codepostal = json['etablissement']['adresseEtablissement']
            ['codePostalEtablissement'];
}
