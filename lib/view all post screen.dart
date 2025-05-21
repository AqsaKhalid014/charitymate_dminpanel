import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonateFoodScreen extends StatelessWidget {
  const DonateFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade400,
        title: Text('Food Posts'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Food').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text('No items to display.'));
          }

          return GridView.count(
            crossAxisCount: 4, // You can change it to 3 or 4 if you want more columns
            children: List.generate(docs.length, (index) {
              var data = docs[index];
              var imageUrl = data['image_url'];
              var productName = data['product_name'];
              var location = data['location'];
              var description = data['description'];

              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        imageUrl,
                                        width: 350,
                                        height: 350,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "Name: $productName",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text("Location: $location"),
                                    Text("Description: $description"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 12,
                    child: PopupMenuButton<String>(  icon: Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) async {
                        if (value == 'delete') {
                          bool? confirmed = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Confirmation'),
                              content: Text('Are you sure you want to delete this post?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            await FirebaseFirestore.instance
                                .collection('Food')
                                .doc(data.id)
                                .delete();
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
class DonateItemScreen extends StatelessWidget {
  const DonateItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade400,
        title: Text('Items Posts'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('other item').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text('No items to display.'));
          }

          return GridView.count(
            crossAxisCount: 4, // You can change it to 3 or 4 if you want more columns
            children: List.generate(docs.length, (index) {
              var data = docs[index];
              var imageUrl = data['image_url'];
              var productName = data['product_name'];
              var location = data['location'];
              var description = data['description'];

              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        imageUrl,
                                        width: 350,
                                        height: 350,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "Name: $productName",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text("Location: $location"),
                                    Text("Description: $description"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 12,
                    child: PopupMenuButton<String>(  icon: Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) async {
                        if (value == 'delete') {
                          bool? confirmed = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Confirmation'),
                              content: Text('Are you sure you want to delete this post?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            await FirebaseFirestore.instance
                                .collection('Food')
                                .doc(data.id)
                                .delete();
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
class DonateFurnitureScreen extends StatelessWidget {
  const DonateFurnitureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade400,
        title: Text('Furniture Posts'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Furniture').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text('No items to display.'));
          }

          return GridView.count(
            crossAxisCount: 4, // You can change it to 3 or 4 if you want more columns
            children: List.generate(docs.length, (index) {
              var data = docs[index];
              var imageUrl = data['image_url'];
              var productName = data['product_name'];
              var location = data['location'];
              var description = data['description'];

              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        imageUrl,
                                        width: 350,
                                        height: 350,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "Name: $productName",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text("Location: $location"),
                                    Text("Description: $description"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 12,
                    child: PopupMenuButton<String>(  icon: Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) async {
                        if (value == 'delete') {
                          bool? confirmed = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Confirmation'),
                              content: Text('Are you sure you want to delete this post?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            await FirebaseFirestore.instance
                                .collection('Food')
                                .doc(data.id)
                                .delete();
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
class DonateStationaryScreen extends StatelessWidget {
  const DonateStationaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade400,
        title: Text('Education Posts'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Stationary').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text('No items to display.'));
          }

          return GridView.count(
            crossAxisCount: 4, // You can change it to 3 or 4 if you want more columns
            children: List.generate(docs.length, (index) {
              var data = docs[index];
              var imageUrl = data['image_url'];
              var productName = data['product_name'];
              var location = data['location'];
              var description = data['description'];

              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        imageUrl,
                                        width: 350,
                                        height: 350,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "Name: $productName",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text("Location: $location"),
                                    Text("Description: $description"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 12,
                    child: PopupMenuButton<String>(  icon: Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) async {
                        if (value == 'delete') {
                          bool? confirmed = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Confirmation'),
                              content: Text('Are you sure you want to delete this post?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            await FirebaseFirestore.instance
                                .collection('Food')
                                .doc(data.id)
                                .delete();
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
class DonateClothScreen extends StatelessWidget {
  const DonateClothScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade400,
        title: Text('clothes Posts'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('clothes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text('No items to display.'));
          }

          return GridView.count(
            crossAxisCount: 4, // You can change it to 3 or 4 if you want more columns
            children: List.generate(docs.length, (index) {
              var data = docs[index];
              var imageUrl = data['image_url'];
              var productName = data['product_name'];
              var location = data['location'];
              var description = data['description'];

              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        imageUrl,
                                        width: 350,
                                        height: 350,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "Name: $productName",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text("Location: $location"),
                                    Text("Description: $description"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 12,
                    child: PopupMenuButton<String>(  icon: Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) async {
                        if (value == 'delete') {
                          bool? confirmed = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Confirmation'),
                              content: Text('Are you sure you want to delete this post?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            await FirebaseFirestore.instance
                                .collection('Food')
                                .doc(data.id)
                                .delete();
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
class DonateMedicalItemsScreen extends StatelessWidget {
  const DonateMedicalItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade400,
        title: Text('MedicalItems Posts'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('medical').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text('No items to display.'));
          }

          return GridView.count(
            crossAxisCount: 4, // You can change it to 3 or 4 if you want more columns
            children: List.generate(docs.length, (index) {
              var data = docs[index];
              var imageUrl = data['image_url'];
              var productName = data['product_name'];
              var location = data['location'];
              var description = data['description'];

              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        imageUrl,
                                        width: 350,
                                        height: 350,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "Name: $productName",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text("Location: $location"),
                                    Text("Description: $description"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 12,
                    child: PopupMenuButton<String>(  icon: Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) async {
                        if (value == 'delete') {
                          bool? confirmed = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Confirmation'),
                              content: Text('Are you sure you want to delete this post?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            await FirebaseFirestore.instance
                                .collection('Food')
                                .doc(data.id)
                                .delete();
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
