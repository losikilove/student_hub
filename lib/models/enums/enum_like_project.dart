enum EnumLikeProject {
  like(value: 0),
  dislike(value: 1);

  final int value;

  const EnumLikeProject({required this.value});

  static EnumLikeProject toLike(int id) {
    if (id == EnumLikeProject.like.value) {
      return EnumLikeProject.like;
    }

    if (id == EnumLikeProject.dislike.value) {
      return EnumLikeProject.dislike;
    }

    return EnumLikeProject.dislike;
  }
}
