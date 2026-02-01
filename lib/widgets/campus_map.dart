import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import '../providers/map_provider.dart';
import '../utils/map_style.dart';

class CampusMap extends StatefulWidget {
  const CampusMap({super.key});

  @override
  State<CampusMap> createState() => _CampusMapState();
}

class _CampusMapState extends State<CampusMap> {
  MapboxMapController? _mapController;
  late MapProvider _mapProvider;

  // Центр кампуса (замените на реальные координаты)
  static const LatLng _campusCenter = LatLng(13.736717, 100.523186);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapProvider = Provider.of<MapProvider>(context, listen: false);
      _mapProvider.loadCampusData();
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;

    // Загружаем маркеры после создания карты
    _loadMarkers();

    // Настройка начального положения
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        _campusCenter,
        16.0,
      ),
    );
  }

  void _onMapClick(Point<double> point, LatLng latLng) {
    // Обработка кликов на карту
  }

  void _onMarkerTap(String markerId) {
    // Находим здание по ID маркера
    final building = _mapProvider.buildings.firstWhere(
      (b) => b.id == markerId,
      orElse: () => _mapProvider.buildings.first,
    );

    // Показываем информацию о здании
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(building.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(building.description),
            const SizedBox(height: 10),
            Text(
              'Координаты: ${building.location.lat.toStringAsFixed(6)}, '
              '${building.location.lng.toStringAsFixed(6)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (building.location.address != null)
              Text(
                'Адрес: ${building.location.address!}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Перемещаем камеру к маркеру
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(
                  LatLng(building.location.lat, building.location.lng),
                  18.0,
                ),
              );
            },
            child: const Text('Показать'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadMarkers() async {
    if (_mapController == null) return;

    // Загружаем маркеры из провайдера
    for (final building in _mapProvider.buildings) {
      final markerId = building.id;
      final latLng = LatLng(building.location.lat, building.location.lng);

      _mapController!.addSymbol(
        SymbolOptions(
          geometry: latLng,
          iconImage: _getIconForBuilding(building),
          iconSize: 1.0,
          textField: building.name,
          textOffset: const Offset(0, 2),
          textColor: '#000000',
          textSize: 12.0,
        ),
        {'buildingId': markerId},
      );
    }

    // Слушаем события кликов на маркеры
    _mapController?.onSymbolTapped.add((argument) {
      final data = argument.data;
      if (data != null && data['buildingId'] != null) {
        _onMarkerTap(data['buildingId']);
      }
    });
  }

  String _getIconForBuilding(Building building) {
    // Логика для разных иконок в зависимости от типа здания
    if (building.name.toLowerCase().contains('библиотека') ||
        building.name.toLowerCase().contains('library')) {
      return 'library-15';
    } else if (building.name.toLowerCase().contains('столовая') ||
        building.name.toLowerCase().contains('cafeteria')) {
      return 'cafe-15';
    } else if (building.name.toLowerCase().contains('общежитие') ||
        building.name.toLowerCase().contains('dormitory')) {
      return 'lodging-15';
    } else {
      return 'building-15';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Stack(
          children: [
            // Карта Mapbox
            MapboxMap(
              accessToken: const String.fromEnvironment(
                'MAPBOX_ACCESS_TOKEN',
                defaultValue: 'YOUR_MAPBOX_ACCESS_TOKEN',
              ),
              onMapCreated: _onMapCreated,
              onMapClick: _onMapClick,
              initialCameraPosition: CameraPosition(
                target: _campusCenter,
                zoom: 15.0,
              ),
              styleString: MapStyle.campusTheme,
              minMaxZoomPreference: const MinMaxZoomPreference(14.0, 20.0),
              myLocationEnabled: true,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              logoViewMargins: const Point(10, 100),
              compassViewMargins: const Point(10, 200),
            ),

            // Панель управления
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                children: [
                  _buildControlButton(
                    icon: Icons.zoom_in,
                    onPressed: () => _mapController?.animateCamera(
                      CameraUpdate.zoomIn(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildControlButton(
                    icon: Icons.zoom_out,
                    onPressed: () => _mapController?.animateCamera(
                      CameraUpdate.zoomOut(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildControlButton(
                    icon: Icons.my_location,
                    onPressed: () => _mapController?.animateCamera(
                      CameraUpdate.newLatLng(_campusCenter),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildControlButton(
                    icon: Icons.refresh,
                    onPressed: _loadMarkers,
                  ),
                ],
              ),
            ),

            // Информация о количестве зданий
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Зданий на карте: ${provider.buildings.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.blue),
        ),
      ),
    );
  }
}
