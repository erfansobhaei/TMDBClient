class CastModel {
    final int id;
    final List<Cast> cast;

    CastModel({this.cast, this.id});

    factory CastModel.fromJson(Map<String, dynamic> json) {
        return CastModel(
            cast: json['cast'] != null ? (json['cast'] as List).map((i) => Cast.fromJson(i)).toList() : null, 
            id: json['id'], 
        );
    }

}

class Cast {
    final int cast_id;
    final String character;
    final String credit_id;
    final int gender;
    final int id;
    final String name;
    final int order;
    final String profile_path;

    Cast({this.cast_id, this.character, this.credit_id, this.gender, this.id, this.name, this.order, this.profile_path});

    factory Cast.fromJson(Map<String, dynamic> json) {
        return Cast(
            cast_id: json['cast_id'],
            character: json['character'],
            credit_id: json['credit_id'],
            gender: json['gender'],
            id: json['id'],
            name: json['name'],
            order: json['order'],
            profile_path: json['profile_path'] != null ? json['profile_path'] : null,
        );
    }

}