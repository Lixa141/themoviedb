import 'package:json_annotation/json_annotation.dart';

part 'movie_details_videos.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieDetailsVideos {
  final List<MovieDetailsVideosResults> results;

  MovieDetailsVideos({required this.results});

  factory MovieDetailsVideos.fromJson(Map<String, dynamic> json) => _$MovieDetailsVideosFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailsVideosToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieDetailsVideosResults {
  @JsonKey(name: 'iso_639_1')
  final String iso6391;
  @JsonKey(name: 'iso_3166_1')
  final String iso31661;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String publishedAt;
  final String id;

  MovieDetailsVideosResults({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });

  factory MovieDetailsVideosResults.fromJson(Map<String, dynamic> json) => _$MovieDetailsVideosResultsFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailsVideosResultsToJson(this);
}
