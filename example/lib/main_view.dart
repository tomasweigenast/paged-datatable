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
        fetchPage: (pageToken, pageSize) async {
          var result = await PostsRepository.getPosts(pageSize: pageSize, pageToken: pageToken);
          return PaginationResult.items(elements: result.items, nextPageToken: result.nextPageToken);
        },
        initialPage: "",
        columns: [
          TableColumn(
            title: "Identificator", 
            itemBuilder: (item) => Text(item.id.toString()),
            sizeFactor: .01
          ),
          TableColumn(
            title: "Author", 
            itemBuilder: (item) => Text(item.author)
          ),
          TableColumn(
            title: "Content", 
            itemBuilder: (item) => Text(item.content),
            sizeFactor: .3
          ),
          TableColumn(
            title: "Created At", 
            itemBuilder: (item) => Text(DateFormat.yMd().format(item.createdAt))
          ),
          TableColumn(
            title: "Gender", 
            itemBuilder: (item) => Text(item.authorGender.name)
          ),
          TableColumn(
            title: "Enabled", 
            itemBuilder: (item) => Text(item.isEnabled ? "Yes" : "No")
          ),
          TableColumn(
            title: "Number", 
            isNumeric: true,
            itemBuilder: (item) => Text(NumberFormat.currency(symbol: r"$ ", locale: "en").format(item.number))
          ),
          TableColumn(
            title: "Fixed", 
            itemBuilder: (item) => const Text("abc")
          ),
        ],
      ),
    );
  }
}