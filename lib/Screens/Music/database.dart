import 'package:flutter/material.dart';

class Playlist{
  final String username;
  final String title;
  final String artwork;
  final int duration;
  final int playlistID;
  final Color color;

  Playlist({
    required this.playlistID,
    required this.duration,
    required this.artwork,
    required this.title,
    required this.username,
    required this.color,
});

}

class Song{
  late final String artist;
  late final int playlistID;
  late final String title;
  late final String artwork;
  late final String url;
  final int duration;
  final Color color;

  Song({
    required this.artist,
    required this.title,
    required this.artwork,
    required this.url,
    required this.color,
    required this.duration,
    required this.playlistID,
});
}

List <Playlist> mostPopular = [
  Playlist(
    username: "SMKNGun",
    title: "Leg Dancing",
    artwork: "asset/images/mango-6.jpg",
    duration: 0,
    playlistID: 10,
    color: Colors.brown,
  ),
  Playlist(
    username: "RoyalPythonDon",
    title: "Jiggy Biggy",
    artwork: "asset/images/mango-8.jpg",
    duration: 0,
    playlistID: 10,
    color: Colors.brown,
  ),
  Playlist(
    username: "JoswagDapper",
    title: "A Rebel Riddim",
    artwork: "asset/images/mango-4.jpg",
    duration: 0,
    playlistID: 10,
    color: Colors.brown,
  ),
  Playlist(
    username: "OGB",
    title: "Vibes and Insha Allah",
    artwork: "asset/images/mango-11.jpg",
    duration: 0,
    playlistID: 10,
    color: Colors.brown,
  ),
  Playlist(
    username: "BiggBishop",
    title: "St. Bottles Vibration",
    artwork: "asset/images/mango-2.jpg",
    duration: 0,
    playlistID: 10,
    color: Colors.brown,
  ),
];

List <Playlist> feelFunky = [
  Playlist(
    username: "SMKNGun",
    title: "Leg Dancing",
    artwork: "asset/images/mango-6.jpg",
    duration: 0,
    playlistID: 10,
    color: Colors.brown,
  ),
  Playlist(
    username: "PythonDon",
    title: "Jiggy Biggy",
    artwork: "asset/images/mango-8.jpg",
    duration: 0,
    playlistID: 10,
    color: Colors.brown,
  ),
  Playlist(
    username: "JoswagDapper",
    title: "A Rebel Riddim",
    artwork: "asset/images/mango-4.jpg",
    duration: 0,
    playlistID: 10,
    color: Colors.brown,
  ),
  Playlist(
    username: "OGB",
    title: "Idan Amaru",
    artwork: "asset/images/mango-11.jpg",
    duration: 0,
    playlistID: 10,
    color: Colors.brown,
  ),
  Playlist(
    username: "BiggBishop",
    title: "St. Bottles Vibration",
    artwork: "asset/images/mango-2.jpg",
    duration: 0,
    playlistID: 10,
    color: Colors.brown,
  ),
];

List <Song> all = [
  Song(
    title: "Mango Preview 1",
    artist: "musicAdmin",
    artwork: "asset/images/mango-6.jpg",
    color: Colors.blueAccent,
    duration: 0,
    playlistID: 10,
    url: "https://assets.mixkit.co/music/preview/mixkit-tech-house-vibes-130.mp3",
  ),
  Song(
    title: "Mango Preview 2",
    artist: "musicAdmin",
    artwork: "asset/images/mango-4.jpg",
    color: Colors.blueAccent,
    duration: 0,
    playlistID: 10,
    url: "https://assets.mixkit.co/music/preview/mixkit-hip-hop-02-738.mp3",
  ),
  Song(
    title: "Mango Preview 3",
    artist: "musicAdmin",
    artwork: "asset/images/mango-7.jpg",
    color: Colors.blueAccent,
    duration: 0,
    playlistID: 10,
    url: "https://assets.mixkit.co/music/preview/mixkit-a-very-happy-christmas-897.mp3",
  ),
  Song(
    title: "Mango Preview 4",
    artist: "musicAdmin",
    artwork: "asset/images/mango-10.jpg",
    color: Colors.blueAccent,
    duration: 0,
    playlistID: 10,
    url: "https://assets.mixkit.co/music/preview/mixkit-hazy-after-hours-132.mp3",
  ),
  Song(
    title: "Mango Preview 5",
    artist: "musicAdmin",
    artwork: "asset/images/mango-11.jpg",
    color: Colors.blueAccent,
    duration: 0,
    playlistID: 10,
    url: "https://assets.mixkit.co/music/preview/mixkit-sun-and-his-daughter-580.mp3",
  ),
  Song(
    title: "Mango Preview 6",
    artist: "musicAdmin",
    artwork: "asset/images/mango-1.jpg",
    color: Colors.blueAccent,
    duration: 0,
    playlistID: 10,
    url: "https://assets.mixkit.co/music/preview/mixkit-raising-me-higher-34.mp3",
  ),
  Song(
    title: "Mango Preview 7",
    artist: "musicAdmin",
    artwork: "asset/images/mango-5.jpg",
    color: Colors.blueAccent,
    duration: 0,
    playlistID: 10,
    url: 'https://assets.mixkit.co/music/preview/mixkit-driving-ambition-32.mp3',
  ),
  Song(
    title: "Mango Preview 8",
    artist: "musicAdmin",
    artwork: "asset/images/mango-12.jpg",
    color: Colors.blueAccent,
    duration: 0,
    playlistID: 10,
    url: 'https://assets.mixkit.co/music/preview/mixkit-life-is-a-dream-837.mp3',
  ),
  Song(
    title: "Mango Preview 9",
    artist: "musicAdmin",
    artwork: "asset/images/mango-14.jpg",
    color: Colors.blueAccent,
    duration: 0,
    playlistID: 10,
    url: "https://assets.mixkit.co/music/preview/mixkit-serene-view-443.mp3",
  ),
];