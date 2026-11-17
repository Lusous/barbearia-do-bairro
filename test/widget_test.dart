import 'package:flutter_test/flutter_test.dart';
import 'package:barbearia_do_bairro/main.dart';

void main() {
  testWidgets('exibe a tela de login', (tester) async {
    await tester.pumpWidget(const BarbeariaApp());

    expect(find.text('Barbearia do Bairro'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
  });
}
