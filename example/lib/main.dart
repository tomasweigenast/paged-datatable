import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable_example/post.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("en");

  PostsProvider.generate(100);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Builder(
            builder: (context) {
              return PagedDataTable<Post>(
                theme: const PagedDataTableTheme(
                ),
                onRowTap: PagedTableRowTapped.multiple([
                  const PagedTableRowTapped.selectRow(),
                  PagedTableRowTapped.function((item) { 
                    debugPrint("Row ${item.id} tapped.");
                  })
                ]),
                pageSizes: const [10, 20, 50],
                defaultPageSize: 10,
                initialPageToken: "initial",
                resolvePage: (pageToken, pageSize, filters) async {
                  var result = await PostsProvider.getPosts(
                    pageSize: pageSize, 
                    pageToken: pageToken,
                    status: filters.filterAsOrNull("isEnabled"),
                    searchQuery: filters.filterAsOrNull("searchQuery")
                  );

                  return PageIndicator.items(
                    items: result.items,
                    nextPageToken: result.nextPageToken
                  );
                },
                onRowSelected: (post, selected) {
                  if(selected) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 1),
                      content: Text("${post.author}'s post selected"),
                      behavior: SnackBarBehavior.floating,
                      width: 400,
                    ));
                  }
                },
                filters: [
                  PagedDataTableTextFieldFilter(
                    filterId: "searchQuery",
                    text: "Search by author and content",
                    chipFormatter: (value) => "Searching for '$value'"
                  ),
                  PagedDataTableDropdownFilter<bool>(
                    filterId: "isEnabled",
                    text: "Post's status",
                    chipFormatter: (bool value) => "Only ${value ? 'enabled' : 'disabled'} posts",
                    items: [
                      const DropdownMenuItem(child: Text("Enabled"), value: true),
                      const DropdownMenuItem(child: Text("Disabled"), value: false),
                    ]
                  )
                ],
                columns: [
                  TableColumn(
                    title: "Id",
                    rowFormatter: (context, item) => Text(item.id.toString())
                  ),
                  TableColumn(
                    title: "Author",
                    flex: 2,
                    rowFormatter: (context, item) => Text(item.author)
                  ),
                  TableColumn(
                    title: "Content",
                    flex: 4,
                    rowFormatter: (context, item) => Tooltip(
                      message: item.content,
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(8),
                      child: Text(item.content, overflow: TextOverflow.ellipsis),
                    )
                  ),
                  TableColumn(
                    title: "Created at",
                    rowFormatter: (context, item) => Text(DateFormat.yMMMd().format(item.createdAt))
                  ),
                  CheckboxTableColumn(
                    title: "Enabled",
                    forField: (post) => post.isEnabled,
                    onChange: (newValue) {
                      return Future.delayed(const Duration(seconds: 1));
                    }
                    // rowFormatter: (context, item) => Checkbox(value: item.isEnabled, onChanged: null)
                  ),
                  TableColumn(
                    // alignment: Alignment.centerRight,
                    title: "Actions",
                    rowFormatter: (context, item) => Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          splashRadius: 20,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          splashRadius: 20,
                          onPressed: () {},
                        )
                      ],
                    )
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}