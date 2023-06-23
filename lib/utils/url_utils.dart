enum URL {
  user('http://192.168.0.100:8888/user'),
  token('http://192.168.0.100:8888/token'),
  image('http://192.168.0.100:8888/image'),
  friend('http://192.168.0.100:8888/friend'),
  chat('http://192.168.0.100:8888/chat'),
  message('http://192.168.0.100:8888/message'),
  friendRequest('http://192.168.0.100:8888/friend_request');

  final String value;

  const URL(this.value);
}
