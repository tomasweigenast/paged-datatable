# PagedDataTable

[![pub package](https://img.shields.io/pub/v/paged_datatable?label=pub.dev&labelColor=333940&logo=dart)](https://pub.dev/packages/paged_datatable)

**PagedDataTable** is a fully customizable and powerful data table widget for Flutter, supporting both **cursor-based** and **offset-based pagination**. It’s built entirely from scratch, without dependencies on Flutter’s native `DataTable` or `Table`. It follows Google’s **Material You** design principles. Whether you're building dashboards, admin panels, or any app with complex tabular data, this library makes it easy to display, sort, and filter your data.

## Online Demo  
Explore a live demo of the table in action:  
<a href="https://tomasweigenast.github.io/pageddatatable/#/.com" target="_blank">Check it out here</a>  

## Why Use PagedDataTable?  

The library offers:  

- **Horizontal scrolling**: Handle columns wider than the screen by scrolling.  
- **Expandable rows**: Toggle row details on demand.  
- **Fixed columns**: Lock specific columns during horizontal scrolling.  
- **In-place row updates**: Edit objects directly within the table without needing separate views.  
- **Cursor and offset pagination**: Choose the pagination style that fits your use case.  
- **Dynamic filtering and sorting**: Filter by text, date, numbers, and more.  
- **Controller-based modifications**: Add or remove rows without reloading the entire table.  
- **Custom themes**: Easily change fonts, colors, and other styles to match your app's theme.  

## Table of Contents  
- [PagedDataTable](#pageddatatable)
  - [Online Demo](#online-demo)
  - [Why Use PagedDataTable?](#why-use-pageddatatable)
  - [Table of Contents](#table-of-contents)
  - [Quick Start](#quick-start)
  - [Setup](#setup)
    - [Fetcher](#fetcher)
    - [Header](#header)
    - [Footer](#footer)
      - [Custom Footer Example](#custom-footer-example)
    - [Columns](#columns)
      - [TableColumn\<K, T\>](#tablecolumnk-t)
      - [EditableTableColumn\<K, T, V\>](#editabletablecolumnk-t-v)
      - [Creating Custom Columns](#creating-custom-columns)
  - [Filters](#filters)
      - [Creating Custom Filters](#creating-custom-filters)
  - [Controller](#controller)
  - [Internationalization](#internationalization)
    - [Supported Locales](#supported-locales)
  - [Contribute](#contribute)

---

## Quick Start

```dart
PagedDataTable<int, User>(
  fetcher: (pageSize, sortModel, filterModel, pageToken) async {
    final result = await UserService.getUsers(
      filterByName: filterModel["name"],
      sortBy: sortModel.fieldName,
      sortByDirection: sortModel.descending ? 'desc' : 'asc',
      pageToken: pageToken, 
      pageSize: pageSize,
    );
    return (result.data, result.nextPageToken);
  },
  columns: [
    TableColumn(
      title: const Text("Name"),
      cellBuilder: (context, user, _) => Text(user.name),
    ),
    EditableTableColumn(
      title: const Text("Age"),
      getter: (user) => user.age.toString(),
      setter: (user, value) {
        user.age = int.tryParse(value) ?? user.age;
        return true;
      },
    ),
  ],
  filters: [
    TextTableFilter(id: "name", name: "Name"),
  ],
);
```

This minimal setup gives you a functional data table with pagination, filtering, and editable rows. Adjust the `fetcher` to fit your data source and watch the table handle your data seamlessly.

## Setup  

To get started, create a **PagedDataTable<K, T>** widget, where:  
- **K** is the key type used for pagination.  
- **T** is the type of data you want to display in the table.  

```dart
PagedDataTable<String, Post>(
  fetcher: (int pageSize, SortModel? sortModel, FilterModel filterModel, String? pageToken) => ...,
  columns: [...],
)
```  
**Important:** `K` must extend `Comparable`.

### Fetcher  

The `fetcher` function loads new pages when needed. It must return a `FutureOr<(List<T>, K?)>`, where the first value is the list of items and the second value is the token for the next page (if available).  

```dart
PagedDataTable<String, Post>(
  fetcher: (int pageSize, SortModel? sortModel, FilterModel filterModel, String? pageToken) async {
    final result = await FetchService.listPosts();
    return (result.data, result.nextPageToken);
  },
  columns: [...],
)
```  
> By default, the table **does not cache** pages.

### Header  

The header contains both **column names** and a **filter bar**. You can customize it by passing a widget to the `filterBarChild` property (e.g., a `PopupMenuButton`).  

### Footer  

The `footer` property allows you to fully customize the footer. If not provided, a `DefaultFooter` will be rendered with the following widgets:  

- **`RefreshTable`**: Reloads the current dataset.  
- **`PageSizeSelector`**: Adjusts the number of items per page.  
- **`CurrentPage`**: Shows the current page number.  
- **`NavigationButtons`**: Go to the next or previous page.  

#### Custom Footer Example  

Use built-in widgets like `RefreshTable` and `NavigationButtons` to build your own footer:  

```dart
PagedDataTable<String, Post>(
  fetcher: ...,
  columns: ...,
  footer: Row(
    children: [
      RefreshButton(),
      CurrentPage(),
      NavigationButtons(),
    ],
  ),
)
```  

### Columns  

PagedDataTable offers two main column types:  

- **ReadOnlyTableColumn<K, T>**: Displays data without allowing edits.  
- **EditableTableColumn<K, T, V>**: Allows in-place editing of cell content.  

```dart
PagedDataTable<String, Post>(
  columns: [
    TableColumn(
      title: const Text("Author"),
      cellBuilder: (context, item, index) => Text(item.author),
    ),
    EditableTableColumn(
      title: const Text("Post Title"),
      getter: (item) => item.title,
      setter: (item, newValue) {
        item.title = newValue;
        return true;
      },
    ),
  ],
)
```  

> `K` and `T` are the same parameters defined in the `PagedDataTable` widget.

Every column has:

- **title**: the column's title. A widget used to display column's name (e.g. `Text`).
- **size**: configures the column's size. By default, it is a `FractionalColumnSize(.1)`, which means it will take 10% of the available width. You can use `FixedColumnSize`, `FractionalColumnSize`, `RemainingColumnSize` and `MaxColumnSize`.
- **format**: applies a transformation to the cell's widget. You have `NumericColumnFormat`, which aligns content to the right and `AlignColumnFormat` which aligns cell's content to the `alignment` property. You can create your own implemeting the `ColumnFormat` interface.
- **sort** and **id**: both properties are used to indicate that a column can be used for sorting. The `id` is what you get in the Fetcher's `SortModel`.
- There are other properties that you can use to play around and modify your columns. Check out the `ReadOnlyTableColumn`'s documentation.

> If you want to fix columns at the left, you can specify the amount of columns to fix using the `fixedColumnCount` property.

#### TableColumn<K, T>

Is the default `ReadOnlyTableColumn` that renders a cell using the `cellBuilder` property.

```dart
PagedDataTable<String, Post>(
  columns: [
    TableColumn(
      title: const Text("Author"),
      cellBuilder: (context, item, index) => Text(item.author),
    ),
  ],
)
```

#### EditableTableColumn<K, T, V>

This abstract class introduces two key properties:

- `getter`: Retrieves the value `V` to be displayed in the cell.
- `setter`: A function that sets a new value. It must return a boolean indicating if the operation was successful. If true, the cell updates with the new value; otherwise, it retains the original one.

There are three built-in editable columns:

- `DropdownTableColumn`: Renders a dropdown menu for selecting values.
- `TextTableColumn`: Initially displays a `Text` widget. Upon double-click, it switches to a `TextField` for in-place editing.
- `LargeTextTableColumn`: Works like `TextTableColumn` but opens an overlay on double-click, providing a more spacious interface for editing large text content.

#### Creating Custom Columns  

Extend `ReadOnlyTableColumn` or `EditableTableColumn` to define your own column types:  

```dart
class MyCustomColumn<K, T> extends ReadOnlyTableColumn<K, T> {
  @override
  Widget build(BuildContext context, T item, int index) {
    return MyCustomCellWidget(item);
  }
}
```  

## Filters  

PagedDataTable supports multiple filter types, such as text fields, dropdowns, and date pickers. Use the `filters` property to define them:  

```dart
PagedDataTable<String, Post>(
  filters: [
    TextTableFilter(id: "content", name: "Content", chipFormatter: (value) => 'Contains "$value"'),
    DropdownTableFilter<Gender>(
      id: "authorGender",
      name: "Author's Gender",
      chipFormatter: (value) => 'Gender: ${value.name}',
      items: Gender.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
    ),
  ],
)
```  

The library offers five built-in filter types:

- `TextTableFilter`: Displays a TextField for filtering based on raw text input.
- `DropdownTableFilter`: Shows a DropdownButton with predefined options for selection.
- `DateTimePickerTableFilter`: Provides a TextField that opens a DateTime picker dialog when tapped.
- `DateRangePickerTableFilter`: Similar to DateTimePickerTableFilter but allows selecting a DateTimeRange.
- `ProgrammingTextFilter`: This filter doesn't render anything in the filter dialog but can be configured programmatically using the controller.

Each filter must define the following core properties:

- `id`: A unique identifier for the filter, referenced by the fetcher's FilterMode.
- `name`: The label displayed in the filter picker.
- `chipFormatter`: A function that converts the selected value into a user-friendly string, shown in the filter’s chip.

#### Creating Custom Filters  

To create a custom filter, extend `TableFilter<T>` and implement `buildPicker`:  

```dart
class CustomTextFilter extends TableFilter<String> {
  @override
  Widget buildPicker(BuildContext context, FilterState<String> state) {
    return TextFormField(
      initialValue: state.value,
      onSaved: (newValue) => state.value = newValue,
    );
  }
}
```  


## Controller  

Use the `PagedDataTableController<K, V>` to programmatically manage rows, filters, sorting, and pagination.  

```dart
final controller = PagedDataTableController<String, Post>();
controller.addRow(Post(...));
controller.nextPage();
```  

## Internationalization  

Add the following line `PagedDataTableLocalization.delegate` to your `MaterialApp` or `CupertinoApp` to enable localization:  

```dart
localizationsDelegates: [
  GlobalMaterialLocalizations.delegate,
  PagedDataTableLocalization.delegate
  GlobalCupertinoLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
]
```  

### Supported Locales  
- **es**: Spanish
- **en**: English
- **de**: German
- **nl**: Dutch
- **tr**: Turkish
- **fr**: French
- **it**: Italian
- **zh**: Chinese
- **ru**: Russian
- **th**: Thai


## Contribute  

All contributions are welcome! Feel free to open an issue or submit a pull request with your improvements.  
