import 'package:petnaar/model/story_model.dart';
import 'package:petnaar/model/user.dart';

final User user = User(
  username: 'Kelvin Sapp',
  photoUrl: 'https://wallpapercave.com/wp/AYWg3iu.jpg', id: '', searchKey: '', receiverToken: '', email: '', displayName: '', bio: '', androidNotificationToken: '', chattingWith: '',
);

final List<Story> stories = [
  Story(
    url: 'https://images.unsplash.com/photo-1534103362078-d07e750bd0c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
    media: MediaType.image,
    duration: const Duration(seconds: 10),
    user: user,
  ),
  Story(
    url: 'https://media.giphy.com/media/moyzrwjUIkdNe/giphy.gif',
    media: MediaType.image,
    duration: const Duration(seconds: 7),
    user: user, // Reusing the same user instance here, as intended
  ),
  Story(
    url: 'https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4',
    media: MediaType.video,
    duration: const Duration(seconds: 20), // Assuming a meaningful duration
    user: user,
  ),
  // Additional stories...
];

