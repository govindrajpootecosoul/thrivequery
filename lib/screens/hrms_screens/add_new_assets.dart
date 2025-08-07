/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddNewAssetScreen extends StatefulWidget {
  const AddNewAssetScreen({Key? key}) : super(key: key);

  @override
  State<AddNewAssetScreen> createState() => _AddNewAssetScreenState();
}

class _AddNewAssetScreenState extends State<AddNewAssetScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedCategory = 'Computer Assets';
  String? selectedSubCategory;
  String? selectedSite;
  String? selectedLocation;
  String? selectedStatus;

  bool showSubCategoryDetails = false;

  final Map<String, List<String>> subCategoriesMap = {
    'Computer Assets': ['Laptop', 'Desktop'],
    'External Equipment': ['Bag', 'Charger', 'Keyboard', 'LCD-Monitors', 'Mouse'],
  };

  final List<String> departments = [
    'Business Analyst',
    'Business Strategy',
    'Data Analytics',
    'Digital Marketing',
    'E-commerce',
    'External Equipment',
    'Finance & Accounts',
    'Human Resources and Administration',
    'India E-commerce',
    'India- Retail Sales',
    'NA',
    'New Product Design',
    'Retail Ecom',
    'Supply Chain-Operations',
    'Zonal Sales (India)',
  ];

  final List<String> sites = ['Head Office', 'India', 'USA'];

  final List<String> locations = [
    'California',
    'Bangalore',
    'Corporate',
    'East Delhi',
    'Ghaziabad',
    'Jammu and Kashmir',
    'MJN',
    'Mumbai',
    'Nashik',
    'Noida- Warehouse',
    'North Delhi'
  ];



  final Map<String, Map<String, String>> assetTagIdMap = {
    'Computer Assets': {
      'Laptop': 'CA-LAP',
      'Desktop': 'CA-DESK',
    },
    'External Equipment': {
      'Bag': 'EE-BAG',
      'Charger': 'EE-CHG',
      'Keyboard': 'EE-KBD',
      'LCD-Monitors': 'EE-LCD',
      'Mouse': 'EE-MSE',
    },
  };


  final List<String> statuses = ['Available', 'Under Repair', 'In Use', 'Scrapped'];

  final TextEditingController assetTagIdController = TextEditingController();
  final TextEditingController assetBrandController = TextEditingController();
  final TextEditingController serialNoController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController systemProcessorController = TextEditingController();
  final TextEditingController processorGenerationController = TextEditingController();
  final TextEditingController deviceIdController = TextEditingController();
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController totalRamController = TextEditingController();
  final TextEditingController ram1Controller = TextEditingController();
  final TextEditingController ram2Controller = TextEditingController();
  final TextEditingController chargerSerialNumberController = TextEditingController();
  final TextEditingController warrantyStartDateController = TextEditingController();
  final TextEditingController warrantyMonthController = TextEditingController();
  final TextEditingController warrantyExpirationDateController = TextEditingController();
  final TextEditingController warrantyNotesController = TextEditingController();

  // External Equipment Fields
  final TextEditingController desktopScreenBrandController = TextEditingController();
  final TextEditingController lcdMonitorBrandController = TextEditingController();
  final TextEditingController lcdSerialNumberController = TextEditingController();
  final TextEditingController bagGivenController = TextEditingController();
  final TextEditingController keyboardGivenController = TextEditingController();
  final TextEditingController newChargerSerialNoController = TextEditingController();
  final TextEditingController mouseGivenController = TextEditingController();

  Widget buildDropdown(String label, String? value, ValueChanged<String?> onChanged, List<String> items) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4 - 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            decoration: InputDecoration(
              fillColor: Colors.green.shade50,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
          ),
        ],
      ),
    );
  }
  Widget buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4 - 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              fillColor: Colors.orange.shade50,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildReadOnlyTextField(String label, TextEditingController controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4 - 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              fillColor: Colors.grey.shade300,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }


  void _handleSubmit() async {
    print("Category: $selectedCategory");
    print("Sub Category: $selectedSubCategory");
    print("Asset Tag ID: ${assetTagIdController.text}");
    print("Site: $selectedSite");
    print("Location: $selectedLocation");
    print("Status: $selectedStatus");

    print("External Equipment Fields:");
    print("Desktop Screen Brand: ${desktopScreenBrandController.text}");
    print("Serial No: ${serialNoController.text}");
    print("LCD Monitor Brand: ${lcdMonitorBrandController.text}");
    print("LCD Serial Number: ${lcdSerialNumberController.text}");
    print("Bag Given: ${bagGivenController.text}");
    print("Keyboard Given: ${keyboardGivenController.text}");
    print("New Charger Serial No: ${newChargerSerialNoController.text}");
    print("Mouse Given: ${mouseGivenController.text}");

    print("Computer Asset Fields:");
    print("Asset Brand: ${assetBrandController.text}");
    print("Serial No: ${serialNoController.text}");
    print("Model: ${modelController.text}");
    print("Description: ${descriptionController.text}");
    print("System Processor: ${systemProcessorController.text}");
    print("Processor Generation: ${processorGenerationController.text}");
    print("Device ID: ${deviceIdController.text}");
    print("Product ID: ${productIdController.text}");
    print("Total RAM: ${totalRamController.text}");
    print("RAM1: ${ram1Controller.text}");
    print("RAM2: ${ram2Controller.text}");
    print("Charger Serial No: ${chargerSerialNumberController.text}");
    print("Warranty Start Date: ${warrantyStartDateController.text}");
    print("Warranty Month: ${warrantyMonthController.text}");
    print("Warranty Expiration Date: ${warrantyExpirationDateController.text}");
    print("Warranty Notes: ${warrantyNotesController.text}");

    final data = {
      "Category": selectedCategory,
      "Sub Category": selectedSubCategory,
      "Asset Tag ID": assetTagIdController.text,
      "Site": selectedSite,
      "Location": selectedLocation,
      "Status": selectedStatus,

      // External Equipment fields
      "Desktop Screen Brand": desktopScreenBrandController.text,
      "LCD Monitor Brand": lcdMonitorBrandController.text,
      "LCD Serial Number": lcdSerialNumberController.text,
      "Bag Given": bagGivenController.text,
      "Keyboard Given": keyboardGivenController.text,
      "New Charger Serial No": newChargerSerialNoController.text,
      "Mouse Given": mouseGivenController.text,

      // Computer Asset fields
      "Serial No": serialNoController.text,
      "Asset Brand": assetBrandController.text,

      "Model": modelController.text,
      "Description": descriptionController.text,
      "System Processor": systemProcessorController.text,
      "Processor Generation": processorGenerationController.text,
      "Device ID": deviceIdController.text,
      "Product ID": productIdController.text,
      "Total RAM": totalRamController.text,
      "RAM1": ram1Controller.text,
      "RAM2": ram2Controller.text,
      "Charger Serial No": chargerSerialNumberController.text,
      "Warranty Start Date": warrantyStartDateController.text,
      "Warranty Month": warrantyMonthController.text,
      "Warranty Expiration Date": warrantyExpirationDateController.text,
      "Warranty Notes": warrantyNotesController.text,
    };

    try {
      final url = Uri.parse('http://192.168.50.92:5300/api/assetmanagements/upload');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Data uploaded successfully");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Form submitted successfully!")),
        );
        _formKey.currentState?.reset();
      } else {
        print("❌ Failed to upload: ${response.statusCode} - ${response.reasonPhrase}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error occurred while submitting.")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final List<String> subCategoryOptions = selectedCategory != null && subCategoriesMap.containsKey(selectedCategory!)
        ? List<String>.from(subCategoriesMap[selectedCategory!]!)
        : <String>[];

    return Scaffold(
      backgroundColor: const Color(0xFFDFDBD2),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Add New Asset", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 20,
                        runSpacing: 16,
                        children: [
                          buildDropdown(
                            'Categories',
                            selectedCategory,
                                (val) {
                              setState(() {
                                selectedCategory = val;
                                selectedSubCategory = null; // 🔄 Reset on category change
                                assetTagIdController.clear();
                                showSubCategoryDetails = false;
                              });
                            },
                            List<String>.from(subCategoriesMap.keys.toList()),
                          ),

                          // buildDropdown('Sub Categories', selectedSubCategory, (val) => setState(() => selectedSubCategory = val), subCategoryOptions),


                          buildDropdown(
                            'Sub Categories',
                            subCategoryOptions.contains(selectedSubCategory) ? selectedSubCategory : null,
                                (val) {
                              setState(() {
                                selectedSubCategory = val;
                                if (selectedCategory != null &&
                                    val != null &&
                                    assetTagIdMap.containsKey(selectedCategory!) &&
                                    assetTagIdMap[selectedCategory!]!.containsKey(val)) {
                                  assetTagIdController.text = assetTagIdMap[selectedCategory!]![val]!;
                                } else {
                                  assetTagIdController.clear();
                                }
                              });
                            },
                            subCategoryOptions,
                          ),

                          buildReadOnlyTextField('Asset Tag ID', assetTagIdController),
                          buildDropdown('Sites', selectedSite, (val) => setState(() => selectedSite = val), sites),
                          buildDropdown('Location', selectedLocation, (val) => setState(() => selectedLocation = val), locations),


                          buildDropdown('Status', selectedStatus, (val) => setState(() => selectedStatus = val), statuses),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => setState(() => showSubCategoryDetails = !showSubCategoryDetails),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Sub-Category Information - (Asset Type)", style: TextStyle(fontWeight: FontWeight.bold)),
                              Icon(Icons.arrow_drop_down_circle)
                            ],
                          ),
                        ),
                      ),
                      if (showSubCategoryDetails) ...[
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 20,
                          runSpacing: 16,
                          children: selectedCategory == 'External Equipment'
                              ? [
                            buildTextField('Desktop Screen Brand', desktopScreenBrandController),
                            buildTextField('Serial No', serialNoController),
                            buildTextField('LCD- Monitor Brand', lcdMonitorBrandController),
                            buildTextField('LCD- Serial Number', lcdSerialNumberController),
                            buildTextField('Bag Given', bagGivenController),
                            buildTextField('Keyboard Given', keyboardGivenController),
                            buildTextField('New Charger Serial No.', newChargerSerialNoController),
                            buildTextField('Mouse Given', mouseGivenController),
                          ]
                              : [
                            buildTextField('Asset Brand', assetBrandController),
                            buildTextField('Serial No', serialNoController),
                            buildTextField('Model (DMI System Information)', modelController),
                            buildTextField('Description', descriptionController),
                            buildTextField('System Processor', systemProcessorController),
                            buildTextField('Processor Generation', processorGenerationController),
                            buildTextField('Device ID', deviceIdController),
                            buildTextField('Product ID', productIdController),
                            buildTextField('Total RAM Nos.', totalRamController),
                            buildTextField('RAM 1 Size & Brand', ram1Controller),
                            buildTextField('RAM 2 Size & Brand', ram2Controller),
                            buildTextField('Charger Serial Number', chargerSerialNumberController),
                            buildTextField('Warranty Start Date', warrantyStartDateController),
                            buildTextField('Warranty Month', warrantyMonthController),
                            buildTextField('Warranty Expiration Date', warrantyExpirationDateController),
                            buildTextField('Warranty Notes', warrantyNotesController),
                          ],
                        )
                      ],
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            ),
                            onPressed: () {
                              setState(() => showSubCategoryDetails = false);
                              _formKey.currentState?.reset();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Form cleared!")),
                              );
                            },
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF103C3F),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            ),
                            onPressed: _handleSubmit,
                            child: const Text("Submit"),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/



