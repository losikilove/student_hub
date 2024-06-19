# Student Hub
- An application permits managing students, teachers, projects, ...
- Version: sdk: '>=3.3.0 <4.0.0'
# api - 19/6
docs: https://e4c3-42-118-185-153.ngrok-free.app/api-docs
api: https://e4c3-42-118-185-153.ngrok-free.app/

# Demo videos
## Phasing 1
Demo video: https://www.youtube.com/watch?v=D1ZxhoNYnho

## Phasing 2
Demo video: https://www.youtube.com/watch?v=9XNt86N6dX0

## Phasing 3
Demo video: https://www.youtube.com/watch?v=fX3ChP_nZmg

## Phasing 4
Demo video: https://www.youtube.com/watch?v=8UNtMWyJc0M

# Issues
## 1. RenderCustomMultiChildLayoutBox object was given an infinite size during layout.
- Reasons: it is a render object that tries to be as big as possible, but it was put inside another render object that allows its children to pick their own size
- Solutions: wrap that widget on a SizedBox widget and then, limit it with size of SizedBox widget

## 2. RenderFlex
- Reasons: overflow widgets
- Solutions: wrap them on a SingleChildScrollView widget and then, continue to wrap all of them on Expanded widget

## 3. Render setState more times
- Reasons: a function attribute is called in setState
- Solutions: get that function out of the setState

## 4. Cannot expand the with of DropdownMenu widget which fits the defined screen
- Reasons: that widget just provides the width attribute which makes dev defining its width
- Solutions: wrap that widget in a LayoutBuilder widget, then set its width to constraints.maxWidth which is the maximum width of Container widget

## 5. Wrapper expansionTile
- Reasons: Remove line wrapper expansionTile
- Solution: add it into theme{} and using dividerColor: Colors.transparent
- Example:
- Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),child: ExpansionTile())

## 6. The instance member 'X' can't be accessed in an initializer
- Reasons:
- Solutions: replace 'late final' on 'final' in List<> ...

## 7. Individual setState for a subwidget which is wrapped in a widget
- Reasons: cannot show changeable states on subwidget
- Solutions: wrap that subwiget on a StatefulBuilder widget, then handle its states into that widget
## 8. Use Dash chat 2
- Enable multidex.
Open project/app/build.gradle and add the following lines.
```
defaultConfig {
    ...

    multiDexEnabled true
}
```
```
dependencies {
    ...

    implementation 'com.android.support:multidex:1.0.3'
}
```

## 9. Cannot use async to get API in initState
- Reasons: wrong syntax of initState
- Solutions: use the FutureBuild widget to get API and show it up
## 10. How to Move bottomsheet along with keyboard which has textfield(autofocused is true)?
- Reason: Autofocus is set to true so that the keyboard pops up
- Solution: use padding MediaQuery.of(context).viewInsets.bottom, isScrollControlled = true
- Example:
```
showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
        padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Enter somethings this textfield',
                    style: TextStyles.textBody2),
                ),
                SizedBox(
                height: 8.0,
                ),
                TextField(
                    decoration: InputDecoration(
                    hintText: 'adddrss'
                    ),
                    autofocus: true,
                ),                 
            ],
            ),
    ));
```