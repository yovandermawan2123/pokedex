import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokedex_app/models/pokemonModel.dart';
import 'package:pokedex_app/utils/api_endpoints.dart';

class HomeController extends GetxController {
  final pokemonList = <PokemonModel>[].obs;
  RxBool isLoading = false.obs;

  final box = GetStorage();
  var tabIndex = 0;

  int offset = 0; // === dipakai untuk infinite scroll

  @override
  void onInit() async {
    super.onInit();
    await FetchPokemons();
  }

  refreshData() async {
    offset = 0; // reset offset SAAT REFRESH
    pokemonList.clear(); // hapus list lama
    await FetchPokemons();
    print('refreshed!');
  }

  // =========================
  // FETCH AWAL (offset = 0)
  // =========================
  FetchPokemons() async {
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(ApiEndPoints.baseUrl + 'pokemon?limit=10&offset=0'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'];

        final List<PokemonModel> tempList = [];

        for (var item in results) {
          var pokemon = PokemonModel.fromListJson(item);

          // species
          final speciesResponse = await http.get(
            Uri.parse(
                'https://pokeapi.co/api/v2/pokemon-species/${pokemon.id}'),
          );
          if (speciesResponse.statusCode == 200) {
            final speciesJson = jsonDecode(speciesResponse.body);
            pokemon = pokemon.copyWithSpecies(speciesJson);
          }

          // details
          final detailsResponse = await http.get(
            Uri.parse('https://pokeapi.co/api/v2/pokemon/${pokemon.id}'),
          );
          if (detailsResponse.statusCode == 200) {
            final detailsJson = jsonDecode(detailsResponse.body);
            pokemon = pokemon.copyWithDetails(detailsJson);
          }

          tempList.add(pokemon);
        }

        pokemonList.assignAll(tempList);

        offset = 10; // setelah fetch pertama, offset mulai dari 20
      } else {
        print('Error fetching data');
      }
    } catch (e) {
      print('Error while getting data: $e');
    }

    isLoading.value = false;
  }

  // =========================
  // LOAD MORE
  // =========================
  loadMore() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(ApiEndPoints.baseUrl + 'pokemon?limit=20&offset=$offset'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'];

        for (var item in results) {
          var pokemon = PokemonModel.fromListJson(item);

          // species
          final speciesResponse = await http.get(
            Uri.parse(
                'https://pokeapi.co/api/v2/pokemon-species/${pokemon.id}'),
          );
          if (speciesResponse.statusCode == 200) {
            final speciesJson = jsonDecode(speciesResponse.body);
            pokemon = pokemon.copyWithSpecies(speciesJson);
          }

          // details
          final detailsResponse = await http.get(
            Uri.parse('https://pokeapi.co/api/v2/pokemon/${pokemon.id}'),
          );
          if (detailsResponse.statusCode == 200) {
            final detailsJson = jsonDecode(detailsResponse.body);
            pokemon = pokemon.copyWithDetails(detailsJson);
          }

          pokemonList.add(pokemon);
        }

        offset += 10; // lanjut ke batch berikutnya
        print("Loaded more Pokémon: total = ${pokemonList.length}");
      }
    } catch (e) {
      print('Load more error: $e');
    }

    isLoading.value = false;
  }

  void getDetail(int id) {
    Get.toNamed('/detail', arguments: id);
  }
}
