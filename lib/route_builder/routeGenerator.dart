import 'package:assingment/Authentication/login_register.dart';
import 'package:assingment/Splash/splash_screen.dart';
import 'package:assingment/components/page_routeBuilder.dart';
import 'package:assingment/screen/cities_page.dart';
import 'package:assingment/screen/ev_dashboard.dart';
import 'package:assingment/screen/demand%20energy%20management/demandScreen.dart';
import 'package:assingment/screen/split_dashboard/split_dashboard.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/evDashboard':
        return CustomPageRoute(page: const EvDashboardScreen());

      case '/demand':
        return CustomPageRoute(page: DemandEnergyScreen());

      case '/cities':
        return CustomPageRoute(page: const CitiesPage());

      case '/login':
        return MaterialPageRoute(builder: (context) => LoginRegister());
      // CustomPageRoute(page: const LoginRegister());

      case '/splash':
        return CustomPageRoute(page: const SplashScreen());

      case '/splitDashboard':
        return CustomPageRoute(page: const SplitDashboard());
    }
    return CustomPageRoute(page: const SplitDashboard());
  }
}
