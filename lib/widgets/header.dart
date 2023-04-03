//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

class Header extends StatelessWidget {
  const Header({Key? key, required this.text, this.color}) : super(key: key);

  final String text;
  final dynamic color;

//widget for background images for screens
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Color.fromRGBO(239, 242, 241, 1), fontSize: 18),
      ),
    );
  }
}
