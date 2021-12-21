/// userId : 57
/// userName : "Sam"
/// topText : "Your tumor surgery is scheduled for January 8th 2:00 PM"
/// questions : [{"surveyId":1,"order":1,"question":"Did you follow the exercise prescribed?","description":"Neck","questionType":"image/url/text/video","url":"https://123.ert/sdf.jpg","answerType":"textbox/radio/checkbox/textarea/voice/image/video/survey","questions":null,"options":[{"optionId":1,"option":"Yes","image":"https://123.ert/wef.jpg"},{"optionId":2,"option":"No","image":"https://123.ert/rtf.jpg"},{"optionId":3,"option":"May be","image":"https://123.ert/ewq.jpg"}],"hasNext":true,"hasPrevious":false},{"surveyId":2,"order":2,"question":"Instructions to apply the medication","subText":null,"questionType":"image/url/text/video","url":"https://123.ert/sdf.mp4","answerType":"textbox/radio/checkbox/textarea/voice/image/video/survey","questions":[{"surveyId":3,"order":1,"question":"a. Instruction is clear","description":null,"questionType":"image/url/text/video","url":"https://123.ert/sdf.mp4","answerType":"radio/checkbox","options":[{"optionId":"1","option":"Yes","image":"https://123.ert/wef.jpg"},{"optionId":"2","option":"No","image":"https://123.ert/rtf.jpg"}],"hasNext":false,"hasPrevious":true},{"surveyId":4,"order":2,"question":"b. Video quality is good","description":null,"questionType":"image/url/text/video","url":"https://123.ert/sdf.mp4","answerType":"radio/checkbox","options":[{"optionId":"1","option":"Yes","image":"https://123.ert/wef.jpg"},{"optionId":"2","option":"No","image":"https://123.ert/rtf.jpg"}],"hasNext":false,"hasPrevious":true},{"surveyId":5,"order":3,"question":"c. Audio clear","description":null,"questionType":"image/url/text/video","url":"https://123.ert/sdf.mp4","answerType":"radio/checkbox","options":[{"optionId":1,"option":"Yes","image":"https://123.ert/wef.jpg"},{"optionId":2,"option":"No","image":"https://123.ert/rtf.jpg"}],"hasNext":false,"hasPrevious":true}],"options":null,"hasNext":false,"hasPrevious":true}]

class SurveyModel {
  int? _userId;
  String? _userName;
  String? _topText;
  List<Questions>? _questions;

  int? get userId => _userId;
  String? get userName => _userName;
  String? get topText => _topText;
  List<Questions>? get questions => _questions;

  SurveyModel({
      int? userId, 
      String? userName, 
      String? topText, 
      List<Questions>? questions}){
    _userId = userId;
    _userName = userName;
    _topText = topText;
    _questions = questions;
}

  SurveyModel.fromJson(dynamic json) {
    _userId = json['userId'];
    _userName = json['userName'];
    _topText = json['topText'];
    if (json['questions'] != null) {
      _questions = [];
      json['questions'].forEach((v) {
        _questions?.add(Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['userId'] = _userId;
    map['userName'] = _userName;
    map['topText'] = _topText;
    if (_questions != null) {
      map['questions'] = _questions?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// surveyId : 1
/// order : 1
/// question : "Did you follow the exercise prescribed?"
/// description : "Neck"
/// questionType : "image/url/text/video"
/// url : "https://123.ert/sdf.jpg"
/// answerType : "textbox/radio/checkbox/textarea/voice/image/video/survey"
/// questions : null
/// options : [{"optionId":1,"option":"Yes","image":"https://123.ert/wef.jpg"},{"optionId":2,"option":"No","image":"https://123.ert/rtf.jpg"},{"optionId":3,"option":"May be","image":"https://123.ert/ewq.jpg"}]
/// hasNext : true
/// hasPrevious : false

class Questions {
  int? _surveyId;
  int? _order;
  String? _question;
  String? _description;
  String? _questionType;
  String? _url;
  String? _answerType;
  dynamic? _questions;
  List<Options>? _options;
  bool? _hasNext;
  bool? _hasPrevious;

  int? get surveyId => _surveyId;
  int? get order => _order;
  String? get question => _question;
  String? get description => _description;
  String? get questionType => _questionType;
  String? get url => _url;
  String? get answerType => _answerType;
  dynamic? get questions => _questions;
  List<Options>? get options => _options;
  bool? get hasNext => _hasNext;
  bool? get hasPrevious => _hasPrevious;

  Questions({
      int? surveyId, 
      int? order, 
      String? question, 
      String? description, 
      String? questionType, 
      String? url, 
      String? answerType, 
      dynamic? questions, 
      List<Options>? options, 
      bool? hasNext, 
      bool? hasPrevious}){
    _surveyId = surveyId;
    _order = order;
    _question = question;
    _description = description;
    _questionType = questionType;
    _url = url;
    _answerType = answerType;
    _questions = questions;
    _options = options;
    _hasNext = hasNext;
    _hasPrevious = hasPrevious;
}

  Questions.fromJson(dynamic json) {
    _surveyId = json['surveyId'];
    _order = json['order'];
    _question = json['question'];
    _description = json['description'];
    _questionType = json['questionType'];
    _url = json['url'];
    _answerType = json['answerType'];
    _questions = json['questions'];
    if (json['options'] != null) {
      _options = [];
      json['options'].forEach((v) {
        _options?.add(Options.fromJson(v));
      });
    }
    _hasNext = json['hasNext'];
    _hasPrevious = json['hasPrevious'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['surveyId'] = _surveyId;
    map['order'] = _order;
    map['question'] = _question;
    map['description'] = _description;
    map['questionType'] = _questionType;
    map['url'] = _url;
    map['answerType'] = _answerType;
    map['questions'] = _questions;
    if (_options != null) {
      map['options'] = _options?.map((v) => v.toJson()).toList();
    }
    map['hasNext'] = _hasNext;
    map['hasPrevious'] = _hasPrevious;
    return map;
  }

}

/// optionId : 1
/// option : "Yes"
/// image : "https://123.ert/wef.jpg"

class Options {
  int? _optionId;
  String? _option;
  String? _image;

  int? get optionId => _optionId;
  String? get option => _option;
  String? get image => _image;

  Options({
      int? optionId, 
      String? option, 
      String? image}){
    _optionId = optionId;
    _option = option;
    _image = image;
}

  Options.fromJson(dynamic json) {
    _optionId = json['optionId'];
    _option = json['option'];
    _image = json['image'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['optionId'] = _optionId;
    map['option'] = _option;
    map['image'] = _image;
    return map;
  }

}