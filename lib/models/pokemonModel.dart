class PokemonModel {
  final int id;
  final String name;
  final String? url; // untuk list
  final String? image; // front_default atau sprite URL
  final List<String>? types; // detail only
  final int? height;
  final int? weight;
  final String? color; // dari species endpoint

  PokemonModel({
    required this.id,
    required this.name,
    this.url,
    this.image,
    this.types,
    this.height,
    this.weight,
    this.color,
  });

  /// Dari LIST endpoint
  factory PokemonModel.fromListJson(Map<String, dynamic> json) {
    final url = json['url'];
    final id = _extractId(url);

    return PokemonModel(
      id: id,
      name: json['name'],
      url: url,
      image:
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png",
    );
  }

  /// Dari DETAIL endpoint
  factory PokemonModel.fromDetailJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'],
      name: json['name'],
      image: json['sprites']['front_default'],
      height: json['height'],
      weight: json['weight'],
      types: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
    );
  }

  /// Dari SPECIES endpoint (untuk warna)
  PokemonModel copyWithSpecies(Map<String, dynamic> speciesJson) {
    return PokemonModel(
      id: id,
      name: name,
      url: url,
      image: image,
      types: types,
      height: height,
      weight: weight,
      color: speciesJson['color'] != null ? speciesJson['color']['name'] : null,
    );
  }

  PokemonModel copyWithDetails(Map<String, dynamic> json) {
    return PokemonModel(
      id: id,
      name: name,
      color: color,
      image: json['sprites']['other']['official-artwork']['front_default'],
      types: (json['types'] as List)
          .map((t) => t['type']['name'].toString())
          .toList(),
    );
  }

  /// Helper untuk extract ID dari URL list
  static int _extractId(String url) {
    final parts = url.split('/');
    return int.parse(parts[parts.length - 2]);
  }
}
