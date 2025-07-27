import 'package:flutter/material.dart';

class OwnerAdminPage extends StatefulWidget {
  const OwnerAdminPage({super.key});

  @override
  State<OwnerAdminPage> createState() => _OwnerAdminPageState();
}

class _OwnerAdminPageState extends State<OwnerAdminPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Owner Dashboard"),
        backgroundColor: Colors.teal,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Active"),
            Tab(text: "Upcoming"),
            Tab(text: "Past"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList("Active"),
          _buildBookingList("Upcoming"),
          _buildBookingList("Past"),
        ],
      ),
    );
  }

  Widget _buildBookingList(String status) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Image.network(
              "https://via.placeholder.com/80",
              fit: BoxFit.cover,
            ),
            title: const Text("Hotel: ITC Royal Bengal"),
            subtitle: const Text(
              "Guest: John Doe\nCheck-in: 12 Aug | Check-out: 14 Aug",
            ),
            trailing: Text(
              status,
              style: const TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
