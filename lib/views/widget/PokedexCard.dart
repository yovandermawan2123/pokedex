import 'package:flutter/material.dart';

class PokedexCard extends StatelessWidget {
  final String name;
  final List<String>? types;
  final String? imageUrl;
  final int id;
  final Color color;

  const PokedexCard({
    super.key,
    required this.name,
    required this.id,
    required this.color,
    this.types,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // fix height agar card stabil seperti UI asli
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          // ---------------------------------------------------
          // BACKGROUND CIRCLE (lebih besar, lebih lembut)
          // ---------------------------------------------------
          Positioned(
            right: -30,
            bottom: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // ---------------------------------------------------
          // CONTENT
          // ---------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------------------------------------------
                // NAME + ID
                // ---------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "#${id.toString().padLeft(3, '0')}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ---------------------------------------------------
                // TYPES — SELALU VERTICAL (tidak mendorong gambar)
                // ---------------------------------------------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (types ?? [])
                      .map(
                        (t) => Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.28),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            t.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),

          // ---------------------------------------------------
          // IMAGE — posisinya tetap di kanan bawah
          // ---------------------------------------------------
          Positioned(
            right: 4,
            bottom: 4,
            child: SizedBox(
              height: 85,
              width: 85,
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.contain,
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      color: Colors.white,
                      size: 40,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
