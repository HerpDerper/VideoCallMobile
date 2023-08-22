enum URL {
  user('http://localhost:8888/user'),
  token('http://localhost:8888/token'),
  image('http://localhost:8888/image'),
  friend('http://localhost:8888/friend'),
  chat('http://localhost:8888/chat'),
  message('http://localhost:8888/message'),
  friendRequest('http://localhost:8888/friend_request');

  final String value;

  const URL(this.value);
}
