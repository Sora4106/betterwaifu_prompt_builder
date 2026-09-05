import 'dart:convert';
import 'dart:html' as html;
import 'dart:math';

import 'package:flutter/material.dart';

import 'app_version.dart';
import 'catalog_data.dart';

const _storageKey = 'betterwaifu_prompt_builder_state_v1';
const _lastSeenVersionKey = 'betterwaifu_prompt_builder_last_seen_version';
const _buttonSurface = Color(0xff34344d);
const _buttonBorder = Color(0xff77779b);
const _buttonSelectedSurface = Color(0xffc4b5fd);
const _buttonSelectedText = Color(0xff171326);
const _defaultNegativeText =
    'lowres, worst quality, bad quality, bad anatomy, bad hands, extra digits, '
    'multiple views, fewer digits, extra limbs, missing fingers, deformed, text, '
    'error, jpeg artifacts, watermark, unfinished, displeasing, signature, username, scan artifacts';

const _negativeCatalog = <Map<String, String>>[
  {'en': 'lowres', 'zh': '低解析度'},
  {'en': 'blurry', 'zh': '模糊'},
  {'en': 'worst quality', 'zh': '最差品質'},
  {'en': 'bad quality', 'zh': '低品質'},
  {'en': 'bad anatomy', 'zh': '錯誤的人體結構'},
  {'en': 'bad hands', 'zh': '錯誤的手部'},
  {'en': 'bad feet', 'zh': '錯誤的腳部'},
  {'en': 'extra digits', 'zh': '多餘手指'},
  {'en': 'fewer digits', 'zh': '手指數量不足'},
  {'en': 'extra limbs', 'zh': '多餘肢體'},
  {'en': 'missing fingers', 'zh': '缺少手指'},
  {'en': 'multiple views', 'zh': '多重視角'},
  {'en': 'deformed', 'zh': '變形'},
  {'en': 'poorly drawn face', 'zh': '臉部繪製不佳'},
  {'en': 'duplicate', 'zh': '重複內容'},
  {'en': 'text', 'zh': '文字'},
  {'en': 'error', 'zh': '錯誤'},
  {'en': 'jpeg artifacts', 'zh': 'JPEG 壓縮瑕疵'},
  {'en': 'watermark', 'zh': '浮水印'},
  {'en': 'logo', 'zh': '標誌'},
  {'en': 'signature', 'zh': '簽名'},
  {'en': 'username', 'zh': '使用者名稱'},
  {'en': 'unfinished', 'zh': '未完成'},
  {'en': 'displeasing', 'zh': '令人不悅'},
  {'en': 'scan artifacts', 'zh': '掃描瑕疵'},
  {'en': 'sketch', 'zh': '草稿'},
  {'en': 'monochrome', 'zh': '單色'},
  {'en': 'greyscale', 'zh': '灰階'},
  {'en': 'artist name', 'zh': '藝術家名稱'},
];

extension _StringFallback on String {
  String ifEmpty(String fallback) => trim().isEmpty ? fallback : this;
}

class TagItem {
  const TagItem({
    required this.id,
    required this.group,
    required this.zh,
    required this.en,
    required this.order,
    this.adult = false,
    this.builtIn = true,
    this.conflictGroup,
  });

  final String id;
  final String group;
  final String zh;
  final String en;
  final int order;
  final bool adult;
  final bool builtIn;
  final String? conflictGroup;

  Map<String, dynamic> toJson() => {
        'id': id,
        'group': group,
        'zh': zh,
        'en': en,
        'order': order,
        'adult': adult,
        'builtIn': builtIn,
        'conflictGroup': conflictGroup,
      };

  factory TagItem.fromJson(Map<String, dynamic> json) => TagItem(
        id: '${json['id']}',
        group: '${json['group'] ?? '自訂'}',
        zh: '${json['zh'] ?? ''}',
        en: '${json['en'] ?? ''}',
        order: (json['order'] as num?)?.toInt() ?? 1,
        adult: json['adult'] == true,
        builtIn: false,
        conflictGroup: json['conflictGroup'] as String?,
      );
}

class _GeneratedOutputTag {
  const _GeneratedOutputTag({
    required this.zh,
    required this.en,
    this.tagId,
    this.personIndex,
    this.characterTag = false,
  });

  final String zh;
  final String en;
  final String? tagId;
  final int? personIndex;
  final bool characterTag;
}

class Preset {
  Preset({required this.name, required this.payload});

  final String name;
  final Map<String, dynamic> payload;

  Map<String, dynamic> toJson() => {'name': name, 'payload': payload};

  factory Preset.fromJson(Map<String, dynamic> json) => Preset(
        name: '${json['name'] ?? '未命名組合'}',
        payload: Map<String, dynamic>.from(json['payload'] as Map? ?? {}),
      );
}

class PersonSlot {
  PersonSlot({this.gender = '女性'});

  String gender;
  bool detailed = true;
  String mode = '原創';
  String characterId = '';
  String animeQuery = '';
  String animeTag = '';
  String remoteAnimeZh = '';
  String remoteAnimeEn = '';
  String query = '';
  String originalAnimeZh = '';
  String originalAnimeEn = '';
  String originalAnimeTag = '';
  String originalCharacterZh = '';
  String originalCharacterEn = '';
  String originalCharacterTag = '';
  String originalTraits = '';

  Map<String, dynamic> toJson() => {
        'gender': gender,
        'detailed': detailed,
        'mode': mode,
        'characterId': characterId,
        'animeQuery': animeQuery,
        'animeTag': animeTag,
        'remoteAnimeZh': remoteAnimeZh,
        'remoteAnimeEn': remoteAnimeEn,
        'query': query,
        'originalAnimeZh': originalAnimeZh,
        'originalAnimeEn': originalAnimeEn,
        'originalAnimeTag': originalAnimeTag,
        'originalCharacterZh': originalCharacterZh,
        'originalCharacterEn': originalCharacterEn,
        'originalCharacterTag': originalCharacterTag,
        'originalTraits': originalTraits,
      };

  factory PersonSlot.fromJson(Map<String, dynamic> json) => PersonSlot(
        gender: '${json['gender'] ?? '女性'}',
      )
        ..detailed = json['detailed'] != false
        ..mode = '${json['mode'] ?? '原創'}'
        ..characterId = '${json['characterId'] ?? ''}'
        ..animeQuery = '${json['animeQuery'] ?? ''}'
        ..animeTag = '${json['animeTag'] ?? ''}'
        ..remoteAnimeZh = '${json['remoteAnimeZh'] ?? ''}'
        ..remoteAnimeEn = '${json['remoteAnimeEn'] ?? ''}'
        ..query = '${json['query'] ?? ''}'
        ..originalAnimeZh = '${json['originalAnimeZh'] ?? ''}'
        ..originalAnimeEn = '${json['originalAnimeEn'] ?? ''}'
        ..originalAnimeTag = '${json['originalAnimeTag'] ?? ''}'
        ..originalCharacterZh = '${json['originalCharacterZh'] ?? ''}'
        ..originalCharacterEn = '${json['originalCharacterEn'] ?? ''}'
        ..originalCharacterTag = '${json['originalCharacterTag'] ?? ''}'
        ..originalTraits = '${json['originalTraits'] ?? ''}';
}

class _RemoteAnime {
  const _RemoteAnime({
    required this.id,
    required this.title,
    required this.titleJapanese,
    required this.year,
    this.source = 'jikan',
    this.characters = const <_RemoteCharacter>[],
  });

  final int id;
  final String title;
  final String titleJapanese;
  final int? year;
  final String source;
  final List<_RemoteCharacter> characters;

  String get tag => title
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9_ -]'), '')
      .replaceAll(RegExp(r'\s+'), '_');
}

class _RemoteCharacter {
  const _RemoteCharacter({
    required this.id,
    required this.name,
    required this.nameKanji,
    required this.role,
    this.about = '',
  });

  final int id;
  final String name;
  final String nameKanji;
  final String role;
  final String about;

  _RemoteCharacter withAbout(String value) => _RemoteCharacter(
        id: id,
        name: name,
        nameKanji: nameKanji,
        role: role,
        about: value,
      );
}

TagItem _catalogTag(CatalogTagData data, {String prefix = 'catalog'}) =>
    TagItem(
      id: '${prefix}_${data.id}',
      group: data.group,
      zh: data.zh,
      en: data.en,
      order: data.order,
      adult: data.adult,
      conflictGroup: data.conflictGroup,
    );

TagItem _characterTag(String id, String zh, String en) => TagItem(
      id: 'character_$id',
      group: '角色標籤',
      zh: zh,
      en: en,
      order: 1,
    );

TagItem _tag(
  String id,
  String group,
  String zh,
  String en,
  int order, {
  bool adult = false,
  String? conflictGroup,
}) =>
    TagItem(
        id: id,
        group: group,
        zh: zh,
        en: en,
        order: order,
        adult: adult,
        conflictGroup: conflictGroup);

const _clothingColors = <List<String>>[
  ['black', '\u9ED1\u8272'],
  ['white', '\u767D\u8272'],
  ['red', '\u7D05\u8272'],
  ['blue', '\u85CD\u8272'],
  ['pink', '\u7C89\u7D05\u8272'],
  ['purple', '\u7D2B\u8272'],
  ['green', '\u7DA0\u8272'],
  ['yellow', '\u9EC3\u8272'],
  ['brown', '\u68D5\u8272'],
  ['gray', '\u7070\u8272'],
  ['gold', '\u91D1\u8272'],
  ['silver', '\u9280\u8272'],
  ['multicolored', '\u591A\u5F69'],
];

List<TagItem> _clothingColorTags(
  String prefix,
  String group,
  String zhSuffix,
  String enSuffix,
  String conflictGroup, {
  bool adult = false,
}) {
  return _clothingColors
      .map((color) => _tag(
            '${prefix}_${color[0]}',
            group,
            '${color[1]}$zhSuffix',
            '${color[0]} $enSuffix',
            2,
            adult: adult,
            conflictGroup: conflictGroup,
          ))
      .toList();
}

