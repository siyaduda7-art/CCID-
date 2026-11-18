import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UsefulContactsBar extends StatefulWidget {
  const UsefulContactsBar({super.key});

  @override
  State<UsefulContactsBar> createState() =>
      _UsefulContactsBarState();
}

class _UsefulContactsBarState
    extends State<UsefulContactsBar> {
  bool expanded = false;

  Future<void> call(String number) async {
    await launchUrl(Uri.parse('tel:$number'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF334155),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.support_agent,
              color: Colors.white,
            ),
            title: const Text(
              'Useful Contacts',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(
              expanded
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
              color: Colors.white,
            ),
            onTap: () =>
                setState(() => expanded = !expanded),
          ),
          if (expanded)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  contactButton(
                    'CCID 24-HR Emergency',
                    '082 415 7127',
                    () => call('0824157127'),
                  ),
                  contactButton(
                    'All Emergencies',
                    '112 mobile / 107 landline',
                    () => call('112'),
                  ),
                  contactButton(
                    'SAPS Cape Town Central',
                    '021 467 8001',
                    () => call('0214678001'),
                  ),
                  contactButton(
                    'City Law Enforcement',
                    '021 596 1999',
                    () => call('0215961999'),
                  ),
                  contactButton(
                    'Ambulance',
                    '10177 / 021 480 7700',
                    () => call('10177'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget contactButton(
    String title,
    String number,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(number),
      trailing: const Icon(
        Icons.call,
        color: Color(0xFF16A34A),
      ),
      onTap: onTap,
    );
  }
}