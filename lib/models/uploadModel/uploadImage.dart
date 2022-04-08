import 'dart:convert';

List<UploadImage> uploadFromJson(String str) => List<UploadImage>.from(json.decode(str).map((x) => UploadImage.fromJson(x)));

String uploadToJson(List<UploadImage> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UploadImage {
  UploadImage({
    this.id,
    this.url,
    this.width,
    this.height,
    this.originalFilename,
    this.pending,
    this.approved,
  });

  String? id;
  String? url;
  int? width;
  int? height;
  String? originalFilename;
  int? pending;
  int? approved;

  factory UploadImage.fromJson(Map<String, dynamic> json) => UploadImage(
    id: json["id"],
    url: json["url"],
    width: json["width"],
    height: json["height"],
    originalFilename: json["original_filename"],
    pending: json["pending"],
    approved: json["approved"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "width": width,
    "height": height,
    "original_filename": originalFilename,
    "pending": pending,
    "approved": approved,
  };
}
