import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sirenapp/service/api.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? siren;
  final _formkey = GlobalKey<FormState>();
  Siren? sirencheck;
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
                'SIREN Checker',
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
                        onChanged: (value) {
                          setState(() {
                            siren = value;
                            print(siren);
                          });
                        },
                      ),
                      CupertinoButton(
                          child: Text('Vérifier'),
                          onPressed: () async {
                            if (siren != null &&
                                _formkey.currentState!.validate()) {
                              sirencheck =
                                  await ApiService().checkIfSirenExist(siren!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Chargement terminé.')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Veuillez saisir une valeur valide.')));
                            }

                            setState(() {
                              sirencheck = sirencheck;
                            });
                          }),
                    ],
                  ),
                )),
            sirencheck?.name != 'Inconnue' && sirencheck?.name != null
                ? Container(
                    child: Text(
                        "Le SIREN existe et correspond à : ${sirencheck?.name}"),
                  )
                : Container(
                    child: Text("Aucune entreprise n'existe pour ce SIREN."),
                  )
          ],
        ),
      ),
    );
  }
}
