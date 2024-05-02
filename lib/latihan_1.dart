import 'dart:convert';

void main() {
  // JSON string yang merepresentasikan data transkrip mahasiswa
  String jsonString = '''
  {
    "nama": "Rendy Achmadiansyah Mukti",
    "nim": "22082010028",
    "jurusan": "Sistem Informasi",
    "mata_kuliah": [
      {
        "nama_kursus": "BP 1",
        "nilai": 3.70,
        "kredit": 3
      },
      {
        "nama_kursus": "BP 2",
        "nilai": 4,
        "kredit": 2
      },
      {
        "nama_kursus": "Pemograman Mobile",
        "nilai": 2.8,
        "kredit": 3
      },
      {
        "nama_kursus": "Statkom",
        "nilai": 3.25,
        "kredit": 2
      }
    ]
  }
  ''';

  // Parsing JSON string ke dalam Map<String, dynamic>
  Map<String, dynamic> mahasiswaJson = jsonDecode(jsonString);

  // Akses daftar mata kuliah
  List<dynamic> mataKuliah = mahasiswaJson['mata_kuliah'];

  // Inisialisasi variabel untuk perhitungan IPK
  double totalNilai = 0.0;
  int totalKredit = 0;

  // Perulangan untuk menghitung total nilai dan total kredit
  for (var mk in mataKuliah) {
  double nilai = mk['nilai'] * (mk['kredit'] as int);  // Cast 'kredit' to 'int'
  totalNilai += nilai;
  totalKredit += mk['kredit'] as int;  // Ensure 'kredit' is treated as 'int'
}

  // Menghitung IPK
  double ipk = totalNilai / totalKredit;

  // Cetak IPK
  print("Nama: ${mahasiswaJson['nama']}");
  print("NIM: ${mahasiswaJson['nim']}");
  print("Jurusan: ${mahasiswaJson['jurusan']}");
  print("IPK: ${ipk.toStringAsFixed(2)}");
}
