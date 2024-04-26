import 'package:flutter/material.dart';
import 'package:ophd/screens/about_screen.dart';
import 'package:ophd/screens/education_screen.dart';
import 'package:ophd/screens/publication_screen.dart';
import 'package:ophd/screens/research_screen.dart';

import 'app_routes.dart';

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  final GlobalKey<NavigatorState> navigatorKey;

  AppRoute _currentRoute;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>(), _currentRoute = AppRoute.about;

  AppRoute get currentRoute => _currentRoute;

  set currentRoute(AppRoute value) {
    _currentRoute = value;
    notifyListeners();
  }

  // Called when the app should build the widget tree
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(child: AboutPage(), key: ValueKey('AboutPage')),
        if (currentRoute == AppRoute.research)
          const MaterialPage(child: ResearchPage(), key: ValueKey('ResearchPage')),
        if (currentRoute == AppRoute.publications)
          const MaterialPage(child: PublicationPage(), key: ValueKey('PublicationPage')),
        if (currentRoute == AppRoute.education)
          const MaterialPage(child: EducationPage(), key: ValueKey('EducationPage')),
        if (currentRoute == AppRoute.contact)
           const MaterialPage(child: AboutPage(), key: ValueKey('ContactPage')), //Temporary
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the current route logic here based on your app
        // Example: 
        if (currentRoute == AppRoute.research) {
          currentRoute = AppRoute.about;
        } else {
          // Decide where to go back to
        }
        return true;
      },
    );
  }

  // Called by Flutter to update the current configuration
  // (e.g., after the browser's back button is pressed)
  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    currentRoute = configuration;
    return; 
  }
}

class AppRouteInformationParser extends RouteInformationParser<AppRoute> {
  @override
  Future<AppRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '/');

    if (uri.pathSegments.isEmpty) {
      return AppRoute.about;
    }

    final pathSegment = uri.pathSegments[0];
    switch (pathSegment) {
      case 'research':
        return AppRoute.research;
      case 'publications':
        return AppRoute.publications;
      case 'education':
        return AppRoute.education;    
      case 'contact':
        return AppRoute.contact;  
      default:
        return AppRoute.about;
    }
  }

  // Converts an AppRoute back to URL string representation
  @override
  RouteInformation restoreRouteInformation(AppRoute configuration) {
    switch (configuration) {
      case AppRoute.about:
        return const RouteInformation(location: '/');
      case AppRoute.research:
        return const RouteInformation(location: '/research');
      case AppRoute.publications:
        return const RouteInformation(location: '/publications');
      case AppRoute.education:
        return const RouteInformation(location: '/education');
      case AppRoute.contact:
        return const RouteInformation(location: '/contact');  
      default:
        return const RouteInformation(location: '/');
    }
  }
}