List<TagItem> _seedTags() => [
      // Role and character basics.
      _tag('role_girl', '角色類型', '女性角色', '1girl', 0),
      _tag('role_boy', '角色類型', '男性角色', '1boy', 0),
      _tag('role_person', '角色類型', '人物', '1person', 0),
      _tag('role_original', '角色類型', '原創角色', 'original', 0),
      _tag('role_elf', '角色類型', '精靈', 'elf', 0),
      _tag('role_catgirl', '角色類型', '貓娘', 'catgirl', 0),
      _tag('role_bunnygirl', '角色類型', '兔女郎角色', 'bunny girl', 0),
      _tag('role_witch', '角色類型', '魔女', 'witch', 0),
      _tag('role_android', '角色類型', '仿生人/機器人', 'android', 0),
      _tag('role_fairy', '角色類型', '妖精', 'fairy', 0),
      _tag('role_tomboy', '角色類型', '假小子', 'tomboy', 0),

      // Appearance and body.
      _tag('trait_long_hair', '外觀特徵', '長髮', 'long hair', 1),
      _tag('trait_short_hair', '外觀特徵', '短髮', 'short hair', 1),
      _tag('trait_hair_between_eyes', '外觀特徵', '瀏海遮眼', 'hair between eyes', 1),
      _tag('trait_blonde_hair', '外觀特徵', '金髮', 'blonde hair', 1),
      _tag('trait_black_hair', '外觀特徵', '黑髮', 'black hair', 1),
      _tag('trait_silver_hair', '外觀特徵', '銀髮', 'silver hair', 1),
      _tag('trait_blue_hair', '外觀特徵', '藍髮', 'blue hair', 1),
      _tag('trait_red_hair', '外觀特徵', '紅髮', 'red hair', 1),
      _tag('trait_pink_hair', '外觀特徵', '粉紅髮', 'pink hair', 1),
      _tag('trait_green_eyes', '外觀特徵', '綠眼睛', 'green eyes', 1),
      _tag('trait_blue_eyes', '外觀特徵', '藍眼睛', 'blue eyes', 1),
      _tag('trait_red_eyes', '外觀特徵', '紅眼睛', 'red eyes', 1),
      _tag('trait_purple_eyes', '外觀特徵', '紫眼睛', 'purple eyes', 1),
      _tag('trait_tall', '外觀特徵', '高挑身材', 'tall', 1),
      _tag('trait_curvy', '外觀特徵', '曲線身材', 'curvy', 1),
      _tag('trait_slim', '外觀特徵', '纖細身材', 'slim', 1),
      _tag('trait_mature', '外觀特徵', '成熟外貌（成年）', 'mature female', 1),
      _tag('trait_makeup', '外觀特徵', '化妝', 'makeup', 1),
      _tag('trait_earrings', '外觀特徵', '耳環', 'earrings', 1),
      _tag('trait_necklace', '外觀特徵', '項鍊', 'necklace', 1),
      _tag('trait_tattoo', '外觀特徵', '刺青', 'tattoo', 1),
      _tag('trait_nail_polish', '外觀特徵', '指甲油', 'nail polish', 1),

      // Hairstyle types.
      _tag('hair_very_short', '髮型', '極短髮', 'very short hair', 1,
          conflictGroup: 'hair_length'),
      _tag('hair_medium', '髮型', '中長髮', 'medium hair', 1,
          conflictGroup: 'hair_length'),
      _tag('hair_very_long', '髮型', '超長髮', 'very long hair', 1,
          conflictGroup: 'hair_length'),
      _tag('hair_bob_cut', '髮型', '鮑伯頭', 'bob cut', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_pixie_cut', '髮型', '精靈短髮', 'pixie cut', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_straight', '髮型', '直髮', 'straight hair', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_wavy', '髮型', '波浪髮', 'wavy hair', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_curly', '髮型', '捲髮', 'curly hair', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_messy', '髮型', '凌亂髮', 'messy hair', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_spiky', '髮型', '刺蝟頭', 'spiky hair', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_ponytail', '髮型', '馬尾', 'ponytail', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_high_ponytail', '髮型', '高馬尾', 'high ponytail', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_low_ponytail', '髮型', '低馬尾', 'low ponytail', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_side_ponytail', '髮型', '側馬尾', 'side ponytail', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_twintails', '髮型', '雙馬尾', 'twintails', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_short_twintails', '髮型', '短雙馬尾', 'short twintails', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_low_twintails', '髮型', '低雙馬尾', 'low twintails', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_single_braid', '髮型', '單辮子', 'single braid', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_twin_braids', '髮型', '雙辮子', 'twin braids', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_side_braid', '髮型', '側辮子', 'side braid', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_french_braid', '髮型', '法式辮子', 'french braid', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_bun', '髮型', '髮髻', 'hair bun', 1, conflictGroup: 'hair_style'),
      _tag('hair_double_bun', '髮型', '雙丸子頭', 'double bun', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_odango', '髮型', '丸子頭', 'odango', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_side_bun', '髮型', '側髮髻', 'side bun', 1,
          conflictGroup: 'hair_style'),
      _tag('hair_drill', '髮型', '鑽頭捲', 'drill hair', 1,
          conflictGroup: 'hair_style'),

      // Clothing, intentionally split into practical sub-groups.
      _tag('clothing_tshirt', '上衣', 'T恤', 't-shirt', 2),
      _tag('clothing_shirt', '上衣', '襯衫', 'shirt', 2),
      _tag('clothing_sweater', '上衣', '毛衣', 'sweater', 2),
      _tag('clothing_hoodie', '上衣', '連帽衫', 'hoodie', 2),
      _tag('clothing_jacket', '上衣', '夾克', 'jacket', 2),
      _tag('clothing_crop_top', '上衣', '短版上衣', 'crop top', 2),
      _tag('clothing_off_shoulder', '上衣', '露肩上衣', 'off-shoulder shirt', 2),
      _tag('clothing_blouse', '上衣', '女式襯衫', 'blouse', 2),
      _tag('clothing_jeans', '褲子', '牛仔褲', 'jeans', 2),
      _tag('clothing_shorts', '褲子', '短褲', 'shorts', 2),
      _tag('clothing_hotpants', '褲子', '熱褲', 'hot pants', 2),
      _tag('clothing_trousers', '褲子', '長褲', 'trousers', 2),
      _tag('clothing_leggings', '褲子', '內搭褲', 'leggings', 2),
      _tag('clothing_skirt', '裙子', '裙子', 'skirt', 2),
      _tag('clothing_miniskirt', '裙子', '迷你裙', 'miniskirt', 2),
      _tag('clothing_pleated_skirt', '裙子', '百褶裙', 'pleated skirt', 2),
      _tag('clothing_short_skirt', '裙子', '短裙', 'short skirt', 2),
      _tag('clothing_knee_length_skirt', '裙子', '及膝裙', 'knee-length skirt', 2),
      _tag('clothing_midi_skirt', '裙子', '中長裙', 'midi skirt', 2),
      _tag('clothing_maxi_skirt', '裙子', '超長裙', 'maxi skirt', 2),
      _tag('clothing_pencil_skirt', '裙子', '鉛筆裙', 'pencil skirt', 2),
      _tag('clothing_a_line_skirt', '裙子', 'A字裙', 'a-line skirt', 2),
      _tag('clothing_circle_skirt', '裙子', '傘裙', 'circle skirt', 2),
      _tag('clothing_tiered_skirt', '裙子', '蛋糕裙', 'tiered skirt', 2),
      _tag('clothing_tutu_skirt', '裙子', '芭蕾舞裙', 'tutu skirt', 2),
      _tag('clothing_wrap_skirt', '裙子', '裹身裙', 'wrap skirt', 2),
      _tag('clothing_slit_skirt', '裙子', '開衩裙', 'slit skirt', 2),
      _tag('clothing_denim_skirt', '裙子', '牛仔裙', 'denim skirt', 2),
      _tag('clothing_dress', '服裝', '洋裝', 'dress', 2),
      _tag('clothing_sundress', '服裝', '夏日洋裝', 'sundress', 2),
      _tag('clothing_school_uniform', '服裝', '校服', 'school uniform', 2),
      _tag('clothing_business_suit', '服裝', '商務套裝', 'business suit', 2),
      _tag('clothing_kimono', '服裝', '和服', 'kimono', 2),
      _tag('clothing_apron', '服裝', '圍裙', 'apron', 2),
      _tag('clothing_swimsuit', '服裝', '泳裝', 'swimsuit', 2),
      _tag('clothing_bikini', '服裝', '比基尼', 'bikini', 2),
      _tag('clothing_bra', '胸罩', '胸罩', 'bra', 2, adult: true),
      _tag('clothing_sports_bra', '胸罩', '運動胸罩', 'sports bra', 2),
      _tag('clothing_lace_bra', '胸罩', '蕾絲胸罩', 'lace bra', 2, adult: true),
      _tag('clothing_panties', '內褲', '內褲', 'panties', 2, adult: true),
      _tag(
        'clothing_highleg_panties',
        '內褲',
        '高衩內褲',
        'highleg panties',
        2,
        adult: true,
      ),
      _tag('clothing_thong', '內褲', '丁字褲', 'thong', 2, adult: true),
      _tag('clothing_socks', '襪子', '短襪', 'socks', 2),
      _tag('clothing_kneehighs', '襪子', '膝上襪', 'kneehighs', 2),
      _tag('clothing_thighhighs', '襪子', '大腿襪', 'thighhighs', 2),
      _tag('clothing_pantyhose', '襪子', '連褲襪', 'pantyhose', 2),
      _tag('clothing_fishnet', '襪子', '網襪', 'fishnet legwear', 2),
      _tag('clothing_sneakers', '鞋子', '運動鞋', 'sneakers', 2),
      _tag('clothing_boots', '鞋子', '靴子', 'boots', 2),
      _tag('clothing_high_heels', '鞋子', '高跟鞋', 'high heels', 2),
      _tag('clothing_sandals', '鞋子', '涼鞋', 'sandals', 2),
      _tag('clothing_gloves', '配件', '手套', 'gloves', 2),
      _tag('clothing_ribbon', '配件', '蝴蝶結', 'hair ribbon', 2),
      _tag('clothing_choker', '配件', '頸圈', 'choker', 2),
      _tag('clothing_hat', '配件', '帽子', 'hat', 2),
      _tag('clothing_glasses', '配件', '眼鏡', 'glasses', 2),
      _tag('accessory_color_black', '配件顏色', '黑色配件', 'black accessory', 2,
          conflictGroup: 'accessory_color'),
      _tag('accessory_color_white', '配件顏色', '白色配件', 'white accessory', 2,
          conflictGroup: 'accessory_color'),
      _tag('accessory_color_red', '配件顏色', '紅色配件', 'red accessory', 2,
          conflictGroup: 'accessory_color'),
      _tag('accessory_color_blue', '配件顏色', '藍色配件', 'blue accessory', 2,
          conflictGroup: 'accessory_color'),
      _tag('accessory_color_pink', '配件顏色', '粉紅色配件', 'pink accessory', 2,
          conflictGroup: 'accessory_color'),
      _tag('accessory_color_purple', '配件顏色', '紫色配件', 'purple accessory', 2,
          conflictGroup: 'accessory_color'),
      _tag('accessory_color_green', '配件顏色', '綠色配件', 'green accessory', 2,
          conflictGroup: 'accessory_color'),
      _tag('accessory_color_yellow', '配件顏色', '黃色配件', 'yellow accessory', 2,
          conflictGroup: 'accessory_color'),
      _tag('accessory_color_brown', '配件顏色', '棕色配件', 'brown accessory', 2,
          conflictGroup: 'accessory_color'),
      _tag('accessory_color_gold', '配件顏色', '金色配件', 'gold accessory', 2,
          conflictGroup: 'accessory_color'),
      _tag('accessory_color_silver', '配件顏色', '銀色配件', 'silver accessory', 2,
          conflictGroup: 'accessory_color'),
      _tag('accessory_color_multicolored', '配件顏色', '多彩配件',
          'multicolored accessory', 2,
          conflictGroup: 'accessory_color'),

      // Additional underwear, sock and footwear styles.
      _tag('bra_underwire', '胸罩', '鋼圈胸罩', 'underwire bra', 2,
          adult: true, conflictGroup: 'bra'),
      _tag('bra_push_up', '胸罩', '集中型胸罩', 'push-up bra', 2,
          adult: true, conflictGroup: 'bra'),
      _tag('bra_bralette', '胸罩', '無鋼圈胸罩', 'bralette', 2,
          adult: true, conflictGroup: 'bra'),
      _tag('bra_triangle', '胸罩', '三角罩杯胸罩', 'triangle bra', 2,
          adult: true, conflictGroup: 'bra'),
      _tag('bra_racerback', '胸罩', '工字背胸罩', 'racerback bra', 2,
          adult: true, conflictGroup: 'bra'),
      _tag('bra_front_clasp', '胸罩', '前扣式胸罩', 'front-clasp bra', 2,
          adult: true, conflictGroup: 'bra'),
      _tag('underwear_slip', '內衣', '襯裙式內衣', 'slip', 2,
          adult: true, conflictGroup: 'underwear_top'),
      _tag('underwear_long', '內衣', '保暖內衣', 'long underwear', 2,
          conflictGroup: 'underwear_top'),
      _tag('underwear_thermal', '內衣', '發熱內衣', 'thermal underwear', 2,
          conflictGroup: 'underwear_top'),
      _tag('underwear_bodystocking', '內衣', '連身襪衣', 'bodystocking', 2,
          adult: true, conflictGroup: 'underwear_top'),
      _tag('lace_panties', '內褲', '蕾絲內褲', 'lace panties', 2,
          adult: true, conflictGroup: 'underwear_bottom'),
      _tag('cotton_panties', '內褲', '棉質內褲', 'cotton panties', 2,
          adult: true, conflictGroup: 'underwear_bottom'),
      _tag('highwaist_panties', '內褲', '高腰內褲', 'high-waisted panties', 2,
          adult: true, conflictGroup: 'underwear_bottom'),
      _tag('lowrise_panties', '內褲', '低腰內褲', 'low-rise panties', 2,
          adult: true, conflictGroup: 'underwear_bottom'),
      _tag('boyshorts', '內褲', '男孩褲式內褲', 'boyshorts', 2,
          adult: true, conflictGroup: 'underwear_bottom'),
      _tag('cheeky_panties', '內褲', '半露臀內褲', 'cheeky panties', 2,
          adult: true, conflictGroup: 'underwear_bottom'),
      _tag('side_tie_panties', '內褲', '側綁帶內褲', 'side-tie panties', 2,
          adult: true, conflictGroup: 'underwear_bottom'),
      _tag('leg_warmers', '襪子', '腿套', 'leg warmers', 2,
          conflictGroup: 'legwear'),
      _tag('crew_socks', '襪子', '中筒襪', 'crew socks', 2,
          conflictGroup: 'legwear'),
      _tag('over_knee_socks', '襪子', '過膝襪', 'over-knee socks', 2,
          conflictGroup: 'legwear'),
      _tag('toe_socks', '襪子', '五趾襪', 'toe socks', 2, conflictGroup: 'legwear'),
      _tag('tabi_socks', '襪子', '分趾襪', 'tabi socks', 2,
          conflictGroup: 'legwear'),
      _tag('ankle_boots', '鞋子', '踝靴', 'ankle boots', 2,
          conflictGroup: 'footwear'),
      _tag('knee_high_boots', '鞋子', '膝上靴', 'knee-high boots', 2,
          conflictGroup: 'footwear'),
      _tag('mary_janes', '鞋子', '瑪莉珍鞋', 'mary janes', 2,
          conflictGroup: 'footwear'),
      _tag('pumps', '鞋子', '淺口高跟鞋', 'pumps', 2, conflictGroup: 'footwear'),
      _tag('platform_shoes', '鞋子', '厚底鞋', 'platform shoes', 2,
          conflictGroup: 'footwear'),
      _tag('flip_flops', '鞋子', '夾腳拖鞋', 'flip-flops', 2,
          conflictGroup: 'footwear'),
      _tag('slippers', '鞋子', '拖鞋', 'slippers', 2, conflictGroup: 'footwear'),
      _tag('geta', '鞋子', '木屐', 'geta', 2, conflictGroup: 'footwear'),
      _tag('roller_skates', '鞋子', '溜冰鞋', 'roller skates', 2,
          conflictGroup: 'footwear'),
      ..._clothingColorTags(
          'underwear_color', '內衣顏色', '內衣', 'underwear', 'underwear_top_color',
          adult: true),
      ..._clothingColorTags('bra_color', '胸罩顏色', '胸罩', 'bra', 'bra_color',
          adult: true),
      ..._clothingColorTags(
          'panties_color', '內褲顏色', '內褲', 'panties', 'underwear_bottom_color',
          adult: true),
      ..._clothingColorTags(
          'socks_color', '襪子顏色', '襪子', 'socks', 'legwear_color'),
      ..._clothingColorTags(
          'shoes_color', '鞋子顏色', '鞋子', 'shoes', 'footwear_color'),

      // Face tags and expressions.
      _tag('face_smile', '表情', '微笑', 'smile', 3),
      _tag('face_grin', '表情', '咧嘴笑', 'grin', 3),
      _tag('face_open_mouth', '表情', '張嘴', 'open mouth', 3),
      _tag('face_blush', '表情', '臉紅', 'blush', 3),
      _tag('face_looking_at_viewer', '表情', '看向觀眾', 'looking at viewer', 3),
      _tag('face_closed_eyes', '表情', '閉眼', 'closed eyes', 3),
      _tag('face_wink', '表情', '眨眼', 'wink', 3),
      _tag('face_sweatdrop', '表情', '汗滴', 'sweatdrop', 3),
      _tag('face_tears', '表情', '眼淚', 'tears', 3),
      _tag('face_surprised', '表情', '驚訝', 'surprised', 3),
      _tag('face_embarrassed', '表情', '害羞', 'embarrassed', 3),
      _tag('face_serious', '表情', '嚴肅', 'serious', 3),
      _tag('face_angry', '表情', '生氣', 'angry', 3),
      _tag('face_lust', '表情', '情慾表情（成年角色）', 'ahegao', 3, adult: true),
      _tag('face_orgasm', '表情', '高潮表情（成年角色）', 'orgasm', 3, adult: true),

      // More face and expression details commonly used with Amanatsu / Illustrious.
      _tag('expr_closed_mouth', '表情', '閉嘴', 'closed mouth', 3,
          conflictGroup: 'expression_mouth'),
      _tag('expr_parted_lips', '表情', '微張嘴唇', 'parted lips', 3,
          conflictGroup: 'expression_mouth'),
      _tag('expr_pout', '表情', '噘嘴', 'pout', 3,
          conflictGroup: 'expression_mouth'),
      _tag('expr_puckered_lips', '表情', '嘟嘴', 'puckered lips', 3,
          conflictGroup: 'expression_mouth'),
      _tag('expr_tongue_out', '表情', '吐舌', 'tongue out', 3,
          conflictGroup: 'expression_mouth'),
      _tag('expr_biting_lip', '表情', '咬唇', 'biting lip', 3,
          conflictGroup: 'expression_mouth'),
      _tag('expr_clenched_teeth', '表情', '咬緊牙關', 'clenched teeth', 3,
          conflictGroup: 'expression_mouth'),
      _tag('expr_one_eye_closed', '表情', '單眼閉起', 'one eye closed', 3,
          conflictGroup: 'expression_eyes'),
      _tag('expr_half_closed_eyes', '表情', '半閉眼', 'half-closed eyes', 3,
          conflictGroup: 'expression_eyes'),
      _tag('expr_narrowed_eyes', '表情', '瞇眼', 'narrowed eyes', 3,
          conflictGroup: 'expression_eyes'),
      _tag('expr_sleepy_eyes', '表情', '惺忪睡眼', 'sleepy eyes', 3,
          conflictGroup: 'expression_eyes'),
      _tag('expr_looking_at_viewer', '表情', '看向觀眾', 'looking at viewer', 3,
          conflictGroup: 'expression_eyes'),
      _tag('expr_looking_away', '表情', '移開視線', 'looking away', 3,
          conflictGroup: 'expression_eyes'),
      _tag('expr_looking_up', '表情', '向上看', 'looking up', 3,
          conflictGroup: 'expression_eyes'),
      _tag('expr_looking_down', '表情', '向下看', 'looking down', 3,
          conflictGroup: 'expression_eyes'),
      _tag('expr_sideways_glance', '表情', '側眼看', 'sideways glance', 3,
          conflictGroup: 'expression_eyes'),
      _tag('expr_sparkling_eyes', '表情', '閃亮眼睛', 'sparkling eyes', 3,
          conflictGroup: 'expression_eyes'),
      _tag('expr_heart_shaped_pupils', '表情', '愛心瞳孔', 'heart-shaped pupils', 3,
          adult: true, conflictGroup: 'expression_eyes'),
      _tag('expr_nose_blush', '表情', '鼻頭泛紅', 'nose blush', 3,
          conflictGroup: 'expression_face_detail'),
      _tag('expr_sweatdrop', '表情', '汗滴', 'sweatdrop', 3,
          conflictGroup: 'expression_face_detail'),
      _tag('expr_steam_from_nose', '表情', '鼻子冒氣', 'steam from nose', 3,
          conflictGroup: 'expression_face_detail'),
      _tag('expr_anger_vein', '表情', '青筋', 'anger vein', 3,
          conflictGroup: 'expression_face_detail'),
      _tag('expr_facial_mark', '表情', '臉部符號', 'facial mark', 3,
          conflictGroup: 'expression_face_detail'),
      _tag('expr_sad', '表情', '悲傷', 'sad', 3, conflictGroup: 'expression_mood'),
      _tag('expr_crying', '表情', '哭泣', 'crying', 3,
          conflictGroup: 'expression_mood'),
      _tag('expr_scared', '表情', '害怕', 'scared', 3,
          conflictGroup: 'expression_mood'),
      _tag('expr_nervous', '表情', '緊張', 'nervous', 3,
          conflictGroup: 'expression_mood'),
      _tag('expr_worried', '表情', '擔心', 'worried', 3,
          conflictGroup: 'expression_mood'),
      _tag('expr_confident', '表情', '自信', 'confident', 3,
          conflictGroup: 'expression_mood'),
      _tag('expr_smug', '表情', '得意', 'smug', 3,
          conflictGroup: 'expression_mood'),
      _tag('expr_seductive', '表情', '誘惑表情', 'seductive expression', 3,
          adult: true, conflictGroup: 'expression_mood'),
      _tag('expr_seductive_smile', '表情', '誘惑微笑', 'seductive smile', 3,
          adult: true, conflictGroup: 'expression_mood'),

      // Pose/action.
      _tag('pose_standing', '姿勢', '站立', 'standing', 4),
      _tag('pose_sitting', '姿勢', '坐著', 'sitting', 4),
      _tag('pose_kneeling', '姿勢', '跪姿', 'kneeling', 4),
      _tag('pose_lying', '姿勢', '躺著', 'lying', 4),
      _tag('pose_lying_on_side', '姿勢', '側躺', 'lying on side', 4),
      _tag('pose_lying_on_back', '姿勢', '仰躺', 'lying on back', 4),
      _tag('pose_squatting', '姿勢', '蹲姿', 'squatting', 4),
      _tag('pose_arms_up', '姿勢', '雙手舉起', 'arms up', 4),
      _tag('pose_hand_on_hip', '姿勢', '手放在腰上', 'hand on hip', 4),
      _tag('pose_leaning', '姿勢', '倚靠', 'leaning', 4),
      _tag('pose_bent_over', '姿勢', '彎腰', 'bent over', 4, adult: true),
      _tag('pose_presenting', '姿勢', '展示姿勢（成年角色）', 'presenting', 4, adult: true),
      _tag('pose_ass_up', '姿勢', '臀部抬起（成年角色）', 'ass up', 4, adult: true),
      _tag('pose_from_behind', '姿勢', '從後方視角', 'from behind', 4),
      _tag('pose_selfie', '姿勢', '自拍姿勢', 'selfie', 4),
      _tag('pose_sitting_chair', '姿勢', '坐在椅子上', 'sitting on chair', 4,
          conflictGroup: 'basic_pose'),
      _tag('pose_sitting_bed', '姿勢', '坐在床上', 'sitting on bed', 4,
          conflictGroup: 'basic_pose'),
      _tag('pose_sitting_floor', '姿勢', '坐在地上', 'sitting on floor', 4,
          conflictGroup: 'basic_pose'),
      _tag('pose_sitting_sofa', '姿勢', '坐在沙發上', 'sitting on sofa', 4,
          conflictGroup: 'basic_pose'),
      _tag('pose_sitting_bench', '姿勢', '坐在長椅上', 'sitting on bench', 4,
          conflictGroup: 'basic_pose'),
      _tag('pose_standing_straight', '姿勢', '立正站立', 'standing straight', 4,
          conflictGroup: 'basic_pose'),
      _tag('pose_standing_one_leg', '姿勢', '單腳站立', 'standing on one leg', 4,
          conflictGroup: 'basic_pose'),
      _tag('pose_standing_crossed_legs', '姿勢', '交叉腿站立',
          'standing with crossed legs', 4,
          conflictGroup: 'basic_pose'),
      _tag('pose_standing_legs_apart', '姿勢', '分腿站立', 'standing with legs apart',
          4,
          conflictGroup: 'basic_pose'),
      _tag('pose_standing_tiptoes', '姿勢', '踮腳站立', 'standing on tiptoes', 4,
          conflictGroup: 'basic_pose'),
      _tag('pose_lying_back', '姿勢', '仰躺', 'lying on back', 4,
          conflictGroup: 'basic_pose'),
      _tag('pose_lying_stomach', '姿勢', '趴躺', 'lying on stomach', 4,
          conflictGroup: 'basic_pose'),
      _tag('pose_lying_bed', '姿勢', '躺在床上', 'lying on bed', 4,
          conflictGroup: 'basic_pose'),
      _tag('pose_lying_floor', '姿勢', '躺在地上', 'lying on floor', 4,
          conflictGroup: 'basic_pose'),
      _tag('pose_one_leg_up', '姿勢', '抬起單腳', 'one leg raised', 4,
          conflictGroup: 'leg_raise'),
      _tag('pose_left_leg_up', '姿勢', '抬起左腳', 'left leg raised', 4,
          conflictGroup: 'left_leg_raise'),
      _tag('pose_right_leg_up', '姿勢', '抬起右腳', 'right leg raised', 4,
          conflictGroup: 'right_leg_raise'),
      _tag('pose_both_legs_up', '姿勢', '抬起雙腳', 'both legs raised', 4,
          conflictGroup: 'leg_raise'),
      _tag('pose_thigh_raised', '姿勢', '抬起大腿', 'raised thigh', 4,
          conflictGroup: 'leg_detail'),
      _tag('pose_lower_leg_raised', '姿勢', '抬起小腿', 'raised lower leg', 4,
          conflictGroup: 'leg_detail'),
      _tag('pose_bent_leg', '姿勢', '彎曲腿部', 'bent leg', 4,
          conflictGroup: 'leg_detail'),
      _tag('pose_left_hand_up', '姿勢', '抬起左手', 'left hand raised', 4,
          conflictGroup: 'left_arm_pose'),
      _tag('pose_right_hand_up', '姿勢', '抬起右手', 'right hand raised', 4,
          conflictGroup: 'right_arm_pose'),
      _tag('pose_one_hand_up', '姿勢', '抬起單手', 'one hand raised', 4,
          conflictGroup: 'arm_pose'),
      _tag('pose_both_hands_up', '姿勢', '抬起雙手', 'both hands raised', 4,
          conflictGroup: 'arm_pose'),
      _tag('pose_waving', '姿勢', '揮手', 'waving', 4,
          conflictGroup: 'hand_gesture'),
      _tag('pose_hands_together', '姿勢', '雙手合十', 'hands together', 4,
          conflictGroup: 'hand_gesture'),
      _tag('pose_hands_behind_back', '姿勢', '雙手放在背後', 'hands behind back', 4,
          conflictGroup: 'hand_gesture'),
      _tag('pose_hand_on_head', '姿勢', '手放在頭上', 'hand on head', 4,
          conflictGroup: 'hand_gesture'),
      _tag('pose_peace_sign', '姿勢', '比出和平手勢', 'peace sign', 4,
          conflictGroup: 'hand_gesture'),
      _tag('pose_pointing', '姿勢', '指向前方', 'pointing', 4,
          conflictGroup: 'hand_gesture'),
      _tag('pose_head_up', '姿勢', '抬頭', 'looking up', 4,
          conflictGroup: 'head_vertical'),
      _tag('pose_head_down', '姿勢', '低頭', 'looking down', 4,
          conflictGroup: 'head_vertical'),
      _tag('pose_head_tilt_left', '姿勢', '頭向左歪', 'head tilt left', 4,
          conflictGroup: 'head_tilt'),
      _tag('pose_head_tilt_right', '姿勢', '頭向右歪', 'head tilt right', 4,
          conflictGroup: 'head_tilt'),
      _tag('pose_head_turn_left', '姿勢', '頭轉向左側', 'head turned left', 4,
          conflictGroup: 'head_direction'),
      _tag('pose_head_turn_right', '姿勢', '頭轉向右側', 'head turned right', 4,
          conflictGroup: 'head_direction'),

      // Dynamic actions and sports poses.
      _tag('action_basketball_shooting', '動作', '投籃', 'shooting basketball', 4),
      _tag(
          'action_basketball_dribbling', '動作', '運球', 'dribbling basketball', 4),
      _tag('action_basketball_dunk', '動作', '灌籃', 'dunking', 4),
      _tag('action_soccer_kicking', '動作', '踢足球', 'kicking soccer ball', 4),
      _tag('action_soccer_dribbling', '動作', '足球帶球', 'dribbling soccer ball', 4),
      _tag('action_baseball_batting', '動作', '打棒球', 'batting', 4),
      _tag('action_baseball_pitching', '動作', '投棒球', 'pitching', 4),
      _tag('action_tennis_swing', '動作', '揮網球拍', 'swinging tennis racket', 4),
      _tag('action_volleyball_spiking', '動作', '排球扣球', 'spiking volleyball', 4),
      _tag('action_badminton_swing', '動作', '揮羽球拍', 'swinging badminton racket',
          4),
      _tag('action_archery', '動作', '射箭', 'drawing bow', 4),
      _tag('action_aiming', '動作', '瞄準', 'aiming', 4),
      _tag('action_sword_swinging', '動作', '揮劍', 'sword swinging', 4),
      _tag('action_fencing', '動作', '擊劍', 'fencing', 4),
      _tag('action_running', '動作', '奔跑', 'running', 4),
      _tag('action_jumping', '動作', '跳躍', 'jumping', 4),
      _tag('action_dancing', '動作', '跳舞', 'dancing', 4),
      _tag('action_skating', '動作', '溜冰', 'ice skating', 4),
      _tag('action_swimming', '動作', '游泳', 'swimming', 4),
      _tag('action_cycling', '動作', '騎腳踏車', 'cycling', 4),
      _tag('action_climbing', '動作', '攀爬', 'climbing', 4),
      _tag('action_punching', '動作', '出拳', 'punching', 4),
      _tag('action_kicking', '動作', '踢腿', 'kicking', 4),
      _tag('action_throwing', '動作', '投擲', 'throwing', 4),
      _tag('action_playing_guitar', '動作', '彈吉他', 'playing guitar', 4),
      _tag('action_playing_piano', '動作', '彈鋼琴', 'playing piano', 4),
      _tag('action_reading', '動作', '閱讀', 'reading', 4),
      _tag('action_writing', '動作', '書寫', 'writing', 4),
      _tag('action_painting', '動作', '繪畫', 'painting', 4),
      _tag('action_photographing', '動作', '拍照', 'photography', 4),
      _tag('action_using_phone', '動作', '使用手機', 'using smartphone', 4),
      _tag('action_typing', '動作', '打字', 'typing', 4),
      _tag('action_cooking', '動作', '烹飪', 'cooking', 4),
      _tag('action_eating', '動作', '吃東西', 'eating', 4),
      _tag('action_drinking', '動作', '喝東西', 'drinking', 4),

      // Common props and handheld objects.
      _tag('object_basketball', '物件', '籃球', 'basketball', 4),
      _tag('object_soccer_ball', '物件', '足球', 'soccer ball', 4),
      _tag('object_volleyball', '物件', '排球', 'volleyball', 4),
      _tag('object_baseball', '物件', '棒球', 'baseball', 4),
      _tag('object_baseball_bat', '物件', '棒球棒', 'baseball bat', 4),
      _tag('object_tennis_racket', '物件', '網球拍', 'tennis racket', 4),
      _tag('object_badminton_racket', '物件', '羽球拍', 'badminton racket', 4),
      _tag('object_bow', '物件', '弓', 'bow', 4),
      _tag('object_arrow', '物件', '箭', 'arrow', 4),
      _tag('object_sword', '物件', '劍', 'sword', 4),
      _tag('object_shield', '物件', '盾牌', 'shield', 4),
      _tag('object_umbrella', '物件', '雨傘', 'umbrella', 4),
      _tag('object_camera', '物件', '相機', 'camera', 4),
      _tag('object_smartphone', '物件', '智慧型手機', 'smartphone', 4),
      _tag('object_laptop', '物件', '筆記型電腦', 'laptop', 4),
      _tag('object_tablet', '物件', '平板電腦', 'tablet', 4),
      _tag('object_headphones', '物件', '耳機', 'headphones', 4),
      _tag('object_book', '物件', '書本', 'book', 4),
      _tag('object_notebook', '物件', '筆記本', 'notebook', 4),
      _tag('object_pen', '物件', '原子筆', 'pen', 4),
      _tag('object_pencil', '物件', '鉛筆', 'pencil', 4),
      _tag('object_backpack', '物件', '背包', 'backpack', 4),
      _tag('object_handbag', '物件', '手提包', 'handbag', 4),
      _tag('object_briefcase', '物件', '公事包', 'briefcase', 4),
      _tag('object_water_bottle', '物件', '水瓶', 'water bottle', 4),
      _tag('object_cup', '物件', '杯子', 'cup', 4),
      _tag('object_mug', '物件', '馬克杯', 'mug', 4),
      _tag('object_plate', '物件', '盤子', 'plate', 4),
      _tag('object_fork', '物件', '叉子', 'fork', 4),
      _tag('object_spoon', '物件', '湯匙', 'spoon', 4),
      _tag('object_chopsticks', '物件', '筷子', 'chopsticks', 4),
      _tag('object_microphone', '物件', '麥克風', 'microphone', 4),
      _tag('object_guitar', '物件', '吉他', 'guitar', 4),
      _tag('object_violin', '物件', '小提琴', 'violin', 4),
      _tag('object_piano', '物件', '鋼琴', 'piano', 4),
      _tag('object_paintbrush', '物件', '畫筆', 'paintbrush', 4),
      _tag('object_palette', '物件', '調色盤', 'palette', 4),
      _tag('object_flower', '物件', '花朵', 'flower', 4),
      _tag('object_bouquet', '物件', '花束', 'bouquet', 4),
      _tag('object_balloon', '物件', '氣球', 'balloon', 4),
      _tag('object_teddy_bear', '物件', '泰迪熊', 'teddy bear', 4),
      _tag('object_stuffed_toy', '物件', '玩偶', 'stuffed toy', 4),
      _tag('object_skateboard', '物件', '滑板', 'skateboard', 4),
      _tag('object_bicycle', '物件', '腳踏車', 'bicycle', 4),
      _tag('object_candle', '物件', '蠟燭', 'candle', 4),
      _tag('object_key', '物件', '鑰匙', 'key', 4),
      _tag('object_gift', '物件', '禮物', 'present', 4),

      // Adult-only accessories and toys; hidden until 18+ categories are enabled.
      _tag('adult_vibrator', '成人道具', '按摩器（成年角色）', 'vibrator', 5, adult: true),
      _tag('adult_wand_vibrator', '成人道具', '魔法棒型按摩器（成年角色）', 'wand vibrator', 5,
          adult: true),
      _tag('adult_dildo', '成人道具', '假陰莖（成年角色）', 'dildo', 5, adult: true),
      _tag('adult_strap_on', '成人道具', '穿戴式假陰莖（成年角色）', 'strap-on dildo', 5,
          adult: true),
      _tag('adult_butt_plug', '成人道具', '肛塞（成年角色）', 'butt plug', 5, adult: true),
      _tag('adult_anal_beads', '成人道具', '肛珠（成年角色）', 'anal beads', 5,
          adult: true),
      _tag('adult_love_egg', '成人道具', '跳蛋（成年角色）', 'love egg', 5, adult: true),
      _tag('adult_remote_vibrator', '成人道具', '遙控按摩器（成年角色）',
          'remote-controlled vibrator', 5,
          adult: true),
      _tag('adult_handcuffs', '成人道具', '手銬（成年角色）', 'handcuffs', 5, adult: true),
      _tag('adult_blindfold', '成人道具', '眼罩（成年角色）', 'blindfold', 5, adult: true),

      // Breasts and nudity groups based on the supplied Danbooru references.
      _tag('body_flat_chest', '胸部', '平胸', 'flat chest', 5),
      _tag('body_small_breasts', '胸部', '小胸', 'small breasts', 5),
      _tag('body_medium_breasts', '胸部', '中等胸部', 'medium breasts', 5),
      _tag('body_large_breasts', '胸部', '大胸', 'large breasts', 5),
      _tag('body_huge_breasts', '胸部', '巨乳', 'huge breasts', 5, adult: true),
      _tag('body_breasts', '胸部', '胸部可見', 'breasts', 5, adult: true),
      _tag('body_cleavage', '胸部', '乳溝', 'cleavage', 5, adult: true),
      _tag('body_nipples', '胸部', '乳頭可見', 'nipples', 5, adult: true),
      _tag('body_breast_press', '胸部', '胸部擠壓', 'breast press', 5, adult: true),
      _tag('nudity_nude', '裸露', '裸體', 'nude', 6, adult: true),
      _tag('nudity_topless', '裸露', '上空', 'topless', 6, adult: true),
      _tag('nudity_bottomless', '裸露', '下空', 'bottomless', 6, adult: true),
      _tag('nudity_bare_shoulders', '裸露', '裸肩', 'bare shoulders', 6),
      _tag('nudity_bare_legs', '裸露', '裸腿', 'bare legs', 6),
      _tag('nudity_barefoot', '裸露', '赤腳', 'barefoot', 6),
      _tag('nudity_midriff', '裸露', '露腰', 'midriff', 6),
      _tag(
        'nudity_covering_breasts',
        '裸露',
        '遮住胸部',
        'covering breasts',
        6,
        adult: true,
      ),
      _tag(
        'nudity_covering_crotch',
        '裸露',
        '遮住胯部',
        'covering crotch',
        6,
        adult: true,
      ),

      // Sex acts and sexual positions. All are adult-only and off by the adult filter.
      _tag('act_sex', '性行為', '性行為（成年角色）', 'sex', 7, adult: true),
      _tag('act_vaginal', '性行為', '陰道性交（成年角色）', 'vaginal', 7, adult: true),
      _tag('act_anal', '性行為', '肛交（成年角色）', 'anal', 7, adult: true),
      _tag('act_oral', '性行為', '口交（成年角色）', 'oral', 7, adult: true),
      _tag('act_blowjob', '性行為', '口交行為（成年角色）', 'blowjob', 7, adult: true),
      _tag('act_handjob', '性行為', '手交（成年角色）', 'handjob', 7, adult: true),
      _tag('act_fingering', '性行為', '手指刺激（成年角色）', 'fingering', 7, adult: true),
      _tag('act_masturbation', '性行為', '自慰（成年角色）', 'masturbation', 7,
          adult: true),
      _tag('act_kissing', '性行為', '接吻', 'kissing', 7),
      _tag('act_french_kiss', '性行為', '法式接吻（成年角色）', 'french kiss', 7,
          adult: true),
      _tag('act_grinding', '性行為', '磨蹭（成年角色）', 'grinding', 7, adult: true),
      _tag('act_bondage', '性行為', '束縛（成年角色）', 'bondage', 7, adult: true),
      _tag('act_bdsm', '性行為', 'BDSM（成年角色）', 'bdsm', 7, adult: true),
      _tag('act_cum', '性行為', '體液（成年角色）', 'cum', 7, adult: true),
      _tag('act_cumshot', '性行為', '射精畫面（成年角色）', 'cumshot', 7, adult: true),
      _tag('act_sweat', '性行為', '汗水', 'sweat', 7),
      _tag(
        'position_missionary',
        '性姿勢',
        '傳教士體位（成年角色）',
        'missionary',
        8,
        adult: true,
      ),
      _tag(
        'position_cowgirl',
        '性姿勢',
        '女上位（成年角色）',
        'cowgirl position',
        8,
        adult: true,
      ),
      _tag(
        'position_reverse_cowgirl',
        '性姿勢',
        '背向女上位（成年角色）',
        'reverse cowgirl',
        8,
        adult: true,
      ),
      _tag('position_doggystyle', '性姿勢', '後入式（成年角色）', 'doggystyle', 8,
          adult: true),
      _tag(
        'position_standing_sex',
        '性姿勢',
        '站立性交（成年角色）',
        'standing sex',
        8,
        adult: true,
      ),
      _tag('position_riding', '性姿勢', '騎乘（成年角色）', 'riding', 8, adult: true),
      _tag('position_sixty_nine', '性姿勢', '六九式（成年角色）', 'sixty-nine', 8,
          adult: true),
      _tag('position_group_sex', '性姿勢', '多人性行為（成年角色）', 'group sex', 8,
          adult: true),

      // Scene, camera and model-friendly quality terms.
      _tag('scene_bedroom', '場景', '臥室', 'bedroom', 9),
      _tag('scene_bathroom', '場景', '浴室', 'bathroom', 9),
      _tag('scene_classroom', '場景', '教室', 'classroom', 9),
      _tag('scene_beach', '場景', '海灘', 'beach', 9),
      _tag('scene_cherry_blossoms', '場景', '櫻花樹下', 'cherry blossoms', 9),
      _tag('scene_night', '場景', '夜晚', 'night', 9),
      _tag('scene_sunset', '場景', '日落', 'sunset', 9),
      _tag('scene_simple_background', '場景', '簡單背景', 'simple background', 9),
      _tag('camera_portrait', '畫面', '肖像構圖', 'portrait', 10),
      _tag('camera_full_body', '畫面', '全身', 'full body', 10),
      _tag('camera_upper_body', '畫面', '上半身', 'upper body', 10),
      _tag('camera_close_up', '畫面', '特寫', 'close-up', 10),
      _tag('camera_cowboy_shot', '畫面', '膝上構圖', 'cowboy shot', 10),
      _tag('camera_from_above', '畫面', '俯視', 'from above', 10),
      _tag('camera_from_below', '畫面', '仰視', 'from below', 10),
      _tag('camera_pov', '畫面', '第一人稱視角', 'pov', 10),
      _tag('camera_birds_eye', '畫面', '鳥瞰視角', 'birds-eye', 10),
      _tag('camera_wide_shot', '畫面', '遠景鏡頭', 'wide shot', 10),
      _tag('camera_isometric', '畫面', '等角視角', 'isometric', 10),
      _tag('camera_high_angle', '畫面', '高角度視角', 'high-angle view', 10),
      _tag('camera_low_angle', '畫面', '低角度視角', 'low-angle view', 10),
      _tag('camera_eye_level', '畫面', '平視角度', 'eye-level shot', 10),
      _tag('camera_front_view', '畫面', '正面視角', 'front view', 10),
      _tag('camera_side_view', '畫面', '側面視角', 'side view', 10),
      _tag('camera_rear_view', '畫面', '背面視角', 'rear view', 10),
      _tag('camera_three_quarter', '畫面', '三分之四視角', 'three-quarter view', 10),
      _tag('camera_over_shoulder', '畫面', '越肩視角', 'over-the-shoulder view', 10),
      _tag('quality_masterpiece', '品質', '傑作', 'masterpiece', 11),
      _tag('quality_best_quality', '品質', '最佳品質', 'best quality', 11),
      _tag('quality_newest', '品質', '最新風格', 'newest', 11),
      _tag('quality_absurdres', '品質', '超高解析', 'absurdres', 11),
      _tag('quality_highres', '品質', '高解析', 'highres', 11),
      _tag('quality_score8', '品質', '高品質評分', 'score_8', 11),
      _tag('quality_detailed', '品質', '高度細節', 'highly detailed', 11),
      _tag('quality_anime', '品質', '動漫風格', 'anime style', 11),
      _tag(
        'quality_anatomically_correct',
        '品質',
        '解剖結構正確',
        'anatomically correct',
        11,
      ),
      _tag(
          'quality_proper_proportions', '品質', '比例正確', 'proper proportions', 11),
      _tag('quality_clear_composition', '品質', '清晰構圖', 'clear composition', 11),
      _tag(
        'quality_professional_lighting',
        '品質',
        '專業打光',
        'professional lighting',
        11,
      ),
      _tag('quality_cinematic_light', '品質', '電影感光線', 'cinematic light', 11),
      _tag('quality_soft_shadows', '品質', '柔和陰影', 'soft shadows', 11),
      _tag(
        'quality_detailed_environment',
        '品質',
        '細節環境',
        'detailed environment',
        11,
      ),
      _tag('quality_soft_lighting', '品質', '柔和光線', 'soft lighting', 11),
      _tag('quality_detailed_eyes', '品質', '精細眼睛', 'detailed eyes', 11),
    ];

