class CatalogTagData {
  const CatalogTagData({
    required this.id,
    required this.group,
    required this.zh,
    required this.en,
    required this.order,
    this.adult = false,
    this.conflictGroup,
  });

  final String id;
  final String group;
  final String zh;
  final String en;
  final int order;
  final bool adult;
  final String? conflictGroup;

  Map<String, dynamic> toJson() => {
        'id': id,
        'group': group,
        'zh': zh,
        'en': en,
        'order': order,
        'adult': adult,
        'conflictGroup': conflictGroup,
      };

  factory CatalogTagData.fromJson(Map<String, dynamic> json) => CatalogTagData(
        id: '${json['id']}',
        group: '${json['group'] ?? '自訂特徵'}',
        zh: '${json['zh'] ?? ''}',
        en: '${json['en'] ?? ''}',
        order: (json['order'] as num?)?.toInt() ?? 1,
        adult: json['adult'] == true,
        conflictGroup: json['conflictGroup'] as String?,
      );
}

class CatalogCharacter {
  const CatalogCharacter({
    required this.id,
    required this.animeZh,
    required this.animeEn,
    required this.animeTag,
    required this.characterZh,
    required this.characterEn,
    required this.characterTag,
    required this.traits,
  });

  final String id;
  final String animeZh;
  final String animeEn;
  final String animeTag;
  final String characterZh;
  final String characterEn;
  final String characterTag;
  final List<CatalogTagData> traits;

  Map<String, dynamic> toJson() => {
        'id': id,
        'animeZh': animeZh,
        'animeEn': animeEn,
        'animeTag': animeTag,
        'characterZh': characterZh,
        'characterEn': characterEn,
        'characterTag': characterTag,
        'traits': traits.map((item) => item.toJson()).toList(),
      };

