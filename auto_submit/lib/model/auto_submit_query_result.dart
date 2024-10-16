// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'auto_submit_query_result.g.dart';

/// The classes in this file are used to serialize/deserialize graphql results.
/// Using classes rather than complex maps improves the readability of the code
/// and makes possible to define an extensible interface for the validations.

@JsonSerializable()
class Author {

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
  Author({
    this.login,
  });
  final String? login;

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}

@JsonSerializable()
class ReviewNode {

  factory ReviewNode.fromJson(Map<String, dynamic> json) => _$ReviewNodeFromJson(json);
  ReviewNode({
    this.author,
    this.authorAssociation,
    this.state,
  });
  final Author? author;
  @JsonKey(name: 'authorAssociation')
  final String? authorAssociation;
  final String? state;

  Map<String, dynamic> toJson() => _$ReviewNodeToJson(this);
}

@JsonSerializable()
class Reviews {

  factory Reviews.fromJson(Map<String, dynamic> json) => _$ReviewsFromJson(json);
  Reviews({this.nodes});

  List<ReviewNode>? nodes;

  Map<String, dynamic> toJson() => _$ReviewsToJson(this);
}

@JsonSerializable()
class CommitNode {

  factory CommitNode.fromJson(Map<String, dynamic> json) => _$CommitNodeFromJson(json);
  CommitNode({this.commit});

  Commit? commit;

  Map<String, dynamic> toJson() => _$CommitNodeToJson(this);
}

@JsonSerializable()
class Commits {

  factory Commits.fromJson(Map<String, dynamic> json) => _$CommitsFromJson(json);
  Commits({this.nodes});

  List<CommitNode>? nodes;

  Map<String, dynamic> toJson() => _$CommitsToJson(this);
}

enum MergeableState {
  CONFLICTING,
  MERGEABLE,
  UNKNOWN,
}

@JsonSerializable()
class ContextNode {

  factory ContextNode.fromJson(Map<String, dynamic> json) => _$ContextNodeFromJson(json);
  ContextNode({
    this.createdAt,
    this.context,
    this.state,
    this.targetUrl,
  });

  @JsonKey(name: 'createdAt')
  DateTime? createdAt;
  String? context;
  String? state;
  @JsonKey(name: 'targetUrl')
  String? targetUrl;

  Map<String, dynamic> toJson() => _$ContextNodeToJson(this);

  @override
  String toString() => jsonEncode(_$ContextNodeToJson(this));
}

@JsonSerializable()
class Status {

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
  Status({this.contexts});

  List<ContextNode>? contexts;

  Map<String, dynamic> toJson() => _$StatusToJson(this);
}

@JsonSerializable()
class Commit {

  factory Commit.fromJson(Map<String, dynamic> json) => _$CommitFromJson(json);
  Commit({
    this.abbreviatedOid,
    this.oid,
    this.committedDate,
    this.pushedDate,
    this.status,
  });
  @JsonKey(name: 'abbreviatedOid')
  final String? abbreviatedOid;
  final String? oid;
  @JsonKey(name: 'committedDate')
  final DateTime? committedDate;
  @JsonKey(name: 'pushedDate')
  final DateTime? pushedDate;
  final Status? status;

  Map<String, dynamic> toJson() => _$CommitToJson(this);
}

@JsonSerializable()
class PullRequest {

  factory PullRequest.fromJson(Map<String, dynamic> json) => _$PullRequestFromJson(json);
  PullRequest({
    this.author,
    this.authorAssociation,
    this.id,
    this.title,
    this.body,
    this.reviews,
    this.commits,
    this.mergeable,
    this.number,
  });
  final Author? author;
  @JsonKey(name: 'authorAssociation')
  final String? authorAssociation;
  final String? id;
  final String? title;
  final String? body;
  final Reviews? reviews;
  final Commits? commits;
  final int? number;
  // https://docs.github.com/en/graphql/reference/enums#mergeablestate
  final MergeableState? mergeable;

  Map<String, dynamic> toJson() => _$PullRequestToJson(this);
}

@JsonSerializable()
class Repository {

  factory Repository.fromJson(Map<String, dynamic> json) => _$RepositoryFromJson(json);
  Repository({
    this.pullRequest,
  });

  @JsonKey(name: 'pullRequest')
  PullRequest? pullRequest;

  Map<String, dynamic> toJson() => _$RepositoryToJson(this);
}

@JsonSerializable()
class QueryResult {

  factory QueryResult.fromJson(Map<String, dynamic> json) => _$QueryResultFromJson(json);
  QueryResult({
    this.repository,
  });

  Repository? repository;

  Map<String, dynamic> toJson() => _$QueryResultToJson(this);
}

/// The reason for this funky naming scheme can be blamed on GitHub.
///
/// See: https://docs.github.com/en/graphql/reference/mutations#revertpullrequest
/// The enclosing object is called RevertPullRequest and has a nested field also
/// called RevertPullRequest.
@JsonSerializable()
class RevertPullRequest {

  factory RevertPullRequest.fromJson(Map<String, dynamic> json) => _$RevertPullRequestFromJson(json);
  RevertPullRequest({
    this.clientMutationId,
    this.pullRequest,
    this.revertPullRequest,
  });

  @JsonKey(name: 'clientMutationId')
  String? clientMutationId;
  @JsonKey(name: 'pullRequest')
  PullRequest? pullRequest;
  @JsonKey(name: 'revertPullRequest')
  PullRequest? revertPullRequest;

  Map<String, dynamic> toJson() => _$RevertPullRequestToJson(this);
}

/// This is needed since the data we get is buried within this outer object and
/// to simplify the deserialization need this wrapper.
///
/// The return data is nested as such:
/// "data": {
///   "revertPullRequest": {
///     "clientMutationId": xxx,
///     "pullRequest": { ... },
///     "revertPullRequest": { ... }
///   }
/// }
@JsonSerializable()
class RevertPullRequestData {

  factory RevertPullRequestData.fromJson(Map<String, dynamic> json) => _$RevertPullRequestDataFromJson(json);
  RevertPullRequestData({this.revertPullRequest});

  @JsonKey(name: 'revertPullRequest')
  RevertPullRequest? revertPullRequest;

  Map<String, dynamic> toJson() => _$RevertPullRequestDataToJson(this);
}
