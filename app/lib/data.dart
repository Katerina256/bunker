import 'dart:collection';

class BunkerEvent {
  String id = '01';
  String audio = '';
  String title = '';
  String duration = '';

  BunkerEvent(this.id, this.title, this.audio, this.duration);
}

class BunkerData {
  static final eData = {
    '01': new BunkerEvent('01', 'Мутанты', 'assets/audio/01.mp3', '01:08'),
    '02': new BunkerEvent('02', 'Динозавры', 'assets/audio/02.mp3', '01:04'),
    '03':
        new BunkerEvent('03', 'Ядерная война', 'assets/audio/03.mp3', '01:02'),
    '04': new BunkerEvent(
        '04', 'Химическая война', 'assets/audio/04.mp3', '01:02'),
    '05': new BunkerEvent(
        '05', 'Духи и призраки', 'assets/audio/05.mp3', '01:13'),
    '06': new BunkerEvent('06', 'Метеорит', 'assets/audio/06.mp3', '00:44'),
    '07': new BunkerEvent(
        '07', 'Суицидальная фауна', 'assets/audio/07.mp3', '00:53'),
    '08': new BunkerEvent(
        '08', 'Восстание роботов', 'assets/audio/08.mp3', '01:03'),
    '09': new BunkerEvent(
        '09', 'Информационная война', 'assets/audio/09.mp3', '01:12'),
    '10': new BunkerEvent('10', 'Инопланетяне', 'assets/audio/10.mp3', '00:59'),
    '11': new BunkerEvent(
        '11', 'Потеря эстетики', 'assets/audio/11.mp3', '01:14'),
    '12': new BunkerEvent(
        '12', 'Cтрадающий Коля', 'assets/audio/12.mp3', '01:14'),
    '13': new BunkerEvent('13', 'Супервулканы', 'assets/audio/13.mp3', '01:04'),
    '14':
        new BunkerEvent('14', 'Котапокалипсис', 'assets/audio/14.mp3', '01:08'),
    '15': new BunkerEvent('15', 'Пандемия', 'assets/audio/15.mp3', '01:10'),
    '16': new BunkerEvent(
        '16', 'Всемирный потоп', 'assets/audio/16.mp3', '01:00'),
    '17': new BunkerEvent(
        '17', 'Зомби-апокалипсис', 'assets/audio/17.mp3', '00:52'),
    '18': new BunkerEvent('18', 'Русский эпос', 'assets/audio/18.mp3', '01:22'),
    '19': new BunkerEvent('19', 'Ктулху', 'assets/audio/19.mp3', '01:04'),
    '20': new BunkerEvent(
        '20', 'Власть алгоритмов', 'assets/audio/20.mp3', '01:12'),
  };

  static final eList = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20'
  ];
}
