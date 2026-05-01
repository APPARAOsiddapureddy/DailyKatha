import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../theme/app_colors.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ref.read(adminServiceProvider).getDashboard();
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = (_data?['stats'] as Map?)?.cast<String, dynamic>() ?? const {};
    final totalUsers = (stats['totalUsers'] ?? 0).toString();
    final totalCards = (stats['totalCards'] ?? 0).toString();

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Admin Dashboard', style: TextStyle(color: AppColors.accentGold)),
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh, color: AppColors.accentGold),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accentGold))
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      children: [
                        _StatCard(label: 'Total Users', value: totalUsers, icon: Icons.people),
                        const SizedBox(width: 12),
                        _StatCard(label: 'Total Cards', value: totalCards, icon: Icons.credit_card),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text('Quick Actions', style: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _ActionButton(
                          label: "Generate Today's 5",
                          icon: Icons.auto_awesome,
                          onTap: () async {
                            try {
                              await ref.read(adminServiceProvider).generateTodaysPicks();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Today's 5 generation triggered")),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                        ),
                        _ActionButton(
                          label: 'Generate Cards',
                          icon: Icons.add_card,
                          onTap: () => context.go('/admin/generate'),
                        ),
                        _ActionButton(
                          label: "Today's 5 (preview)",
                          icon: Icons.today,
                          onTap: () => context.go('/today-picks'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Text('Top Cards', style: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    for (final c in ((_data?['topCards'] as List?) ?? const []))
                      _TopCardTile(card: (c as Map).cast<String, dynamic>()),
                  ],
                ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.accentGold,
        unselectedItemColor: AppColors.textTertiaryDark,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'Generate'),
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "Today's 5"),
        ],
        onTap: (idx) {
          if (idx == 0) context.go('/admin/dashboard');
          if (idx == 1) context.go('/admin/generate');
          if (idx == 2) context.go('/today-picks');
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderOnDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.accentGold, size: 22),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: AppColors.accentGold, fontSize: 26, fontWeight: FontWeight.w900)),
            Text(label, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.accentGold.withAlpha((0.12 * 255).round()),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.accentGold.withAlpha((0.28 * 255).round())),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.accentGold, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: AppColors.accentGold, fontWeight: FontWeight.w700, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _TopCardTile extends StatelessWidget {
  const _TopCardTile({required this.card});

  final Map<String, dynamic> card;

  @override
  Widget build(BuildContext context) {
    final quote = (card['quote_te'] as String? ?? '').replaceAll('\n', ' ');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderOnDark),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withAlpha((0.12 * 255).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(card['category']?.toString() ?? '', style: const TextStyle(color: AppColors.accentGold, fontSize: 11)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              quote,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textSecondaryDark),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.favorite, color: Color(0xFFD4607C), size: 14),
          const SizedBox(width: 4),
          Text('${card['like_count'] ?? 0}', style: const TextStyle(color: AppColors.textTertiaryDark)),
        ],
      ),
    );
  }
}

