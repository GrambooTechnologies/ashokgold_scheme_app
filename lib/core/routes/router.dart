import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';
import 'package:ashokgold_scheme_app/features/auth/views/otp_view.dart';
import 'package:ashokgold_scheme_app/features/auth/views/phone_number_view.dart';
import 'package:ashokgold_scheme_app/features/auth/views/registration_view.dart';
import 'package:ashokgold_scheme_app/features/auth/views/splash_view.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/views/customer_closed_scheme_detail_view.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/views/customer_joined_active_scheme_detail_view.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/widgets/completed_schemes_tab.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/views/installment_history_view.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/views/installment_payment_page.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/views/payment_tries_view.dart';
import 'package:ashokgold_scheme_app/features/home/views/bottom_nav.dart';
import 'package:ashokgold_scheme_app/features/home/views/home_view.dart';
import 'package:ashokgold_scheme_app/features/nominee/models/nominee_model.dart';
import 'package:ashokgold_scheme_app/features/nominee/views/add_edit_nominee_view.dart';
import 'package:ashokgold_scheme_app/features/nominee/views/nominee_list_view.dart';
import 'package:ashokgold_scheme_app/features/payment_gateway/views/payment_failure_page.dart';
import 'package:ashokgold_scheme_app/features/payment_gateway/views/payment_success_page.dart';
import 'package:ashokgold_scheme_app/features/payment_gateway/views/payment_webview_page.dart';
import 'package:ashokgold_scheme_app/features/profile/views/edit_profile_view.dart';
import 'package:ashokgold_scheme_app/features/auth/models/customer_model.dart';
import 'package:ashokgold_scheme_app/features/profile/views/profile_view.dart';
import 'package:ashokgold_scheme_app/features/profile/views/social_media_view.dart';
import 'package:ashokgold_scheme_app/features/settings/views/privacy_policy_view.dart';
import 'package:ashokgold_scheme_app/features/settings/views/terms_and_conditions_view.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/views/scheme_joining_view.dart';
import 'package:ashokgold_scheme_app/features/schemes/views/scheme_detail_view.dart';
import 'package:ashokgold_scheme_app/features/schemes/views/schemes_list_view.dart';
import 'package:go_router/go_router.dart';

import '../../features/profile/views/appinfo.dart';
import '../../features/profile/views/contact_support_view.dart';
import '../../features/notifications/views/notification_inbox_view.dart';

