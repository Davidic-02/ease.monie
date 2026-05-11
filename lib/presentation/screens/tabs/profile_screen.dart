import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _openProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _openProfile(context),
          child: const Text('Open Profile Screen'),
        ),
      ),
    );
  }
}

/// FULL SCREEN PAGE (replaces bottom sheet)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const ProfileBottomSheet(),
    );
  }
}

/// YOUR ORIGINAL UI (UNCHANGED)
class ProfileBottomSheet extends StatelessWidget {
  const ProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle bar (you can remove later if you want, but unchanged as requested)
        Container(
          margin: const EdgeInsets.only(top: 60, bottom: 8),
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        const SizedBox(height: 8),

        _SheetMenuItem(
          icon: Icons.person_outline_rounded,
          label: 'Manage Profile',
          isActive: true,
          onTap: () {},
        ),

        const _SheetDivider(),

        _SheetMenuItem(
          icon: Icons.chat_bubble_outline_rounded,
          label: 'Submit Complaints',
          onTap: () {},
        ),

        const _SheetDivider(),

        _SheetMenuItem(
          icon: Icons.phone_outlined,
          label: 'Contact',
          onTap: () {},
        ),

        const _SheetDivider(),

        _SheetMenuItem(
          icon: Icons.settings_outlined,
          label: 'Settings',
          onTap: () {},
        ),

        const _SheetDivider(),

        _SheetMenuItem(
          icon: Icons.logout_rounded,
          label: 'Log Out',
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class _SheetMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SheetMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF2563EB) : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.2)
                        : const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: isActive ? Colors.white : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isActive ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: isActive
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetDivider extends StatelessWidget {
  const _SheetDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
      color: Colors.grey[200],
    );
  }
}
