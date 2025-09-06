import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Event> events = [
      Event(
        title: 'REChain x Stacks Bitcoin Hackathon',
        subtitle: 'Harvard, USA',
        date: '9-10 Nov 2024',
        duration: '36 hours',
        prize: '\$25,000 USD',
        attendees: 350,
        isUpcoming: true,
        image: 'assets/images/event1.jpg',
      ),
      Event(
        title: 'REChain x Stellar Meridian Hackathon',
        subtitle: 'London, UK',
        date: '12-13 Oct 2024',
        duration: '36 hours',
        prize: '\$50,000 USD',
        attendees: 280,
        isUpcoming: true,
        image: 'assets/images/event2.jpg',
      ),
      Event(
        title: 'REChain x VeChain Singapore Hackathon',
        subtitle: 'Singapore',
        date: '14-15 Sep 2024',
        duration: '36 hours',
        prize: '\$30,000 USD',
        attendees: 200,
        isUpcoming: true,
        image: 'assets/images/event3.jpg',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('События'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return EventCard(event: event).animate().fadeIn(
            delay: Duration(milliseconds: index * 100),
            duration: 600.ms,
          ).slideX(begin: 0.3, end: 0);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Создать событие'),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Изображение события
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor.withOpacity(0.8),
                  AppTheme.secondaryColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Заглушка для изображения
                Center(
                  child: Icon(
                    Icons.event,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                // Статус события
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: event.isUpcoming 
                          ? AppTheme.accentColor 
                          : AppTheme.successColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.isUpcoming ? 'Скоро' : 'Завершено',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Подзаголовок
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.textSecondaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Детали события
                Row(
                  children: [
                    Expanded(
                      child: _buildEventDetail(
                        Icons.calendar_today,
                        event.date,
                      ),
                    ),
                    Expanded(
                      child: _buildEventDetail(
                        Icons.access_time,
                        event.duration,
                      ),
                    ),
                    Expanded(
                      child: _buildEventDetail(
                        Icons.emoji_events,
                        event.prize,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Участники
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: AppTheme.textSecondaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${event.attendees} участников',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Кнопки действий
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Подробнее'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: event.isUpcoming ? () {} : null,
                        child: Text(event.isUpcoming ? 'Регистрация' : 'Завершено'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class Event {
  final String title;
  final String subtitle;
  final String date;
  final String duration;
  final String prize;
  final int attendees;
  final bool isUpcoming;
  final String image;

  Event({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.duration,
    required this.prize,
    required this.attendees,
    required this.isUpcoming,
    required this.image,
  });
}
