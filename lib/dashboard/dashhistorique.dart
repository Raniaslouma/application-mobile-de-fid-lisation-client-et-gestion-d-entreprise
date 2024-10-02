import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapplication/dashboard/rapport.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';



class Dashhisto extends StatefulWidget {
  @override
  _DashhistoState createState() => _DashhistoState();
}

class _DashhistoState extends State<Dashhisto> {
  Stream<QuerySnapshot> _stream = Stream.empty();

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('Historique').snapshots();
  }

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
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            final productCountsByMonth = <String, Map<String, int>>{};

            // Process data
            snapshot.data!.docs.forEach((document) {
              final data = document.data() as Map<String, dynamic>;
              final date = data['date'].toDate();
              final month =
                  '${date.year}-${date.month.toString().padLeft(2, '0')}';
              final productName = data['nomProduit'];
              final productCount = data['nomberdeproduit'] ?? 0;

              if (!productCountsByMonth.containsKey(month)) {
                productCountsByMonth[month] = {};
              }

              if (!productCountsByMonth[month]!.containsKey(productName)) {
                productCountsByMonth[month]![productName] = 0;
              }

              productCountsByMonth[month]![productName] =
                  (productCountsByMonth[month]![productName] ?? 0) +
                      (productCount as int);
            });

            final sortedMonths = productCountsByMonth.keys.toList()..sort();

            return SingleChildScrollView(
              child: Column(
                children: sortedMonths.map((month) {
                  final productCounts = productCountsByMonth[month]!;
                  final totalProductCount =
                      productCounts.values.fold(0, (sum, count) => sum + count);
                  final data = productCounts.entries.map((entry) {
                    final percentage = (entry.value / totalProductCount) * 100;
                    return ProductCount(entry.key, percentage.toInt());
                  }).toList();

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(horizontal: 16),
                      title: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            month.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      collapsedBackgroundColor: Colors.white,
                      backgroundColor: Colors.grey.shade100,
                      collapsedTextColor: Colors.black,
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      childrenPadding: EdgeInsets.all(16),
                      children: [
                        Container(
                          height: 300,
                          child: SfCartesianChart(
                            plotAreaBorderColor: Colors.transparent,
                            primaryXAxis: CategoryAxis(
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            primaryYAxis: NumericAxis(
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              axisLine: AxisLine(width: 0),
                              majorTickLines: MajorTickLines(size: 0),
                              majorGridLines: MajorGridLines(width: 0),
                              numberFormat: NumberFormat('#,##0%'),
                            ),
                            series: <ChartSeries>[
                              ColumnSeries<ProductCount, String>(
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  labelAlignment: ChartDataLabelAlignment.top,
                                  textStyle: TextStyle(
                                    color: Colors
                                        .white, // Modifier la couleur du texte des labels
                                  ),
                                ),
                                dataSource: data,
                                xValueMapper: (ProductCount productCount, _) =>
                                    productCount.productName,
                                yValueMapper: (ProductCount productCount, _) =>
                                    (productCount.percentage / 100),
                                color: Colors
                                    .orange, // Modifier la couleur de la colonne
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}

class ProductCount {
  final String productName;
  final int percentage;

  ProductCount(this.productName, this.percentage);
}