import 'package:intl/intl.dart';

String formatDate(DateTime dt){
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(dt);
}