import 'package:flutter/material.dart';
import 'package:hirewise/pages/hackathon/hackathon_search_result_page.dart';
import 'package:hirewise/provider/hackathon_provider.dart';
import 'package:provider/provider.dart';
import 'package:hirewise/provider/job_provider.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';

class HackathonSearchPage extends StatefulWidget {
  const HackathonSearchPage({super.key});

  @override
  State<HackathonSearchPage> createState() => _HackathonSearchPageState();
}

class _HackathonSearchPageState extends State<HackathonSearchPage> {
  final _formKey = GlobalKey<FormState>();
  final _queryController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Widget _buildTextField(
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: customBlue, size: 24),
              hintText: "Search for Hackathon or Location...",
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 16,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: customBlue,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _performSearch() async {
    try {
      if (_queryController.text.isNotEmpty) {
        setState(() {
          _isSearching = true;
        });
        if (mounted) {
          setState(() {
            _isSearching = false;
          });
          await Provider.of<HackathonProvider>(context, listen: false)
              .searchHackathon(
            context,
            query: _queryController.text,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HackathonSearchResultsPage(
                query: _queryController.text,
              ),
            ),
          );
        }
      } else {
        setState(() {
          _isSearching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Please enter a hackathon or location to search',
              style: TextStyle(fontSize: 15),
            ),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: const TextStyle(fontSize: 15),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Find Hackathon',
          style: AppStyles.mondaB.copyWith(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildTextField(
              _queryController,
              Icons.search_rounded,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSearching ? null : () => _performSearch(),
              style: ElevatedButton.styleFrom(
                backgroundColor: customBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                shadowColor: customBlue.withOpacity(0.4),
              ),
              child: _isSearching
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Search Hackathons',
                          style: AppStyles.mondaB.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
