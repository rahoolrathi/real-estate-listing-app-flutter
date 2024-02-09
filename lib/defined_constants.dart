const double horizontal_width=350;
const double horizontal_height=150;
const double vertical_width=180;
const double  vertical_height=280;
const String API="192.168.97.14:3000";
const String POSTPROPERTYURL='http://$API/api/v1/properties';
const String GETPROPERTIESURL='http://$API/api/v1/properties';
const String GETMYPROPERTIES='http://$API/api/v1/properties/myproperties/';
const String deleteMyProperty='http://$API/api/v1/properties/deleteProperty/';
const String applyfilterProperty='http://$API/api/v1/properties/filters/';
List<String> cities = [
  'Karachi',
  'Lahore',
  'Islamabad',
  'Rawalpindi',
  'Faisalabad',
  'Multan',
  'Gujranwala',
  'Sialkot',
  'Gujrat',
  'Bahawalpur',
  'Sargodha',
  'Sahiwal',
  'Hyderabad',
  'Sukkur',
  'Larkana',
  'Nawabshah',
  'Mirpur Khas',
  'Jacobabad',
  'Shikarpur',
  'Khairpur',
  'Dadu',
  'Peshawar',
  'Abbottabad',
  'Mardan',
  'Swat (Saidu Sharif)',
  'Mingora',
  'Kohat',
  'Bannu',
  'Nowshera',
  'Dera Ismail Khan',
  'Haripur',
  'Quetta',
  'Turbat',
  'Gwadar',
  'Chaman',
  'Sibi',
  'Zhob',
  'Loralai',
  'Mastung',
  'Nushki',
  'Khuzdar',
  'Islamabad'
];