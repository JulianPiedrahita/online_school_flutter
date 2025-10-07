import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:eqx/widgets/background.dart';

class CalendarioEventosScreen extends StatelessWidget {
  final Map<DateTime, List<Map<String, dynamic>>> eventos;
  const CalendarioEventosScreen({Key? key, required this.eventos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F3460).withOpacity(0.9),
                Color(0xFF16DB93).withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Calendario de Eventos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          Background(),
          _CalendarioEventosBody(eventos: eventos),
        ],
      ),
    );
  }
}

class _CalendarioEventosBody extends StatefulWidget {
  final Map<DateTime, List<Map<String, dynamic>>> eventos;
  const _CalendarioEventosBody({Key? key, required this.eventos}) : super(key: key);

  @override
  State<_CalendarioEventosBody> createState() => _CalendarioEventosBodyState();
}

class _CalendarioEventosBodyState extends State<_CalendarioEventosBody> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<Map<String, dynamic>>(
          firstDay: DateTime(DateTime.now().year - 5),
          lastDay: DateTime(DateTime.now().year + 5),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: (day) {
            return widget.eventos[DateTime(day.year, day.month, day.day)] ?? [];
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: CalendarStyle(
            markerDecoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _buildEventosList(),
        ),
      ],
    );
  }

  Widget _buildEventosList() {
    final eventos = widget.eventos[DateTime(
      _selectedDay?.year ?? _focusedDay.year,
      _selectedDay?.month ?? _focusedDay.month,
      _selectedDay?.day ?? _focusedDay.day,
    )] ?? [];
    if (eventos.isEmpty) {
      return const Center(child: Text('No hay eventos para este día.'));
    }
    return ListView.builder(
      itemCount: eventos.length,
      itemBuilder: (context, index) {
        final evento = eventos[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.event),
            title: Text(evento['nombre'] ?? ''),
            subtitle: Text(evento['descripcion'] ?? ''),
          ),
        );
      },
    );
  }
}
