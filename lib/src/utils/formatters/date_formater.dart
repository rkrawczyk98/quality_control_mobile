import 'package:intl/intl.dart';

const Map<String, String> dayShortcuts = {
  'poniedziałek': 'pon.',
  'wtorek': 'wt.',
  'środa': 'śr.',
  'czwartek': 'czw.',
  'piątek': 'pt.',
  'sobota': 'sob.',
  'niedziela': 'niedz.'
};

String formatDate(DateTime? date) {
  final DateFormat dayFormatter = DateFormat.EEEE('pl');
  final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');
  final DateFormat timeFormatter = DateFormat('HH:mm');

  if(date != null){
  String dayOfWeek = dayFormatter.format(date);
  String formattedDayOfWeek = dayShortcuts[dayOfWeek] ?? dayOfWeek;
  String formattedDate = dateFormatter.format(date);
  String formattedTime = timeFormatter.format(date);

  return '$formattedDayOfWeek | $formattedDate | $formattedTime';
  }else{
    return 'Brak informacji';
  }

}
