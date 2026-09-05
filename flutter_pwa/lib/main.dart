import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';

const _storageKey = 'betterwaifu_prompt_builder_state_v1';

class TagItem {
  const TagItem({
    required this.id,
    required this.group,
    required this.zh,
    required this.en,
    required this.order,
    this.adult = false,
    this.builtIn = true,
  });

  final String id;
  final String group;
  final String zh;
  final String en;
  final int order;
  final bool adult;
  final bool builtIn;

  Map<String, dynamic> toJson() => {
        'id': id,
        'group': group,
        'zh': zh,
        'en': en,
        'order': order,
        'adult': adult,
        'builtIn': builtIn,
      };

  factory TagItem.fromJson(Map<String, dynamic> json) => TagItem(
        id: '${json['id']}',
        group: '${json['group'] ?? '自訂'}',
        zh: '${json['zh'] ?? ''}',
        en: '${json['en'] ?? ''}',
        order: (json['order'] as num?)?.toInt() ?? 1,
        adult: json['adult'] == true,
        builtIn: false,
      );
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

TagItem _tag(
  String id,
  String group,
  String zh,
  String en,
  int order, {
  bool adult = false,
}) =>
    TagItem(id: id, group: group, zh: zh, en: en, order: order, adult: adult);

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
      _tag('body_groping', '胸部', '撫摸胸部', 'groping', 5, adult: true),
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
  final List<TagItem> _builtIns = _seedTags();
  final Set<String> _selectedIds = <String>{};
  final List<TagItem> _customTags = <TagItem>[];
  final List<Preset> _presets = <Preset>[];
  final TextEditingController _search = TextEditingController();
  final TextEditingController _extraPositive = TextEditingController();
  final TextEditingController _negative = TextEditingController(
    text:
        'lowres, worst quality, bad quality, bad anatomy, bad hands, extra digits, '
        'multiple views, fewer digits, extra limbs, missing fingers, deformed, text, '
        'error, jpeg artifacts, watermark, unfinished, displeasing, signature, username, scan artifacts',
  );
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
  bool _showAdult = false;
  bool _showInfo = true;

  List<TagItem> get _allTags => [..._builtIns, ..._customTags];

  List<TagItem> get _selectedTags {
    final tags =
        _allTags.where((tag) => _selectedIds.contains(tag.id)).toList();
    tags.sort((a, b) {
      final order = a.order.compareTo(b.order);
      return order == 0 ? a.en.compareTo(b.en) : order;
    });
    return tags;
  }

  List<String> get _groups => [
        '全部',
        ..._allTags.map((tag) => tag.group).toSet(),
      ];