class PromptBuilderApp extends StatefulWidget {
  const PromptBuilderApp({super.key});

  @override
  State<PromptBuilderApp> createState() => _PromptBuilderAppState();
}

class _PromptBuilderAppState extends State<PromptBuilderApp> {
  final List<TagItem> _builtIns = _seedTags().map((tag) {
    const mergedHairIds = {
      'trait_long_hair',
      'trait_short_hair',
      'trait_hair_between_eyes',
      'trait_blonde_hair',
      'trait_black_hair',
      'trait_silver_hair',
      'trait_blue_hair',
      'trait_red_hair',
      'trait_pink_hair',
    };
    if (!mergedHairIds.contains(tag.id)) return tag;
    return TagItem(
      id: tag.id,
      group: '髮型',
      zh: tag.zh,
      en: tag.en,
      order: tag.order,
      adult: tag.adult,
      builtIn: tag.builtIn,
      conflictGroup: tag.conflictGroup,
    );
  }).toList();
  final List<TagItem> _supplemental =
      supplementalTags.map(_catalogTag).toList();
  final Set<String> _selectedIds = <String>{};
  final Map<int, Set<String>> _personSelectedIds = <int, Set<String>>{};
  final Map<int, Set<String>> _removedCharacterTags = <int, Set<String>>{};
  final Map<int, String> _personTagQueries = <int, String>{};
  final Map<String, String> _personActiveGroups = <String, String>{};
  final List<TagItem> _customTags = <TagItem>[];
  final List<CatalogCharacter> _customCharacters = <CatalogCharacter>[];
  final Map<int, List<_RemoteAnime>> _remoteAnimeResults =
      <int, List<_RemoteAnime>>{};
  final Map<int, _RemoteAnime> _remoteAnimeSelection = <int, _RemoteAnime>{};
  final Map<int, List<_RemoteCharacter>> _remoteCharacters =
      <int, List<_RemoteCharacter>>{};
  final Set<int> _remoteLookupLoading = <int>{};
  final Map<int, String> _remoteLookupErrors = <int, String>{};
  final List<PersonSlot> _personSlots = <PersonSlot>[PersonSlot()];
  final List<String> _recentCharacterIds = <String>[];
  final List<Preset> _presets = <Preset>[];
  final Map<String, TextEditingController> _personSearchControllers =
      <String, TextEditingController>{};
  final Map<int, GlobalKey> _stepKeys = <int, GlobalKey>{};
  final TextEditingController _search = TextEditingController();
  final TextEditingController _extraPositive = TextEditingController();
  final TextEditingController _negative = TextEditingController(
    text: _defaultNegativeText,
  );
  final Map<String, String> _customNegativeTranslations = <String, String>{};
  final TextEditingController _preprompt = TextEditingController(
    text: 'masterpiece, best quality, newest, absurdres, highres',
  );

  String _activeGroup = '全部';
  String _gender = '女性';
  String _model = 'Amanatsu 1.1';
  String _sampler = 'Euler a';
  int _steps = 28;
  String _cfg = '5.0';
  String _clipSkip = '2';
  int _peopleCount = 1;
  int _stepIndex = 0;
  bool _showAdult = false;
  bool _groupPeoplePrompt = true;
  bool _showInfo = true;

  List<TagItem> get _allTags =>
      [..._builtIns, ..._supplemental, ..._customTags];

  List<CatalogCharacter> get _allCharacters =>
      [...catalogCharacters, ..._customCharacters];

  List<TagItem> get _selectedTags {
    final tags =
        _allTags.where((tag) => _selectedIds.contains(tag.id)).toList();
    tags.sort(_compareOutputTags);
    return tags;
  }

  int _outputGroupOrder(String group) {
    const order = <String, int>{
      '外觀特徵': 10,
      '臉部特徵': 11,
      '胸部': 12,
      '裸露': 13,
      '髮型': 14,
      '服裝': 20,
      '服裝風格': 21,
      '服裝顏色': 22,
      '上衣': 23,
      '上衣風格': 24,
      '上衣顏色': 25,
      '褲子': 26,
      '裙子': 26,
      '下身風格': 27,
      '下身顏色': 28,
      '內衣': 30,
      '內衣顏色': 31,
      '胸罩': 31,
      '胸罩顏色': 32,
      '內褲': 32,
      '內褲顏色': 33,
      '襪子': 33,
      '襪子顏色': 34,
      '鞋子': 34,
      '鞋子顏色': 35,
      '配件': 35,
      '配件顏色': 36,
      '服裝細節': 37,
      '服裝材質': 38,
      '穿脫狀態': 39,
      '表情': 40,
      '姿勢': 41,
      '性行為': 42,
      '性姿勢': 43,
      '動作': 44,
      '物件': 45,
      '成人道具': 46,
      '場景': 60,
      '畫面': 61,
    };
    return order[group] ?? 50;
  }

  int _compareOutputTags(TagItem a, TagItem b) {
    final groupOrder =
        _outputGroupOrder(a.group).compareTo(_outputGroupOrder(b.group));
    if (groupOrder != 0) return groupOrder;
    final catalogOrder = a.order.compareTo(b.order);
    return catalogOrder == 0 ? a.en.compareTo(b.en) : catalogOrder;
  }

  Set<String> _personTagIds(int index) =>
      _personSelectedIds.putIfAbsent(index, () => <String>{});

  List<TagItem> _selectedTagsForPerson(int index) {
    final ids = _personTagIds(index);
    final tags = _allTags.where((tag) => ids.contains(tag.id)).toList();
    tags.sort(_compareOutputTags);
    return tags;
  }

  int get _personSelectedCount =>
      _personSelectedIds.values.fold(0, (total, ids) => total + ids.length);

  List<String> get _groups => [
        '全部',
        ..._allTags.map((tag) => tag.group).toSet(),
      ];

  @override
  void initState() {
    super.initState();
    _restore();
    _checkForVersionUpdate();
    _search.addListener(() => setState(() {}));
  }