  factory CatalogCharacter.fromJson(Map<String, dynamic> json) =>
      CatalogCharacter(
        id: '${json['id']}',
        animeZh: '${json['animeZh'] ?? '原創'}',
        animeEn: '${json['animeEn'] ?? 'Original'}',
        animeTag: '${json['animeTag'] ?? 'original'}',
        characterZh: '${json['characterZh'] ?? ''}',
        characterEn: '${json['characterEn'] ?? ''}',
        characterTag: '${json['characterTag'] ?? ''}',
        traits: (json['traits'] as List? ?? [])
            .map((item) =>
                CatalogTagData.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );
}

CatalogTagData _ct(
  String id,
  String group,
  String zh,
  String en,
  int order, {
  bool adult = false,
  String? conflict,
}) =>
    CatalogTagData(
      id: id,
      group: group,
      zh: zh,
      en: en,
      order: order,
      adult: adult,
      conflictGroup: conflict,
    );

const supplementalTags = <CatalogTagData>[
  // Face and body details.
  CatalogTagData(
      id: 'face_fangs', group: '臉部特徵', zh: '虎牙', en: 'fangs', order: 1),
  CatalogTagData(
      id: 'face_sharp_teeth',
      group: '臉部特徵',
      zh: '尖牙',
      en: 'sharp teeth',
      order: 1),
  CatalogTagData(
      id: 'face_ahoge', group: '臉部特徵', zh: '呆毛', en: 'ahoge', order: 1),
  CatalogTagData(
      id: 'face_animal_ears',
      group: '臉部特徵',
      zh: '獸耳',
      en: 'animal ears',
      order: 1),
  CatalogTagData(
      id: 'face_cat_ears', group: '臉部特徵', zh: '貓耳', en: 'cat ears', order: 1),
  CatalogTagData(
      id: 'face_fox_ears', group: '臉部特徵', zh: '狐耳', en: 'fox ears', order: 1),
  CatalogTagData(
      id: 'face_horns', group: '臉部特徵', zh: '角', en: 'horns', order: 1),
  CatalogTagData(
      id: 'face_elf_ears', group: '臉部特徵', zh: '精靈耳', en: 'elf ears', order: 1),
  CatalogTagData(
      id: 'face_pointy_ears',
      group: '臉部特徵',
      zh: '尖耳',
      en: 'pointy ears',
      order: 1),
  CatalogTagData(
      id: 'face_eyebrows',
      group: '臉部特徵',
      zh: '眉毛可見',
      en: 'eyebrows visible',
      order: 1),
  CatalogTagData(
      id: 'face_lips', group: '臉部特徵', zh: '嘴唇', en: 'lips', order: 1),
  CatalogTagData(
      id: 'face_parted_lips',
      group: '臉部特徵',
      zh: '微張嘴唇',
      en: 'parted lips',
      order: 1),
  CatalogTagData(
      id: 'face_pout', group: '臉部特徵', zh: '噘嘴', en: 'pout', order: 1),
  CatalogTagData(
      id: 'face_smirk', group: '臉部特徵', zh: '壞笑', en: 'smirk', order: 1),
  CatalogTagData(
      id: 'face_drooling',
      group: '臉部特徵',
      zh: '流口水',
      en: 'drooling',
      order: 1,
      adult: true),
  CatalogTagData(
      id: 'face_tongue_out',
      group: '臉部特徵',
      zh: '吐舌',
      en: 'tongue out',
      order: 1),
  CatalogTagData(
      id: 'face_heart_eyes',
      group: '臉部特徵',
      zh: '愛心眼',
      en: 'heart eyes',
      order: 1),
  CatalogTagData(
      id: 'face_dizzy', group: '臉部特徵', zh: '暈眩眼', en: 'dizzy', order: 1),
  CatalogTagData(
      id: 'face_expressionless',
      group: '臉部特徵',
      zh: '面無表情',
      en: 'expressionless',
      order: 1),
  CatalogTagData(
      id: 'face_evil_smile',
      group: '臉部特徵',
      zh: '邪惡微笑',
      en: 'evil smile',
      order: 1),
  CatalogTagData(
      id: 'face_seductive',
      group: '臉部特徵',
      zh: '誘惑表情（成年角色）',
      en: 'seductive smile',
      order: 1,
      adult: true),
  CatalogTagData(
      id: 'face_ahegao_2',
      group: '臉部特徵',
      zh: '情慾表情（成年角色）',
      en: 'ahegao',
      order: 1,
      adult: true,
      conflictGroup: 'expression'),
  CatalogTagData(
      id: 'face_closed_mouth',
      group: '表情',
      zh: '閉嘴',
      en: 'closed mouth',
      order: 3,
      conflictGroup: 'mouth'),
  CatalogTagData(
      id: 'face_open_mouth_2',
      group: '表情',
      zh: '張嘴',
      en: 'open mouth',
      order: 3,
      conflictGroup: 'mouth'),
  CatalogTagData(
      id: 'face_wink_2',
      group: '表情',
      zh: '眨眼',
      en: 'wink',
      order: 3,
      conflictGroup: 'eyes'),
  CatalogTagData(
      id: 'face_closed_eyes_2',
      group: '表情',
      zh: '閉眼',
      en: 'closed eyes',
      order: 3,
      conflictGroup: 'eyes'),
  CatalogTagData(
      id: 'face_blush_2', group: '表情', zh: '臉紅', en: 'blush', order: 3),
  CatalogTagData(
      id: 'face_crying', group: '表情', zh: '哭泣', en: 'crying', order: 3),
  CatalogTagData(
      id: 'face_sweatdrop', group: '表情', zh: '汗滴', en: 'sweatdrop', order: 3),

  // Clothing types, layers, colors, materials and wear state.
  CatalogTagData(
      id: 'clothing_maid',
      group: '服裝',
      zh: '女僕裝',
      en: 'maid outfit',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_nurse',
      group: '服裝',
      zh: '護士服',
      en: 'nurse uniform',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_leotard',
      group: '服裝',
      zh: '體操服/連身衣',
      en: 'leotard',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_bodysuit',
      group: '服裝',
      zh: '緊身連體衣',
      en: 'bodysuit',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_lingerie',
      group: '服裝',
      zh: '女性內衣',
      en: 'lingerie',
      order: 2,
      adult: true,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_babydoll',
      group: '服裝',
      zh: '娃娃裝',
      en: 'babydoll',
      order: 2,
      adult: true,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_negligee',
      group: '服裝',
      zh: '睡袍',
      en: 'negligee',
      order: 2,
      adult: true,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_nightgown',
      group: '服裝',
      zh: '睡裙',
      en: 'nightgown',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_yukata',
      group: '服裝',
      zh: '浴衣',
      en: 'yukata',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_qipao',
      group: '服裝',
      zh: '旗袍',
      en: 'qipao',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_gothic_lolita',
      group: '服裝',
      zh: '哥德蘿莉塔',
      en: 'gothic lolita',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_military',
      group: '服裝',
      zh: '軍裝',
      en: 'military uniform',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_police',
      group: '服裝',
      zh: '警察制服',
      en: 'police uniform',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_tracksuit',
      group: '服裝',
      zh: '運動服',
      en: 'tracksuit',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_labcoat', group: '服裝', zh: '實驗袍', en: 'lab coat', order: 2),
  CatalogTagData(
      id: 'clothing_cardigan',
      group: '上衣',
      zh: '開襟衫',
      en: 'cardigan',
      order: 2,
      conflictGroup: 'top'),
  CatalogTagData(
      id: 'clothing_vest',
      group: '上衣',
      zh: '背心',
      en: 'vest',
      order: 2,
      conflictGroup: 'top'),
  CatalogTagData(
      id: 'clothing_camisole',
      group: '上衣',
      zh: '細肩帶背心',
      en: 'camisole',
      order: 2,
      conflictGroup: 'top'),
  CatalogTagData(
      id: 'clothing_tanktop',
      group: '上衣',
      zh: '無袖上衣',
      en: 'tank top',
      order: 2,
      conflictGroup: 'top'),
  CatalogTagData(
      id: 'underwear_camisole',
      group: '內衣',
      zh: '吊帶內衣',
      en: 'camisole underwear',
      order: 2,
      adult: true,
      conflictGroup: 'underwear'),
  CatalogTagData(
      id: 'underwear_chemise',
      group: '內衣',
      zh: '睡衣式內衣',
      en: 'chemise',
      order: 2,
      adult: true,
      conflictGroup: 'underwear'),
  CatalogTagData(
      id: 'underwear_bandeau',
      group: '內衣',
      zh: '無肩帶內衣',
      en: 'bandeau underwear',
      order: 2,
      adult: true,
      conflictGroup: 'underwear'),
  CatalogTagData(
      id: 'clothing_sailor',
      group: '服裝',
      zh: '水手服',
      en: 'sailor uniform',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_cape', group: '服裝', zh: '披風', en: 'cape', order: 2),
  CatalogTagData(
      id: 'clothing_robe',
      group: '服裝',
      zh: '長袍',
      en: 'robe',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_hakama',
      group: '服裝',
      zh: '袴',
      en: 'hakama',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_hanfu',
      group: '服裝',
      zh: '漢服',
      en: 'hanfu',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_sari',
      group: '服裝',
      zh: '紗麗',
      en: 'sari',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_raincoat',
      group: '服裝',
      zh: '雨衣',
      en: 'raincoat',
      order: 2,
      conflictGroup: 'one_piece'),
  CatalogTagData(
      id: 'clothing_color_black',
      group: '服裝顏色',
      zh: '黑色服裝',
      en: 'black clothing',
      order: 2),
  CatalogTagData(
      id: 'clothing_color_white',
      group: '服裝顏色',
      zh: '白色服裝',
      en: 'white clothing',
      order: 2),
  CatalogTagData(
      id: 'clothing_color_red',
      group: '服裝顏色',
      zh: '紅色服裝',
      en: 'red clothing',
      order: 2),
  CatalogTagData(
      id: 'clothing_color_blue',
      group: '服裝顏色',
      zh: '藍色服裝',
      en: 'blue clothing',
      order: 2),
  CatalogTagData(
      id: 'clothing_color_pink',
      group: '服裝顏色',
      zh: '粉紅色服裝',
      en: 'pink clothing',
      order: 2),
  CatalogTagData(
      id: 'clothing_color_purple',
      group: '服裝顏色',
      zh: '紫色服裝',
      en: 'purple clothing',
      order: 2),
  CatalogTagData(
      id: 'clothing_color_green',
      group: '服裝顏色',
      zh: '綠色服裝',
      en: 'green clothing',
      order: 2),
  CatalogTagData(
      id: 'clothing_color_yellow',
      group: '服裝顏色',
      zh: '黃色服裝',
      en: 'yellow clothing',
      order: 2),
  CatalogTagData(
      id: 'clothing_color_multicolor',
      group: '服裝顏色',
      zh: '多色服裝',
      en: 'multicolored clothing',
      order: 2),
  CatalogTagData(
      id: 'clothing_lace', group: '服裝細節', zh: '蕾絲', en: 'lace trim', order: 2),
  CatalogTagData(
      id: 'clothing_frills', group: '服裝細節', zh: '荷葉邊', en: 'frills', order: 2),
  CatalogTagData(
      id: 'clothing_ribbon_trim',
      group: '服裝細節',
      zh: '緞帶裝飾',
      en: 'ribbon trim',
      order: 2),
  CatalogTagData(
      id: 'clothing_bow', group: '服裝細節', zh: '蝴蝶結裝飾', en: 'bow', order: 2),
  CatalogTagData(
      id: 'clothing_ruffles', group: '服裝細節', zh: '褶邊', en: 'ruffles', order: 2),
  CatalogTagData(
      id: 'clothing_see_through',
      group: '服裝細節',
      zh: '透視布料',
      en: 'see-through clothing',
      order: 2,
      adult: true),
  CatalogTagData(
      id: 'clothing_sheer',
      group: '服裝細節',
      zh: '薄紗',
      en: 'sheer fabric',
      order: 2),
  CatalogTagData(
      id: 'clothing_satin', group: '服裝材質', zh: '緞面', en: 'satin', order: 2),
  CatalogTagData(
      id: 'clothing_silk', group: '服裝材質', zh: '絲綢', en: 'silk', order: 2),
  CatalogTagData(
      id: 'clothing_latex',
      group: '服裝材質',
      zh: '乳膠',
      en: 'latex',
      order: 2,
      adult: true),
  CatalogTagData(
      id: 'clothing_leather', group: '服裝材質', zh: '皮革', en: 'leather', order: 2),
  CatalogTagData(
      id: 'clothing_denim', group: '服裝材質', zh: '丹寧布', en: 'denim', order: 2),
  CatalogTagData(
      id: 'clothing_wet',
      group: '穿脫狀態',
      zh: '濕衣服',
      en: 'wet clothes',
      order: 2),
  CatalogTagData(
      id: 'clothing_torn',
      group: '穿脫狀態',
      zh: '破損衣物',
      en: 'torn clothes',
      order: 2),
  CatalogTagData(
      id: 'clothing_open',
      group: '穿脫狀態',
      zh: '敞開衣物',
      en: 'open clothes',
      order: 2,
      adult: true),
  CatalogTagData(
      id: 'clothing_unbuttoned',
      group: '穿脫狀態',
      zh: '解開鈕扣',
      en: 'unbuttoned',
      order: 2,
      adult: true),
  CatalogTagData(
      id: 'clothing_undressing',
      group: '穿脫狀態',
      zh: '脫衣中',
      en: 'undressing',
      order: 2,
      adult: true),
  CatalogTagData(
      id: 'clothing_dressing',
      group: '穿脫狀態',
      zh: '穿衣中',
      en: 'dressing',
      order: 2),
  CatalogTagData(
      id: 'clothing_bra_lift',
      group: '穿脫狀態',
      zh: '掀起胸罩（成年角色）',
      en: 'bra lift',
      order: 2,
      adult: true),
  CatalogTagData(
      id: 'clothing_panties_down',
      group: '穿脫狀態',
      zh: '內褲褪下（成年角色）',
      en: 'panties down',
      order: 2,
      adult: true),

  // General pose and composition.
  CatalogTagData(
      id: 'pose_all_fours',
      group: '姿勢',
      zh: '四肢著地（成年角色）',
      en: 'all fours',
      order: 4,
      adult: true,
      conflictGroup: 'pose'),
  CatalogTagData(
      id: 'pose_crawling',
      group: '姿勢',
      zh: '爬行',
      en: 'crawling',
      order: 4,
      conflictGroup: 'pose'),
  CatalogTagData(
      id: 'pose_prone',
      group: '姿勢',
      zh: '俯臥',
      en: 'prone',
      order: 4,
      conflictGroup: 'pose'),
  CatalogTagData(
      id: 'pose_supine',
      group: '姿勢',
      zh: '仰臥',
      en: 'supine',
      order: 4,
      conflictGroup: 'pose'),
  CatalogTagData(
      id: 'pose_fetal',
      group: '姿勢',
      zh: '胎兒姿勢',
      en: 'fetal position',
      order: 4,
      conflictGroup: 'pose'),
  CatalogTagData(
      id: 'pose_legs_up',
      group: '姿勢',
      zh: '雙腿抬起（成年角色）',
      en: 'legs up',
      order: 4,
      adult: true),
  CatalogTagData(
      id: 'pose_legs_apart',
      group: '姿勢',
      zh: '雙腿分開（成年角色）',
      en: 'legs apart',
      order: 4,
      adult: true),
  CatalogTagData(
      id: 'pose_hands_behind_back',
      group: '姿勢',
      zh: '雙手在背後',
      en: 'hands behind back',
      order: 4),
  CatalogTagData(
      id: 'pose_mating_press',
      group: '性姿勢',
      zh: '壓制式（成年角色）',
      en: 'mating press',
      order: 8,
      adult: true,
      conflictGroup: 'sex_position'),
  CatalogTagData(
      id: 'pose_face_down_ass_up',
      group: '性姿勢',
      zh: '臉朝下臀部抬起（成年角色）',
      en: 'face down ass up',
      order: 8,
      adult: true,
      conflictGroup: 'sex_position'),
  CatalogTagData(
      id: 'pose_spread_legs',
      group: '性姿勢',
      zh: '張腿姿勢（成年角色）',
      en: 'spread legs',
      order: 8,
      adult: true,
      conflictGroup: 'sex_position'),
  CatalogTagData(
      id: 'pose_sex_from_behind',
      group: '性姿勢',
      zh: '後方性交（成年角色）',
      en: 'sex from behind',
      order: 8,
      adult: true,
      conflictGroup: 'sex_position'),
  CatalogTagData(
      id: 'pose_wall_sex',
      group: '性姿勢',
      zh: '靠牆性交（成年角色）',
      en: 'wall sex',
      order: 8,
      adult: true,
      conflictGroup: 'sex_position'),
  CatalogTagData(
      id: 'pose_shower_sex',
      group: '性姿勢',
      zh: '淋浴間性交（成年角色）',
      en: 'shower sex',
      order: 8,
      adult: true,
      conflictGroup: 'sex_position'),
  CatalogTagData(
      id: 'act_penetration',
      group: '性行為',
      zh: '插入（成年角色）',
      en: 'penetration',
      order: 7,
      adult: true),
  CatalogTagData(
      id: 'act_deepthroat',
      group: '性行為',
      zh: '深喉（成年角色）',
      en: 'deepthroat',
      order: 7,
      adult: true),
  CatalogTagData(
      id: 'act_tribadism',
      group: '性行為',
      zh: '磨豆腐（成年角色）',
      en: 'tribadism',
      order: 7,
      adult: true),
  CatalogTagData(
      id: 'act_dry_humping',
      group: '性行為',
      zh: '隔衣磨蹭（成年角色）',
      en: 'dry humping',
      order: 7,
      adult: true),
  CatalogTagData(
      id: 'act_exhibitionism',
      group: '性行為',
      zh: '露出癖（成年角色）',
      en: 'exhibitionism',
      order: 7,
      adult: true),
  CatalogTagData(
      id: 'act_public_indecency',
      group: '性行為',
      zh: '公然猥褻主題（成年角色）',
      en: 'public indecency',
      order: 7,
      adult: true),
  CatalogTagData(
      id: 'act_creampie',
      group: '性行為',
      zh: '內射（成年角色）',
      en: 'creampie',
      order: 7,
      adult: true),
  CatalogTagData(
      id: 'act_cum_on_face',
      group: '性行為',
      zh: '射在臉上（成年角色）',
      en: 'cum on face',
      order: 7,
      adult: true),
  CatalogTagData(
      id: 'act_cum_on_body',
      group: '性行為',
      zh: '射在身體上（成年角色）',
      en: 'cum on body',
      order: 7,
      adult: true),
  CatalogTagData(
      id: 'act_orgasm',
      group: '性行為',
      zh: '高潮（成年角色）',
      en: 'orgasm',
      order: 7,
      adult: true),
  CatalogTagData(
      id: 'act_afterglow',
      group: '性行為',
      zh: '事後餘韻（成年角色）',
      en: 'afterglow',
      order: 7,
      adult: true),
  CatalogTagData(
      id: 'act_submissive',
      group: '性行為',
      zh: '服從（成年角色）',
      en: 'submissive',
      order: 7,
      adult: true),
  CatalogTagData(
      id: 'act_dominant',
      group: '性行為',
      zh: '支配（成年角色）',
      en: 'dominant',
      order: 7,
      adult: true),
];

CatalogTagData _trait(String id, String zh, String en, {bool adult = false}) =>
    CatalogTagData(
        id: id, group: '角色標籤', zh: zh, en: en, order: 1, adult: adult);

const catalogCharacters = <CatalogCharacter>[
  CatalogCharacter(
    id: 'to_love_ru_lala',
    animeZh: '出包王女',
    animeEn: 'To LOVE-Ru',
    animeTag: 'to_love-ru',
    characterZh: '拉拉・撒塔琳・戴比路克',
    characterEn: 'Lala Satalin Deviluke',
    characterTag: 'lala_satalin_deviluke',
    traits: [
      CatalogTagData(
          id: 'lala_pink_hair',
          group: '角色標籤',
          zh: '粉紅色頭髮',
          en: 'pink hair',
          order: 1),
      CatalogTagData(
          id: 'lala_ahoge', group: '角色標籤', zh: '呆毛', en: 'ahoge', order: 1),
      CatalogTagData(
          id: 'lala_green_eyes',
          group: '角色標籤',
          zh: '綠眼睛',
          en: 'green eyes',
          order: 1),
      CatalogTagData(
          id: 'lala_heart_tail',
          group: '角色標籤',
          zh: '黑色心型尾巴',
          en: 'black heart-shaped tail',
          order: 1),
      CatalogTagData(
          id: 'lala_slim', group: '角色標籤', zh: '纖細身材', en: 'slim', order: 1),
      CatalogTagData(
          id: 'lala_medium_breasts',
          group: '角色標籤',
          zh: '中等胸部',
          en: 'medium breasts',
          order: 1,
          adult: true),
    ],
  ),
  CatalogCharacter(
      id: 'to_love_ru_momo',
      animeZh: '出包王女',
      animeEn: 'To LOVE-Ru',
      animeTag: 'to_love-ru',
      characterZh: '夢夢・貝莉雅・戴比路克',
      characterEn: 'Momo Belia Deviluke',
      characterTag: 'momo_belia_deviluke',
      traits: [
        CatalogTagData(
            id: 'momo_pink_hair',
            group: '角色標籤',
            zh: '粉紅色頭髮',
            en: 'pink hair',
            order: 1),
        CatalogTagData(
            id: 'momo_green_eyes',
            group: '角色標籤',
            zh: '綠眼睛',
            en: 'green eyes',
            order: 1),
        CatalogTagData(
            id: 'momo_ahoge', group: '角色標籤', zh: '呆毛', en: 'ahoge', order: 1)
      ]),
  CatalogCharacter(
      id: 'to_love_ru_yui',
      animeZh: '出包王女',
      animeEn: 'To LOVE-Ru',
      animeTag: 'to_love-ru',
      characterZh: '古手川唯',
      characterEn: 'Yui Kotegawa',
      characterTag: 'yui_kotegawa',
      traits: [
        CatalogTagData(
            id: 'yui_black_hair',
            group: '角色標籤',
            zh: '黑色長髮',
            en: 'black hair',
            order: 1),
        CatalogTagData(
            id: 'yui_green_eyes',
            group: '角色標籤',
            zh: '綠眼睛',
            en: 'green eyes',
            order: 1),
        CatalogTagData(
            id: 'yui_uniform',
            group: '角色標籤',
            zh: '校服',
            en: 'school uniform',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'vocaloid_miku',
      animeZh: '初音未來',
      animeEn: 'VOCALOID',
      animeTag: 'vocaloid',
      characterZh: '初音未來',
      characterEn: 'Hatsune Miku',
      characterTag: 'hatsune_miku',
      traits: [
        CatalogTagData(
            id: 'miku_aqua_hair',
            group: '角色標籤',
            zh: '水藍色雙馬尾',
            en: 'aqua hair',
            order: 1),
        CatalogTagData(
            id: 'miku_blue_eyes',
            group: '角色標籤',
            zh: '藍綠色眼睛',
            en: 'aqua eyes',
            order: 1),
        CatalogTagData(
            id: 'miku_headset',
            group: '角色標籤',
            zh: '耳機',
            en: 'headset',
            order: 1),
        CatalogTagData(
            id: 'miku_twin_tails',
            group: '角色標籤',
            zh: '雙馬尾',
            en: 'twintails',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'sao_asuna',
      animeZh: '刀劍神域',
      animeEn: 'Sword Art Online',
      animeTag: 'sword_art_online',
      characterZh: '結城明日奈',
      characterEn: 'Asuna Yuuki',
      characterTag: 'asuna_(sword_art_online)',
      traits: [
        CatalogTagData(
            id: 'asuna_brown_hair',
            group: '角色標籤',
            zh: '長棕髮',
            en: 'long brown hair',
            order: 1),
        CatalogTagData(
            id: 'asuna_brown_eyes',
            group: '角色標籤',
            zh: '棕色眼睛',
            en: 'brown eyes',
            order: 1),
        CatalogTagData(
            id: 'asuna_slim', group: '角色標籤', zh: '纖細身材', en: 'slim', order: 1)
      ]),
  CatalogCharacter(
      id: 're_zero_rem',
      animeZh: 'Re:從零開始的異世界生活',
      animeEn: 'Re:Zero − Starting Life in Another World',
      animeTag: 're:zero_kara_hajimeru_isekai_seikatsu',
      characterZh: '雷姆',
      characterEn: 'Rem',
      characterTag: 'rem_(re:zero)',
      traits: [
        CatalogTagData(
            id: 'rem_blue_hair',
            group: '角色標籤',
            zh: '藍髮',
            en: 'blue hair',
            order: 1),
        CatalogTagData(
            id: 'rem_blue_eyes',
            group: '角色標籤',
            zh: '藍眼睛',
            en: 'blue eyes',
            order: 1),
        CatalogTagData(
            id: 'rem_maid',
            group: '角色標籤',
            zh: '女僕裝',
            en: 'maid outfit',
            order: 1)
      ]),
  CatalogCharacter(
      id: 're_zero_ram',
      animeZh: 'Re:從零開始的異世界生活',
      animeEn: 'Re:Zero − Starting Life in Another World',
      animeTag: 're:zero_kara_hajimeru_isekai_seikatsu',
      characterZh: '拉姆',
      characterEn: 'Ram',
      characterTag: 'ram_(re:zero)',
      traits: [
        CatalogTagData(
            id: 'ram_pink_hair',
            group: '角色標籤',
            zh: '粉紅髮',
            en: 'pink hair',
            order: 1),
        CatalogTagData(
            id: 'ram_red_eyes',
            group: '角色標籤',
            zh: '紅眼睛',
            en: 'red eyes',
            order: 1),
        CatalogTagData(
            id: 'ram_maid',
            group: '角色標籤',
            zh: '女僕裝',
            en: 'maid outfit',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'rezero_emilia',
      animeZh: 'Re:從零開始的異世界生活',
      animeEn: 'Re:Zero − Starting Life in Another World',
      animeTag: 're:zero_kara_hajimeru_isekai_seikatsu',
      characterZh: '艾蜜莉亞',
      characterEn: 'Emilia',
      characterTag: 'emilia_(re:zero)',
      traits: [
        CatalogTagData(
            id: 'emilia_silver_hair',
            group: '角色標籤',
            zh: '銀髮',
            en: 'silver hair',
            order: 1),
        CatalogTagData(
            id: 'emilia_purple_eyes',
            group: '角色標籤',
            zh: '紫色眼睛',
            en: 'purple eyes',
            order: 1),
        CatalogTagData(
            id: 'emilia_elf_ears',
            group: '角色標籤',
            zh: '精靈耳',
            en: 'elf ears',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'darling_zero_two',
      animeZh: 'DARLING in the FRANXX',
      animeEn: 'DARLING in the FRANXX',
      animeTag: 'darling_in_the_franxx',
      characterZh: '02',
      characterEn: 'Zero Two',
      characterTag: 'zero_two',
      traits: [
        CatalogTagData(
            id: '02_pink_hair',
            group: '角色標籤',
            zh: '粉紅長髮',
            en: 'long pink hair',
            order: 1),
        CatalogTagData(
            id: '02_red_eyes',
            group: '角色標籤',
            zh: '青綠眼睛',
            en: 'teal eyes',
            order: 1),
        CatalogTagData(
            id: '02_horns', group: '角色標籤', zh: '紅色角', en: 'red horns', order: 1)
      ]),
  CatalogCharacter(
      id: 'my_dressup_marin',
      animeZh: '更衣人偶墜入愛河',
      animeEn: 'My Dress-Up Darling',
      animeTag: 'sono_bisque_doll_wa_koi_wo_suru',
      characterZh: '喜多川海夢',
      characterEn: 'Marin Kitagawa',
      characterTag: 'kitagawa_marin',
      traits: [
        CatalogTagData(
            id: 'marin_blonde_hair',
            group: '角色標籤',
            zh: '金髮',
            en: 'blonde hair',
            order: 1),
        CatalogTagData(
            id: 'marin_brown_eyes',
            group: '角色標籤',
            zh: '棕色眼睛',
            en: 'brown eyes',
            order: 1),
        CatalogTagData(
            id: 'marin_earrings',
            group: '角色標籤',
            zh: '耳環',
            en: 'earrings',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'spy_family_yor',
      animeZh: 'SPY×FAMILY',
      animeEn: 'SPY x FAMILY',
      animeTag: 'spy_x_family',
      characterZh: '約兒・佛傑',
      characterEn: 'Yor Forger',
      characterTag: 'yor_briar',
      traits: [
        CatalogTagData(
            id: 'yor_black_hair',
            group: '角色標籤',
            zh: '黑色長髮',
            en: 'black hair',
            order: 1),
        CatalogTagData(
            id: 'yor_red_eyes',
            group: '角色標籤',
            zh: '紅眼睛',
            en: 'red eyes',
            order: 1),
        CatalogTagData(
            id: 'yor_hair_ornament',
            group: '角色標籤',
            zh: '金色髮飾',
            en: 'hair ornament',
            order: 1),
        CatalogTagData(
            id: 'yor_mature',
            group: '角色標籤',
            zh: '成年成熟外貌',
            en: 'mature female',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'chainsaw_man_power',
      animeZh: '鏈鋸人',
      animeEn: 'Chainsaw Man',
      animeTag: 'chainsaw_man',
      characterZh: '帕瓦',
      characterEn: 'Power',
      characterTag: 'power_(chainsaw_man)',
      traits: [
        CatalogTagData(
            id: 'power_blonde_hair',
            group: '角色標籤',
            zh: '金髮',
            en: 'blonde hair',
            order: 1),
        CatalogTagData(
            id: 'power_yellow_eyes',
            group: '角色標籤',
            zh: '黃眼睛',
            en: 'yellow eyes',
            order: 1),
        CatalogTagData(
            id: 'power_horns', group: '角色標籤', zh: '角', en: 'horns', order: 1)
      ]),
  CatalogCharacter(
      id: 'chainsaw_makima',
      animeZh: '鏈鋸人',
      animeEn: 'Chainsaw Man',
      animeTag: 'chainsaw_man',
      characterZh: '真紀真',
      characterEn: 'Makima',
      characterTag: 'makima',
      traits: [
        CatalogTagData(
            id: 'makima_red_hair',
            group: '角色標籤',
            zh: '紅髮',
            en: 'red hair',
            order: 1),
        CatalogTagData(
            id: 'makima_yellow_eyes',
            group: '角色標籤',
            zh: '黃眼睛',
            en: 'yellow eyes',
            order: 1),
        CatalogTagData(
            id: 'makima_suit',
            group: '角色標籤',
            zh: '西裝',
            en: 'business suit',
            order: 1),
        CatalogTagData(
            id: 'makima_mature',
            group: '角色標籤',
            zh: '成年成熟外貌',
            en: 'mature female',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'demon_slayer_nezuko',
      animeZh: '鬼滅之刃',
      animeEn: 'Demon Slayer: Kimetsu no Yaiba',
      animeTag: 'kimetsu_no_yaiba',
      characterZh: '竈門禰豆子',
      characterEn: 'Nezuko Kamado',
      characterTag: 'kamado_nezuko',
      traits: [
        CatalogTagData(
            id: 'nezuko_black_hair',
            group: '角色標籤',
            zh: '黑髮',
            en: 'black hair',
            order: 1),
        CatalogTagData(
            id: 'nezuko_pink_eyes',
            group: '角色標籤',
            zh: '粉紅眼睛',
            en: 'pink eyes',
            order: 1),
        CatalogTagData(
            id: 'nezuko_bamboo',
            group: '角色標籤',
            zh: '竹筒',
            en: 'bamboo gag',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'demon_slayer_shinobu',
      animeZh: '鬼滅之刃',
      animeEn: 'Demon Slayer: Kimetsu no Yaiba',
      animeTag: 'kimetsu_no_yaiba',
      characterZh: '胡蝶忍',
      characterEn: 'Shinobu Kocho',
      characterTag: 'kocho_shinobu',
      traits: [
        CatalogTagData(
            id: 'shinobu_purple_hair',
            group: '角色標籤',
            zh: '紫髮',
            en: 'purple hair',
            order: 1),
        CatalogTagData(
            id: 'shinobu_purple_eyes',
            group: '角色標籤',
            zh: '紫眼睛',
            en: 'purple eyes',
            order: 1),
        CatalogTagData(
            id: 'shinobu_butterfly',
            group: '角色標籤',
            zh: '蝴蝶髮飾',
            en: 'butterfly hair ornament',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'sailor_moon_usagi',
      animeZh: '美少女戰士',
      animeEn: 'Sailor Moon',
      animeTag: 'bishoujo_senshi_sailor_moon',
      characterZh: '月野兔',
      characterEn: 'Usagi Tsukino',
      characterTag: 'tsukino_usagi',
      traits: [
        CatalogTagData(
            id: 'usagi_blonde_twin',
            group: '角色標籤',
            zh: '金色雙丸子雙馬尾',
            en: 'blonde hair',
            order: 1),
        CatalogTagData(
            id: 'usagi_blue_eyes',
            group: '角色標籤',
            zh: '藍眼睛',
            en: 'blue eyes',
            order: 1),
        CatalogTagData(
            id: 'usagi_odango',
            group: '角色標籤',
            zh: '丸子頭',
            en: 'odango',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'evangelion_rei',
      animeZh: '新世紀福音戰士',
      animeEn: 'Neon Genesis Evangelion',
      animeTag: 'neon_genesis_evangelion',
      characterZh: '綾波零',
      characterEn: 'Rei Ayanami',
      characterTag: 'ayanami_rei',
      traits: [
        CatalogTagData(
            id: 'rei_blue_hair',
            group: '角色標籤',
            zh: '藍髮',
            en: 'blue hair',
            order: 1),
        CatalogTagData(
            id: 'rei_red_eyes',
            group: '角色標籤',
            zh: '紅眼睛',
            en: 'red eyes',
            order: 1),
        CatalogTagData(
            id: 'rei_short_hair',
            group: '角色標籤',
            zh: '短髮',
            en: 'short hair',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'evangelion_asuka',
      animeZh: '新世紀福音戰士',
      animeEn: 'Neon Genesis Evangelion',
      animeTag: 'neon_genesis_evangelion',
      characterZh: '惣流・明日香・蘭格雷',
      characterEn: 'Asuka Langley Soryu',
      characterTag: 'souryuu_asuka_langley',
      traits: [
        CatalogTagData(
            id: 'asuka_red_hair',
            group: '角色標籤',
            zh: '紅髮',
            en: 'red hair',
            order: 1),
        CatalogTagData(
            id: 'asuka_blue_eyes',
            group: '角色標籤',
            zh: '藍眼睛',
            en: 'blue eyes',
            order: 1),
        CatalogTagData(
            id: 'asuka_hairclips',
            group: '角色標籤',
            zh: '髮夾',
            en: 'hair clips',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'one_piece_nami',
      animeZh: 'ONE PIECE',
      animeEn: 'One Piece',
      animeTag: 'one_piece',
      characterZh: '娜美',
      characterEn: 'Nami',
      characterTag: 'nami',
      traits: [
        CatalogTagData(
            id: 'nami_orange_hair',
            group: '角色標籤',
            zh: '橘色頭髮',
            en: 'orange hair',
            order: 1),
        CatalogTagData(
            id: 'nami_brown_eyes',
            group: '角色標籤',
            zh: '棕色眼睛',
            en: 'brown eyes',
            order: 1),
        CatalogTagData(
            id: 'nami_tattoo', group: '角色標籤', zh: '刺青', en: 'tattoo', order: 1)
      ]),
  CatalogCharacter(
      id: 'one_piece_robin',
      animeZh: 'ONE PIECE',
      animeEn: 'One Piece',
      animeTag: 'one_piece',
      characterZh: '妮可・羅賓',
      characterEn: 'Nico Robin',
      characterTag: 'nico_robin',
      traits: [
        CatalogTagData(
            id: 'robin_black_hair',
            group: '角色標籤',
            zh: '黑髮',
            en: 'black hair',
            order: 1),
        CatalogTagData(
            id: 'robin_blue_eyes',
            group: '角色標籤',
            zh: '藍眼睛',
            en: 'blue eyes',
            order: 1),
        CatalogTagData(
            id: 'robin_mature',
            group: '角色標籤',
            zh: '成年成熟外貌',
            en: 'mature female',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'fairy_tail_erza',
      animeZh: 'FAIRY TAIL',
      animeEn: 'Fairy Tail',
      animeTag: 'fairy_tail',
      characterZh: '艾爾莎・史卡雷特',
      characterEn: 'Erza Scarlet',
      characterTag: 'erza_scarlet',
      traits: [
        CatalogTagData(
            id: 'erza_red_hair',
            group: '角色標籤',
            zh: '紅髮',
            en: 'red hair',
            order: 1),
        CatalogTagData(
            id: 'erza_brown_eyes',
            group: '角色標籤',
            zh: '棕色眼睛',
            en: 'brown eyes',
            order: 1),
        CatalogTagData(
            id: 'erza_armor', group: '角色標籤', zh: '鎧甲', en: 'armor', order: 1)
      ]),
  CatalogCharacter(
      id: 'fairy_tail_lucy',
      animeZh: 'FAIRY TAIL',
      animeEn: 'Fairy Tail',
      animeTag: 'fairy_tail',
      characterZh: '露西・哈特菲利亞',
      characterEn: 'Lucy Heartfilia',
      characterTag: 'lucy_heartfilia',
      traits: [
        CatalogTagData(
            id: 'lucy_blonde_hair',
            group: '角色標籤',
            zh: '金髮',
            en: 'blonde hair',
            order: 1),
        CatalogTagData(
            id: 'lucy_brown_eyes',
            group: '角色標籤',
            zh: '棕色眼睛',
            en: 'brown eyes',
            order: 1),
        CatalogTagData(
            id: 'lucy_celestial_keys',
            group: '角色標籤',
            zh: '星靈鑰匙',
            en: 'celestial spirit keys',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'highschool_dxd_rias',
      animeZh: 'High School DxD',
      animeEn: 'High School DxD',
      animeTag: 'highschool_dxd',
      characterZh: '莉雅絲・吉蒙里',
      characterEn: 'Rias Gremory',
      characterTag: 'rias_gremory',
      traits: [
        CatalogTagData(
            id: 'rias_red_hair',
            group: '角色標籤',
            zh: '紅色長髮',
            en: 'long red hair',
            order: 1),
        CatalogTagData(
            id: 'rias_blue_eyes',
            group: '角色標籤',
            zh: '藍眼睛',
            en: 'blue eyes',
            order: 1),
        CatalogTagData(
            id: 'rias_curvy',
            group: '角色標籤',
            zh: '曲線身材',
            en: 'curvy',
            order: 1,
            adult: true)
      ]),
  CatalogCharacter(
      id: 'kaguya_kaguya',
      animeZh: '輝夜姬想讓人告白',
      animeEn: 'Kaguya-sama: Love Is War',
      animeTag: 'kaguya-sama_wa_kokurasetai',
      characterZh: '四宮輝夜',
      characterEn: 'Kaguya Shinomiya',
      characterTag: 'shinomiya_kaguya',
      traits: [
        CatalogTagData(
            id: 'kaguya_black_hair',
            group: '角色標籤',
            zh: '黑髮',
            en: 'black hair',
            order: 1),
        CatalogTagData(
            id: 'kaguya_red_eyes',
            group: '角色標籤',
            zh: '紅眼睛',
            en: 'red eyes',
            order: 1),
        CatalogTagData(
            id: 'kaguya_ribbon',
            group: '角色標籤',
            zh: '髮帶',
            en: 'hair ribbon',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'oshi_no_ko_ai',
      animeZh: '【我推的孩子】',
      animeEn: 'Oshi no Ko',
      animeTag: 'oshi_no_ko',
      characterZh: '星野愛',
      characterEn: 'Ai Hoshino',
      characterTag: 'hoshino_ai',
      traits: [
        CatalogTagData(
            id: 'ai_purple_hair',
            group: '角色標籤',
            zh: '紫色長髮',
            en: 'long purple hair',
            order: 1),
        CatalogTagData(
            id: 'ai_star_eyes',
            group: '角色標籤',
            zh: '星星眼',
            en: 'star-shaped pupils',
            order: 1),
        CatalogTagData(
            id: 'ai_idol', group: '角色標籤', zh: '偶像', en: 'idol', order: 1)
      ]),
  CatalogCharacter(
      id: 'frieren_frieren',
      animeZh: '葬送的芙莉蓮',
      animeEn: 'Frieren: Beyond Journey\'s End',
      animeTag: 'sousou_no_frieren',
      characterZh: '芙莉蓮',
      characterEn: 'Frieren',
      characterTag: 'frieren',
      traits: [
        CatalogTagData(
            id: 'frieren_white_hair',
            group: '角色標籤',
            zh: '白髮',
            en: 'white hair',
            order: 1),
        CatalogTagData(
            id: 'frieren_green_eyes',
            group: '角色標籤',
            zh: '綠眼睛',
            en: 'green eyes',
            order: 1),
        CatalogTagData(
            id: 'frieren_elf_ears',
            group: '角色標籤',
            zh: '精靈耳',
            en: 'elf ears',
            order: 1)
      ]),
  CatalogCharacter(
      id: 'konosuba_megumin',
      animeZh: '為美好的世界獻上祝福！',
      animeEn: 'KonoSuba',
      animeTag: 'kono_subarashii_sekai_ni_shukufuku_wo!',
      characterZh: '惠惠',
      characterEn: 'Megumin',
      characterTag: 'megumin',
      traits: [
        CatalogTagData(
            id: 'megumin_black_hair',
            group: '角色標籤',
            zh: '黑髮',
            en: 'black hair',
            order: 1),
        CatalogTagData(
            id: 'megumin_red_eyes',
            group: '角色標籤',
            zh: '紅眼睛',
            en: 'red eyes',
            order: 1),
        CatalogTagData(
            id: 'megumin_witch_hat',
            group: '角色標籤',
            zh: '魔女帽',
            en: 'witch hat',
            order: 1)
      ]),
];
