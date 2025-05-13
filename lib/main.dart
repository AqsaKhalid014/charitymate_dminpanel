import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'check login.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDqEon27jUibjQscjvsZZg4mmekt0GH9wY",
        authDomain: "charitymate-bc611.firebaseapp.com",
        databaseURL: "https://charitymate-bc611-default-rtdb.firebaseio.com",
        projectId: "charitymate-bc611",
        storageBucket: "charitymate-bc611.appspot.com",
        messagingSenderId: "129550855747",
        appId: "1:129550855747:web:87f8f7e93decf8e7e0eef6",
        measurementId: "G-BH3YKCT2QC",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Charity Mate',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: CheckUserLoginStatus(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _addUserDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Create user in Firebase Auth
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  // Store user data in Firestore
                  await FirebaseFirestore.instance
                      .collection('users personal data')
                      .doc(userCredential.user!.uid)
                      .set({
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'password': passwordController.text,
                    'createdAt': Timestamp.now(),
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User added successfully!')),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Add User'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUserDialog(BuildContext context, DocumentSnapshot user) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
              onPressed: () async {
                try {
                  // Delete from Firebase Auth
                  await FirebaseAuth.instance.currentUser!.delete();

                  // Delete from Firestore
                  await FirebaseFirestore.instance
                      .collection('users personal data')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .delete();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User deleted successfully!')),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Yes'),
            ),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.orange.shade400,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange.shade400,
              ),
              child: const Text(
                "Charity Mate",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _drawerItem(icon: Icons.home, label: 'Dashboard', onTap: () {}),
            _drawerItem(icon: Icons.people, label: 'Users', onTap: () {}),
            _drawerItem(icon: Icons.feedback, label: 'Feedback', onTap: () {}),
            _drawerItem(icon: Icons.logout, label: 'Logout', onTap: () {}),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3.0, // Increased aspect ratio to reduce height
              children: const [
                DashboardCard(title: "Total Donations", change: "4.6% increase"),
                DashboardCard(title: "Total Money", change: "2.6% decrease"),
                DashboardCard(title: "View All Posts", change: "4.6% increase"),
              ],
            ),
            const SizedBox(height: 20),

            // Main Content Row (Users and Feedback)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Users Section (Left side)
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Users:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.green),
                            onPressed: () => _addUserDialog(context),
                            tooltip: 'Add User',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 408,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.orangeAccent),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users personal data')
                              .orderBy('createdAt', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            }

                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Center(child: Text('No user data available.'));
                            }

                            var users = snapshot.data!.docs;

                            return SingleChildScrollView(
                              child: Container(
                                width:840,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Contact No', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('SignIn Time', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('DisableUser', style: TextStyle(fontWeight: FontWeight.bold))),  // New column
                                  ],
                                  rows: users.map<DataRow>((user) {
                                    var userData = user.data() as Map<String, dynamic>;
                                    return DataRow(cells: [
                                      DataCell(Text(userData['name'] ?? '')),
                                      DataCell(Text(userData['email'] ?? '')),
                                      DataCell(Text(userData['phone'] ?? '')),
                                      DataCell(Text(userData['createdAt']?.toDate().toString() ?? '')),
                                      DataCell(
                                        IconButton(
                                          icon: Icon(Icons.block),
                                          onPressed: () {
                                            // Show the dialog to disable the user
                                            _showDisableDialog(userData['email']);
                                          },
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Feedback Section (Right side)
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Feedback',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 410,

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('feedback')
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            var feedbacks = snapshot.data!.docs;

                            return ListView.builder(
                              itemCount: feedbacks.length,
                              itemBuilder: (context, index) {
                                var feedback = feedbacks[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  elevation: 2,
                                  child: ListTile(
                                    leading: const Icon(Icons.star, color: Colors.yellow),
                                    title: Text(feedback['feedback'] ?? '', style: const TextStyle(fontSize: 15)),
                                    subtitle: Text("Rating: ${feedback['rating']} ⭐"),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Graphs Section (Now at the bottom)
            const Text(
              'Statistics',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200, // Further reduced height
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        title: ChartTitle(text: 'Donations Overview'),
                        legend: Legend(isVisible: true),
                        series: <CartesianSeries<ChartData, String>>[
                          ColumnSeries<ChartData, String>(
                            dataSource: [
                              ChartData('Jan', 35),
                              ChartData('Feb', 28),
                              ChartData('Mar', 34),
                              ChartData('Apr', 32),
                              ChartData('May', 40),
                            ],
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            name: 'Donations',
                            color: Colors.orange,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        title: ChartTitle(text: 'User Growth'),
                        legend: Legend(isVisible: true),
                        series: <CartesianSeries<ChartData, String>>[
                          LineSeries<ChartData, String>(
                            dataSource: [
                              ChartData('Jan', 15),
                              ChartData('Feb', 22),
                              ChartData('Mar', 25),
                              ChartData('Apr', 30),
                              ChartData('May', 35),
                            ],
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            name: 'Users',
                            color: Colors.indigo,
                            markerSettings: const MarkerSettings(isVisible: true),
                          )
                        ],
                      ),
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

  Widget _drawerItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(label, style: const TextStyle(color: Colors.black)),
      onTap: onTap,
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String change;

  const DashboardCard({
    super.key,
    required this.title,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '100', // Replace with actual data from Firestore
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                change.contains('increase') ? Icons.arrow_upward : Icons.arrow_downward,
                color: change.contains('increase') ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: TextStyle(
                  color: change.contains('increase') ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}


void _disableUserUntil(String email, DateTime disableUntil) {
  FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .get()
      .then((snapshot) {
    if (snapshot.docs.isNotEmpty) {
      var userDoc = snapshot.docs.first;
      userDoc.reference.update({
        'isDisabled': true,
        'disabledUntil': disableUntil,
      });
    }
  });
}
void _showDisableDialog(String email) {
  final durationController = TextEditingController();

  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        title: const Text('Disable User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter number of hours to disable this user:'),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Hours'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final hours = int.tryParse(durationController.text);
              if (hours == null || hours <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid number of hours')),
                );
                return;
              }

              final disabledUntil = Timestamp.fromDate(
                DateTime.now().add(Duration(hours: hours)),
              );

              // Update Firestore user document
              final query = await FirebaseFirestore.instance
                  .collection('users personal data')
                  .where('email', isEqualTo: email)
                  .limit(1)
                  .get();

              if (query.docs.isNotEmpty) {
                await query.docs.first.reference.update({
                  'disabledUntil': disabledUntil,
                });
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User disabled for $hours hours')),
              );

              Navigator.of(context).pop();
            },
            child: const Text('Disable'),
          ),
        ],
      );
    },
  );
}
