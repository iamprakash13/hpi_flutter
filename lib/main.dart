import 'package:flutter/material.dart' hide Route;
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/route.dart';
import 'package:provider/provider.dart';

import 'app/services/navigation.dart';
import 'news/widgets/news_page.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      Provider<NavigationService>(
        builder: (_) => NavigationService(),
      ),
      Provider<ClientChannel>(
        builder: (_) => ClientChannel(
          "172.18.132.7",
          port: 50061,
          options: ChannelOptions(
            credentials: ChannelCredentials.insecure(),
          ),
        ),
      ),
    ], child: HpiApp()),
  );
}

const _brandColorRed = 0xFFB1063A;
const _brandColorRedSwatch = MaterialColor(
  _brandColorRed,
  <int, Color>{
    50: Color(0xFFFBE2E6),
    100: Color(0xFFF6B6C1),
    200: Color(0xFFEE8799),
    300: Color(0xFFE55872),
    400: Color(0xFFDD3656),
    500: Color(0xFFD4143D),
    600: Color(0xFFC50E3C),
    700: Color(_brandColorRed),
    800: Color(0xFF9E0037),
    900: Color(0xFF7C0033),
  },
);
const _brandColorOrange = 0xFFDD6108;
const _brandColorOrangeSwatch = MaterialColor(
  _brandColorOrange,
  <int, Color>{
    50: Color(0xFFFDF4E2),
    100: Color(0xFFFBE3B6),
    200: Color(0xFFF9D186),
    300: Color(0xFFF8BE56),
    400: Color(0xFFF7B033),
    500: Color(0xFFF6A21B),
    600: Color(0xFFF29716),
    700: Color(0xFFED8711),
    800: Color(0xFFE6780D),
    900: Color(_brandColorOrange),
  },
);
const _brandColorYellow = 0xFFF6A804;

class HpiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HPI',
      theme: ThemeData(
        primarySwatch: _brandColorRedSwatch,
        accentColor: Color(_brandColorOrange),
      ),
      initialRoute: Route.dashboard.name,
      onGenerateRoute: Route.generateRoute,
      navigatorObservers: [
        NavigationObserver(Provider.of<NavigationService>(context)),
      ],
    );
  }
}
