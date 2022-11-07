import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:votacao_mobile/configs/api/api.dart';
import 'package:http/http.dart' as http;

class VotingPage extends StatefulWidget {
  const VotingPage({Key? key}) : super(key: key);

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  final _formKey = GlobalKey<FormState>();
  var age = TextEditingController();
  var city = TextEditingController();
  var state = TextEditingController();
  var voteNumber = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> vote() async {
    var url = Uri.parse('$api/api/usuarios/salvar');
    Map data = {
      "voto": int.parse(voteNumber.text),
      "idade": 24,
      "cidade": int.parse(age.text),
      "estado": state.text
    };
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: json.encode(data));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Votação'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        field(age, '', TextInputType.number, 'Idade'),
                        field(city, 'Ex: Ribeirão Preto', TextInputType.text,
                            'Cidade'),
                        field(state, 'Ex: São Paulo', TextInputType.text,
                            'Estado'),
                        field(
                            voteNumber, 'Ex: 18', TextInputType.number, 'Voto'),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 4,
                ))
              else
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      var votting = await vote();

                      setState(() {
                        _isLoading = false;
                      });
                      if (votting) {
                        message('');
                      } else {
                        message('Erro ao efetuar a votação');
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.lightBlue;
                    }),
                    fixedSize: MaterialStateProperty.all<Size>(
                        Size(MediaQuery.of(context).size.width, 40)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Votar',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
            ],
          )),
    );
  }

  field(controller, hintText, type, title) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value == '') {
              return 'Preencha o campo';
            }
            return null;
          },
          controller: controller,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: type,
          decoration: InputDecoration(
            errorStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.red,
            ),
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            hintText: hintText,
            isDense: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(47),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(47),
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(47),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(47),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  message(erro) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Row(
            children: [
              Icon(
                erro == ''
                    ? Icons.check_circle_outline
                    : Icons.dangerous_outlined,
                color: erro == '' ? Colors.green : Colors.red,
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Text(
                erro == '' ? 'Voto efetuado com sucesso' : erro,
                style: const TextStyle(
                    fontSize: 14, fontFamily: 'Poppins', color: Colors.white),
              ),
            ],
          ),
          duration: Duration(
            seconds: erro == '' ? 3 : 5,
          ),
          backgroundColor: Colors.black,
        ))
        .closed
        .then((value) {
      if (erro == '') {
        Navigator.pop(context);
      }
    });
  }
}
