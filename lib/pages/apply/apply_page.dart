import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/pages/home/job_search_page.dart';
import 'package:hirewise/pages/home/widget/job_card.dart';
import 'package:hirewise/pages/home/widget/job_card_skelaton.dart';
import 'package:hirewise/provider/job_provider.dart';
import 'package:provider/provider.dart';

class ApplyPage extends StatefulWidget {
  const ApplyPage({super.key});

  @override
  State<ApplyPage> createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _initialFetch();
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
    final jobProvider = Provider.of<JobProvider>(context, listen: false);

    try {
      if (isRefresh || jobProvider.appliedJobs.isEmpty) {
        await jobProvider.getAppliedJobs(context);
      }
    } catch (e) {
      _showError("Something went wrong while fetching applied jobs");
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
                  "You haven't applied to any jobs yet",
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
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Applied Jobs",
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
                  builder: (context) => JobSearchPage(),
                ),
              );
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Consumer<JobProvider>(
        builder: (context, jobProvider, _) {
          Widget content;

          if (jobProvider.isLoading) {
            content = ListView.builder(
              itemCount: 5,
              itemBuilder: (_, __) => const JobCardSkeleton(),
            );
          } else if (jobProvider.appliedJobs.isEmpty) {
            content = _buildEmptyState();
          } else {
            content = ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: jobProvider.appliedJobs.length,
              itemBuilder: (context, index) => JobCard(
                job: jobProvider.appliedJobs[index],
                applied: true,
                page: 4,
              ),
            );
          }
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            color: customBlue,
            onRefresh: () => fetch(true),
            child: content,
          );
        },
      ),
    );
  }
}
