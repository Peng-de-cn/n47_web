import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:n47_web/header/app_header.dart';
import '../bloc/events_cubit.dart';
import '../database/event.dart';
import '../footer/app_footer.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = context.read<EventsCubit>().state;
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
            child: buildContent(events, context),
          ),
        ],
      )
    );
  }

  Widget buildContent(List<Event> events, BuildContext context) {
    return CustomScrollView(
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
          child: AppFooter(), // Footer as part of the scrolling content
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
            crossAxisAlignment: alignLeft
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(
                event.date,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                event.description,
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Image.network(
              event.image,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMobileLayout(int index, Event event, int eventsLength) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          buildMobileImageContent(event),
          buildMobileTextContent(event, true),
          if (index != eventsLength - 1) const Divider(height: 40),
        ],
      ),
    );
  }

  Widget buildMobileImageContent(Event event) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9, // image ratio
        child: Image.network(
          event.image,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, size: 50),
            );
          },
        ),
      ),
    );
  }

  Widget buildMobileTextContent(Event event, bool alignLeft) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: alignLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min, // Important: Avoid Infinite Scaling
        children: [
          Text(
            event.date,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            event.description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

}