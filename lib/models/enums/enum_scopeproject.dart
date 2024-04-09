enum EnumScopeProject {
  working(value: 0),
  archive(value: 1);

  final int value;

  const EnumScopeProject({required this.value});

  static EnumScopeProject toRole(int id) {
    if (id == EnumScopeProject.working.value) {
      return EnumScopeProject.working;
    }

    if (id == EnumScopeProject.archive.value) {
      return EnumScopeProject.archive;
    }

    return EnumScopeProject.working;
  }
}