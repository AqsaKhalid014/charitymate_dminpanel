import 'package:flutter/material.dart';
import 'package:charitymate_adminpanel/view all post screen.dart'; // Ensure this path is correct

class TappableBlocksScreen extends StatelessWidget {
  const TappableBlocksScreen({super.key});

  final List<Map<String, dynamic>> blocks = const [
    {
      'title': 'Food Screen',
      'icon': Icons.fastfood,
      'color': Colors.white,
      'gradient': [Colors.white, Colors.white],
    },
    {
      'title': 'Furniture Screen',
      'icon': Icons.weekend,
      'color': Colors.white,
      'gradient': [Colors.white, Colors.white],
    },
    {
      'title': 'Clothes Screen',
      'icon': Icons.checkroom,
      'color': Colors.white,
      'gradient': [Colors.white, Colors.white],
    },
    {
      'title': 'Education Screen',
      'icon': Icons.school,
      'color': Colors.white,
      'gradient': [Colors.white, Colors.white],
    },
    {
      'title': 'Medical Screen',
      'icon': Icons.medical_services,
      'color': Colors.white,
      'gradient': [Colors.white, Colors.white],
    },
    {
      'title': 'Others',
      'icon': Icons.more_horiz,
      'color': Colors.white,
      'gradient': [Colors.white, Colors.white],
    },
  ];

  void onBlockTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DonateFoodScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DonateFurnitureScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DonateClothScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DonateStationaryScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DonateMedicalItemsScreen()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DonateItemScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${blocks[index]['title']} tapped'),
            duration: const Duration(milliseconds: 500),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade400,
        title: const Text('All Donations'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.2,
          ),
          itemCount: blocks.length,
          itemBuilder: (context, index) {
            final block = blocks[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onBlockTapped(context, index),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: block['gradient'],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        block['icon'],
                        size: 48,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        block['title'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}