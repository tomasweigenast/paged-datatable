import 'dart:collection';

import 'package:darq/darq.dart';
import 'package:faker/faker.dart';

class Post {
  final int id;
  String author;
  String content;
  DateTime createdAt;
  bool isEnabled;
  int number;
  Gender authorGender;

  Post({required this.id, required this.author, required this.content, required this.createdAt, required this.isEnabled, required this.number, required this.authorGender});

  static final Faker _faker = Faker();
  factory Post.random({required int id}) {
    return Post(
      id: id,
      author: _faker.person.name(),
      content: _faker.lorem.sentences(10).join(". "),
      createdAt: _faker.date.dateTime(minYear: 2019, maxYear: 2021),
      isEnabled: _faker.randomGenerator.boolean(),
      number: faker.randomGenerator.integer(9999),
      authorGender: Gender.values[_faker.randomGenerator.integer(3)]
    );  
  }
}

enum Gender {
  male, female, unespecified
}

String formatGender(Gender gender) {
  switch(gender) {
    case Gender.male: return "Male";
    case Gender.female: return "Female";
    case Gender.unespecified: return "Unspecified";
  }
}

class PostsRepository {
  PostsRepository._();

  static final List<Post> _backend = [];

  static void generate(int count) {
    _backend.clear();
    _backend.addAll(List.generate(count, (index) => Post.random(id: index)));
  }

  static Future<PaginatedList<Post>> getPosts({required int pageSize, required String? pageToken, bool? status, String? searchQuery}) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Decode page token
    int nextId = pageToken == null ? 0 : int.tryParse(pageToken) ?? 1;

    var query = _backend.orderBy((element) => element.id).where((element) => element.id >= nextId);
    if(status != null) {
      query = query.where((element) => element.isEnabled == status);
    }

    if(searchQuery != null) {
      searchQuery = searchQuery.toLowerCase();
      query = query.where((element) => element.author.toLowerCase().startsWith(searchQuery!) || element.content.toLowerCase().contains(searchQuery));
    }

    var resultSet = query.take(pageSize+1).toList();
    String? nextPageToken;
    if(resultSet.length == pageSize+1) {
      Post lastPost = resultSet.removeLast();
      nextPageToken = lastPost.id.toString();
    }

    return PaginatedList(
      items: resultSet,
      nextPageToken: nextPageToken
    );
  }
}

class PaginatedList<T> {
  final Iterable<T> _items;
  final String? _nextPageToken;

  List<T> get items => UnmodifiableListView(_items);
  String? get nextPageToken => _nextPageToken;

  PaginatedList({required Iterable<T> items, String? nextPageToken}) : _items = items, _nextPageToken = nextPageToken;
}