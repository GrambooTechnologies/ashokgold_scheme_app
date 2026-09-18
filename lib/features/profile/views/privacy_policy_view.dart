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
                  'Effective Date: September 2026\n'
                  'Last Updated: September 2026\n\n'
                  'Ashok Gold and Diamonds ("we", "our", "us") is committed '
                  'to protecting your privacy. This Privacy Policy explains '
                  'how we collect, use, store, and safeguard your information.',
                ),

                _Divider(),

                _SectionTitle('1. Introduction'),
                _Paragraph(
                  'This Privacy Policy describes how we manage personal and '
                  'financial information collected through our gold savings '
                  'schemes and jewellery services.',
                ),

                _Divider(),

                _SectionTitle('2. Information We Collect'),
                _Paragraph(
                  'We may collect the following information:\n\n'
                  '• Full name, address, phone number, and email\n'
                  '• Government identification, if required\n'
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
                  'Transaction records may be maintained for accounting, '
                  'business, legal, and regulatory compliance purposes.',
                ),

                _Divider(),

                _SectionTitle('4. How We Use Your Information'),
                _Paragraph(
                  'We may use your information to:\n\n'
                  '• Manage gold savings schemes\n'
                  '• Process monthly payments\n'
                  '• Record and allocate gold purchases\n'
                  '• Verify customer identity\n'
                  '• Provide customer support\n'
                  '• Send alerts, reminders, and notifications\n'
                  '• Prevent fraud and unauthorized transactions\n'
                  '• Maintain transaction and business records',
                ),

                _Divider(),

                _SectionTitle('5. Data Security'),
                _Paragraph(
                  'We use reasonable and industry-standard security measures, '
                  'including encryption, secure servers, and restricted access, '
                  'to protect your personal and financial information against '
                  'unauthorized access, misuse, alteration, or disclosure.',
                ),

                _Divider(),

                _SectionTitle('6. Data Retention'),
                _Paragraph(
                  'We retain customer information only for as long as '
                  'reasonably necessary for business operations, legal, '
                  'accounting, and regulatory requirements.\n\n'
                  'When information is no longer required, we may securely '
                  'delete or anonymize it, subject to applicable laws and '
                  'regulations.',
                ),

                _Divider(),

                _SectionTitle('7. Information Sharing'),
                _Paragraph(
                  'Your information may be shared, where necessary, with:\n\n'
                  '• Payment gateway providers\n'
                  '• Banking and financial service partners\n'
                  '• Government authorities, when legally required\n'
                  '• Legal, accounting, and audit agencies\n'
                  '• Service providers supporting our business operations\n\n'
                  'We do not sell your personal information to third parties.',
                ),

                _Divider(),

                _SectionTitle('8. Third-Party Services'),
                _Paragraph(
                  'Our platform may integrate with third-party services for '
                  'payment processing, SMS delivery, analytics, cloud hosting, '
                  'and other operational services.\n\n'
                  'These third-party providers may process your information '
                  'according to their own privacy policies and applicable laws.',
                ),

                _Divider(),

                _SectionTitle('9. Your Rights'),
                _Paragraph(
                  'Subject to applicable laws and regulations, you may have '
                  'the right to:\n\n'
                  '• Access your personal information\n'
                  '• Request correction of inaccurate information\n'
                  '• Withdraw consent where applicable\n'
                  '• Request deletion of personal information, subject to '
                  'legal requirements\n'
                  '• Request your transaction history',
                ),

                _Divider(),

                _SectionTitle("10. Children's Privacy"),
                _Paragraph(
                  'Our services are intended for individuals 18 years of age '
                  'or older. We do not knowingly collect personal information '
                  'from individuals under the age of 18.',
                ),

                _Divider(),

                _SectionTitle('11. Policy Updates'),
                _Paragraph(
                  'We may update this Privacy Policy from time to time to '
                  'reflect changes in our services, business practices, or '
                  'applicable laws.\n\n'
                  'Any updated version will be published through the '
                  'application or other appropriate channels. The '
                  '"Last Updated" date at the top of this policy indicates '
                  'when the policy was most recently revised.',
                ),

                _Divider(),

                _SectionTitle('12. Governing Law'),
                _Paragraph(
                  'This Privacy Policy is governed by the applicable laws '
                  'of India.\n\n'
                  'Any disputes relating to this Privacy Policy shall be '
                  'subject to the jurisdiction of the appropriate courts '
                  'in India.',
                ),

                _Divider(),

                _SectionTitle('13. Contact Us'),
                _Paragraph(
                  'For privacy-related questions, concerns, or requests, '
                  'please contact us:\n\n'
                  'Ashok Gold and Diamonds\n\n'
                  'Email: ashokgoldanddiamonds@gmail.com\n'
                  'Phone: +91 9746755852\n'
                  'Address: Ashok Gold and Diamonds Head Office, India',
                ),

                SizedBox(height: 30),

                Center(
                  child: Text(
                    '© 2026 Ashok Gold and Diamonds. All Rights Reserved.',
                    textAlign: TextAlign.center,
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