  void _checkForVersionUpdate() {
    final previous = html.window.localStorage[_lastSeenVersionKey];
    html.window.localStorage[_lastSeenVersionKey] = appVersionLabel;
    if (previous != null && previous != appVersionLabel) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showVersionHistory(previous);
      });
    }
  }

  void _showVersionHistory([String? previousVersion]) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.new_releases_outlined),
            const SizedBox(width: 8),
            Text('版本更新 $appVersionLabel'),
          ],
        ),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (previousVersion != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text('已從 $previousVersion 更新到 $appVersionLabel。'),
                  ),
                ...appVersionHistory.map(
                  (release) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${release['label']} · ${release['date']}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 3),
                        Text(release['notes'] ?? ''),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _search.dispose();
    _extraPositive.dispose();
    _negative.dispose();
    _preprompt.dispose();
    for (final controller in _personSearchControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _personSearchController(
      int index, String field, String value) {
    final key = '$index:$field';
    final controller = _personSearchControllers.putIfAbsent(
        key, () => TextEditingController(text: value));
    if (controller.text != value) {
      controller.text = value;
    }
    return controller;
  }

  void _clearPersonSearchController(int index, String field) {
    _personSearchControllers['$index:$field']?.clear();
  }

  void _restore() {
    final raw = html.window.localStorage[_storageKey];
    if (raw == null) return;
    try {
      final data = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      _customTags.addAll(
        (data['customTags'] as List? ?? []).map(
          (item) => TagItem.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
      _customCharacters.addAll(
        (data['customCharacters'] as List? ?? [])
            .map(
              (item) => CatalogCharacter.fromJson(
                  Map<String, dynamic>.from(item as Map)),
            )
            .map(_normalizeImportedAnime),
      );
      _personSlots
        ..clear()
        ..addAll(
          (data['personSlots'] as List? ?? []).map(
            (item) =>
                PersonSlot.fromJson(Map<String, dynamic>.from(item as Map)),
          ),
        );
      if (_personSlots.isEmpty) _personSlots.add(PersonSlot());
      // Older builds saved imported remote characters with a malformed mode
      // value. A non-empty characterId that points to the catalog is always
      // an anime-character slot, so repair it when restoring local memory.
      for (final slot in _personSlots) {
        if (slot.characterId.isEmpty) continue;
        for (final character in _allCharacters) {
          if (character.id != slot.characterId) continue;
          slot.mode = '動漫角色';
          slot.animeTag = character.animeTag;
          break;
        }
      }
      _recentCharacterIds.addAll(
        (data['recentCharacterIds'] as List? ?? []).map((id) => '$id'),
      );
      _presets.addAll(
        (data['presets'] as List? ?? []).map(
          (item) => Preset.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
      _selectedIds.addAll(
        (data['selectedIds'] as List? ?? []).map((id) => '$id'),
      );
      if (!data.containsKey('personSelectedIds')) {
        final legacyPersonal = _allTags
            .where((tag) =>
                _selectedIds.contains(tag.id) &&
                !['場景', '畫面', '品質'].contains(tag.group))
            .toList();
        if (legacyPersonal.isNotEmpty) {
          _personSelectedIds[0] = legacyPersonal.map((tag) => tag.id).toSet();
          _selectedIds.removeAll(legacyPersonal.map((tag) => tag.id));
        }
      }
      final personTags = data['personSelectedIds'] as Map?;
      if (personTags != null) {
        for (final entry in personTags.entries) {
          final index = int.tryParse('${entry.key}');
          if (index == null) continue;
          _personSelectedIds[index] =
              (entry.value as List? ?? []).map((id) => '$id').toSet();
        }
      }
      final removedCharacterTags = data['removedCharacterTags'] as Map?;
      if (removedCharacterTags != null) {
        for (final entry in removedCharacterTags.entries) {
          final index = int.tryParse('${entry.key}');
          if (index == null) continue;
          _removedCharacterTags[index] =
              (entry.value as List? ?? []).map((tag) => '$tag').toSet();
        }
      }
      _peopleCount = (data['peopleCount'] as num?)?.toInt() ?? 1;
      _stepIndex =
          ((data['stepIndex'] as num?)?.toInt() ?? 0).clamp(0, 6).toInt();
      _gender = '${data['gender'] ?? '女性'}';
      _model = '${data['model'] ?? 'Amanatsu 1.1'}';
      _sampler = '${data['sampler'] ?? 'Euler a'}';
      _steps = (data['steps'] as num?)?.toInt() ?? 28;
      _cfg = '${data['cfg'] ?? '5.0'}';
      _clipSkip = '${data['clipSkip'] ?? '2'}';
      _showAdult = data['showAdult'] == true;
      _groupPeoplePrompt = data['groupPeoplePrompt'] != false;
      _extraPositive.text = '${data['extraPositive'] ?? ''}';
      _negative.text = '${data['negative'] ?? _negative.text}';
      _customNegativeTranslations
        ..clear()
        ..addAll(Map<String, dynamic>.from(
          data['customNegativeTranslations'] as Map? ?? <String, dynamic>{},
        ).map((key, value) => MapEntry(key.toLowerCase(), '$value')));
      _preprompt.text = '${data['preprompt'] ?? _preprompt.text}';
      _peopleCount = _personSlots.length;
    } catch (_) {
      // A malformed local record should never stop the builder from opening.
    }
  }

  Map<String, dynamic> _snapshot() => {
        'selectedIds': _selectedIds.toList(),
        'personSelectedIds': _personSelectedIds.map(
          (index, ids) => MapEntry('$index', ids.toList()),
        ),
        'removedCharacterTags': _removedCharacterTags.map(
          (index, tags) => MapEntry('$index', tags.toList()),
        ),
        'customTags': _customTags.map((tag) => tag.toJson()).toList(),
        'customCharacters':
            _customCharacters.map((item) => item.toJson()).toList(),
        'personSlots': _personSlots.map((item) => item.toJson()).toList(),
        'recentCharacterIds': _recentCharacterIds,
        'presets': _presets.map((preset) => preset.toJson()).toList(),
        'peopleCount': _peopleCount,
        'stepIndex': _stepIndex,
        'gender': _gender,
        'model': _model,
        'sampler': _sampler,
        'steps': _steps,
        'cfg': _cfg,
        'clipSkip': _clipSkip,
        'showAdult': _showAdult,
        'groupPeoplePrompt': _groupPeoplePrompt,
        'extraPositive': _extraPositive.text,
        'negative': _negative.text,
        'customNegativeTranslations': _customNegativeTranslations,
        'preprompt': _preprompt.text,
      };

  void _persist() {
    html.window.localStorage[_storageKey] = jsonEncode(_snapshot());
  }

  String _peopleTag() {
    if (_gender == '女性')
      return _peopleCount == 1 ? '1girl' : '${_peopleCount}girls';
    if (_gender == '男性')
      return _peopleCount == 1 ? '1boy' : '${_peopleCount}boys';
    return _peopleCount == 1 ? '1person' : '${_peopleCount}people';
  }

  String _peopleZh() {
    final type = _gender == '女性'
        ? '女性角色'
        : _gender == '男性'
            ? '男性角色'
            : '人物';
    return '$_peopleCount 人$type';
  }

  List<String> _peopleTokensNew() {
    final female = _personSlots.where((slot) => slot.gender == '女性').length;
    final male = _personSlots.where((slot) => slot.gender == '男性').length;
    final other = _personSlots.length - female - male;
    final result = <String>[];
    if (female > 0) result.add(female == 1 ? '1girl' : '${female}girls');
    if (male > 0) result.add(male == 1 ? '1boy' : '${male}boys');
    if (other > 0) result.add(other == 1 ? '1other' : '${other}others');
    return result.isEmpty ? ['1person'] : result;
  }

  String _peopleTagNew() => _peopleTokensNew().join(', ');

  String _peopleZhNew() {
    final female = _personSlots.where((slot) => slot.gender == '女性').length;
    final male = _personSlots.where((slot) => slot.gender == '男性').length;
    final other = _personSlots.length - female - male;
    final result = <String>[];
    if (female > 0) result.add('$female 位女性角色');
    if (male > 0) result.add('$male 位男性角色');
    if (other > 0) result.add('$other 位其他/異種角色');
    return result.join('、');
  }

  CatalogCharacter? _characterForNew(PersonSlot slot) {
    if (slot.characterId.isEmpty) return null;
    for (final character in _allCharacters) {
      if (character.id == slot.characterId) return character;
    }
    return null;
  }

  Set<String> _traitOverrideGroups(String en) {
    final value = en.trim().toLowerCase();
    final groups = <String>{};
    if (RegExp(
            r'\b(blonde|black|silver|blue|red|pink|white|purple|aqua|brown|green|orange|yellow)\s+hair\b')
        .hasMatch(value)) {
      groups.add('hair_color');
    }
    if (RegExp(r'\b(very\s+short|very\s+long|long|medium|short)\s+hair\b')
        .hasMatch(value)) {
      groups.add('hair_length');
    }
    if (RegExp(
            r'\b(bob\s+cut|pixie\s+cut|straight\s+hair|wavy\s+hair|curly\s+hair|messy\s+hair|spiky\s+hair|braid|braids|ponytail|twintails|bun|odango|drill\s+hair)\b')
        .hasMatch(value)) {
      groups.add('hair_style');
    }
    if (RegExp(
            r'\b(green|blue|red|purple|yellow|aqua|brown|pink|orange)\s+eyes\b')
        .hasMatch(value)) {
      groups.add('eye_color');
    }
    if (['slim', 'tall', 'curvy', 'muscular', 'petite'].contains(value)) {
      groups.add('body_type');
    }
    if ([
      'flat chest',
      'small breasts',
      'medium breasts',
      'large breasts',
      'huge breasts'
    ].contains(value)) {
      groups.add('breast_size');
    }
    return groups;
  }

  Set<String> _personOverrideGroups(int index) => _selectedTagsForPerson(index)
      .expand((tag) => _traitOverrideGroups(tag.en))
      .toSet();

  Set<String> _removedCharacterTagSet(int index) =>
      _removedCharacterTags.putIfAbsent(index, () => <String>{});

  bool _isRemovedCharacterTag(int index, String english) =>
      _removedCharacterTagSet(index).contains(_cleanTag(english).toLowerCase());

  List<CatalogTagData> _characterTraitsForSlot(PersonSlot slot, int index) {
    final character = _characterForNew(slot);
    if (character == null) return const <CatalogTagData>[];
    final replaced = _personOverrideGroups(index);
    return character.traits
        .where((trait) =>
            _traitOverrideGroups(trait.en).intersection(replaced).isEmpty &&
            !_isRemovedCharacterTag(index, trait.en))
        .toList();
  }

  List<String> _characterTokensForSlot(PersonSlot slot, int index) {
    if (!slot.detailed) return [];
    if (slot.mode == '動漫角色') {
      final character = _characterForNew(slot);
      if (character == null) return [];
      return [
        if (!_isRemovedCharacterTag(index, character.animeTag))
          character.animeTag,
        if (!_isRemovedCharacterTag(index, character.characterTag))
          character.characterTag,
        ..._characterTraitsForSlot(slot, index).map((item) => item.en),
      ];
    }
    final own = <String>[];
    if (_cleanTag(slot.originalAnimeTag).isNotEmpty &&
        !_isRemovedCharacterTag(index, slot.originalAnimeTag)) {
      own.add(_cleanTag(slot.originalAnimeTag));
    }
    if (_cleanTag(slot.originalCharacterTag).isNotEmpty &&
        !_isRemovedCharacterTag(index, slot.originalCharacterTag)) {
      own.add(_cleanTag(slot.originalCharacterTag));
    }
    own.addAll(_extraTags(slot.originalTraits)
        .where((tag) => !_isRemovedCharacterTag(index, tag)));
    return own.isEmpty ? ['original'] : own;
  }

  List<_GeneratedOutputTag> _characterOutputTagsForSlot(
      PersonSlot slot, int index) {
    if (!slot.detailed) return const <_GeneratedOutputTag>[];
    if (slot.mode == '動漫角色') {
      final character = _characterForNew(slot);
      if (character == null) return const <_GeneratedOutputTag>[];
      final result = <_GeneratedOutputTag>[];
      if (!_isRemovedCharacterTag(index, character.animeTag)) {
        result.add(_GeneratedOutputTag(
          zh: character.animeZh,
          en: character.animeTag,
          personIndex: index,
          characterTag: true,
        ));
      }
      if (!_isRemovedCharacterTag(index, character.characterTag)) {
        result.add(_GeneratedOutputTag(
          zh: character.characterZh,
          en: character.characterTag,
          personIndex: index,
          characterTag: true,
        ));
      }
      for (final trait in _characterTraitsForSlot(slot, index)) {
        result.add(_GeneratedOutputTag(
          zh: trait.zh,
          en: trait.en,
          personIndex: index,
          characterTag: true,
        ));
      }
      return result;
    }
    final result = <_GeneratedOutputTag>[];
    final animeTag = _cleanTag(slot.originalAnimeTag);
    final characterTag = _cleanTag(slot.originalCharacterTag);
    if (animeTag.isNotEmpty && !_isRemovedCharacterTag(index, animeTag)) {
      result.add(_GeneratedOutputTag(
        zh: slot.originalAnimeZh.trim().isEmpty
            ? animeTag
            : slot.originalAnimeZh.trim(),
        en: animeTag,
        personIndex: index,
        characterTag: true,
      ));
    }
    if (characterTag.isNotEmpty &&
        !_isRemovedCharacterTag(index, characterTag)) {
      result.add(_GeneratedOutputTag(
        zh: slot.originalCharacterZh.trim().isEmpty
            ? characterTag
            : slot.originalCharacterZh.trim(),
        en: characterTag,
        personIndex: index,
        characterTag: true,
      ));
    }
    for (final trait in _extraTags(slot.originalTraits)) {
      final english = _positiveEnglishTag(trait);
      if (_isRemovedCharacterTag(index, english)) continue;
      result.add(_GeneratedOutputTag(
        zh: _positiveChineseTag(trait),
        en: english,
        personIndex: index,
        characterTag: true,
      ));
    }
    return result;
  }

  List<String> _characterChineseForSlot(PersonSlot slot, int index) {
    if (!slot.detailed) return ['此角色不設定細節'];
    if (slot.mode == '動漫角色' && _characterForNew(slot) == null) {
      return ['尚未選擇動漫角色'];
    }
    final tags = _characterOutputTagsForSlot(slot, index);
    if (tags.isNotEmpty) return tags.map((tag) => tag.zh).toList();
    return ['原創角色'];
  }

  List<String> _characterTokensNew() {
    final result = <String>[];
    for (var index = 0; index < _personSlots.length; index++) {
      result.addAll(_characterTokensForSlot(_personSlots[index], index));
    }
    return result;
  }

  List<String> _characterChineseNew() {
    final result = <String>[];
    for (var index = 0; index < _personSlots.length; index++) {
      result.addAll(_characterChineseForSlot(_personSlots[index], index));
    }
    return result;
  }

  List<_GeneratedOutputTag> _generatedPositiveTags() {
    final result = <_GeneratedOutputTag>[];
    for (var index = 0; index < _personSlots.length; index++) {
      final slot = _personSlots[index];
      result.addAll(_characterOutputTagsForSlot(slot, index));
      result.addAll(_selectedTagsForPerson(index).map((tag) =>
          _GeneratedOutputTag(
              zh: tag.zh, en: tag.en, tagId: tag.id, personIndex: index)));
    }
    result.addAll(_selectedTags.map(
        (tag) => _GeneratedOutputTag(zh: tag.zh, en: tag.en, tagId: tag.id)));
    return result;
  }

  void _removeGeneratedOutputTag(_GeneratedOutputTag outputTag) {
    setState(() {
      if (outputTag.characterTag) {
        if (outputTag.personIndex != null) {
          _removedCharacterTagSet(outputTag.personIndex!)
              .add(_cleanTag(outputTag.en).toLowerCase());
        }
      } else if (outputTag.tagId != null) {
        if (outputTag.personIndex == null) {
          _selectedIds.remove(outputTag.tagId);
        } else {
          _personTagIds(outputTag.personIndex!).remove(outputTag.tagId);
        }
      }
      _persist();
    });
  }

  String _cleanTag(String value) => value
      .trim()
      .replaceAll(RegExp(r'^[,，\s]+|[,，\s]+$'), '')
      .replaceAll(RegExp(r'\s+'), ' ');

  List<String> _extraTags(String value) => value
      .split(RegExp(r'[,，、。\n]+'))
      .map(_cleanTag)
      .where((item) => item.isNotEmpty)
      .toList();

  String _positiveEnglishTag(String value) {
    final cleaned = _cleanTag(value);
    if (cleaned.isEmpty || !RegExp(r'[\u4e00-\u9fff]').hasMatch(cleaned)) {
      return cleaned;
    }
    for (final tag in _allTags) {
      if (tag.zh == cleaned) return tag.en;
    }
    const replacements = <String, String>{
      '超長髮': 'very long hair',
      '極短髮': 'very short hair',
      '粉紅色': 'pink',
      '藍色': 'blue',
      '黑色': 'black',
      '白色': 'white',
      '紅色': 'red',
      '紫色': 'purple',
      '綠色': 'green',
      '黃色': 'yellow',
      '棕色': 'brown',
      '灰色': 'gray',
      '銀色': 'silver',
      '金色': 'gold',
      '長髮': 'long hair',
      '短髮': 'short hair',
      '蕾絲': 'lace',
      '花邊': 'frills',
      '哥德式': 'gothic',
      '晚禮服': 'evening gown',
      '長裙': 'long skirt',
      '短裙': 'short skirt',
      '迷你裙': 'miniskirt',
      '泳裝': 'swimsuit',
      '運動服': 'sportswear',
      '單肩': 'one shoulder',
      '連身': 'one-piece',
      '外套': 'jacket',
      '上衣': 'top',
      '洋裝': 'dress',
      '裙子': 'skirt',
      '褲子': 'pants',
      '短褲': 'shorts',
      '胸罩': 'bra',
      '內褲': 'panties',
      '內衣': 'underwear',
      '襪子': 'socks',
      '鞋子': 'shoes',
      '靴子': 'boots',
      '微笑': 'smile',
      '臉紅': 'blush',
      '哭泣': 'crying',
      '生氣': 'angry',
      '驚訝': 'surprised',
      '坐著': 'sitting',
      '站立': 'standing',
      '躺著': 'lying',
    };
    var translated = cleaned;
    final entries = replacements.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));
    for (final entry in entries) {
      translated = translated.replaceAll(entry.key, entry.value);
    }
    return translated;
  }

  String _positiveChineseTag(String value) {
    final cleaned = _cleanTag(value);
    if (cleaned.isEmpty || RegExp(r'[\u4e00-\u9fff]').hasMatch(cleaned)) {
      return cleaned;
    }
    for (final tag in _allTags) {
      if (tag.en.toLowerCase() == cleaned.toLowerCase()) return tag.zh;
    }
    const replacements = <String, String>{
      'very long hair': '超長髮',
      'very short hair': '極短髮',
      'long hair': '長髮',
      'short hair': '短髮',
      'blue': '藍色',
      'black': '黑色',
      'white': '白色',
      'red': '紅色',
      'pink': '粉紅色',
      'purple': '紫色',
      'green': '綠色',
      'yellow': '黃色',
      'brown': '棕色',
      'gray': '灰色',
      'silver': '銀色',
      'gold': '金色',
      'jacket': '外套',
      'top': '上衣',
      'dress': '洋裝',
      'skirt': '裙子',
      'pants': '褲子',
      'shorts': '短褲',
      'bra': '胸罩',
      'panties': '內褲',
      'underwear': '內衣',
      'socks': '襪子',
      'shoes': '鞋子',
      'boots': '靴子',
      'lace': '蕾絲',
      'smile': '微笑',
      'blush': '臉紅',
      'crying': '哭泣',
      'angry': '生氣',
      'surprised': '驚訝',
      'sitting': '坐著',
      'standing': '站立',
      'lying': '躺著',
    };
    var translated = cleaned;
    final entries = replacements.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));
    for (final entry in entries) {
      translated = translated.replaceAll(entry.key, entry.value);
    }
    return translated;
  }

  String? _hairLengthTag(String value) {
    final normalized = _cleanTag(value).toLowerCase();
    final match = RegExp(r'^(very short|very long|long|medium|short) hair$')
        .firstMatch(normalized);
    return match?.group(0);
  }

  String? _effectiveHairLength(PersonSlot slot, int index) {
    if (!slot.detailed) return null;
    for (final tag in _selectedTagsForPerson(index)) {
      final selectedLength = _hairLengthTag(tag.en);
      if (selectedLength != null) return selectedLength;
    }
    if (slot.mode == '動漫角色') {
      final character = _characterForNew(slot);
      if (character != null) {
        for (final trait in _characterTraitsForSlot(slot, index)) {
          final originalLength = _hairLengthTag(trait.en);
          if (originalLength != null) return originalLength;
        }
      }
    }
    for (final trait in _extraTags(slot.originalTraits)) {
      final originalLength = _hairLengthTag(trait);
      if (originalLength != null) return originalLength;
    }
    return null;
  }

  List<String> get _hairGuardNegativeTags {
    final lengths = <String>{};
    for (var index = 0; index < _personSlots.length; index++) {
      final length = _effectiveHairLength(_personSlots[index], index);
      if (length != null) lengths.add(length);
    }
    if (lengths.length != 1) return const <String>[];
    final result = <String>[];
    switch (lengths.first) {
      case 'short hair':
        result.add('long hair');
        break;
      case 'very short hair':
        result.add('long hair');
        break;
      case 'long hair':
      case 'very long hair':
        result.add('short hair');
        break;
      case 'medium hair':
        result.addAll(['short hair', 'long hair']);
        break;
    }
    final seen = <String>{};
    return result.where((tag) => seen.add(tag)).toList();
  }

  List<String> get _negativeTokens {
    final seen = <String>{};
    return [..._extraTags(_negative.text), ..._hairGuardNegativeTags]
        .where((tag) => seen.add(tag.toLowerCase()))
        .toList();
  }

  List<String> get _positiveTokens {
    final tokens = <String>[..._peopleTokensNew()];
    for (var index = 0; index < _personSlots.length; index++) {
      tokens.addAll(_characterTokensForSlot(_personSlots[index], index));
      tokens.addAll(_selectedTagsForPerson(index).map((tag) => tag.en));
    }
    tokens.addAll(_selectedTags.map((tag) => tag.en));
    tokens.addAll(_extraTags(_extraPositive.text).map(_positiveEnglishTag));
    tokens.addAll(_extraTags(_preprompt.text));
    final seen = <String>{};
    return tokens.where((token) => seen.add(token.toLowerCase())).toList();
  }

  List<String> _personPromptTokens(int index) => [
        ..._characterTokensForSlot(_personSlots[index], index),
        ..._selectedTagsForPerson(index).map((tag) => tag.en),
      ];

  List<String> get _sharedPositiveTokens => [
        ..._selectedTags.map((tag) => tag.en),
        ..._extraTags(_extraPositive.text).map(_positiveEnglishTag),
        ..._extraTags(_preprompt.text),
      ];

  String _groupedPositiveText() {
    final output = <String>[];
    final used = <String>{};
    void addTokens(Iterable<String> values) {
      output.addAll(values
          .where((value) => used.add(_cleanTag(value).toLowerCase()))
          .map((value) => '$value.'));
    }

    addTokens(_peopleTokensNew());
    for (var index = 0; index < _personSlots.length; index++) {
      final personal = _personPromptTokens(index)
          .where((value) => !used.contains(_cleanTag(value).toLowerCase()))
          .toList();
      if (personal.isEmpty) continue;
      personal.forEach((value) => used.add(_cleanTag(value).toLowerCase()));
      output.add('(${personal.join(', ')}:1.15).');
    }
    addTokens(_sharedPositiveTokens);
    return output.join(' ');
  }

  String get _positiveText => _groupPeoplePrompt && _personSlots.length > 1
      ? _groupedPositiveText()
      : _positiveTokens.map((tag) => '$tag.').join(' ');

  String get _positiveZh {
    final tokens = <String>[_peopleZhNew()];
    for (var index = 0; index < _personSlots.length; index++) {
      final personal = [
        ..._characterChineseForSlot(_personSlots[index], index),
        ..._selectedTagsForPerson(index).map((tag) => tag.zh),
      ];
      tokens.add('人物 ${index + 1}：${personal.join('、')}');
    }
    tokens.addAll(_selectedTags.map((tag) => tag.zh));
    if (_extraPositive.text.trim().isNotEmpty) {
      tokens.add(
        '額外正向標籤（中文對照）：${_extraTags(_extraPositive.text).map(_positiveChineseTag).join('、')}',
      );
    }
    if (_preprompt.text.trim().isNotEmpty)
      tokens.add('Amanatsu 品質前綴：${_preprompt.text.trim()}');
    return tokens.join('。 ');
  }

  String _negativeTranslation(String tag) {
    final custom = _customNegativeTranslations[tag.toLowerCase()];
    if (custom != null && custom.trim().isNotEmpty) return custom;
    const translations = {
      'lowres': '低解析度',
      'worst quality': '最差品質',
      'bad quality': '低品質',
      'bad anatomy': '解剖結構錯誤',
      'bad hands': '手部錯誤',
      'extra digits': '多餘手指',
      'fewer digits': '手指數量不足',
      'multiple views': '多視角',
      'extra limbs': '多餘肢體',
      'missing fingers': '缺少手指',
      'deformed': '變形',
      'poorly drawn face': '臉部繪製不佳',
      'text': '文字',
      'error': '錯誤',
      'jpeg artifacts': 'JPEG 壓縮痕跡',
      'watermark': '浮水印',
      'logo': '標誌',
      'signature': '簽名',
      'unfinished': '未完成',
      'displeasing': '令人不適的畫面',
      'username': '使用者名稱',
      'scan artifacts': '掃描痕跡',
      'sketch': '草稿',
      'monochrome': '單色',
      'greyscale': '灰階',
      'guro': '血腥獵奇',
      'artist name': '藝術家名稱',
      'old': '老舊風格',
      'early': '早期風格',
      'chromatic aberration': '色差',
      'artistic error': '藝術錯誤',
      'short hair': '短髮',
      'very short hair': '極短髮',
      'long hair': '長髮',
      'very long hair': '超長髮',
      'medium hair': '中長髮',
    };
    return translations[tag.toLowerCase()] ??
        (RegExp(r'[\u4e00-\u9fff]').hasMatch(tag) ? tag : '未內建翻譯：$tag');
  }

  String get _negativeZh =>
      _negativeTokens.map((tag) => '${_negativeTranslation(tag)}。').join(' ');

  String get _negativeText => _negativeTokens.map((tag) => '$tag.').join(' ');

  void _toggleNegativeTag(String english, String chinese) {
    final tags = _extraTags(_negative.text);
    final index = tags.indexWhere(
      (item) => item.toLowerCase() == english.toLowerCase(),
    );
    setState(() {
      if (index >= 0) {
        tags.removeAt(index);
      } else {
        tags.add(english);
      }
      _customNegativeTranslations[english.toLowerCase()] = chinese;
      _negative.text = tags.join(', ');
      _persist();
    });
  }

  Future<void> _addNegativeTag() async {
    final englishController = TextEditingController();
    final chineseController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('新增負面標籤'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: englishController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '英文標籤',
                hintText: '例如 blurry 或 bad composition',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: chineseController,
              decoration: const InputDecoration(
                labelText: '中文翻譯',
                hintText: '例如 模糊 或 構圖不佳',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('加入'),
          ),
        ],
      ),
    );
    final english = _cleanTag(englishController.text);
    final chinese = _cleanTag(chineseController.text).ifEmpty(english);
    englishController.dispose();
    chineseController.dispose();
    if (confirmed != true || english.isEmpty) return;
    final tags = _extraTags(_negative.text);
    if (!tags.any((item) => item.toLowerCase() == english.toLowerCase())) {
      tags.add(english);
    }
    setState(() {
      _negative.text = tags.join(', ');
      _customNegativeTranslations[english.toLowerCase()] = chinese;
      _persist();
    });
  }

  Widget _negativeTagPicker() {
    final selected =
        _extraTags(_negative.text).map((item) => item.toLowerCase()).toSet();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: _negativeCatalog.map((item) {
            final english = item['en']!;
            final chinese = item['zh']!;
            return FilterChip(
              label: Text('$chinese / $english'),
              selected: selected.contains(english.toLowerCase()),
              onSelected: (_) => _toggleNegativeTag(english, chinese),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _addNegativeTag,
          icon: const Icon(Icons.add),
          label: const Text('新增負面標籤（中英文）'),
        ),
      ],
    );
  }

  String? _conflictGroup(TagItem tag) {
    if (tag.group == '內衣') return 'underwear_top';
    if (tag.group == '內褲') return 'underwear_bottom';
    if (tag.group == '胸罩') return 'bra';
    if (tag.group == '內衣顏色') return 'underwear_top_color';
    if (tag.group == '內褲顏色') return 'underwear_bottom_color';
    if (tag.group == '胸罩顏色') return 'bra_color';
    if (tag.group == '襪子顏色') return 'legwear_color';
    if (tag.group == '鞋子顏色') return 'footwear_color';
    if (tag.conflictGroup != null) return tag.conflictGroup;
    final traitGroups = _traitOverrideGroups(tag.en);
    if (traitGroups.isNotEmpty) return traitGroups.first;
    if (tag.group == '上衣風格') return 'top_style';
    if (tag.group == '下身風格') return 'bottom_style';
    if (tag.group == '上衣顏色') return 'top_color';
    if (tag.group == '下身顏色') return 'bottom_color';
    if (tag.group == '服裝顏色') return 'clothing_color';
    if (tag.group == '配件顏色') return 'accessory_color';
    if (tag.group == '上衣') return 'top';
    if (['褲子', '裙子'].contains(tag.group)) return 'bottom';
    if (tag.group == '胸罩') return 'bra';
    if (['內衣', '內褲'].contains(tag.group)) return 'underwear';
    if (['服裝', '服裝風格'].contains(tag.group)) return 'one_piece';
    if (tag.group == '姿勢') {
      const basicPoses = {
        'standing',
        'sitting',
        'kneeling',
        'lying',
        'lying on side',
        'lying on back',
        'squatting',
      };
      if (basicPoses.contains(tag.en)) return 'basic_pose';
      if (tag.en == 'arms up') return 'arm_pose';
      if (tag.en == 'hand on hip') return 'hand_gesture';
      return 'pose';
    }
    if (tag.group == '性姿勢') return 'sex_position';
    if (tag.group == '場景') return 'scene';
    if (tag.group == '畫面') {
      const framing = {
        'portrait',
        'full body',
        'upper body',
        'close-up',
        'cowboy shot',
        'wide shot',
      };
      return framing.contains(tag.en) ? 'framing' : 'camera';
    }
    if (tag.group == '穿脫狀態') return 'wear_state';
    if (tag.group == '胸部' &&
        [
          'flat chest',
          'small breasts',
          'medium breasts',
          'large breasts',
          'huge breasts'
        ].contains(tag.en)) return 'breast_size';
    if (tag.group == '表情' && ['closed mouth', 'open mouth'].contains(tag.en))
      return 'mouth';
    if (tag.group == '表情' && ['wink', 'closed eyes'].contains(tag.en))
      return 'eyes';
    return null;
  }

  bool _tagsConflict(TagItem first, TagItem second) {
    final firstGroup = _conflictGroup(first);
    final secondGroup = _conflictGroup(second);
    if (firstGroup != null && firstGroup == secondGroup) {
      return firstGroup != 'clothing_color';
    }
    if ((firstGroup == 'arm_pose' &&
            {'left_arm_pose', 'right_arm_pose'}.contains(secondGroup)) ||
        (secondGroup == 'arm_pose' &&
            {'left_arm_pose', 'right_arm_pose'}.contains(firstGroup))) {
      return true;
    }
    final clothingLayers = {
      'top',
      'bottom',
      'top_color',
      'bottom_color',
      'top_style',
      'bottom_style'
    };
    if ((firstGroup == 'one_piece' && clothingLayers.contains(secondGroup)) ||
        (secondGroup == 'one_piece' && clothingLayers.contains(firstGroup))) {
      return true;
    }
    final firstNude =
        first.en == 'nude' || first.en == 'topless' || first.en == 'bottomless';
    final secondNude = second.en == 'nude' ||
        second.en == 'topless' ||
        second.en == 'bottomless';
    if (firstNude || secondNude) {
      final clothing = {
        'top',
        'bottom',
        'top_color',
        'bottom_color',
        'top_style',
        'bottom_style',
        'one_piece'
      };
      if ((firstNude && clothing.contains(secondGroup)) ||
          (secondNude && clothing.contains(firstGroup))) return true;
    }
    return false;
  }

  TagItem? _randomClothingTag(List<String> groups, Random random) {
    final seen = <String>{};
    final candidates = _allTags
        .where((tag) =>
            groups.contains(tag.group) &&
            (_showAdult || !tag.adult) &&
            seen.add('${tag.group}|${tag.en}'))
        .toList()
      ..shuffle(random);
    return candidates.isEmpty ? null : candidates.first;
  }

  void _randomizeClothing(int personIndex) {
    if (personIndex < 0 || personIndex >= _personSlots.length) return;
    final random = Random();
    final clothingGroups = {
      '上衣',
      '褲子',
      '裙子',
      '內衣',
      '胸罩',
      '內褲',
      '襪子',
      '鞋子',
      '服裝',
      '配件',
      '配件顏色',
      '內衣顏色',
      '胸罩顏色',
      '內褲顏色',
      '襪子顏色',
      '鞋子顏色',
      '服裝風格',
      '上衣風格',
      '下身風格',
      '上衣顏色',
      '下身顏色',
      '服裝顏色',
      '服裝細節',
      '服裝材質',
      '穿脫狀態',
    };
    final target = _personTagIds(personIndex);
    target.removeWhere((id) => _allTags
        .any((tag) => tag.id == id && clothingGroups.contains(tag.group)));

    void add(TagItem? tag) {
      if (tag != null) target.add(tag.id);
    }

    if (random.nextBool()) {
      add(_randomClothingTag(['服裝', '服裝風格'], random));
      add(_randomClothingTag(['服裝顏色'], random));
    } else {
      add(_randomClothingTag(['上衣'], random));
      add(_randomClothingTag(['褲子', '裙子'], random));
      if (random.nextBool()) add(_randomClothingTag(['上衣風格'], random));
      if (random.nextBool()) add(_randomClothingTag(['下身風格'], random));
      if (random.nextBool()) add(_randomClothingTag(['上衣顏色'], random));
      if (random.nextBool()) add(_randomClothingTag(['下身顏色'], random));
    }
    if (random.nextBool()) add(_randomClothingTag(['胸罩'], random));
    if (random.nextBool()) add(_randomClothingTag(['內衣'], random));
    if (random.nextBool()) add(_randomClothingTag(['內褲'], random));
    if (random.nextBool()) add(_randomClothingTag(['襪子'], random));
    if (random.nextBool()) add(_randomClothingTag(['鞋子'], random));
    if (random.nextBool()) add(_randomClothingTag(['穿脫狀態'], random));
    if (random.nextBool()) add(_randomClothingTag(['服裝材質'], random));

    final detailCandidates = _allTags
        .where((tag) => tag.group == '服裝細節' && (_showAdult || !tag.adult))
        .toList()
      ..shuffle(random);
    for (final tag in detailCandidates.take(1 + random.nextInt(3))) {
      target.add(tag.id);
    }
    final accessoryCandidates = _allTags
        .where((tag) => tag.group == '配件' && (_showAdult || !tag.adult))
        .toList()
      ..shuffle(random);
    for (final tag in accessoryCandidates.take(random.nextInt(3))) {
      target.add(tag.id);
    }
    if (accessoryCandidates.isNotEmpty && random.nextDouble() < 0.8) {
      add(_randomClothingTag(['配件顏色'], random));
    }
    bool hasTargetGroup(String group) => target
        .any((id) => _allTags.any((tag) => tag.id == id && tag.group == group));
    if (hasTargetGroup('內衣') && random.nextBool()) {
      add(_randomClothingTag(['內衣顏色'], random));
    }
    if (hasTargetGroup('胸罩') && random.nextBool()) {
      add(_randomClothingTag(['胸罩顏色'], random));
    }
    if (hasTargetGroup('內褲') && random.nextBool()) {
      add(_randomClothingTag(['內褲顏色'], random));
    }
    if (hasTargetGroup('襪子') && random.nextBool()) {
      add(_randomClothingTag(['襪子顏色'], random));
    }
    if (hasTargetGroup('鞋子') && random.nextBool()) {
      add(_randomClothingTag(['鞋子顏色'], random));
    }

    setState(() {
      _persist();
    });
  }

  Future<void> _toggle(TagItem tag, {int? personIndex}) async {
    final targetIds =
        personIndex == null ? _selectedIds : _personTagIds(personIndex);
    final currentTags = personIndex == null
        ? _selectedTags
        : _selectedTagsForPerson(personIndex);
    if (personIndex != null &&
        tag.group == '服裝顏色' &&
        !currentTags.any((item) => _conflictGroup(item) == 'one_piece')) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('請先選擇連身裝，才可以設定連身裝顏色。')));
      return;
    }
    if (targetIds.contains(tag.id)) {
      setState(() {
        targetIds.remove(tag.id);
        _persist();
      });
      return;
    }
    if (personIndex != null &&
        !(await _confirmCharacterOverride(tag, personIndex))) {
      return;
    }
    final conflicts =
        currentTags.where((item) => _tagsConflict(item, tag)).toList();
    if (conflicts.isNotEmpty) {
      final replace = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('標籤可能互相衝突'),
          content: Text(
              '目前已有「${conflicts.map((item) => item.zh).join('、')}」。\n加入「${tag.zh}」會移除原標籤，是否更換？'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('保留原標籤')),
            FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('移除原標籤並更換')),
          ],
        ),
      );
      if (replace != true) return;
    }
    setState(() {
      for (final conflict in conflicts) {
        targetIds.remove(conflict.id);
      }
      targetIds.add(tag.id);
      _persist();
    });
  }

  Future<bool> _confirmCharacterOverride(TagItem tag, int personIndex) async {
    if (personIndex < 0 || personIndex >= _personSlots.length) return true;
    final slot = _personSlots[personIndex];
    if (slot.mode != '動漫角色') return true;
    final character = _characterForNew(slot);
    final selectedGroups = _traitOverrideGroups(tag.en);
    if (character == null || selectedGroups.isEmpty) return true;
    if (_selectedTagsForPerson(personIndex).any((selected) =>
        _traitOverrideGroups(selected.en)
            .intersection(selectedGroups)
            .isNotEmpty)) {
      return true;
    }
    final replaced = character.traits
        .where((trait) => _traitOverrideGroups(trait.en)
            .intersection(selectedGroups)
            .isNotEmpty)
        .toList();
    if (replaced.isEmpty) return true;
    final original = replaced.map((item) => '${item.zh}（${item.en}）').join('、');
    final apply = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('這會覆寫角色原始特徵'),
        content: Text('角色「${character.characterZh}」原本包含：$original。\n\n'
            '新增「${tag.zh}（${tag.en}）」會替換同類特徵，輸出時移除原本的標籤。\n\n'
            '例如改變髮色或長短會改變角色原本的形象設定。要套用嗎？'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('保留原特徵')),
          FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('套用並替換')),
        ],
      ),
    );
    return apply == true;
  }

  Future<void> _copy(String value, String label) async {
    try {
      await html.window.navigator.clipboard?.writeText(value);
    } catch (_) {
      final area = html.TextAreaElement()
        ..value = value
        ..style.position = 'fixed'
        ..style.opacity = '0';
      html.document.body?.append(area);
      area.select();
      html.document.execCommand('copy');
      area.remove();
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$label已複製')));
  }

  Future<void> _clearAllTags() async {
    final clear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('清除所有標籤？'),
        content: const Text(
            '這會清除目前組合的正向標籤、負向標籤、人物角色、人物細節、額外文字與提示前綴，回到一位女性且不需細節的乾淨狀態。\n\n'
            '自訂標籤、角色資料、已儲存組合與版本記錄不會被刪除。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('取消')),
          FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('確定清除')),
        ],
      ),
    );
    if (clear != true) return;
    setState(() {
      _selectedIds.clear();
      _personSelectedIds.clear();
      _removedCharacterTags.clear();
      _personTagQueries.clear();
      _personActiveGroups.clear();
      for (final controller in _personSearchControllers.values) {
        controller.clear();
      }
      _personSlots
        ..clear()
        ..add(PersonSlot()..detailed = false);
      _peopleCount = 1;
      _gender = '女性';
      _stepIndex = 0;
      _activeGroup = '全部';
      _search.clear();
      _extraPositive.clear();
      _negative.text = _defaultNegativeText;
      _preprompt.clear();
      _persist();
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('目前組合已清除')));
    _scrollToStep(0);
  }

  void _downloadBackup() {
    final blob = html.Blob([jsonEncode(_snapshot())], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'betterwaifu-prompt-backup.json')
      ..click();
    html.Url.revokeObjectUrl(url);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('記憶資料已匯出')));
  }

  void _importBackup() {
    final input = html.FileUploadInputElement()
      ..accept = '.json,application/json';
    input.click();
    input.onChange.listen((_) {
      final file = input.files?.first;
      if (file == null) return;
      final reader = html.FileReader();
      reader.readAsText(file);
      reader.onLoad.listen((_) {
        try {
          html.window.localStorage[_storageKey] = '${reader.result}';
          setState(() {
            _selectedIds.clear();
            _personSelectedIds.clear();
            _removedCharacterTags.clear();
            _customTags.clear();
            _presets.clear();
            _restore();
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('記憶資料已匯入')));
        } catch (_) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('JSON 檔案格式不正確')));
        }
      });
    });
  }

  void _savePreset() {
    final controller = TextEditingController(text: '我的 Amanatsu 組合');
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('儲存組合'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: '組合名稱'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              setState(
                () => _presets.insert(
                  0,
                  Preset(name: name, payload: _snapshot()),
                ),
              );
              _persist();
              Navigator.pop(dialogContext);
            },
            child: const Text('儲存'),
          ),
        ],
      ),
    );
  }

  void _loadPreset(Preset preset) {
    final data = preset.payload;
    setState(() {
      _selectedIds
        ..clear()
        ..addAll((data['selectedIds'] as List? ?? []).map((id) => '$id'));
      _personSelectedIds
        ..clear()
        ..addAll({
          for (final entry in (data['personSelectedIds'] as Map? ?? {}).entries)
            if (int.tryParse('${entry.key}') != null)
              int.parse('${entry.key}'):
                  (entry.value as List? ?? []).map((id) => '$id').toSet(),
        });
      _peopleCount = (data['peopleCount'] as num?)?.toInt() ?? 1;
      _gender = '${data['gender'] ?? _gender}';
      _model = '${data['model'] ?? _model}';
      _sampler = '${data['sampler'] ?? _sampler}';
      _steps = (data['steps'] as num?)?.toInt() ?? _steps;
      _cfg = '${data['cfg'] ?? _cfg}';
      _clipSkip = '${data['clipSkip'] ?? _clipSkip}';
      _showAdult = data['showAdult'] == true;
      _extraPositive.text = '${data['extraPositive'] ?? ''}';
      _negative.text = '${data['negative'] ?? _negative.text}';
      _customNegativeTranslations
        ..clear()
        ..addAll(Map<String, dynamic>.from(
          data['customNegativeTranslations'] as Map? ?? <String, dynamic>{},
        ).map((key, value) => MapEntry(key.toLowerCase(), '$value')));
      _preprompt.text = '${data['preprompt'] ?? _preprompt.text}';
      _persist();
    });
  }

  void _setPeopleCount(int count) {
    setState(() {
      while (_personSlots.length < count) _personSlots.add(PersonSlot());
      while (_personSlots.length > count) _personSlots.removeLast();
      _personSelectedIds.removeWhere((index, _) => index >= count);
      _removedCharacterTags.removeWhere((index, _) => index >= count);
      _personTagQueries.removeWhere((index, _) => index >= count);
      _personActiveGroups.removeWhere((key, _) =>
          int.tryParse(key.split(':').first) != null &&
          int.parse(key.split(':').first) >= count);
      _peopleCount = count;
      _persist();
    });
  }

  List<CatalogCharacter> _matchingAnime(PersonSlot slot) {
    final lower = slot.animeQuery.trim().toLowerCase();
    final seen = <String>{};
    final matches = _allCharacters.where((item) {
      if (!seen.add(item.animeTag)) return false;
      if (lower.isEmpty) return true;
      return '${item.animeZh} ${item.animeEn} ${item.animeTag}'
          .toLowerCase()
          .contains(lower);
    }).toList();
    if (slot.animeTag.isNotEmpty) {
      matches.sort((a, b) {
        final aSelected = a.animeTag == slot.animeTag;
        final bSelected = b.animeTag == slot.animeTag;
        if (aSelected == bSelected) return 0;
        return aSelected ? -1 : 1;
      });
    }
    return matches.take(18).toList();
  }

  List<CatalogCharacter> _matchingCharacters(PersonSlot slot) {
    final lower = slot.query.trim().toLowerCase();
    final source = _allCharacters.where((item) {
      if (slot.animeTag.isNotEmpty && item.animeTag != slot.animeTag) {
        return false;
      }
      if (lower.isEmpty) return true;
      return '${item.animeZh} ${item.animeEn} ${item.characterZh} ${item.characterEn} ${item.animeTag} ${item.characterTag}'
          .toLowerCase()
          .contains(lower);
    }).toList();
    if (lower.isEmpty && _recentCharacterIds.isNotEmpty) {
      source.sort((a, b) {
        final aIndex = _recentCharacterIds.indexOf(a.id);
        final bIndex = _recentCharacterIds.indexOf(b.id);
        return (aIndex < 0 ? 999 : aIndex).compareTo(bIndex < 0 ? 999 : bIndex);
      });
    }
    return source.take(18).toList();
  }

  Future<Map<String, dynamic>> _remoteJson(String url) async {
    final raw = await html.HttpRequest.getString(url);
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  Future<Map<String, dynamic>> _anilistJson(
      String query, String keyword) async {
    final response = await html.HttpRequest.request(
      'https://graphql.anilist.co',
      method: 'POST',
      requestHeaders: {'Content-Type': 'application/json'},
      sendData: jsonEncode({
        'query': query,
        'variables': {'search': keyword},
      }),
    );
    return Map<String, dynamic>.from(
        jsonDecode(response.responseText ?? '{}') as Map);
  }

  List<String> _animeSearchTerms(String query) {
    const aliases = <String, List<String>>{
      '棋靈王': ['Hikaru no Go', '棋魂', 'ヒカルの碁'],
      '棋魂': ['Hikaru no Go', '棋靈王', 'ヒカルの碁'],
      '灌籃高手': ['Slam Dunk', 'スラムダンク'],
      '名偵探柯南': ['Detective Conan', 'Case Closed', '名探偵コナン'],
      '航海王': ['One Piece', 'ワンピース'],
      '火影忍者': ['Naruto', 'NARUTO -ナルト-'],
      '死神': ['Bleach', 'BLEACH'],
      '獵人': ['Hunter x Hunter', 'HUNTER×HUNTER'],
      '進擊的巨人': ['Attack on Titan', '進撃の巨人'],
      '鬼滅之刃': ['Demon Slayer', 'Kimetsu no Yaiba', '鬼滅の刃'],
      '咒術迴戰': ['Jujutsu Kaisen', '呪術廻戦'],
      '我的英雄學院': ['My Hero Academia', 'Boku no Hero Academia', '僕のヒーローアカデミア'],
      '間諜家家酒': ['SPY x FAMILY', 'SPY×FAMILY'],
      '葬送的芙莉蓮': [
        "Frieren: Beyond Journey's End",
        'Sousou no Frieren',
        '葬送のフリーレン'
      ],
      '涼宮春日的憂鬱': [
        'The Melancholy of Haruhi Suzumiya',
        'Suzumiya Haruhi no Yuuutsu',
        '涼宮ハルヒの憂鬱'
      ],
      '出包王女': ['To LOVE-Ru', 'To LOVEる -とらぶる-'],
    };
    final input = query.trim();
    final normalized = input.toLowerCase().replaceAll(RegExp(r'\s+'), '');
    final terms = <String>[input];
    aliases.forEach((alias, variants) {
      if (alias.toLowerCase().replaceAll(RegExp(r'\s+'), '') == normalized) {
        terms.addAll(variants);
      }
    });
    return terms.toSet().where((term) => term.isNotEmpty).toList();
  }

  Future<void> _searchRemoteAnime(int slotIndex) async {
    if (slotIndex < 0 || slotIndex >= _personSlots.length) return;
    final query = _personSlots[slotIndex].animeQuery.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請先輸入動漫名稱再查詢。')),
      );
      return;
    }
    setState(() {
      _remoteLookupLoading.add(slotIndex);
      _remoteLookupErrors.remove(slotIndex);
    });
    try {
      const queryText = r'''query ($search: String!) {
        Page(perPage: 8) {
          media(search: $search, type: ANIME) {
            id
            title { romaji english native }
            synonyms
            startDate { year }
            characters(perPage: 50) {
              edges { role node { id name { full native } description } }
            }
          }
        }
      }''';
      final results = <Map>[];
      for (final term in _animeSearchTerms(query)) {
        final data = await _anilistJson(queryText, term);
        final page =
            ((data['data'] as Map?)?['Page'] as Map?)?['media'] as List? ?? [];
        results.addAll(page.whereType<Map>());
        if (results.isNotEmpty) break;
      }
      final seenIds = <int>{};
      final mapped = results
          .where((item) {
            final id = (item['id'] as num?)?.toInt() ?? 0;
            if (id <= 0 || seenIds.contains(id)) return false;
            seenIds.add(id);
            return true;
          })
          .map((item) {
            final title =
                Map<String, dynamic>.from(item['title'] as Map? ?? {});
            final date =
                Map<String, dynamic>.from(item['startDate'] as Map? ?? {});
            final characters =
                ((item['characters'] as Map?)?['edges'] as List? ?? [])
                    .whereType<Map>()
                    .map((edge) {
                      final node =
                          Map<String, dynamic>.from(edge['node'] as Map? ?? {});
                      final name =
                          Map<String, dynamic>.from(node['name'] as Map? ?? {});
                      return _RemoteCharacter(
                        id: (node['id'] as num?)?.toInt() ?? 0,
                        name: '${name['full'] ?? ''}',
                        nameKanji: '${name['native'] ?? ''}',
                        role: '${edge['role'] ?? ''}',
                        about: '${node['description'] ?? ''}',
                      );
                    })
                    .where((character) =>
                        character.id > 0 && character.name.isNotEmpty)
                    .toList();
            return _RemoteAnime(
              id: (item['id'] as num?)?.toInt() ?? 0,
              title:
                  '${title['english'] ?? title['romaji'] ?? title['native'] ?? ''}',
              titleJapanese: '${title['native'] ?? ''}',
              year: (date['year'] as num?)?.toInt(),
              source: 'anilist',
              characters: characters,
            );
          })
          .where((item) => item.id > 0 && item.title.isNotEmpty)
          .toList();
      final mappedResults =
          mapped.where((item) => item.id > 0 && item.title.isNotEmpty).toList();
      if (!mounted) return;
      setState(() {
        _remoteAnimeResults[slotIndex] = mappedResults;
        _remoteLookupLoading.remove(slotIndex);
        if (mappedResults.isEmpty) {
          _remoteLookupErrors[slotIndex] = '查無作品。已嘗試常見中文別名，請改用英文／日文名稱或使用手動新增。';
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _remoteLookupLoading.remove(slotIndex);
        _remoteLookupErrors[slotIndex] = '自動查詢失敗，請稍後再試或使用手動新增。';
      });
    }
  }

  Future<void> _loadRemoteCharacters(int slotIndex, _RemoteAnime anime) async {
    if (slotIndex < 0 || slotIndex >= _personSlots.length) return;
    setState(() {
      _remoteLookupLoading.add(slotIndex);
      _remoteLookupErrors.remove(slotIndex);
      _remoteAnimeSelection[slotIndex] = anime;
    });
    try {
      final characters = anime.source == 'anilist'
          ? anime.characters
          : ((await _remoteJson(
                          'https://api.jikan.moe/v4/anime/${anime.id}/characters'))[
                      'data'] as List? ??
                  [])
              .whereType<Map>()
              .map((item) {
                final character = Map<String, dynamic>.from(
                    item['character'] as Map? ?? <String, dynamic>{});
                return _RemoteCharacter(
                  id: (character['mal_id'] as num?)?.toInt() ?? 0,
                  name: '${character['name'] ?? ''}',
                  nameKanji: '${character['name_kanji'] ?? ''}',
                  role: '${item['role'] ?? ''}',
                );
              })
              .where((item) => item.id > 0 && item.name.isNotEmpty)
              .toList();
      if (!mounted) return;
      final slot = _personSlots[slotIndex];
      slot.animeTag = anime.tag;
      slot.remoteAnimeZh =
          anime.titleJapanese.isEmpty ? anime.title : anime.titleJapanese;
      slot.remoteAnimeEn = anime.title;
      slot.animeQuery = '';
      _clearPersonSearchController(slotIndex, 'anime');
      setState(() {
        _remoteCharacters[slotIndex] = characters;
        _remoteLookupLoading.remove(slotIndex);
        _persist();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _remoteLookupLoading.remove(slotIndex);
        _remoteLookupErrors[slotIndex] = '角色查詢失敗，請稍後再試。';
      });
    }
  }

  Future<String> _remoteCharacterAbout(int id) async {
    try {
      final data =
          await _remoteJson('https://api.jikan.moe/v4/characters/$id/full');
      return '${data['data']?['about'] ?? ''}';
    } catch (_) {
      return '';
    }
  }

  List<CatalogTagData> _remoteTraits(_RemoteCharacter character) {
    var about = character.about.toLowerCase().replaceAll('-', ' ');
    final traits = <CatalogTagData>[];
    void add(String zh, String en) {
      if (traits.any((item) => item.en == en)) return;
      traits.add(CatalogTagData(
        id: 'remote_trait_${DateTime.now().microsecondsSinceEpoch}_${traits.length}',
        group: '自訂特徵',
        zh: zh,
        en: en,
        order: 1,
      ));
    }

    const hairColors = {
      'pink': '粉紅色頭髮',
      'red': '紅色頭髮',
      'blue': '藍色頭髮',
      'green': '綠色頭髮',
      'purple': '紫色頭髮',
      'blonde': '金色頭髮',
      'black': '黑色頭髮',
      'white': '白色頭髮',
      'silver': '銀色頭髮',
      'brown': '棕色頭髮',
      'aqua': '藍綠色頭髮',
      'orange': '橘色頭髮',
      'yellow': '黃色頭髮',
    };
    for (final entry in hairColors.entries) {
      if (RegExp('\\b${entry.key} hair\\b').hasMatch(about)) {
        add(entry.value, '${entry.key} hair');
      }
    }
    const eyeColors = {
      'pink': '粉紅色眼睛',
      'red': '紅色眼睛',
      'blue': '藍色眼睛',
      'green': '綠色眼睛',
      'purple': '紫色眼睛',
      'brown': '棕色眼睛',
      'aqua': '藍綠色眼睛',
      'yellow': '黃色眼睛',
    };
    for (final entry in eyeColors.entries) {
      if (RegExp('\\b${entry.key} eyes?\\b').hasMatch(about)) {
        add(entry.value, '${entry.key} eyes');
      }
    }
    const phrases = <String, Map<String, String>>{
      'very long hair': {'zh': '超長髮', 'en': 'very long hair'},
      'long hair': {'zh': '長髮', 'en': 'long hair'},
      'medium hair': {'zh': '中長髮', 'en': 'medium hair'},
      'short hair': {'zh': '短髮', 'en': 'short hair'},
      'very short hair': {'zh': '極短髮', 'en': 'very short hair'},
      'bob cut': {'zh': '鮑伯頭', 'en': 'bob cut'},
      'pixie cut': {'zh': '精靈短髮', 'en': 'pixie cut'},
      'straight hair': {'zh': '直髮', 'en': 'straight hair'},
      'wavy hair': {'zh': '波浪髮', 'en': 'wavy hair'},
      'curly hair': {'zh': '捲髮', 'en': 'curly hair'},
      'twin tails': {'zh': '雙馬尾', 'en': 'twintails'},
      'twintails': {'zh': '雙馬尾', 'en': 'twintails'},
      'ponytail': {'zh': '馬尾', 'en': 'ponytail'},
      'braid': {'zh': '辮子', 'en': 'braid'},
      'bun': {'zh': '髮髻', 'en': 'hair bun'},
      'ahoge': {'zh': '呆毛', 'en': 'ahoge'},
      'glasses': {'zh': '眼鏡', 'en': 'glasses'},
      'horns': {'zh': '角', 'en': 'horns'},
      'elf ears': {'zh': '精靈耳', 'en': 'elf ears'},
      'pointed ears': {'zh': '尖耳朵', 'en': 'pointed ears'},
      'tail': {'zh': '尾巴', 'en': 'tail'},
      'slim': {'zh': '纖細身材', 'en': 'slim'},
      'medium breasts': {'zh': '中等胸部', 'en': 'medium breasts'},
      'large breasts': {'zh': '豐滿胸部', 'en': 'large breasts'},
    };
    for (final entry in phrases.entries) {
      if (about.contains(entry.key) &&
          !(entry.key == 'long hair' && about.contains('very long hair')) &&
          !(entry.key == 'short hair' && about.contains('very short hair'))) {
        add(entry.value['zh']!, entry.value['en']!);
      }
    }
    return traits;
  }

  CatalogCharacter _remoteCatalogCharacter(
      _RemoteAnime anime, _RemoteCharacter remote) {
    final animeTag = _resolvedAnimeTag(anime);
    CatalogCharacter? local;
    final normalized =
        remote.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    for (final item in _allCharacters) {
      if (item.animeTag != animeTag) continue;
      final itemName =
          item.characterEn.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
      if (itemName == normalized ||
          item.characterTag.toLowerCase() == _slug(remote.name)) {
        local = item;
        break;
      }
    }
    return CatalogCharacter(
      id: 'jikan_character_${remote.id}',
      animeZh: anime.titleJapanese.isEmpty ? anime.title : anime.titleJapanese,
      animeEn: anime.title,
      animeTag: animeTag,
      characterZh: remote.nameKanji.isEmpty ? remote.name : remote.nameKanji,
      characterEn: remote.name,
      characterTag: _slug(remote.name),
      traits: local?.traits ?? _remoteTraits(remote),
    );
  }

  String _animeKey(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\u4e00-\u9fff]'), '');

  String _resolvedAnimeTag(_RemoteAnime anime) {
    final names = [anime.title, anime.titleJapanese]
        .where((value) => value.trim().isNotEmpty)
        .map(_animeKey)
        .toSet();
    for (final item in catalogCharacters) {
      if (names.contains(_animeKey(item.animeEn)) ||
          names.contains(_animeKey(item.animeZh)) ||
          names.contains(_animeKey(item.animeTag))) {
        return item.animeTag;
      }
    }
    return anime.tag;
  }

  CatalogCharacter _normalizeImportedAnime(CatalogCharacter character) {
    final names = {_animeKey(character.animeEn), _animeKey(character.animeZh)};
    for (final item in catalogCharacters) {
      if (names.contains(_animeKey(item.animeEn)) ||
          names.contains(_animeKey(item.animeZh)) ||
          names.contains(_animeKey(item.animeTag))) {
        if (item.animeTag == character.animeTag) return character;
        return CatalogCharacter(
          id: character.id,
          animeZh: character.animeZh,
          animeEn: character.animeEn,
          animeTag: item.animeTag,
          characterZh: character.characterZh,
          characterEn: character.characterEn,
          characterTag: character.characterTag,
          traits: character.traits,
        );
      }
    }
    return character;
  }

  Future<void> _importRemoteCharacters(int slotIndex,
      {List<_RemoteCharacter>? only}) async {
    final anime = _remoteAnimeSelection[slotIndex];
    final remoteCharacters = _remoteCharacters[slotIndex] ?? const [];
    if (anime == null || remoteCharacters.isEmpty) return;
    final source = only ?? remoteCharacters;
    setState(() => _remoteLookupLoading.add(slotIndex));
    final imported = <CatalogCharacter>[];
    for (var index = 0; index < source.length; index++) {
      var remote = source[index];
      if (remote.about.isEmpty && (only != null || index < 18)) {
        remote = remote.withAbout(await _remoteCharacterAbout(remote.id));
        if (index < source.length - 1) {
          await Future<void>.delayed(const Duration(milliseconds: 350));
        }
      }
      final character = _remoteCatalogCharacter(anime, remote);
      if (!_customCharacters.any((item) => item.id == character.id)) {
        imported.add(character);
      }
    }
    _customCharacters.addAll(imported);
    if (imported.isNotEmpty) {
      final slot = _personSlots[slotIndex];
      slot.mode = '動漫角色';
      slot.characterId = imported.first.id;
      slot.animeTag = imported.first.animeTag;
      _recentCharacterIds
        ..remove(imported.first.id)
        ..insert(0, imported.first.id);
      if (_recentCharacterIds.length > 10) _recentCharacterIds.removeLast();
    }
    if (!mounted) return;
    setState(() {
      _remoteLookupLoading.remove(slotIndex);
      _persist();
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已匯入 ${imported.length} 個角色；前 18 個會嘗試補抓外觀特徵。')));
  }

  Widget _remoteAnimePanel(int index) {
    final results = _remoteAnimeResults[index] ?? const <_RemoteAnime>[];
    final error = _remoteLookupErrors[index];
    if (results.isEmpty && error == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(
              child:
                  Text('自動查詢結果', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            TextButton.icon(
              onPressed: () => _clearRemoteLookup(index),
              icon: const Icon(Icons.close, size: 16),
              label: const Text('清除查詢結果'),
            ),
          ],
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(error),
          ),
        ...results.map((anime) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(anime.title),
              subtitle: Text(anime.titleJapanese.isEmpty
                  ? 'Jikan / MyAnimeList 公開資料'
                  : '${anime.titleJapanese} · Jikan / MyAnimeList'),
              trailing: TextButton(
                onPressed: () => _loadRemoteCharacters(index, anime),
                child: const Text('查詢角色'),
              ),
            )),
      ],
    );
  }

  Widget _remoteCharacterPanel(int index) {
    final anime = _remoteAnimeSelection[index];
    final characters = _remoteCharacters[index] ?? const <_RemoteCharacter>[];
    if (anime == null || characters.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text('${anime.title}：自動查詢到 ${characters.length} 名角色',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            TextButton.icon(
              onPressed: () => _clearRemoteLookup(index),
              icon: const Icon(Icons.close, size: 16),
              label: const Text('關閉'),
            ),
          ],
        ),
        const SizedBox(height: 5),
        OutlinedButton.icon(
          onPressed: _remoteLookupLoading.contains(index)
              ? null
              : () => _importRemoteCharacters(index),
          icon: const Icon(Icons.download_outlined),
          label: const Text('匯入此作品角色與可辨識特徵'),
        ),
        SizedBox(
          height: 190,
          child: ListView.builder(
            itemCount: characters.length,
            itemBuilder: (_, characterIndex) {
              final character = characters[characterIndex];
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(character.name),
                subtitle: Text(character.nameKanji.isEmpty
                    ? character.role
                    : '${character.nameKanji} · ${character.role}'),
                trailing: TextButton(
                  onPressed: _remoteLookupLoading.contains(index)
                      ? null
                      : () => _importRemoteCharacters(index, only: [character]),
                  child: const Text('匯入'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _clearRemoteLookup(int index) {
    setState(() {
      _remoteAnimeResults.remove(index);
      _remoteAnimeSelection.remove(index);
      _remoteCharacters.remove(index);
      _remoteLookupErrors.remove(index);
      _remoteLookupLoading.remove(index);
    });
  }

  void _selectAnime(int slotIndex, CatalogCharacter anime) {
    if (slotIndex < 0 || slotIndex >= _personSlots.length) return;
    setState(() {
      final slot = _personSlots[slotIndex];
      slot.animeTag = anime.animeTag;
      slot.animeQuery = '';
      slot.query = '';
      slot.characterId = '';
      _removedCharacterTags.remove(slotIndex);
      _clearPersonSearchController(slotIndex, 'anime');
      _clearPersonSearchController(slotIndex, 'character');
      _persist();
    });
  }

  void _selectCharacter(int slotIndex, CatalogCharacter character) {
    if (slotIndex < 0 || slotIndex >= _personSlots.length) return;
    setState(() {
      final slot = _personSlots[slotIndex];
      slot.characterId = character.id;
      slot.mode = '動漫角色';
      slot.animeTag = character.animeTag;
      slot.animeQuery = '';
      slot.query = '';
      _removedCharacterTags.remove(slotIndex);
      _clearPersonSearchController(slotIndex, 'anime');
      _clearPersonSearchController(slotIndex, 'character');
      _recentCharacterIds.remove(character.id);
      _recentCharacterIds.insert(0, character.id);
      if (_recentCharacterIds.length > 10) _recentCharacterIds.removeLast();
      _persist();
    });
  }

  bool _charactersComplete() {
    for (final slot in _personSlots) {
      if (!slot.detailed) continue;
      if (slot.mode == '動漫角色' && _characterForNew(slot) == null) return false;
      if (slot.mode == '原創' &&
          (slot.originalCharacterEn.trim().isEmpty ||
              slot.originalCharacterTag.trim().isEmpty)) return false;
    }
    return true;
  }

  String _slug(String value) => value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9_ -]'), '')
      .replaceAll(RegExp(r'\s+'), '_');

  void _addCustomCharacter() {
    final animeZh = TextEditingController();
    final animeEn = TextEditingController();
    final animeTag = TextEditingController();
    final characterZh = TextEditingController();
    final characterEn = TextEditingController();
    final characterTag = TextEditingController();
    final traitsZh = TextEditingController();
    final traitsEn = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('新增動漫／角色資料'),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  Expanded(
                      child: TextField(
                          controller: animeZh,
                          decoration:
                              const InputDecoration(labelText: '動漫中文名稱'))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextField(
                          controller: animeEn,
                          decoration: const InputDecoration(
                              labelText: 'Anime English name')))
                ]),
                const SizedBox(height: 10),
                TextField(
                    controller: animeTag,
                    decoration: const InputDecoration(
                        labelText: 'Anime tag', hintText: '留白會由英文名稱產生')),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                      child: TextField(
                          controller: characterZh,
                          decoration:
                              const InputDecoration(labelText: '角色中文名稱'))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextField(
                          controller: characterEn,
                          decoration: const InputDecoration(
                              labelText: 'Character English name')))
                ]),
                const SizedBox(height: 10),
                TextField(
                    controller: characterTag,
                    decoration: const InputDecoration(
                        labelText: 'Character tag', hintText: '留白會由英文名稱產生')),
                const SizedBox(height: 10),
                TextField(
                    controller: traitsZh,
                    decoration: const InputDecoration(
                        labelText: '角色特徵中文', hintText: '粉紅頭髮, 呆毛, 綠眼睛')),
                const SizedBox(height: 10),
                TextField(
                    controller: traitsEn,
                    decoration: const InputDecoration(
                        labelText: 'Character traits English',
                        hintText: 'pink hair, ahoge, green eyes')),
                const SizedBox(height: 8),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('中文與英文特徵依逗號順序配對；資料只會儲存在本機。',
                        style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('取消')),
          FilledButton(
            onPressed: () {
              final cEn = characterEn.text.trim();
              final cTag = _cleanTag(characterTag.text).isEmpty
                  ? _slug(cEn)
                  : _cleanTag(characterTag.text);
              if (animeZh.text.trim().isEmpty ||
                  animeEn.text.trim().isEmpty ||
                  characterZh.text.trim().isEmpty ||
                  cEn.isEmpty ||
                  cTag.isEmpty) return;
              final zhList = _extraTags(traitsZh.text);
              final enList = _extraTags(traitsEn.text);
              final traits = <CatalogTagData>[];
              final total =
                  zhList.length > enList.length ? zhList.length : enList.length;
              for (var index = 0; index < total; index++) {
                final zh =
                    index < zhList.length ? zhList[index] : enList[index];
                final en = index < enList.length ? enList[index] : _slug(zh);
                traits.add(CatalogTagData(
                    id: 'custom_trait_${DateTime.now().microsecondsSinceEpoch}_$index',
                    group: '角色標籤',
                    zh: zh,
                    en: en,
                    order: 1));
              }
              final character = CatalogCharacter(
                  id:
                      'custom_character_${DateTime.now().microsecondsSinceEpoch}',
                  animeZh: animeZh.text.trim(),
                  animeEn: animeEn.text.trim(),
                  animeTag: _cleanTag(animeTag.text).isEmpty
                      ? _slug(animeEn.text)
                      : _cleanTag(animeTag.text),
                  characterZh: characterZh.text.trim(),
                  characterEn: cEn,
                  characterTag: cTag,
                  traits: traits);
              final slotIndex = _personSlots.indexWhere(
                  (slot) => slot.mode == '動漫角色' && slot.characterId.isEmpty);
              final targetIndex = slotIndex < 0 ? 0 : slotIndex;
              _customCharacters.add(character);
              final target = _personSlots[targetIndex];
              target.mode = '動漫角色';
              target.characterId = character.id;
              target.animeTag = character.animeTag;
              target.animeQuery = '';
              target.query = '';
              _clearPersonSearchController(targetIndex, 'anime');
              _clearPersonSearchController(targetIndex, 'character');
              _recentCharacterIds
                ..remove(character.id)
                ..insert(0, character.id);
              if (_recentCharacterIds.length > 10) {
                _recentCharacterIds.removeLast();
              }
              setState(_persist);
              Navigator.pop(dialogContext);
            },
            child: const Text('儲存角色'),
          ),
        ],
      ),
    );
  }

  void _advanceStep() {
    if (_stepIndex == 1 && !_charactersComplete()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('請為每個需要詳細設定的角色選擇動漫角色，或切換成不需細節。')));
      return;
    }
    final nextStep = _stepIndex < 6 ? _stepIndex + 1 : _stepIndex;
    setState(() {
      _stepIndex = nextStep;
      _activeGroup = '全部';
      _search.clear();
      _persist();
    });
    _scrollToStep(nextStep);
  }

  void _addCustomTag() {
    final zh = TextEditingController();
    final en = TextEditingController();
    String group = '自訂特徵';
    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('新增自訂標籤'),
          content: SizedBox(
            width: 430,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: zh,
                  decoration: const InputDecoration(labelText: '中文名稱'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: en,
                  decoration: const InputDecoration(
                    labelText: 'English tag',
                    hintText: '例如: blue jacket',
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: group,
                  decoration: const InputDecoration(labelText: '分類與輸出順序'),
                  items: const [
                    '自訂角色',
                    '自訂特徵',
                    '髮型',
                    '上衣',
                    '褲子',
                    '裙子',
                    '內衣',
                    '胸罩',
                    '內褲',
                    '襪子',
                    '鞋子',
                    '服裝',
                    '配件',
                    '配件顏色',
                    '內衣顏色',
                    '胸罩顏色',
                    '內褲顏色',
                    '襪子顏色',
                    '鞋子顏色',
                    '服裝風格',
                    '上衣風格',
                    '下身風格',
                    '上衣顏色',
                    '下身顏色',
                    '服裝顏色',
                    '服裝細節',
                    '服裝材質',
                    '穿脫狀態',
                    '表情',
                    '姿勢',
                    '動作',
                    '物件',
                    '成人道具',
                    '場景',
                    '其他',
                  ]
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => group = value ?? group),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '自訂內容會只儲存在此瀏覽器，不會上傳。',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                final zhValue = zh.text.trim();
                final enValue = _cleanTag(en.text);
                if (zhValue.isEmpty || enValue.isEmpty) return;
                final order = ['自訂角色'].contains(group)
                    ? 0
                    : ['自訂特徵'].contains(group)
                        ? 1
                        : ['表情'].contains(group)
                            ? 3
                            : ['姿勢'].contains(group)
                                ? 4
                                : ['場景'].contains(group)
                                    ? 9
                                    : 2;
                final tag = TagItem(
                  id: 'custom_${DateTime.now().microsecondsSinceEpoch}',
                  group: group,
                  zh: zhValue,
                  en: enValue,
                  order: order,
                  builtIn: false,
                );
                setState(() {
                  _customTags.add(tag);
                  const personalGroups = {
                    '內衣顏色',
                    '胸罩顏色',
                    '內褲顏色',
                    '襪子顏色',
                    '鞋子顏色',
                    '自訂角色',
                    '自訂特徵',
                    '髮型',
                    '上衣',
                    '褲子',
                    '裙子',
                    '內衣',
                    '胸罩',
                    '內褲',
                    '襪子',
                    '鞋子',
                    '服裝',
                    '配件',
                    '配件顏色',
                    '服裝風格',
                    '上衣風格',
                    '下身風格',
                    '上衣顏色',
                    '下身顏色',
                    '服裝顏色',
                    '服裝細節',
                    '服裝材質',
                    '穿脫狀態',
                    '表情',
                    '姿勢',
                    '動作',
                    '物件',
                    '成人道具',
                  };
                  if (personalGroups.contains(group)) {
                    _personTagIds(0).add(tag.id);
                  } else {
                    _selectedIds.add(tag.id);
                  }
                  _persist();
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('加入並選取'),
            ),
          ],
        ),
      ),
    );
  }

  List<TagItem> _visibleTags(String group) {
    final query = _search.text.trim().toLowerCase();
    return _allTags.where((tag) {
      final groupMatch = group == '全部' || tag.group == group;
      final adultMatch = _showAdult || !tag.adult;
      final queryMatch = query.isEmpty ||
          tag.zh.toLowerCase().contains(query) ||
          tag.en.toLowerCase().contains(query);
      return groupMatch && adultMatch && queryMatch;
    }).toList();
  }

  double _adaptiveChipLabelWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 430) return 124;
    if (width < 800) return 154;
    return 190;
  }

  Widget _tagChip(TagItem tag, {int? personIndex}) {
    final selected = personIndex == null
        ? _selectedIds.contains(tag.id)
        : _personTagIds(personIndex).contains(tag.id);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: _adaptiveChipLabelWidth(context) + (tag.adult ? 28 : 14),
      ),
      child: FilterChip(
        selected: selected,
        label: Text(
          '${tag.zh}  ·  ${tag.en}',
          softWrap: true,
          style: TextStyle(
            color: selected ? _buttonSelectedText : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        avatar: tag.adult
            ? Icon(Icons.eighteen_mp,
                size: 15,
                color: selected ? _buttonSelectedText : const Color(0xffffa7b7))
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        labelPadding: EdgeInsets.zero,
        visualDensity: VisualDensity.standard,
        backgroundColor: _buttonSurface,
        selectedColor: _buttonSelectedSurface,
        checkmarkColor: _buttonSelectedText,
        side: BorderSide(
          color: selected ? const Color(0xfff0eaff) : _buttonBorder,
        ),
        onSelected: (_) => _toggle(tag, personIndex: personIndex),
      ),
    );
  }

  String _wizardGroupLabel(String group) {
    if (group == '褲子') return '下身／褲子';
    if (group == '服裝') return '連身裙／整套服裝';
    if (group == '服裝顏色') return '連身裝顏色';
    return group;
  }

  List<TagItem> _stepVisibleTags(List<String> groups,
      {String? queryText, String? activeGroup}) {
    final query = (queryText ?? _search.text).trim().toLowerCase();
    return _allTags.where((tag) {
      final inGroup = groups.contains(tag.group) &&
          (activeGroup == null || tag.group == activeGroup);
      final adultMatch = _showAdult || !tag.adult;
      final queryMatch = query.isEmpty ||
          tag.zh.toLowerCase().contains(query) ||
          tag.en.toLowerCase().contains(query);
      return inGroup && adultMatch && queryMatch;
    }).toList();
  }

  Widget _stepTagPicker(List<String> groups,
      {required String nextLabel, int? personIndex, bool showNext = true}) {
    final groupKey =
        personIndex == null ? null : '$personIndex:${groups.join('|')}';
    final storedGroup = personIndex == null
        ? _activeGroup
        : (_personActiveGroups[groupKey!] ?? groups.first);
    final currentGroup =
        groups.contains(storedGroup) ? storedGroup : groups.first;
    final tagQuery = personIndex == null
        ? _search.text
        : (_personTagQueries[personIndex] ?? '');
    final visible = _stepVisibleTags(groups,
        queryText: tagQuery, activeGroup: currentGroup);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: personIndex == null ? _search : null,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: '搜尋此步驟的中文或英文標籤…',
              filled: true,
              suffixIcon: tagQuery.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        if (personIndex == null) {
                          _search.clear();
                        } else {
                          setState(() => _personTagQueries[personIndex] = '');
                        }
                      },
                      icon: const Icon(Icons.clear))),
          onChanged: personIndex == null
              ? null
              : (value) =>
                  setState(() => _personTagQueries[personIndex] = value),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: groups.map((group) {
            return ChoiceChip(
                label: Text(
                  _wizardGroupLabel(group),
                  softWrap: false,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: group == currentGroup
                        ? _buttonSelectedText
                        : Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                selected: group == currentGroup,
                backgroundColor: _buttonSurface,
                selectedColor: _buttonSelectedSurface,
                side: BorderSide(
                  color: group == currentGroup
                      ? const Color(0xfff0eaff)
                      : _buttonBorder,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                onSelected: (_) => setState(() {
                      if (personIndex == null) {
                        _activeGroup = group;
                      } else {
                        _personActiveGroups[groupKey!] = group;
                      }
                    }));
          }).toList(),
        ),
        const SizedBox(height: 12),
        if (visible.isEmpty)
          const Text('此分類沒有符合的標籤，可以先完成此步驟或新增自訂標籤。')
        else
          Wrap(
              spacing: 8,
              runSpacing: 8,
              children: visible
                  .map((tag) => _tagChip(tag, personIndex: personIndex))
                  .toList()),
        if (showNext) ...[
          const SizedBox(height: 14),
          Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                  onPressed: _advanceStep,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(nextLabel))),
        ],
      ],
    );
  }

  Widget _stepPersonTagPicker(List<String> groups,
      {required String nextLabel, required String instruction}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(instruction),
        const SizedBox(height: 12),
        ..._personSlots.asMap().entries.map((entry) {
          final index = entry.key;
          final slot = entry.value;
          final characterNames = _characterChineseForSlot(slot, index);
          final title =
              characterNames.isEmpty ? '人物 ${index + 1}' : characterNames.first;
          if (!slot.detailed) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text('人物 ${index + 1}'),
                subtitle: const Text('此人物設定為不需細節，不加入此類標籤。'),
              ),
            );
          }
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            color:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(.28),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(child: Text('${index + 1}')),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('人物 ${index + 1} · $title',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                      IconButton(
                        tooltip: '隨機服裝穿搭',
                        onPressed: () => _randomizeClothing(index),
                        icon: const Icon(Icons.shuffle),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _stepTagPicker(groups,
                      nextLabel: nextLabel,
                      personIndex: index,
                      showNext: false),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: _advanceStep,
            icon: const Icon(Icons.arrow_forward),
            label: Text(nextLabel),
          ),
        ),
      ],
    );
  }

  List<String> _clothingDetailGroups(int personIndex) {
    final selected = _selectedTagsForPerson(personIndex);
    bool has(String group) => selected.any((tag) => tag.group == group);
    final onePiece = selected.any((tag) => ['服裝', '服裝風格'].contains(tag.group));
    final groups = <String>['服裝細節', '服裝材質', '穿脫狀態'];
    if (onePiece) {
      groups.insertAll(0, ['服裝風格', '服裝顏色']);
    } else {
      if (has('上衣')) groups.insertAll(0, ['上衣風格', '上衣顏色']);
      if (has('褲子') || has('裙子')) {
        groups.insertAll(0, ['下身風格', '下身顏色']);
      }
    }
    if (has('內衣')) groups.insert(0, '內衣顏色');
    if (has('胸罩')) groups.insert(0, '胸罩顏色');
    if (has('內褲')) groups.insert(0, '內褲顏色');
    if (has('襪子')) groups.insert(0, '襪子顏色');
    if (has('鞋子')) groups.insert(0, '鞋子顏色');
    if (has('配件')) groups.insert(0, '配件顏色');
    return groups.toSet().toList();
  }

  Widget _stepClothing() {
    const styles = [
      '上衣',
      '褲子',
      '裙子',
      '內衣',
      '胸罩',
      '內褲',
      '襪子',
      '鞋子',
      '服裝',
      '配件',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('先選服裝大項目與樣式，再用服裝細節選擇顏色、花邊、蕾絲與材質。每位人物的服裝會分開保存。'),
        const SizedBox(height: 12),
        ..._personSlots.asMap().entries.map((entry) {
          final index = entry.key;
          final slot = entry.value;
          final characterNames = _characterChineseForSlot(slot, index);
          final adaptiveDetails = _clothingDetailGroups(index);
          final title =
              characterNames.isEmpty ? '人物 ${index + 1}' : characterNames.first;
          if (!slot.detailed) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text('人物 ${index + 1}'),
                subtitle: const Text('此人物設定為不需細節，不加入服裝標籤。'),
              ),
            );
          }
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            color:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(.28),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(child: Text('${index + 1}')),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('人物 ${index + 1} · $title',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('服裝類型與樣式',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  _stepTagPicker(styles,
                      nextLabel: '下一步', personIndex: index, showNext: false),
                  const Divider(height: 26),
                  const Text('風格、顏色與服裝細節（可多選）',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  _stepTagPicker(adaptiveDetails,
                      nextLabel: '下一步', personIndex: index, showNext: false),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: _advanceStep,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('下一步：表情'),
          ),
        ),
      ],
    );
  }

  GlobalKey _stepKey(int index) =>
      _stepKeys.putIfAbsent(index, () => GlobalKey(debugLabel: 'step-$index'));

  void _scrollToStep(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final target = _stepKey(index).currentContext;
      if (target == null) return;
      Scrollable.ensureVisible(
        target,
        alignment: 0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _openStep(int index) {
    setState(() => _stepIndex = index);
    _scrollToStep(index);
  }

  Widget _stepHeader(int index, String title, String summary, IconData icon) {
    final expanded = _stepIndex == index;
    return InkWell(
      onTap: () => _openStep(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(children: [
          CircleAvatar(radius: 15, child: Text('${index + 1}')),
          const SizedBox(width: 12),
          Icon(icon,
              size: 20,
              color: expanded
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 9),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(summary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant))
              ])),
          Icon(expanded ? Icons.expand_less : Icons.expand_more),
        ]),
      ),
    );
  }

  Widget _stepCard(
      int index, String title, String summary, IconData icon, Widget child) {
    return Card(
      key: _stepKey(index),
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        _stepHeader(index, title, summary, icon),
        if (_stepIndex == index) const Divider(height: 1),
        if (_stepIndex == index)
          Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18), child: child),
      ]),
    );
  }

  Widget _stepPeople() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('先決定畫面中有幾位角色；之後可以逐一指定女性、男性或其他/異種。',
            style: TextStyle(fontSize: 13)),
        const SizedBox(height: 14),
        DropdownButtonFormField<int>(
          value: _personSlots.length,
          decoration: const InputDecoration(
              labelText: '人物數量（必填）', prefixIcon: Icon(Icons.groups_outlined)),
          items: List.generate(10, (index) => index + 1)
              .map((value) =>
                  DropdownMenuItem(value: value, child: Text('$value 人')))
              .toList(),
          onChanged: (value) => _setPeopleCount(value ?? 1),
        ),
        const SizedBox(height: 12),
        Text(
          '模型、Sampler、Steps、CFG 與 Clip skip 請直接在 AI 生成網站設定；本工具只輸出可貼上的提示標籤。',
          style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 14),
        Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
                onPressed: _advanceStep,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('下一步：場景'))),
      ],
    );
  }

  Widget _stepCharacters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.groups_outlined, size: 20),
            const SizedBox(width: 8),
            Text('人物資料數量：${_personSlots.length}',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            const Spacer(),
            IconButton(
              tooltip: '減少人物',
              onPressed: _personSlots.length <= 1
                  ? null
                  : () => _setPeopleCount(_personSlots.length - 1),
              icon: const Icon(Icons.remove_circle_outline),
            ),
            IconButton(
              tooltip: '增加人物（最多 10 人）',
              onPressed: _personSlots.length >= 10
                  ? null
                  : () => _setPeopleCount(_personSlots.length + 1),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
            '人物數量會依下方角色資料卡自動計算。每個人物都要選擇「動漫角色」、「原創角色」，或明確選擇「不需細節」。動漫角色會自動帶入動漫英文 tag、角色英文 tag 與角色特徵。'),
        const SizedBox(height: 12),
        ..._personSlots.asMap().entries.map((entry) {
          final index = entry.key;
          final slot = entry.value;
          final animeMatches = _matchingAnime(slot);
          final matches = _matchingCharacters(slot);
          return Card(
            color:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(.35),
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text('人物 ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(width: 12),
                      SizedBox(
                          width: 130,
                          child: DropdownButtonFormField<String>(
                              value: slot.gender,
                              decoration:
                                  const InputDecoration(labelText: '性別/類型'),
                              items: const ['女性', '男性', '其他/異種']
                                  .map((value) => DropdownMenuItem(
                                      value: value, child: Text(value)))
                                  .toList(),
                              onChanged: (value) => setState(() {
                                    slot.gender = value ?? slot.gender;
                                    _persist();
                                  }))),
                      const Spacer(),
                      Switch(
                          value: slot.detailed,
                          onChanged: (value) => setState(() {
                                slot.detailed = value;
                                _persist();
                              })),
                      const Text('需要細節')
                    ]),
                    if (!slot.detailed)
                      const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('此人物只輸出人數/性別 tag，不加入動漫名稱、角色名稱或特徵。')),
                    if (slot.detailed) ...[
                      const SizedBox(height: 10),
                      Wrap(
                          spacing: 8,
                          children: ['動漫角色', '原創', '不需細節']
                              .map((mode) => ChoiceChip(
                                  label: Text(mode),
                                  selected: slot.mode == mode,
                                  onSelected: (_) => setState(() {
                                        slot.mode = mode;
                                        if (mode == '不需細節')
                                          slot.detailed = false;
                                        _persist();
                                      })))
                              .toList()),
                      if (slot.mode == '動漫角色') ...[
                        const SizedBox(height: 10),
                        Row(children: [
                          Expanded(
                            child: TextField(
                                controller: _personSearchController(
                                    index, 'anime', slot.animeQuery),
                                decoration: const InputDecoration(
                                    labelText: '第一步：查詢動漫名稱',
                                    prefixIcon: Icon(Icons.search)),
                                onChanged: (value) =>
                                    setState(() => slot.animeQuery = value)),
                          ),
                          const SizedBox(width: 8),
                          FilledButton.icon(
                            onPressed: _remoteLookupLoading.contains(index)
                                ? null
                                : () => _searchRemoteAnime(index),
                            icon: const Icon(Icons.public, size: 18),
                            label: const Text('自動查詢'),
                          ),
                        ]),
                        _remoteAnimePanel(index),
                        _remoteCharacterPanel(index),
                        const SizedBox(height: 9),
                        if (animeMatches.isNotEmpty)
                          Wrap(
                              spacing: 7,
                              runSpacing: 7,
                              children: animeMatches
                                  .map((anime) => ChoiceChip(
                                      label: Text(
                                          '${anime.animeZh} · ${anime.animeEn}'),
                                      selected: slot.animeTag == anime.animeTag,
                                      onSelected: (_) =>
                                          _selectAnime(index, anime)))
                                  .toList())
                        else
                          const Text('查無動漫資料，可新增自己的動漫與角色。'),
                        if (slot.animeTag.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          TextField(
                              controller: _personSearchController(
                                  index, 'character', slot.query),
                              decoration: const InputDecoration(
                                  labelText: '第二步：查詢角色名稱',
                                  prefixIcon: Icon(Icons.person_search)),
                              onChanged: (value) =>
                                  setState(() => slot.query = value)),
                          const SizedBox(height: 9),
                          if (matches.isNotEmpty)
                            Wrap(
                                spacing: 7,
                                runSpacing: 7,
                                children: matches
                                    .map((character) => ChoiceChip(
                                        label: Text(
                                            '${character.characterZh} · ${character.characterEn}'),
                                        selected:
                                            slot.characterId == character.id,
                                        onSelected: (_) =>
                                            _selectCharacter(index, character)))
                                    .toList())
                          else
                            const Text('查無此動漫角色，可自行新增角色資料。'),
                        ],
                        const SizedBox(height: 9),
                        OutlinedButton.icon(
                            onPressed: _addCustomCharacter,
                            icon: const Icon(Icons.person_add_alt_1),
                            label: const Text('新增自訂動漫與角色')),
                        if (_characterForNew(slot) != null)
                          Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                  '已帶入：${_characterForNew(slot)!.animeEn} · 動漫 tag：${_characterForNew(slot)!.animeTag} · ${_characterForNew(slot)!.characterEn} · ${_characterForNew(slot)!.traits.map((item) => item.en).join(', ')}',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))),
                      ],
                      if (slot.mode == '原創') ...[
                        const SizedBox(height: 10),
                        TextFormField(
                            initialValue: slot.originalAnimeZh,
                            decoration: const InputDecoration(
                                labelText: '原創作品/世界觀中文（可選）'),
                            onChanged: (value) {
                              slot.originalAnimeZh = value;
                              _persist();
                            }),
                        const SizedBox(height: 8),
                        TextFormField(
                            initialValue: slot.originalAnimeEn,
                            decoration: const InputDecoration(
                                labelText: 'Original work English（可選）'),
                            onChanged: (value) {
                              slot.originalAnimeEn = value;
                              _persist();
                            }),
                        const SizedBox(height: 8),
                        TextFormField(
                            initialValue: slot.originalCharacterZh,
                            decoration:
                                const InputDecoration(labelText: '原創角色中文名稱'),
                            onChanged: (value) {
                              slot.originalCharacterZh = value;
                              _persist();
                            }),
                        const SizedBox(height: 8),
                        TextFormField(
                            initialValue: slot.originalCharacterEn,
                            decoration: const InputDecoration(
                                labelText:
                                    'Original character English name（必填）'),
                            onChanged: (value) {
                              slot.originalCharacterEn = value;
                              slot.originalCharacterTag =
                                  slot.originalCharacterTag.isEmpty
                                      ? _slug(value)
                                      : slot.originalCharacterTag;
                              _persist();
                            }),
                        const SizedBox(height: 8),
                        TextFormField(
                            initialValue: slot.originalCharacterTag,
                            decoration: const InputDecoration(
                                labelText: 'Character tag（必填）'),
                            onChanged: (value) {
                              slot.originalCharacterTag = value;
                              _persist();
                            }),
                        const SizedBox(height: 8),
                        TextFormField(
                            initialValue: slot.originalTraits,
                            decoration: const InputDecoration(
                                labelText: '原創角色特徵（中英文皆可，逗號分隔）'),
                            onChanged: (value) {
                              slot.originalTraits = value;
                              _persist();
                            }),
                      ],
                    ],
                  ]),
            ),
          );
        }),
        Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
                onPressed: _advanceStep,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('完成角色：下一步特徵'))),
      ],
    );
  }

  Widget _stepFinal() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextField(
          controller: _preprompt,
          maxLines: 2,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
              labelText: 'Amanatsu 品質前綴（可修改）',
              helperText: '一般英文標籤會以英文句點分隔；多人分組加強會用括號區塊輸出。')),
      const SizedBox(height: 10),
      TextField(
          controller: _extraPositive,
          maxLines: 2,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
              labelText: '額外正向標籤', hintText: '中文或英文，逗號/換行分隔')),
      const SizedBox(height: 10),
      TextField(
          controller: _negative,
          maxLines: 4,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
              labelText: '負面標籤 English',
              prefixIcon: Icon(Icons.block_outlined))),
      const SizedBox(height: 10),
      Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(.35),
              borderRadius: BorderRadius.circular(10)),
          child: Text('負面標籤中文翻譯：\n$_negativeZh')),
      const SizedBox(height: 12),
      _negativeTagPicker(),
      const SizedBox(height: 12),
      Text(
          '自動髮長防衝突：角色為長髮時會在負面輸出加入 short hair；改選短髮後則加入 long hair。這些自動詞不會改寫上方可編輯欄位。',
          style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant)),
      const SizedBox(height: 12),
      SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: _showAdult,
          title: const Text('顯示 18+ 標籤'),
          subtitle: const Text('只使用成年角色，並遵守 BetterWaifu 內容規範。'),
          onChanged: (value) => setState(() {
                _showAdult = value;
                _persist();
              })),
      SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: _groupPeoplePrompt,
          title: const Text('多人角色分組加強（括號權重）'),
          subtitle: const Text(
              '兩人以上時，會將每位人物的角色、特徵、服裝、表情與動作分成獨立的 (…:1.15) 區塊；場景與共同標籤維持在區塊外。'),
          onChanged: (value) => setState(() {
                _groupPeoplePrompt = value;
                _persist();
              })),
    ]);
  }

  Widget _progressiveBuilder() {
    return Column(children: [
      _stepCard(
          0,
          '場景與畫面',
          _selectedTags
              .where((tag) => ['場景', '畫面'].contains(tag.group))
              .map((tag) => tag.zh)
              .join('、')
              .ifEmpty('尚未選擇'),
          Icons.landscape_outlined,
          _stepTagPicker(['場景', '畫面'], nextLabel: '下一步：角色資料')),
      _stepCard(
          1,
          '角色資料',
          _characterChineseNew().join('、').ifEmpty('每個人物都要設定或選擇不需細節'),
          Icons.badge_outlined,
          _stepCharacters()),
      _stepCard(
          2,
          '角色特徵',
          _personSelectedIds.isEmpty
              ? '每位人物分別設定'
              : _personSelectedIds.values
                  .expand(
                      (ids) => _allTags.where((tag) => ids.contains(tag.id)))
                  .where((tag) =>
                      ['外觀特徵', '髮型', '臉部特徵', '胸部', '裸露'].contains(tag.group))
                  .map((tag) => tag.zh)
                  .join('、')
                  .ifEmpty('尚未選擇'),
          Icons.face_retouching_natural,
          _stepPersonTagPicker(['外觀特徵', '髮型', '臉部特徵', '胸部', '裸露'],
              nextLabel: '下一步：服裝',
              instruction: '請在每位人物自己的區塊內設定外觀、髮型、臉部、胸部與裸露標籤。')),
      _stepCard(
          3,
          '服裝與穿脫狀態',
          _personSelectedIds.values
              .expand((ids) => _allTags.where((tag) => ids.contains(tag.id)))
              .where((tag) => [
                    '上衣',
                    '褲子',
                    '裙子',
                    '內衣',
                    '胸罩',
                    '內褲',
                    '襪子',
                    '鞋子',
                    '服裝',
                    '配件',
                    '服裝風格',
                    '上衣風格',
                    '下身風格',
                    '上衣顏色',
                    '下身顏色',
                    '服裝顏色',
                    '服裝細節',
                    '服裝材質',
                    '穿脫狀態'
                  ].contains(tag.group))
              .map((tag) => tag.zh)
              .join('、')
              .ifEmpty('每位人物分別設定'),
          Icons.checkroom_outlined,
          _stepClothing()),
      _stepCard(
          4,
          '表情',
          _personSelectedIds.values
              .expand((ids) => _allTags.where((tag) => ids.contains(tag.id)))
              .where((tag) => tag.group == '表情')
              .map((tag) => tag.zh)
              .join('、')
              .ifEmpty('每位人物分別設定'),
          Icons.mood_outlined,
          _stepPersonTagPicker(['表情'],
              nextLabel: '下一步：姿勢', instruction: '請分別設定每位人物的表情。')),
      _stepCard(
          5,
          '姿勢、動作、物件與成人道具',
          _personSelectedIds.values
              .expand((ids) => _allTags.where((tag) => ids.contains(tag.id)))
              .where((tag) =>
                  ['姿勢', '動作', '物件', '成人道具', '性行為', '性姿勢'].contains(tag.group))
              .map((tag) => tag.zh)
              .join('、')
              .ifEmpty('每位人物分別設定'),
          Icons.accessibility_new,
          _stepPersonTagPicker(['姿勢', '動作', '物件', '成人道具', '性行為', '性姿勢'],
              nextLabel: '下一步：品質與負面',
              instruction: '請分別設定每位人物的基本姿勢、運動動作、常見物件、成人道具與性姿勢；不同人物可以使用不同姿勢。')),
      _stepCard(6, '品質、額外與負面', '設定品質前綴、negative prompt 與 18+ 顯示', Icons.tune,
          _stepFinal()),
    ]);
  }

  Widget _builderPanel() {
    final visible = _visibleTags(_activeGroup);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    '標籤資料庫',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                FilledButton.icon(
                  onPressed: _addCustomTag,
                  icon: const Icon(Icons.add),
                  label: const Text('新增標籤'),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Text(
              '點選標籤加入提示詞；排序會依照角色 → 特徵 → 服裝 → 表情 → 姿勢／動作／物件。',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: _search.clear,
                        icon: const Icon(Icons.clear),
                      ),
                hintText: '搜尋中文或英文標籤…',
                filled: true,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: _groups.map((group) {
                return ChoiceChip(
                  label: Text(
                    group,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      color: _activeGroup == group
                          ? _buttonSelectedText
                          : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  selected: _activeGroup == group,
                  backgroundColor: _buttonSurface,
                  selectedColor: _buttonSelectedSurface,
                  side: BorderSide(
                    color: _activeGroup == group
                        ? const Color(0xfff0eaff)
                        : _buttonBorder,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  onSelected: (_) => setState(() => _activeGroup = group),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            if (visible.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('沒有符合條件的標籤。可以用右上角「新增標籤」建立自己的中文/英文內容。'),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: visible.map(_tagChip).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _setupPanel() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '組合設定',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            const Text(
              '人物數量與性別請在「角色資料」區直接增加、減少人物卡片並分別設定。',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Text(
              '模型、Sampler、Steps、CFG 與 Clip skip 請直接在 AI 生成網站設定；本工具只輸出可貼上的提示標籤。',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _showAdult,
              title: const Text('顯示 18+ 標籤分類'),
              subtitle: const Text('包含胸部、裸露、性行為與性姿勢；只建立成年角色內容。'),
              onChanged: (value) => setState(() {
                _showAdult = value;
                _persist();
              }),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _preprompt,
              maxLines: 2,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Amanatsu 品質前綴（可修改）',
                helperText: '會在全部選取標籤之後輸出，避免破壞你指定的角色→服裝→表情→姿勢順序。',
                prefixIcon: Icon(Icons.tune),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _extraPositive,
              maxLines: 2,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: '額外正向標籤',
                hintText: '可輸入中文或英文；中文會自動轉成英文標籤',
                helperText: '可用逗號或換行分隔；內建標籤會自動對應英文，英文欄位仍以英文輸出。',
                prefixIcon: Icon(Icons.add_circle_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _negative,
              maxLines: 4,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: '負面標籤（Negative prompt）',
                hintText: 'lowres, blurry, bad anatomy…',
                prefixIcon: Icon(Icons.block_outlined),
              ),
            ),
            const SizedBox(height: 8),
            _negativeTagPicker(),
          ],
        ),
      ),
    );
  }

  Widget _outputField(
    String label,
    String value, {
    required VoidCallback onCopy,
    int maxLines = 4,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                tooltip: '複製',
                onPressed: value.isEmpty ? null : onCopy,
                icon: const Icon(Icons.copy_all_outlined),
              ),
            ],
          ),
          TextField(
            controller: TextEditingController(text: value),
            readOnly: true,
            maxLines: maxLines,
            decoration: const InputDecoration(
              filled: true,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chineseOutputField() {
    final generated = _generatedPositiveTags();
    final extra = _extraPositive.text.trim();
    final preprompt = _preprompt.text.trim();
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  '中文翻譯與記憶欄位',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                tooltip: '複製',
                onPressed: _positiveZh.isEmpty
                    ? null
                    : () => _copy(_positiveZh, '中文欄位'),
                icon: const Icon(Icons.copy_all_outlined),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 150),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).inputDecorationTheme.fillColor ??
                  Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '人物數量：${_peopleZh()}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  if (generated.isNotEmpty) ...[
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: generated.map((tag) {
                        return Tooltip(
                          message: tag.en,
                          child: InputChip(
                            label: Text(tag.zh),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () => _removeGeneratedOutputTag(tag),
                            backgroundColor: _buttonSurface,
                            side: const BorderSide(color: _buttonBorder),
                            labelStyle: const TextStyle(color: Colors.white),
                            deleteIconColor: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  if (extra.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      '額外正向敘述：${_extraTags(extra).map(_positiveChineseTag).join('、')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                  if (preprompt.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Amanatsu 品質前綴：$preprompt',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _outputPanel() {
    final selectedCount = _selectedTags.length + _personSelectedCount;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '輸出結果',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '已選 $selectedCount 個資料庫標籤 · 英文每個標籤以句點結尾',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _copy(_positiveText, '英文正向標籤'),
                  icon: const Icon(Icons.copy_all),
                ),
                IconButton(
                  onPressed: _savePreset,
                  icon: const Icon(Icons.bookmark_add_outlined),
                ),
                IconButton(
                  tooltip: '清除所有標籤',
                  onPressed: _clearAllTags,
                  icon: const Icon(Icons.delete_sweep_outlined),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 690;
                final english = _outputField(
                  'English prompt · 可直接貼上',
                  _positiveText,
                  onCopy: () => _copy(_positiveText, '英文正向標籤'),
                  maxLines: 6,
                );
                final chinese = _chineseOutputField();
                return narrow
                    ? Column(
                        children: [
                          english,
                          const SizedBox(height: 12),
                          chinese,
                        ],
                      )
                    : Row(
                        children: [english, const SizedBox(width: 14), chinese],
                      );
              },
            ),
            const SizedBox(height: 12),
            _outputField(
              'Negative prompt · 負面標籤',
              _negativeText,
              onCopy: () => _copy(_negativeText, '負面標籤'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            _outputField(
              'Negative prompt · 中文翻譯',
              _negativeZh,
              onCopy: () => _copy(_negativeZh, '負面中文翻譯'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(.48),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '模型參數請在 AI 生成網站設定；這裡只提供可貼上的提示標籤。',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '輸出順序：${_peopleTag()} → 角色/特徵 → 服裝 → 表情 → 姿勢 → 場景/畫面 → 品質前綴。',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _memoryPanel() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    '記憶與備份',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  tooltip: '匯出 JSON',
                  onPressed: _downloadBackup,
                  icon: const Icon(Icons.download_outlined),
                ),
                IconButton(
                  tooltip: '匯入 JSON',
                  onPressed: _importBackup,
                  icon: const Icon(Icons.upload_outlined),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '目前資料只存在這個瀏覽器的 localStorage；清除網站資料會移除記憶。',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            if (_presets.isEmpty)
              const Text('尚無儲存組合。按輸出結果右上角的書籤按鈕即可保存。')
            else
              ..._presets.asMap().entries.map((entry) {
                final index = entry.key;
                final preset = entry.value;
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 15,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(preset.name),
                  subtitle: Text(
                    '${(preset.payload['selectedIds'] as List? ?? []).length} 個標籤 · ${preset.payload['gender'] ?? '女性'} ${preset.payload['peopleCount'] ?? 1} 人',
                  ),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        tooltip: '載入',
                        onPressed: () => _loadPreset(preset),
                        icon: const Icon(Icons.restore),
                      ),
                      IconButton(
                        tooltip: '刪除',
                        onPressed: () => setState(() {
                          _presets.removeAt(index);
                          _persist();
                        }),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _infoPanel() {
    return Card(
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        initiallyExpanded: _showInfo,
        onExpansionChanged: (value) => setState(() => _showInfo = value),
        leading: const Icon(Icons.rule),
        title: const Text('Amanatsu / BetterWaifu 使用提示'),
        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 17),
                const SizedBox(width: 6),
                Text('目前版本：$appVersionLabel'),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: _showVersionHistory,
                  child: const Text('查看版本歷程'),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '• 模型、Sampler、Steps、CFG、Clip skip 與 seed 請在 AI 生成網站設定；本工具專注產生提示標籤。',
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('• 這個工具使用 Danbooru-style tag，英文標籤會整理成可直接貼上的單行文字。'),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '• BetterWaifu 公開文件建議使用逗號分隔、可用括號強調、另設 negative prompt；本工具保留自由輸入欄位。',
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '• Amanatsu 1.1 的專屬公開格式沒有可核實的完整規格，因此品質前綴是可編輯的，不假裝是固定官方規則。',
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('• 18+ 分類預設隱藏；打開後請只使用成年角色，並遵守 BetterWaifu 的內容規範。'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 22,
        title: Row(
          children: [
            Icon(Icons.auto_awesome, size: 25),
            SizedBox(width: 10),
            Flexible(child: Text('Prompt Atelier')),
            SizedBox(width: 10),
            Text(
              'v$appVersionLabel',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: '版本歷程',
            onPressed: _showVersionHistory,
            icon: const Icon(Icons.new_releases_outlined),
          ),
          IconButton(
            tooltip: '匯出備份',
            onPressed: _downloadBackup,
            icon: const Icon(Icons.save_alt),
          ),
          IconButton(
            tooltip: '匯入備份',
            onPressed: _importBackup,
            icon: const Icon(Icons.file_open_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(58, 16, 16, 38),
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: _progressiveBuilder(),
              ),
              const SizedBox(height: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: _outputPanel(),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: _memoryPanel(),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: _infoPanel(),
              ),
            ],
          ),
          Positioned(
            left: 6,
            top: 12,
            child: SafeArea(
              child: SizedBox(
                width: 42,
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 7),
                    child: Column(
                      children: [
                        const Text('複製',
                            style: TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        IconButton.filled(
                            constraints: const BoxConstraints.tightFor(
                                width: 32, height: 32),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            iconSize: 16,
                            tooltip: '複製正向英文標籤',
                            onPressed: () => _copy(_positiveText, '正向英文標籤'),
                            icon: const Text('正',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800))),
                        const SizedBox(height: 4),
                        IconButton.filled(
                            constraints: const BoxConstraints.tightFor(
                                width: 32, height: 32),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            iconSize: 16,
                            tooltip: '複製負面英文標籤',
                            onPressed: () => _copy(_negativeText, '負面英文標籤'),
                            icon: const Text('負',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      title: 'BetterWaifu Prompt Atelier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff8c6ef3),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xff11111a),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(_buttonSelectedSurface),
            foregroundColor: MaterialStatePropertyAll(_buttonSelectedText),
            side: MaterialStatePropertyAll(
              BorderSide(color: Color(0xfff0eaff)),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(_buttonSurface),
            foregroundColor: MaterialStatePropertyAll(Colors.white),
            side: MaterialStatePropertyAll(BorderSide(color: _buttonBorder)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(_buttonSelectedSurface),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(Colors.white),
            backgroundColor: MaterialStatePropertyAll(_buttonSurface),
          ),
        ),
        chipTheme: const ChipThemeData(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          labelStyle: TextStyle(
            fontSize: 12,
            height: 1.25,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: _buttonSurface,
          selectedColor: _buttonSelectedSurface,
          checkmarkColor: _buttonSelectedText,
          side: BorderSide(color: _buttonBorder),
        ),
        cardTheme: const CardThemeData(margin: EdgeInsets.zero, elevation: 0),
      ),
      home: const PromptBuilderApp(),
    ),
  );
}
