/*
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

void main() => runApp(const SalesDashboardChart());

class SalesDashboardChart extends StatelessWidget {
  const SalesDashboardChart({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Graph graph = Graph()..isTree = true;
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  final Map<String, Node> nodes = {};
  final Map<String, List<String>> edges = {};
  final Map<String, bool> expanded = {};

  @override
  void initState() {
    super.initState();
    builder
      ..siblingSeparation = (30)
      ..levelSeparation = (100)
      ..subtreeSeparation = (40)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT;
    _initNodes();
    // All expanded by default
    for (var key in expanded.keys) {
      expanded[key] = true;
    }
    _updateGraph();
  }

  void _initNodes() {
    addNode('offtake', 'Offtake', 'AED 3.1k', true);
    addNode('gvs', 'GVs', '716', true, 'Avg. Rank: 7',);
    addNode('organicGvs', 'Organic GVs', '716', true, 'Rank: 19');
    addNode('adGvs', 'Ad GVs', '0.0', false, 'Rank: 19');
    addNode('impressions', 'Impressions', '12k', true);
    addNode('ctr', 'CTR%', '5%', true);
    addNode('addToCart', 'Add to Cart', '150', false);
    addNode('cvr', 'CVR', '15.9%', false);
    addNode('asp', 'ASP', 'AED 27.1', false);
    addNode('buyBox', 'BuyBox%', '74.5%', false);
    addNode('sellerListing', 'Seller Listing%', '74.5%', false);
    addNode('discounting', 'Discounting', '35.5%', true);
    addNode('osa', 'OSA Ad. to Organic Ratio', '0.0%', false);

    addEdge('offtake', 'gvs');
    addEdge('offtake', 'cvr');
    addEdge('offtake', 'asp');
    addEdge('gvs', 'organicGvs');
    addEdge('gvs', 'adGvs');
    addEdge('gvs', 'addToCart');
    addEdge('adGvs', 'impressions');
    addEdge('adGvs', 'ctr');
    addEdge('cvr', 'buyBox');
    addEdge('buyBox', 'sellerListing');
    addEdge('cvr', 'discounting');
    addEdge('cvr', 'osa');
  }

  void _updateGraph() {
    graph.nodes.clear();
    graph.edges.clear();
    for (var node in nodes.values) {
      graph.addNode(node);
    }
    for (var from in edges.keys) {
      for (var to in edges[from]!) {
        graph.addEdge(nodes[from]!, nodes[to]!);
      }
    }
    setState(() {});
  }

  void addNode(String id, String title, String value, bool isPositive, [String? subtitle]) {
    expanded[id] = true; // Default to expanded
    nodes[id] = Node.Id(id)
      ..key = ValueKey(
        getToggleBox(
          id,
          title,
          value,
          isPositive,
          expanded[id]!,
              () {
            setState(() {
              expanded[id] = !(expanded[id] ?? false);
              _updateGraph();
            });
          },
          subtitle,
        ),
      );
  }

  void addEdge(String from, String to) {
    edges[from] = [...?edges[from], to];
  }

  Widget getToggleBox(String id, String title, String value, bool isPositive, bool isExpanded, VoidCallback onTap, [String? subtitle]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),

              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
              ],
            ),
            if (subtitle != null)
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF6EB),
      appBar: AppBar(
        backgroundColor: Colors.brown.shade100,
        title: const Text("Sales KPI Flow Chart"),
        centerTitle: true,
      ),
      body: Center(
        child: InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(60),
          minScale: 0.5,
          maxScale: 2.0,
          child: GraphView(
            graph: graph,
            algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
            paint: Paint()
              ..color = Colors.black
              ..strokeWidth = 1
              ..style = PaintingStyle.stroke,
            builder: (Node node) {
              return node.key!.value as Widget;
            },
          ),
        ),
      ),
    );
  }
}
*/







import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

void main() => runApp(const SalesDashboardChart());

