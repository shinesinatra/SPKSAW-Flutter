import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KriteriaPage extends StatefulWidget {
  const KriteriaPage({super.key});

  @override
  State<KriteriaPage> createState() => _KriteriaPageState();
}

class _KriteriaPageState extends State<KriteriaPage> {

  final String baseUrl = "http://localhost/FlutterProjects/spksaw/api/kriteria.php";
  final ScrollController _horizontalScroll = ScrollController();

  List data = [];

  Future fetchData() async {
    final res = await http.get(Uri.parse("$baseUrl?action=get"));
    setState(() {
      data = json.decode(res.body);
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _horizontalScroll.dispose();
    super.dispose();
  }

  void showForm({Map? item}) {

    final kode = TextEditingController(text: item?['kode']);
    final nama = TextEditingController(text: item?['nama']);
    final bobot = TextEditingController(text: item?['bobot']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item == null ? "Tambah Kriteria" : "Ubah Kriteria",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),

              const SizedBox(height: 20),

              TextField(
                controller: kode,
                decoration: inputStyle("Kode"),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: nama,
                decoration: inputStyle("Nama Kriteria"),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: bobot,
                decoration: inputStyle("Bobot"),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {

                    if(item == null){
                      await http.post(Uri.parse("$baseUrl?action=add"), body:{
                        "kode":kode.text,
                        "nama":nama.text,
                        "bobot":bobot.text
                      });
                    } else {
                      await http.post(Uri.parse("$baseUrl?action=update"), body:{
                        "kode":kode.text,
                        "nama":nama.text,
                        "bobot":bobot.text
                      });
                    }

                    Navigator.pop(context);
                    fetchData();
                  },
                  child: const Text("Simpan"),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void deleteData(String kode) async {
    await http.post(Uri.parse("$baseUrl?action=delete"), body:{"kode":kode});
    fetchData();
  }

  InputDecoration inputStyle(String label){
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF7F7F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF2F2F2),
              foregroundColor: Colors.black,
            ),
            onPressed: ()=>showForm(),
            icon: const Icon(Icons.add),
            label: const Text("Tambah"),
          ),

          const SizedBox(height:20),

          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Scrollbar(
                    controller: _horizontalScroll,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _horizontalScroll,
                      scrollDirection: Axis.horizontal,
                      child: IntrinsicWidth(
                        child: DataTable(

                          headingRowColor:
                          MaterialStateProperty.all(const Color(0xFFF5F5F5)),

                          columnSpacing: 20,
                          horizontalMargin: 12,
                          dataRowMinHeight: 45,
                          dataRowMaxHeight: 50,
                          headingRowHeight: 50,

                          columns: [

                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  "Kode",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  "Kriteria",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  "Bobot",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  "Aksi",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                          ],

                          rows: data.map((e) =>
                              DataRow(cells: [

                                DataCell(
                                  Center(child: Text(e['kode']))
                                ),

                                DataCell(
                                  Center(child: Text(e['nama']))
                                ),

                                DataCell(
                                  Center(child: Text(e['bobot'].toString()))
                                ),

                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () => showForm(item: e),
                                          splashRadius: 20,
                                        ),

                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => deleteData(e['kode']),
                                          splashRadius: 20,
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                              ])
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
