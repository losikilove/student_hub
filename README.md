# Student Hub
- An application permits managing students, teachers, projects, ...

# Issues
## 1. RenderCustomMultiChildLayoutBox object was given an infinite size during layout.
- Reasons: it is a render object that tries to be as big as possible, but it was put inside another render object that allows its children to pick their own size
- Solutions: wrap that widget on a SizedBox widget and then, limit it with size of SizedBox widget