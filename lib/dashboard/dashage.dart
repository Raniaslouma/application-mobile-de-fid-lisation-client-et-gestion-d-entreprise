import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'rapport.dart';

class Dash extends StatelessWidget {
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
                count:
                    0, // Replace 0 with the appropriate logic to count the users
              );
            })).toList();

            // Count users in each age category
            int youngCount =
                users.where((user) => user.age >= 17 && user.age <= 24).length;
            int adultCount =
                users.where((user) => user.age >= 25 && user.age <= 62).length;
            int over40Count = users.where((user) => user.age > 62).length;

            List<UserData> chartData = [
              UserData(name: 'Jeunes', age: 0, count: youngCount),
              UserData(name: 'Adultes', age: 0, count: adultCount),
              UserData(name: '+62', age: 0, count: over40Count),
            ];

            return Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center( child: Text(
                      'Répartition des clients par catégorie d\'âge',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        shadows: [
                         
                        ],
                      ),
                    ),),
                   
                    SizedBox(height: 18),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF651FFF),
                              Color(0xFF8000FF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SfCircularChart(
                          title: ChartTitle(
                            text: 'Clients',
                            textStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          legend: Legend(
                            isVisible: true,
                            position: LegendPosition.bottom,
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          series: <CircularSeries>[
                            PieSeries<UserData, String>(
                              dataSource: chartData,
                              xValueMapper: (UserData user, _) => user.name,
                              yValueMapper: (UserData user, _) => user.count,
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.inside,
                                connectorLineSettings: ConnectorLineSettings(
                                  type: ConnectorType.curve,
                                  color: Colors.white,
                                ),
                                labelIntersectAction: LabelIntersectAction.none,
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                builder: (dynamic data,
                                    dynamic point,
                                    dynamic series,
                                    int pointIndex,
                                    int seriesIndex) {
                                  final double total = chartData.fold(
                                      0, (sum, user) => sum + user.count);
                                  final double percentage =
                                      (data.count / total) * 100;
                                  final String formattedPercentage =
                                      NumberFormat.decimalPercentPattern(
                                              decimalDigits: 1)
                                          .format(percentage / 100);
                                  return Text('$formattedPercentage',
                                      style: TextStyle(
                                        fontSize: 16,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(1, 1),
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ));
                                },
                              ),
                              pointColorMapper: (UserData user, _) {
                                if (user.name == 'Jeunes') {
                                  return Color(0xFF6EC6FF);
                                } else if (user.name == 'Adultes') {
                                  return Color(0xFFFF6E6E);
                                } else if (user.name == '+62') {
                                  return Color(0xFF6EFF9B);
                                } else {
                                  return Colors.transparent;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class UserData {
  final String name;
  final int age;
  final int count;

  UserData({required this.name, required this.age, required this.count});
}
