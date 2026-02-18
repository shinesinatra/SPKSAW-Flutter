import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class PenilaianPage extends StatefulWidget {
  const PenilaianPage({super.key});

  @override
  State<PenilaianPage> createState() => _PenilaianPageState();
}

class _PenilaianPageState extends State<PenilaianPage> {
  final String baseUrl =
      "http://localhost/FlutterProjects/spksaw/api/penilaian.php";
  final ScrollController _horizontalScroll = ScrollController();

  List data = [];
  List kriteria = [];
  List kelasList = [];
  List siswaList = [];

  Map<String, String> fieldMap = {};

  @override
  void initState() {
    fetchAll();
    super.initState();
  }

  Future fetchAll() async {
    final res = await http.get(Uri.parse("$baseUrl?action=get"));
    final jsonData = json.decode(res.body);

    setState(() {
      data = jsonData['penilaian'];
      kriteria = jsonData['kriteria'];
      kelasList = jsonData['kelas'];

      fieldMap.clear();
      for (var k in kriteria) {
        fieldMap[k['field']] = k['nama'];
      }
    });
  }

  Future fetchSiswa(String kelas) async {
    final res = await http.post(
      Uri.parse("$baseUrl?action=getSiswa"),
      body: {"kelas": kelas},
    );
    siswaList = json.decode(res.body);
  }

  void showForm({Map? item}) {
    String? kelas = item?['kelas'];
    String? nisn = item?['nisn'];

    TextEditingController namaController =
        TextEditingController(text: item?['nama']);

    Map<String, TextEditingController> nilaiController = {};

    for (var k in kriteria) {
      final field = k['field'];
      nilaiController[field] = TextEditingController(
        text: item != null ? item[field]?.toString() : '',
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back),
                        SizedBox(width: 5),
                        Text("Kembali"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: kelas,
                    decoration: inputStyle("Kelas"),
                    items: kelasList
                        .map<DropdownMenuItem<String>>(
                          (k) => DropdownMenuItem(value: k, child: Text(k)),
                        )
                        .toList(),
                    onChanged: item != null
                        ? null
                        : (val) async {
                            setModalState(() => kelas = val);
                            await fetchSiswa(val!);
                            setModalState(() {});
                          },
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: nisn,
                    decoration: inputStyle("NISN"),
                    items: siswaList
                        .map<DropdownMenuItem<String>>(
                          (s) => DropdownMenuItem(
                            value: s['nisn'],
                            child: Text(s['nisn']),
                          ),
                        )
                        .toList(),
                    onChanged: item != null
                        ? null
                        : (val) {
                            setModalState(() {
                              nisn = val;
                              namaController.text = siswaList.firstWhere(
                                (e) => e['nisn'] == val,
                              )['nama'];
                            });
                          },
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: namaController,
                    readOnly: true,
                    decoration: inputStyle("Nama"),
                  ),

                  const SizedBox(height: 10),

                  ...kriteria.map((k) {
                    final field = k['field'];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        controller: nilaiController[field],
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        decoration: inputStyle(k['nama']),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Map<String, String> body = {
                          "kelas": kelas!,
                          "nisn": nisn!,
                          "nama": namaController.text,
                        };

                        nilaiController.forEach((key, val) {
                          body[key] = val.text;
                        });

                        if (item == null) {
                          await http.post(Uri.parse("$baseUrl?action=add"), body: body);
                        } else {
                          await http.post(Uri.parse("$baseUrl?action=update"), body: body);
                        }

                        Navigator.pop(context);
                        fetchAll();
                      },
                      child: const Text("Simpan"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void deleteData(String nisn) async {
    await http.post(Uri.parse("$baseUrl?action=delete"), body: {"nisn": nisn});
    fetchAll();
  }

  InputDecoration inputStyle(String label) {
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
    List columns = data.isNotEmpty ? data[0].keys.toList() : [];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () => showForm(),
            icon: const Icon(Icons.add),
            label: const Text("Tambah"),
          ),

          const SizedBox(height: 20),

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
                            ...columns.map(
                              (c) => DataColumn(
                                label: Expanded(
                                  child: Text(
                                    fieldMap[c] ?? c,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            const DataColumn(
                              label: Expanded(
                                child: Text(
                                  "Aksi",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],

                          rows: data.map(
                            (row) => DataRow(
                              cells: [

                                ...columns.map(
                                  (c) => DataCell(
                                    Center(
                                      child: Text(row[c]?.toString() ?? ""),
                                    ),
                                  ),
                                ),

                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () => showForm(item: row),
                                          splashRadius: 20,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => deleteData(row['nisn']),
                                          splashRadius: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
