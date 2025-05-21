import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllDonationsScreen extends StatefulWidget {
  const AllDonationsScreen({super.key});

  @override
  State<AllDonationsScreen> createState() => _AllDonationsScreenState();
}

class _AllDonationsScreenState extends State<AllDonationsScreen> {
  final List<String> collections = [
    'Food',
    'Furniture',
    'Stationery',
    'Clothes',
    'Medical',
    'Other item',
  ];

  Future<List<Map<String, dynamic>>> fetchAllDonations() async {
    List<Map<String, dynamic>> allData = [];

    for (String collection in collections) {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection(collection).get();

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        data['collection'] = collection; // Add collection name
        data['docId'] = doc.id; // Save doc id for delete etc.
        allData.add(data);
      }
    }

    return allData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade400,
        title: const Text('All Donation Items'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAllDonations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          }

          var items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text('No items available.'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${items.length} items found',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 5,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(items.length, (index) {
                    var item = items[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(item['product_name'] ?? 'No Name'),
                            content: SingleChildScrollView(
                              child: Container(
                                height: 400,
                                width: 400,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (item['image_url'] != null)
                                      Image.network(
                                        item['image_url'],
                                        width: 350,
                                        height: 320,
                                      ),
                                    const SizedBox(height: 8),
                                    Text(
                                        "Location: ${item['location'] ?? 'N/A'}"),
                                    Text(
                                        "Description: ${item['description'] ?? 'N/A'}"),
                                    Text("Category: ${item['collection']}"),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Image.network(
                              item['image_url'] ?? '',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (_, __, ___) =>
                              const Center(child: Text('No Image')),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                  item['product_name'] ?? 'No Name',
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
