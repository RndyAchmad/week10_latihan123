import 'package:flutter/material.dart'; // Mengimpor material package untuk UI.
import 'package:http/http.dart' as http; // Mengimpor http package untuk melakukan permintaan HTTP.
import 'dart:convert'; // Mengimpor dart:convert untuk mengkonversi data JSON.

void main() => runApp(MyApp()); // Fungsi main, titik masuk program, menjalankan MyApp.

class MyApp extends StatelessWidget { // Kelas MyApp, stateless widget.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Universitas di Indonesia', // Judul aplikasi.
      theme: ThemeData( // Tema global untuk aplikasi.
        primarySwatch: Colors.blue, // Warna utama yang digunakan adalah biru.
      ),
      home: UniversityList(), // Halaman utama aplikasi adalah UniversityList.
    );
  }
}

class University { // Kelas untuk mendefinisikan model data universitas.
  final String name; // Nama universitas.
  final String website; // Website universitas.

  University({required this.name, required this.website}); // Konstruktor dengan required fields.

  factory University.fromJson(Map<String, dynamic> json) { // Factory constructor untuk membuat instance dari JSON.
    return University(
      name: json['name'], // Mengambil nilai nama dari JSON.
      website: json['web_pages'][0], // Mengambil nilai website pertama dari array web_pages.
    );
  }
}

class UniversityList extends StatefulWidget { // Stateful widget untuk daftar universitas.
  @override
  _UniversityListState createState() => _UniversityListState(); // Membuat state.
}

class _UniversityListState extends State<UniversityList> { // State dari UniversityList.
  late Future<List<University>> futureUniversities; // Deklarasi Future list dari University.

  @override
  void initState() { // Override initState.
    super.initState();
    futureUniversities = fetchUniversities(); // Memuat data universitas.
  }

  Future<List<University>> fetchUniversities() async { // Fungsi untuk mengambil data universitas dari API.
    final response = await http.get( // Melakukan permintaan GET.
        Uri.parse('http://universities.hipolabs.com/search?country=Indonesia'));

    if (response.statusCode == 200) { // Cek jika status code adalah 200 (berhasil).
      List<dynamic> universitiesJson = jsonDecode(response.body); // Dekode respons menjadi JSON.
      return universitiesJson.map((json) => University.fromJson(json)).toList(); // Konversi JSON ke list dari University.
    } else {
      throw Exception('Failed to load universities'); // Lempar exception jika gagal memuat data.
    }
  }

  @override
  Widget build(BuildContext context) { // Method untuk build UI.
    return Scaffold(
      appBar: AppBar(
        title: Text('Universitas di Indonesia'), // Judul app bar.
      ),
      body: FutureBuilder<List<University>>( // FutureBuilder untuk menangani data Future.
        future: futureUniversities,
        builder: (context, snapshot) { // Builder untuk membangun UI berdasarkan snapshot.
          if (snapshot.connectionState == ConnectionState.done) { // Cek jika koneksi selesai.
            if (snapshot.hasData) { // Cek jika snapshot memiliki data.
              return ListView.separated( // Menggunakan ListView dengan pemisah.
                itemCount: snapshot.data!.length, // Jumlah item adalah panjang data.
                separatorBuilder: (_, __) => Divider(height: 1), // Builder untuk divider.
                itemBuilder: (context, index) { // Item builder untuk setiap universitas.
                  return ListTile(
                    title: Text(snapshot.data![index].name), // Tampilkan nama universitas.
                    subtitle: Text(snapshot.data![index].website), // Tampilkan website universitas.
                  );
                },
              );
            } else if (snapshot.hasError) { // Jika ada error dalam snapshot.
              return Center(
                child: Text("Error: ${snapshot.error}"), // Tampilkan error.
              );
            }
          }
          return Center(child: CircularProgressIndicator()); // Tampilkan spinner saat memuat.
        },
      ),
    );
  }
}