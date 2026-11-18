import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/restaurant.dart';

class RestaurantRepository {
  static const String _assetPath =
      'assets/data/restaurants.json';

  Future<List<Restaurant>> loadRestaurants() async {
    final rawJson = await rootBundle.loadString(_assetPath);

    final List<dynamic> decoded =
        jsonDecode(rawJson) as List<dynamic>;

    return decoded
        .map(
          (item) => Restaurant.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}