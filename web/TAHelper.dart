library TABroker;
import 'package:xml/xml.dart';
import 'dart:json';
import 'tabroker.dart';
import 'LocconnectHelper.dart';
import 'dart:async';
import 'dart:html';
import 'ProgressEnum.dart';


class TAHelper{
  
  void processJobs(){
    downloadJobs().then((e)=>e.forEach((i)=>processJob(i)));
  }
  
  void processJob(String jobid) {
   LocconnectHelper.setStatus(jobid, ProgressEnum.PROCESSING)
   .then((HttpRequest responce){
     TAMain.ouputText(responce.responseText);
     LocconnectHelper.setFeedback(jobid, "the job is now being process")
     .then((HttpRequest re){
       TAMain.ouputText(re.responseText); 
         downloadJob(jobid)
         .then((e){
             LocconnectHelper.sendOutput(jobid,processFile(jobid,e))
             .then((e)=>LocconnectHelper.setFeedback(jobid, "processing complete"))
             .then((e)=>LocconnectHelper.setStatus(jobid, ProgressEnum.COMPLETE))
             .then((HttpRequest responce)=>TAMain.ouputText(responce.responseText));
         });
     });
     
     
     
   });
  }
  String processFile(String jobid,String text){
    if(text==null||text=="")return text;
    LocconnectHelper.setFeedback(jobid, "populating File").then((HttpRequest responce)=>TAMain.ouputText(responce.responseText));
     if(text.startsWith("<content>")){
       text=text.replaceFirst("<content>", "");
       text=text.substring(0,text.lastIndexOf("</content>"));
     }
     text=text.trim();
     var parser = new DomParser();
     Document xliff =parser.parseFromString(text, 'text/xml');
//     XmlElement xliff = XML.parse(text);
     Element root =xliff.firstChild;
     if(double.parse(root.attributes["version"])==2.0){
       ElementList units= xliff.queryAll("unit");
       units.forEach((Element unit){
         ElementList match=unit.queryAll("match");
         ElementList segments= unit.queryAll("segment");
         
         segments.forEach((Element segment){
           var max=0.0;
           Element maxElement;
           
           ElementList mrks = segment.queryAll("mrk");
           Iterable mrkItr = mrks.where((Element e) => e.attributes.containsKey("ref"));
           mrkItr.forEach((Element mrk) {
             Element currentMatch=match.singleWhere((Element e)=>"#"+e.attributes["id"]==mrk.attributes["ref"]);
             if(currentMatch.attributes.containsKey("matchSuitability")&&double.parse(currentMatch.attributes["matchSuitability"])>max){
               max=currentMatch.attributes["matchSuitability"];
               maxElement=currentMatch;
             }else if(currentMatch.attributes.containsKey("matchQuality")&&currentMatch.attributes.containsKey("similarity")){
               double current = double.parse(currentMatch.attributes["matchQuality"])*double.parse(currentMatch.attributes["similarity"]);
               if(current>max){
                 max=current;
                 maxElement=currentMatch;
               }
             }
           });
           if(match!=null&& match.isNotEmpty){
               Element node=null; 
               if(maxElement!=null)node = maxElement.query("target").clone(true);
               else node = match.singleWhere((Element e)=>"#"+e.attributes["id"]==mrks[0].attributes["ref"]).query("target").clone(true);
               segment.append(node);
           }
           
         });
         
       });
     }else{
       ElementList transUnits= xliff.queryAll("trans-unit");
      transUnits.forEach((Element transunit){
        ElementList altTrans=transunit.queryAll("alt-trans");
        var max=0.0;
        Element maxElement; 
        altTrans.forEach((Element alt){
         if(alt.attributes.containsKey("match-quality")&&double.parse(alt.attributes["match-quality"])>max){
           max=alt.attributes["match-quality"];
           maxElement=alt;
         }
        });
         if(altTrans!=null&& altTrans.isNotEmpty){
          var placeholder = altTrans.first;
          Element node=null; 
          if(maxElement!=null)node = maxElement.query("target");
          else node = altTrans.first.query("target");
          if(node.parent.attributes.containsKey("provenanceRecordsRef")){
            node =node.clone(true).$dom_setAttribute("its:provenanceRecordsRef", node.parent.attributes["provenanceRecordsRef"]);
          }else node =node.clone(true);
          transunit.insertBefore(node,placeholder);
         }
      });
     }
     
     return new XmlSerializer().serializeToString(xliff);
     

    
  }
  
  
  downloadJob(String jobid){
    LocconnectHelper.setFeedback(jobid, "downloading job file").then((HttpRequest responce)=>TAMain.ouputText(responce.responseText));
    Future ret= LocconnectHelper.downloadJob(jobid);
    ret.then(
        (e)=>LocconnectHelper.setFeedback(jobid, "downloading complete").then((HttpRequest responce)=>TAMain.ouputText(responce.responseText)));
    return ret; 
  }
  
  Future<List> downloadJobs() {
    TAMain app = new TAMain();
    Future<List> ret = LocconnectHelper.downloadJobs().then((jobs)=>new Future.value((parseJobs(jobs))));
   return ret;

  }
  
  List<String> parseJobs(String jobs) {
    List ret = new List();
    try{
      var xml = XML.parse(jobs);
      XmlCollection jobNodes =xml.queryAll("job");
      
      jobNodes.forEach((XmlElement e)=> ret.add(e.text));
    }catch(e){}
    return ret;
  }

  
  
}