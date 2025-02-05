import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/job_model.dart';
import 'package:hirewise/pages/home/job_search_page.dart';
import 'package:hirewise/pages/home/widget/job_card.dart';
import 'package:hirewise/pages/home/widget/job_card_skelaton.dart';
import 'package:hirewise/provider/job_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final ScrollController _recommendedController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initialFetch();
  }

  @override
  void dispose() {
    _recommendedController.dispose();
    super.dispose();
  }

  Future<void> _initialFetch() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    try {
      await fetch();
    } catch (e) {
      if (!mounted) return;
      _showError("Failed to load initial data");
    }
  }

  Future<void> fetch() async {
    if (mounted) {
      final jobProvider = Provider.of<JobProvider>(context, listen: false);

      try {
        if (jobProvider.recommendedJobs.isEmpty) {
          await jobProvider.getRecommendedJobs(context);
        }
      } catch (e) {
        _showError("Something went wrong while fetching jobs");
      }
    }
  }

  Future<void> refreshRecommendedJobs() async {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);

    try {
      await jobProvider.getRecommendedJobs(context);
    } catch (e) {
      _showError("Something went wrong while fetching jobs");
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
          onPressed: () => fetch(),
        ),
      ),
    );
  }

  Widget _buildEmptyState({required VoidCallback onRefresh}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/error.png",
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Text(
              "No jobs found",
              textAlign: TextAlign.center,
              style: AppStyles.mondaB.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: customBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              minimumSize: const Size(200, 40),
            ),
            onPressed: onRefresh,
            child: Text(
              "Refresh",
              style: AppStyles.mondaB.copyWith(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildJobList(List<Job> jobs, ScrollController scrollController,
      {required VoidCallback onRefresh}) {
    if (jobs.isEmpty) {
      return _buildEmptyState(onRefresh: onRefresh);
    }

    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: jobs.length,
      itemBuilder: (context, index) =>
          JobCard(job: jobs[index], applied: false, page: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Hire",
                style: AppStyles.mondaB.copyWith(
                  fontSize: 30,
                  color: customBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "Wise",
                style: AppStyles.mondaB.copyWith(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: customBlue, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JobSearchPage()),
              );
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Consumer<JobProvider>(
        builder: (context, jobProvider, _) {
          if (jobProvider.isLoading) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (_, __) => const JobCardSkeleton(),
            );
          }

          return RefreshIndicator(
            key: _refreshIndicatorKey,
            color: customBlue,
            onRefresh: () => refreshRecommendedJobs(),
            child: _buildJobList(
              jobProvider.recommendedJobs,
              _recommendedController,
              onRefresh: () => refreshRecommendedJobs(),
            ),
          );
        },
      ),
    );
  }
}
