import 'package:dog_app/configs/app_colors.dart';
import 'package:dog_app/models/breed_entity.dart';
import 'package:flutter/material.dart';

class BreedWidget extends StatelessWidget {
  const BreedWidget({
    Key? key,
    required this.breed,
    required this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  final BreedEntity breed;

  final Function() onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? AppColors.primary : AppColors.secondary,
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(right: 10),
          child: Text(
            breed.name,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
