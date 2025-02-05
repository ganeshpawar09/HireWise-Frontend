import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/job_model.dart';
import 'package:hirewise/pages/home/home_detail_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final bool applied;
  final int page;
  const JobCard(
      {super.key,
      required this.job,
      required this.applied,
      required this.page});

  String formatSalary(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return "Deadline: ${DateFormat('MMM d, yyyy').format(date)}";
  }

  int dayAgo(String givenDateStr) {
    DateTime givenDate = DateTime.parse(givenDateStr);
    DateTime currentDate = DateTime.now();
    return currentDate.difference(givenDate).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeDetailPage(
                job: job,
                applied: applied,
                page: page,
              ),
            ),
          );
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: cardBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: customBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            job.companyName[0],
                            style: AppStyles.mondaB.copyWith(
                              fontSize: 24,
                              color: customBlue,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              job.companyName,
                              style: AppStyles.mondaB.copyWith(
                                fontSize: 16,
                                color: customBlue,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  MdiIcons.accountGroup,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${job.companySize}+ employees',
                                  style: AppStyles.mondaN.copyWith(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            job.title,
                            style: AppStyles.mondaB.copyWith(fontSize: 18),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: customBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            job.jobType,
                            style: AppStyles.mondaN.copyWith(
                              fontSize: 12,
                              color: customBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildInfoRow(
                      MdiIcons.mapMarker,
                      job.location,
                      MdiIcons.briefcaseOutline,
                      job.experience,
                    ),
                    SizedBox(height: 8),
                    _buildInfoRow(
                      MdiIcons.currencyInr,
                      "₹${formatSalary(job.salaryRangeMin)} - ${formatSalary(job.salaryRangeMax)}",
                      MdiIcons.calendarClock,
                      formatDate(job.deadline.toIso8601String()),
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: job.requiredSkills
                          .take(3)
                          .map((skill) => _buildSkillChip(skill))
                          .toList(),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${dayAgo(job.postingDate.toString())} days ago",
                          style: AppStyles.mondaN.copyWith(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              MdiIcons.accountGroup,
                              color: Colors.white60,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            // Text(
                            //   "${job.applicants.length} applicants",
                            //   style: AppStyles.mondaN.copyWith(
                            //     fontSize: 12,
                            //     color: Colors.white60,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon1, String text1, IconData icon2, String text2) {
    return Row(
      children: [
        Expanded(child: _buildInfoItem(icon1, text1)),
        SizedBox(width: 16),
        Expanded(child: _buildInfoItem(icon2, text2)),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: customBlue),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style:
                AppStyles.mondaN.copyWith(fontSize: 12, color: Colors.white70),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        skill,
        style: AppStyles.mondaN.copyWith(
          fontSize: 12,
          color: Colors.white70,
        ),
      ),
    );
  }
}
