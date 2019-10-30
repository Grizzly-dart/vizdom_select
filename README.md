# Select

Incremental DOM library to build beautiful graphs and plots.

# Usage

## Selecting

```dart
void main() {
  select('#root')
    ..select('.header', doo: (header) {
      final title = header.select('.title');
      DivElement node = title.element;
      node.text = "Vizdom";
      final subTitle = header.select('.sub-title');
      node = subTitle.element;
      node.text = "how-to";
    })
    ..select('.content', doo: (content) {
      final description = content.select('.description');
      DivElement node = description.element;
      node.text = "Use select to select elements.";
      final moreDescription = content.select('.more-description');
      node = moreDescription.element;
      node.text = "Use bind to bind data to elements.";
    });
}
```

## Binding data

```dart
// TODO
```