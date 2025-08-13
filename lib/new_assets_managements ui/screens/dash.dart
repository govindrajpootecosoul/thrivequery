import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Assets_DashboardScreen extends StatefulWidget {
  const Assets_DashboardScreen({super.key});
  @override
  State<Assets_DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<Assets_DashboardScreen> {
  Map<String, dynamic>? statusCounts;
  Map<String, dynamic>? categoryCounts;
  bool isLoading = true;

  // dummy recent activity (kept as requested)
  final List<Map<String, String>> _dummyRecent = [
    {"title": "CA-LAP-045 - Checkout", "subtitle": "John Smith • 2 hours ago"},
    {"title": "EE-KBD-023 - Checkin", "subtitle": "Sarah Johnson • 4 hours ago"},
    {"title": "CA-DESK-112 - Maintenance", "subtitle": "Mike Wilson • 1 day ago"},
    {"title": "EE-LCD-078 - Audit", "subtitle": "Emma Davis • 2 days ago"},
    {"title": "EE-MSE-156 - Checkout", "subtitle": "David Brown • 3 days ago"},
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var dio = Dio();
      var response = await dio.get(
        'https://thrive-assetsmanagements.onrender.com/api/assetmanagements/counts',
      );

      if (response.statusCode == 200) {
        setState(() {
          statusCounts = Map<String, dynamic>.from(response.data["statusCounts"] ?? {});
          categoryCounts = Map<String, dynamic>.from(response.data["categoryCounts"] ?? {});
          isLoading = false;
        });
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  // === kept your buildCard signature but slightly tuned for two styles (white top cards and colored status cards)
  Widget buildCard(Color iconColor, IconData icon, String title, int value,
      {Color? bgColor}) {
    // If bgColor provided -> status overview style (colored background)
    final bool colored = bgColor != null;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colored ? bgColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade200, blurRadius: 6),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top row with value and circular icon on right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Value (if colored card, value bigger & centered style)
                Text(
                  "$value",
                  style: TextStyle(
                    fontSize: colored ? 22 : 22,
                    fontWeight: FontWeight.bold,
                    color: colored ? Colors.black87 : Colors.black87,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: colored ? Colors.white.withOpacity(0.15) : iconColor.withOpacity(0.12),
                  child: Icon(icon, color: colored ? iconColor : iconColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colored ? Colors.black87 : Colors.black54,
              ),
            ),
            // small change indicator for top white cards (only for top row Total/Assigned etc.)
            if (!colored)
              const SizedBox(height: 8),
            if (!colored)
              const Text(
                "", // keep blank; you can put change text here if API provides
                style: TextStyle(fontSize: 12, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }

  Widget actionButton(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color.withOpacity(0.25), width: 1.2),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 10),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget recentActivityItem(
      IconData icon, Color iconColor, String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // small status dot like screenshot
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // asset category row item matching screenshot (dot + label + right count + percent)
  Widget _categoryRow(String name, int count, double percent, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // colored dot
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 14))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(count.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text("${(percent * 100).toStringAsFixed(1)}%", style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }

  // compute percentages for categories
  Map<String, double> _computeCategoryPercents(Map<String, dynamic> cats) {
    final Map<String, double> res = {};
    int total = 0;
    cats.forEach((k, v) {
      if (v is int) total += v;
      else if (v is String) total += int.tryParse(v) ?? 0;
      else if (v is double) total += v.toInt();
    });
    if (total == 0) {
      cats.forEach((k, v) => res[k] = 0.0);
      return res;
    }
    cats.forEach((k, v) {
      final int val = (v is int) ? v : (v is String ? int.tryParse(v) ?? 0 : (v is double ? v.toInt() : 0));
      res[k] = val / total;
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    // responsive layout: use wide two-column when width >= 1000
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Dashboard", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(builder: (context, constraints) {
        final bool wide = constraints.maxWidth >= 1000;
        // compute category percents
        final Map<String, dynamic> cats = categoryCounts ?? {};
        final percents = _computeCategoryPercents(cats);
        final List<Color> categoryColors = [
          const Color(0xFF2F80ED), // blue
          const Color(0xFF27AE60), // green
          const Color(0xFF9B51E0), // purple
          const Color(0xFFF2994A), // orange
          // add more if needed
        ];

        Widget topStatsRow() {
          // top row cards look white with small circular icon right
          return Row(
            children: [
              // keep your buildCard usage but with white bg (bgColor null)
              buildCard(const Color(0xFF2F80ED), Icons.pie_chart_outline, "Total Assets", statusCounts?["total"] ?? 0),
              buildCard(const Color(0xFF27AE60), Icons.people_outline, "Assigned Assets", statusCounts?["assigned"] ?? 0),
              buildCard(const Color(0xFF8A2BE2), Icons.check_circle_outline, "Available Assets", statusCounts?["available"] ?? 0),
              buildCard(const Color(0xFFF2994A), Icons.build_outlined, "Under Maintenance", statusCounts?["underMaintenance"] ?? 0),
            ],
          );
        }

        Widget statusOverview() {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0,3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text("Asset Status Overview", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                // the big colored cards in a row
                Row(
                  children: [
                    // Assigned (light blue)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(color: const Color(0xFF2F80ED), shape: BoxShape.circle),
                              child: const Icon(Icons.check, color: Colors.white),
                            ),
                            const SizedBox(height: 12),
                            Text("${statusCounts?["assigned"] ?? 0}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            const Text("Assigned", style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                    ),
                    // Available (light green)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(color: const Color(0xFF27AE60), shape: BoxShape.circle),
                              child: const Icon(Icons.event_available, color: Colors.white),
                            ),
                            const SizedBox(height: 12),
                            Text("${statusCounts?["available"] ?? 0}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            const Text("Available", style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                    ),
                    // Maintenance (light orange)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(color: const Color(0xFFF2994A), shape: BoxShape.circle),
                              child: const Icon(Icons.build_circle, color: Colors.white),
                            ),
                            const SizedBox(height: 12),
                            Text("${statusCounts?["underMaintenance"] ?? 0}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            const Text("Maintenance", style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                    ),
                    // Broken (light pink)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(color: const Color(0xFFEB5757), shape: BoxShape.circle),
                              child: const Icon(Icons.close, color: Colors.white),
                            ),
                            const SizedBox(height: 12),
                            Text("${statusCounts?["broken"] ?? 0}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            const Text("Broken", style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        Widget assetCategoriesPanel() {
          // total assets for footer
          int total = 0;
          categoryCounts?.forEach((k, v) {
            final int val = (v is int) ? v : (v is String ? int.tryParse(v) ?? 0 : 0);
            total += val;
          });
          final perc = _computeCategoryPercents(categoryCounts ?? {});

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Asset Categories", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                // build rows
                ...categoryCounts!.entries.toList().asMap().entries.map((entryIndex) {
                  final idx = entryIndex.key;
                  final entry = entryIndex.value;
                  final name = entry.key;
                  final val = (entry.value is int) ? entry.value : int.tryParse(entry.value.toString()) ?? 0;
                  final pct = perc[name] ?? 0.0;
                  final dotColor = categoryColors[idx % categoryColors.length];
                  return _categoryRow(name, val, pct, dotColor);
                }).toList(),
                const Divider(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Assets", style: TextStyle(fontWeight: FontWeight.w600)),
                    Text("${statusCounts?["total"] ?? total}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          );
        }

        Widget quickActionsPanel() {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Quick Actions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // two-column grid-like layout
                    Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2F80ED).withOpacity(0.25)), borderRadius: BorderRadius.circular(8)), child: Column(children: const [Icon(Icons.add, color: Color(0xFF2F80ED)), SizedBox(height: 8), Text("Add New Asset", style: TextStyle(color: Color(0xFF2F80ED)))]))),
                    const SizedBox(width: 12),
                    Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: const Color(0xFF27AE60).withOpacity(0.25)), borderRadius: BorderRadius.circular(8)), child: Column(children: const [Icon(Icons.access_time, color: Color(0xFF27AE60)), SizedBox(height: 8), Text("Audit Assets", style: TextStyle(color: Color(0xFF27AE60)))]))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: const Color(0xFF9B51E0).withOpacity(0.25)), borderRadius: BorderRadius.circular(8)), child: Column(children: const [Icon(Icons.download, color: Color(0xFF9B51E0)), SizedBox(height: 8), Text("Export Report", style: TextStyle(color: Color(0xFF9B51E0)))]))),
                    const SizedBox(width: 12),
                    Expanded(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFF2994A).withOpacity(0.25)), borderRadius: BorderRadius.circular(8)), child: Column(children: const [Icon(Icons.settings, color: Color(0xFFF2994A)), SizedBox(height: 8), Text("Manage Settings", style: TextStyle(color: Color(0xFFF2994A)))]))),
                  ],
                ),
              ],
            ),
          );
        }

        Widget recentActivityPanel() {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Recent Activity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                // list
                ..._dummyRecent.map((e) => recentActivityItem(Icons.check_circle, Colors.blue, e['title']!, e['subtitle']!)).toList(),
              ],
            ),
          );
        }

        // Main layout
        if (wide) {
          // desktop: two-column layout
          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top stats (full width)
                topStatsRow(),
                const SizedBox(height: 18),
                // middle: left big status overview + right categories
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // left (status overview) - takes 2/3
                    Expanded(
                      flex: 3,
                      child: statusOverview(),
                    ),
                    const SizedBox(width: 18),
                    // right (categories)
                    Expanded(
                      flex: 1,
                      child: assetCategoriesPanel(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // bottom: recent activity (left) and quick actions (right)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: recentActivityPanel()),
                    const SizedBox(width: 18),
                    Expanded(flex: 1, child: quickActionsPanel()),
                  ],
                ),
              ],
            ),
          );
        } else {
          // mobile: stacked single column
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topStatsRow(),
                const SizedBox(height: 12),
                statusOverview(),
                const SizedBox(height: 12),
                assetCategoriesPanel(),
                const SizedBox(height: 12),
                recentActivityPanel(),
                const SizedBox(height: 12),
                quickActionsPanel(),
              ],
            ),
          );
        }
      }),
    );
  }
}
