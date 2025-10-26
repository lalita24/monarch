class Monarch {
  final int? id;
  final int reignNo;         // รัชกาลที่ ...
  final String name;         // พระนาม
  final String years;        // ช่วงปีครองราชย์
  final String bio;          // ประวัติย่อ
  final String photoPath;    // path ของรูป (asset)

  const Monarch({
    this.id,
    required this.reignNo,
    required this.name,
    required this.years,
    required this.bio,
    required this.photoPath,
  });

  Monarch copyWith({
    int? id,
    int? reignNo,
    String? name,
    String? years,
    String? bio,
    String? photoPath,
  }) {
    return Monarch(
      id: id ?? this.id,
      reignNo: reignNo ?? this.reignNo,
      name: name ?? this.name,
      years: years ?? this.years,
      bio: bio ?? this.bio,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'reignNo': reignNo,
        'name': name,
        'years': years,
        'bio': bio,
        'photoPath': photoPath,
      };

  factory Monarch.fromMap(Map<String, dynamic> map) => Monarch(
        id: map['id'] as int?,
        reignNo: map['reignNo'] as int,
        name: map['name'] as String,
        years: map['years'] as String,
        bio: map['bio'] as String,
        photoPath: map['photoPath'] as String,
      );
}
