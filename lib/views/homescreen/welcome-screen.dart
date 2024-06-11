import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/models/model/users.dart';
import 'package:student_hub/view_models/controller_route.dart';
import 'package:student_hub/views/auth/switch_account_view.dart';
import 'package:student_hub/widgets/theme/dark_mode.dart';

class WelcomeScreen extends StatefulWidget {
  final User companyUser;
  final String fullName;
  const WelcomeScreen(this.companyUser, this.fullName, {super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.5, // Start fading in at 50% of the animation duration
          1.0, // Fully faded in at 100% of the animation duration
          curve: Curves.easeIn,
        ),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<DarkModeProvider>(context).isDarkMode;
    return Scaffold(
      appBar: _AppBar(_animationController, widget.companyUser),
      backgroundColor: isDarkMode ? Color(0xFF212121) : Colors.white,
      body: SafeArea(
        child: _Body(
            animationController: _animationController,
            fadeAnimation: _fadeAnimation,
            companyUser: widget.companyUser),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant WelcomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationController.reset();
    _animationController.forward();
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final AnimationController animationController;
  User companyUser;

  _AppBar(this.animationController, this.companyUser, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<DarkModeProvider>(context).isDarkMode;
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: isDarkMode ? Colors.white : Color(0xFF242526),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('Student Hub',
          style: GoogleFonts.poppins(
              // Apply the Poppins font
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold)),
      backgroundColor:
          isDarkMode ? Color.fromARGB(255, 28, 28, 29) : Colors.white,
      actions: <Widget>[
        IconButton(
            icon: Container(
              // Add a Container as the parent
              padding: const EdgeInsets.all(8.0), // Padding for spacing
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),
                child: Image.asset('assets/icons/user_ic.png',
                    width: 25, height: 25),
              ),
            ),
            onPressed: () {
              animationController.stop();
              FocusScope.of(context).unfocus();
              Future.delayed(const Duration(milliseconds: 300), () {
                // Navigate to the user information registration page
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        SwitchAccountView(companyUser, null),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = const Interval(
                        0.3,
                        0.9,
                        curve: Curves.fastOutSlowIn,
                      );
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                ).then((_) {
                  animationController.reset();
                  animationController.forward();
                });
              });
            })
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _Body extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> fadeAnimation;
  final User companyUser;

  const _Body(
      {super.key,
      required this.animationController,
      required this.fadeAnimation,
      required this.companyUser});

  //

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: _Content(
                animationController: animationController,
                fadeAnimation: fadeAnimation,
                companyUser: companyUser),
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final User companyUser;
  final AnimationController animationController;
  final Animation<double> fadeAnimation;

  const _Content(
      {super.key,
      required this.animationController,
      required this.fadeAnimation,
      required this.companyUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Animated Image
        SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
                  .animate(
            CurvedAnimation(
              parent: animationController,
              curve: const Interval(
                0.3,
                0.6,
                curve: Curves.fastOutSlowIn,
              ),
            ),
          ),
          child: const AnimationImage(),
        ),
        // Animated Text
        SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
                  .animate(
            CurvedAnimation(
              parent: animationController,
              curve: const Interval(
                0.3,
                0.7,
                curve: Curves.fastOutSlowIn,
              ),
            ),
          ),
          child: _AnimatedText(companyUser: companyUser),
        ),
        // ... (Rest of your body code) ...
        SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
                  .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(
              0.3,
              0.8,
              curve: Curves.fastOutSlowIn,
            ),
          )),
          child: const _DescriptionText(),
        ),
        // Animated Buttons
        const SizedBox(
            height: 50), // Add some space between the text and the buttons
        SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(0, -0.5), end: const Offset(0, 0))
              .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(
              0.3,
              1,
              curve: Curves.fastOutSlowIn,
            ),
          )),
          child: FadeTransition(
            opacity: fadeAnimation,
            child: _AnimatedButton(
                text: 'welcome_welcomecompany3'.tr(), companyUser: companyUser),
          ),
        ),

        const SizedBox(height: 20),
        SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
                  .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(
              0.4,
              1,
              curve: Curves.fastOutSlowIn,
            ),
          )),
        ),
      ],
    );
  }
}

class _AnimatedText extends StatelessWidget {
  final User companyUser;
  const _AnimatedText({super.key, required this.companyUser});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<DarkModeProvider>(context).isDarkMode;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 80, 20, 5),
      child: Align(
        alignment: Alignment.topCenter,
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Màu của phần còn lại của văn bản
            ),
            children: [
              TextSpan(
                text: "welcome_welcomecompany2".tr(),
                style: GoogleFonts.poppins(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              TextSpan(
                text: "${companyUser.fullname}",
                style: GoogleFonts.poppins(
                  color: Color(0xFF406AFF),
                  fontWeight: FontWeight.bold, // Màu của phần được đổi
                ),
              ),
              TextSpan(
                text: " !",
                style: GoogleFonts.poppins(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DescriptionText extends StatelessWidget {
  const _DescriptionText({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<DarkModeProvider>(context).isDarkMode;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          "welcome_welcomecompany1".tr(),
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _AnimatedButton extends StatelessWidget {
  final String text;
  final User companyUser;

  const _AnimatedButton(
      {super.key, required this.text, required this.companyUser});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Set the width to your desired size
      height: 50, // Set the height to your desired size
      child: ElevatedButton(
        onPressed: () {
          ControllerRoute(context).navigateToHomeScreen(false, companyUser, 1);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF406AFF),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(text,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}

class AnimationImage extends StatelessWidget {
  const AnimationImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 90, 20, 5),
      child: Align(
        alignment: Alignment.topCenter,
        child: Image.asset(
          'assets/images/get-started_img.png',
        ),
      ),
    );
  }
}
