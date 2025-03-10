import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/hackathon_model.dart';
import 'package:hirewise/pages/hackathon/hackathon_detail_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

class HackathonCard extends StatelessWidget {
  final Hackathon hackathon;
  const HackathonCard({
    super.key,
    required this.hackathon,
  });

  String formatPrizeMoney(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }

  String formatDateRange(DateTime start, DateTime end) {
    return "${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d, yyyy').format(end)}";
  }

  int daysLeft(DateTime endDate) {
    DateTime currentDate = DateTime.now();
    return endDate.difference(currentDate).inDays;
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
              builder: (context) => HackathonDetailPage(
                hackathon: hackathon,
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
                          child: hackathon.imageUrl.isEmpty
                              ? _buildInitialLetter()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    hackathon.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback to initial letter when image fails to load
                                      return _buildInitialLetter();
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  customBlue),
                                          strokeWidth: 2.0,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              hackathon.organizer.isNotEmpty
                                  ? hackathon.organizer
                                  : "Hackathon",
                              style: AppStyles.mondaB.copyWith(
                                fontSize: 16,
                                color: customBlue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  MdiIcons.calendarRange,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  formatDateRange(
                                      hackathon.startDate, hackathon.endDate),
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
                      // Status indicator (days left or ongoing)
                      _buildStatusIndicator(),
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
                            hackathon.hackathonName,
                            style: AppStyles.mondaB.copyWith(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      MdiIcons.mapMarker,
                      hackathon.location,
                      MdiIcons.accountGroup,
                      "Max ${hackathon.maxTeamSize} members",
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      MdiIcons.trophy,
                      "₹${formatPrizeMoney(hackathon.prizeMoney)} Prize Pool",
                      MdiIcons.fileDocumentOutline,
                      "${hackathon.problemStatements.length} Problems",
                    ),
                    const SizedBox(height: 16),
                    Text(
                      hackathon.description,
                      style: AppStyles.mondaN.copyWith(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildInitialLetter() {
    return Text(
      hackathon.organizer.isNotEmpty
          ? hackathon.organizer[0]
          : hackathon.hackathonName[0],
      style: AppStyles.mondaB.copyWith(
        fontSize: 24,
        color: customBlue,
      ),
    );
  }

  // Widget to display status indicator (days left or ongoing)
  Widget _buildStatusIndicator() {
    final days = daysLeft(hackathon.endDate);
    final isOngoing = DateTime.now().isAfter(hackathon.startDate) &&
        DateTime.now().isBefore(hackathon.endDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isOngoing
            ? Colors.green.withOpacity(0.2)
            : (days > 0
                ? customBlue.withOpacity(0.2)
                : Colors.red.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isOngoing ? Colors.green : (days > 0 ? customBlue : Colors.red),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOngoing
                ? MdiIcons.play
                : (days > 0 ? MdiIcons.clockOutline : MdiIcons.closeCircle),
            size: 14,
            color:
                isOngoing ? Colors.green : (days > 0 ? customBlue : Colors.red),
          ),
          const SizedBox(width: 4),
          Text(
            isOngoing ? "Ongoing" : (days > 0 ? "$days days left" : "Ended"),
            style: AppStyles.mondaB.copyWith(
              fontSize: 12,
              color: isOngoing
                  ? Colors.green
                  : (days > 0 ? customBlue : Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon1, String text1, IconData icon2, String text2) {
    return Row(
      children: [
        Expanded(child: _buildInfoItem(icon1, text1)),
        const SizedBox(width: 16),
        Expanded(child: _buildInfoItem(icon2, text2)),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: customBlue),
        const SizedBox(width: 4),
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
}
