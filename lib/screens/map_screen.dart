import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen({
    this.initialLocation =
        const PlaceLocation(latitude: 8.5436032, longitude: 76.9036209),
    this.isSelecting = false,
  });
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selectLocation(_, LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
              icon: Icon(Icons.check),
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 13,
          onTap: widget.isSelecting ? _selectLocation : null,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/knowaslamts/cl5s1s65v000314sefd47qjo6/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia25vd2FzbGFtdHMiLCJhIjoiY2w1cnQ3ZXhpMDV1MjNjcXdvcG8waHJqZiJ9.4WrBx4mNp6Iz1_2V9hRyTw',
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1Ijoia25vd2FzbGFtdHMiLCJhIjoiY2w1cnQ3ZXhpMDV1MjNjcXdvcG8waHJqZiJ9.4WrBx4mNp6Iz1_2V9hRyTw',
              'id': 'mapbox.country-boundaries-v1',
            },
          ),
          MarkerLayerOptions(
              markers: (_pickedLocation == null && widget.isSelecting)
                  ? []
                  : [
                      Marker(
                        point: _pickedLocation ??
                            LatLng(
                              widget.initialLocation.latitude,
                              widget.initialLocation.longitude,
                            ),
                        builder: (ctx) => Icon(
                          Icons.location_on,
                          color: Colors.red[900],
                        ),
                        width: 50,
                        height: 50,
                      )
                    ])
        ],
      ),
    );
  }
}
