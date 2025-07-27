import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
        backgroundColor: Colors.blue,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Current"),
            Tab(text: "Past"),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildProfileSection(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList("Current Bookings"),
                _buildBookingList("Past Bookings"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage("https://via.placeholder.com/150"),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "John Doe",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("johndoe@mail.com", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(String title) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
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
            title: Text("ITC Royal Bengal"),
            subtitle: Text("Check-in: 12 Aug | Check-out: 14 Aug"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "₹15,000",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  title == "Current Bookings" ? "Active" : "Completed",
                  style: TextStyle(
                    color: title == "Current Bookings"
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