class SalesDashboardChart extends StatelessWidget {
  const SalesDashboardChart({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Graph graph = Graph()..isTree = true;
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  final Map<String, Node> nodes = {};
  final Map<String, List<String>> edges = {};
  final Map<String, bool> expanded = {};

  @override
  void initState() {
    super.initState();
    builder
      ..siblingSeparation = (30)
      ..levelSeparation = (100)
      ..subtreeSeparation = (40)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT;
    _initNodes();
    for (var key in expanded.keys) {
      expanded[key] = true;
    }
    _updateGraph();
  }

  void _initNodes() {
    addNode('offtake', 'Offtake', 'AED 3.1k', true, trendPercent: '+3.4%');
    addNode('gvs', 'GVs', '716', true, subtitle: 'Avg. Rank', subValue: '7', trendPercent: '+52.4%');
    addNode('organicGvs', 'Organic GVs', '716', true, subtitle: 'Rank', subValue: '19', trendPercent: '+20.0%');
    addNode('adGvs', 'Ad GVs', '0.0', false, subtitle: 'Rank', subValue: '19', trendPercent: '-10.0%');
    addNode('impressions', 'Impressions', '12k', true, trendPercent: '+5.5%');
    addNode('ctr', 'CTR%', '5%', true, trendPercent: '+2.5%');
    addNode('addToCart', 'Add to Cart', '150', false, trendPercent: '-4.2%');
    addNode('cvr', 'CVR', '15.9%', false, trendPercent: '-1.1%');
    addNode('asp', 'ASP', 'AED 27.1', false, trendPercent: '-0.5%');
    addNode('buyBox', 'BuyBox%', '74.5%', false, trendPercent: '-3.2%');
    addNode('sellerListing', 'Seller Listing%', '74.5%', false, trendPercent: '-2.4%');
    addNode('discounting', 'Discounting', '35.5%', true, trendPercent: '+4.1%');
    addNode('osa', 'OSA Ad. to Organic Ratio', '0.0%', false, trendPercent: '-1.7%');

    addEdge('offtake', 'gvs');
    addEdge('offtake', 'cvr');
    addEdge('offtake', 'asp');
    addEdge('gvs', 'organicGvs');
    addEdge('gvs', 'adGvs');
    addEdge('gvs', 'addToCart');
    addEdge('adGvs', 'impressions');
    addEdge('adGvs', 'ctr');
    addEdge('cvr', 'buyBox');
    addEdge('buyBox', 'sellerListing');
    addEdge('cvr', 'discounting');
    addEdge('cvr', 'osa');
  }

  void _updateGraph() {
    graph.nodes.clear();
    graph.edges.clear();
    for (var node in nodes.values) {
      graph.addNode(node);
    }
    for (var from in edges.keys) {
      for (var to in edges[from]!) {
        graph.addEdge(nodes[from]!, nodes[to]!);
      }
    }
    setState(() {});
  }

  void addNode(
      String id,
      String title,
      String value,
      bool isPositive, {
        String? subtitle,
        String? subValue,
        String? trendPercent,
      }) {
    expanded[id] = true;
    nodes[id] = Node.Id(id)
      ..key = ValueKey(
        getToggleBox(
          id,
          title,
          value,
          isPositive,
          expanded[id]!,
              () {
            setState(() {
              expanded[id] = !(expanded[id] ?? false);
              _updateGraph();
            });
          },
          subtitle,
          subValue,
          trendPercent,
        ),
      );
  }

  void addEdge(String from, String to) {
    edges[from] = [...?edges[from], to];
  }

  Widget getToggleBox(
      String id,
      String title,
      String value,
      bool isPositive,
      bool isExpanded,
      VoidCallback onTap, [
        String? subtitle,
        String? subValue,
        String? trendPercent,
      ]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
          ],
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (subtitle != null && subValue != null) ...[
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(subValue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
            const SizedBox(height: 6),
            if (trendPercent != null)
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isPositive ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trendPercent,
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF6EB),
      appBar: AppBar(
        backgroundColor: Colors.brown.shade100,
        title: const Text("Sales KPI Flow Chart"),
        centerTitle: true,
      ),
      body: Center(
        child: InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(60),
          minScale: 0.5,
          maxScale: 2.0,
          child:
          GraphView(
            graph: graph,
            algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
            paint: Paint()
              ..color = Colors.black
              ..strokeWidth = 1
              ..style = PaintingStyle.stroke,
            builder: (Node node) {
              return node.key!.value as Widget;
            },
          ),
        ),
      ),
    );
  }
}







