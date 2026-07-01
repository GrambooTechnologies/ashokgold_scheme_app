import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatelessWidget {
  static const String routeName = '/privacy-policy';

  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Palette.blackColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Palette.blackColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
            vertical: h * 0.03,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.05,
              vertical: h * 0.04,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Paragraph(
                  'Effective Date: December 2024\n'
                  'Last Updated: December 2024\n\n'
                  'Anaswara Jewellery Gold Scheme Application ("we", "our", "us") '
                  'is committed to protecting your privacy. This Privacy Policy '
                  'explains how we collect, use, store, and safeguard your information.',
                ),
                _Divider(),
                _SectionTitle('1. Introduction'),
                _Paragraph(
                  'This Privacy Policy describes how we manage personal and financial '
                  'information collected through our gold savings and jewellery '
                  'scheme platform.',
                ),
                _Divider(),
                _SectionTitle('2. Information We Collect'),
                _Paragraph(
                  'We may collect the following information:\n\n'
                  '• Full name, address, phone number, and email\n'
                  '• Government identification (if required)\n'
                  '• Bank or payment details\n'
                  '• Scheme enrollment details\n'
                  '• Nominee and beneficiary information\n'
                  '• Device and usage information',
                ),
                _Divider(),
                _SectionTitle('3. Payment & Financial Information'),
                _Paragraph(
                  'All payments are processed through authorized and secure '
                  'payment gateway partners. We do not store complete card '
                  'details on our servers.\n\n'
                  'Transaction records are maintained for accounting and '
                  'legal compliance purposes.',
                ),
                _Divider(),
                _SectionTitle('4. How We Use Your Information'),
                _Paragraph(
                  'We use your data to:\n\n'
                  '• Manage gold savings schemes\n'
                  '• Process monthly payments\n'
                  '• Allocate gold purchases\n'
                  '• Verify identity\n'
                  '• Provide customer support\n'
                  '• Send alerts and notifications\n'
                  '• Prevent fraud',
                ),
                _Divider(),
                _SectionTitle('5. Data Security'),
                _Paragraph(
                  'We use industry-standard security measures including '
                  'encryption, secure servers, and restricted access to '
                  'protect your information.',
                ),
                _Divider(),
                _SectionTitle('6. Data Retention'),
                _Paragraph(
                  'We retain customer data only as long as required for '
                  'business, legal, and regulatory purposes. Data is '
                  'securely deleted when no longer needed.',
                ),
                _Divider(),
                _SectionTitle('7. Information Sharing'),
                _Paragraph(
                  'Your information may be shared only with:\n\n'
                  '• Payment gateway providers\n'
                  '• Banking partners\n'
                  '• Government authorities (when required)\n'
                  '• Legal and audit agencies\n\n'
                  'We do not sell your personal data.',
                ),
                _Divider(),
                _SectionTitle('8. Third-Party Services'),
                _Paragraph(
                  'We integrate with third-party services for payments, '
                  'SMS delivery, analytics, and cloud hosting. These '
                  'providers follow their own privacy policies.',
                ),
                _Divider(),
                _SectionTitle('9. Your Rights'),
                _Paragraph(
                  'You have the right to:\n\n'
                  '• Access your personal data\n'
                  '• Request corrections\n'
                  '• Withdraw consent\n'
                  '• Request deletion (subject to law)\n'
                  '• Receive transaction history',
                ),
                _Divider(),
                _SectionTitle('10. Children’s Privacy'),
                _Paragraph(
                  'Our services are intended for individuals above 18 years '
                  'of age. We do not knowingly collect data from minors.',
                ),
                _Divider(),
                _SectionTitle('11. Policy Updates'),
                _Paragraph(
                  'We may revise this policy periodically. Updated versions '
                  'will be published in the application.',
                ),
                _Divider(),
                _SectionTitle('12. Governing Law'),
                _Paragraph(
                  'This Privacy Policy is governed by the laws of India. '
                  'Any disputes shall be subject to local jurisdiction.',
                ),
                _Divider(),
                _SectionTitle('13. Contact Us'),
                _Paragraph(
                  'For privacy-related concerns, contact us:\n\n'
                  'Email: privacy@anaswarajewellery.com\n'
                  'Phone: +91 9876543210\n'
                  'Address: Anaswara Jewellery Head Office, India',
                ),
                SizedBox(height: 30),
                Center(
                  child: Text(
                    '© 2024 Anaswara Jewellery. All Rights Reserved.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ----------------- Helper Widgets ----------------- */

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Palette.primaryColor,
        ),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;

  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 14,
        height: 1.7,
        color: Colors.black87,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Divider(thickness: 1, color: Colors.grey.shade300),
    );
  }
}
