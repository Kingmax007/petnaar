import 'package:petnaar/model/user.dart';

enum MediaType {
  image,
  video,
}

class Story {
  final String url;
  final MediaType media;
  final Duration duration;
  final User user;

  // Using required keyword to ensure all properties are passed to the constructor
  // and initializing non-nullable properties.
  Story({
    required this.url,
    required this.media,
    required this.duration,
    required this.user,
  });
}
