// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';

// class InternetBanner extends StatefulWidget {
//   final Widget child;
//   const InternetBanner({Key? key, required this.child}) : super(key: key);

//   @override
//   State<InternetBanner> createState() => _InternetBannerState();
// }

// class _InternetBannerState extends State<InternetBanner>
//     with SingleTickerProviderStateMixin {
//   bool _isConnected = true;
//   late final AnimationController _controller;
//   late final Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Animation controller for slide down effect
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, -1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     _checkInternet();
//     Connectivity().onConnectivityChanged.listen((_) => _checkInternet());
//   }

//   Future<void> _checkInternet() async {
//     bool result = await InternetConnectionChecker().hasConnection;
//     if (result != _isConnected) {
//       setState(() {
//         _isConnected = result;
//       });

//       // Animate banner
//       if (!_isConnected) {
//         _controller.forward();
//       } else {
//         _controller.reverse();
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Your app content
//         Positioned.fill(child: widget.child),

//         // Sliding banner
//         Positioned(
//           top: 0,
//           left: 0,
//           right: 0,
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: SafeArea(
//               bottom: false,
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: 16,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade700,
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 6,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Icons.wifi_off, color: Colors.white),
//                     SizedBox(width: 8),
//                     Text(
//                       "No Internet Connection",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetBanner extends StatefulWidget {
  final Widget child;
  const InternetBanner({Key? key, required this.child}) : super(key: key);

  @override
  State<InternetBanner> createState() => _InternetBannerState();
}

class _InternetBannerState extends State<InternetBanner>
    with TickerProviderStateMixin {
  bool _isConnected = true;

  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Slide animation controller
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
        );

    // Pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _pulseController.forward();
      }
    });

    _checkInternet();
    Connectivity().onConnectivityChanged.listen((_) => _checkInternet());
  }

  Future<void> _checkInternet() async {
    // bool result = await InternetConnectionChecker().hasConnection;

    bool result;

    if (kIsWeb) {
      // On Web, try a simple HTTP GET
      try {
        var connectivityResult = await Connectivity().checkConnectivity();
        result = connectivityResult != ConnectivityResult.none;
      } catch (_) {
        result = false;
      }
    } else {
      // On Mobile/Desktop, use connectivity + InternetConnectionChecker
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        result = false;
      } else {
        result = await InternetConnectionChecker().hasConnection;
      }
    }

    if (result != _isConnected) {
      setState(() {
        _isConnected = result;
      });

      // Slide animation
      if (!_isConnected) {
        _slideController.forward();
        _pulseController.forward();
      } else {
        _slideController.reverse();
        _pulseController.stop();
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        // Sliding + Pulsing banner
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: _slideAnimation,
            child: SafeArea(
              bottom: false,
              child: Center(
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                    ), // good for tablets
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "No Internet Connection",

                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
