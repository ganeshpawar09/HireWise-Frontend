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
  final ScrollController _recommendedController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _recommendedRefreshKey =
      GlobalKey<RefreshIndicatorState>();

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
      await fetch(false);
    } catch (e) {
      if (!mounted) return;
      _showError("Failed to load initial data");
    }
  }

  Future<void> fetch(bool isRefresh) async {
    if (mounted) {
      final jobProvider = Provider.of<JobProvider>(context, listen: false);

      try {
        if (isRefresh || jobProvider.recommendedJobs.isEmpty) {
          print("fetch");
          await jobProvider.getRecommendedJobs(context);
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

  Widget _buildJobList(List<Job> jobs) {
    if (jobs.isEmpty) {
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
      );
    }

    return RefreshIndicator(
      key: _recommendedRefreshKey,
      color: customBlue,
      onRefresh: () => fetch(true),
      child: ListView.builder(
        controller: _recommendedController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: jobs.length,
        itemBuilder: (context, index) =>
            JobCard(job: jobs[index], applied: false, page: 1),
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
      ),
      body: Consumer<JobProvider>(
        builder: (context, jobProvider, _) {
          if (jobProvider.isLoading) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (_, __) => const JobCardSkeleton(),
            );
          }
          return _buildJobList(jobProvider.recommendedJobs);
        },
      ),
    );
  }
}
