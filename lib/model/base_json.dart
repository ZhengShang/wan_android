class BaseJson {
  /*
    "data": {
        "curPage": 2,
        "datas": [],
        "offset": 20,
        "over": false,
        "pageCount": 77,
        "size": 20,
        "total": 1522
     }
    "errorCode": 0,
    "errorMsg": ""
   */

  int errorCode;
  String errorMsg;

  BaseJson({this.errorCode, this.errorMsg});
}
