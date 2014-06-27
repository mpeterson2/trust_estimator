library Http;

import "dart:async";
import "dart:collection";
import "dart:convert";
import "dart:io" as io;

class HttpClient  {
  int numConnections = 0;
  io.HttpClient client;
  Queue<_Request> requests;
  DateTime _hourTime = new DateTime.now();
  Timer requestTimer;
  
  HttpClient() {
    client = new io.HttpClient();
    requests = new Queue();
    
    _startRequestTimer();
  }
  
  void _startRequestTimer() {
    requestTimer = new Timer.periodic(new Duration(milliseconds: 25), (timer) {
      if(numConnections == 0) {
        _makeRequest();
      }
    });
  }
  
  void _makeRequest() {
    if(requests.isNotEmpty) {
      _request(requests.removeFirst());
    }
  }
  
  Future _request(_Request re) {
    numConnections++;
    
    client.getUrl(Uri.parse(re.url)).then((request) {        
        if(re.headers != null) {
          re.headers.forEach((key, val) => request.headers.set(key, val));
        }
        
        return request.close();
      })
      .then((response) {
        numConnections--;
        var returnData = new StringBuffer();
        response.transform(UTF8.decoder).listen((data) {
          returnData.write(data);
        })
        .onDone(() {
          _makeRequest();
          re.com.complete(returnData.toString());
        });
      });
    
    return re.com.future;
  }
  
  Future get(String url, {Map headers}) {
    var com = new Completer();
    requests.add(new _Request(url, com, headers));
    
    return com.future;
  }
  
  void end() {
    requestTimer.cancel();
  }
}

class _Request {
  String url;
  Completer com;
  Map headers = {};
  
  _Request(this.url, this.com, this.headers) {
    if(headers == null) {
      headers = {};
    }
  }
}