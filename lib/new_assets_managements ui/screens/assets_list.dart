
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../screens/hrms_screens/add_new_assets.dart';
import '../dialog/add_new_assets.dart';
import '../dialog/checkout.dart';
import '../dialog/update_assets.dart';

class Asset {
  // Existing fields (kept for compatibility)
  final String id; // internal/db id if present
  final String assetTagId;
  final String description;
  final String purchaseDate;
  final String purchasedFrom;
  final String cost;
  final String site;
  final String location;
  final String category;
  final String department;
  final String assignedTo;
  final String dateCreated;
  final String status;
  final String createdBy;
  final String subCategory;
  final String employeeName;
  final String model;

  // New fields from your API sample
  final String brand;
  final String serialNumber;
  final String processor;
  final String processorGeneration;
  final String totalRam;
  final String ram1Size;
  final String ram1Brand;
  final String ram2Size;
  final String ram2Brand;
  final String warrantyStart;
  final String warrantyMonth;
  final String warrantyExpire;
  final String deviceId;
  final String chargerSerialNumber;
  final String bagGiven;
  final String keyboardGiven;
  final String mouseGiven;

  Asset({
    required this.id,
    required this.assetTagId,
    required this.description,
    required this.purchaseDate,
    required this.purchasedFrom,
    required this.cost,
    required this.site,
    required this.location,
    required this.category,
    required this.department,
    required this.assignedTo,
    required this.dateCreated,
    required this.status,
    required this.createdBy,
    required this.subCategory,
    required this.employeeName,
    required this.model,
    required this.brand,
    required this.serialNumber,
    required this.processor,
    required this.processorGeneration,
    required this.totalRam,
    required this.ram1Size,
    required this.ram1Brand,
    required this.ram2Size,
    required this.ram2Brand,
    required this.warrantyStart,
    required this.warrantyMonth,
    required this.warrantyExpire,
    required this.deviceId,
    required this.chargerSerialNumber,
    required this.bagGiven,
    required this.keyboardGiven,
    required this.mouseGiven,
  });

  // Helper to read a value by trying multiple keys (handles case/space variants)
  static String _v(Map<String, dynamic> j, List<String> keys, [String def = '']) {
    for (final k in keys) {
      if (j.containsKey(k) && j[k] != null) {
        final v = j[k];
        if (v is String) return v;
        return v.toString();
      }
    }
    return def;
  }

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      // keep backend/internal id if present (don’t map Serial Number into id!)
      id: _v(json, ['id', '_id']),

      // Tag / Asset Tag
      assetTagId: _v(json, ['Asset Tag ID', 'Tag ID', 'assetTagId', 'asset_tag_id']),

      // Description(s)
      description: _v(json, ['Description', 'Descriptions', 'description']),

      // Purchase
      purchaseDate: _v(json, ['Purchase Date', 'purchaseDate']),
      purchasedFrom: _v(json, ['Purchased from', 'Purchased From', 'purchasedFrom']),
      cost: _v(json, ['Cost', 'cost']),

      // Location-ish
      site: _v(json, ['Site', 'site']),
      location: _v(json, ['Location', 'location']),

      // Categories
      category: _v(json, ['Category', 'category']),
      subCategory: _v(json, ['Sub-Category', 'Sub Category', 'subCategory']),

      // People / Dept
      department: _v(json, ['Department', 'department']),
      assignedTo: _v(json, ['Assigned to', 'Assigned To', 'assignedTo']),
      employeeName: _v(json, ['Employee Name', 'employeeName']),

      // Meta
      dateCreated: _v(json, ['Date Created', 'dateCreated']),
      status: _v(json, ['Status', 'status']),
      createdBy: _v(json, ['Created by', 'Created By', 'createdBy']),

      // Device
      model: _v(json, ['Model', 'model']),
      brand: _v(json, ['Brand', 'brand']),
      serialNumber: _v(json, ['Serial Number', 'serialNumber']),

      // Specs
      processor: _v(json, ['Processor', 'processor']),
      processorGeneration: _v(json, ['Processor Generation', 'processorGeneration']),
      totalRam: _v(json, ['Total RAM', 'totalRam']),
      ram1Size: _v(json, ['RAM1 Size', 'ram1Size']),
      ram1Brand: _v(json, ['RAM1 Brand', 'ram1Brand']),
      ram2Size: _v(json, ['RAM2 Size', 'ram2Size']),
      ram2Brand: _v(json, ['RAM2 Brand', 'ram2Brand']),

