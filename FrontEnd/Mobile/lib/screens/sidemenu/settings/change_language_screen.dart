import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:map_flutter/providers/locale_provider.dart';
import 'package:map_flutter/generated/l10n.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  late String _selectedLanguage;

  final List<Map<String, String>> languages = [
    {
      'name': 'English',
      'native': 'English',
      'flag': 'assets/flags/gb.png',
      'code': 'en',
    },
    {
      'name': 'Arabic',
      'native': 'العربية',
      'flag': 'assets/flags/sa.png',
      'code': 'ar',
    },
    {
      'name': 'Hindi',
      'native': 'हिन्दी',
      'flag': 'assets/flags/in.png',
      'code': 'hi',
    },
    {
      'name': 'French',
      'native': 'Français',
      'flag': 'assets/flags/fr.png',
      'code': 'fr',
    },
    {
      'name': 'German',
      'native': 'Deutsch',
      'flag': 'assets/flags/de.png',
      'code': 'de',
    },
    {
      'name': 'Portuguese',
      'native': 'Português',
      'flag': 'assets/flags/pt.png',
      'code': 'pt',
    },
    {
      'name': 'Turkish',
      'native': 'Türkçe',
      'flag': 'assets/flags/tr.png',
      'code': 'tr',
    },
    {
      'name': 'Dutch',
      'native': 'Nederlands',
      'flag': 'assets/flags/nl.png',
      'code': 'nl',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = Provider.of<LocaleProvider>(context, listen: false)
        .getCurrentLanguageCode();
  }

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
        title: Text(
          S.of(context).change_language,
          style: const TextStyle(
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
                children: languages
                    .map(
                      (language) => Column(
                        children: [
                          _buildLanguageItem(language),
                          const SizedBox(height: 16),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(Map<String, String> language) {
    bool isSelected = _selectedLanguage == language['code'];

    return GestureDetector(
      onTap: () async {
        setState(() {
          _selectedLanguage = language['code']!;
        });
        final provider = Provider.of<LocaleProvider>(context, listen: false);
        await provider.setLocale(language['code']!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).language_changed_success)),
          );
        }
      },
      child: Container(
        height: 64,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.50,
              color: isSelected
                  ? const Color(0xFF08B783)
                  : const Color(0xFFD0D0D0),
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
}
