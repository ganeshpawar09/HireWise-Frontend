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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final ScrollController _recommendedController = ScrollController();
  final ScrollController _mightLikeController = ScrollController();

  // Add refresh indicator keys for each tab
  final GlobalKey<RefreshIndicatorState> _recommendedRefreshKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _mightLikeRefreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initialFetch();

    // Listen for tab changes to ensure proper refresh behavior
    _tabController.addListener(() {
      setState(() {}); // Rebuild when tab changes
    });
  }

  @override
  void dispose() {
    _recommendedController.dispose();
    _mightLikeController.dispose();
    _tabController.dispose();
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
    print("fetch");
    if (mounted) {
      final jobProvider = Provider.of<JobProvider>(context, listen: false);

      try {
        if (isRefresh ||
            jobProvider.recommendedJobs.isEmpty ||
            jobProvider.youMightLikeJobs.isEmpty) {
          await jobProvider.getRecommendedJobs(context);
        }
      } catch (e) {
        _showError("Something went wrong while fetching jobs");
      }
    }
  }

  Future<void> refreshJobs() async {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);

    try {
      await jobProvider.getRecommendedJobs(context);
    } catch (e) {
      _showError("Something went wrong while refreshing jobs");
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
                  "No Jobs Found",
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

  Widget _buildJobList(List<Job> jobs, ScrollController scrollController,
      GlobalKey<RefreshIndicatorState> refreshKey, int page) {
    if (jobs.isEmpty) {
      return RefreshIndicator(
        key: refreshKey,
        color: customBlue,
        onRefresh: () => fetch(true),
        child: _buildEmptyState(),
      );
    }

    return RefreshIndicator(
      key: refreshKey,
      color: customBlue,
      onRefresh: () => fetch(true),
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: jobs.length,
        itemBuilder: (context, index) =>
            JobCard(job: jobs[index], applied: false, page: page),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Hire",
                style: AppStyles.mondaB.copyWith(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "Wise",
                style: AppStyles.mondaB.copyWith(
                  fontSize: 30,
                  color: customBlue,
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
        bottom: TabBar(
          controller: _tabController,
          dividerColor: backgroundColor,
          dividerHeight: 0.0,
          labelColor: customBlue,
          unselectedLabelColor: Colors.white,
          indicatorColor: customBlue,
          labelStyle: AppStyles.mondaN.copyWith(
            fontSize: 16,
          ),
          tabs: const [
            Tab(
              text: 'Recommended',
            ),
            Tab(text: 'You Might Like'),
          ],
        ),
      ),
      body: Consumer<JobProvider>(
        builder: (context, jobProvider, _) {
          if (jobProvider.isLoading) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (_, __) => const JobCardSkeleton(),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildJobList(
                jobProvider.recommendedJobs,
                _recommendedController,
                _recommendedRefreshKey,
                1,
              ),
              _buildJobList(
                jobProvider.youMightLikeJobs,
                _mightLikeController,
                _mightLikeRefreshKey,
                2,
              ),
            ],
          );
        },
      ),
    );
  }
}
