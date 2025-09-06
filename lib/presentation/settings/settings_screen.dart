import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    context.go(Routes.login); // replace stack with login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          const ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/user.png"), // placeholder
            ),
            title: Text("Mr. John Doe"),
            subtitle: Text("Welcome"),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("User Profile"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: navigate to profile screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change Password"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: navigate to change password screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("FAQs"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: navigate to FAQ screen
            },
          ),

          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text("Push Notification"),
            value: true,
            onChanged: (value) {
              // handle toggle
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
