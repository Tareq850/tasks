import '../packages/statusrequest.dart';

handleData(response){
  if(response is StatusRequest){
    return response;
  }else{
    return StatusRequest.success;
  }
}