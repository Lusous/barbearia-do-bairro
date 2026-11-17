import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const BarbeariaApp());
}

class BarbeariaApp extends StatelessWidget {
  const BarbeariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barbearia do Bairro',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B5E20)),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class Service {
  final String name;
  final double price;
  final int duration;

  const Service({
    required this.name,
    required this.price,
    required this.duration,
  });
}

class Appointment {
  final String client;
  final Service service;
  final DateTime date;
  final String time;
  final String professional;

  const Appointment({
    required this.client,
    required this.service,
    required this.date,
    required this.time,
    required this.professional,
  });
}

const services = <Service>[
  Service(name: 'Corte', price: 35, duration: 30),
  Service(name: 'Corte + Barba', price: 50, duration: 45),
  Service(name: 'Barba', price: 25, duration: 20),
];

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe e-mail e senha.')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const BookingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.content_cut, size: 64),
                      const SizedBox(height: 16),
                      const Text(
                        'Barbearia do Bairro',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Entre para consultar e agendar seu atendimento.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip: 'Mostrar ou ocultar senha',
                            onPressed: () => setState(
                              () => obscurePassword = !obscurePassword,
                            ),
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: login,
                          child: const Text('Entrar'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text('Fluxo de recuperação demonstrativo.'),
                          ),
                        ),
                        child: const Text('Esqueci minha senha'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  Service selectedService = services.first;
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String? selectedTime;

  final times = const ['09:00', '09:30', '10:00', '11:00', '14:00', '15:30'];

  Future<void> chooseDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      initialDate: selectedDate,
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
        selectedTime = null;
      });
    }
  }

  void confirmBooking() {
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha um horário disponível.')),
      );
      return;
    }

    final appointment = Appointment(
      client: 'Bruno Lima',
      service: selectedService,
      date: selectedDate,
      time: selectedTime!,
      professional: 'Marcos',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmationPage(appointment: appointment),
      ),
    );
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Serviços e agendamento')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Escolha o serviço',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Service>(
   initialValue: selectedService,
              decoration: const InputDecoration(labelText: 'Serviço'),
              items: services
                  .map(
                    (service) => DropdownMenuItem(
                      value: service,
                      child: Text(
                        '${service.name} — R\$ ${service.price.toStringAsFixed(2)}',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => selectedService = value);
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: chooseDate,
              icon: const Icon(Icons.calendar_month),
              label: Text(formatDate(selectedDate)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Horários disponíveis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: times.map((time) {
                final selected = selectedTime == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: selected,
                  onSelected: (_) => setState(() => selectedTime = time),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: confirmBooking,
                icon: const Icon(Icons.check),
                label: const Text('Confirmar agendamento'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationPage extends StatefulWidget {
  final Appointment appointment;

  const ConfirmationPage({super.key, required this.appointment});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  bool cancelled = false;

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  void cancelAppointment() {
    setState(() => cancelled = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Agendamento cancelado.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmação')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Icon(
              cancelled ? Icons.cancel_outlined : Icons.check_circle,
              size: 72,
              color: cancelled ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 12),
            Text(
              cancelled ? 'Agendamento cancelado' : 'Agendamento confirmado!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _InfoRow(label: 'Cliente', value: appointment.client),
                    _InfoRow(label: 'Serviço', value: appointment.service.name),
                    _InfoRow(
                      label: 'Profissional',
                      value: appointment.professional,
                    ),
                    _InfoRow(
                      label: 'Data',
                      value: formatDate(appointment.date),
                    ),
                    _InfoRow(label: 'Horário', value: appointment.time),
                    _InfoRow(
                      label: 'Valor',
                      value:
                          'R\$ ${appointment.service.price.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar aos serviços'),
            ),
            if (!cancelled) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: cancelAppointment,
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Cancelar agendamento'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
