import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              title: Text(
                "Settings", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.black, letterSpacing: -0.5)
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildProfileCard(),
                  const SizedBox(height: 48),
                  _buildSectionHeader("PLAYBACK"),
                  _buildSettingsGroup([
                    _buildSwitchTile("High Quality Audio", "Uses more data", true),
                    _buildSwitchTile("Autoplay", "Continue playing similar music", true),
                    _buildSwitchTile("Crossfade", "Blend songs together", false),
                    _buildChevronTile("Equalizer", "Custom EQ settings"),
                  ]),
                  const SizedBox(height: 48),
                  _buildSectionHeader("DOWNLOADS"),
                  _buildSettingsGroup([
                    _buildChevronTile("Download Quality", "High (256 kbps)"),
                    _buildChevronTile("Storage Used", "2.4 GB of 16 GB", trailing: "2.4 GB"),
                  ]),
                  const SizedBox(height: 48),
                  _buildSectionHeader("NOTIFICATIONS"),
                  _buildSettingsGroup([
                    _buildSwitchTile("New Music Alerts", null, true),
                  ]),
                  const SizedBox(height: 48),
                  _buildSectionHeader("ACCOUNT"),
                  _buildSettingsGroup([
                    _buildChevronTile("Manage Subscription", null),
                    _buildChevronTile("Payment Method", null),
                    _buildChevronTile("Privacy Policy", null),
                    _buildChevronTile("Terms of Use", null),
                  ]),
                  const SizedBox(height: 48),
                  _buildSignOutButton(),
                  const SizedBox(height: 32),
                  const Center(
                    child: Text(
                      "TuneWave v3.1.4", 
                      style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)
                    )
                  ),
                  const SizedBox(height: 140),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white12, width: 2),
            ),
            child: const CircleAvatar(
              radius: 36,
              backgroundColor: Color(0xFF2196F3),
              child: Text("R", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Raj", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const Text("raj@example.com", style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    "PREMIUM", 
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11, 
          fontWeight: FontWeight.w800, 
          color: Colors.grey.shade500, 
          letterSpacing: 1.5
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.08), width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          return Column(
            children: [
              children[index],
              if (index != children.length - 1)
                Divider(height: 1, indent: 24, endIndent: 24, color: Colors.black.withOpacity(0.04)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String? subtitle, bool value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)) : null,
      trailing: CupertinoSwitch(
        value: value,
        activeColor: const Color(0xFF2196F3),
        onChanged: (v) {},
      ),
    );
  }

  Widget _buildChevronTile(String title, String? subtitle, {String? trailing}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) 
            Text(trailing, style: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 22),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          "Sign Out",
          style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.w800, fontSize: 17),
        ),
      ),
    );
  }
}
