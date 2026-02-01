import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/qr_provider.dart';
import '../models/qr_model.dart';

class QRHistoryScreen extends StatefulWidget {
  const QRHistoryScreen({super.key});

  @override
  State<QRHistoryScreen> createState() => _QRHistoryScreenState();
}

class _QRHistoryScreenState extends State<QRHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QRProvider>().loadScanHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QRProvider>();
    final history = provider.scannedCodes;
    
    return Scaffold(
      body: Column(
        children: [
          // Статистика
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'История сканирований',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white),
                      onPressed: _confirmClearHistory,
                      tooltip: 'Очистить историю',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      '${provider.totalScans}',
                      'Всего',
                      Icons.qr_code_scanner,
                    ),
                    _buildStatItem(
                      '${provider.discountScans}',
                      'Скидки',
                      Icons.local_offer,
                    ),
                    _buildStatItem(
                      '${provider.stationScans}',
                      'Станции',
                      Icons.location_on,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // История
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : history.isEmpty
                    ? _buildEmptyHistory()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          return _buildHistoryItem(history[index], index);
                        },
                      ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
  
  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.history_toggle_off,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            'История сканирований пуста',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Сканируйте QR-коды, чтобы они появились здесь',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Начать сканирование'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHistoryItem(QRCode code, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getColorForType(code.type),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            _getIconForType(code.type),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          code.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (code.description.isNotEmpty)
              Text(
                code.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Text(
              code.formattedDate,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: code.isDiscount
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  '${code.discountValue}%',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        onTap: () => _showCodeDetails(code),
      ),
    );
  }
  
  Color _getColorForType(QRType type) {
    switch (type) {
      case QRType.discount:
        return Colors.green;
      case QRType.station:
        return Colors.blue;
      case QRType.url:
        return Colors.purple;
      case QRType.text:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  IconData _getIconForType(QRType type) {
    switch (type) {
      case QRType.discount:
        return Icons.local_offer;
      case QRType.station:
        return Icons.location_on;
      case QRType.url:
        return Icons.link;
      case QRType.text:
        return Icons.text_snippet;
      default:
        return Icons.qr_code;
    }
  }
  
  void _showCodeDetails(QRCode code) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getColorForType(code.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconForType(code.type),
                    color: _getColorForType(code.type),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        code.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getTypeLabel(code.type),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (code.description.isNotEmpty)
                    Text(code.description),
                  
                  const SizedBox(height: 16),
                  
                  if (code.content.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Содержимое QR:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: SelectableText(
                            code.content,
                            style: const TextStyle(fontFamily: 'Monospace'),
                          ),
                        ),
                      ],
                    ),
                  
                  if (code.scannedAt != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Отсканировано: ${code.formattedDate}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Закрыть'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _copyToClipboard(code.content),
                    child: const Text('Копировать'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
  
  String _getTypeLabel(QRType type) {
    switch (type) {
      case QRType.discount:
        return 'QR-код скидки';
      case QRType.station:
        return 'Станция кампуса';
      case QRType.url:
        return 'Веб-ссылка';
      case QRType.text:
        return 'Текстовый QR';
      default:
        return 'QR-код';
    }
  }
  
  void _copyToClipboard(String text) {
    // В реальном приложении используйте clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Скопировано в буфер обмена')),
    );
  }
  
  void _confirmClearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить историю?'),
        content: const Text('Все сканирования будут удалены. Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<QRProvider>().clearHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('История очищена'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Очистить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