  @override
  void initState() {
    super.initState();
    _restore();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    _extraPositive.dispose();
    _negative.dispose();
    _preprompt.dispose();
    super.dispose();
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
      _presets.addAll(
        (data['presets'] as List? ?? []).map(
          (item) => Preset.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
      _selectedIds.addAll(
        (data['selectedIds'] as List? ?? []).map((id) => '$id'),
      );
      _peopleCount = (data['peopleCount'] as num?)?.toInt() ?? 1;
      _gender = '${data['gender'] ?? '女性'}';
      _model = '${data['model'] ?? 'Amanatsu 1.1'}';
      _sampler = '${data['sampler'] ?? 'Euler a'}';
      _steps = (data['steps'] as num?)?.toInt() ?? 28;
      _cfg = '${data['cfg'] ?? '5.0'}';
      _clipSkip = '${data['clipSkip'] ?? '2'}';
      _showAdult = data['showAdult'] == true;
      _extraPositive.text = '${data['extraPositive'] ?? ''}';
      _negative.text = '${data['negative'] ?? _negative.text}';
      _preprompt.text = '${data['preprompt'] ?? _preprompt.text}';
    } catch (_) {
      // A malformed local record should never stop the builder from opening.
    }
  }

  Map<String, dynamic> _snapshot() => {
        'selectedIds': _selectedIds.toList(),
        'customTags': _customTags.map((tag) => tag.toJson()).toList(),
        'presets': _presets.map((preset) => preset.toJson()).toList(),
        'peopleCount': _peopleCount,
        'gender': _gender,
        'model': _model,
        'sampler': _sampler,
        'steps': _steps,
        'cfg': _cfg,
        'clipSkip': _clipSkip,
        'showAdult': _showAdult,
        'extraPositive': _extraPositive.text,
        'negative': _negative.text,
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

  String _cleanTag(String value) => value
      .trim()
      .replaceAll(RegExp(r'^[,，\s]+|[,，\s]+$'), '')
      .replaceAll(RegExp(r'\s+'), ' ');

  List<String> _extraTags(String value) => value
      .split(RegExp(r'[,，\n]+'))
      .map(_cleanTag)
      .where((item) => item.isNotEmpty)
      .toList();

  List<String> get _positiveTokens {
    final tokens = <String>[_peopleTag()];
    tokens.addAll(_selectedTags.map((tag) => tag.en));
    tokens.addAll(_extraTags(_extraPositive.text));
    tokens.addAll(_extraTags(_preprompt.text));
    final seen = <String>{};
    return tokens.where((token) => seen.add(token.toLowerCase())).toList();
  }

  String get _positiveText => _positiveTokens.map((tag) => '$tag.').join(' ');

  String get _positiveZh {
    final tokens = <String>[_peopleZh()];
    tokens.addAll(_selectedTags.map((tag) => tag.zh));
    if (_extraPositive.text.trim().isNotEmpty)
      tokens.add('額外英文標籤：${_extraPositive.text.trim()}');
    if (_preprompt.text.trim().isNotEmpty)
      tokens.add('Amanatsu 品質前綴：${_preprompt.text.trim()}');
    return tokens.join('。 ');
  }

  String get _negativeText =>
      _extraTags(_negative.text).map((tag) => '$tag.').join(' ');

  void _toggle(TagItem tag) {
    setState(() {
      if (_selectedIds.contains(tag.id)) {
        _selectedIds.remove(tag.id);
      } else {
        _selectedIds.add(tag.id);
      }
      _persist();
    });
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
      _preprompt.text = '${data['preprompt'] ?? _preprompt.text}';
      _persist();
    });
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
                    '上衣',
                    '褲子',
                    '裙子',
                    '胸罩',
                    '內褲',
                    '襪子',
                    '鞋子',
                    '服裝',
                    '配件',
                    '表情',
                    '姿勢',
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
                  _selectedIds.add(tag.id);
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

  Color _groupColor(String group, BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (group.contains('服裝') ||
        ['上衣', '褲子', '裙子', '胸罩', '內褲', '襪子', '鞋子', '配件'].contains(group)) {
      return scheme.tertiaryContainer;
    }
    if (group.contains('性') || group == '裸露' || group == '胸部')
      return scheme.errorContainer;
    if (group == '表情' || group == '姿勢') return scheme.secondaryContainer;
    if (group == '品質') return scheme.primaryContainer;
    return scheme.surfaceVariant;
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

  Widget _tagChip(TagItem tag) {
    final selected = _selectedIds.contains(tag.id);
    return FilterChip(
      selected: selected,
      label: Text('${tag.zh}  ·  ${tag.en}'),
      avatar: tag.adult ? const Icon(Icons.eighteen_mp, size: 15) : null,
      backgroundColor: _groupColor(tag.group, context).withOpacity(.32),
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      onSelected: (_) => _toggle(tag),
    );
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
              '點選標籤加入提示詞；排序會依照角色 → 特徵 → 服裝 → 表情 → 姿勢。',
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
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _groups.length,
                separatorBuilder: (_, __) => const SizedBox(width: 7),
                itemBuilder: (_, index) {
                  final group = _groups[index];
                  return ChoiceChip(
                    label: Text(group),
                    selected: _activeGroup == group,
                    onSelected: (_) => setState(() => _activeGroup = group),
                  );
                },
              ),
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
            DropdownButtonFormField<String>(
              value: _model,
              decoration: const InputDecoration(
                labelText: '目標模型',
                prefixIcon: Icon(Icons.auto_awesome),
              ),
              items: const ['Amanatsu 1.1', 'Amanatsu（自訂設定）', '通用 Danbooru']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (value) => setState(() {
                _model = value ?? _model;
                _persist();
              }),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: const InputDecoration(labelText: '角色型態'),
                    items: const ['女性', '男性', '混合']
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() {
                      _gender = value ?? _gender;
                      _persist();
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _peopleCount,
                    decoration: const InputDecoration(labelText: '人數'),
                    items: List.generate(6, (index) => index + 1)
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text('$value 人'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() {
                      _peopleCount = value ?? 1;
                      _persist();
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _sampler,
                    decoration: const InputDecoration(labelText: 'Sampler'),
                    items: const [
                      'Euler a',
                      'DPM++ 2M Karras',
                      'DPM++ SDE Karras',
                      'DDIM'
                    ]
                        .map((value) =>
                            DropdownMenuItem(value: value, child: Text(value)))
                        .toList(),
                    onChanged: (value) => setState(() {
                      _sampler = value ?? _sampler;
                      _persist();
                    }),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _steps,
                    decoration: const InputDecoration(labelText: 'Steps'),
                    items: const [20, 24, 28, 32, 35, 40]
                        .map((value) => DropdownMenuItem(
                            value: value, child: Text('$value')))
                        .toList(),
                    onChanged: (value) => setState(() {
                      _steps = value ?? _steps;
                      _persist();
                    }),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _cfg,
                    decoration: const InputDecoration(labelText: 'CFG'),
                    items: const ['4.5', '5.0', '5.5', '6.0', '7.0']
                        .map((value) =>
                            DropdownMenuItem(value: value, child: Text(value)))
                        .toList(),
                    onChanged: (value) => setState(() {
                      _cfg = value ?? _cfg;
                      _persist();
                    }),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _clipSkip,
                    decoration: const InputDecoration(labelText: 'Clip skip'),
                    items: const ['1', '2']
                        .map((value) =>
                            DropdownMenuItem(value: value, child: Text(value)))
                        .toList(),
                    onChanged: (value) => setState(() {
                      _clipSkip = value ?? _clipSkip;
                      _persist();
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              '起始建議：Euler a · 28 steps · CFG 5 · Clip skip 2；請以自己的 seed 與畫面比例實測。',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 11,
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
                hintText: '可用中文或英文，以逗號或換行分隔',
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

  Widget _outputPanel() {
    final selectedCount = _selectedTags.length;
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
                final chinese = _outputField(
                  '中文翻譯與記憶欄位',
                  _positiveZh,
                  onCopy: () => _copy(_positiveZh, '中文欄位'),
                );
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
                      '模型設定：$_sampler · $_steps steps · CFG $_cfg · Clip skip $_clipSkip。',
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
        children: const [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '• 參考起始設定為 Euler a、28 steps、CFG 5、Clip skip 2；實際效果仍需依 seed、尺寸與 prompt 測試。',
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
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, size: 25),
            SizedBox(width: 10),
            Text('Prompt Atelier'),
          ],
        ),
        actions: [
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1100;
          final content = wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: _builderPanel()),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          _setupPanel(),
                          const SizedBox(height: 16),
                          _memoryPanel(),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _setupPanel(),
                    const SizedBox(height: 16),
                    _builderPanel(),
                    const SizedBox(height: 16),
                    _memoryPanel(),
                  ],
                );
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 38),
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1480),
                child: Center(child: content),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1480),
                child: _outputPanel(),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1480),
                child: _infoPanel(),
              ),
            ],
          );
        },
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
        cardTheme: const CardThemeData(margin: EdgeInsets.zero, elevation: 0),
      ),
      home: const PromptBuilderApp(),
    ),
  );
}
