import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const Lab02Screen(),
    );
  }
}

class Lab02Screen extends StatefulWidget {
  const Lab02Screen({super.key});

  @override
  State<Lab02Screen> createState() => _Lab02ScreenState();
}

class _Lab02ScreenState extends State<Lab02Screen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedRole = 'Gryffindor';
  final List<String> _roles = ['Gryffindor', 'Slytherin', 'Ravenclaw', 'Hufflepuff'];

  // --- Material Date Picker ---
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // --- Cupertino Date Picker ---
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _selectedDate,
          onDateTimeChanged: (DateTime newDate) {
            setState(() => _selectedDate = newDate);
          },
        ),
      ),
    );
  }

  // --- Cupertino Role Wheel Picker ---
  void _showCupertinoRolePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 200,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
            initialItem: _roles.indexOf(_selectedRole),
          ),
          onSelectedItemChanged: (int index) {
            setState(() => _selectedRole = _roles[index]);
          },
          children: _roles.map((role) => Center(child: Text(role))).toList(),
        ),
      ),
    );
  }

  Widget _buildPortraitView() {
    return ListView(
      children: [
        _buildProfileCard(),
        const TitleSection(
          name: 'Hogwarts School of Witchcraft and Wizardry',
          location: 'Hogsmeade, Scotland',
          starCount: 41,
        ),
        Image.asset('assests/landscape.jpeg', fit: BoxFit.cover),
        _buildPickersSection(),
      ],
    );
  }

  Widget _buildLandscapeView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: _buildProfileCard(),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              const TitleSection(
                name: 'Hogwarts School of Witchcraft and Wizardry',
                location: 'Hogsmeade, Scotland',
                starCount: 41,
              ),
              Image.asset('assests/landscape.jpeg', fit: BoxFit.cover),
              _buildPickersSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.indigo,
                backgroundImage: AssetImage('assests/profile.jpeg'),
              ),
              SizedBox(height: 20),
              Text(
                'Ling Wang Cheng',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Student ID: BCS24020048',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Divider(height: 32, thickness: 1),
              Text(
                'Personal Life Goal / Quote:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                '"To become a successful software engineer and build impactful applications."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickersSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.indigo.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Interactive Pickers (Lab 2.2)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Divider(),
              Text('Selected Date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
              Text('Selected House: $_selectedRole'),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () => _selectMaterialDate(context),
                icon: const Icon(Icons.date_range),
                label: const Text('Material Date Picker'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _showCupertinoDatePicker(context),
                icon: const Icon(CupertinoIcons.calendar),
                label: const Text('Cupertino Date Picker (Modal Sheet)'),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Material Dropdown: '),
                  DropdownButton<String>(
                    value: _selectedRole,
                    items: _roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => _selectedRole = newValue);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _showCupertinoRolePicker(context),
                icon: const Icon(CupertinoIcons.list_bullet),
                label: const Text('Cupertino House Wheel Picker'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}