import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddNewAssetScreen extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? assetData;

  const AddNewAssetScreen({
    super.key,
    this.isEdit = false,
    this.assetData,
  });

  @override
  State<AddNewAssetScreen> createState() => _AddNewAssetScreenState();
}

class _AddNewAssetScreenState extends State<AddNewAssetScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedSite;
  String? selectedLocation;
  String? selectedStatus;

  bool showSubCategoryDetails = false;

  final Map<String, List<String>> subCategoriesMap = {
    'Computer Assets': ['Laptop', 'Desktop'],
    'External Equipment': ['Bag', 'Charger', 'Keyboard', 'LCD-Monitors', 'Mouse'],
  };

  final List<String> departments = [
    'Business Analyst',
    'Business Strategy',
    'Data Analytics',
    'Digital Marketing',
    'E-commerce',
    'External Equipment',
    'Finance & Accounts',
    'Human Resources and Administration',
    'India E-commerce',
    'India- Retail Sales',
    'NA',
    'New Product Design',
    'Retail Ecom',
    'Supply Chain-Operations',
    'Zonal Sales (India)',
  ];

  final List<String> sites = ['Head Office', 'India', 'USA'];

  final List<String> locations = [
    'California',
    'Bangalore',
    'Corporate',
    'East Delhi',
    'Ghaziabad',
    'Jammu and Kashmir',
    'MJN',
    'Mumbai',
    'Nashik',
    'Noida- Warehouse',
    'North Delhi'
  ];

  final Map<String, Map<String, String>> assetTagIdMap = {
    'Computer Assets': {
      'Laptop': 'CA-LAP',
      'Desktop': 'CA-DESK',
    },
    'External Equipment': {
      'Bag': 'EE-BAG',
      'Charger': 'EE-CHG',
      'Keyboard': 'EE-KBD',
      'LCD-Monitors': 'EE-LCD',
      'Mouse': 'EE-MSE',
    },
  };

  final List<String> statuses = ['Available', 'Under Repair', 'In Use', 'Scrapped'];

  final TextEditingController assetTagIdController = TextEditingController();
  final TextEditingController assetBrandController = TextEditingController();
  final TextEditingController serialNoController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController systemProcessorController = TextEditingController();
  final TextEditingController processorGenerationController = TextEditingController();
  final TextEditingController deviceIdController = TextEditingController();
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController totalRamController = TextEditingController();
  final TextEditingController ram1Controller = TextEditingController();
  final TextEditingController ram2Controller = TextEditingController();
  final TextEditingController chargerSerialNumberController = TextEditingController();
  final TextEditingController warrantyStartDateController = TextEditingController();
  final TextEditingController warrantyMonthController = TextEditingController();
  final TextEditingController warrantyExpirationDateController = TextEditingController();
  final TextEditingController warrantyNotesController = TextEditingController();

  final TextEditingController desktopScreenBrandController = TextEditingController();
  final TextEditingController lcdMonitorBrandController = TextEditingController();
  final TextEditingController lcdSerialNumberController = TextEditingController();
  final TextEditingController bagGivenController = TextEditingController();
  final TextEditingController keyboardGivenController = TextEditingController();
  final TextEditingController newChargerSerialNoController = TextEditingController();
  final TextEditingController mouseGivenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.assetData != null) {
      final data = widget.assetData!;
      selectedCategory = data['Category'];
      selectedSubCategory = data['Sub Category'];
      selectedSite = data['Site'];
      selectedLocation = data['Location'];
      selectedStatus = data['Status'];
      assetTagIdController.text = data['Asset Tag ID'] ?? '';
      assetBrandController.text = data['Asset Brand'] ?? '';
      serialNoController.text = data['Serial No'] ?? '';
      modelController.text = data['Model'] ?? '';
      descriptionController.text = data['Description'] ?? '';
      systemProcessorController.text = data['System Processor'] ?? '';
      processorGenerationController.text = data['Processor Generation'] ?? '';
      deviceIdController.text = data['Device ID'] ?? '';
      productIdController.text = data['Product ID'] ?? '';
      totalRamController.text = data['Total RAM'] ?? '';
      ram1Controller.text = data['RAM1'] ?? '';
      ram2Controller.text = data['RAM2'] ?? '';
      chargerSerialNumberController.text = data['Charger Serial No'] ?? '';
      warrantyStartDateController.text = data['Warranty Start Date'] ?? '';
      warrantyMonthController.text = data['Warranty Month'] ?? '';
      warrantyExpirationDateController.text = data['Warranty Expiration Date'] ?? '';
      warrantyNotesController.text = data['Warranty Notes'] ?? '';
      desktopScreenBrandController.text = data['Desktop Screen Brand'] ?? '';
      lcdMonitorBrandController.text = data['LCD Monitor Brand'] ?? '';
      lcdSerialNumberController.text = data['LCD Serial Number'] ?? '';
      bagGivenController.text = data['Bag Given'] ?? '';
      keyboardGivenController.text = data['Keyboard Given'] ?? '';
      newChargerSerialNoController.text = data['New Charger Serial No'] ?? '';
      mouseGivenController.text = data['Mouse Given'] ?? '';
    }
  }

  void _handleSubmit() async {
    final data = {
      "Category": selectedCategory,
      "Sub Category": selectedSubCategory,
      "Asset Tag ID": assetTagIdController.text,
      "Site": selectedSite,
      "Location": selectedLocation,
      "Status": selectedStatus,
      "Desktop Screen Brand": desktopScreenBrandController.text,
      "LCD Monitor Brand": lcdMonitorBrandController.text,
      "LCD Serial Number": lcdSerialNumberController.text,
      "Bag Given": bagGivenController.text,
      "Keyboard Given": keyboardGivenController.text,
      "New Charger Serial No": newChargerSerialNoController.text,
      "Mouse Given": mouseGivenController.text,
      "Serial No": serialNoController.text,
      "Asset Brand": assetBrandController.text,
      "Model": modelController.text,
      "Description": descriptionController.text,
      "System Processor": systemProcessorController.text,
      "Processor Generation": processorGenerationController.text,
      "Device ID": deviceIdController.text,
      "Product ID": productIdController.text,
      "Total RAM": totalRamController.text,
      "RAM1": ram1Controller.text,
      "RAM2": ram2Controller.text,
      "Charger Serial No": chargerSerialNumberController.text,
      "Warranty Start Date": warrantyStartDateController.text,
      "Warranty Month": warrantyMonthController.text,
      "Warranty Expiration Date": warrantyExpirationDateController.text,
      "Warranty Notes": warrantyNotesController.text,
    };

    try {
      final url = widget.isEdit
          ? Uri.parse('http://192.168.50.92:5300/api/assetmanagements/${widget.assetData?["_id"]}')
          : Uri.parse('http://192.168.50.92:5300/api/assetmanagements/upload');

      final response = await (widget.isEdit
          ? http.put(url, headers: {'Content-Type': 'application/json'}, body: json.encode(data))
          : http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(data)));

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.isEdit ? "Asset updated successfully!" : "Asset added successfully!")),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred during submission.")),
      );
    }
  }


  Widget buildDropdown(String label, String? value, ValueChanged<String?> onChanged, List<String> items) {
    // ✅ Fix for: value not in items OR value occurs more than once
    final validValue = (value != null && items.where((element) => element == value).length == 1) ? value : null;

    return SizedBox(
      width: MediaQuery.of(context).size.width / 4 - 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: validValue,
            onChanged: onChanged,
            decoration: InputDecoration(
              fillColor: Colors.green.shade50,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }



/*  Widget buildDropdown(String label, String? value, ValueChanged<String?> onChanged, List<String> items) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4 - 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            decoration: InputDecoration(
              fillColor: Colors.green.shade50,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
          ),
        ],
      ),
    );
  }
  */


  Widget buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4 - 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              fillColor: Colors.orange.shade50,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildReadOnlyTextField(String label, TextEditingController controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4 - 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              fillColor: Colors.grey.shade300,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    final List<String> subCategoryOptions = selectedCategory != null && subCategoriesMap.containsKey(selectedCategory!)
        ? List<String>.from(subCategoriesMap[selectedCategory!]!)
        : <String>[];

    return Scaffold(
      backgroundColor: const Color(0xFFDFDBD2),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Add New Asset", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 20,
                        runSpacing: 16,
                        children: [
                          buildDropdown(
                            'Categories',
                            selectedCategory,
                                (val) {
                              setState(() {
                                selectedCategory = val;
                                selectedSubCategory = null; // 🔄 Reset on category change
                                assetTagIdController.clear();
                                showSubCategoryDetails = false;
                              });
                            },
                            List<String>.from(subCategoriesMap.keys.toList()),
                          ),

                          // buildDropdown('Sub Categories', selectedSubCategory, (val) => setState(() => selectedSubCategory = val), subCategoryOptions),


                          buildDropdown(
                            'Sub Categories',
                            subCategoryOptions.contains(selectedSubCategory) ? selectedSubCategory : null,
                                (val) {
                              setState(() {
                                selectedSubCategory = val;
                                if (selectedCategory != null &&
                                    val != null &&
                                    assetTagIdMap.containsKey(selectedCategory!) &&
                                    assetTagIdMap[selectedCategory!]!.containsKey(val)) {
                                  assetTagIdController.text = assetTagIdMap[selectedCategory!]![val]!;
                                } else {
                                  assetTagIdController.clear();
                                }
                              });
                            },
                            subCategoryOptions,
                          ),

                          buildReadOnlyTextField('Asset Tag ID', assetTagIdController),
                          buildDropdown('Sites', selectedSite, (val) => setState(() => selectedSite = val), sites),
                          buildDropdown('Location', selectedLocation, (val) => setState(() => selectedLocation = val), locations),


                          buildDropdown('Status', selectedStatus, (val) => setState(() => selectedStatus = val), statuses),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => setState(() => showSubCategoryDetails = !showSubCategoryDetails),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Sub-Category Information - (Asset Type)", style: TextStyle(fontWeight: FontWeight.bold)),
                              Icon(Icons.arrow_drop_down_circle)
                            ],
                          ),
                        ),
                      ),
                      if (showSubCategoryDetails) ...[
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 20,
                          runSpacing: 16,
                          children: selectedCategory == 'External Equipment'
                              ? [
                            buildTextField('Desktop Screen Brand', desktopScreenBrandController),
                            buildTextField('Serial No', serialNoController),
                            buildTextField('LCD- Monitor Brand', lcdMonitorBrandController),
                            buildTextField('LCD- Serial Number', lcdSerialNumberController),
                            buildTextField('Bag Given', bagGivenController),
                            buildTextField('Keyboard Given', keyboardGivenController),
                            buildTextField('New Charger Serial No.', newChargerSerialNoController),
                            buildTextField('Mouse Given', mouseGivenController),
                          ]
                              : [
                            buildTextField('Asset Brand', assetBrandController),
                            buildTextField('Serial No', serialNoController),
                            buildTextField('Model (DMI System Information)', modelController),
                            buildTextField('Description', descriptionController),
                            buildTextField('System Processor', systemProcessorController),
                            buildTextField('Processor Generation', processorGenerationController),
                            buildTextField('Device ID', deviceIdController),
                            buildTextField('Product ID', productIdController),
                            buildTextField('Total RAM Nos.', totalRamController),
                            buildTextField('RAM 1 Size & Brand', ram1Controller),
                            buildTextField('RAM 2 Size & Brand', ram2Controller),
                            buildTextField('Charger Serial Number', chargerSerialNumberController),
                            buildTextField('Warranty Start Date', warrantyStartDateController),
                            buildTextField('Warranty Month', warrantyMonthController),
                            buildTextField('Warranty Expiration Date', warrantyExpirationDateController),
                            buildTextField('Warranty Notes', warrantyNotesController),
                          ],
                        )
                      ],
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            ),
                            onPressed: () {
                              setState(() => showSubCategoryDetails = false);
                              _formKey.currentState?.reset();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Form cleared!")),
                              );
                            },
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF103C3F),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            ),
                            onPressed: _handleSubmit,
                            child: const Text("Submit"),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
// buildDropdown, buildTextField, buildReadOnlyTextField, build() all remain the same
}

