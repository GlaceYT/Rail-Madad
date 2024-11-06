import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final List<Item> _faqItems = generateItems(3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Enhanced AppBar color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildPanel(),
        ),
      ),
      backgroundColor: Colors.grey[100], // Light background color
    );
  }

  Widget _buildPanel() {
    return Column(
      children: _faqItems.map((Item item) {
        return GestureDetector(
          onTap: () {
            setState(() {
              item.isExpanded = !item.isExpanded;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 16.0), // Space between each FAQ
            padding: const EdgeInsets.all(8.0), // Padding for card content
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: item.isExpanded
                    ? [Colors.pinkAccent, Colors.orangeAccent]
                    : [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26, // Shadow color
                  blurRadius: 8.0, // Shadow blur radius
                  offset: Offset(2, 2), // Shadow offset
                ),
              ],
            ),
            child: ExpansionPanelList(
              elevation: 0, // No extra elevation for the panels themselves
              expandedHeaderPadding: EdgeInsets.zero, // Remove extra header padding
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  item.isExpanded = !item.isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  backgroundColor: Colors.transparent, // Keep background transparent to show gradient
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(
                        item.headerValue,
                        style: const TextStyle(
                          fontSize: 18, // Bold and larger font
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text for contrast
                        ),
                      ),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0), // Reduced padding above answer (top=0)
                    child: Text(
                      item.expandedValue,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.3, // Slightly reduced line height
                        color: Colors.white70, // Lighter color for text
                      ),
                    ),
                  ),
                  isExpanded: item.isExpanded,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Stores the state of the FAQ items.
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

// Generates the list of FAQ items.
List<Item> generateItems(int numberOfItems) {
  return [
    Item(
      headerValue: 'What is RailMadad AI?',
      expandedValue: 'RailMadad AI is an AI-powered assistant for train-related queries.',
    ),
    Item(
      headerValue: 'How do I track my train?',
      expandedValue: 'You can track your train using the Track Train feature in the app.',
    ),
    Item(
      headerValue: 'How can I file a complaint?',
      expandedValue: 'Complaints can be filed under the Complaints section of the app.',
    ),
  ];
}
