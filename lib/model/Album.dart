class Album {
  final String tags;
  final String previewURL;

  Album({required this.tags, required this.previewURL});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      tags: json['tags'],
      previewURL: json['previewURL'],
    );
  }

  static List<Album> listToAlbums(List jsonlist){
    return jsonlist.map((e) => Album.fromJson(e)).toList();
  }

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return 'Album{tags: $tags,previewURL: $previewURL}';
  // }
}
