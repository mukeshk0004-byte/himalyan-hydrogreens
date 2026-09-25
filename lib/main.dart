import 'package:flutter/material.dart';

void main() {
  runApp(const HimalyanApp());
}

class HimalyanApp extends StatelessWidget {
  const HimalyanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Himalyan Hydrogreens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class UserModel {
  final String username;
  final String role;
  final String assignedSite;

  UserModel({required this.username, required this.role, required this.assignedSite});
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  final Map<String, Map<String, String>> validUsers = {
    'owner': {'pass': 'admin123', 'role': 'owner', 'site': 'ALL'},
    'sup_site1': {'pass': '1234', 'role': 'supervisor', 'site': 'Site 1'},
    'sup_banuna': {'pass': '1234', 'role': 'supervisor', 'site': 'Banuna'},
    'sup_site3': {'pass': '1234', 'role': 'supervisor', 'site': 'Site 3'},
    'sup_site4': {'pass': '1234', 'role': 'supervisor', 'site': 'Site 4'},
    'sup_site5': {'pass': '1234', 'role': 'supervisor', 'site': 'Site 5'},
  };

  void _login() {
    String u = _userController.text.trim().toLowerCase();
    String p = _passController.text.trim();

    if (validUsers.containsKey(u) && validUsers[u]!['pass'] == p) {
      UserModel user = UserModel(
        username: u,
        role: validUsers[u]!['role']!,
        assignedSite: validUsers[u]!['site']!,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainDashboard(user: user)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Galat Username ya Password!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.eco, size: 64, color: Color(0xFF2E7D32)),
                  const SizedBox(height: 12),
                  const Text(
                    'Himalyan Hydrogreens',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text('Farm Management System', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _userController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _login,
                      child: const Text('LOGIN', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Owner: owner / admin123\nSupervisor: sup_banuna / 1234',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainDashboard extends StatelessWidget {
  final UserModel user;
  const MainDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    bool isOwner = user.role == 'owner';

    return Scaffold(
      appBar: AppBar(
        title: Text(isOwner ? 'Owner Dashboard' : 'Site: ${user.assignedSite}'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFFE8F5E9),
            child: ListTile(
              leading: Icon(isOwner ? Icons.admin_panel_settings : Icons.location_on, color: const Color(0xFF2E7D32)),
              title: Text('User: ${user.username.toUpperCase()}'),
              subtitle: Text(isOwner ? 'All 5 Sites Active' : 'Assigned: ${user.assignedSite}'),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Farm Operations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _moduleTile(context, Icons.grass, 'Nursery & Sowing', 'Seeds, Qty, Mortality check', () => _openForm(context, 'Nursery & Sowing')),
          _moduleTile(context, Icons.swap_horiz, 'Transplants', 'Shift nursery to field/tunnels', () => _openForm(context, 'Transplants')),
          _moduleTile(context, Icons.agriculture, 'Harvesting Logs', 'Daily harvesting weight & tunnels', () => _openForm(context, 'Harvesting')),
          _moduleTile(context, Icons.people, 'Labour Management', 'Daily wages, attendance, advance', () => _openForm(context, 'Labour')),
          _moduleTile(context, Icons.inventory_2, 'Stock / Inventory', 'Fertilizer, seed usage & stock', () => _openForm(context, 'Stock')),
          
          if (isOwner) ...[
            const SizedBox(height: 16),
            const Text('Owner Only Controls', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 10),
            _moduleTile(context, Icons.account_balance_wallet, 'Finance & Expenses', 'All site expenses & bills', () => _openForm(context, 'Finance')),
            _moduleTile(context, Icons.analytics, 'Consolidated Reports', 'Summary across all 5 sites', () => _openForm(context, 'Reports')),
          ]
        ],
      ),
    );
  }

  Widget _moduleTile(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8F5E9),
          child: Icon(icon, color: const Color(0xFF2E7D32)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _openForm(BuildContext context, String moduleName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenericFormScreen(moduleName: moduleName, user: user),
      ),
    );
  }
}

class GenericFormScreen extends StatefulWidget {
  final String moduleName;
  final UserModel user;
  const GenericFormScreen({super.key, required this.moduleName, required this.user});

  @override
  State<GenericFormScreen> createState() => _GenericFormScreenState();
}

class _GenericFormScreenState extends State<GenericFormScreen> {
  final _field1 = TextEditingController();
  final _field2 = TextEditingController();
  final _field3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String siteLabel = widget.user.role == 'owner' ? 'All Sites' : widget.user.assignedSite;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.moduleName} Entry'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Site: $siteLabel', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            const SizedBox(height: 10),
            TextField(
              controller: _field1,
              decoration: const InputDecoration(labelText: 'Item / Variety / Labour Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _field2,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity / Weight (Kg) / Wage / Hours', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _field3,
              decoration: const InputDecoration(labelText: 'Tunnel / Field / Remarks', border: OutlineInputBorder()),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white),
                icon: const Icon(Icons.save),
                label: const Text('SAVE RECORD'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${widget.moduleName} entry saved successfully!')),
                  );
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
