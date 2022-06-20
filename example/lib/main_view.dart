import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable_example/post.dart';

class MainView extends StatefulWidget {
  const MainView({ Key? key }) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  final controller = PagedDataTableController<Post>();

  final PagedDataTableConfigurationData _dataTableConfiguration = PagedDataTableConfigurationData(
    // internalization: const PagedDataTableInternalization(
    //   showFilterMenuTooltipText: "Afficher les filtres", 
    //   filterByTitle: "Filtrer par", 
    //   applyFilterButtonText: "Appliquer des filtres", 
    //   cancelFilteringButtonText: "Annuler", 
    //   removeAllFiltersButtonText: "Effacer", 
    //   removeFilterButtonText: "Supprimer ce filtre", 
    //   refreshButtonText: "Mettre à jour", 
    //   rowsPerPageText: "Lignes par page", 
    //   pageIndicatorText: "Page {currentPage}", 
    //   nextPageButtonText: "Page suivante.", 
    //   previousPageButtonText: "Page précédente."
    // ),
    enableTransitions: true,
    theme: PagedDataTableTheme(
      elevation: 0,
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
  );

  bool _themeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Builder(
          builder: (context) {
            return PagedDataTable<Post>(
              optionsMenu: PagedDataTableOptionsMenu(
                clipBehavior: Clip.hardEdge,
                items: [
                  OptionsMenuItem(
                    title: const Text("Refresh using controller"),
                    onTap: () {
                      controller.refresh(clearCache: false);
                    },
                  ),
                  OptionsMenuItem(
                    title: const Text("Print selected rows"),
                    onTap: () {
                      var rows = controller.getSelectedRows();
                      debugPrint(rows.map((e) => e.author).toString());
                    },
                  ),
                  OptionsMenuItem(
                    title: const Text("Set a filter value"),
                    onTap: () {
                      controller.setFilterValue("isEnabled", true);
                    },
                  ),
                  OptionsMenuItem(
                    title: const Text("Create and set a filter value"),
                    onTap: () {
                      controller.setFilterValue("randomNumber", 60);
                    },
                  ),
                  OptionsMenuItem(
                    title: const Text("Remove all filters"),
                    onTap: () {
                      controller.clearFilters();
                    },
                  ),
                ],
                iconColor: Colors.white,
              ),
              controller: controller,
              configuration: _themeEnabled ? _dataTableConfiguration : PagedDataTableConfigurationData(
                theme: PagedDataTableTheme(
                  rowColors: [Theme.of(context).canvasColor],
                  shape: const RoundedRectangleBorder(),
                  headerTheme: PagedDataTableHeaderTheme(
                    backgroundColor: Theme.of(context).canvasColor,
                    columnNameColor: Colors.black
                  ),
                  footerTheme: PagedDataTableFooterTheme(
                    backgroundColor: Theme.of(context).canvasColor,
                    textColor: Colors.black,
                    paginationButtonsColor: Colors.red,
                  ),
                )
              ),
              header: TextButton(
                child: const Text("Switch theme"),
                style: _themeEnabled ? TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.onPrimary
                ) : null,
                onPressed: () {
                  setState(() {
                    _themeEnabled = !_themeEnabled;
                  });
                },
              ),
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
              footer: TextButton(
                child: const Text("Enviar a cola de impresión"),
                onPressed: () {
                  
                },
              ),
              resolvePage: (pageToken, pageSize, filters) async {
                debugPrint("Fetching page. Active filters: $filters");

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
                PagedDataTableTextFilter(
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
                DropdownTableColumn<Post, Gender>(
                  title: "Author Gender",
                  flex: 1,
                  items: Gender.values,
                  valueFormatter: (item) => formatGender(item),
                  forField: (post) => post.authorGender,
                  onChange: (post, newGender) async {
                    await Future.delayed(const Duration(seconds: 2));
                    post.authorGender = newGender;
                  }
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
                      Flexible(
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          splashRadius: 20,
                          onPressed: () {},
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          splashRadius: 20,
                          onPressed: () {},
                        ),
                      )
                    ],
                  )
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}