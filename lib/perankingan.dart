import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PerankinganPage extends StatefulWidget {
  const PerankinganPage({super.key});

  @override
  State<PerankinganPage> createState() => _PerankinganPageState();
}

class _PerankinganPageState extends State<PerankinganPage> {

  List kelasList = [];
  String? selectedKelas;
  List ranking = [];

  final String baseUrl =
      "http://localhost/FlutterProjects/spksaw/api/perankingan.php";

  @override
  void initState() {
    super.initState();
    getKelas();
    getRanking();
  }

  /// ================= GET DROPDOWN KELAS =================
  Future getKelas() async {

    final res = await http.get(
      Uri.parse("$baseUrl?action=get_kelas"),
    );

    if (res.statusCode == 200) {
      setState(() {
        kelasList = json.decode(res.body);
      });
    }
  }

  /// ================= RESET (TRUNCATE) =================
  Future resetRanking() async {

    await http.get(
      Uri.parse("$baseUrl?action=reset"),
    );

    await getRanking(); // AUTO REFRESH
  }

  /// ================= PROSES SAW =================
  Future prosesRanking() async {

    if (selectedKelas == null) return;

    await http.get(
      Uri.parse("$baseUrl?action=proses&kelas=$selectedKelas"),
    );

    await getRanking(); // AUTO REFRESH
  }

  /// ================= GET HASIL RANKING =================
  Future getRanking() async {

    final res = await http.get(
      Uri.parse(baseUrl),
    );

    if (res.statusCode == 200) {
      setState(() {
        ranking = json.decode(res.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        children: [

          /// ================= TOP CONTROL =================
          Row(
            children: [

              /// RESET BUTTON (KIRI)
              ElevatedButton(
                onPressed: resetRanking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Reset"),
              ),

              const SizedBox(width: 20),

              /// DROPDOWN KELAS (TENGAH)
              Expanded(
                child: DropdownButtonFormField(
                  value: selectedKelas,
                  decoration: InputDecoration(
                    labelText: "Pilih Kelas",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: kelasList.map<DropdownMenuItem>((k){
                    return DropdownMenuItem(
                      value: k,
                      child: Text(k),
                    );
                  }).toList(),
                  onChanged: (v){
                    setState(() {
                      selectedKelas = v.toString();
                    });
                  },
                ),
              ),

              const SizedBox(width: 20),

              /// PROSES BUTTON (KANAN)
              ElevatedButton(
                onPressed: prosesRanking,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Proses"),
              ),

            ],
          ),

          const SizedBox(height: 20),

          /// ================= TABLE =================
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(

                headingRowColor:
                MaterialStateProperty.all(Colors.grey[300]),

                columns: const [

                  DataColumn(
                    label: Center(child: Text("Peringkat")),
                  ),

                  DataColumn(
                    label: Center(child: Text("NISN")),
                  ),

                  DataColumn(
                    label: Center(child: Text("Nama")),
                  ),

                  DataColumn(
                    label: Center(child: Text("Nilai SAW")),
                  ),

                ],

                rows: List.generate(ranking.length, (i){

                  final d = ranking[i];

                  return DataRow(cells: [

                    /// PERINGKAT (START FROM 1)
                    DataCell(
                      Center(child: Text("${i+1}")),
                    ),

                    DataCell(
                      Center(child: Text(d['nisn'])),
                    ),

                    DataCell(
                      Center(child: Text(d['nama'])),
                    ),

                    DataCell(
                      Center(child: Text(d['nilai'].toString())),
                    ),

                  ]);

                }),

              ),
            ),
          )
        ],
      ),
    );
  }
}
