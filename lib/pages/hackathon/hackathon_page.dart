import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/hackathon_model.dart';
import 'package:hirewise/pages/hackathon/hackathon_search_page.dart';
import 'package:hirewise/pages/hackathon/widget/hackathon_card.dart';
import 'package:hirewise/pages/home/widget/job_card_skelaton.dart';
import 'package:hirewise/provider/hackathon_provider.dart';
import 'package:provider/provider.dart';

class HackathonPage extends StatefulWidget {
  const HackathonPage({super.key});

  @override
  State<HackathonPage> createState() => _HackathonPageState();
}

class _HackathonPageState extends State<HackathonPage> {
  final ScrollController _hackathonController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _hackathonRefreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _initialFetch();
  }

  @override
  void dispose() {
    _hackathonController.dispose();
    super.dispose();
  }

  Future<void> _initialFetch() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    try {
      await fetch(false);
    } catch (e) {
      if (!mounted) return;
      _showError("Failed to load initial data");
    }
  }

  Future<void> fetch(bool isRefresh) async {
    if (mounted) {
      final hackathonProvider =
          Provider.of<HackathonProvider>(context, listen: false);

      try {
        if (isRefresh || hackathonProvider.hackathon.isEmpty) {
          print("fetch");
          await hackathonProvider.getHackathon(context);
        }
      } catch (e) {
        _showError("Something went wrong while fetching jobs");
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () => fetch(true),
        ),
      ),
    );
  }

  Widget _buildHackathonList(List<Hackathon> hackathon) {
    if (hackathon.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/error.png",
              height: 100,
              width: 100,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.work_off_outlined,
                size: 100,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No Hacakathon Found",
              textAlign: TextAlign.center,
              style: AppStyles.mondaB.copyWith(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: customBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(200, 45),
              ),
              onPressed: () => fetch(true),
              child: Text(
                "Refresh",
                style: AppStyles.mondaB.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      key: _hackathonRefreshKey,
      color: customBlue,
      onRefresh: () => fetch(true),
      child: ListView.builder(
        controller: _hackathonController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: hackathon.length,
        itemBuilder: (context, index) =>
            HackathonCard(hackathon: hackathon[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Hackathon",
          style: AppStyles.mondaB.copyWith(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: customBlue, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HackathonSearchPage(),
                ),
              );
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Consumer<HackathonProvider>(
        builder: (context, hackathonProvider, _) {
          if (hackathonProvider.isLoading) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (_, __) => const JobCardSkeleton(),
            );
          }
          return _buildHackathonList(hackathonProvider.hackathon);
        },
      ),
    );
  }
}
