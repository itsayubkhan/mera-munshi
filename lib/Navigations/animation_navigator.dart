import 'package:flutter/material.dart';

class NavigationHelper {
  // A method to navigate to the target page with ease-in animation
  static Future<T?> navigateWithEaseIn<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push(_createEaseInRoute<T>(page));
  }

  // A private method that builds the ease-in animation using PageRouteBuilder
  static Route<T> _createEaseInRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start the transition from the right
        const end = Offset.zero;
        const curve = Curves.easeIn; // Apply the ease-in curve

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300), // Control animation speed
    );
  }
}
