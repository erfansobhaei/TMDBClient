class TrailerModel {
    final int id;
    final List<Result> results;

    TrailerModel({this.id, this.results});

    factory TrailerModel.fromJson(Map<String, dynamic> json) {
        return TrailerModel(
            id: json['id'], 
            results: json['results'] != null ? (json['results'] as List).map((i) => Result.fromJson(i)).toList() : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        if (this.results != null) {
            data['results'] = this.results.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Result {
    final String id;
    final String iso_3166_1;
    final String iso_639_1;
    final String key;
    final String name;
    final String site;
    final int size;
    final String type;

    Result({this.id, this.iso_3166_1, this.iso_639_1, this.key, this.name, this.site, this.size, this.type});

    factory Result.fromJson(Map<String, dynamic> json) {
        return Result(
            id: json['id'], 
            iso_3166_1: json['iso_3166_1'], 
            iso_639_1: json['iso_639_1'], 
            key: json['key'], 
            name: json['name'], 
            site: json['site'], 
            size: json['size'], 
            type: json['type'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['iso_3166_1'] = this.iso_3166_1;
        data['iso_639_1'] = this.iso_639_1;
        data['key'] = this.key;
        data['name'] = this.name;
        data['site'] = this.site;
        data['size'] = this.size;
        data['type'] = this.type;
        return data;
    }
}