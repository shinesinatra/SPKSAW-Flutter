import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AlternatifPage extends StatefulWidget {
  const AlternatifPage({super.key});

  @override
  State<AlternatifPage> createState() => _AlternatifPageState();
}

class _AlternatifPageState extends State<AlternatifPage> {

  final String baseUrl = "http://localhost/FlutterProjects/spksaw/api/alternatif.php";
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

  void showForm({Map? item}) {

    final nisn = TextEditingController(text: item?['nisn']);
    final nama = TextEditingController(text: item?['nama']);
    final alamat = TextEditingController(text: item?['alamat']);

    DateTime? selectedDate = item != null
        ? DateTime.parse(item['tanggal_lahir'])
        : null;

    String kelas = item?['kelas'] ?? "I";
    String jk = item?['jenis_kelamin'] ?? "Laki-laki";

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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item == null ? "Tambah Alternatif" : "Ubah Alternatif",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
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
                    controller: nisn,
                    readOnly: item != null,
                    decoration: inputStyle("NISN"),
                  ),

                  const SizedBox(height: 15),

                  /// ✅ DROPDOWN KELAS FIX
                  DropdownButtonFormField<String>(
                    value: kelas,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    decoration: inputStyle("Kelas"),
                    items: ["I","II","III","IV","V","VI"]
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (val){
                      setModalState(()=>kelas = val!);
                    },
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: nama,
                    decoration: inputStyle("Nama"),
                  ),

                  const SizedBox(height: 15),

                  InkWell(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime(2015),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if(picked!=null){
                        setModalState(()=>selectedDate = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: inputStyle("Tanggal Lahir"),
                      child: Text(
                        selectedDate == null
                            ? "Pilih Tanggal"
                            : DateFormat("yyyy-MM-dd").format(selectedDate!),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: jk,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    decoration: inputStyle("Jenis Kelamin"),
                    items: ["Laki-laki","Perempuan"]
                        .map((e)=>DropdownMenuItem(value:e,child:Text(e)))
                        .toList(),
                    onChanged: (val){
                      setModalState(()=>jk = val!);
                    },
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: alamat,
                    decoration: inputStyle("Alamat"),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      onPressed: () async {

                        if(selectedDate == null){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Tanggal lahir wajib diisi"))
                          );
                          return;
                        }

                        if(item == null){
                          await http.post(Uri.parse("$baseUrl?action=add"), body:{
                            "nisn":nisn.text,
                            "kelas":kelas,
                            "nama":nama.text,
                            "tanggal_lahir":DateFormat("yyyy-MM-dd").format(selectedDate!),
                            "jenis_kelamin":jk,
                            "alamat":alamat.text
                          });
                        } else {
                          await http.post(Uri.parse("$baseUrl?action=update"), body:{
                            "nisn":nisn.text,
                            "kelas":kelas,
                            "nama":nama.text,
                            "tanggal_lahir":DateFormat("yyyy-MM-dd").format(selectedDate!),
                            "jenis_kelamin":jk,
                            "alamat":alamat.text
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
        ),
      ),
    );
  }

  void deleteData(String nisn) async {
    await http.post(Uri.parse("$baseUrl?action=delete"), body:{"nisn":nisn});
    fetchData();
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
                  constraints: const BoxConstraints(maxWidth: 1000),
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

                          columns: [

  DataColumn(
    label: Expanded(
      child: Text("NISN", textAlign: TextAlign.center),
    ),
  ),

  DataColumn(
    label: Expanded(
      child: Text("Kelas", textAlign: TextAlign.center),
    ),
  ),

  DataColumn(
    label: Expanded(
      child: Text("Nama", textAlign: TextAlign.center),
    ),
  ),

  DataColumn(
    label: Expanded(
      child: Text("Tanggal Lahir", textAlign: TextAlign.center),
    ),
  ),

  DataColumn(
    label: Expanded(
      child: Text("Jenis Kelamin", textAlign: TextAlign.center),
    ),
  ),

  DataColumn(
    label: Expanded(
      child: Text("Alamat", textAlign: TextAlign.center),
    ),
  ),

  DataColumn(
    label: Expanded(
      child: Text("Aksi", textAlign: TextAlign.center),
    ),
  ),

],


                          rows: data.map((e)=>
                              DataRow(cells: [

                                DataCell(Text(e['nisn'])),
                                DataCell(Text(e['kelas'])),
                                DataCell(Text(e['nama'])),
                                DataCell(Text(e['tanggal_lahir'])),
                                DataCell(Text(e['jenis_kelamin'])),
                                DataCell(Text(e['alamat'])),

                                DataCell(Row(
                                  children: [

                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed:()=>showForm(item:e),
                                    ),

                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed:()=>deleteData(e['nisn']),
                                    ),

                                  ],
                                )),

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
