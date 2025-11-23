import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:animations/animations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pokedex_app/controllers/home_controller.dart';
import 'package:pokedex_app/models/pokemonModel.dart';
import 'package:pokedex_app/utils/api_endpoints.dart';
import 'package:pokedex_app/utils/helper.dart';
import 'package:pokedex_app/utils/number_format.dart';
import 'package:pokedex_app/views/widget/PokedexCard.dart';
import 'package:pokedex_app/views/widget/PokedexCardShimmer.dart';

// import 'inputWrapper.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController homeController = Get.put(HomeController());
  final ScrollController _scrollController = ScrollController();

  bool _pinned = false;
  bool _snap = false;
  bool _floating = true;
  int index = 0;

  int _current = 0;
  final CarouselController _controller = CarouselController();

  final List<Map<String, dynamic>> myList = [
    {
      // "Name": "Yovan Dermawan",
      // "Age": 20,
      "text": [
        // "Kegiatan Sosial",
        // "Zakat",
        // "Bencana Alam",
        // "Sekolah",
        // "Rumah Ibadah",
        // "Hewan",
        // "Other",
      ],
      "category": [
        // "images/Assets/category/social.png",
        // "images/Assets/category/volunteer.png",
        // "images/Assets/category/bencana-alam.png",
        // "images/Assets/category/university.png",
        // "images/Assets/category/mosque.png",
        // "images/Assets/category/animals.png",
        // "images/Assets/category/other.png",
      ],
      "colours": [
        Colors.red,
        Colors.blue.shade600,
        Colors.amber.shade600,
        Colors.purple,
      ],
    },
  ];

  final List banners = [
    // "images/Assets/banners/1.png",
    // "images/Assets/banners/2.png",
    // "images/Assets/banners/3.png",
  ];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        homeController.loadMore(); // ⬅️ ini trigger infinite scroll
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;

    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // return GetBuilder<HomeController>(
    //     builder: ((controller) => RefreshIndicator(
    //           onRefresh: () => controller.refreshData(),
    //           child: CustomScrollView(
    //             slivers: <Widget>[
    //               SliverPersistentHeader(
    //                 delegate: CustomSliverAppBarDelegate(
    //                   expandedHeight: 160,
    //                 ),
    //               ),
    //               const SliverToBoxAdapter(
    //                 child: SizedBox(
    //                   height: 40,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         )));
    return Scaffold(
      backgroundColor: Colors.white,

      // color: Colors.grey.shade100,
      body: RefreshIndicator(
        onRefresh: () => homeController.refreshData(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              expandedHeight: 80,
              flexibleSpace: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 12),
                  child: Text(
                    "Pokedex",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            Obx(() {
              if (homeController.pokemonList.isEmpty &&
                  homeController.isLoading.value) {
                // ⬅️ shimmer full HANYA saat load awal
                return _shimmerGrid();
              } else {
                // ⬅️ tampilkan grid + shimmer bawah jika loadMore
                return _getSlivers(homeController);
              }
            })
          ],
        ),
      ),
    );
  }
}

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  const CustomSliverAppBarDelegate({
    required this.expandedHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = 60;
    final box = GetStorage();

    final top = expandedHeight - shrinkOffset - size / 2;
    final name = 'Fuss';
    // final ProductController productController = Get.put(ProductController());
    // final name = (productController.memberModel.value?.body[0].name == null)
    //     ? ""
    //     : productController.memberModel.value?.body[0].name;
    // final points = (productController.memberModel.value?.body[0].points == null)
    //     ? 0
    //     : int.parse(productController.memberModel.value!.body[0].points);
    // final holdpoints =
    //     (productController.memberModel.value?.body[0].hold_points == null)
    //         ? 0
    //         : productController.memberModel.value?.body[0].hold_points;
    // final pointAccount = (points - holdpoints!);
    // final kurs_today = (productController.kursModel.value?.body[0].kurs == null)
    //     ? 0
    //     : productController.kursModel.value?.body[0].kurs;

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        buildBackground(shrinkOffset, name),
        // buildBackground(shrinkOffset, name, kurs_today),
        buildAppBar(shrinkOffset),
        Positioned(
          top: top,
          left: 20,
          right: 20,
          child: buildFloating(shrinkOffset),
          // child: buildFloating(shrinkOffset, (pointAccount).toString()),
        ),
      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildAppBar(double shrinkOffset) => Opacity(
        opacity: appear(shrinkOffset),
        child: AppBar(
          // title: Text('Flutter'),
          centerTitle: false,
          backgroundColor: Colors.green,
        ),
      );

  Widget buildBackground(double shrinkOffset, String name) => Container(
        child: Opacity(
            opacity: disappear(shrinkOffset),
            child: AppBar(
              automaticallyImplyLeading: false,
              // title: Container(
              //     margin: EdgeInsets.only(top: 30),
              //     // padding: EdgeInsets.all(10),
              //     child: Column(
              //       children: [Text('Hai, Yovan D'), Text('Hai, Yovan D')],
              //     )),
              // centerTitle: false,
              flexibleSpace: Container(
                  child: Container(
                    // padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SafeArea(
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 15,
                              left: 20,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   'Good Evening',
                                  //   style: TextStyle(
                                  //       fontSize: 20, color: Colors.white),
                                  // ),
                                  Text(
                                    'Hai, User',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            // top: 40,
                            right: 20,
                          ),
                          child: Icon(Icons.favorite, color: Colors.white),
                        )
                        // Stack(
                        //   alignment: AlignmentDirectional.topCenter,
                        //   children: [Text('Hey')],
                        // )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    // borderRadius: BorderRadius.only(
                    //     bottomLeft: Radius.circular(20),
                    //     bottomRight: Radius.circular(20))
                  )),
              backgroundColor: Colors.transparent,
              bottomOpacity: 0.0,
              elevation: 0.0,
            )),
      );

  Widget buildFloating(double shrinkOffset) => Opacity(
        // Widget buildFloating(double shrinkOffset, String? pointAccount) => Opacity(
        opacity: disappear(shrinkOffset),
        child: Card(
          elevation: 0,
          child: Row(
            children: [
              Expanded(child: buildButton()),
              // Expanded(child: buildButton(pointAccount)),
            ],
          ),
        ),
      );

  Widget buildButton() => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(
            //   style: BorderStyle.solid,
            //   color: Colors.black45,
            // ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.all(Radius.elliptical(5, 5))),
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon(icon),
            // const SizedBox(width: 12),

            // Image(
            //   image: AssetImage('images/Aset/icon/points.png'),
            //   height: 30,
            // ),
            Row(
              children: [
                Icon(Icons.account_balance_wallet),
                Text("  10.000", style: TextStyle(fontSize: 16)),
              ],
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Text("Isi",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),

            // Text(formatAmount((pointAccount).toString()),
            //     style: TextStyle(
            //         fontSize: 24,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.red.shade800)),
          ],
        ),
      );

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

Widget _getSlivers(HomeController homeController) {
  final addShimmer =
      homeController.isLoading.value && homeController.pokemonList.isNotEmpty;

  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Jika index masih dalam list Pokémon → tampil kartu biasa
          if (index < homeController.pokemonList.length) {
            final pokemon = homeController.pokemonList[index];

            return GestureDetector(
              onTap: () {
                homeController
                    .getDetail((homeController.pokemonList[index].id));
              },
              child: PokedexCard(
                name: pokemon.name.capitalizeFirst!,
                id: pokemon.id,
                color: mapPokemonColor(pokemon.color),
                imageUrl: pokemon.image,
                types: pokemon.types,
              ),
            );
          }

          // Jika index sudah lewat list → tampil shimmer bawah
          return const PokedexCardShimmer();
        },
        childCount: homeController.pokemonList.length + (addShimmer ? 2 : 0),
      ),
    ),
  );
}

Widget _shimmerGrid() {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => const PokedexCardShimmer(),
        childCount: 10, // jumlah skeleton card
      ),
    ),
  );
}
