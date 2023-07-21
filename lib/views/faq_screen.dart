import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'How does the Party People business application function?',
      answer:
          'First, organisations must register with the application with attractive profiles and offers that may be seen by the public. Party People is an application designed for promoting events and parties with full control and monitoring of the events. The audience will be able to compare, explore, and select the events in a way that works best for them by viewing your party event and organization with all of its amenities.',
    ),
    FAQItem(
      question: 'What are the Regular and Popular parties? ',
      answer:
          'Regular parties: whenever an organisation posts a party or event. Once the admin has accepted the party post, it becomes accessible to the audience and is categorized as today\'s, tomorrow\'s, and upcoming parties.\n\n'
          'Popular Parties: When your party is a regular party, you can make it a popular party by boosting it; popular parties are displayed as the popular events at the top of the home screen. Popular parties draw attention from the public by appearing at the top of the audience\'s home screen.',
    ),
    FAQItem(
      question: 'How does the Party People business application function?',
      answer:
          'First, organisations must register with the application with attractive profiles and offers that may be seen by the public. Party People is an application designed for promoting events and parties with full control and monitoring of the events. The audience will be able to compare, explore, and select the events in a way that works best for them by viewing your party event and organization with all of its amenities.',
    ),
    FAQItem(
      question:
          'How do I obtain ratings in the Party People business application?',
      answer:
          'The amenities you offer the audience determine how well the organisation is rated. By going to the organisation\'s edit profile page, you can alter your profile at any moment. When you register a business application for a party, one of our representatives will inspect the organisation. When he submits his report to the admin, you will receive ratings. You may download the standard rating system by selecting the "Get Verified" option in the application menu bar. The ratings provided by the party people application are based on the standards and rules of the firm, which depend on the facilities, location, and many other aspects.',
    ),
    FAQItem(
      question: 'How do I gain likes, views, and comments on my events?',
      answer:
          'The symbols displayed in the home screens allow you to readily monitor likes, views, and going; these parameters represent the aggregate of all party likes, views, and going; whenever audience members tap on the further parameters, you will be notified.If I forget my user name,Your user name is very sensitive. If you forget it, speak to one of our representatives to get it, or contact us through our website\'s contact form.',
    ),
    // Add more FAQItems as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ\'s'),
      ),
      body: ListView.builder(
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          return FAQItemTile(item: faqItems[index]);
        },
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class FAQItemTile extends StatefulWidget {
  final FAQItem item;

  FAQItemTile({required this.item});

  @override
  _FAQItemTileState createState() => _FAQItemTileState();
}

class _FAQItemTileState extends State<FAQItemTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.item.question,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            widget.item.answer,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
      ],
      onExpansionChanged: (expanded) {
        setState(() {
          isExpanded = expanded;
        });
      },
    );
  }
}
