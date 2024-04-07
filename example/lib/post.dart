import 'dart:collection';

import 'package:darq/darq.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class Post {
  final int id;
  String author;
  String content;
  DateTime createdAt;
  bool isEnabled;
  int number;
  Gender authorGender;

  Post({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
    required this.isEnabled,
    required this.number,
    required this.authorGender,
  });

  static final Faker _faker = Faker();
  factory Post.random({required int id}) {
    return Post(
        id: id,
        author: _faker.person.name(),
        content: _faker.lorem.sentences(10).join(". "),
        createdAt: _faker.date.dateTime(minYear: 2022, maxYear: 2023),
        isEnabled: _faker.randomGenerator.boolean(),
        number: faker.randomGenerator.integer(9999),
        authorGender: Gender.values[_faker.randomGenerator.integer(3)]);
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is Post ? other.id == id : false;

  @override
  String toString() =>
      "Post(id: $id, author: $author, content: ${content.length > 50 ? content.substring(0, 50) + '...' : content}, createdAt: $createdAt, isEnabled: $isEnabled, number: $number, authorGender: $authorGender)";
}

enum Gender {
  male("Male"),
  female("Female"),
  unespecified("Unspecified");

  const Gender(this.name);

  final String name;
}

class PostsRepository {
  PostsRepository._();

  static final List<Post> _backend = [];

  static void generate(int count) {
    _backend.clear();
    _backend.addAll(List.generate(count, (index) => Post.random(id: index)));
  }

  static Future<PaginatedList<Post>> getPosts(
      {required int pageSize,
      required String? pageToken,
      bool? status,
      Gender? gender,
      DateTimeRange? between,
      String? authorName,
      String? searchQuery,
      String? sortBy,
      bool sortDescending = false}) async {
    await Future.delayed(const Duration(seconds: 1));

    // Decode page token
    int nextId = pageToken == null ? 0 : int.tryParse(pageToken) ?? 1;

    Iterable<Post> query = _backend;

    if (sortBy == null) {
      query = query.orderBy((element) => element.id);
    } else {
      switch (sortBy) {
        case "createdAt":
          query = sortDescending
              ? query.orderByDescending(
                  (element) => element.createdAt.millisecondsSinceEpoch)
              : query.orderBy(
                  (element) => element.createdAt.millisecondsSinceEpoch);
          break;

        case "number":
          query = sortDescending
              ? query.orderByDescending((element) => element.number)
              : query.orderBy((element) => element.number);
          break;

        case "author":
          query = sortDescending
              ? query.orderByDescending((element) => element.author)
              : query.orderBy((element) => element.author);
          break;

        case "authorGender":
          query = sortDescending
              ? query.orderByDescending((element) => element.authorGender.name)
              : query.orderBy((element) => element.authorGender.name);
          break;
      }
    }

    query = query.where((element) => element.id >= nextId);
    if (status != null) {
      query = query.where((element) => element.isEnabled == status);
    }

    if (gender != null) {
      query = query.where((element) => element.authorGender == gender);
    }

    if (between != null) {
      query = query.where((element) =>
          between.start.isBefore(element.createdAt) &&
          between.end.isAfter(element.createdAt));
    }

    if (authorName != null) {
      query = query.where((element) =>
          element.author.toLowerCase().contains(authorName.toLowerCase()));
    }

    if (searchQuery != null) {
      searchQuery = searchQuery.toLowerCase();
      query = query.where((element) =>
          element.author.toLowerCase().startsWith(searchQuery!) ||
          element.content.toLowerCase().contains(searchQuery));
    }

    var resultSet = query.take(pageSize + 1).toList();
    String? nextPageToken;
    if (resultSet.length == pageSize + 1) {
      Post lastPost = resultSet.removeLast();
      nextPageToken = lastPost.id.toString();
    }

    return PaginatedList(items: resultSet, nextPageToken: nextPageToken);
  }
}

class PaginatedList<T> {
  final Iterable<T> _items;
  final String? _nextPageToken;

  List<T> get items => UnmodifiableListView(_items);
  String? get nextPageToken => _nextPageToken;

  PaginatedList({required Iterable<T> items, String? nextPageToken})
      : _items = items,
        _nextPageToken = nextPageToken;
}
