import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/models/model/proposal.dart';
import 'package:student_hub/models/model/users.dart';
import 'package:student_hub/models/not_use/project_company.dart';
import 'package:student_hub/widgets/show_project_company_widget.dart';
import 'package:student_hub/widgets/theme/dark_mode.dart';

class AllProjectsPageStudent extends StatefulWidget {
  final User user;
  final Future<List<Proposal>> Function() fetchProjectDataFunction;
  const AllProjectsPageStudent(
      {super.key, required this.user, required this.fetchProjectDataFunction});
  @override
  _AllProjectsPageStudentState createState() => _AllProjectsPageStudentState();
}

class _AllProjectsPageStudentState extends State<AllProjectsPageStudent>
    with WidgetsBindingObserver {
  late final PageController _pageController;
  late Future<List<Proposal>> futureProjects;
  late int lenghtActiveProposal = 0;
  late int lenghtSubmittedProposal = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()..addListener(_onPageChange);
    setState(() {
      futureProjects = widget.fetchProjectDataFunction();
      countProposal();
      print(lenghtActiveProposal);
      print(lenghtSubmittedProposal);
    });
  }

  void countProposal() async {
    List<Proposal> proposals = await widget.fetchProjectDataFunction();
    int tempActiveProposal = 0;
    int tempSubmittedProposal = 0;
    for (var proposal in proposals) {
      if (proposal.statusFlag == 1) {
        tempActiveProposal++;
      }
      if (proposal.statusFlag == 0) {
        tempSubmittedProposal++;
      }
    }
    if (mounted) {
      // Kiểm tra xem widget còn mounted hay không
      setState(() {
        lenghtActiveProposal = tempActiveProposal;
        lenghtSubmittedProposal = tempSubmittedProposal;
      });
    }
    ;
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChange);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.page == _pageController.initialPage) {
        if (mounted) {
          setState(() {
            futureProjects = widget.fetchProjectDataFunction();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<DarkModeProvider>(context).isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          child: Text(
            "${'studentdashboard_student5'.tr()} ($lenghtActiveProposal)",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        Expanded(
          // Thêm Expanded ở đây
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(bottom: 0)),
                Expanded(
                  child: FutureBuilder<List<Proposal>>(
                    future: futureProjects,
                    builder: (context, proposal) {
                      if (proposal.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (proposal.hasError) {
                        return Text('Error: ${proposal.error}');
                      } else if (proposal.hasData && proposal.data!.isEmpty) {
                        return Center(
                            child: Text(
                          "studentdashboard_student18".tr(),
                          style: GoogleFonts.poppins(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ));
                      } else {
                        return ListView.builder(
                          itemCount: proposal.data!.length,
                          itemBuilder: (context, index) {
                            Proposal proposalItem = proposal.data![index];
                            print(proposalItem.projectCompany!.title);
                            print(proposalItem.projectCompany!.description);
                            if (proposalItem.statusFlag != 1) {
                              return const SizedBox.shrink();
                            }
                            return GestureDetector(
                              onTap: () {},
                              child: ShowProjectCompanyWidget(
                                projectCompany: proposalItem.projectCompany!,
                                quantities: const [],
                                labels: const [],
                                showOptionsIcon: false,
                                onProjectDeleted: () {},
                                user: widget.user,
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          child: Text(
            "${'studentdashboard_student6'.tr()} ($lenghtSubmittedProposal)",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        Expanded(
          // Thêm Expanded ở đây
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(bottom: 0)),
                Expanded(
                  child: FutureBuilder<List<Proposal>>(
                    future: futureProjects,
                    builder: (context, proposal) {
                      if (proposal.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (proposal.hasError) {
                        return Text('Error: ${proposal.error}');
                      } else if (proposal.hasData && proposal.data!.isEmpty) {
                        return Center(
                            child: Text(
                          "studentdashboard_student17".tr(),
                          style: GoogleFonts.poppins(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ));
                      } else {
                        return ListView.builder(
                          itemCount: proposal.data!.length,
                          itemBuilder: (context, index) {
                            Proposal proposalItem = proposal.data![index];
                            print(proposalItem.projectCompany!.title);
                            print(proposalItem.projectCompany!.description);
                            if (proposalItem.statusFlag != 0) {
                              return const SizedBox.shrink();
                            }
                            return GestureDetector(
                              onTap: () {},
                              child: ShowProjectCompanyWidget(
                                projectCompany: proposalItem.projectCompany!,
                                quantities: const [],
                                labels: const [],
                                showOptionsIcon: false,
                                onProjectDeleted: () {},
                                user: widget.user,
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
