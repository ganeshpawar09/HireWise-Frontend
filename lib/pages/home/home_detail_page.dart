import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/job_model.dart';
import 'package:hirewise/provider/job_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class HomeDetailPage extends StatefulWidget {
  final Job job;
  final bool applied;
  final int page;
  const HomeDetailPage(
      {super.key,
      required this.job,
      required this.applied,
      required this.page});

  @override
  State<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends State<HomeDetailPage> {
  String formatSalary(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    customBlue.withOpacity(0.8),
                    Colors.black,
                  ],
                )),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            widget.job.companyName[0],
                            style: AppStyles.mondaB.copyWith(
                              fontSize: 36,
                              color: customBlue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.job.companyName,
                        style: AppStyles.mondaB.copyWith(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Job Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Title and Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.job.title,
                          style: AppStyles.mondaB.copyWith(fontSize: 24),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: customBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.job.jobType,
                          style: AppStyles.mondaN.copyWith(
                            fontSize: 14,
                            color: customBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          MdiIcons.currencyInr,
                          'Salary Range',
                          '₹${formatSalary(widget.job.salaryRangeMin)} - ${formatSalary(widget.job.salaryRangeMax)} per annum',
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          MdiIcons.briefcaseOutline,
                          'Experience',
                          widget.job.experience,
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          MdiIcons.mapMarker,
                          'Location',
                          widget.job.location,
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          MdiIcons.accountGroup,
                          'Company Size',
                          '${widget.job.companySize}+ employees',
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          MdiIcons.factoryIcon,
                          'Industry',
                          widget.job.companyIndustry,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Required Skills
                  Text(
                    'Required Skills',
                    style: AppStyles.mondaB.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.job.requiredSkills
                        .map((skill) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: customBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                skill,
                                style: AppStyles.mondaN.copyWith(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Job Description
                  Text(
                    'Job Description',
                    style: AppStyles.mondaB.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.job.description,
                    style: AppStyles.mondaN.copyWith(
                      fontSize: 15,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Responsibilities
                  Text(
                    'Key Responsibilities',
                    style: AppStyles.mondaB.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: widget.job.responsibilities
                        .map((resp) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    MdiIcons.chevronRight,
                                    color: customBlue,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      resp,
                                      style: AppStyles.mondaN.copyWith(
                                        fontSize: 15,
                                        color: Colors.white70,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Qualifications
                  Text(
                    'Qualifications',
                    style: AppStyles.mondaB.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: widget.job.qualifications
                        .map((qual) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    MdiIcons.checkCircle,
                                    color: customBlue,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      qual,
                                      style: AppStyles.mondaN.copyWith(
                                        fontSize: 15,
                                        color: Colors.white70,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Company Description
                  Text(
                    'About Company',
                    style: AppStyles.mondaB.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.job.companyDescription,
                    style: AppStyles.mondaN.copyWith(
                      fontSize: 15,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: (widget.applied)
          ? const SizedBox()
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await Provider.of<JobProvider>(context, listen: false)
                      .applyForJob(context, widget.job.id, widget.page);
                  setState(() {
                    _isLoading = false;
                  });

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: (_isLoading)
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Apply Now',
                        style: AppStyles.mondaB.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: customBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: customBlue,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppStyles.mondaN.copyWith(
                fontSize: 13,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppStyles.mondaB.copyWith(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
