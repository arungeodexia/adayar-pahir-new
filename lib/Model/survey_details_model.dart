/// userId : 57
/// userName : "Sam"
/// topText : "Your tumor surgery is scheduled for January 8th 2:00 PM"
/// question : {"templateid":2,"questionId":2,"question":"Instructions to apply the medication","questionType":"video","url":"https://aci-assets.s3.amazonaws.com/howtoapply.mp4","answerType":"choices","choices":[{"questionId":3,"question":"a. Instruction is clear","questionType":"text","url":null,"answerType":"radio","options":[{"optionId":"1","option":"Yes","url":null},{"optionId":"2","option":"No","url":null}],"hasNext":false,"hasPrevious":true},{"questionId":4,"order":2,"question":"b. Video quality is good","description":null,"questionType":"text","url":null,"answerType":"radio","options":[{"optionId":"1","option":"Yes","url":null},{"optionId":"2","option":"No","url":null}],"hasNext":false,"hasPrevious":true},{"questionId":5,"question":"c. Audio clear","description":null,"questionType":"text","url":null,"answerType":"radio","options":[{"optionId":1,"option":"Yes","url":null},{"optionId":2,"option":"No","url":null}],"hasNext":false,"hasPrevious":true}],"consolidateOptions":true,"hasNext":false,"hasPrevious":true}

class SurveyDetailsModel {
  int? _userId;
  String? _userName;
  String? _topText;
  Question? _question;

  int? get userId => _userId;
  String? get userName => _userName;
  String? get topText => _topText;
  Question? get question => _question;

  SurveyDetailsModel({
      int? userId,
      String? userName,
      String? topText,
      Question? question}){
    _userId = userId;
    _userName = userName;
    _topText = topText;
    _question = question;
}

  SurveyDetailsModel.fromJson(dynamic json) {
    _userId = json['userId'];
    _userName = json['userName'];
    _topText = json['topText'];
    _question = json['question'] != null ? Question.fromJson(json['question']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['userId'] = _userId;
    map['userName'] = _userName;
    map['topText'] = _topText;
    if (_question != null) {
      map['question'] = _question?.toJson();
    }
    return map;
  }

}

/// templateid : 2
/// questionId : 2
/// question : "Instructions to apply the medication"
/// questionType : "video"
/// url : "https://aci-assets.s3.amazonaws.com/howtoapply.mp4"
/// answerType : "choices"
/// choices : [{"questionId":3,"question":"a. Instruction is clear","questionType":"text","url":null,"answerType":"radio","options":[{"optionId":"1","option":"Yes","url":null},{"optionId":"2","option":"No","url":null}],"hasNext":false,"hasPrevious":true},{"questionId":4,"order":2,"question":"b. Video quality is good","description":null,"questionType":"text","url":null,"answerType":"radio","options":[{"optionId":"1","option":"Yes","url":null},{"optionId":"2","option":"No","url":null}],"hasNext":false,"hasPrevious":true},{"questionId":5,"question":"c. Audio clear","description":null,"questionType":"text","url":null,"answerType":"radio","options":[{"optionId":1,"option":"Yes","url":null},{"optionId":2,"option":"No","url":null}],"hasNext":false,"hasPrevious":true}]
/// consolidateOptions : true
/// hasNext : false
/// hasPrevious : true

class Question {
  int? _templateid;
  int? _questionId;
  String? _question;
  String? _questionType;
  String? _url;
  String? _answerType;
  List<Options>? _options;
  List<Choices>? _choices;
  bool? _consolidateOptions;
  bool? _hasNext;
  bool? _hasPrevious;

  int? get templateid => _templateid;
  int? get questionId => _questionId;
  String? get question => _question;
  String? get questionType => _questionType;
  String? get url => _url;
  String? get answerType => _answerType;
  List<Choices>? get choices => _choices;
  List<Options>? get options => _options;
  bool? get consolidateOptions => _consolidateOptions;
  bool? get hasNext => _hasNext;
  bool? get hasPrevious => _hasPrevious;

