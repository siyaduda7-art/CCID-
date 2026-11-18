import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../theme/ccid_theme.dart';
import 'map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CCID Connect'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  AppConfig.logoAsset,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to Cape Town CBD',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CcidColors.darkGreen,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find places, stay safe, report issues, and explore the Cape Town Central City.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              homeButton(
                context,
                icon: Icons.map,
                title: 'CBD Map',
                subtitle:
                    'Restaurants, hotels, landmarks and directions',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MapScreen(),
                    ),
                  );
                },
              ),
              homeButton(
                context,
                icon: Icons.shield,
                title: 'Safety & Alerts',
                subtitle:
                    'CCID safety information and emergency contacts',
                onTap: () {},
              ),
              homeButton(
                context,
                icon: Icons.report,
                title: 'Report an Issue',
                subtitle:
                    'Illegal dumping, safety concerns and incidents',
                onTap: () {},
              ),
              homeButton(
                context,
                icon: Icons.badge,
                title: 'Verify CCID Officer',
                subtitle:
                    'Recognise official CCID Public Safety Officers',
                onTap: () {},
              ),
              homeButton(
                context,
                icon: Icons.qr_code,
                title: 'Share App',
                subtitle: 'Share the app using a QR code',
                onTap: () {},
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CcidColors.darkGreen,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  children: [
                    Text(
                      'CCID 24-Hour Emergency',
                      style: TextStyle(
                        color: CcidColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '082 415 7127',
                      style: TextStyle(
                        color: CcidColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget homeButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: CcidColors.lime,
          child: Icon(icon, color: CcidColors.darkGreen),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}