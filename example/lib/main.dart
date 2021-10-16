
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable_example/post.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("en");

  PostsRepository.generate(100);

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
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Builder(
            builder: (context) {
              return PagedDataTableConfiguration(
                data: PagedDataTableConfigurationData(
                  enableTransitions: true,
                  theme: PagedDataTableTheme(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    headerTheme: PagedDataTableHeaderTheme(
                      backgroundColor: Colors.deepPurple.withOpacity(.6),
                      columnNameColor: Colors.white
                    ),
                    footerTheme: PagedDataTableFooterTheme(
                      backgroundColor: Colors.deepPurple.withOpacity(.6),
                      textColor: Colors.white,
                      paginationButtonsColor: Colors.red,
                    ),
                    rowColors: [
                      Colors.deepPurple.withOpacity(.05),
                      Colors.deepPurple.withOpacity(.1)
                    ],
                    editableColumnTheme: EditableColumnTheme(
                      cancelButtonStyle: TextButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        primary: Colors.deepOrange
                      ),
                      saveButtonStyle: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                      )
                    )
                  )
                ),
                child: PagedDataTable<Post>(
                  onRowTap: PagedTableRowTapped.multiple([
                    const PagedTableRowTapped.selectRow(),
                    PagedTableRowTapped.function((item) { 
                      debugPrint("Row ${item.id} tapped.");
                    })
                  ]),
                  pageSizes: const [10, 20, 50],
                  defaultPageSize: 10,
                  itemIdEvaluator: (item) => item.id,
                  initialPageToken: "initial",
                  resolvePage: (pageToken, pageSize, filters) async {
                    var result = await PostsRepository.getPosts(
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
                    EditableTableColumn(
                      title: "Content",
                      flex: 4,
                      multiline: true,
                      onChange: (value, newValue) async {
                        await Future.delayed(const Duration(seconds: 5));
                        value.content = newValue;
                      },
                      validator: (text) {
                        if(text == null || text.isEmpty) {
                          return "This field is required.";
                        }

                        return null;
                      },
                      valueFormatter: (item) => item.content
                    ),
                    TableColumn(
                      title: "Created at",
                      rowFormatter: (context, item) => Text(DateFormat.yMMMd().format(item.createdAt))
                    ),
                    CheckboxTableColumn(
                      title: "Enabled",
                      forField: (post) => post.isEnabled,
                      onChange: (item, newValue) async {
                        await Future.delayed(const Duration(seconds: 1));
                        item.isEnabled = newValue;
                      }
                      // rowFormatter: (context, item) => Checkbox(value: item.isEnabled, onChanged: null)
                    ),
                    EditableTableColumn(
                      title: "Random number",
                      alignment: Alignment.centerRight,
                      valueFormatter: (value) => value.number.toString(),
                      multiline: false,
                      onChange: (value, newValue) async {
                        await Future.delayed(const Duration(seconds: 2));
                        value.number = int.parse(newValue);
                      },
                      validator: (text) {
                        if(text == null || text.isEmpty) {
                          return "This field is required.";
                        }

                        return null;
                      },
                      textFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ]
                    ),
                    TableColumn(
                      alignment: Alignment.centerRight,
                      title: "Actions",
                      rowFormatter: (context, item) => Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}