import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable_example/post.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeDateFormatting("en");

  PostsRepository.generate(500);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        PagedDataTableLocalization.delegate
      ],
      supportedLocales: const [
        Locale("es"),
        Locale("en"),
        Locale("de"),
        Locale("it"),
        Locale("ru"),
        Locale("fr"),
      ],
      locale: const Locale("en"),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: kIsWeb ? GoogleFonts.robotoTextTheme() : null,
      ),
      home: const MainView(),
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final simple = const SimplePagedDataTable();
  final expansible = const ExpansiblePagedDataTable();

  bool isSimple = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 208, 208, 208),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextButton(
              child: Text("Switch to ${isSimple ? 'expansible' : 'simple'}"),
              onPressed: () {
                setState(() {
                  isSimple = !isSimple;
                });
              },
            ),
            Expanded(
              child: isSimple ? simple : expansible,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class SimplePagedDataTable extends StatefulWidget {
  const SimplePagedDataTable({super.key});

  @override
  State<SimplePagedDataTable> createState() => _SimplePagedDataTableState();
}

class _SimplePagedDataTableState extends State<SimplePagedDataTable> {
  final tableController = PagedDataTableController<String, Post>();
  @override
  Widget build(BuildContext context) {
    return PagedDataTableTheme(
      data: PagedDataTableThemeData(
        selectedRow: const Color(0xFFCE93D8),
        rowColor: (index) => index.isEven ? Colors.purple[50] : null,
      ),
      child: PagedDataTable<String, Post>(
        controller: tableController,
        initialPageSize: 100,
        configuration: const PagedDataTableConfiguration(),
        pageSizes: const [10, 20, 50, 100],
        fetcher: (pageSize, sortModel, filterModel, pageToken) async {
          final data = await PostsRepository.getPosts(
            pageSize: pageSize,
            pageToken: pageToken,
            sortBy: sortModel?.fieldName,
            sortDescending: sortModel?.descending ?? false,
            gender: filterModel["authorGender"],
            searchQuery: filterModel["content"],
          );
          return (data.items, data.nextPageToken);
        },
        filters: [
          TextTableFilter(
            id: "content",
            chipFormatter: (value) => 'Content has "$value"',
            name: "Content",
          ),
          DropdownTableFilter<Gender>(
            items: Gender.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(growable: false),
            chipFormatter: (value) => 'Author is ${value.name.toLowerCase()}',
            id: "authorGender",
            name: "Author's Gender",
          ),
          DateTimePickerTableFilter(
            id: "1",
            name: "Date picker",
            chipFormatter: (date) => "Date is $date",
            initialValue: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            lastDate: DateTime.now(),
            dateFormat: DateFormat.yMd(),
          ),
          DateRangePickerTableFilter(
            id: "2",
            name: "DateRange picker",
            chipFormatter: (date) => "Date is $date",
            initialValue: null,
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            lastDate: DateTime.now(),
            formatter: (range) => "${range.start} - ${range.end}",
          ),
        ],
        filterBarChild: PopupMenuButton(
          icon: const Icon(Icons.more_vert_outlined),
          itemBuilder: (context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: const Text("Print selected rows"),
              onTap: () {
                debugPrint(tableController.selectedRows.toString());
                debugPrint(tableController.selectedItems.toString());
              },
            ),
            PopupMenuItem(
              child: const Text("Select random row"),
              onTap: () {
                final index = Random().nextInt(tableController.totalItems);
                tableController.selectRow(index);
              },
            ),
            PopupMenuItem(
              child: const Text("Select all rows"),
              onTap: () {
                tableController.selectAllRows();
              },
            ),
            PopupMenuItem(
              child: const Text("Unselect all rows"),
              onTap: () {
                tableController.unselectAllRows();
              },
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              child: const Text("Remove first row"),
              onTap: () {
                tableController.removeRowAt(0);
              },
            ),
            PopupMenuItem(
              child: const Text("Remove last row"),
              onTap: () {
                tableController.removeRowAt(tableController.totalItems - 1);
              },
            ),
            PopupMenuItem(
              child: const Text("Remove random row"),
              onTap: () {
                final index = Random().nextInt(tableController.totalItems);
                tableController.removeRowAt(index);
              },
            ),
          ],
        ),
        fixedColumnCount: 2,
        columns: [
          RowSelectorColumn(),
          TableColumn(
            title: const Text("Id"),
            cellBuilder: (context, item, index) => Text(item.id.toString()),
            size: const FixedColumnSize(100),
          ),
          TableColumn(
            title: const Text("Author"),
            cellBuilder: (context, item, index) => Text(item.author),
            sortable: true,
            id: "author",
            size: const FractionalColumnSize(.15),
          ),
          DropdownTableColumn(
            title: const Text("Enabled"),
            // cellBuilder: (context, item, index) => Text(item.isEnabled ? "Yes" : "No"),
            items: const <DropdownMenuItem<bool>>[
              DropdownMenuItem(value: true, child: Text("Yes")),
              DropdownMenuItem(value: false, child: Text("No")),
            ],
            size: const FixedColumnSize(100),
            getter: (item, index) => item.isEnabled,
            setter: (item, newValue, index) async {
              await Future.delayed(const Duration(seconds: 2));
              item.isEnabled = newValue;
              return true;
            },
          ),
          TableColumn(
            title: const Text("Author Gender"),
            cellBuilder: (context, item, index) => Text(item.authorGender.name),
            sortable: true,
            id: "authorGender",
            size: const MaxColumnSize(FractionalColumnSize(.2), FixedColumnSize(100)),
          ),
          LargeTextTableColumn(
            title: const Text("Content"),
            size: const RemainingColumnSize(),
            getter: (item, index) => item.content,
            fieldLabel: "Content",
            setter: (item, newValue, index) async {
              await Future.delayed(const Duration(seconds: 2));
              item.content = newValue;
              return true;
            },
          ),
          TextTableColumn(
            title: const Text("Number"),
            format: const NumericColumnFormat(),
            // cellBuilder: (context, item, index) => Text(item.number.toString()),
            size: const MaxColumnSize(FixedColumnSize(100), FractionalColumnSize(.1)),
            getter: (item, index) => item.number.toString(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            setter: (item, newValue, index) async {
              await Future.delayed(const Duration(seconds: 2));
              item.number = int.parse(newValue);
              return true;
            },
          ),
        ],
      ),
    );
  }
}

class ExpansiblePagedDataTable extends StatefulWidget {
  const ExpansiblePagedDataTable({super.key});

  @override
  State<ExpansiblePagedDataTable> createState() => _ExpansiblePagedDataTableState();
}

class _ExpansiblePagedDataTableState extends State<ExpansiblePagedDataTable> {
  final tableController = PagedDataTableController<String, Post>();
  @override
  Widget build(BuildContext context) {
    return PagedDataTableTheme(
      data: PagedDataTableThemeData(
        selectedRow: const Color(0xFF6DC870),
        rowColor: (index) => index.isEven ? Colors.green[50] : null,
      ),
      child: PagedDataTable<String, Post>.expansible(
        controller: tableController,
        initialPageSize: 100,
        configuration: const PagedDataTableConfiguration(),
        pageSizes: const [10, 20, 50, 100],
        fetcher: (pageSize, sortModel, filterModel, pageToken) async {
          final data = await PostsRepository.getPosts(
            pageSize: pageSize,
            pageToken: pageToken,
            sortBy: sortModel?.fieldName,
            sortDescending: sortModel?.descending ?? false,
            gender: filterModel["authorGender"],
            searchQuery: filterModel["content"],
          );

          final resultset = <Post, List<Post>?>{};
          for (final post in data.items) {
            resultset[post] = PostsRepository.getRelatedPosts(post);
          }

          return (resultset, data.nextPageToken);
        },
        filters: [
          TextTableFilter(
            id: "content",
            chipFormatter: (value) => 'Content has "$value"',
            name: "Content",
          ),
          DropdownTableFilter<Gender>(
            items: Gender.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(growable: false),
            chipFormatter: (value) => 'Author is ${value.name.toLowerCase()}',
            id: "authorGender",
            name: "Author's Gender",
          ),
          DateTimePickerTableFilter(
            id: "1",
            name: "Date picker",
            chipFormatter: (date) => "Date is $date",
            initialValue: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            lastDate: DateTime.now(),
            dateFormat: DateFormat.yMd(),
          ),
          DateRangePickerTableFilter(
            id: "2",
            name: "DateRange picker",
            chipFormatter: (date) => "Date is $date",
            initialValue: null,
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            lastDate: DateTime.now(),
            formatter: (range) => "${range.start} - ${range.end}",
          ),
        ],
        filterBarChild: PopupMenuButton(
          icon: const Icon(Icons.more_vert_outlined),
          itemBuilder: (context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: const Text("Print selected rows"),
              onTap: () {
                debugPrint(tableController.selectedRows.toString());
                debugPrint(tableController.selectedItems.toString());
              },
            ),
            PopupMenuItem(
              child: const Text("Select random row"),
              onTap: () {
                final index = Random().nextInt(tableController.totalItems);
                tableController.selectRow(index);
              },
            ),
            PopupMenuItem(
              child: const Text("Select all rows"),
              onTap: () {
                tableController.selectAllRows();
              },
            ),
            PopupMenuItem(
              child: const Text("Unselect all rows"),
              onTap: () {
                tableController.unselectAllRows();
              },
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              child: const Text("Remove first row"),
              onTap: () {
                tableController.removeRowAt(0);
              },
            ),
            PopupMenuItem(
              child: const Text("Remove last row"),
              onTap: () {
                tableController.removeRowAt(tableController.totalItems - 1);
              },
            ),
            PopupMenuItem(
              child: const Text("Remove random row"),
              onTap: () {
                final index = Random().nextInt(tableController.totalItems);
                tableController.removeRowAt(index);
              },
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              child: const Text("Add collapsed row in first row"),
              onTap: () {
                tableController.insertCollapsed(
                  3,
                  Post(
                      id: 123456789,
                      author: "Me",
                      content: "This is the content",
                      createdAt: DateTime.now(),
                      isEnabled: true,
                      number: 9999,
                      authorGender: Gender.male),
                );
              },
            ),
            PopupMenuItem(
              child: const Text("Remove the first collapsed row"),
              onTap: () {
                tableController.removeCollapsedAt(tableController.expansibleRows.first, 0);
              },
            ),
          ],
        ),
        fixedColumnCount: 2,
        columns: [
          RowSelectorColumn(),
          CollapsibleRowColumn(),
          TableColumn(
            title: const Text("Id"),
            cellBuilder: (context, item, index) => Text(item.id.toString()),
            size: const FixedColumnSize(100),
          ),
          TableColumn(
            title: const Text("Author"),
            cellBuilder: (context, item, index) => Text(item.author),
            sortable: true,
            id: "author",
            size: const FractionalColumnSize(.15),
          ),
          DropdownTableColumn(
            title: const Text("Enabled"),
            // cellBuilder: (context, item, index) => Text(item.isEnabled ? "Yes" : "No"),
            items: const <DropdownMenuItem<bool>>[
              DropdownMenuItem(value: true, child: Text("Yes")),
              DropdownMenuItem(value: false, child: Text("No")),
            ],
            size: const FixedColumnSize(100),
            getter: (item, index) => item.isEnabled,
            setter: (item, newValue, index) async {
              debugPrint("Item: [${item.id}] NewValue: [$newValue] Index: [$index]");

              await Future.delayed(const Duration(seconds: 2));
              item.isEnabled = newValue;
              return true;
            },
          ),
          TableColumn(
            title: const Text("Author Gender"),
            cellBuilder: (context, item, index) => Text(item.authorGender.name),
            sortable: true,
            id: "authorGender",
            size: const MaxColumnSize(FractionalColumnSize(.2), FixedColumnSize(100)),
          ),
          LargeTextTableColumn(
            title: const Text("Content"),
            size: const RemainingColumnSize(),
            getter: (item, index) => item.content,
            fieldLabel: "Content",
            setter: (item, newValue, index) async {
              await Future.delayed(const Duration(seconds: 2));
              item.content = newValue;
              return true;
            },
          ),
          TextTableColumn(
            title: const Text("Number"),
            format: const NumericColumnFormat(),
            // cellBuilder: (context, item, index) => Text(item.number.toString()),
            size: const MaxColumnSize(FixedColumnSize(100), FractionalColumnSize(.1)),
            getter: (item, index) => item.number.toString(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            setter: (item, newValue, index) async {
              await Future.delayed(const Duration(seconds: 2));
              item.number = int.parse(newValue);
              return true;
            },
          ),
        ],
      ),
    );
  }
}
