import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/hackathon_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class HackathonDetailPage extends StatefulWidget {
  final Hackathon hackathon;
  const HackathonDetailPage({
    super.key,
    required this.hackathon,
  });

  @override
  State<HackathonDetailPage> createState() => _HackathonDetailPageState();
}

class _HackathonDetailPageState extends State<HackathonDetailPage> {
  String formatPrizeMoney(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
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
                  ),
                ),
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
                          child: widget.hackathon.imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    widget.hackathon.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Text(
                                        widget.hackathon.hackathonName[0],
                                        style: AppStyles.mondaB.copyWith(
                                          fontSize: 36,
                                          color: customBlue,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Text(
                                  widget.hackathon.hackathonName[0],
                                  style: AppStyles.mondaB.copyWith(
                                    fontSize: 36,
                                    color: customBlue,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.hackathon.hackathonName,
                        style: AppStyles.mondaB.copyWith(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Hackathon Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Organizer and Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Organized by ${widget.hackathon.organizer}",
                          style: AppStyles.mondaB.copyWith(fontSize: 18),
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
                          widget.hackathon.location,
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
                          MdiIcons.calendarRange,
                          'Start Date',
                          formatDate(widget.hackathon.startDate),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          MdiIcons.calendarClock,
                          'End Date',
                          formatDate(widget.hackathon.endDate),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          MdiIcons.accountGroup,
                          'Team Size',
                          '${widget.hackathon.maxTeamSize} members max',
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          MdiIcons.trophy,
                          'Prize Pool',
                          widget.hackathon.prizeMoney > 0
                              ? '₹${formatPrizeMoney(widget.hackathon.prizeMoney)}'
                              : 'TBA',
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          MdiIcons.mapMarker,
                          'Location',
                          widget.hackathon.location,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Hackathon Description
                  Text(
                    'About Hackathon',
                    style: AppStyles.mondaB.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.hackathon.description,
                    style: AppStyles.mondaN.copyWith(
                      fontSize: 15,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Problem Statements
                  Text(
                    'Problem Statements',
                    style: AppStyles.mondaB.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: widget.hackathon.problemStatements
                        .map((problem) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    MdiIcons.lightbulbOutline,
                                    color: customBlue,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      problem,
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

                  // Rules
                  Text(
                    'Rules & Guidelines',
                    style: AppStyles.mondaB.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: widget.hackathon.rules
                        .map((rule) => Padding(
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
                                      rule,
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
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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

            try {
              final Uri url = Uri.parse(widget.hackathon.registrationLink);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not launch registration link'),
                  ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $e'),
                ),
              );
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: customBlue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Go To Hackathon',
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
