import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Be Prepared For The Alpine And Beyond!'**
  String get appTitle;

  /// No description provided for @naviHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get naviHistory;

  /// No description provided for @naviSponsors.
  ///
  /// In en, this message translates to:
  /// **'Sponsors'**
  String get naviSponsors;

  /// No description provided for @naviContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get naviContact;

  /// No description provided for @naviAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get naviAbout;

  /// No description provided for @contactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactTitle;

  /// No description provided for @followTitle.
  ///
  /// In en, this message translates to:
  /// **'Follow us'**
  String get followTitle;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @imprint.
  ///
  /// In en, this message translates to:
  /// **'Imprint'**
  String get imprint;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'Copyright © All Rights Reserved'**
  String get copyright;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @wechatDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Wechat'**
  String get wechatDialogTitle;

  /// No description provided for @wechatDialogText.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code to add us on WeChat'**
  String get wechatDialogText;

  /// No description provided for @redNoteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'RedNote'**
  String get redNoteDialogTitle;

  /// No description provided for @redNoteDialogText.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code to follow our RedNote'**
  String get redNoteDialogText;

  /// No description provided for @urlError.
  ///
  /// In en, this message translates to:
  /// **'Unable to open link:'**
  String get urlError;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Datenschutzerklärung'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyDetail.
  ///
  /// In en, this message translates to:
  /// **'Vielen Dank für Ihr Interesse an unserem Onlineauftritt. Der Schutz Ihrer persönlichen Daten liegt uns sehr am Herzen. An dieser Stelle möchten wir Sie daher über den Datenschutz in unserem Unternehmen informieren. Selbstverständlich beachten wir die gesetzlichen Bestimmungen des Datenschutzgesetzes (BDSG) des Telemediengesetzes (TMG) und anderer datenschutzrechtlicher Bestimmungen.\n\nBei Ihren persönlichen Daten können Sie uns vertrauen! Sie werden durch digitale Sicherheitssysteme verschlüsselt und an uns übertragen. Unsere Webseiten sind durch technische Maßnahmen gegen Beschädigungen, Zerstörung oder unberechtigten Zugriff geschützt.\n\nGegenstand des Datenschutzes\nGegenstand des Datenschutzes sind personenbezogene Daten. Diese sind nach § 3 Abs. 1 BDSG Einzelangaben über persönlich oder sachliche Verhältnisse einer bestimmten oder bestimmbaren natürlichen Person. Hierunter fallen z.B. Angaben wie Name, Post-Adresse, E-Mail-Adresse oder Telefonnummer.\n\nUmfang der Datenerhebung und -speicherung\nIm Allgemeinen ist es für die Nutzung unserer Internetseite nicht erforderlich, dass Sie personenbezogene Daten angeben. Damit wir unsere Dienstleistungen aber tatsächlich erbringen können, benötigen wir ggf. Ihre personenbezogenen Daten. Dies gilt sowohl bei der Zusendung von Informationsmaterial oder bestellter Ware sowie auch für die Beantwortung individueller Anfragen. Wenn Sie uns mit der Erbringung einer Dienstleistung oder der Zusendung von Ware beauftragen, erheben und speichern wir Ihre persönlichen Daten grundsätzlich nur, soweit es für die Erbringung der Dienstleistung oder die Durchführung des Vertrages notwendig ist. Dazu kann es erforderlich sein, Ihre persönlichen Daten an Unternehmen weiterzugeben, die wir zur Erbringung der Dienstleistung oder zur Vertragsabwicklung einsetzen. Dies sind z. B. Transportunternehmen oder andere Service-Dienste. Nach vollständiger Vertragsabwicklung werden Ihre Daten gesperrt und nach Ablauf der steuer- und handelsrechtlichen Vorschriften gelöscht, sofern Sie nicht ausdrücklich einer darüber hinausgehende Datenverwendung zugestimmt haben. Wenn Sie sich mit Ihrer E-Mail-Adresse für unseren Newsletter angemeldet haben, nutzen wir Ihre E-Mail-Adresse auch über die Vertragsdurchführung hinaus für eigene Werbezwecke, bis Sie sich vom Newsletter-Bezug abmelden.\n\nErhebung und Speicherung von Nutzungsdaten\nZur Optimierung unserer Webseite sammeln und speichern wir Daten wie z. B. Datum und Uhrzeit des Seitenaufrufs, die Seite, von der Sie unsere Seite aufgerufen haben und ähnliches, sofern Sie dieser Datenerhebung und -speicherung nicht widersprechen. Dies erfolgt anonymisiert, ohne den Benutzer der Seite persönlich zu identifizieren. Ggf. werden Nutzerprofile mittels eines Pseudonyms erstellt. Auch hierbei erfolgt keine Verbindung zwischen der hinter dem Pseudonym stehenden natürlichen Personen mit den erhobenen Nutzungsdaten zur Erhebung und Speicherung der Nutzungsdaten setzen wir auch Cookies ein. Dabei handelt es sich um kleine Textdateien, die auf Ihrem Computer gespeichert werden und zur Speicherung von statistischen Information wie Betriebssystem, Ihrem Internetbenutzungsprogramm (Browser), der zuvor aufgerufene Webseite (Referrer-URL) und der Uhrzeit dienen. Diese Daten erheben wir ausschließlich, zu statistischen Zwecken, um unseren Internetauftritt weiter zu optimieren und unsere Internetangebote noch attraktiver gestalten zu können. Die Erhebung und Speicherung erfolgt ausschließlich in anonymisierter oder pseudonymisierter Form und lässt keinen Rückschluss auf Sie als natürlich Person zu.\n\nZweckgebundene Datenverwendung\nWir beachten den Grundsatz der zweckgebundenen Daten-Verwendung und erheben, verarbeiten und speichern Ihre personenbezogenen Daten nur für die Zwecke, für die Sie sie uns mitgeteilt haben. Eine Weitergabe Ihrer persönlichen Daten an Dritte erfolgt ohne Ihre ausdrückliche Einwilligung nicht, sofern dies nicht zur Erbringung der Dienstleistung oder zur Vertragsdurchführung notwendig ist. Auch die Übermittlung an auskunftsberechtigte staatliche Institution und Behörden erfolgt nur im Rahmen der gesetzlichen Auskunftspflichten oder wenn wir durch eine gerichtliche Entscheidung zur Auskunft verpflichtet werden. Auch den unternehmensinternen Datenschutz nehmen wir sehr ernst. Unsere Mitarbeiter und die von uns beauftragten Dienstleistungsunternehmen sind von uns zur Verschwiegenheit und zur Einhaltung der datenschutzrechtlichen Bestimmungen verpflichtet worden.\n\nVerwendung von Webanalysediensten\nDiese Website benutzt Google Analytics, einen Webanalysedienst der Google Inc. („Google“). Google Analytics verwendet sog. „Cookies“, Textdateien, die auf Ihrem Computer gespeichert werden und die eine Analyse der Benutzung der Website durch Sie ermöglichen. Die durch den Cookie erzeugten Informationen über Ihre Benutzung dieser Website (einschließlich Ihrer IP-Adresse) wird an einen Server von Google in den USA übertragen und dort gespeichert. Google wird diese Informationen benutzen, um Ihre Nutzung der Website auszuwerten, um Reports über die Websiteaktivitäten für die Websitebetreiber zusammenzustellen und um weitere mit der Websitenutzung und der Internetnutzung verbundene Dienstleistungen zu erbringen. Auch wird Google diese Informationen gegebenenfalls an Dritte übertragen, sofern dies gesetzlich vorgeschrieben oder soweit Dritte diese Daten im Auftrag von Google verarbeiten. Google wird in keinem Fall Ihre IP-Adresse mit anderen Daten von Google in Verbindung bringen. Sie können die Installation der Cookies durch eine entsprechende Einstellung Ihrer Browser Software verhindern; wir weisen Sie jedoch darauf hin, dass Sie in diesem Fall gegebenenfalls nicht sämtliche Funktionen dieser Website vollumfänglich nutzen können. Durch die Nutzung dieser Website erklären Sie sich mit der Bearbeitung der über Sie erhobenen Daten durch Google in der zuvor beschriebenen Art und Weise und zu dem zuvor benannten Zweck einverstanden.\n\nAuskunft- und Widerrufsrecht\nSie erhalten jederzeit ohne Angabe von Gründen kostenfrei Auskunft über Ihre bei uns gespeicherten Daten. Sie können jederzeit Ihre bei uns erhobenen Daten sperren, berichtigen oder löschen lassen und der anonymisierten oder pseudonymisierten Datenerhebung und -speicherung zu Optimierungszwecken unserer Website widersprechen. Auch können Sie jederzeit die uns erteilte Einwilligung zur Datenerhebung und Verwendung ohne Angaben von Gründen widerrufen. Wenden Sie sich hierzu bitte an die im Impressum angegebene Kontaktadresse. Wir stehen Ihnen jederzeit gern für weitergehende Fragen zu unserem Hinweisen zum Datenschutz und zur Verarbeitung Ihrer persönlichen Daten zur Verfügung.\n\nAktualität\nDie Bos innovations GmbH ist bemüht, das Webangebot stets aktuell und inhaltlich richtig sowie vollständig anzubieten. Dennoch ist das Auftreten von Fehlern nicht völlig auszuschließen. Die Bos innovations GmbH übernimmt keine Haftung für die Aktualität, die inhaltliche Richtigkeit sowie für die Vollständigkeit der in ihrem Webangebot eingestellten Informationen, es sei denn die Fehler wurden vorsätzlich oder grob fahrlässig aufgenommen.\n\n'**
  String get privacyPolicyDetail;

  /// No description provided for @imprintTitle.
  ///
  /// In en, this message translates to:
  /// **'Impressum'**
  String get imprintTitle;

  /// No description provided for @imprintDetail.
  ///
  /// In en, this message translates to:
  /// **'Angaben gemäß § 5 TMG:\nN47° ExtremeSport League e.V.\nGroßhaderner Straße 40\n81375 München\nDeutschland\n\nEingetragen im Vereinsregister des Amtsgerichtes München: VR209601\n\nVerantwortlich i. S. d § 55 RStV und § 5 TMG:\nVorsitzender:\nPeng Zhang\nGroßhaderner Straße 40\n81375 München\n\nKontakt\nE-Mail                             info@n47.eu\nHomepage                   https://n47.eu\n\nHaftungshinweis\n\nAllgemein\nEs wurde alle Sorgfalt aufgewendet, die Richtigkeit der Angaben auf diesen Internetseiten sicher zu stellen. Eventuelle Fehler sind dennoch nicht auszuschließen. Für entsprechende Hinweise sind wir Ihnen dankbar.\n\nVerwendete Hyperlinks\nDer N47° ExtremeSport League e.V. bietet Links zu anderen Seiten im Internet, bei denen keinerlei Einfluss auf Gestaltung und Inhalt der verlinkten Seiten besteht. Deshalb distanziert sich der N47° ExtremeSport League e.V. ausdrücklich von sämtlichen Inhalten aller verlinkten Seiten und macht sich deren Inhalte nicht zu eigen. Diese Erklärung gilt für alle in der Website verwendeten Links und für alle Inhalte der Seiten.\n\nHaftungsausschluss\nAlle enthaltenen Informationen wurden mit größtmöglicher Sorgfalt kontrolliert. Der N47° ExtremeSport League e.V. kann trotzdem nicht für Schäden haftbar gemacht werden, die im Zusammenhang mit der Verwendung dieser Inhalte entstehen könnten. Für die Richtigkeit und Vollständigkeit der durch Hyperlinks/ \"Links\" vermittelten sowie der Informationen auf dieser Website wird keine Gewähr übernommen.\n\nCopyright by N47° ExtremeSport League e.V. Sämtliche Inhalte der Website dürfen nur nach vorheriger schriftlicher Freigabe verwendet werden.'**
  String get imprintDetail;

  /// No description provided for @historyTab.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get historyTab;

  /// No description provided for @sponsorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Sponsors'**
  String get sponsorsTitle;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'WHO WE ARE'**
  String get aboutTitle;

  /// No description provided for @aboutDetail.
  ///
  /// In en, this message translates to:
  /// **'In the beautiful winter of 2021, a couple of us snowboarders came together and decided to form an extreme sports club to provide an actively interactive platform, specifically for Chinese snowboard enthusiasts in Europe. Beforehand, most winter sports clubs put skiers and snowboarders together in one activity. Although they are both sports on snow, they have numerous differences. Therefore, we find it necessary to form a club mainly for snowboarders. On the one hand, The club helps get people together for better interactions. On the other hand, group activity could potentially benefit snowboard enthusiasts. Here begins our story.\n \nIn the spring of 2022, we cooperated with several big brand manufacturers to hold an offline event and celebrate the club\'s establishment. The event received powerful support from many snowboard beginners and snowboard OGs and hosted hundreds of snowboarders eventually. The recognition from all snowboarder friends has given us great confidence and motivation. Therefore, we hope to put more effort and time into doing a good job in the club and live up to the friends who love snowboarding in Europe in our spare time.\n \nWe named our club N47 degrees (N47°) because we found that almost all the famous snowboard resorts on earth miraculously appeared at 47 degrees north latitude. We hope to connect snowboard enthusiasts at this latitude with our club. We believe that the N47° does not belong to one person or some groups but belongs to any mate who loves this sport. Moreover, we do our best to maintain such a community and let it grow and develop.\n \nAt the end of winter 2022, more and more Chinese in Europe, as well as Xiaobai and Big Pros get to know N47°. We feel gratified because while the N47° is registered in Germany, we are looking forward to the broader Alps or even the whole of Europe. More and more Chinese from other countries, such as France, Switzerland, the United Kingdom, Austria, Italy, etc., are beginning to join us. We appreciate all of your trust. N47° is becoming warmer, more abundant, and more dimensional with each lovely you.\n \nToday\'s N47° has become a community that organizes offline activities in multiple ski resorts every week. N47° becomes more like a flag or a spirit to everyone. Her soul aligns with our original intention of choosing snowboarding and insisting on snowboarding. It is also the so-called original intention that brings everyone together from all over the world. For our initiators, the future of N47° will continue to pursue the original intent. We will complete the club with a more exciting atmosphere. So that snowboarding can become a carrier to bring each other closer. Friendship will bond us together to boost a great passion for snowboarding.\n \nFace to the future, N47° is ambitious. We plan to go beyond the weekly offline activities: externally, we will continue to join hands with the world\'s top snowboard manufacturers and brands to hold various essential activities and benefit our snowboarders; internally, we will continue to gather more like-minded snowboard instructors, sponsors, and Olympic stars to maintain our N47° community and let her continue to grow and develop. We believe that the N47° is heading to a bright future with every fantastic you because we are together.'**
  String get aboutDetail;

  /// No description provided for @contactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Have questions or feedback? Send us a message and we will get back to you as soon as possible.'**
  String get contactSubtitle;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// No description provided for @labelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get labelEmail;

  /// No description provided for @labelSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get labelSubject;

  /// No description provided for @labelMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get labelMessage;

  /// No description provided for @sendMessageButton.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessageButton;

  /// No description provided for @sendSuccessDialog.
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully!'**
  String get sendSuccessDialog;

  /// No description provided for @sendFailedDialog.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message, please try it later'**
  String get sendFailedDialog;

  /// No description provided for @nameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameEmptyError;

  /// No description provided for @emailEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailEmptyError;

  /// No description provided for @emailInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalidError;

  /// No description provided for @subjectEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a subject'**
  String get subjectEmptyError;

  /// No description provided for @messageEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your message'**
  String get messageEmptyError;

  /// No description provided for @sendEmailFailed.
  ///
  /// In en, this message translates to:
  /// **'Send email failed: '**
  String get sendEmailFailed;

  /// No description provided for @httpError.
  ///
  /// In en, this message translates to:
  /// **'HTTP request failed with status: '**
  String get httpError;

  /// No description provided for @cookieTitle.
  ///
  /// In en, this message translates to:
  /// **'We use cookies 🍪'**
  String get cookieTitle;

  /// No description provided for @cookieDescription.
  ///
  /// In en, this message translates to:
  /// **'We use cookies and similar technologies to provide core site functionality and to understand usage patterns to improve your experience. You can choose to accept all or only necessary cookies.'**
  String get cookieDescription;

  /// No description provided for @acceptAll.
  ///
  /// In en, this message translates to:
  /// **'Accept all'**
  String get acceptAll;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Only necessary'**
  String get reject;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
