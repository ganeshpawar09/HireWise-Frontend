import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/study_material.dart';
import 'package:hirewise/pages/prepzone/studymaterial/study_material_detail_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CSFundamentalsStudyMaterialPage extends StatelessWidget {
  const CSFundamentalsStudyMaterialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "CS Fundamentals",
          style: AppStyles.mondaB.copyWith(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: 5,
              itemBuilder: (context, index) {
                final topics = [
                  PathItem(
                    "DSA",
                    "Learn arrays, lists, stacks, and queues for efficient data handling.",
                    Icons.storage,
                    accentBlue,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopicContent(topic: dsa),
                      ),
                    ),
                  ),
                  PathItem(
                    "OS",
                    "Explore process management and memory allocation in OS.",
                    Icons.computer,
                    accentOrange,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopicContent(topic: os),
                      ),
                    ),
                  ),
                  PathItem(
                    "DBMS",
                    "Understand SQL and NoSQL databases.",
                    MdiIcons.database,
                    accentGreen,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopicContent(topic: dbms),
                      ),
                    ),
                  ),
                  PathItem(
                    "OOP",
                    "Master OOP principles and design patterns.",
                    Icons.developer_board,
                    accentViolet,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopicContent(topic: oop),
                      ),
                    ),
                  ),
                  PathItem(
                    "CN",
                    "Study protocols and security for resilient applications.",
                    Icons.network_wifi,
                    accentPink,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopicContent(topic: cn),
                      ),
                    ),
                  ),
                ];
                return _buildCard(topics[index]);
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(PathItem path) {
    return GestureDetector(
      onTap: path.onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              path.color.withOpacity(0.15),
              path.color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: path.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                path.icon,
                color: path.color,
                size: 28,
              ),
            ),
            const Spacer(),
            Text(
              path.title,
              style: AppStyles.mondaB.copyWith(
                fontSize: 20,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              path.description,
              style: AppStyles.mondaN.copyWith(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PathItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  PathItem(
    this.title,
    this.description,
    this.icon,
    this.color,
    this.onTap,
  );
}
//   Widget _buildTopicCard(String title, String description, IconData icon,
//       Color color, BuildContext context, String section) {
//     return InkWell(
//       onTap: () {
//         StudyMaterial selectedTopic;

//         switch (title) {
//           case 'Object-Oriented Programming':
//             selectedTopic = oop;
//             break;
//           case 'Database Management Systems':
//             selectedTopic = dbms;
//             break;
//           case 'Data Structures & Algorithms':
//             selectedTopic = dsa;
//             break;
//           case 'Operating Systems':
//             selectedTopic = os;
//             break;
//           case 'Networking':
//             selectedTopic = cn;
//             break;
//           default:
//             selectedTopic = cn;
//             return;
//         }

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TopicContent(
//               topic: selectedTopic,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               color.withOpacity(0.2),
//               color.withOpacity(0.05),
//             ],
//             stops: const [0.1, 0.9],
//           ),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: color.withOpacity(0.3),
//             width: 2,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.2),
//               blurRadius: 15,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 size: 32,
//                 color: color,
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 title,
//                 style: AppStyles.mondaB.copyWith(
//                   fontSize: 16,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 description,
//                 style: AppStyles.mondaM.copyWith(
//                   fontSize: 12,
//                   color: Colors.white.withOpacity(0.8),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
