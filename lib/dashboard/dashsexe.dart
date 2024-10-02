import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'rapport.dart';

class DashSexe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ListDash();
            }));
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('usersClient').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Text('No data available'),
            );
          } else {
            List<UserData> users =
                List<UserData>.from(snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return UserData(
                name: data['nom'] ?? '',
                age: int.parse(data['age'] ?? '0'),
                gender: data['sexe'] ?? '',
                count: 1, // Each user is counted as 1
              );
            })).toList();

            // Group users by gender
            Map<String, int> genderCounts = {};
            users.forEach((user) {
              if (genderCounts.containsKey(user.gender)) {
                genderCounts[user.gender] = genderCounts[user.gender]! + 1;
              } else {
                genderCounts[user.gender] = 1;
              }
            });

            List<UserData> chartData = genderCounts.entries.map((entry) {
              return UserData(
                name: entry.key,
                age: 0,
                gender: entry.key,
                count: entry.value,
              );
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Center( child: Text('Répartition des clients par sexe',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                       
                      ))),
                  SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SfCircularChart(
                              series: <CircularSeries>[
                                DoughnutSeries<UserData, String>(
                                  dataSource: chartData,
                                  xValueMapper: (UserData user, _) =>
                                      user.gender,
                                  yValueMapper: (UserData user, _) =>
                                      user.count,
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    labelPosition:
                                        ChartDataLabelPosition.inside,
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  pointColorMapper: (UserData user, _) {
                                    return user.gender == 'Homme'
                                        ? Colors.blue
                                        : Colors.pink;
                                  },
                                  startAngle: 90,
                                  endAngle: 450,
                                  radius: '90%',
                                  innerRadius: '40%',
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GenderIndicator(
                                  label: 'Homme',
                                  color: Colors.blue,
                                ),
                                GenderIndicator(
                                  label: 'Femme',
                                  color: Colors.pink,
                                ),
                              ],
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
        },
      ),
    );
  }
}

class GenderIndicator extends StatelessWidget {
  final String label;
  final Color color;

  const GenderIndicator({
    Key? key,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class UserData {
  final String name;
  final int age;
  final String gender;
  final int count;

  UserData({
    required this.name,
    required this.age,
    required this.gender,
    required this.count,
  });
}
