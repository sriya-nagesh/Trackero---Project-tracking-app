//Sriya Nagesh (SUKD1902368) BIT-UCLAN
import 'package:trackero/export.dart';

//onbairding/ how to use page
class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: controller,
            children: [
              Container(
                color: const Color.fromRGBO(239, 242, 241, 1),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/onboarding/0.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(239, 242, 241, 1),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/onboarding/1.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(239, 242, 241, 1),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/onboarding/2.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(239, 242, 241, 1),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/onboarding/3.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(239, 242, 241, 1),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/onboarding/4.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(239, 242, 241, 1),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/onboarding/5.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(239, 242, 241, 1),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/onboarding/6.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(239, 242, 241, 1),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/onboarding/7.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(239, 242, 241, 1),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/onboarding/8.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(239, 242, 241, 1),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/onboarding/9.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(239, 242, 241, 1),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/onboarding/10.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(239, 242, 241, 1),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/onboarding/11.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(239, 242, 241, 1),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/onboarding/12.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          color: const Color.fromRGBO(239, 242, 241, 1),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'DONE',
                    style: lightblue,
                  )),
              Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 13,
                  effect: const SlideEffect(
                    dotHeight: 7,
                    dotWidth: 7,
                    spacing: 10,
                    dotColor: Color.fromRGBO(151, 216, 196, 1),
                    activeDotColor: Color.fromRGBO(107, 151, 202, 1),
                  ),
                  onDotClicked: (pageno) => controller.animateToPage(pageno,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInExpo),
                ),
              ),
              TextButton(
                  onPressed: () {
                    controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  child: const Text(
                    'NEXT',
                    style: lightblue,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
