import 'package:flutter/material.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  String _selectedLanguage = 'English';

  final List<Map<String, dynamic>> languages = [
    {
      'name': 'English',
      'native': 'English',
      'flag': 'assets/flags/gb.png',
    },
    {
      'name': 'Arabic',
      'native': 'العربية',
      'flag': 'assets/flags/sa.png',
    },
    {
      'name': 'Hindi',
      'native': 'हिन्दी',
      'flag': 'assets/flags/in.png',
    },
    {
      'name': 'French',
      'native': 'Français',
      'flag': 'assets/flags/fr.png',
    },
    {
      'name': 'German',
      'native': 'Deutsch',
      'flag': 'assets/flags/de.png',
    },
    {
      'name': 'Portuguese',
      'native': 'Português',
      'flag': 'assets/flags/pt.png',
    },
    {
      'name': 'Turkish',
      'native': 'Türkçe',
      'flag': 'assets/flags/tr.png',
    },
    {
      'name': 'Dutch',
      'native': 'Nederlands',
      'flag': 'assets/flags/nl.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Change Language',
          style: TextStyle(
            color: Color(0xFF2A2A2A),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: languages.map((language) => 
                  Column(
                    children: [
                      _buildLanguageItem(language),
                      const SizedBox(height: 16),
                    ],
                  ),
                ).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008955),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(Map<String, dynamic> language) {
    bool isSelected = language['name'] == _selectedLanguage;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = language['name']!;
        });
      },
      child: Container(
        height: 64,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.50,
              color: isSelected ? const Color(0xFF08B783) : const Color(0xFFD0D0D0),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3D000000),
              blurRadius: 1,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  language['flag']!,
                  width: 46,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 46,
                      height: 32,
                      color: Colors.grey[300],
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language['name']!,
                      style: const TextStyle(
                        color: Color(0xFF5A5A5A),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      language['native']!,
                      style: const TextStyle(
                        color: Color(0xFFB8B8B8),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF08B783),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    // Add your language change logic here
    // You can access the selected language using _selectedLanguage
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Language changed to $_selectedLanguage')),
    );
    Navigator.pop(context);
  }
}
