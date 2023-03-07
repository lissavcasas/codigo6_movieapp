import 'package:codigo6_movieapp/models/character_model.dart';
import 'package:codigo6_movieapp/utils/constants.dart';
import 'package:flutter/material.dart';

class ItemCastWidget extends StatelessWidget {
  final CharacterModel model;

  const ItemCastWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 14.0),
      constraints: const BoxConstraints(
        maxWidth: 110.0,
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white10,
            backgroundImage: model.profilePath.isNotEmpty
                ? NetworkImage(apiImageUrl + model.profilePath)
                : const NetworkImage(
                    "https://st4.depositphotos.com/4329009/19956/v/450/depositphotos_199564354-stock-illustration-creative-vector-illustration-of-default.jpg"),
            radius: 44.0,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            model.originalName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
