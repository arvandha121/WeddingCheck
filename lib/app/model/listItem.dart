class ListItem {
  int? id;
  int? parentId;
  String nama;
  String alamat;
  String kota;
  String kecamatan;
  String? keluarga;
  String gambar;
  String keterangan;

  ListItem({
    this.id,
    this.parentId,
    required this.nama,
    required this.alamat,
    required this.kota,
    required this.kecamatan,
    this.keluarga,
    required this.gambar,
    required this.keterangan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parentId': parentId,
      'nama': nama,
      'alamat': alamat,
      'kota': kota,
      'kecamatan': kecamatan,
      'keluarga': keluarga,
      'gambar': gambar,
      'keterangan': keterangan,
    };
  }

  factory ListItem.fromMap(Map<String, dynamic> map) {
    return ListItem(
      id: map['id'],
      parentId: map['parentId'],
      nama: map['nama'],
      alamat: map['alamat'],
      kota: map['kota'],
      kecamatan: map['kecamatan'],
      keluarga: map['keluarga'],
      gambar: map['gambar'],
      keterangan: map['keterangan'],
    );
  }
}
