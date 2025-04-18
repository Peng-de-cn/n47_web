import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:n47_web/header/app_header.dart';
import 'package:n47_web/l10n/generated/app_localizations.dart';
import '../bloc/events_cubit.dart';
import '../database/event.dart';
import '../firebase/fire_store.dart';
import '../footer/app_footer.dart';
import '../utils/Util.dart';
import '../utils/logger_util.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentSeasonIndex = 0;
  List<String> _availableSeasons = [];
  late List<List<Event>> _seasonalEvents;

  @override
  void initState() {
    super.initState();
    _loadAvailableSeasons();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadAvailableSeasons() {
    final events = context.read<EventsCubit>().state;

    // 按日期排序事件
    events.sort((a, b) => _parseDate(a.date).compareTo(_parseDate(b.date)));

    // 分组到各个雪季
    final seasonMap = <String, List<Event>>{};

    for (final event in events) {
      final date = _parseDate(event.date);
      final season = _getSeasonForDate(date);

      seasonMap.putIfAbsent(season, () => []).add(event);
    }

    // 获取所有雪季并按时间排序(最新的在前)
    _availableSeasons = seasonMap.keys.toList()
      ..sort((a, b) => _parseSeason(b).compareTo(_parseSeason(a)));

    // 保存每个雪季的事件列表
    _seasonalEvents = _availableSeasons.map((s) => seasonMap[s]!).toList();

    setState(() {
      if (_availableSeasons.isNotEmpty) {
        _currentSeasonIndex = 0;
      }
    });
  }

  DateTime _parseDate(String dateStr) {
    try {
      if (dateStr.contains('-')) {
        return DateTime.parse(dateStr);
      }
      final parts = dateStr.split(' ');
      if (parts.length == 3) {
        final month = _monthNameToNumber(parts[0]);
        final day = parts[1].replaceAll(',', '');
        final year = parts[2];
        return DateTime(int.parse(year), month, int.parse(day));
      }
    } catch (e) {
      logger.e('Error parsing date: $dateStr - $e');
    }
    return DateTime.now();
  }

  int _monthNameToNumber(String month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months.indexWhere((m) => m.startsWith(month)) + 1;
  }

  String _getSeasonForDate(DateTime date) {
    final year = date.year;
    final month = date.month;

    if (month >= 10) {
      return '${year.toString().substring(2)}/${(year + 1).toString().substring(2)}';
    }
    else if (month <= 5) {
      return '${(year - 1).toString().substring(2)}/${year.toString().substring(2)}';
    }
    return '${(year - 1).toString().substring(2)}/${year.toString().substring(2)}';
  }


  DateTime _parseSeason(String season) {
    final parts = season.split('/');
    final startYear = 2000 + int.parse(parts[0]);
    return DateTime(startYear, 10);
  }

  List<Event> _getEventsForCurrentSeason() {
    if (_availableSeasons.isEmpty) return [];
    return _seasonalEvents[_currentSeasonIndex];
  }

  void _goToNextSeason() {
    if (_currentSeasonIndex < _availableSeasons.length - 1) {
      setState(() {
        _currentSeasonIndex++;
      });
      _scrollToTop();
    }
  }

  void _goToPreviousSeason() {
    if (_currentSeasonIndex > 0) {
      setState(() {
        _currentSeasonIndex--;
      });
      _scrollToTop();
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentEvents = _getEventsForCurrentSeason();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          const AppHeader(),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                if (_availableSeasons.length > 1) _buildSeasonSelector(),
                Expanded(
                  child: buildContent(currentEvents, context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentSeasonIndex > 0 ? _goToPreviousSeason : null,
          ),
          Text(
            '${_availableSeasons[_currentSeasonIndex]} ${AppLocalizations.of(context)!.historyTab}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentSeasonIndex < _availableSeasons.length - 1 ? _goToNextSeason : null,
          ),
        ],
      ),
    );
  }

  Widget buildContent(List<Event> events, BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final event = events[index];
              return LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    return buildDesktopLayout(index, event);
                  } else {
                    return buildMobileLayout(index, event, events.length);
                  }
                },
              );
            },
            childCount: events.length,
          ),
        ),
        const SliverToBoxAdapter(
          child: AppFooter(),
        ),
      ],
    );
  }

  Widget buildDesktopLayout(int index, Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          if (index % 2 == 0) ...[
            buildDesktopTextContent(event, true),
            buildDesktopImageContent(event),
          ] else ...[
            buildDesktopImageContent(event),
            buildDesktopTextContent(event, false),
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
                Util.formatHtmlText(event.date),
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 9,
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
    );
  }

  Widget buildMobileTextContent(Event event, bool alignLeft) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Util.formatHtmlText(event.date),
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