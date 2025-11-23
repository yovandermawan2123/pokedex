import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex_app/controllers/detail_controller.dart';
import 'package:pokedex_app/utils/helper.dart';

class Detail extends StatelessWidget {
  final DetailController controller = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final pokemon = controller.pokemonDetail.value;
        if (pokemon == null) {
          return Center(child: CircularProgressIndicator(color: Colors.green));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      mapPokemonColor(pokemon.color)!,
                      mapPokemonColor(pokemon.color)!.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 40,
                      right: -40,
                      child: Opacity(
                        opacity: 0.15,
                        child: Icon(Icons.catching_pokemon,
                            size: 220, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 16,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: Colors.white, size: 28),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    Positioned(
                      top: 90,
                      left: 20,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pokemon.name.capitalizeFirst!,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "#${pokemon.id.toString().padLeft(3, "0")}",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 140,
                      left: 20,
                      child: Row(
                        children: (pokemon.types ?? []).map((t) {
                          return Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              t.capitalizeFirst!,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Image.network(
                          pokemon.image,
                          height: 180,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: DefaultTabController(
                  length: 4,
                  child: Column(
                    children: [
                      TabBar(
                        indicatorColor: mapPokemonColor(pokemon.color),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: "About"),
                          Tab(text: "Base Stats"),
                          Tab(text: "Evolution"),
                          Tab(text: "Moves"),
                        ],
                      ),
                      SizedBox(
                        height: 400, // PENTING AGAR KONTEN MUNCUL
                        child: TabBarView(
                          children: [
                            aboutTab(pokemon),
                            baseStatsTab(pokemon),
                            Center(child: Text("Evolution Coming Soon")),
                            movesTab(pokemon),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget aboutTab(pokemon) {
    return ListView(
      padding: EdgeInsets.only(top: 20),
      children: [
        infoRow("Height", pokemon.height.toString() + " cm"),
        infoRow("Weight", pokemon.weight.toString() + " kg"),
        infoRow(
          "Abilities",
          pokemon.abilities.map((a) => a.name).join(", "),
        ),
      ],
    );
  }

  Widget baseStatsTab(pokemon) {
    return ListView(
      padding: EdgeInsets.only(top: 20),
      children: pokemon.stats.map<Widget>((s) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              SizedBox(width: 100, child: Text(s.name.toUpperCase())),
              Text("${s.baseStat}  "),
              Expanded(
                child: LinearProgressIndicator(
                  value: s.baseStat / 150,
                  color: Colors.green,
                  backgroundColor: Colors.grey.shade300,
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget movesTab(pokemon) {
    return ListView(
      padding: EdgeInsets.only(top: 20),
      children: pokemon.moves.map<Widget>((m) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text("• ${m.name}"),
        );
      }).toList(),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(label + " : ",
              style: TextStyle(
                  color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
