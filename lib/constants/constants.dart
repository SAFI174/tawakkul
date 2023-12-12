import 'package:adhan/adhan.dart';
import 'package:quran/quran.dart';
const String bismillahText = '324';
const String loadingText = 'يتم تحضير البيانات...';
const String appName = 'تَوَكَّلَ';
const String previewColorMarkerText = 'ﭑ ﭒ ﭓ ﭔ ﭕ ﭖ ﭗ';
const String previewColorBox = 'ò';
const String previewVerse = "ﯜ ﯝ ﯞ ﯟ ﯠ";
const String previewText = basmala;
const String explainAdaptiveModeText =
    'تسمح للمستخدمين بالتحكم الكامل في حجم الخط والتكبير والتصغير وفقًا لاحتياجاتهم الشخصية. يمكن ضبط النص بحجم مناسب للعينين، مما يجعل القراءة مريحة اكثر';

final List<Map<String, dynamic>> madhabList = [
  {
    "title": "المذهب الشافعي",
    "description":
        "يتم حساب صلاة العصر في المذهب الشافعي عندما يكون ظل الجسم مساويًا لطوله، بالإضافة إلى طول الظل في منتصف النهار.",
    "madhab": Madhab.shafi.index,
  },
  {
    "title": "المذهب الحنفي",
    "description":
        "يتم حساب صلاة العصر في المذهب الحنفي عندما يكون ظل الجسم ضعف طوله، بالإضافة إلى طول الظل في منتصف النهار.",
    "madhab": Madhab.hanafi.index,
  },
];

final List<Map<String, dynamic>> calculationMethodList = [
  {
    "title": "منظمة العالم الإسلامي",
    "description": "تستخدم زاوية الفجر 18 وزاوية العشاء 17",
    "method": CalculationMethod.muslim_world_league.index,
  },
  {
    "title": "الهيئة العامة المصرية للمساحة",
    "description": "تستخدم زاوية الفجر 19.5 وزاوية العشاء 17.5",
    "method": CalculationMethod.egyptian.index,
  },
  {
    "title": "جامعة العلوم الإسلامية، كراتشي",
    "description": "تستخدم زاوية الفجر 18 وزاوية العشاء 18",
    "method": CalculationMethod.karachi.index,
  },
  {
    "title": "جامعة أم القرى، مكة",
    "description":
        "تستخدم زاوية الفجر 18.5 وزاوية العشاء 90. ملاحظة: يجب إضافة تعديل مخصص لعشاء بزمن +30 دقيقة خلال رمضان",
    "method": CalculationMethod.umm_al_qura.index,
  },
  {
    "title": "منطقة الخليج",
    "description": "تستخدم زاوية الفجر والعشاء بزاوية 18.2 درجة",
    "method": CalculationMethod.dubai.index,
  },
  {
    "title": "لجنة رؤية الهلال",
    "description":
        "تستخدم زاوية الفجر 18 وزاوية العشاء 18. كما تستخدم قيم تعديل موسمية",
    "method": CalculationMethod.moon_sighting_committee.index,
  },
  {
    "title": "الطريقة المعروفة باسم ISNA",
    "description":
        "تم تضمين هذه الطريقة لأغراض الاكتمال، ولكنها غير مستحسنة. تستخدم زاوية الفجر 15 وزاوية العشاء 15",
    "method": CalculationMethod.north_america.index,
  },
  {
    "title": "الكويت",
    "description": "تستخدم زاوية الفجر 18 وزاوية العشاء 17.5",
    "method": CalculationMethod.kuwait.index,
  },
  {
    "title": "قطر",
    "description": "نسخة معدلة من أم القرى تستخدم زاوية الفجر 18",
    "method": CalculationMethod.qatar.index,
  },
  {
    "title": "سنغافورة",
    "description": "تستخدم زاوية الفجر 20 وزاوية العشاء 18",
    "method": CalculationMethod.singapore.index,
  },
  {
    "title": "ديانيت",
    "description": "تركيا",
    "method": CalculationMethod.turkey.index,
  },
  {
    "title": "معهد الجيوفيزياء، جامعة طهران",
    "description":
        "وقت العشاء المبكر بزاوية 14 درجة. وقت الفجر متأخر قليلاً بزاوية 17.7 درجة. يحسب المغرب بناءً على وصول الشمس إلى زاوية 4.5 درجة تحت الأفق",
    "method": CalculationMethod.tehran.index,
  },
];
