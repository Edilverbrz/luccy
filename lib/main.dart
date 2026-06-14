import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/controllers/luccy_controller.dart';
import 'src/infra/shared_prefs_expense_repository.dart';
import 'src/models/expense.dart';

void main() {
  runApp(const LuccyApp());
}

class LuccyApp extends StatelessWidget {
  const LuccyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LuccyController(repository: SharedPrefsExpenseRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Luccy',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.teal,
          scaffoldBackgroundColor: const Color(0xFFF3F4F6),
          textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Inter'),
        ),
        home: const LuccyShell(),
      ),
    );
  }
}

class LuccyShell extends StatelessWidget {
  const LuccyShell({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<LuccyController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450, maxHeight: 900),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFF0F172A), width: 10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 40,
                  offset: const Offset(0, 24),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: ctrl.authState != AuthState.authenticated
                  ? const AuthPage()
                  : ctrl.setupState == SetupState.inProgress
                      ? const SetupPage()
                      : const DashboardPage(),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<LuccyController>();
    final isLogin = ctrl.authState == AuthState.login;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFDFF6F2), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 40,
                offset: const Offset(0, 18),
              ),
            ],
            border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
          ),
          child: Column(
            children: [
              const SizedBox(height: 28),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F766E),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF14B8A6).withOpacity(0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.android, size: 42, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                'Luccy',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F766E),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Finanzas inteligentes y seguras',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF175E58),
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 24,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _TabButton(
                              text: 'Iniciar Sesión',
                              selected: isLogin,
                              onTap: () => ctrl.setAuthState(AuthState.login),
                            ),
                          ),
                          Expanded(
                            child: _TabButton(
                              text: 'Registrarse',
                              selected: !isLogin,
                              onTap: () => ctrl.setAuthState(AuthState.register),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFFE2E8F0), height: 1),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (!isLogin) ...[
                              const Text(
                                'Nombre',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _TextField(
                                controller: nameController,
                                hint: '¿Cómo te llamas?',
                                icon: Icons.person,
                              ),
                              const SizedBox(height: 18),
                            ],
                            const Text(
                              'Correo Electrónico',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _TextField(
                              controller: emailController,
                              hint: 'tu@correo.com',
                              icon: Icons.mail,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Contraseña',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _TextField(
                              controller: passwordController,
                              hint: '••••••••',
                              icon: Icons.lock,
                              obscureText: true,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                ctrl.submitAuth(name: nameController.text);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F766E),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                shadowColor: const Color(0xFF0F766E).withOpacity(0.35),
                                elevation: 12,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isLogin ? 'Entrar a mi cuenta' : 'Crear mi cuenta',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final incomeController = TextEditingController();
  final fixedDescController = TextEditingController();
  final fixedAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<LuccyController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 28,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFE0F2FE), Color(0xFFF0FEF9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F766E),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.android, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hola, ${ctrl.userName.isEmpty ? 'Usuario' : ctrl.userName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Color(0xFF115E59),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Configuremos tu mes',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF0F766E),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          '1. Tus Ingresos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '¿Cuánto dinero entra este mes?',
                          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 18),
                        _AmountInput(
                          controller: incomeController,
                          hintText: '0.00',
                          onChanged: (value) => ctrl.setIncome(double.tryParse(value) ?? 0.0),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          '2. Gastos Fijos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Añade renta, servicios, suscripciones, etc.',
                                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                              ),
                            ),
                            Text(
                              ctrl.formatCurrency(ctrl.totalFixedExpenses),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFBE123C),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _TextField(
                                      controller: fixedDescController,
                                      hint: 'Ej. Renta',
                                      filled: true,
                                      hasBorder: false,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 110,
                                    child: _TextField(
                                      controller: fixedAmountController,
                                      hint: '0.00',
                                      filled: true,
                                      hasBorder: false,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F766E),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF0F766E).withOpacity(0.25),
                                          blurRadius: 14,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.add, color: Colors.white),
                                      onPressed: () {
                                        final amount = double.tryParse(fixedAmountController.text) ?? 0.0;
                                        if (amount > 0 && fixedDescController.text.trim().isNotEmpty) {
                                          ctrl.addFixedExpense(fixedDescController.text.trim(), amount);
                                          fixedDescController.clear();
                                          fixedAmountController.clear();
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (ctrl.fixedExpenses.isEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 22),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'No has añadido gastos fijos aún.',
                                    style: TextStyle(color: Color(0xFF94A3B8)),
                                  ),
                                )
                              else
                                Column(
                                  children: ctrl.fixedExpenses
                                      .map(
                                        (item) => Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(22),
                                              border: Border.all(color: const Color(0xFFE2E8F0)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.04),
                                                  blurRadius: 18,
                                                  offset: const Offset(0, 10),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 42,
                                                  height: 42,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFEE2E2),
                                                    borderRadius: BorderRadius.circular(14),
                                                  ),
                                                  child: const Icon(Icons.trending_down, color: Color(0xFFB91C1C)),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    item.description,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: Color(0xFF0F172A),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  ctrl.formatCurrency(item.amount),
                                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                                ),
                                                const SizedBox(width: 12),
                                                GestureDetector(
                                                  onTap: () => ctrl.removeFixedExpense(item.id),
                                                  child: const Icon(Icons.delete_outline, color: Color(0xFF64748B)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: ElevatedButton(
                      onPressed: ctrl.income > 0 ? () => ctrl.finishSetup() : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F766E),
                        disabledBackgroundColor: const Color(0xFFCBD5E1),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        elevation: 12,
                        shadowColor: const Color(0xFF0F766E).withOpacity(0.28),
                      ),
                      child: const Text(
                        '¡Todo listo, comenzar!',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool showAddModal = false;
  final expenseAmountController = TextEditingController();
  final expenseDescController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<LuccyController>();
    final activeTab = ctrl.activeTab;
    final status = ctrl.getLuccyStatus();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 34,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0F766E),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.16),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: const Icon(Icons.android, color: Colors.white, size: 24),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Hola, ${ctrl.userName.isEmpty ? 'Usuario' : ctrl.userName}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'Tu Resumen',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ctrl.setSetupState(SetupState.inProgress);
                                      ctrl.setActiveTab('dashboard');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.14),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: const Text(
                                        'Editar Mes',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 18),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                                ),
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Disponible para gastar',
                                      style: TextStyle(
                                        color: Color(0xFFBDE0DF),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      ctrl.formatCurrency(ctrl.currentAvailable),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 38,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Presupuesto Libre',
                                              style: TextStyle(
                                                color: Color(0xFFCAE7E2),
                                                fontSize: 10,
                                                letterSpacing: 0.8,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              ctrl.formatCurrency(ctrl.freeBudget),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            const Text(
                                              'Ya Gastado',
                                              style: TextStyle(
                                                color: Color(0xFFCAE7E2),
                                                fontSize: 10,
                                                letterSpacing: 0.8,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              ctrl.formatCurrency(ctrl.totalSpent),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _StatusCard(status: status),
                                  const SizedBox(height: 18),
                                  _StatsCards(ctrl: ctrl),
                                  const SizedBox(height: 18),
                                  _BudgetProgress(percentage: ctrl.percentageSpent),
                                  const SizedBox(height: 22),
                                  activeTab == 'dashboard'
                                      ? const SizedBox.shrink()
                                      : _HistorySection(ctrl: ctrl, status: status),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 92,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showAddModal = true;
                  });
                },
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F766E),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F766E).withOpacity(0.28),
                        blurRadius: 28,
                        offset: const Offset(0, 18),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFF8FAFC), width: 6),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 34),
                ),
              ),
            ),
          ),
          if (showAddModal)
            _AddExpenseModal(
              onClose: () {
                setState(() {
                  showAddModal = false;
                });
              },
              onSubmit: () {
                final amount = double.tryParse(expenseAmountController.text) ?? 0.0;
                if (amount > 0 && expenseDescController.text.trim().isNotEmpty) {
                  ctrl.addVariableExpense(amount, expenseDescController.text.trim());
                  expenseAmountController.clear();
                  expenseDescController.clear();
                  setState(() {
                    showAddModal = false;
                  });
                }
              },
              amountController: expenseAmountController,
              descController: expenseDescController,
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: const Color(0xFFCBD5E1).withOpacity(0.7))),
        ),
        height: 92,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: _NavBarButton(
                icon: Icons.home,
                label: 'INICIO',
                active: ctrl.activeTab == 'dashboard',
                onTap: () => ctrl.setActiveTab('dashboard'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Container()),
            const SizedBox(width: 10),
            Expanded(
              child: _NavBarButton(
                icon: Icons.history,
                label: 'HISTORIAL',
                active: ctrl.activeTab == 'history',
                onTap: () => ctrl.setActiveTab('history'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.text,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(22),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: selected ? const Color(0xFF0F766E) : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.hint,
    this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.filled = false,
    this.hasBorder = true,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool filled;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF94A3B8), size: 18) : null,
        hintText: hint,
        filled: filled,
        fillColor: filled ? const Color(0xFFF1F5F9) : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: hasBorder ? const Color(0xFFE2E8F0) : Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF0F766E)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFECFEFF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                bottomLeft: Radius.circular(28),
              ),
            ),
            child: const Text(
              '\$',
              style: TextStyle(
                color: Color(0xFF0F766E),
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              ),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status, super.key});

  final LuccyStatus status;

  @override
  Widget build(BuildContext context) {
    final bgColor = status.level == StatusLevel.critical
        ? const Color(0xFFFEE2E2)
        : status.level == StatusLevel.danger
            ? const Color(0xFFFFEDD5)
            : status.level == StatusLevel.attention
                ? const Color(0xFFFFFBEB)
                : const Color(0xFFE6FFFA);
    final borderColor = status.level == StatusLevel.critical
        ? const Color(0xFFFB7185)
        : status.level == StatusLevel.danger
            ? const Color(0xFFF97316)
            : status.level == StatusLevel.attention
                ? const Color(0xFFF59E0B)
                : const Color(0xFF2DD4BF);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: borderColor.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              status.level == StatusLevel.critical || status.level == StatusLevel.danger
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle_outline,
              color: status.level == StatusLevel.critical
                  ? const Color(0xFFB91C1C)
                  : status.level == StatusLevel.danger
                      ? const Color(0xFFEA580C)
                      : status.level == StatusLevel.attention
                          ? const Color(0xFFB45309)
                          : const Color(0xFF0F766E),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mensaje de Luccy',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status.message,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.5),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _StatsCards extends StatelessWidget {
  const _StatsCards({required this.ctrl, super.key});

  final LuccyController ctrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.account_balance_wallet,
            label: 'INGRESOS',
            value: ctrl.formatCurrency(ctrl.income),
            color: const Color(0xFF0F766E),
            bgColor: const Color(0xFFE0F2FE),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _StatCard(
            icon: Icons.trending_down,
            label: 'FIJOS',
            value: ctrl.formatCurrency(ctrl.totalFixedExpenses),
            color: const Color(0xFFBE123C),
            bgColor: const Color(0xFFFEF2F2),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color.withOpacity(0.88),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
          ),
        ],
      ),
    );
  }
}

