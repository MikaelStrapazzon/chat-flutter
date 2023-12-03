import 'package:flutter/material.dart';

import '../../pages/DashboardPage/dashboard_page.dart';

class LoggedLayout extends StatefulWidget {
  const LoggedLayout(
      {Key? key,
      required this.body,
      required this.appBar,
      this.floatingActionButton})
      : super(key: key);

  final PreferredSizeWidget appBar;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  State<StatefulWidget> createState() => _LoggedLayoutState();
}

class _LoggedLayoutState extends State<LoggedLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF6750A4)),
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/logos/logo.png'),
                    width: 90,
                  ),
                  Text(
                    'Semplice Moda ERP',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.insert_chart_outlined),
              title: const Text('Dashboard'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardPage())),
            ),
          ],
        ),
      ),
    );
  }
}
