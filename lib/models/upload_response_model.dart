class UploadResponse {
  List<FileModel>? files;
  Summary? summary;

  UploadResponse({this.files, this.summary});

  UploadResponse.fromJson(Map<String, dynamic> json) {
    if (json['files'] != null) {
      files = <FileModel>[];
      json['files'].forEach((v) {
        files!.add(FileModel.fromJson(v));
      });
    }
    summary =
        json['summary'] != null ? Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    return data;
  }
}

class FileModel {
  String? originalName;
  String? fileName;
  int? size;
  String? mimetype;
  String? url;
  String? key;
  String? etag;

  FileModel({
    this.originalName,
    this.fileName,
    this.size,
    this.mimetype,
    this.url,
    this.key,
    this.etag,
  });

  FileModel.fromJson(Map<String, dynamic> json) {
    originalName = json['originalName'];
    fileName = json['fileName'];
    size = json['size'];
    mimetype = json['mimetype'];
    url = json['url'];
    key = json['key'];
    etag = json['etag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['originalName'] = originalName;
    data['fileName'] = fileName;
    data['size'] = size;
    data['mimetype'] = mimetype;
    data['url'] = url;
    data['key'] = key;
    data['etag'] = etag;
    return data;
  }
}

class Summary {
  int? totalFiles;
  int? successfulUploads;
  int? failedUploads;
  int? successRate;

  Summary({
    this.totalFiles,
    this.successfulUploads,
    this.failedUploads,
    this.successRate,
  });

  Summary.fromJson(Map<String, dynamic> json) {
    totalFiles = json['totalFiles'];
    successfulUploads = json['successfulUploads'];
    failedUploads = json['failedUploads'];
    successRate = json['successRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalFiles'] = totalFiles;
    data['successfulUploads'] = successfulUploads;
    data['failedUploads'] = failedUploads;
    data['successRate'] = successRate;
    return data;
  }
}