      // Warranty
      warrantyStart: _v(json, ['Warranty Start', 'warrantyStart']),
      warrantyMonth: _v(json, ['Warranty Month', 'warrantyMonth']),
      warrantyExpire: _v(json, ['Warranty Expire', 'warrantyExpire']),

      // Other
      deviceId: _v(json, ['Device ID', 'deviceId']),
      chargerSerialNumber: _v(json, ['Charger Serial Number', 'chargerSerialNumber']),
      bagGiven: _v(json, ['Bag Given', 'bagGiven']),
      keyboardGiven: _v(json, ['Keyboard Given', 'keyboardGiven']),
      mouseGiven: _v(json, ['Mouse Given', 'mouseGiven']),
    );
  }
}

class AssetListScreen extends StatefulWidget {
  const AssetListScreen({Key? key}) : super(key: key);
  static const routeName = '/asset-list';

  @override
  State<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends State<AssetListScreen> {
  List<Asset> assets = [];
  List<Asset> filteredAssets = [];

  bool isLoading = true;
  String? errorMessage;

  // search + filters
  String searchQuery = '';
  String filterAssignedTo = 'All';
  String filterStatus = 'All';
  String filterCategory = 'All';
  String filterDepartment = 'All';

  List<String> assignedToOptions = ['All'];
  List<String> statusOptions = ['All'];
  List<String> categoryOptions = ['All'];
  List<String> departmentOptions = ['All'];

  // sorting
  int? sortColumnIndex;
  bool sortAscending = true;

  // pagination
  int _rowsPerPage = 10;
  int _page = 0;
  final List<int> _rowsPerPageOptions = const [10, 25, 50, 100];

  @override
  void initState() {
    super.initState();
    fetchAssets();
  }

  Future<void> fetchAssets() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        'https://thrive-assetsmanagements.onrender.com/api/assetmanagements',
      );

