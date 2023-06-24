import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 500) {
            return Center(
              child: SingleChildScrollView(
                child: _buildCard(),
              ),
            );
          } else {
            return Center(
              child: SingleChildScrollView(
                child: _buildContent()
              )
            );
          }
        },
      ),
    );
  }

  Card _buildCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: _buildContent()
    );
  }

  Padding _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(125),
            child: Image.asset(
              'assets/images/profile.jpg',
              width: 250,
              height: 250,
            ),
          ),
          const Text(
            'Ofek Gila',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Ph.D. Student, Computer Science @ UCI',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: [
              _buildIconButton(FontAwesomeIcons.github, 'https://github.com/ofekih', 'GitHub'),
              _buildIconButton(FontAwesomeIcons.linkedin, 'https://www.linkedin.com/in/ofek-gila/', 'LinkedIn'),
              _buildIconButton(FontAwesomeIcons.envelope, 'mailto:me@ofek.phd', 'Email'),
              _buildIconButton(FontAwesomeIcons.whatsapp, 'https://wa.me/14087056117', 'WhatsApp'),
              _buildIconButton(Icons.article, 'https://blog.theofekfoundation.org/', 'Blog'),
              _buildIconButton(Icons.web, 'https://theofekfoundation.org', 'Website'),
              _buildIconButton(Icons.family_restroom, 'https://gila.family/', 'Family'),
            ],
          ),
        ],
      ),
    );
  }

  IconButton _buildIconButton(IconData icon, String url, String tooltip) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => _launchURL(url),
      tooltip: tooltip,
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
