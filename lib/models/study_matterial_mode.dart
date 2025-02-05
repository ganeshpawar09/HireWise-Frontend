class StudyMaterial {
  final String id;
  final String title;
  final String description;
  final List<ArticleSource> learningResources;
  final List<VideoPlaylist> featuredPlaylists;
  final List<Video> recommendedVideos;

  StudyMaterial({
    required this.id,
    required this.title,
    required this.description,
    required this.learningResources,
    required this.featuredPlaylists,
    this.recommendedVideos = const [],
  });
}

class ArticleSource {
  final String id;
  final String name;
  final String logoUrl;
  final String websiteUrl;
  final String description;

  ArticleSource({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.websiteUrl,
    required this.description,
  });
}

class VideoPlaylist {
  final String id;
  final String title;
  final String channelName;
  final String thumbnailUrl;
  final int videoCount;
  final String websiteUrl;

  VideoPlaylist({
    required this.id,
    required this.title,
    required this.channelName,
    required this.thumbnailUrl,
    required this.videoCount,
    required this.websiteUrl,
  });
}

class Video {
  final String id;
  final String title;
  final String channelName;
  final String thumbnailUrl;
  final String websiteUrl;
  final String duration;
  final int views;
  final DateTime publishedDate;
  final String description;

  Video({
    required this.id,
    required this.title,
    required this.channelName,
    required this.thumbnailUrl,
    required this.websiteUrl,
    required this.duration,
    required this.views,
    required this.publishedDate,
    required this.description,
  });
}

