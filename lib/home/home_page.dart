import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:n47_web/header/app_header.dart';
import 'package:n47_web/home/home_bloc.dart';
import 'package:n47_web/home/scrolldown_indicator.dart';
import '../bloc/future_events_cubit.dart';
import '../database/event.dart';
import '../footer/app_footer.dart';
import '../l10n/generated/app_localizations.dart';
import '../refreshable/refreshable_page.dart';
import '../utils/util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _backgroundLoaded = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final backgroundImage = context.read<HomeBloc>().state.backgroundImage;

      await precacheImage(AssetImage(backgroundImage), context);
      if (mounted) {
        setState(() => _backgroundLoaded = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = context.watch<HomeBloc>().state;
    final futureEvents = context.watch<FutureEventsCubit>().state;

    return RefreshablePage(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              homeState.backgroundImage,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => buildErrorWidget(),
            ),
          ),
          if (_backgroundLoaded) ...[
            const AppHeader(),
            Positioned(
              top: Util.isMobile(context) ? 60 : 80,
              left: 0,
              right: 0,
              bottom: 0,
              child: buildContent(context, futureEvents),
            ),
          ]
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context, List<FutureEventHive> events) {
    final isMobile = Util.isMobile(context);
    final scrollController = ScrollController();
    final mediaQuery = MediaQuery.of(context);

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(
              top: isMobile
                  ? mediaQuery.size.height * 0.2
                  : mediaQuery.size.height * 0.3,
              bottom: mediaQuery.size.height * 0.2,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20.0 : 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.appTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: isMobile ? 40 : 64,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: isMobile ? 0.8 : 1.5,
                      shadows: [
                        Shadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.3),
                          blurRadius: 4,
                          offset: Offset(isMobile ? 1 : 2, isMobile ? 1 : 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.3),
                  ScrollDownIndicator(scrollController: scrollController),
                ],
              ),
            ),
          ),
        ),
        if (events.isEmpty)
          const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: CircularProgressIndicator(),
              ),
            ),
          )
        else
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white.withValues(alpha: 0.92),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20.0 : 80.0,
                vertical: 40.0,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    if (!isMobile) ...[
                      Row(
                        children: [
                          SizedBox(
                            width: 180,
                            child: Text(
                              AppLocalizations.of(context)!.tableHeaderDate,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.tableHeaderEventLocation,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: Text(
                              AppLocalizations.of(context)!.tableHeaderBrands,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30, thickness: 1.5, color: Colors.black87),
                    ],

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      separatorBuilder: (context, index) => const Divider(height: 32, thickness: 0.8, color: Colors.black12),
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return isMobile
                            ? buildMobileEventRow(event)
                            : buildDesktopEventRow(event);
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),

        const SliverToBoxAdapter(child: AppFooter()),
      ],
    );
  }

  Widget buildDesktopEventRow(FutureEventHive event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              Util.formatHtmlText(event.dateText),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Util.formatHtmlText(event.title),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (event.location.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    Util.formatHtmlText(event.location),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (event.brand.isNotEmpty)
            SizedBox(
              width: 120,
              child: Text(
                event.brand,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.black54,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 手机端响应式行设计
  Widget buildMobileEventRow(FutureEventHive event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Util.formatHtmlText(event.dateText),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            if (event.brand.isNotEmpty)
              Text(
                event.brand,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Colors.black54,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          Util.formatHtmlText(event.title),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        if (event.location.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            Util.formatHtmlText(event.location),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }

  Widget buildErrorWidget() => Container(
    color: Colors.grey[200],
    child: const Icon(Icons.broken_image),
  );
}