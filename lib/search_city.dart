// import 'dart:async';
// import 'dart:io' show Platform;
//
// import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
// import 'package:country_state_city_picker/country_state_city_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
//
// /// Defines the main theme color.
// final MaterialColor themeMaterialColor =
// BaseflowPluginExample.createMaterialColor(
//     const Color.fromRGBO(48, 49, 60, 1));
//
// /// Example [Widget] showing the functionalities of the geolocator plugin
// class GeolocatorWidget extends StatefulWidget {
//   /// Creates a new GeolocatorWidget.
//   const GeolocatorWidget({Key? key}) : super(key: key);
//
//   /// Utility method to create a page with the Baseflow templating.
//   static ExamplePage createPage() {
//     return ExamplePage(
//         Icons.location_on, (context) => const GeolocatorWidget());
//   }
//
//   @override
//   _GeolocatorWidgetState createState() => _GeolocatorWidgetState();
// }
//
// class _GeolocatorWidgetState extends State<GeolocatorWidget> {
//   static const String _kLocationServicesDisabledMessage =
//       'Location services are disabled.';
//   static const String _kPermissionDeniedMessage = 'Permission denied.';
//   static const String _kPermissionDeniedForeverMessage =
//       'Permission denied forever.';
//   static const String _kPermissionGrantedMessage = 'Permission granted.';
//
//   final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
//   final List<_PositionItem> _positionItems = <_PositionItem>[];
//   StreamSubscription<Position>? _positionStreamSubscription;
//   StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
//   bool positionStreamStarted = false;
//   String countryValue = '';
//   String stateValue = '';
//   String cityValue = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _toggleServiceStatusStream();
//
//   }
//
//   PopupMenuButton _createActions() {
//     return PopupMenuButton(
//       elevation: 40,
//       onSelected: (value) async {
//         switch (value) {
//           case 1:
//             _getLocationAccuracy();
//             break;
//           case 2:
//             _requestTemporaryFullAccuracy();
//             break;
//           case 3:
//             _openAppSettings();
//             break;
//           case 4:
//             _openLocationSettings();
//             break;
//           case 5:
//             setState(_positionItems.clear);
//             break;
//           default:
//             break;
//         }
//       },
//       itemBuilder: (context) => [
//         if (Platform.isIOS)
//           const PopupMenuItem(
//             child: Text("Get Location Accuracy"),
//             value: 1,
//           ),
//         if (Platform.isIOS)
//           const PopupMenuItem(
//             child: Text("Request Temporary Full Accuracy"),
//             value: 2,
//           ),
//         const PopupMenuItem(
//           child: Text("Open App Settings"),
//           value: 3,
//         ),
//         if (Platform.isAndroid || Platform.isWindows)
//           const PopupMenuItem(
//             child: Text("Open Location Settings"),
//             value: 4,
//           ),
//         const PopupMenuItem(
//           child: Text("Clear"),
//           value: 5,
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     const sizedBox = SizedBox(
//       height: 10,
//     );
//
//     return BaseflowPluginExample(
//
//
//         pluginName: 'Geolocator',
//         githubURL: 'https://github.com/Baseflow/flutter-geolocator',
//         pubDevURL: 'https://pub.dev/packages/geolocator',
//         appBarActions: [
//           _createActions()
//         ],
//         pages: [
//           ExamplePage(
//             Icons.location_on,
//                 (context) => Scaffold(
//               backgroundColor: Theme.of(context).colorScheme.surface,
//               body: Column(
//                 children: [
//                   SizedBox(
//                     height:200,
//                     child: SelectState(
//                       // style: TextStyle(color: Colors.red),
//                       onCountryChanged: (value) {
//                         setState(() {
//                           countryValue = value;
//                         });
//                       },
//                       onStateChanged: (value) {
//                         setState(() {
//                           stateValue = value;
//                         });
//                       },
//                       onCityChanged: (value) {
//                         setState(() {
//                           cityValue = value;
//                         });
//                       },
//                     ),
//                   ),
//
//                   SizedBox(height: 100,
//                     child: ListView.builder(
//                       itemCount: _positionItems.length,
//                       itemBuilder: (context, index) {
//                         final positionItem = _positionItems[index];
//
//                         if (positionItem.type == _PositionItemType.log) {
//                           return ListTile(
//                             title: Text(positionItem.displayValue,
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 )),
//                           );
//                         } else {
//                           return Card(
//                             child: ListTile(
//                               tileColor: themeMaterialColor,
//                               title: Text(
//                                 positionItem.displayValue,
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               floatingActionButton: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   FloatingActionButton(
//                     onPressed: () {
//                       positionStreamStarted = !positionStreamStarted;
//                       _toggleListening();
//                     },
//                     tooltip: (_positionStreamSubscription == null)
//                         ? 'Start position updates'
//                         : _positionStreamSubscription!.isPaused
//                         ? 'Resume'
//                         : 'Pause',
//                     backgroundColor: _determineButtonColor(),
//                     child: (_positionStreamSubscription == null ||
//                         _positionStreamSubscription!.isPaused)
//                         ? const Icon(Icons.play_arrow)
//                         : const Icon(Icons.pause),
//                   ),
//                   sizedBox,
//                   FloatingActionButton(
//                     onPressed: _getCurrentPosition,
//                     child: const Icon(Icons.my_location),
//                   ),
//                   sizedBox,
//                   FloatingActionButton(
//                     onPressed: _getLastKnownPosition,
//                     child: const Icon(Icons.bookmark),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ]);
//   }
//
//   Future<void> _getCurrentPosition() async {
//     final hasPermission = await _handlePermission();
//
//     if (!hasPermission) {
//       return;
//     }
//
//     final position = await _geolocatorPlatform.getCurrentPosition();
//     _updatePositionList(
//       _PositionItemType.position,
//       position.toString(),
//     );
//   }
//
//   Future<bool> _handlePermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       _updatePositionList(
//         _PositionItemType.log,
//         _kLocationServicesDisabledMessage,
//       );
//
//       return false;
//     }
//
//     permission = await _geolocatorPlatform.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await _geolocatorPlatform.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         _updatePositionList(
//           _PositionItemType.log,
//           _kPermissionDeniedMessage,
//         );
//
//         return false;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       _updatePositionList(
//         _PositionItemType.log,
//         _kPermissionDeniedForeverMessage,
//       );
//
//       return false;
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     _updatePositionList(
//       _PositionItemType.log,
//       _kPermissionGrantedMessage,
//     );
//     return true;
//   }
//
//   void _updatePositionList(_PositionItemType type, String displayValue) {
//     _positionItems.add(_PositionItem(type, displayValue));
//     setState(() {});
//   }
//
//   bool _isListening() => !(_positionStreamSubscription == null ||
//       _positionStreamSubscription!.isPaused);
//
//   Color _determineButtonColor() {
//     return _isListening() ? Colors.green : Colors.red;
//   }
//
//   void _toggleServiceStatusStream() {
//     if (_serviceStatusStreamSubscription == null) {
//       final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
//       _serviceStatusStreamSubscription =
//           serviceStatusStream.handleError((error) {
//             _serviceStatusStreamSubscription?.cancel();
//             _serviceStatusStreamSubscription = null;
//           }).listen((serviceStatus) {
//             String serviceStatusValue;
//             if (serviceStatus == ServiceStatus.enabled) {
//               if (positionStreamStarted) {
//                 _toggleListening();
//               }
//               serviceStatusValue = 'enabled';
//             } else {
//               if (_positionStreamSubscription != null) {
//                 setState(() {
//                   _positionStreamSubscription?.cancel();
//                   _positionStreamSubscription = null;
//                   _updatePositionList(
//                       _PositionItemType.log, 'Position Stream has been canceled');
//                 });
//               }
//               serviceStatusValue = 'disabled';
//             }
//             _updatePositionList(
//               _PositionItemType.log,
//               'Location service has been $serviceStatusValue',
//             );
//           });
//     }
//   }
//
//   void _toggleListening() {
//     if (_positionStreamSubscription == null) {
//       final positionStream = _geolocatorPlatform.getPositionStream();
//       _positionStreamSubscription = positionStream.handleError((error) {
//         _positionStreamSubscription?.cancel();
//         _positionStreamSubscription = null;
//       }).listen((position) => _updatePositionList(
//         _PositionItemType.position,
//         position.toString(),
//       ));
//       _positionStreamSubscription?.pause();
//     }
//
//     setState(() {
//       if (_positionStreamSubscription == null) {
//         return;
//       }
//
//       String statusDisplayValue;
//       if (_positionStreamSubscription!.isPaused) {
//         _positionStreamSubscription!.resume();
//         statusDisplayValue = 'resumed';
//       } else {
//         _positionStreamSubscription!.pause();
//         statusDisplayValue = 'paused';
//       }
//
//       _updatePositionList(
//         _PositionItemType.log,
//         'Listening for position updates $statusDisplayValue',
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     if (_positionStreamSubscription != null) {
//       _positionStreamSubscription!.cancel();
//       _positionStreamSubscription = null;
//     }
//
//     super.dispose();
//   }
//
//   void _getLastKnownPosition() async {
//     final position = await _geolocatorPlatform.getLastKnownPosition();
//     if (position != null) {
//       _updatePositionList(
//         _PositionItemType.position,
//         position.toString(),
//       );
//     } else {
//       _updatePositionList(
//         _PositionItemType.log,
//         'No last known position available',
//       );
//     }
//   }
//
//   void _getLocationAccuracy() async {
//     final status = await _geolocatorPlatform.getLocationAccuracy();
//     _handleLocationAccuracyStatus(status);
//   }
//
//   void _requestTemporaryFullAccuracy() async {
//     final status = await _geolocatorPlatform.requestTemporaryFullAccuracy(
//       purposeKey: "TemporaryPreciseAccuracy",
//     );
//     _handleLocationAccuracyStatus(status);
//   }
//
//   void _handleLocationAccuracyStatus(LocationAccuracyStatus status) {
//     String locationAccuracyStatusValue;
//     if (status == LocationAccuracyStatus.precise) {
//       locationAccuracyStatusValue = 'Precise';
//     } else if (status == LocationAccuracyStatus.reduced) {
//       locationAccuracyStatusValue = 'Reduced';
//     } else {
//       locationAccuracyStatusValue = 'Unknown';
//     }
//     _updatePositionList(
//       _PositionItemType.log,
//       '$locationAccuracyStatusValue location accuracy granted.',
//     );
//   }
//
//   void _openAppSettings() async {
//     final opened = await _geolocatorPlatform.openAppSettings();
//     String displayValue;
//
//     if (opened) {
//       displayValue = 'Opened Application Settings.';
//     } else {
//       displayValue = 'Error opening Application Settings.';
//     }
//
//     _updatePositionList(
//       _PositionItemType.log,
//       displayValue,
//     );
//   }
//
//   void _openLocationSettings() async {
//     final opened = await _geolocatorPlatform.openLocationSettings();
//     String displayValue;
//
//     if (opened) {
//       displayValue = 'Opened Location Settings';
//     } else {
//       displayValue = 'Error opening Location Settings';
//     }
//
//     _updatePositionList(
//       _PositionItemType.log,
//       displayValue,
//     );
//   }
// }
//
// enum _PositionItemType {
//   log,
//   position,
// }
//
// class _PositionItem {
//   _PositionItem(this.type, this.displayValue);
//
//   final _PositionItemType type;
//   final String displayValue;
// }


import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:country_code_picker/country_code_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localisation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GeolocatorPage(),
    );
  }
}

