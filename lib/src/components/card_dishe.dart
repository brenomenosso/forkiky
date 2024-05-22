import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardDishe extends StatefulWidget {

  final String publisher;
  final String title;
  final String sourceUrl;
  final String recipeId;
  final String imageUrl;
  final bool isFavorite;

  const CardDishe({super.key, 
    required this.publisher,
    required this.title,
    required this.sourceUrl,
    required this.recipeId,
    required this.imageUrl,
    this.isFavorite = false,
  });

  @override
  State<CardDishe> createState() => _CardDisheState();
}

class _CardDisheState extends State<CardDishe> {
  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade200,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(imageUrl: widget.imageUrl, fit: BoxFit.cover, width: double.infinity, height: 200),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: sizeOf.width - 100,
                      child: Text('Nome do prato: ${widget.title}', style: const TextStyle(fontSize: 18, overflow: TextOverflow.ellipsis))),
                    Text(widget.publisher, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
                Icon(Icons.favorite_border, color: !widget.isFavorite ? Colors.white : Colors.red, size: 30,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}