class RESTResponseModel<T>{
  T data;
  bool error;
  String errorMessage;

  RESTResponseModel({this.data, this.error, this.errorMessage});
}