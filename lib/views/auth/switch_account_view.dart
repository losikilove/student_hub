import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_hub/models/model/users.dart';

import 'package:student_hub/view_models/auth_account_viewModel.dart';
import 'package:student_hub/view_models/controller_route.dart';
import 'package:student_hub/widgets/add_account_widget.dart';
import 'package:student_hub/models/not_use/company_user.dart';
import 'package:student_hub/widgets/theme/dark_mode.dart';
import 'package:student_hub/widgets/theme/localization_checker.dart';

class SwitchAccountView extends StatefulWidget {
  final User user;
  int? selectedIndex;
  SwitchAccountView(this.user, this.selectedIndex, {Key? key})
      : super(key: key);

  @override
  _SwitchAccountViewState createState() => _SwitchAccountViewState();
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({Key? key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Student Hub',
          style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontWeight: FontWeight.bold)),
      backgroundColor: const Color(0xFFBEEEF7),
      actions: <Widget>[
        IconButton(
          icon: const SizedBox(
            width: 25,
            height: 25,
            child: Icon(Icons.search, color: Colors.black),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SwitchAccountViewState extends State<SwitchAccountView> {
  late SharedPreferences prefs;
  static const String darkModeKey = 'switchAccountDarkMode';
  int? role;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getInt('role')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<DarkModeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: isDarkMode ? Colors.white : Color(0xFF242526),
          onPressed: () {
            widget.selectedIndex == null
                ? Navigator.pop(context)
                : ControllerRoute(context).navigateToHomeScreen(
                    false, widget.user, widget.selectedIndex!);
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
        actions: <Widget>[],
      ),
      backgroundColor: isDarkMode ? Color(0xFF212121) : Colors.white,
      body: Column(
        children: <Widget>[
          // If there are no accounts, show AddAccountWidget, else show a dropdown list of accounts
          accounts.isEmpty
              ? AddAccountWidget(widget.user)
              : GestureDetector(
                  onTap: () {
                    AuthAccountViewModel(context).showAccountList(widget.user);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                              child: Text("switchaccount".tr(),
                                  style: GoogleFonts.poppins(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Transform.rotate(
                              angle: -90 *
                                  3.14159 /
                                  180, // Convert degrees to radians
                              child: Icon(Icons.arrow_back_ios,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors
                                          .black, // Đổi màu dựa trên trạng thái dark mode
                                  size: 18.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDarkMode
                                ? Color.fromARGB(255, 90, 90, 90)!
                                : Colors.grey[200]!,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Image.asset(
                              "${role == 0 ? 'assets/icons/student_account.png' : 'assets/icons/company_account.png'}",
                            ),
                          ),
                        ),

                        SizedBox(
                            width: 20), // Khoảng cách giữa hình ảnh và văn bản
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.user.fullname!}",
                              textAlign: TextAlign.center, // Căn giữa văn bản
                              style: GoogleFonts.poppins(
                                color: Color(0xFF406AFF),
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 4), // Khoảng cách giữa hai phần
                            Text(
                              "${role == 0 ? 'student_auth1'.tr() : 'student_auth2'.tr()}",
                              textAlign: TextAlign.center, // Căn giữa văn bản
                              style: GoogleFonts.poppins(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

          const Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            // Set the padding you want
          ),
          Container(
            color: isDarkMode ? Color(0xFF212121) : Colors.white,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      print(
                          'Techstack: ${widget.user.studentUser!.techStack!.name}');
                      print(
                          'Skillset: ${widget.user.studentUser!.skillSet!.map((e) => e.name)}');
                      print(
                          'Language: ${widget.user.studentUser!.languages!.map((e) => e.languageName)}');
                      print(
                          'Education: ${widget.user.studentUser!.education!.map((e) => e.schoolName)}');
                      // skillset in experience
                      print(
                          'Skillset in experience: ${widget.user.studentUser!.experience!.map((e) => e.skillSet!.map((e) => e.name))}');
                      AuthAccountViewModel(context).userProfile(widget.user);
                    },
                    icon: Image.asset(
                      'assets/icons/profile.jpg',
                      color: isDarkMode ? Colors.white : Colors.black,
                      width: 28.0,
                      height: 28.0,
                    ),
                    label: Text(
                      'switchaccount1'.tr(),
                      style: GoogleFonts.poppins(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Divider(), // Set the padding you want
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 10,
                        0), // Điều chỉnh giá trị padding theo nhu cầu của bạn
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/theme.png', // Đường dẫn của hình ảnh
                          color: isDarkMode ? Colors.white : Colors.black,
                          width: 40.0, // Chiều rộng của biểu tượng (nếu cần)
                          height: 40.0, // Chiều cao của biểu tượng (nếu cần)
                        ),
                        SizedBox(
                            width:
                                4.0), // Khoảng cách giữa biểu tượng và văn bản
                        Text(
                          'switchaccount2'.tr(),
                          style: GoogleFonts.poppins(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Switch(
                          value: isDarkMode, // Trạng thái bật/tắt
                          onChanged: (bool value) {
                            Provider.of<DarkModeProvider>(context,
                                    listen: false)
                                .toggleDarkMode();
                          },
                          activeColor: Color(0xFF406AFF), // Màu khi bật
                          inactiveThumbColor: Colors.grey, // Màu khi tắt
                          inactiveTrackColor: const Color.fromARGB(
                              255, 255, 255, 255), // Màu nền khi tắt
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Divider(), // Set the padding you want
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        10, 0, 10, 0), // Adjust the padding as needed
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/language.png', // Path to the image
                          color: isDarkMode ? Colors.white : Colors.black,
                          width: 30.0, // Width of the icon (if needed)
                          height: 30.0, // Height of the icon (if needed)
                        ),
                        SizedBox(
                            width: 8.0), // Space between the icon and the text
                        Text(
                          'switchaccount4'.tr(),
                          style: GoogleFonts.poppins(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        DropdownButton<String>(
                          value: context
                              .locale.languageCode, // Current selected language
                          
                          dropdownColor: isDarkMode
                              ? Color.fromARGB(255, 46, 46, 48)
                              : Colors.white,
                          underline: Container(
                            height: 2,
                            color: Color(0xFF406AFF),
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              LocalizationChecker.changeLanguage(context);
                            }
                          },
                          items: <String>['en', 'vi']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value == 'en' ? 'language1'.tr() : 'language16'.tr(),
                                style: GoogleFonts.poppins(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Divider(), // Set the padding you want
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      // Log out button pressed
                      AuthAccountViewModel(context).logoutAccount();
                    },
                    icon: Image.asset(
                      'assets/icons/logout.jpg', // Đường dẫn của hình ảnh
                      color: isDarkMode ? Colors.white : Colors.black,
                      width: 28.0, // Chiều rộng của biểu tượng (nếu cần)
                      height: 28.0, // Chiều cao của biểu tượng (nếu cần)
                    ),
                    label: Text('switchaccount3'.tr(),
                        style: GoogleFonts.poppins(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