      if (response.statusCode == 200) {
        final body = response.data;

        // Support both: direct list OR wrapped { data: [...] }
        List<dynamic> list;
        if (body is List) {
          list = body;
        } else if (body is Map && body['data'] is List) {
          list = body['data'];
        } else {
          throw 'Unexpected response format';
        }

        assets = list.map<Asset>((e) => Asset.fromJson(Map<String, dynamic>.from(e))).toList();

        // build filter options
        assignedToOptions = ['All'];
        statusOptions = ['All'];
        categoryOptions = ['All'];
        departmentOptions = ['All'];

        for (final a in assets) {
          if (a.assignedTo.isNotEmpty && !assignedToOptions.contains(a.assignedTo)) {
            assignedToOptions.add(a.assignedTo);
          }
          if (a.status.isNotEmpty && !statusOptions.contains(a.status)) {
            statusOptions.add(a.status);
          }
          if (a.category.isNotEmpty && !categoryOptions.contains(a.category)) {
            categoryOptions.add(a.category);
          }
          if (a.department.isNotEmpty && !departmentOptions.contains(a.department)) {
            departmentOptions.add(a.department);
          }
        }

        applyFilters(resetPage: true);
      } else {
        errorMessage = 'Failed to load assets: ${response.statusMessage}';
      }
    } catch (e) {
      errorMessage = 'Error fetching assets: $e';
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteAsset(String id) async {
    try {
      var dio = Dio();
      var response = await dio.delete(
        "https://thrive-assetsmanagements.onrender.com/api/assetmanagements/delete/$id",
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Asset deleted successfully")),
        );
        fetchAssets(); // 🔥 refresh list after delete
      }
    } catch (e) {
      print("Error deleting asset: $e");
    }
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Asset"),
        content: const Text("Are you sure you want to delete this asset?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              await deleteAsset(id);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void applyFilters({bool resetPage = false}) {
    filteredAssets = assets.where((asset) {
      final q = searchQuery.toLowerCase();

      final matchesSearch = q.isEmpty ||
          asset.assetTagId.toLowerCase().contains(q) ||
          asset.model.toLowerCase().contains(q) ||
          asset.category.toLowerCase().contains(q) ||
          asset.subCategory.toLowerCase().contains(q) ||
          asset.brand.toLowerCase().contains(q) ||
          asset.serialNumber.toLowerCase().contains(q);

      final matchesAssignedTo = filterAssignedTo == 'All' || asset.assignedTo == filterAssignedTo;
      final matchesStatus = filterStatus == 'All' || asset.status == filterStatus;
      final matchesCategory = filterCategory == 'All' || asset.category == filterCategory;
      final matchesDepartment = filterDepartment == 'All' || asset.department == filterDepartment;

      return matchesSearch &&
          matchesAssignedTo &&
          matchesStatus &&
          matchesCategory &&
          matchesDepartment;
    }).toList();

    // apply current sorting again on filtered list
    if (sortColumnIndex != null) {
      _applySortForIndex(sortColumnIndex!, sortAscending, setStateCall: false);
    }

    if (resetPage) _page = 0;
    // clamp page if needed
    final totalPages = (_safeDivCeil(filteredAssets.length, _rowsPerPage)).clamp(1, 1 << 31);
    if (_page > totalPages - 1) _page = totalPages - 1;
    if (_page < 0) _page = 0;

    setState(() {});
  }

  int _safeDivCeil(int a, int b) {
    if (b <= 0) return 0;
    if (a == 0) return 0;
    return ((a - 1) ~/ b) + 1;
  }

  List<Asset> get _currentPageItems {
    if (filteredAssets.isEmpty) return const [];
    final start = _page * _rowsPerPage;
    final end = (start + _rowsPerPage) > filteredAssets.length
        ? filteredAssets.length
        : (start + _rowsPerPage);
    if (start >= filteredAssets.length) return const [];
    return filteredAssets.sublist(start, end);
  }

  void _sort<T>(
      Comparable<T> Function(Asset a) getField,
      int columnIndex,
      bool ascending,
      ) {
    filteredAssets.sort((a, b) {
      final aVal = getField(a);
      final bVal = getField(b);
      final cmp = Comparable.compare(aVal, bVal);
      return ascending ? cmp : -cmp;
    });

    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
      _page = 0; // reset to first page after sort
    });
  }

  // Helper to reapply same sort programmatically (e.g., after filters)
  void _applySortForIndex(int columnIndex, bool ascending, {bool setStateCall = true}) {
    switch (columnIndex) {
      case 0: // STATUS
        filteredAssets.sort((a, b) =>
        ascending ? a.status.toLowerCase().compareTo(b.status.toLowerCase())
            : b.status.toLowerCase().compareTo(a.status.toLowerCase()));
        break;
      case 1: // ASSET TAG ID
        filteredAssets.sort((a, b) =>
        ascending ? a.assetTagId.toLowerCase().compareTo(b.assetTagId.toLowerCase())
            : b.assetTagId.toLowerCase().compareTo(a.assetTagId.toLowerCase()));
        break;
      case 2: // MODEL
        filteredAssets.sort((a, b) =>
        ascending ? a.model.toLowerCase().compareTo(b.model.toLowerCase())
            : b.model.toLowerCase().compareTo(a.model.toLowerCase()));
        break;
      case 3: // CATEGORY
        filteredAssets.sort((a, b) =>
        ascending ? a.category.toLowerCase().compareTo(b.category.toLowerCase())
            : b.category.toLowerCase().compareTo(a.category.toLowerCase()));
        break;
      case 4: // SUB CATEGORY
        filteredAssets.sort((a, b) =>
        ascending ? a.subCategory.toLowerCase().compareTo(b.subCategory.toLowerCase())
            : b.subCategory.toLowerCase().compareTo(a.subCategory.toLowerCase()));
        break;
      case 5: // LOCATION
        filteredAssets.sort((a, b) =>
        ascending ? a.location.toLowerCase().compareTo(b.location.toLowerCase())
            : b.location.toLowerCase().compareTo(a.location.toLowerCase()));
        break;
      case 6: // SITE
        filteredAssets.sort((a, b) =>
        ascending ? a.site.toLowerCase().compareTo(b.site.toLowerCase())
            : b.site.toLowerCase().compareTo(a.site.toLowerCase()));
        break;
      case 7: // ASSIGNED TO
        filteredAssets.sort((a, b) =>
        ascending ? a.assignedTo.toLowerCase().compareTo(b.assignedTo.toLowerCase())
            : b.assignedTo.toLowerCase().compareTo(a.assignedTo.toLowerCase()));
        break;
      case 8: // DEPARTMENT
        filteredAssets.sort((a, b) =>
        ascending ? a.department.toLowerCase().compareTo(b.department.toLowerCase())
            : b.department.toLowerCase().compareTo(a.department.toLowerCase()));
        break;
      default:
        break;
    }
    if (setStateCall) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final total = filteredAssets.length;
    final start = total == 0 ? 0 : (_page * _rowsPerPage) + 1;
    final end = total == 0
        ? 0
        : ((_page * _rowsPerPage + _rowsPerPage) > total
        ? total
        : (_page * _rowsPerPage + _rowsPerPage));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(child: Text(errorMessage!))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Asset Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const AddNewAssetForm(),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Asset'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Track and manage all your company assets',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Filters row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText:
                      'Search assets by name, tag ID, model, serial, brand...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12,
                      ),
                    ),
                    onChanged: (value) {
                      searchQuery = value;
                      applyFilters(resetPage: true);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: filterAssignedTo.isEmpty || filterAssignedTo == 'All'
                            ? null
                            : filterAssignedTo,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        hint: const Text("Select Assigned To",
                            style: TextStyle(color: Colors.grey)),
                        items: assignedToOptions
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child:
                            Text(e, overflow: TextOverflow.ellipsis),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          filterAssignedTo = value ?? 'All';
                          applyFilters(resetPage: true);
                        },
                      ),
                      if (filterAssignedTo.isNotEmpty &&
                          filterAssignedTo != 'All')
                        Positioned(
                          right: 36,
                          child: GestureDetector(
                            onTap: () {
                              filterAssignedTo = 'All';
                              applyFilters(resetPage: true);
                            },
                            child: const Icon(Icons.clear,
                                size: 20, color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: filterStatus.isEmpty || filterStatus == 'All'
                            ? null
                            : filterStatus,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        hint: const Text("Select Status",
                            style: TextStyle(color: Colors.grey)),
                        items: statusOptions
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child:
                            Text(e, overflow: TextOverflow.ellipsis),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          filterStatus = value ?? 'All';
                          applyFilters(resetPage: true);
                        },
                      ),
                      if (filterStatus.isNotEmpty &&
                          filterStatus != 'All')
                        Positioned(
                          right: 36,
                          child: GestureDetector(
                            onTap: () {
                              filterStatus = 'All';
                              applyFilters(resetPage: true);
                            },
                            child: const Icon(Icons.clear,
                                size: 20, color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: filterCategory.isEmpty ||
                            filterCategory == 'All'
                            ? null
                            : filterCategory,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        hint: const Text("Select Category",
                            style: TextStyle(color: Colors.grey)),
                        items: categoryOptions
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child:
                            Text(e, overflow: TextOverflow.ellipsis),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          filterCategory = value ?? 'All';
                          applyFilters(resetPage: true);
                        },
                      ),
                      if (filterCategory.isNotEmpty &&
                          filterCategory != 'All')
                        Positioned(
                          right: 36,
                          child: GestureDetector(
                            onTap: () {
                              filterCategory = 'All';
                              applyFilters(resetPage: true);
                            },
                            child: const Icon(Icons.clear,
                                size: 20, color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: filterDepartment.isEmpty ||
                            filterDepartment == 'All'
                            ? null
                            : filterDepartment,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        hint: const Text("Select Department",
                            style: TextStyle(color: Colors.grey)),
                        items: departmentOptions
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child:
                            Text(e, overflow: TextOverflow.ellipsis),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          filterDepartment = value ?? 'All';
                          applyFilters(resetPage: true);
                        },
                      ),
                      if (filterDepartment.isNotEmpty &&
                          filterDepartment != 'All')
                        Positioned(
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              filterDepartment = 'All';
                              applyFilters(resetPage: true);
                            },
                            child: const Icon(Icons.clear,
                                size: 20, color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // rows-per-page + count
            Row(
              children: [
                const Text('Rows per page:'),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _rowsPerPage,
                  items: _rowsPerPageOptions
                      .map((e) => DropdownMenuItem<int>(
                    value: e,
                    child: Text('$e'),
                  ))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _rowsPerPage = v;
                      _page = 0;
                    });
                  },
                ),
                const Spacer(),
                Text('Showing $start–$end of $total'),
              ],
            ),
            const SizedBox(height: 8),

            // Table
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ConstrainedBox(
                      constraints:
                      BoxConstraints(minWidth: constraints.maxWidth),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: FittedBox(
                          alignment: Alignment.topLeft,
                          fit: BoxFit.scaleDown,
                          child: DataTable(
                            sortColumnIndex: sortColumnIndex,
                            sortAscending: sortAscending,
                            columnSpacing: 57,
                            dataRowHeight: 40,
                            headingRowHeight: 45,
                            columns: [
                              DataColumn(
                                label: const Text('STATUS'),
                                onSort: (i, asc) {
                                  sortColumnIndex = i;
                                  sortAscending = asc;
                                  _applySortForIndex(i, asc);
                                },
                              ),
                              DataColumn(
                                label: const Text('ASSET TAG ID'),
                                onSort: (i, asc) =>
                                    _sort((a) => a.assetTagId.toLowerCase(), i, asc),
                              ),
                              DataColumn(
                                label: const Text('MODEL'),
                                onSort: (i, asc) =>
                                    _sort((a) => a.model.toLowerCase(), i, asc),
                              ),
                              DataColumn(
                                label: const Text('CATEGORY'),
                                onSort: (i, asc) =>
                                    _sort((a) => a.category.toLowerCase(), i, asc),
                              ),
                              DataColumn(
                                label: const Text('SUB CATEGORY'),
                                onSort: (i, asc) =>
                                    _sort((a) => a.subCategory.toLowerCase(), i, asc),
                              ),
                              DataColumn(
                                label: const Text('LOCATION'),
                                onSort: (i, asc) =>
                                    _sort((a) => a.location.toLowerCase(), i, asc),
                              ),
                              DataColumn(
                                label: const Text('SITE'),
                                onSort: (i, asc) =>
                                    _sort((a) => a.site.toLowerCase(), i, asc),
                              ),
                              DataColumn(
                                label: const Text('ASSIGNED TO'),
                                onSort: (i, asc) =>
                                    _sort((a) => a.assignedTo.toLowerCase(), i, asc),
                              ),
                              DataColumn(
                                label: const Text('DEPARTMENT'),
                                onSort: (i, asc) =>
                                    _sort((a) => a.department.toLowerCase(), i, asc),
                              ),
                              const DataColumn(label: Text('ACTIONS')),
                            ],
                            rows: _currentPageItems.map((asset) {
                              return DataRow(
                                cells: [
                                  DataCell(_buildStatusBadge(asset.status)),
                                  DataCell(
                                    Text(
                                      asset.assetTagId.length > 5
                                          ? asset.assetTagId.substring(0, 5)
                                          : asset.assetTagId,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      asset.model.length > 20
                                          ? asset.model.substring(0, 20)
                                          : asset.model,
                                    ),
                                  ),
                                  DataCell(Text(asset.category)),
                                  DataCell(Text(asset.subCategory)),
                                  DataCell(Text(asset.location)),
                                  DataCell(Text(asset.site)),
                                  DataCell(
                                    Text(
                                      asset.assignedTo.isEmpty
                                          ? 'Unassigned'
                                          : asset.assignedTo,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      asset.department.length > 30
                                          ? asset.department.substring(0, 30)
                                          : asset.department,
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        if (asset.status.toLowerCase() ==
                                            'checked out')
                                          IconButton(
                                            icon: const Icon(
                                              Icons
                                                  .arrow_circle_left_outlined,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                              _showCheckInConfirmation(
                                                  asset.id);
                                            },
                                          ),
                                        if (asset.status.toLowerCase() ==
                                            'available')
                                          IconButton(
                                            icon: const Icon(
                                              Icons
                                                  .arrow_circle_right_outlined,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              _showCheckoutDialog(asset);
                                            },
                                          ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            _showAssetDetailsDialog(asset);
                                          },
                                        ),

                                        // IconButton(
                                        //   icon: const Icon(Icons.edit, color: Colors.blue),
                                        //   onPressed: () {
                                        //     print("Assets ID: ${asset.id}");
                                        //     print("Assets Category: ${asset.category}");
                                        //     print("Assets Sub_ Category: ${asset.subCategory}");
                                        //
                                        //
                                        //     showDialog(
                                        //       context: context,
                                        //       barrierDismissible: false,
                                        //       builder: (context) => const Updatye_AssetForm(),
                                        //     );
                                        //   },
                                        // ),

                              IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteDialog(asset.id),)


                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Pagination controls
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'First page',
                  onPressed: _page > 0
                      ? () => setState(() => _page = 0)
                      : null,
                  icon: const Icon(Icons.first_page),
                ),
                IconButton(
                  tooltip: 'Previous page',
                  onPressed: _page > 0
                      ? () => setState(() => _page -= 1)
                      : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                Text('Page ${_page + 1} / '
                    '${(_safeDivCeil(filteredAssets.length, _rowsPerPage)).clamp(1, 1 << 31)}'),
                IconButton(
                  tooltip: 'Next page',
                  onPressed: ((_page + 1) * _rowsPerPage) <
                      filteredAssets.length
                      ? () => setState(() => _page += 1)
                      : null,
                  icon: const Icon(Icons.chevron_right),
                ),
                IconButton(
                  tooltip: 'Last page',
                  onPressed: filteredAssets.isEmpty
                      ? null
                      : () => setState(() => _page =
                      _safeDivCeil(filteredAssets.length, _rowsPerPage) -
                          1),
                  icon: const Icon(Icons.last_page),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    IconData iconData;

    switch (status.toLowerCase()) {
      case 'available':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        iconData = Icons.check_circle;
        break;
      case 'assigned':
      case 'checked out':
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        iconData = Icons.person;
        break;
      case 'maintenance':
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        iconData = Icons.error;
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
        iconData = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            status.isEmpty ? '—' : status,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  void _showAssetDetailsDialog(Asset asset) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            width: 700,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Asset Details',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      _buildStatusBadge(asset.status),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Icon + Basic ID
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.computer, color: Colors.white, size: 48),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              asset.assetTagId.isEmpty ? '(No Tag)' : asset.assetTagId,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(asset.model, style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Basic Information
                  const Text(
                    'Basic Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('Brand', asset.brand),
                  _buildInfoRow('Model', asset.model),
                  _buildInfoRow('Serial Number', asset.serialNumber),
                  _buildInfoRow('Category', asset.category),
                  _buildInfoRow('Sub Category', asset.subCategory),
                  _buildInfoRow('Description', asset.description),

                  const SizedBox(height: 16),

                  // Specifications
                  const Text(
                    'Specifications',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('Processor', asset.processor),
                  _buildInfoRow('Processor Generation', asset.processorGeneration),
                  _buildInfoRow('Total RAM', asset.totalRam),
                  _buildInfoRow('RAM1 Size', asset.ram1Size),
                  _buildInfoRow('RAM1 Brand', asset.ram1Brand),
                  _buildInfoRow('RAM2 Size', asset.ram2Size),
                  _buildInfoRow('RAM2 Brand', asset.ram2Brand),

                  const SizedBox(height: 16),

                  // Location & Assignment
                  const Text(
                    'Location & Assignment',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('Site', asset.site),
                  _buildInfoRow('Location', asset.location),
                  _buildInfoRow('Department', asset.department),
                  _buildInfoRow('Assigned To', asset.assignedTo.isEmpty ? 'Unassigned' : asset.assignedTo),

                  const SizedBox(height: 16),

                  // Warranty
                  const Text(
                    'Warranty Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('Warranty Start', asset.warrantyStart),
                  _buildInfoRow('Warranty Period (months)', asset.warrantyMonth),
                  _buildInfoRow('Warranty Expires', asset.warrantyExpire),

                  const SizedBox(height: 16),

                  // Purchase
                  const Text(
                    'Purchase & Other Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('Purchase Date', asset.purchaseDate),
                  _buildInfoRow('Purchased From', asset.purchasedFrom),
                  _buildInfoRow('Cost', asset.cost),
                  _buildInfoRow('Created By', asset.createdBy),
                  _buildInfoRow('Date Created', asset.dateCreated),
                  _buildInfoRow('Device ID', asset.deviceId),
                  _buildInfoRow('Charger Serial Number', asset.chargerSerialNumber),
                  _buildInfoRow('Bag Given', asset.bagGiven),
                  _buildInfoRow('Keyboard Given', asset.keyboardGiven),
                  _buildInfoRow('Mouse Given', asset.mouseGiven),

                  const SizedBox(height: 24),

                  // Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (asset.status.toLowerCase() == 'available')
                        ElevatedButton(
                          onPressed: () {
                            _showCheckoutDialog(asset);
                          },
                          child: const Text('Assign'),
                        ),
                      if (asset.status.toLowerCase() == 'checked out')
                        ElevatedButton(
                          onPressed: () {
                            _showCheckInConfirmation(asset.id);
                          },
                          child: const Text('Check In'),
                        ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCheckoutDialog(Asset asset) {
    showDialog(
      context: context,
      builder: (context) {
        return CheckoutDialog(asset: asset);
      },
    );
  }

  void _showCheckInConfirmation(String assetId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Check In Asset'),
          content: const Text('Are you sure you want to check in this asset?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _checkInAsset(assetId);
              },
              child: const Text('Yes, Check In'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkInAsset(String assetId) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final data = json.encode({"assetId": assetId});

      final dio = Dio();
      final response = await dio.request(
        'https://thrive-assetsmanagements.onrender.com/api/assetmanagements/checkin',
        options: Options(method: 'POST', headers: headers),
        data: data,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Asset checked in successfully!')),
        );
        fetchAssets(); // refresh after check-in
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusMessage}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