class _BudgetProgress extends StatelessWidget {
  const _BudgetProgress({required this.percentage, super.key});

  final double percentage;

  @override
  Widget build(BuildContext context) {
    final progress = (percentage / 100).clamp(0.0, 1.0);
    final color = percentage > 80
        ? const Color(0xFFB91C1C)
        : percentage > 50
            ? const Color(0xFFF59E0B)
            : const Color(0xFF0F766E);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Consumo del presupuesto',
                style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              Text(
                '${(percentage.clamp(0, 100)).toStringAsFixed(0)}%',
                style: TextStyle(fontWeight: FontWeight.w800, color: color),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              color: color,
              backgroundColor: const Color(0xFFE2E8F0),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.ctrl, required this.status, super.key});

  final LuccyController ctrl;
  final LuccyStatus status;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historial y Alertas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 16),
        if (ctrl.percentageSpent > 50)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.notifications_active, color: Color(0xFF0F766E), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    status.message,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        const Text(
          'Tus Gastos Variables',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 12),
        if (ctrl.variableExpenses.isEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              children: const [
                Icon(Icons.account_balance_wallet, size: 36, color: Color(0xFF94A3B8)),
                SizedBox(height: 14),
                Text(
                  'No has registrado ningún gasto extra aún. ¡Sigue así!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
              ],
            ),
          )
        else
          Column(
            children: ctrl.variableExpenses
                .map(
                  (expense) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.trending_down, color: Color(0xFF334155)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(expense.description, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                                const SizedBox(height: 4),
                                Text(expense.date, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '-${ctrl.formatCurrency(expense.amount)}',
                            style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFFBE123C)),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _AddExpenseModal extends StatelessWidget {
  const _AddExpenseModal({
    required this.onClose,
    required this.onSubmit,
    required this.amountController,
    required this.descController,
    super.key,
  });

  final VoidCallback onClose;
  final VoidCallback onSubmit;
  final TextEditingController amountController;
  final TextEditingController descController;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.42),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(34),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.14),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Añadir Gasto',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                        ),
                      ),
                      GestureDetector(
                        onTap: onClose,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.close, color: Color(0xFF475569)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    '¿Cuánto gastaste?',
                    style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 10),
                  _AmountInput(
                    controller: amountController,
                    hintText: '0.00',
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    '¿En qué?',
                    style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 10),
                  _TextField(
                    controller: descController,
                    hint: 'Ej. Café, Uber, Cine...',
                    filled: true,
                    hasBorder: false,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 12,
                      shadowColor: const Color(0xFF0F766E).withOpacity(0.28),
                    ),
                    child: const Text(
                      'Registrar',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarButton extends StatelessWidget {
  const _NavBarButton({required this.icon, required this.label, required this.active, required this.onTap, super.key});

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: active ? const Color(0xFF0F766E) : const Color(0xFF94A3B8)),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.9,
              color: active ? const Color(0xFF0F766E) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
