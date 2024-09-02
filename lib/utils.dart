import 'package:intl/intl.dart';

String formatDate(DateTime){
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(DateTime);
}