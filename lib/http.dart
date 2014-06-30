library Http;

import "dart:async";
import "dart:collection";
import "dart:convert";
import "dart:io" as io;

class HttpClient  {
  int numConnections = 0;
  io.HttpClient client;
  Queue<_Request> requests;
  Queue<_Request> bypassRequests;
  DateTime _hourTime = new DateTime.now();
  Timer requestTimer;
  Function rateLimit;
  bool checkingRateLimit = false;
  int requestsRemaining = 0;
  num totalRequests = 0;
  
  HttpClient() {
    client = new io.HttpClient();
    requests = new Queue();
    bypassRequests = new Queue();
    
    _startRequestTimer();
  }
  
  Future waitForRateLimit() {
    var com = new Completer();
    if(requestsRemaining <= 0) {
      checkingRateLimit = true;
      rateLimit();
      new Timer.periodic(new Duration(minutes: 1), (timer) {
        checkingRateLimit = true;
        rateLimit().then((_) {
          if(requestsRemaining > 0) {
            checkingRateLimit = false;
            com.complete();
            timer.cancel();
          }
        });
      });
    }
    else {
      com.complete();
    }    
    
    return com.future;
  }
  
  void _startRequestTimer() {
    requestTimer = new Timer.periodic(new Duration(milliseconds: 25), (timer) {
      if(numConnections == 0) {
        _makeRequest();
        _makeBypassRequest();
      }
    });
  }
  
  void _makeRequest() {
    if(requests.isNotEmpty) {
      if(!checkingRateLimit) {
        waitForRateLimit().then((_) {
          totalRequests++;
          _request(requests.removeFirst());
        });
      }
    }
  }
  
  void _makeBypassRequest() {
    if(bypassRequests.isNotEmpty) {
      _request(bypassRequests.removeFirst());
    }
  }
  
  Future _request(_Request re) {
    numConnections++;
    print("Remaining: $requestsRemaining, ${re.url}");
    client.getUrl(Uri.parse(re.url))
      .then((request) {
        requestsRemaining--;
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
  
  Future get(String url, {Map headers, bypass: false}) {
    var com = new Completer();
    if(bypass) {
      bypassRequests.add(new _Request(url, com, headers));
    }
    else {
      requests.add(new _Request(url, com, headers));
    }
    
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