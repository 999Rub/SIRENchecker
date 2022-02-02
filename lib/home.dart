import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sirenapp/service/api.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? sirensiret = '';
  final _formkey = GlobalKey<FormState>();
  Siren? sirencheck;
  Siret? siretcheck;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1),
              child: Text(
                'SIREN/SIRET Checker',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.075),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration:
                            InputDecoration(hintText: 'SIREN / SIRET checker'),
                        onChanged: (value) {
                          setState(() {
                            sirensiret = value;
                            print(sirensiret);
                          });
                        },
                      ),
                      CupertinoButton(
                          child: Text('Vérifier'),
                          onPressed: () async {
                            if (_formkey.currentState!.validate() &&
                                sirensiret!.isNotEmpty) {
                              sirensiret!.length > 9
                                  ? siretcheck =
                                      await ApiService(sirensiret: sirensiret!)
                                          .checkIfSirenExist()
                                  : sirencheck =
                                      await ApiService(sirensiret: sirensiret!)
                                          .checkIfSirenExist();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Chargement terminé.')));
                            }

                            setState(() {
                              if (sirensiret!.length > 9) {
                                siretcheck = siretcheck;
                              } else {
                                sirencheck = sirencheck;
                              }
                            });
                          }),
                    ],
                  ),
                )),
            sirencheck?.name != 'Inconnue' && sirencheck?.name != null
                ? Container(
                    child: Text(
                        "Le SIREN existe et correspond à ${sirencheck?.categorie} : ${sirencheck?.name} qui a été créée le ${sirencheck?.creation}"),
                  )
                : Text("Aucune entreprise n'existe pour ce SIREN."),
            siretcheck?.name != 'Inconnue' && siretcheck?.name != null
                ? Text(
                    "Le SIRET existe et correspond à ${siretcheck?.categorie} : ${siretcheck?.name} qui a été créée le ${siretcheck?.creation}  à ${siretcheck?.ville} - ${siretcheck?.codepostal}")
                : Container(
                    child: Text("Aucune entreprise n'existe pour ce SIRET."),
                  )
          ],
        ),
      ),
    );
  }
}
