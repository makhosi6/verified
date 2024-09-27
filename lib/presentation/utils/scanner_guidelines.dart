import 'package:flutter/material.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/document_type.dart';

class ScanDocsGuidelines extends StatefulWidget {
  final DocumentType? documentType;

  const ScanDocsGuidelines({super.key, required this.documentType});

  @override
  State<ScanDocsGuidelines> createState() => _ScanDocsGuidelinesState();
}

class _ScanDocsGuidelinesState extends State<ScanDocsGuidelines> {
  ///
  bool _isOpen = true;

  ///
  void toggle() {
    if (mounted) {
      setState(() {
        _isOpen = !_isOpen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var windowSize = MediaQuery.of(context).size.width;
    List<String>? guidelines = _guidelines[widget.documentType?.name ?? 'general']?.whereType<String>().toList() ?? _guidelines['general']?.whereType<String>().toList() ?? [];

    if (!_isOpen) {
      return Positioned(
        top: widget.documentType == null ? 40 : 20,
        left: widget.documentType != null ? 20 : null,
        right: widget.documentType == null ? 20 : null,
        child: Hero(
          tag: 'read_guidelines_btn1',
          transitionOnUserGestures: true,
          child: IconButton(
            alignment: Alignment.topLeft,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 234, 248, 238)),
              padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
            ),
            icon: Icon(Icons.help_rounded, color: Colors.grey.shade900),
            onPressed: toggle,
          ),
        ),
      );
    }

    return AnimatedPositioned(
      top: widget.documentType == null ? 40 : 20,
      left: widget.documentType != null ? 10 : null,
      right: widget.documentType == null ? 0 : null,
      width: _isOpen
          ? (((windowSize > appConstraints.constrainWidth()) ? appConstraints.constrainWidth() : windowSize) - 10)
          : 0,
      height: _isOpen ? null : 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticInOut,
      child: Hero(
        tag: 'read_guidelines_btn1',
        transitionOnUserGestures: true,
        child: Container(
          width: MediaQuery.of(context).size.width - 10,
          margin: const EdgeInsets.only(right: 10),
          child: Card(
            elevation: 5,
            color: const Color.fromARGB(255, 234, 248, 238),
            child: Container(
              padding: primaryPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.help_rounded,
                          size: 28,
                          color: Colors.grey.shade800,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Guidelines',
                          style: TextStyle(color: Colors.grey.shade800, fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  ...guidelines.map(
                    (guideline) => Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 4),
                      child: Text(
                        '\u2022  $guideline',
                        style: TextStyle(color: Colors.grey.shade800),
                        maxLines: 3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: OutlinedButton(
                        onPressed: toggle,
                        style: ButtonStyle(side: WidgetStateProperty.all(BorderSide(color: primaryColor))),
                        child: const Text('Close')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _guidelines = {
  'id_card': [
    'Position your ID card within the on-screen guidelines.',
    'Ensure the card is correctly aligned and clear.',
    'Scan both the front and back sides.',
    'If you need to retry, touch and hold the image preview (top-right).',
    'Good lighting and a bright/white background are REQUIRED for it to work.'
  ],
  'id_book': [
    'Position the two main pages of your ID book within the guidelines.',
    'Align the pages from left to right (page 1 to page 2).',
    'Ensure both pages are clear and correctly positioned.',
    'If you need to retry, touch and hold the image preview (top-right).',
    'Good lighting and a bright/white background are REQUIRED for it to work.'
  ],
  'passport': [
    "Place your passport's main/front page within the guidelines.",
    'Ensure the page is clear and properly aligned.',
    'If you need to retry, touch and hold the image preview (top-right).',
    'Good lighting and a bright/white background are REQUIRED for it to work.'
  ],
  'general': [
    'Position your face within the on-screen guidelines.',
    'Ensure all images are clear.',
    'Good lighting and a bright/white background are REQUIRED for it to work.'
  ]
};