class GeolocatorPage extends StatefulWidget {
  const GeolocatorPage({super.key});

  @override
  State<GeolocatorPage> createState() => _GeolocatorPageState();
}

class _GeolocatorPageState extends State<GeolocatorPage> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  String countryValue = '';
  String stateValue = '';
  String cityValue = '';
  String countryCode = '';

  // Données simplifiées pour les régions et villes
  final Map<String, List<String>> states = {
    'FR': ['Île-de-France', 'Auvergne-Rhône-Alpes', 'Provence-Alpes-Côte d\'Azur'],
    'US': ['California', 'Texas', 'New York'],
  };

  final Map<String, List<String>> cities = {
    'Île-de-France': ['Paris', 'Versailles', 'Boulogne-Billancourt'],
    'California': ['Los Angeles', 'San Francisco', 'San Diego'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localisation'),
        actions: [_createActions()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Sélecteur de pays avec country_code_picker
            Card(
              elevation: 2,
              child: ListTile(
                title: const Text('Pays'),
                subtitle: Text(countryValue.isNotEmpty ? countryValue : 'Non sélectionné'),
                trailing: CountryCodePicker(
                  onChanged: (CountryCode code) {
                    setState(() {
                      countryCode = code.code ?? '';
                      countryValue = code.name ?? '';
                      stateValue = '';
                      cityValue = '';
                    });
                  },
                  initialSelection: countryCode.isNotEmpty ? countryCode : 'FR',
                  favorite: const ['FR', 'US'],
                  showCountryOnly: true,
                  showOnlyCountryWhenClosed: true,
                  alignLeft: false,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Sélecteur de région/état
            if (countryCode.isNotEmpty)
              DropdownButtonFormField<String>(
                value: stateValue.isEmpty ? null : stateValue,
                decoration: const InputDecoration(
                  labelText: 'Région/État',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: states[countryCode]?.map((state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    stateValue = value ?? '';
                    cityValue = '';
                  });
                },
              ),

            const SizedBox(height: 20),

            // Sélecteur de ville
            if (stateValue.isNotEmpty)
              DropdownButtonFormField<String>(
                value: cityValue.isEmpty ? null : cityValue,
                decoration: const InputDecoration(
                  labelText: 'Ville',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: cities[stateValue]?.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    cityValue = value ?? '';
                  });
                },
              ),

            const SizedBox(height: 30),

            // Affichage de la sélection
            if (countryValue.isNotEmpty || stateValue.isNotEmpty || cityValue.isNotEmpty)
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (countryValue.isNotEmpty)
                        Text('Pays: $countryValue', style: const TextStyle(fontSize: 16)),
                      if (stateValue.isNotEmpty)
                        Text('Région: $stateValue', style: const TextStyle(fontSize: 16)),
                      if (cityValue.isNotEmpty)
                        Text('Ville: $cityValue', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Boutons de localisation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'current_location',
                  onPressed: _getCurrentPosition,
                  tooltip: 'Position actuelle',
                  child: const Icon(Icons.my_location),
                ),
                FloatingActionButton(
                  heroTag: 'last_location',
                  onPressed: _getLastKnownPosition,
                  tooltip: 'Dernière position connue',
                  child: const Icon(Icons.history),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<int> _createActions() {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        if (Platform.isIOS)
          const PopupMenuItem<int>(
            value: 1,
            child: Text("Précision de localisation"),
          ),
        const PopupMenuItem<int>(
          value: 2,
          child: Text("Paramètres de l'application"),
        ),
        if (Platform.isAndroid)
          const PopupMenuItem<int>(
            value: 3,
            child: Text("Paramètres de localisation"),
          ),
      ],
      onSelected: (value) {
        switch (value) {
          case 1:
            _getLocationAccuracy();
            break;
          case 2:
            _openAppSettings();
            break;
          case 3:
            _openLocationSettings();
            break;
        }
      },
    );
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;

    try {
      final position = await _geolocatorPlatform.getCurrentPosition();
      // Ici vous pourriez inverser le géocodage pour obtenir le pays/ville
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Position: ${position.latitude}, ${position.longitude}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Services de localisation désactivés')),
      );
      return false;
    }

    LocationPermission permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission refusée')),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission définitivement refusée')),
      );
      return false;
    }

    return true;
  }

  Future<void> _getLastKnownPosition() async {
    final position = await _geolocatorPlatform.getLastKnownPosition();
    if (position != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dernière position: ${position.latitude}, ${position.longitude}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune position connue')),
      );
    }
  }

  void _getLocationAccuracy() async {
    if (Platform.isIOS) {
      final status = await _geolocatorPlatform.getLocationAccuracy();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Précision: ${status.toString()}')),
      );
    }
  }

  void _openAppSettings() async {
    final opened = await _geolocatorPlatform.openAppSettings();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(opened ? 'Paramètres ouverts' : 'Échec d\'ouverture')),
    );
  }

  void _openLocationSettings() async {
    if (Platform.isAndroid) {
      final opened = await _geolocatorPlatform.openLocationSettings();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(opened ? 'Paramètres de localisation ouverts' : 'Échec d\'ouverture')),
      );
    }
  }
}