//
// import 'package:flutter/material.dart';
// import 'package:graphview/GraphView.dart';
//
// void main() => runApp(const SalesDashboardChart());
//
// class SalesDashboardChart extends StatelessWidget {
//   const SalesDashboardChart({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: DashboardScreen(),
//     );
//   }
// }
//
// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   final Graph graph = Graph()..isTree = true;
//   final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
//   final Map<String, Node> nodes = {};
//
//   @override
//   void initState() {
//     super.initState();
//     builder
//       ..siblingSeparation = 30
//       ..levelSeparation = 100
//       ..subtreeSeparation = 40
//       ..orientation = BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT;
//
//     _initNodes();
//   }
//
//   void _initNodes() {
//     addNode('offtake', 'Offtake', 'AED 3.1k', true, trendPercent: '+3.4%');
//     addNode('gvs', 'GVs', '716', true, subtitle: 'Avg. Rank', subValue: '7', trendPercent: '+52.4%');
//     addNode('organicGvs', 'Organic GVs', '716', true, subtitle: 'Rank', subValue: '19', trendPercent: '+20.0%');
//     addNode('adGvs', 'Ad GVs', '0.0', false, subtitle: 'Rank', subValue: '19', trendPercent: '-10.0%');
//     addNode('impressions', 'Impressions', '12k', true, trendPercent: '+5.5%');
//     addNode('ctr', 'CTR%', '5%', true, trendPercent: '+2.5%');
//     addNode('addToCart', 'Add to Cart', '150', false, trendPercent: '-4.2%');
//     addNode('cvr', 'CVR', '15.9%', false, trendPercent: '-1.1%');
//     addNode('asp', 'ASP', 'AED 27.1', false, trendPercent: '-0.5%');
//     addNode('buyBox', 'BuyBox%', '74.5%', false, trendPercent: '-3.2%');
//     addNode('sellerListing', 'Seller Listing%', '74.5%', false, trendPercent: '-2.4%');
//     addNode('discounting', 'Discounting', '35.5%', true, trendPercent: '+4.1%');
//     addNode('osa', 'OSA Ad. to Organic Ratio', '0.0%', false, trendPercent: '-1.7%');
//
//     addEdge('offtake', 'gvs');
//     addEdge('offtake', 'cvr');
//     addEdge('offtake', 'asp');
//     addEdge('gvs', 'organicGvs');
//     addEdge('gvs', 'adGvs');
//     addEdge('gvs', 'addToCart');
//     addEdge('adGvs', 'impressions');
//     addEdge('adGvs', 'ctr');
//     addEdge('cvr', 'buyBox');
//     addEdge('buyBox', 'sellerListing');
//     addEdge('cvr', 'discounting');
//     addEdge('cvr', 'osa');
//   }
//
//   void addNode(String id, String title, String value, bool isPositive,
//       {String? subtitle, String? subValue, String? trendPercent}) {
//     final box = getStyledBox(title, value, isPositive,
//         subtitle: subtitle, subValue: subValue, trendPercent: trendPercent);
//     final node = Node(box); // ✅ FIX: Use Node(widget)
//     nodes[id] = node;
//     graph.addNode(node);
//   }
//
//   void addEdge(String from, String to) {
//     graph.addEdge(
//       nodes[from]!,
//       nodes[to]!,
//       paint: Paint()
//         ..color = Colors.brown
//         ..strokeWidth = 2
//         ..style = PaintingStyle.stroke
//         ..strokeCap = StrokeCap.round,
//     );
//   }
//
//   Widget getStyledBox(String title, String value, bool isPositive,
//       {String? subtitle, String? subValue, String? trendPercent}) {
//     return Container(
//       width: 160,
//       padding: const EdgeInsets.all(12),
//       margin: const EdgeInsets.all(6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
//         ],
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//           const SizedBox(height: 4),
//           Text(value,
//               style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           if (subtitle != null && subValue != null) ...[
//             Text(subtitle,
//                 style: const TextStyle(fontSize: 12, color: Colors.grey)),
//             const SizedBox(height: 2),
//             Text(subValue,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ],
//           const SizedBox(height: 6),
//           if (trendPercent != null)
//             Align(
//               alignment: Alignment.centerRight,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Icon(
//                     isPositive ? Icons.arrow_upward : Icons.arrow_downward,
//                     color: isPositive ? Colors.green : Colors.red,
//                     size: 16,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     trendPercent,
//                     style: TextStyle(
//                       color: isPositive ? Colors.green : Colors.red,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFCF6EB),
//       appBar: AppBar(
//         backgroundColor: Colors.brown.shade100,
//         title: const Text("Sales KPI Flow Chart"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: InteractiveViewer(
//           constrained: false,
//           boundaryMargin: const EdgeInsets.all(60),
//           minScale: 0.5,
//           maxScale: 2.0,
//           child: GraphView(
//             graph: graph,
//             algorithm: BuchheimWalkerAlgorithm(builder, ArrowEdgeRenderer()), // ✅ Arrows
//             paint: Paint()
//               ..color = Colors.brown
//               ..strokeWidth = 2
//               ..style = PaintingStyle.stroke
//               ..strokeCap = StrokeCap.round,
//             builder: (Node node) {
//               return node.data as Widget; // ✅ Access the widget
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }


