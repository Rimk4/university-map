import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            subtitle: Text('Student'),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Live Alerts'),
            subtitle: const Text('Receive campus notifications'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('PM2.5 Monitoring'),
            subtitle: const Text('Air quality alerts'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('Activity Tracking'),
            subtitle: const Text('Track walks and calories'),
            value: true,
            onChanged: (value) {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Map Preferences'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notification Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About App'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Bangkok University Campus',
                applicationVersion: '1.0.0',
                children: [
                  const Text('Campus navigation and services app'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
