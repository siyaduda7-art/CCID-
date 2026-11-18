import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/restaurant_repository.dart';
import '../models/restaurant.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/useful_contacts_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String selectedFilter = 'All';
  String searchQuery = '';

  final MapController mapController = MapController();
  final RestaurantRepository repository = RestaurantRepository();

  List<Restaurant> allRestaurants = [];
  bool isLoading = true;
  String? errorMessage;

  static const LatLng capeTownCbd = LatLng(-33.9249, 18.4241);

  @override
  void initState() {
    super.initState();
    loadRestaurants();
  }

  Future<void> loadRestaurants() async {
    try {
      final loaded = await repository.loadRestaurants();

      setState(() {
        allRestaurants = loaded;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Could not load restaurant data.';
        isLoading = false;
      });
    }
  }

  Color categoryColor(RestaurantCategory category) {
    switch (category) {
      case RestaurantCategory.fineDining:
        return const Color(0xFF1B3668);
      case RestaurantCategory.premiumCasual:
        return const Color(0xFF2B6CB0);
      case RestaurantCategory.casualDining:
        return const Color(0xFF38BDF8);
      case RestaurantCategory.african:
        return const Color(0xFFD99B26);
    }
  }

  Color categoryTextColor(RestaurantCategory category) {
    if (category == RestaurantCategory.casualDining ||
        category == RestaurantCategory.african) {
      return const Color(0xFF0F172A);
    }
    return Colors.white;
  }

  bool matchesFilter(Restaurant restaurant) {
    if (selectedFilter == 'All') return true;

    if (selectedFilter == 'Halaal / Halaal Friendly') {
      return restaurant.halaal || restaurant.halaalFriendly;
    }

    return restaurant.category == selectedFilter;
  }

  bool matchesSearch(Restaurant restaurant) {
    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) return true;

    return restaurant.name.toLowerCase().contains(query) ||
        restaurant.address.toLowerCase().contains(query) ||
        restaurant.id.toString().contains(query);
  }

  List<Restaurant> get visibleRestaurants {
    return allRestaurants
        .where(matchesFilter)
        .where(matchesSearch)
        .where((restaurant) => restaurant.location != null)
        .toList();
  }

  Future<void> openDirections(Restaurant restaurant) async {
    if (restaurant.location == null) return;

    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination='
      '${restaurant.location!.latitude},'
      '${restaurant.location!.longitude}',
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  void showRestaurantCard(Restaurant restaurant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return RestaurantCard(
          restaurant: restaurant,
          pinColor: categoryColor(restaurant.categoryEnum),
          pinTextColor:
              categoryTextColor(restaurant.categoryEnum),
          onGetDirections: () => openDirections(restaurant),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8EEF8),
      appBar: AppBar(
        title: const Text('Cape Town CBD Eateries'),
      ),
      body: Column(
        children: [
          buildFilters(),
          buildSearchBar(),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(errorMessage!),
                        ),
                      )
                    : buildMap(),
          ),
          const UsefulContactsBar(),
        ],
      ),
    );
  }

  Widget buildFilters() {
    final filters = [
      'All',
      'Fine Dining',
      'Premium Casual',
      'Casual Dining',
      'African',
      'Halaal / Halaal Friendly',
    ];

    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          Color color = Colors.white;
          Color textColor = const Color(0xFF0F172A);

          if (filter == 'Fine Dining') {
            color = const Color(0xFF1B3668);
          }
          if (filter == 'Premium Casual') {
            color = const Color(0xFF2B6CB0);
          }
          if (filter == 'Casual Dining') {
            color = const Color(0xFF38BDF8);
          }
          if (filter == 'African') {
            color = const Color(0xFFD99B26);
          }
          if (filter == 'Halaal / Halaal Friendly') {
            color = const Color(0xFF16A34A);
            textColor = Colors.white;
          }

          if (isSelected) textColor = Colors.white;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              selectedColor: color,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(color: textColor),
              onSelected: (_) {
                setState(() => selectedFilter = filter);
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        onChanged: (value) =>
            setState(() => searchQuery = value),
        decoration: const InputDecoration(
          hintText:
              'Search restaurant, street, or pin number',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget buildMap() {
    return FlutterMap(
      mapController: mapController,
      options: const MapOptions(
        initialCenter: capeTownCbd,
        initialZoom: 15.2,
        minZoom: 13,
        maxZoom: 18,
        interactionOptions: InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'za.co.ccidconnect.app',
        ),
        MarkerLayer(
          markers: visibleRestaurants.map((restaurant) {
            final color =
                categoryColor(restaurant.categoryEnum);
            final textColor =
                categoryTextColor(restaurant.categoryEnum);

            return Marker(
              point: restaurant.location!,
              width: 38,
              height: 38,
              child: GestureDetector(
                onTap: () =>
                    showRestaurantCard(restaurant),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    restaurant.id
                        .toString()
                        .padLeft(2, '0'),
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}