import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'services/api_service.dart';


void main() {
  runApp(Mindbloom());
}

class Mindbloom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workplace Transparency Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> feedbackData = [];
  double safetyRating = 0;
  double cultureRating = 0;
  String harassmentReport = '';
  String mentalHealthFeedback = '';

  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }

  Future<void> fetchFeedback() async {
    try {
      final data = await _apiService.fetchFeedback();
      setState(() {
        feedbackData = data;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> submitFeedback() async {
    final feedback = {
      'safetyRating': safetyRating,
      'cultureRating': cultureRating,
      'harassmentReport': harassmentReport,
      'mentalHealthFeedback': mentalHealthFeedback,
    };

    try {
      await _apiService.submitFeedback(feedback);
      setState(() {
        safetyRating = 0;
        cultureRating = 0;
        harassmentReport = '';
        mentalHealthFeedback = '';
      });
      fetchFeedback(); // Refresh feedback after submission
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully')));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to submit feedback')));
    }
  }

  // Bar chart showing trends of safety and culture ratings
  List<BarChartGroupData> getBarChartData() {
    return List.generate(feedbackData.length, (index) {
      final item = feedbackData[index];
      return BarChartGroupData(
        x: index,
        barRods: [
  BarChartRodData(
    toY: item['safetyRating'].toDouble(),
    color: Colors.blue,  // You can also use `gradient` for gradient colors
    width: 15,  // Optional but recommended to specify the width of the bar
  ),
  BarChartRodData(
    toY: item['cultureRating'].toDouble(),
    color: Colors.green,
    width: 15,
  ),
]
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workplace Transparency Dashboard'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Submit Anonymous Feedback',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: safetyRating,
              min: 0,
              max: 10,
              divisions: 10,
              label: 'Safety Rating: $safetyRating',
              onChanged: (value) {
                setState(() {
                  safetyRating = value;
                });
              },
            ),
            Slider(
              value: cultureRating,
              min: 0,
              max: 10,
              divisions: 10,
              label: 'Culture Rating: $cultureRating',
              onChanged: (value) {
                setState(() {
                  cultureRating = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Harassment Report'),
              onChanged: (value) {
                setState(() {
                  harassmentReport = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Mental Health Feedback'),
              onChanged: (value) {
                setState(() {
                  mentalHealthFeedback = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: submitFeedback,
              child: Text('Submit Feedback'),
            ),
            SizedBox(height: 20),
            Text(
              'Safety and Culture Ratings Over Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: getBarChartData(),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
