import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_tracker.dart';
import '../models/user_model.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityProvider>().loadUserActivity();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActivityProvider>();
    final userActivity = provider.userActivity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Freshman Activities'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.loadUserActivity(),
            tooltip: 'Refresh progress',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareProgress,
            tooltip: 'Share progress',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.loadUserActivity(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Прогресс-бар выполнения
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Campus Exploration Progress',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Complete all stations to unlock achievement',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Level ${provider.calculateLevel()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Круговой прогресс-бар
                    CircularPercentIndicator(
                      radius: 80,
                      lineWidth: 15,
                      percent: userActivity.completionPercentage / 100,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${userActivity.completionPercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Completed',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      progressColor:
                          _getProgressColor(userActivity.completionPercentage),
                      backgroundColor: Colors.grey[200],
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animateFromLastPercent: true,
                    ),
                    const SizedBox(height: 24),

                    // Детали прогресса
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 16,
                      children: [
                        _buildStatCard(
                          context,
                          '${userActivity.distanceWalked.toStringAsFixed(1)} km',
                          'Distance',
                          Icons.directions_walk,
                          Colors.blue,
                        ),
                        _buildStatCard(
                          context,
                          '${userActivity.caloriesBurned} cal',
                          'Calories',
                          Icons.local_fire_department,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          context,
                          '${userActivity.visitedStations.length}',
                          'Stations',
                          Icons.location_on,
                          Colors.green,
                        ),
                        _buildStatCard(
                          context,
                          '${provider.calculateTimeSpent().inMinutes} min',
                          'Time Spent',
                          Icons.timer,
                          Colors.purple,
                        ),
                        _buildStatCard(
                          context,
                          '${provider.calculateXP()} XP',
                          'Experience',
                          Icons.star,
                          Colors.amber,
                        ),
                        _buildStatCard(
                          context,
                          '${provider.calculateAchievements()}',
                          'Achievements',
                          Icons.emoji_events,
                          Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Статистика за неделю
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 150,
                      child: provider.weeklyStats.isNotEmpty
                          ? _buildWeeklyChart(provider.weeklyStats)
                          : const Center(
                              child: Text('No activity data for this week'),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Станции QR-кодов
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'QR Code Stations',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Chip(
                          label: Text(
                            '${provider.completedStationsCount}/${provider.totalStationsCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...provider.stations
                        .map((station) => _buildStationCard(context, station)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Достижения
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Achievements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: provider.achievements
                          .map(
                            (achievement) => Chip(
                              avatar: Icon(
                                achievement['isUnlocked']
                                    ? Icons.check
                                    : Icons.lock,
                                size: 16,
                                color: achievement['isUnlocked']
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              label: Text(
                                achievement['name'],
                                style: TextStyle(
                                  color: achievement['isUnlocked']
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: achievement['isUnlocked']
                                  ? Colors.green
                                  : Colors.grey[300],
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _scanQRCode(context),
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan QR Code'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label,
      IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationCard(BuildContext context, Map<String, dynamic> station) {
    final isCompleted = station['isCompleted'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isCompleted
            ? Colors.green.withOpacity(0.1)
            : Colors.blue.withOpacity(0.1),
        border: Border.all(
          color: isCompleted ? Colors.green : Colors.blue,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.qr_code,
            color: Colors.white,
          ),
        ),
        title: Text(
          station['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isCompleted ? Colors.green : Colors.blue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: ${station['location']['name']}'),
            if (station['description'] != null)
              Text(
                station['description'],
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (station['points'] != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${station['points']} XP',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        onTap: () => _showStationDetails(context, station),
      ),
    );
  }

  Widget _buildWeeklyChart(List<Map<String, dynamic>> weeklyStats) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: weeklyStats.length,
      itemBuilder: (context, index) {
        final stat = weeklyStats[index];
        final percentage = stat['distance'] / 10; // 10 км максимум
        return Container(
          width: 60,
          margin: const EdgeInsets.only(right: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${stat['distance'].toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Container(
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    color: Theme.of(context).primaryColor.withOpacity(
                          0.3 + percentage * 0.7,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat['day'],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    if (percentage >= 25) return Colors.yellow;
    return Colors.red;
  }

  void _showStationDetails(BuildContext context, Map<String, dynamic> station) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: station['isCompleted'] ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    station['isCompleted'] ? Icons.check : Icons.qr_code,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Location: ${station['location']['name']}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                if (station['points'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${station['points']} XP',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (station['description'] != null)
              Text(
                station['description'],
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            if (!station['isCompleted'])
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _scanQRCode(context, stationId: station['id']);
                  },
                  child: const Text('Scan QR Code Now'),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _scanQRCode(BuildContext context, {String? stationId}) {
    // Имитация сканирования QR-кода
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              color: Colors.grey[200],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_scanner, size: 80, color: Colors.blue),
                    SizedBox(height: 20),
                    Text('Point camera at QR code'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Position QR code within frame'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (stationId != null) {
                context.read<ActivityProvider>().markStationComplete(stationId);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Station checked successfully! +10 XP'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Simulate Scan'),
          ),
        ],
      ),
    );
  }

  void _shareProgress() {
    final provider = context.read<ActivityProvider>();
    final activity = provider.userActivity;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Progress'),
        content:
            const Text('Share your campus exploration progress with friends!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Progress shared successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }
}
