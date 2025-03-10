import 'package:flutter/material.dart';
import 'package:hirewise/pages/hackathon/widget/hackathon_card.dart';
import 'package:hirewise/provider/hackathon_provider.dart';
import 'package:provider/provider.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/pages/home/widget/job_card_skelaton.dart';

class HackathonSearchResultsPage extends StatefulWidget {
  final String? query;

  const HackathonSearchResultsPage({
    super.key,
    this.query,
  });

  @override
  State<HackathonSearchResultsPage> createState() =>
      _HackathonSearchResultsPageState();
}

class _HackathonSearchResultsPageState
    extends State<HackathonSearchResultsPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
    final hackathonProvider =
        Provider.of<HackathonProvider>(context, listen: false);

    try {
      if (isRefresh || hackathonProvider.searchedHackathon.isEmpty) {
        await hackathonProvider.searchHackathon(
          context,
          query: widget.query,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showError("Something went wrong while fetching hackathons");
      rethrow;
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

  Widget _buildEmptyState() {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      slivers: [
        SliverFillRemaining(
          child: Center(
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
                  'No jobs found matching your criteria',
                  style: AppStyles.mondaB.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Try adjusting your search filters',
                  style: AppStyles.mondaN.copyWith(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        'Modify Search',
                        style: AppStyles.mondaB.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => fetch(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        'Refresh',
                        style: AppStyles.mondaB.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Search Results',
          style: AppStyles.mondaB.copyWith(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<HackathonProvider>(
        builder: (context, hackathonProvider, _) {
          Widget content;

          if (hackathonProvider.isLoading) {
            content = ListView.builder(
              itemCount: 5,
              itemBuilder: (_, __) => const JobCardSkeleton(),
            );
          } else if (hackathonProvider.searchedHackathon.isEmpty) {
            content = _buildEmptyState();
          } else {
            content = ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: hackathonProvider.searchedHackathon.length,
              itemBuilder: (context, index) {
                return HackathonCard(
                  hackathon: hackathonProvider.searchedHackathon[index],
                );
              },
            );
          }

          return RefreshIndicator(
              key: _refreshIndicatorKey,
              color: customBlue,
              onRefresh: () => fetch(true),
              child: content);
        },
      ),
    );
  }
}
