library globals;

String serverAddress = '';
bool debug = false;
String authHeader = '';
String serverUrl(){
  return '$serverAddress/api';
}