import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:votacao_mobile/configs/api/api.dart';

class CandidatePage extends StatefulWidget {
  const CandidatePage({Key? key}) : super(key: key);

  @override
  State<CandidatePage> createState() => _CandidatePageState();
}

class _CandidatePageState extends State<CandidatePage> {
  Future<List> allCandidates() async {
    var url = Uri.parse('$api/api/candidatos');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    throw Exception('Erro ao carregar lista de candidatos.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Candidatos'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              color: Colors.white,
              onPressed: () {
                setState(() {});
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, 'voting')
              .then((value) => setState(() {}));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 60),
        child: FutureBuilder<List>(
          future: allCandidates(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Erro ao carregar lista de candidatos.'),
              );
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var voto = snapshot.data![index]['total_votos'].toString();
                  var votoAjust =
                      double.parse(voto).toStringAsFixed(2).toString();
                  if (votoAjust == '0') {
                    voto = '00.00';
                  } else if (votoAjust.length == 4) {
                    voto = '0$votoAjust';
                  } else {
                    voto = votoAjust;
                  }
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          NetworkImage(snapshot.data![index]['imagem']),
                    ),
                    title: Text(snapshot.data![index]['nome']),
                    subtitle: LinearPercentIndicator(
                      lineHeight: 20.0,
                      trailing: Text('$voto %'),
                      backgroundColor: const Color.fromARGB(151, 158, 158, 158),
                      progressColor: Colors.blue,
                      percent: double.parse(voto) / 100,
                    ),
                    trailing: Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      padding: const EdgeInsets.all(6.0),
                      color: const Color.fromARGB(151, 158, 158, 158),
                      child: Text(
                        snapshot.data![index]['numero'].toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
              ),
            );
          },
        ),
      ),
    );
  }
}