  Question({
      int? templateid,
      int? questionId,
      String? question,
      String? questionType,
      String? url,
      String? answerType,
      List<Choices>? choices,
      bool? consolidateOptions,
      bool? hasNext,
      bool? hasPrevious}){
    _templateid = templateid;
    _questionId = questionId;
    _question = question;
    _questionType = questionType;
    _url = url;
    _answerType = answerType;
    _choices = choices;
    _options = options;
    _consolidateOptions = consolidateOptions;
    _hasNext = hasNext;
    _hasPrevious = hasPrevious;
}

  Question.fromJson(dynamic json) {
    _templateid = json['templateid'];
    _questionId = json['questionId'];
    _question = json['question'];
    _questionType = json['questionType'];
    _url = json['url'];
    _answerType = json['answerType'];
    if (json['choices'] != null) {
      _choices = [];
      json['choices'].forEach((v) {
        _choices?.add(Choices.fromJson(v));
      });
    }
    if (json['options'] != null) {
      _options = [];
      json['options'].forEach((v) {
        _options?.add(Options.fromJson(v));
      });
    }

    _consolidateOptions = json['consolidateOptions'];
    _hasNext = json['hasNext'];
    _hasPrevious = json['hasPrevious'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['templateid'] = _templateid;
    map['questionId'] = _questionId;
    map['question'] = _question;
    map['questionType'] = _questionType;
    map['url'] = _url;
    map['answerType'] = _answerType;
    if (_choices != null) {
      map['choices'] = _choices?.map((v) => v.toJson()).toList();
    }
    if (_options != null) {
      map['options'] = _options?.map((v) => v.toJson()).toList();
    }

    map['consolidateOptions'] = _consolidateOptions;
    map['hasNext'] = _hasNext;
    map['hasPrevious'] = _hasPrevious;
    return map;
  }

}

/// questionId : 3
/// question : "a. Instruction is clear"
/// questionType : "text"
/// url : null
/// answerType : "radio"
/// options : [{"optionId":"1","option":"Yes","url":null},{"optionId":"2","option":"No","url":null}]
/// hasNext : false
/// hasPrevious : true

class Choices {
  int? _questionId;
  String? _question;
  String? _questionType;
  dynamic? _url;
  String? _answerType;
  List<Options>? _options;
  bool? _hasNext;
  bool? _hasPrevious;

  int? get questionId => _questionId;
  String? get question => _question;
  String? get questionType => _questionType;
  dynamic? get url => _url;
  String? get answerType => _answerType;
  List<Options>? get options => _options;
  bool? get hasNext => _hasNext;
  bool? get hasPrevious => _hasPrevious;

  Choices({
      int? questionId,
      String? question,
      String? questionType,
      dynamic? url,
      String? answerType,
      List<Options>? options,
      bool? hasNext,
      bool? hasPrevious}){
    _questionId = questionId;
    _question = question;
    _questionType = questionType;
    _url = url;
    _answerType = answerType;
    _options = options;
    _hasNext = hasNext;
    _hasPrevious = hasPrevious;
}

  Choices.fromJson(dynamic json) {
    _questionId = json['questionId'];
    _question = json['question'];
    _questionType = json['questionType'];
    _url = json['url'];
    _answerType = json['answerType'];
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
    map['questionId'] = _questionId;
    map['question'] = _question;
    map['questionType'] = _questionType;
    map['url'] = _url;
    map['answerType'] = _answerType;
    if (_options != null) {
      map['options'] = _options?.map((v) => v.toJson()).toList();
    }
    map['hasNext'] = _hasNext;
    map['hasPrevious'] = _hasPrevious;
    return map;
  }

}

/// optionId : "1"
/// option : "Yes"
/// url : null

class Options {
  dynamic? _optionId;
  String? _option;
  dynamic? _url;
  int? _select=-1;

  String? get optionId => _optionId;
  String? get option => _option;
  int? get select => _select;
  dynamic? get url => _url;

  set selct(int val) => _select = val; // optionally perform validation, etc

  Options({
      String? optionId,
      String? option,
      int? select,
      dynamic? url}){
    _optionId = optionId;
    _option = option;
    _select = select;
    _url = url;
}

  Options.fromJson(dynamic json) {
    _optionId = json['optionId'];
    _option = json['option'];
    _url = json['url'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['optionId'] = _optionId;
    map['option'] = _option;
    map['url'] = _url;
    return map;
  }

}