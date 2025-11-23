import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokedex_app/models/pokemonDetailModel.dart';
import 'package:pokedex_app/utils/api_endpoints.dart';

class DetailController extends GetxController {
  Rx<PokemonDetail?> pokemonDetail = Rx<PokemonDetail?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    int id = Get.arguments; // aman, selalu string
    FetchSinglePokemon(id);
  }

  FetchSinglePokemon(int id) async {
    isLoading.value = true;

    try {
      print("Fetching detail for ID: $id");

      // FETCH DATA DETAIL POKEMON
      final response = await http.get(
        Uri.parse("${ApiEndPoints.baseUrl}pokemon/$id"),
      );

      print("URL HIT: ${ApiEndPoints.baseUrl}pokemon/$id");
      print("Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // ============================
        // FETCH COLOR DARI SPECIES API
        // ============================
        String? color;
        try {
          final speciesRes = await http.get(
            Uri.parse("${ApiEndPoints.baseUrl}pokemon-species/$id"),
          );

          if (speciesRes.statusCode == 200) {
            final speciesJson = jsonDecode(speciesRes.body);
            color = speciesJson['color']?['name'];
          } else {
            print("Gagal mengambil species/color");
          }
        } catch (e) {
          print("Gagal fetch color: $e");
        }

        // MASUKKAN COLOR KE MODEL
        pokemonDetail.value = PokemonDetail.fromJson(
          jsonData,
          color: color,
        );

        print("=== DETAIL LOADED SUCCESS ===");
        print("ID: ${pokemonDetail.value!.id}");
        print("Name: ${pokemonDetail.value!.name}");
        print("Image: ${pokemonDetail.value!.image}");
        print("Types: ${pokemonDetail.value!.types}");
        print("Height: ${pokemonDetail.value!.height}");
        print("Weight: ${pokemonDetail.value!.weight}");
        print(
            "Stats: ${pokemonDetail.value!.stats.map((e) => "${e.name}:${e.baseStat}").toList()}");
        print(
            "Abilities: ${pokemonDetail.value!.abilities.map((e) => e.name).toList()}");
        print("Color: ${pokemonDetail.value!.color}");
      } else {
        print("ERROR FETCH DETAIL: ${response.body}");
      }
    } catch (e) {
      print("FETCH ERROR: $e");
    }

    isLoading.value = false;
  }
}
