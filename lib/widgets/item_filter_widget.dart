import 'package:codigo6_movieapp/ui/general/colors.dart';
import 'package:flutter/material.dart';

class ItemFilterWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const ItemFilterWidget({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                color: isSelected ? Colors.white : Colors.white38,
                fontWeight: FontWeight.w500,
              ),
            ),
            isSelected
                ? Container(
                    width: 15,
                    height: 3.5,
                    decoration: BoxDecoration(
                      color: kBrandSecondaryColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
