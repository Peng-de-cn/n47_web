import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:n47_web/firebase/fire_store.dart';
import 'package:n47_web/header/app_header.dart';
import 'package:n47_web/home/home_bloc.dart';
import 'package:n47_web/home/scrolldown_indicator.dart';
import '../bloc/future_events_cubit.dart';
import '../database/event.dart';
import '../footer/app_footer.dart';
import '../l10n/generated/app_localizations.dart';
import '../refreshable/refreshable_page.dart';
import '../utils/util.dart';
import '../utils/logger_util.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final events = context.read<FutureEventsCubit>().state;
    return RefreshablePage(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(state.backgroundImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const AppHeader(),
              Positioned(
                top: Util.isMobile(context) ? 60 : 100,
                left: 0,
                right: 0,
                bottom: 0,
                child: buildContent(events, context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildContent(List<Event> events, BuildContext context) {
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
                  ? mediaQuery.size.height * 0.2  // 20% of screen height for top padding
                  : mediaQuery.size.height * 0.3, // 30%
              bottom: isMobile
                  ? mediaQuery.size.height * 0.1  // 10% of screen height for bottom padding
                  : mediaQuery.size.height * 0.2, // 20%
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20.0 : 40.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.appTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                        fontSize: isMobile ? 40 : 64,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: isMobile ? 0.8 : 1.5,
                        shadows: [
                          Shadow(
                              color: Color.fromRGBO(0, 0, 0, 0.3),
                              blurRadius: 4,
                              offset: Offset(isMobile ? 1 : 2, isMobile ? 1 : 2))
                        ]),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.3), // 30% of screen height
                  ScrollDownIndicator(scrollController: scrollController),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final event = events[index];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.0, -1.0),
                    end: Alignment(0.0, 0.5),
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.7),
                      Colors.white,
                    ],
                    stops: [0.0, 0.1, 0.3, 0.7, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      return buildDesktopLayout(index, event);
                    } else {
                      return buildMobileLayout(index, event, events.length);
                    }
                  },
                ),
              );
            },
            childCount: events.length,
          ),
        ),
        const SliverToBoxAdapter(
          child: AppFooter(), // Footer as part of the scrolling content
        ),
      ],
    );
  }

  Widget buildDesktopLayout(int index, Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
      child: Row(
        children: [
          if (index % 2 == 0) ...[
            Expanded(
              flex: 3,
              child: buildDesktopTextContent(event, true),
            ),
            Expanded(
              flex: 2,
              child: buildDesktopImageContent(event),
            ),
          ] else ...[
            Expanded(
              flex: 2,
              child: buildDesktopImageContent(event),
            ),
            Expanded(
              flex: 3,
              child: buildDesktopTextContent(event, false),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildDesktopTextContent(Event event, bool alignLeft) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Align(
          alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
          child: Column(
            crossAxisAlignment: alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                Util.formatHtmlText(event.dateText),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                Util.formatHtmlText(event.title),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                Util.formatHtmlText(event.description),
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDesktopImageContent(Event event) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: FutureBuilder<String?>(
                  future: Firestore.loadImageUrl(event.imageWeb),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return AnimatedOpacity(
                        opacity: 0.5,
                        duration: const Duration(milliseconds: 300),
                        child: buildLoadingWidget(),
                      );
                    }

                    if (snapshot.hasError) {
                      logger.e('Image load failed: ${snapshot.error}');
                      return buildErrorWidget();
                    }

                    final url = snapshot.data;
                    if (url == null || url.isEmpty) {
                      return buildErrorWidget();
                    }

                    return CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => buildLoadingWidget(),
                      errorWidget: (_, url, error) => buildErrorWidget(),
                      maxWidthDiskCache: kIsWeb ? null : 1024,
                      fadeInDuration: const Duration(milliseconds: 200),
                      imageBuilder: kIsWeb ? (context, imageProvider) => Image(image: imageProvider) : null,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMobileLayout(int index, Event event, int eventsLength) {
    return Column(
      children: [
        buildMobileImageContent(event),
        buildMobileTextContent(event, true),
        if (index != eventsLength - 1) const Divider(height: 40),
      ],
    );
  }

  Widget buildMobileImageContent(Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 4 / 3, // image ratio
              child: FutureBuilder<String?>(
                future: Firestore.loadImageUrl(event.imageMobile),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return AnimatedOpacity(
                      opacity: 0.5,
                      duration: const Duration(milliseconds: 300),
                      child: buildLoadingWidget(),
                    );
                  }

                  if (snapshot.hasError) {
                    logger.e('Image load failed: ${snapshot.error}');
                    return buildErrorWidget();
                  }

                  final url = snapshot.data;
                  if (url == null || url.isEmpty) {
                    return buildErrorWidget();
                  }

                  return CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => buildLoadingWidget(),
                    errorWidget: (_, url, error) => buildErrorWidget(),
                    maxWidthDiskCache: kIsWeb ? null : 1024,
                    fadeInDuration: const Duration(milliseconds: 200),
                    imageBuilder: kIsWeb ? (context, imageProvider) => Image(image: imageProvider) : null,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMobileTextContent(Event event, bool alignLeft) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
      child: Column(
        crossAxisAlignment: alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min, // Important: Avoid Infinite Scaling
        children: [
          Text(
            Util.formatHtmlText(event.dateText),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Util.formatHtmlText(event.title),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            Util.formatHtmlText(event.description),
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoadingWidget() => Center(child: CircularProgressIndicator());

  Widget buildErrorWidget() => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image),
      );
}
