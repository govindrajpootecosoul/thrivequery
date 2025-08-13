import 'package:flutter/material.dart';

import '../Platforms_screen/brillo.dart';
import '../Platforms_screen/hrmp.dart';
import '../Platforms_screen/kinetica_sporst.dart';
import '../Platforms_screen/vectorai.dart';
import '../new_assets_managements ui/assetsmain.dart';
import '../screens/adminpanel.dart';

String platformname="";
class DepartmentSelectionScreen extends StatelessWidget {
  const DepartmentSelectionScreen({super.key});

  void onDepartmentSelected(BuildContext context, String department) {
    if (department == "Brillo") {
      platformname=department;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Brillo_screen()),
      );
    } else if (department == "Kinetica Sports") {
      platformname=department;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const kinetica_sports()),
      );
    } else if (department == "Vector.Ai") {
      platformname=department;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const vectorai_screen()),
      );
    }


    else if (department == "HRMS") {
      //platformname=department;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  MainLayout()),
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No screen found for $department')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side image
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/selectdep.png'),
                  //// Dummy image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Right side content
          Expanded(
            flex: 5,
            child: Container(
              color: const Color(0xFFE0D6C5), // Light beige background
              child: Center(
                child: Column(
                //  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Text(""),
                          const Text(
                            "Select Platform",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D71B5),
                            ),
                          ),
                          InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AdminPanel()),
                                );
                              },
                              child:
                          Icon(Icons.settings,size: 40,)),

                        ],
                      ),
                    ),
                    Divider(color: Color(0xFF073349),),
                    const SizedBox(height: 60),

                    // Row of first two buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        gradientButton(context, "Kinetica Sports"),
                        const SizedBox(width: 60),
                        gradientButton(context, "Brillo"),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // HR Button
                    gradientButton(context, "Vector.Ai"),
                    const SizedBox(height: 30),

              InkWell(
                // onTap: () => onDepartmentSelected(label),
                onTap: () =>{
                Navigator.push(
                context,
              //  MaterialPageRoute(builder: (context) =>  MainLayout()),
                MaterialPageRoute(builder: (context) =>  AssetManagementMain()),
                )
                },

                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 250,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF073349), Color(0xFF117AAF)],

                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(4, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Assets Managements",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


Widget gradientButton(BuildContext context, String label) {
    return
      InkWell(
     // onTap: () => onDepartmentSelected(label),
      onTap: () => onDepartmentSelected(context, label),

      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 250,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF073349), Color(0xFF117AAF)],

          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(4, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
