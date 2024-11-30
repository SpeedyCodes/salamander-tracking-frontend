import 'package:intl/intl.dart';

String formatDate(DateTime dt){
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(dt);
}
DateTime parseDate(String dt){
  final DateFormat formatter = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
  return formatter.parse(dt);
}