final GoRouter router = GoRouter(
  initialLocation: SplashView.routeName,
  routes: [
    GoRoute(
      path: SplashView.routeName,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: PhoneNumberView.routeName,
      builder: (context, state) => const PhoneNumberView(),
    ),
    GoRoute(
      path: OtpView.routeName,
      builder: (context, state) {
        final phoneNumber = state.extra as String;
        return OtpView(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      path: RegistrationView.routeName,
      builder: (context, state) => const RegistrationView(),
    ),
    GoRoute(
      path: BottomNav.routeName,
      builder: (context, state) => const BottomNav(),
    ),
    GoRoute(
      path: HomeView.routeName,
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: ProfileView.routeName,
      builder: (context, state) => const ProfileView(),
    ),
    GoRoute(
      path: EditProfileView.routeName,
      builder: (context, state) {
        final customer = state.extra as CustomerModel;
        return EditProfileView(customer: customer);
      },
    ),
    GoRoute(
      path: ContactSupportView.routeName,
      builder: (context, state) => const ContactSupportView(),
    ),
    GoRoute(
      path: SocialMediaView.routeName,
      builder: (context, state) => const SocialMediaView(),
    ),
    GoRoute(
      path: PrivacyPolicyView.routeName,
      builder: (context, state) => const PrivacyPolicyView(),
    ),
    GoRoute(
      path: TermsAndConditionsView.routeName,
      builder: (context, state) => const TermsAndConditionsView(),
    ),
    GoRoute(
      path: NomineeListView.routeName,
      builder: (context, state) => const NomineeListView(),
    ),
    GoRoute(
      path: CompletedSchemesTab.routeName,
      builder: (context, state) => const CompletedSchemesTab(),
    ),
    GoRoute(
      path: AddEditNomineeView.routeName,
      builder: (context, state) {
        final nominee = state.extra as CustomerNomineeModel?;
        return AddEditNomineeView(nominee: nominee);
      },
    ),
    GoRoute(
      path: SchemesListView.routeName,
      builder: (context, state) => const SchemesListView(),
    ),
    GoRoute(
      path: AppInfoView.routeName,
      builder: (_, _) => const AppInfoView(),
    ),
    GoRoute(
      path: '${SchemeDetailView.routeName}/:schemeId',
      builder: (context, state) {
        final schemeId = state.pathParameters['schemeId']!;
        return SchemeDetailView(schemeId: schemeId);
      },
    ),
    GoRoute(
      path: '${SchemeJoiningView.routeName}/:schemeId',
      builder: (context, state) {
        final schemeId = state.pathParameters['schemeId']!;
        final amount = state.uri.queryParameters['amount'];
        return SchemeJoiningView(
          schemeId: schemeId,
          initialAmount: toDouble(amount),
        );
      },
    ),
    GoRoute(
      path: '${CustomerJoinedSchemeDetailView.routeName}/:joinId',
      builder: (context, state) {
        final joinId = state.pathParameters['joinId']!;
        return CustomerJoinedSchemeDetailView(joinId: joinId);
      },
    ),
    GoRoute(
      path: '${CustomerClosedSchemeDetailView.routeName}/:closingId',
      builder: (context, state) {
        final closingId = state.pathParameters['closingId']!;
        return CustomerClosedSchemeDetailView(closingId: closingId);
      },
    ),
    GoRoute(
      path: '${InstallmentHistoryView.routeName}/:joinId',
      builder: (context, state) {
        final joinId = state.pathParameters['joinId']!;
        return InstallmentHistoryView(joinId: joinId);
      },
    ),
    GoRoute(
      path: '${PaymentTriesView.routeName}/:joinId',
      builder: (context, state) {
        final joinId = state.pathParameters['joinId']!;
        return PaymentTriesView(joinId: joinId);
      },
    ),
    GoRoute(
      path: InstallmentPaymentPage.routeName,
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>;
        final joinId = params['joinId'] as String;
        final schemeName = params['schemeName'] as String;
        final installmentAmount = params['installmentAmount'] as String;
        return InstallmentPaymentPage(
          joinId: joinId,
          schemeName: schemeName,
          installmentAmount: installmentAmount,
        );
      },
    ),
    GoRoute(
      path: PaymentWebViewPage.routeName,
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>;
        final paymentUrl = params['paymentUrl'] as String;
        final orderId = params['orderId'] as String;
        final joinId = params['joinId'] as String?;
        final isSchemeJoining = params['isSchemeJoining'] as bool? ?? false;
        final schemeName = params['schemeName'] as String?;
        final amount = params['amount'] as String?;
        return PaymentWebViewPage(
          paymentUrl: paymentUrl,
          orderId: orderId,
          joinId: joinId,
          isSchemeJoining: isSchemeJoining,
          schemeName: schemeName,
          amount: amount,
        );
      },
    ),
    GoRoute(
      path: PaymentSuccessPage.routeName,
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>;
        final orderId = params['orderId'] as String;
        final joinId = params['joinId'] as String?;
        final isSchemeJoining = params['isSchemeJoining'] as bool? ?? false;
        final schemeName = params['schemeName'] as String?;
        final amount = params['amount'] as String?;
        return PaymentSuccessPage(
          orderId: orderId,
          joinId: joinId,
          isSchemeJoining: isSchemeJoining,
          schemeName: schemeName,
          amount: amount,
        );
      },
    ),
    GoRoute(
      path: PaymentFailurePage.routeName,
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>;
        final orderId = params['orderId'] as String;
        final message = params['message'] as String;
        return PaymentFailurePage(orderId: orderId, message: message);
      },
    ),
    GoRoute(
      path: NotificationInboxView.routeName,
      builder: (context, state) => const NotificationInboxView(),
    ),
  ],
);
