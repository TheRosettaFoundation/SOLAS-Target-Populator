library TABroker;
import 'dart:html';
import 'dart:async';
import "package:json_object/json_object.dart";
import "TAHelper.dart";
void main() {
  TAMain app = new TAMain();
  HttpRequest.getString("conf/conf.json").then((e)=>app.loadConf(e)).then((e)=>app.run());

}


class TAMain{
  static TAMain _instance = null;
  TAMain._internal();
  
  factory TAMain(){
    if(_instance==null){
      _instance= new TAMain._internal();
    }
    return _instance;
  }
  
  JsonObject _conf;
  JsonObject get conf=>  _conf;
  
  void loadConf(String responce) {
    _conf= new JsonObject.fromJsonString(responce);
  }
  
  void run(){
    TAHelper helper = new TAHelper();
    var timer = new Timer.periodic(new Duration(seconds:conf.app.pollingInterval), (e)=>helper.processJobs());
  }
  static void ouputText(String str){
    DivElement elem= query("#sample_container_id");
    elem.children.add(new Element.html("<p>$str</p>"));
  }
}