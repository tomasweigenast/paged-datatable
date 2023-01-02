import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable_example/post.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: PagedDataTable<String, Post>(
        fetchPage: (pageToken, pageSize, sortBy, filtering) async {
          var result = await PostsRepository.getPosts(
            pageSize: pageSize, 
            pageToken: pageToken,
            sortBy: sortBy?.columnId,
            sortDescending: sortBy?.descending ?? false,
            gender: filtering.valueOrNullAs<Gender>("gender"),
            authorName: filtering.valueOrNullAs<String>("authorName"),
            between: filtering.valueOrNullAs<DateTimeRange>("betweenDate")
          );
          return PaginationResult.items(elements: result.items, nextPageToken: result.nextPageToken);
        },
        initialPage: "",
        columns: [
          TableColumn(
            title: "Identificator", 
            cellBuilder: (item) => Text(item.id.toString()),
            sizeFactor: .05
          ),
          TableColumn(
            title: "Author", 
            cellBuilder: (item) => Text(item.author)
          ),
          LargeTextTableColumn(
            title: "Content",
            getter: (post) => post.content,
            setter: (post, newContent) async {
              await Future.delayed(const Duration(seconds: 1));
              post.content = newContent;
              return true;
            }, 
            sizeFactor: .3
          ),
          TableColumn(
            id: "createdAt",
            title: "Created At", 
            sortable: true,
            cellBuilder: (item) => Text(DateFormat.yMd().format(item.createdAt))
          ),
          DropdownTableColumn<Post, Gender>(
            title: "Gender", 
            getter: (post) => post.authorGender,
            setter: (post, newGender) async {
              post.authorGender = newGender;
              await Future.delayed(const Duration(seconds: 1));
              return true;
            },
            items: const [
              DropdownMenuItem(value: Gender.male, child: Text("Male")),
              DropdownMenuItem(value: Gender.female, child: Text("Female")),
              DropdownMenuItem(value: Gender.unespecified, child: Text("Unspecified")),
            ],
          ),
          TableColumn(
            title: "Enabled", 
            cellBuilder: (item) => Text(item.isEnabled ? "Yes" : "No")
          ),
          TextTableColumn(
            title: "Number", 
            id: "number",
            sortable: true,
            sizeFactor: .05,
            isNumeric: true,
            getter: (post) => post.number.toString(),
            setter: (post, newValue) async {
              await Future.delayed(const Duration(seconds: 1));

              int? number = int.tryParse(newValue);
              if(number == null) {
                return false;
              }

              post.number = number;
              return true;
            }
          ),
          TableColumn(
            title: "Fixed Value", 
            cellBuilder: (item) => const Text("abc")
          ),
        ],
        filters: [
          TextTableFilter(
            id: "authorName",
            title: "Author's name",
            chipFormatter: (text) => "By $text"
          ),
          DropdownTableFilter<Gender>(
            id: "gender",
            title: "Gender",
            chipFormatter: (gender) => 'Only ${gender.name.toLowerCase()} posts',
            items: const [
              DropdownMenuItem(value: Gender.male, child: Text("Male")),
              DropdownMenuItem(value: Gender.female, child: Text("Female")),
              DropdownMenuItem(value: Gender.unespecified, child: Text("Unspecified")),
            ]
          ),
          DatePickerTableFilter(
            id: "date",
            title: "Date",
            chipFormatter: (date) => 'Only on ${DateFormat.yMd().format(date)}',
            firstDate: DateTime(2000, 1, 1),
            lastDate: DateTime.now(),
          ),
          DateRangePickerTableFilter(
            id: "betweenDate",
            title: "Between",
            chipFormatter: (date) => 'Between ${DateFormat.yMd().format(date.start)} and ${DateFormat.yMd().format(date.end)}',
            firstDate: DateTime(2000, 1, 1),
            lastDate: DateTime.now(),
          )
        ],
        footer: TextButton(
          onPressed: () {},
          child: const Text("Im a footer button"),
        ),
        menu: PagedDataTableFilterBarMenu(
          items: [
            ListTile(
              title: const Text("Remove filters"),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Add filter"),
              onTap: () {}
            ),
            const Divider(height: 0),
            ListTile(
              title: const Text("Refresh cache"),
              onTap: () {},
            ),
          ]
        ),
      ),
    );
  }
}