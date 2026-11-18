import 'package:latlong2/latlong.dart';

enum RestaurantCategory {
  fineDining,
  premiumCasual,
  casualDining,
  african,
}

class Restaurant {
  final int id;
  final String name;
  final String category;
  final String address;
  final bool starred;
  final String? starNote;
  final LatLng? location;

  const Restaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.starred,
    required this.starNote,
    this.location,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final location = json['location'];

    return Restaurant(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      address: json['address'] as String,
      starred: json['starred'] as bool? ?? false,
      starNote: json['starNote'] as String?,
      location: location == null
          ? null
          : LatLng(
              (location['latitude'] as num).toDouble(),
              (location['longitude'] as num).toDouble(),
            ),
    );
  }

  RestaurantCategory get categoryEnum {
    switch (category) {
      case 'Fine Dining':
        return RestaurantCategory.fineDining;
      case 'Premium Casual':
        return RestaurantCategory.premiumCasual;
      case 'Casual Dining':
        return RestaurantCategory.casualDining;
      case 'African':
        return RestaurantCategory.african;
      default:
        return RestaurantCategory.casualDining;
    }
  }

  bool get halaal =>
      starNote?.toLowerCase().contains('halaal') ?? false;

  bool get halaalFriendly =>
      starNote?.toLowerCase().contains('halaal friendly') ?? false;
}