class PokemonDetail {
  final int id;
  final String name;
  final String image;
  final List<String> types;
  final int height;
  final int weight;
  final List<PokemonStat> stats;
  final List<PokemonAbility> abilities;
  final List<PokemonMove> moves;
  final String? color; // ← hanya ditambah ini

  PokemonDetail({
    required this.id,
    required this.name,
    required this.image,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
    required this.abilities,
    required this.moves,
    this.color,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json, {String? color}) {
    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      image: json['sprites']['other']['official-artwork']['front_default'],
      types: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
      height: json['height'],
      weight: json['weight'],
      stats:
          (json['stats'] as List).map((s) => PokemonStat.fromJson(s)).toList(),
      abilities: (json['abilities'] as List)
          .map((a) => PokemonAbility.fromJson(a))
          .toList(),
      moves:
          (json['moves'] as List).map((m) => PokemonMove.fromJson(m)).toList(),
      color: color, // ← masukin warna ke sini
    );
  }
}

class PokemonStat {
  final String name;
  final int baseStat;

  PokemonStat({
    required this.name,
    required this.baseStat,
  });

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      name: json['stat']['name'],
      baseStat: json['base_stat'],
    );
  }
}

class PokemonAbility {
  final String name;

  PokemonAbility({required this.name});

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(
      name: json['ability']['name'],
    );
  }
}

class PokemonMove {
  final String name;

  PokemonMove({required this.name});

  factory PokemonMove.fromJson(Map<String, dynamic> json) {
    return PokemonMove(
      name: json['move']['name'],
    );
  }
}
