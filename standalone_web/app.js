/* BetterWaifu Prompt Atelier — dependency-free browser version. */
const STORAGE_KEY = 'betterwaifu_prompt_builder_state_v2';

const tag = (id, group, zh, en, order, adult = false, conflictGroup = '') => ({
  id, group, zh, en, order, adult, conflictGroup, builtIn: true
});

// Curated bilingual seed catalogue. Users can add any missing Danbooru-style tag.
const seedTags = [
  tag('scene_bedroom', '場景', '臥室', 'bedroom', 6, false, 'scene'),
  tag('scene_bathroom', '場景', '浴室', 'bathroom', 6, false, 'scene'),
  tag('scene_classroom', '場景', '教室', 'classroom', 6, false, 'scene'),
  tag('scene_beach', '場景', '海灘', 'beach', 6, false, 'scene'),
  tag('scene_cherry', '場景', '櫻花樹下', 'cherry blossoms', 6, false, 'scene'),
  tag('scene_night', '場景', '夜晚', 'night', 6, false, 'time'),
  tag('scene_sunset', '場景', '夕陽', 'sunset', 6, false, 'time'),
  tag('scene_simple', '場景', '簡潔背景', 'simple background', 6, false, 'scene'),
  tag('camera_portrait', '畫面', '肖像構圖', 'portrait', 7, false, 'framing'),
  tag('camera_fullbody', '畫面', '全身', 'full body', 7, false, 'framing'),
  tag('camera_upperbody', '畫面', '上半身', 'upper body', 7, false, 'framing'),
  tag('camera_closeup', '畫面', '特寫', 'close-up', 7, false, 'framing'),
  tag('camera_cowboy', '畫面', '牛仔鏡頭', 'cowboy shot', 7, false, 'framing'),
  tag('camera_above', '畫面', '俯視角度', 'from above', 7, false, 'camera'),
  tag('camera_below', '畫面', '仰視角度', 'from below', 7, false, 'camera'),
  tag('camera_pov', '畫面', '第一人稱視角', 'pov', 7, false, 'camera'),

  tag('trait_long_hair', '外觀特徵', '長髮', 'long hair', 1),
  tag('trait_short_hair', '外觀特徵', '短髮', 'short hair', 1),
  tag('trait_hair_between', '外觀特徵', '瀏海遮眼', 'hair between eyes', 1),
  tag('trait_blonde', '外觀特徵', '金髮', 'blonde hair', 1, false, 'hair_color'),
  tag('trait_black_hair', '外觀特徵', '黑髮', 'black hair', 1, false, 'hair_color'),
  tag('trait_silver', '外觀特徵', '銀髮', 'silver hair', 1, false, 'hair_color'),
  tag('trait_blue_hair', '外觀特徵', '藍髮', 'blue hair', 1, false, 'hair_color'),
  tag('trait_red_hair', '外觀特徵', '紅髮', 'red hair', 1, false, 'hair_color'),
  tag('trait_pink_hair', '外觀特徵', '粉紅髮', 'pink hair', 1, false, 'hair_color'),
  tag('trait_green_eyes', '臉部特徵', '綠眼睛', 'green eyes', 1, false, 'eye_color'),
  tag('trait_blue_eyes', '臉部特徵', '藍眼睛', 'blue eyes', 1, false, 'eye_color'),
  tag('trait_red_eyes', '臉部特徵', '紅眼睛', 'red eyes', 1, false, 'eye_color'),
  tag('trait_purple_eyes', '臉部特徵', '紫眼睛', 'purple eyes', 1, false, 'eye_color'),
  tag('trait_ahoge', '臉部特徵', '呆毛', 'ahoge', 1),
  tag('trait_fangs', '臉部特徵', '虎牙', 'fangs', 1),
  tag('trait_pointed_ears', '臉部特徵', '尖耳朵', 'pointed ears', 1),
  tag('trait_horns', '臉部特徵', '角', 'horns', 1),
  tag('trait_eyebrows', '臉部特徵', '眉毛', 'eyebrows', 1),
  tag('trait_eyelashes', '臉部特徵', '睫毛', 'eyelashes', 1),
  tag('trait_earrings', '臉部特徵', '耳環', 'earrings', 1),
  tag('trait_makeup', '臉部特徵', '化妝', 'makeup', 1),
  tag('trait_slim', '外觀特徵', '纖細身材', 'slim', 1, false, 'body_type'),
  tag('trait_tall', '外觀特徵', '高挑身材', 'tall', 1, false, 'body_type'),
  tag('trait_curvy', '外觀特徵', '曲線身材', 'curvy', 1, false, 'body_type'),
  tag('trait_tail', '外觀特徵', '尾巴', 'tail', 1),
  tag('trait_heart_tail', '外觀特徵', '黑色心型尾巴', 'black heart-shaped tail', 1),
  tag('trait_tattoo', '外觀特徵', '刺青', 'tattoo', 1),
  tag('trait_wings', '外觀特徵', '翅膀', 'wings', 1),

  tag('breast_flat', '胸部', '平胸', 'flat chest', 1, false, 'breast_size'),
  tag('breast_small', '胸部', '小胸部', 'small breasts', 1, false, 'breast_size'),
  tag('breast_medium', '胸部', '中等胸部', 'medium breasts', 1, false, 'breast_size'),
  tag('breast_large', '胸部', '大胸部', 'large breasts', 1, false, 'breast_size'),
  tag('breast_huge', '胸部', '巨乳', 'huge breasts', 1, true, 'breast_size'),
  tag('breast_cleavage', '胸部', '乳溝', 'cleavage', 1, true),
  tag('breast_nipples', '胸部', '乳頭', 'nipples', 1, true),
  tag('breast_press', '胸部', '擠乳', 'breast press', 1, true),
  tag('nude', '裸露', '全裸', 'nude', 1, true, 'nudity'),
  tag('topless', '裸露', '上空', 'topless', 1, true, 'topless'),
  tag('bottomless', '裸露', '下空', 'bottomless', 1, true, 'bottomless'),
  tag('bare_shoulders', '裸露', '裸肩', 'bare shoulders', 1),
  tag('bare_legs', '裸露', '裸腿', 'bare legs', 1),
  tag('barefoot', '裸露', '赤腳', 'barefoot', 1),
  tag('midriff', '裸露', '露腹', 'midriff', 1),
  tag('covering_breasts', '裸露', '遮住胸部', 'covering breasts', 1, true),
  tag('covering_crotch', '裸露', '遮住胯部', 'covering crotch', 1, true),

  tag('top_tshirt', '上衣', 'T恤', 't-shirt', 2, false, 'top'),
  tag('top_shirt', '上衣', '襯衫', 'shirt', 2, false, 'top'),
  tag('top_blouse', '上衣', '女式襯衫', 'blouse', 2, false, 'top'),
  tag('top_sweater', '上衣', '毛衣', 'sweater', 2, false, 'top'),
  tag('top_hoodie', '上衣', '連帽衫', 'hoodie', 2, false, 'top'),
  tag('top_jacket', '上衣', '夾克', 'jacket', 2, false, 'top'),
  tag('top_crop', '上衣', '短版上衣', 'crop top', 2, false, 'top'),
  tag('top_offshoulder', '上衣', '露肩上衣', 'off-shoulder shirt', 2, false, 'top'),
  tag('top_tank', '上衣', '背心', 'tank top', 2, false, 'top'),
  tag('top_bodysuit', '上衣', '連身衣', 'bodysuit', 2, false, 'one_piece'),
  tag('bottom_jeans', '褲子', '牛仔褲', 'jeans', 2, false, 'bottom'),
  tag('bottom_shorts', '褲子', '短褲', 'shorts', 2, false, 'bottom'),
  tag('bottom_hotpants', '褲子', '熱褲', 'hot pants', 2, false, 'bottom'),
  tag('bottom_trousers', '褲子', '長褲', 'trousers', 2, false, 'bottom'),
  tag('bottom_leggings', '褲子', '緊身褲', 'leggings', 2, false, 'bottom'),
  tag('bottom_casual', '褲子', '休閒褲', 'casual pants', 2, false, 'bottom'),
  tag('skirt', '裙子', '裙子', 'skirt', 2, false, 'bottom'),
  tag('miniskirt', '裙子', '迷你裙', 'miniskirt', 2, false, 'bottom'),
  tag('pleated_skirt', '裙子', '百褶裙', 'pleated skirt', 2, false, 'bottom'),
  tag('long_skirt', '裙子', '長裙', 'long skirt', 2, false, 'bottom'),
  tag('dress', '服裝', '洋裝', 'dress', 2, false, 'one_piece'),
  tag('sundress', '服裝', '夏日洋裝', 'sundress', 2, false, 'one_piece'),
  tag('uniform', '服裝', '制服', 'school uniform', 2, false, 'one_piece'),
  tag('suit', '服裝', '西裝', 'business suit', 2, false, 'one_piece'),
  tag('kimono', '服裝', '和服', 'kimono', 2, false, 'one_piece'),
  tag('yukata', '服裝', '浴衣', 'yukata', 2, false, 'one_piece'),
  tag('apron', '服裝', '圍裙', 'apron', 2),
  tag('swimsuit', '服裝', '泳裝', 'swimsuit', 2, false, 'one_piece'),
  tag('bikini', '服裝', '比基尼', 'bikini', 2, false, 'one_piece'),
  tag('maid', '服裝', '女僕服', 'maid outfit', 2, false, 'one_piece'),
  tag('nurse_uniform', '服裝', '護士服', 'nurse uniform', 2, false, 'one_piece'),
  tag('bra', '胸罩', '胸罩', 'bra', 2, true, 'bra'),
  tag('sports_bra', '胸罩', '運動胸罩', 'sports bra', 2, false, 'bra'),
  tag('lace_bra', '胸罩', '蕾絲胸罩', 'lace bra', 2, true, 'bra'),
  tag('strapless_bra', '胸罩', '無肩帶胸罩', 'strapless bra', 2, true, 'bra'),
  tag('panties', '內褲', '內褲', 'panties', 2, true, 'underwear'),
  tag('highleg_panties', '內褲', '高腰高叉內褲', 'highleg panties', 2, true, 'underwear'),
  tag('thong', '內褲', '丁字褲', 'thong', 2, true, 'underwear'),
  tag('bloomers', '內褲', '燈籠褲', 'bloomers', 2, false, 'underwear'),
  tag('socks', '襪子', '短襪', 'socks', 2, false, 'legwear'),
  tag('ankle_socks', '襪子', '踝襪', 'ankle socks', 2, false, 'legwear'),
  tag('kneehighs', '襪子', '膝上襪', 'knee highs', 2, false, 'legwear'),
  tag('thighhighs', '襪子', '大腿襪', 'thighhighs', 2, false, 'legwear'),
  tag('pantyhose', '襪子', '連褲襪', 'pantyhose', 2, false, 'legwear'),
  tag('fishnet', '襪子', '網襪', 'fishnet legwear', 2, false, 'legwear'),
  tag('sneakers', '鞋子', '運動鞋', 'sneakers', 2, false, 'footwear'),
  tag('boots', '鞋子', '靴子', 'boots', 2, false, 'footwear'),
  tag('heels', '鞋子', '高跟鞋', 'high heels', 2, false, 'footwear'),
  tag('sandals', '鞋子', '涼鞋', 'sandals', 2, false, 'footwear'),
  tag('loafers', '鞋子', '樂福鞋', 'loafers', 2, false, 'footwear'),
  tag('gloves', '配件', '手套', 'gloves', 2),
  tag('ribbon', '配件', '髮帶', 'hair ribbon', 2),
  tag('choker', '配件', '頸圈', 'choker', 2),
  tag('glasses', '配件', '眼鏡', 'glasses', 2),
  tag('hat', '配件', '帽子', 'hat', 2),
  tag('backpack', '配件', '背包', 'backpack', 2),

  tag('color_black', '服裝顏色', '黑色', 'black', 2, false, 'clothing_color'),
  tag('color_white', '服裝顏色', '白色', 'white', 2, false, 'clothing_color'),
  tag('color_red', '服裝顏色', '紅色', 'red', 2, false, 'clothing_color'),
  tag('color_blue', '服裝顏色', '藍色', 'blue', 2, false, 'clothing_color'),
  tag('color_pink', '服裝顏色', '粉紅色', 'pink', 2, false, 'clothing_color'),
  tag('color_purple', '服裝顏色', '紫色', 'purple', 2, false, 'clothing_color'),
  tag('color_green', '服裝顏色', '綠色', 'green', 2, false, 'clothing_color'),
  tag('color_yellow', '服裝顏色', '黃色', 'yellow', 2, false, 'clothing_color'),
  tag('color_brown', '服裝顏色', '棕色', 'brown', 2, false, 'clothing_color'),
  tag('detail_lace', '服裝細節', '蕾絲', 'lace', 2),
  tag('detail_frills', '服裝細節', '荷葉邊', 'frills', 2),
  tag('detail_ribbon', '服裝細節', '蝴蝶結', 'bow', 2),
  tag('detail_stripes', '服裝細節', '條紋', 'striped', 2),
  tag('detail_ruffles', '服裝細節', '皺褶', 'ruffles', 2),
  tag('detail_buttons', '服裝細節', '鈕扣', 'buttons', 2),
  tag('detail_pockets', '服裝細節', '口袋', 'pockets', 2),
  tag('detail_translucent', '服裝細節', '半透明', 'translucent clothing', 2),
  tag('material_cotton', '服裝材質', '棉質', 'cotton', 2),
  tag('material_silk', '服裝材質', '絲綢', 'silk', 2),
  tag('material_leather', '服裝材質', '皮革', 'leather', 2),
  tag('material_denim', '服裝材質', '丹寧布', 'denim', 2),
  tag('material_wool', '服裝材質', '羊毛', 'wool', 2),
  tag('state_undressing', '穿脫狀態', '正在脫衣', 'undressing', 2, true, 'wear_state'),
  tag('state_dressed', '穿脫狀態', '穿著整齊', 'fully dressed', 2, false, 'wear_state'),
  tag('state_open_clothes', '穿脫狀態', '衣服敞開', 'open clothes', 2, true),
  tag('state_unbuttoned', '穿脫狀態', '解開鈕扣', 'unbuttoned', 2, true),
  tag('state_wardrobe_malfunction', '穿脫狀態', '衣物走光', 'wardrobe malfunction', 2, true),

  tag('expr_smile', '表情', '微笑', 'smile', 3, false, 'expression_mouth'),
  tag('expr_grin', '表情', '咧嘴笑', 'grin', 3, false, 'expression_mouth'),
  tag('expr_open_mouth', '表情', '張嘴', 'open mouth', 3, false, 'expression_mouth'),
  tag('expr_blush', '表情', '臉紅', 'blush', 3),
  tag('expr_closed_eyes', '表情', '閉眼', 'closed eyes', 3, false, 'expression_eyes'),
  tag('expr_wink', '表情', '眨眼', 'wink', 3, false, 'expression_eyes'),
  tag('expr_tears', '表情', '眼淚', 'tears', 3),
  tag('expr_surprised', '表情', '驚訝', 'surprised', 3, false, 'expression_mood'),
  tag('expr_embarrassed', '表情', '害羞', 'embarrassed', 3, false, 'expression_mood'),
  tag('expr_serious', '表情', '嚴肅', 'serious', 3, false, 'expression_mood'),
  tag('expr_angry', '表情', '生氣', 'angry', 3, false, 'expression_mood'),
  tag('expr_ahegao', '表情', '陶醉表情', 'ahegao', 3, true),
  tag('expr_orgasm', '表情', '高潮表情', 'orgasm', 3, true),

  tag('pose_standing', '姿勢', '站立', 'standing', 4, false, 'basic_pose'),
  tag('pose_sitting', '姿勢', '坐姿', 'sitting', 4, false, 'basic_pose'),
  tag('pose_kneeling', '姿勢', '跪姿', 'kneeling', 4, false, 'basic_pose'),
  tag('pose_lying', '姿勢', '躺姿', 'lying', 4, false, 'basic_pose'),
  tag('pose_side_lying', '姿勢', '側躺', 'lying on side', 4, false, 'basic_pose'),
  tag('pose_squatting', '姿勢', '蹲姿', 'squatting', 4, false, 'basic_pose'),
  tag('pose_arms_up', '姿勢', '雙手舉起', 'arms up', 4),
  tag('pose_hand_hip', '姿勢', '手放腰上', 'hand on hip', 4),
  tag('pose_leaning', '姿勢', '倚靠', 'leaning', 4),
  tag('pose_bent_over', '姿勢', '彎腰', 'bent over', 4, true),
  tag('pose_presenting', '姿勢', '展示姿勢', 'presenting', 4, true),
  tag('pose_ass_up', '姿勢', '翹臀', 'ass up', 4, true),
  tag('pose_from_behind', '姿勢', '背後視角', 'from behind', 4),
  tag('pose_selfie', '姿勢', '自拍', 'selfie', 4),
  tag('act_kissing', '性行為', '接吻', 'kissing', 5),
  tag('act_sex', '性行為', '性交', 'sex', 5, true),
  tag('act_vaginal', '性行為', '陰道性交', 'vaginal', 5, true),
  tag('act_anal', '性行為', '肛交', 'anal', 5, true),
  tag('act_oral', '性行為', '口交', 'oral', 5, true),
  tag('act_blowjob', '性行為', '口交行為', 'blowjob', 5, true),
  tag('act_handjob', '性行為', '手交', 'handjob', 5, true),
  tag('act_fingering', '性行為', '手指插入', 'fingering', 5, true),
  tag('act_masturbation', '性行為', '自慰', 'masturbation', 5, true),
  tag('act_grinding', '性行為', '磨蹭', 'grinding', 5, true),
  tag('act_bondage', '性行為', '束縛', 'bondage', 5, true),
  tag('act_bdsm', '性行為', 'BDSM', 'BDSM', 5, true),
  tag('pos_missionary', '性姿勢', '正常位', 'missionary', 5, true, 'sex_position'),
  tag('pos_cowgirl', '性姿勢', '女上位', 'cowgirl position', 5, true, 'sex_position'),
  tag('pos_reverse_cowgirl', '性姿勢', '背面女上位', 'reverse cowgirl', 5, true, 'sex_position'),
  tag('pos_doggy', '性姿勢', '後背位', 'doggystyle', 5, true, 'sex_position'),
  tag('pos_standing_sex', '性姿勢', '站立性愛', 'standing sex', 5, true, 'sex_position'),
  tag('pos_riding', '性姿勢', '騎乘', 'riding', 5, true, 'sex_position'),
  tag('pos_sixty_nine', '性姿勢', '六九式', 'sixty-nine', 5, true, 'sex_position'),
  tag('pos_group_sex', '性姿勢', '多人性愛', 'group sex', 5, true, 'sex_position'),

  tag('quality_masterpiece', '品質', '傑作', 'masterpiece', 10),
  tag('quality_best', '品質', '最佳品質', 'best quality', 10),
  tag('quality_newest', '品質', '最新風格', 'newest', 10),
  tag('quality_absurdres', '品質', '超高解析度', 'absurdres', 10),
  tag('quality_highres', '品質', '高解析度', 'highres', 10),
  tag('quality_detailed', '品質', '細節豐富', 'highly detailed', 10),
  tag('quality_lighting', '品質', '專業光線', 'professional lighting', 10),
  tag('quality_anime', '品質', '動漫風格', 'anime style', 10)
];

const trait = (zh, en) => ({ zh, en });
const character = (id, animeZh, animeEn, animeTag, characterZh, characterEn, characterTag, traits) => ({
  id, animeZh, animeEn, animeTag, characterZh, characterEn, characterTag, traits
});

// Common starting library. The custom character form intentionally remains available for every other title.
const catalogCharacters = [
  character('lala', '出包王女', 'To LOVE-Ru', 'to_love-ru', '拉拉・撒塔林・戴比路克', 'Lala Satalin Deviluke', 'lala_satalin_deviluke', [trait('粉紅色頭髮', 'pink hair'), trait('呆毛', 'ahoge'), trait('綠眼睛', 'green eyes'), trait('黑色心型尾巴', 'black heart-shaped tail'), trait('纖細身材', 'slim'), trait('中等胸部', 'medium breasts')]),
  character('momo', '出包王女', 'To LOVE-Ru', 'to_love-ru', '夢夢・貝莉雅・戴比路克', 'Momo Velia Deviluke', 'momo_velia_deviluke', [trait('粉紅色頭髮', 'pink hair'), trait('綠眼睛', 'green eyes'), trait('惡魔尾巴', 'devil tail'), trait('中等胸部', 'medium breasts')]),
  character('yui', '出包王女', 'To LOVE-Ru', 'to_love-ru', '古手川唯', 'Yui Kotegawa', 'yui_kotegawa', [trait('黑色長髮', 'black hair'), trait('紫色眼睛', 'purple eyes'), trait('纖細身材', 'slim')]),
  character('miku', 'VOCALOID', 'Vocaloid', 'vocaloid', '初音未來', 'Hatsune Miku', 'hatsune_miku', [trait('藍綠色長髮', 'aqua hair'), trait('雙馬尾', 'twintails'), trait('藍綠色眼睛', 'aqua eyes')]),
  character('asuna', '刀劍神域', 'Sword Art Online', 'sword_art_online', '結城明日奈', 'Asuna Yuuki', 'asuna_yuuki', [trait('棕色長髮', 'brown hair'), trait('棕色眼睛', 'brown eyes'), trait('纖細身材', 'slim')]),
  character('rem', 'Re:從零開始的異世界生活', 'Re:ZERO', 're_zero_kara_hajimeru_isekai_seikatsu', '雷姆', 'Rem', 'rem_(re:zero)', [trait('藍髮', 'blue hair'), trait('藍眼睛', 'blue eyes'), trait('短髮', 'short hair')]),
  character('ram', 'Re:從零開始的異世界生活', 'Re:ZERO', 're_zero_kara_hajimeru_isekai_seikatsu', '拉姆', 'Ram', 'ram_(re:zero)', [trait('粉紅髮', 'pink hair'), trait('紅眼睛', 'red eyes'), trait('短髮', 'short hair')]),
  character('emilia', 'Re:從零開始的異世界生活', 'Re:ZERO', 're_zero_kara_hajimeru_isekai_seikatsu', '艾蜜莉亞', 'Emilia', 'emilia_(re:zero)', [trait('銀髮', 'silver hair'), trait('紫色眼睛', 'purple eyes'), trait('尖耳朵', 'pointed ears')]),
  character('zero_two', 'DARLING in the FRANXX', 'DARLING in the FRANXX', 'darling_in_the_franxx', '02', 'Zero Two', 'zero_two', [trait('粉紅長髮', 'pink long hair'), trait('青綠色眼睛', 'aqua eyes'), trait('角', 'horns')]),
  character('marin', '更衣人偶夢見我', 'My Dress-Up Darling', 'sono_bisque_doll_wa_koi_wo_suru', '喜多川海夢', 'Marin Kitagawa', 'kitagawa_marin', [trait('金髮', 'blonde hair'), trait('紅眼睛', 'red eyes'), trait('辣妹', 'gyaru')]),
  character('yor', 'SPY×FAMILY 間諜家家酒', 'SPY x FAMILY', 'spy_x_family', '約兒・佛傑', 'Yor Forger', 'yor_forger', [trait('黑色長髮', 'black hair'), trait('紅眼睛', 'red eyes'), trait('纖細身材', 'slim')]),
  character('power', '鏈鋸人', 'Chainsaw Man', 'chainsaw_man', '帕瓦', 'Power', 'power_(chainsaw_man)', [trait('金髮', 'blonde hair'), trait('金色眼睛', 'yellow eyes'), trait('角', 'horns')]),
  character('makima', '鏈鋸人', 'Chainsaw Man', 'chainsaw_man', '真紀真', 'Makima', 'makima', [trait('紅髮', 'red hair'), trait('黃色眼睛', 'yellow eyes'), trait('辮子', 'braid')]),
  character('nezuko', '鬼滅之刃', 'Demon Slayer', 'kimetsu_no_yaiba', '竈門禰豆子', 'Nezuko Kamado', 'kamado_nezuko', [trait('黑髮', 'black hair'), trait('粉紅眼睛', 'pink eyes'), trait('竹筒', 'bamboo gag')]),
  character('shinobu', '鬼滅之刃', 'Demon Slayer', 'kimetsu_no_yaiba', '胡蝶忍', 'Shinobu Kocho', 'kocho_shinobu', [trait('紫髮', 'purple hair'), trait('紫色眼睛', 'purple eyes'), trait('蝴蝶髮飾', 'butterfly hair ornament')]),
  character('usagi', '美少女戰士', 'Sailor Moon', 'sailor_moon', '月野兔', 'Usagi Tsukino', 'tsukino_usagi', [trait('金髮', 'blonde hair'), trait('藍眼睛', 'blue eyes'), trait('雙馬尾', 'twintails')]),
  character('rei', '新世紀福音戰士', 'Neon Genesis Evangelion', 'neon_genesis_evangelion', '綾波零', 'Rei Ayanami', 'ayanami_rei', [trait('藍髮', 'blue hair'), trait('紅眼睛', 'red eyes'), trait('短髮', 'short hair')]),
  character('asuka', '新世紀福音戰士', 'Neon Genesis Evangelion', 'neon_genesis_evangelion', '惣流・明日香・蘭格雷', 'Asuka Langley Soryu', 'souryuu_asuka_langley', [trait('紅髮', 'red hair'), trait('藍眼睛', 'blue eyes'), trait('髮夾', 'hairclip')]),
  character('nami', 'ONE PIECE', 'One Piece', 'one_piece', '娜美', 'Nami', 'nami', [trait('橘髮', 'orange hair'), trait('棕色眼睛', 'brown eyes'), trait('刺青', 'tattoo')]),
  character('robin', 'ONE PIECE', 'One Piece', 'one_piece', '妮可・羅賓', 'Nico Robin', 'nico_robin', [trait('黑髮', 'black hair'), trait('藍色眼睛', 'blue eyes'), trait('高挑身材', 'tall')]),
  character('erza', 'FAIRY TAIL 魔導少年', 'Fairy Tail', 'fairy_tail', '艾爾莎・史卡雷特', 'Erza Scarlet', 'erza_scarlet', [trait('紅髮', 'red hair'), trait('棕色眼睛', 'brown eyes'), trait('盔甲', 'armor')]),
  character('lucy', 'FAIRY TAIL 魔導少年', 'Fairy Tail', 'fairy_tail', '露西・哈特菲利亞', 'Lucy Heartfilia', 'lucy_heartfilia', [trait('金髮', 'blonde hair'), trait('棕色眼睛', 'brown eyes'), trait('纖細身材', 'slim')]),
  character('rias', 'High School DxD', 'High School DxD', 'high_school_dxd', '莉雅絲・吉蒙里', 'Rias Gremory', 'rias_gremory', [trait('紅髮', 'red hair'), trait('藍眼睛', 'blue eyes'), trait('大胸部', 'large breasts')]),
  character('kaguya', '輝夜姬想讓人告白', 'Kaguya-sama: Love Is War', 'kaguya-sama_wa_kokurasetai', '四宮輝夜', 'Kaguya Shinomiya', 'shinomiya_kaguya', [trait('黑髮', 'black hair'), trait('紅眼睛', 'red eyes'), trait('長髮', 'long hair')]),
  character('ai', '【我推的孩子】', 'Oshi no Ko', 'oshi_no_ko', '星野愛', 'Ai Hoshino', 'hoshino_ai', [trait('紫色長髮', 'purple long hair'), trait('星星眼', 'star-shaped pupils'), trait('粉紅髮飾', 'pink hair ornament')]),
  character('frieren', '葬送的芙莉蓮', 'Frieren: Beyond Journey\'s End', 'sousou_no_frieren', '芙莉蓮', 'Frieren', 'frieren', [trait('白髮', 'white hair'), trait('綠眼睛', 'green eyes'), trait('精靈耳', 'elf ears')]),
  character('megumin', '為美好的世界獻上祝福', 'KonoSuba', 'kono_subarashii_sekai_ni_shukufuku_wo', '惠惠', 'Megumin', 'megumin', [trait('黑髮', 'black hair'), trait('紅眼睛', 'red eyes'), trait('眼罩', 'eyepatch')]),
  character('saber', 'Fate/stay night', 'Fate/stay night', 'fate_stay_night', '阿爾托莉雅・潘德拉剛', 'Saber', 'saber', [trait('金髮', 'blonde hair'), trait('綠眼睛', 'green eyes'), trait('辮子', 'braid')]),
  character('kurisu', 'STEINS;GATE', 'Steins;Gate', 'steins;gate', '牧瀨紅莉栖', 'Kurisu Makise', 'makise_kurisu', [trait('紅髮', 'red hair'), trait('紫色眼睛', 'purple eyes'), trait('長髮', 'long hair')]),
  character('chitoge', '偽戀', 'Nisekoi', 'nisekoi', '桐崎千棘', 'Chitoge Kirisaki', 'kirisaki_chitoge', [trait('金髮', 'blonde hair'), trait('藍眼睛', 'blue eyes'), trait('蝴蝶結', 'ribbon')])
];

const defaultNegative = 'lowres, worst quality, bad quality, bad anatomy, bad hands, extra digits, multiple views, fewer digits, extra limbs, missing fingers, deformed, text, error, jpeg artifacts, watermark, unfinished, displeasing, signature, username, scan artifacts';
const newSlot = () => ({ gender: '女性', detailed: true, mode: '原創', characterId: '', query: '', originalAnimeZh: '', originalAnimeEn: '', originalAnimeTag: '', originalCharacterZh: '', originalCharacterEn: '', originalCharacterTag: '', originalTraitsZh: '', originalTraitsEn: '' });
const state = { selected: new Set(), customTags: [], customCharacters: [], recentCharacterIds: [], presets: [], group: '全部', query: '', step: 0, peopleSlots: [newSlot()], gender: '女性', count: 1, model: 'Amanatsu 1.1', sampler: 'Euler a', steps: 28, cfg: '5.0', clipSkip: '2', showAdult: false, preprompt: 'masterpiece, best quality, newest, absurdres, highres', extra: '', negative: defaultNegative };

const $ = selector => document.querySelector(selector);
const esc = value => String(value ?? '').replace(/[&<>'"]/g, char => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', "'": '&#39;', '"': '&quot;' }[char]));
const clean = value => String(value ?? '').trim().replace(/^[,\s，、。]+|[,\s，、。]+$/g, '').replace(/\s+/g, ' ');
const splitTags = value => String(value ?? '').split(/[,\n，、。]+/).map(clean).filter(Boolean);
const unique = list => [...new Map(list.map(item => [item.toLowerCase(), item])).values()];
const allTags = () => [...seedTags, ...state.customTags];
const allCharacters = () => [...catalogCharacters, ...state.customCharacters];
const findCharacter = id => allCharacters().find(item => item.id === id);
const characterForSlot = slot => findCharacter(slot.characterId);

function peopleTokens() {
  const counts = { 女性: 0, 男性: 0, 其他: 0 };
  state.peopleSlots.forEach(slot => { counts[slot.gender] = (counts[slot.gender] || 0) + 1; });
  return Object.entries(counts).filter(([, count]) => count).map(([gender, count]) => {
    if (gender === '女性') return count === 1 ? '1girl' : `${count}girls`;
    if (gender === '男性') return count === 1 ? '1boy' : `${count}boys`;
    return count === 1 ? '1person' : `${count}people`;
  });
}
function peopleChinese() { return state.peopleSlots.map(slot => slot.gender).reduce((result, item) => { result[item] = (result[item] || 0) + 1; return result; }, {}); }
function personSummary() { return Object.entries(peopleChinese()).map(([gender, count]) => `${count} 名${gender}`).join('、'); }
function traitsFromSlot(slot) {
  const c = characterForSlot(slot);
  if (!slot.detailed) return { en: [], zh: [] };
  if (slot.mode === '動漫角色' && c) return { en: c.traits.map(item => item.en), zh: c.traits.map(item => item.zh) };
  return { en: splitTags(slot.originalTraitsEn), zh: splitTags(slot.originalTraitsZh) };
}
function characterTokens() {
  const en = [], zh = [];
  state.peopleSlots.forEach(slot => {
    if (!slot.detailed) return;
    const c = characterForSlot(slot);
    if (slot.mode === '動漫角色' && c) {
      en.push(c.animeTag, c.characterTag); zh.push(`${c.animeZh}（${c.animeEn}）`, `${c.characterZh}（${c.characterEn}）`);
    } else if (slot.mode === '原創') {
      if (slot.originalAnimeTag.trim()) en.push(clean(slot.originalAnimeTag));
      if (slot.originalCharacterTag.trim()) en.push(clean(slot.originalCharacterTag));
      if (slot.originalAnimeZh.trim() || slot.originalAnimeEn.trim()) zh.push(`${slot.originalAnimeZh || slot.originalAnimeEn}（${slot.originalAnimeEn || slot.originalAnimeZh}）`);
      if (slot.originalCharacterZh.trim() || slot.originalCharacterEn.trim()) zh.push(`${slot.originalCharacterZh || slot.originalCharacterEn}（${slot.originalCharacterEn || slot.originalCharacterZh}）`);
    }
    const traits = traitsFromSlot(slot); en.push(...traits.en); zh.push(...traits.zh);
  });
  return { en: unique(en.filter(Boolean)), zh: unique(zh.filter(Boolean)) };
}
function selectedTags() { return allTags().filter(item => state.selected.has(item.id)).sort((a, b) => a.order - b.order || a.en.localeCompare(b.en)); }
function tokens() { const c = characterTokens(); return unique([...peopleTokens(), ...c.en, ...selectedTags().map(item => item.en), ...splitTags(state.extra), ...splitTags(state.preprompt)]); }
function positiveText() { return tokens().map(item => `${item}.`).join(' '); }
function chineseText() { const c = characterTokens(); const list = [personSummary(), ...c.zh, ...selectedTags().map(item => item.zh)]; if (state.extra.trim()) list.push(`額外正向標籤：${state.extra.trim()}`); if (state.preprompt.trim()) list.push(`Amanatsu 品質前綴：${state.preprompt.trim()}`); return list.join('。'); }
const negativeTranslations = { lowres: '低解析度', 'worst quality': '最差品質', 'bad quality': '低品質', 'bad anatomy': '錯誤的人體結構', 'bad hands': '錯誤的手部', 'extra digits': '多餘手指', 'multiple views': '多重視角', 'fewer digits': '手指數量不足', 'extra limbs': '多餘肢體', 'missing fingers': '缺少手指', deformed: '變形', text: '文字', error: '錯誤', 'jpeg artifacts': 'JPEG 壓縮瑕疵', watermark: '浮水印', unfinished: '未完成', displeasing: '令人不悅', signature: '簽名', username: '使用者名稱', 'scan artifacts': '掃描瑕疵', 'bad feet': '錯誤的腳部', 'poorly drawn face': '臉部繪製不佳', 'duplicate': '重複內容' };
function negativeText() { return splitTags(state.negative).map(item => `${item}.`).join(' '); }
function negativeChinese() { return splitTags(state.negative).map(item => negativeTranslations[item.toLowerCase()] || item).map(item => `${item}。`).join(' '); }

function snapshot() { return { ...state, selected: [...state.selected], peopleSlots: state.peopleSlots.map(slot => ({ ...slot })) }; }
function persist() { localStorage.setItem(STORAGE_KEY, JSON.stringify(snapshot())); }
function toast(message) { const element = $('#toast'); if (!element) return; element.textContent = message; element.classList.add('show'); clearTimeout(toast.timer); toast.timer = setTimeout(() => element.classList.remove('show'), 1900); }
function restore() { try { const saved = JSON.parse(localStorage.getItem(STORAGE_KEY) || 'null'); if (!saved) return; Object.assign(state, saved); state.selected = new Set(saved.selected || []); state.peopleSlots = (saved.peopleSlots || []).map(slot => ({ ...newSlot(), ...slot })); if (!state.peopleSlots.length) state.peopleSlots = [newSlot()]; state.customTags = saved.customTags || []; state.customCharacters = saved.customCharacters || []; state.recentCharacterIds = saved.recentCharacterIds || []; state.presets = saved.presets || []; state.count = state.peopleSlots.length; state.gender = state.peopleSlots[0].gender; } catch { toast('記憶資料無法讀取，已使用預設值。'); } }

function setPeopleCount(value) { const count = Math.max(1, Math.min(6, Number(value) || 1)); while (state.peopleSlots.length < count) state.peopleSlots.push(newSlot()); while (state.peopleSlots.length > count) state.peopleSlots.pop(); state.count = count; state.gender = state.peopleSlots[0].gender; }
function searchCharacters(slot) { const q = slot.query.toLowerCase().trim(); return allCharacters().filter(item => !q || `${item.animeZh} ${item.animeEn} ${item.characterZh} ${item.characterEn} ${item.animeTag} ${item.characterTag}`.toLowerCase().includes(q)).slice(0, 12); }
function recentCharacters() { return state.recentCharacterIds.map(findCharacter).filter(Boolean); }
function chooseCharacter(index, id) { const slot = state.peopleSlots[index]; const c = findCharacter(id); if (!c) return; slot.mode = '動漫角色'; slot.characterId = c.id; slot.query = ''; state.recentCharacterIds = [c.id, ...state.recentCharacterIds.filter(item => item !== c.id)].slice(0, 10); persist(); render(); }
function characterComplete() { return state.peopleSlots.every(slot => !slot.detailed || (slot.mode === '動漫角色' ? Boolean(characterForSlot(slot)) : Boolean(slot.originalCharacterEn.trim() && slot.originalCharacterTag.trim()))); }
function slug(value) { return clean(value).toLowerCase().replace(/[^a-z0-9_ -]/g, '').replace(/\s+/g, '_'); }

function conflictGroup(item) { return item.conflictGroup || ''; }
function conflictingTags(candidate) {
  const group = conflictGroup(candidate); if (!group) return [];
  return selectedTags().filter(item => {
    const other = conflictGroup(item); if (!other) return false;
    if (group === 'basic_pose' && other === 'basic_pose') return state.peopleSlots.length === 1;
    if (group === 'topless' && ['top', 'bra'].includes(other)) return true;
    if (group === 'bottomless' && ['bottom', 'underwear'].includes(other)) return true;
    if (['top', 'bra'].includes(group) && other === 'topless') return true;
    if (['bottom', 'underwear'].includes(group) && other === 'bottomless') return true;
    if (group === 'nudity' && ['top', 'bra', 'bottom', 'underwear', 'one_piece'].includes(other)) return true;
    if (other === 'nudity' && ['top', 'bra', 'bottom', 'underwear', 'one_piece'].includes(group)) return true;
    return group === other && ['scene', 'time', 'framing', 'camera', 'clothing_color', 'hair_color', 'body_type', 'breast_size', 'expression_eyes', 'expression_mouth', 'expression_mood', 'wear_state', 'legwear', 'footwear', 'sex_position'].includes(group);
  });
}
function toggleTag(id) { const item = allTags().find(candidate => candidate.id === id); if (!item) return; if (state.selected.has(id)) { state.selected.delete(id); render(); return; } const conflicts = conflictingTags(item); if (conflicts.length) { const names = conflicts.map(candidate => `${candidate.zh} (${candidate.en})`).join('、'); if (!window.confirm(`新增「${item.zh}」會與已選標籤衝突：${names}\n\n按「確定」移除原標籤並換成新標籤；按「取消」保留原選擇。`)) return; conflicts.forEach(candidate => state.selected.delete(candidate.id)); } state.selected.add(id); render(); }

function tagButton(item) { return `<button class="tag ${state.selected.has(item.id) ? 'selected' : ''} ${item.adult ? 'adult' : ''}" data-tag="${esc(item.id)}"><span>${item.adult ? '<i class="adult-dot">18+</i> ' : ''}${esc(item.zh)}</span><em>${esc(item.en)}</em></button>`; }
function renderTagPicker(groups, filterKey) { const query = filterKey === 'wizard' ? (state.wizardQuery || '') : state.query; const filtered = allTags().filter(item => groups.includes(item.group) && (state.showAdult || !item.adult) && (!query || `${item.zh} ${item.en}`.toLowerCase().includes(query.toLowerCase()))); return `<div class="search-line"><span>⌕</span><input data-wizard-search="${filterKey}" value="${esc(query)}" placeholder="搜尋中文或英文標籤…"></div><div class="wizard-tags">${filtered.length ? filtered.map(tagButton).join('') : '<div class="empty">沒有符合的標籤，可使用新增自訂標籤。</div>'}</div>`; }
function stepHeader(index, title, desc, icon) { const open = state.step === index; return `<button class="wizard-header" data-step="${index}"><span class="wizard-number">${index + 1}</span><span class="wizard-icon">${icon}</span><span class="wizard-title"><b>${title}</b><small>${desc}</small></span><span class="wizard-chevron">${open ? '⌃' : '⌄'}</span></button>`; }
function stepCard(index, title, desc, icon, body) { return `<section class="wizard-step ${state.step === index ? 'open' : 'closed'}">${stepHeader(index, title, desc, icon)}${state.step === index ? `<div class="wizard-body"><div class="wizard-body-inner">${body}</div></div>` : ''}</section>`; }
function nextButton(label = '下一步') { return `<div class="wizard-actions"><button class="primary" data-next="1">${label} →</button></div>`; }

function peopleStep() { return `<div class="wizard-controls"><label>人物數量<select data-people-count>${[1, 2, 3, 4, 5, 6].map(value => `<option value="${value}" ${state.peopleSlots.length === value ? 'selected' : ''}>${value} 人</option>`).join('')}</select></label><label>模型<select data-setting="model"><option>Amanatsu 1.1</option><option>Amanatsu（自訂設定）</option><option>通用 Danbooru</option></select></label><label>Sampler<select data-setting="sampler"><option>Euler a</option><option>DPM++ 2M Karras</option><option>DPM++ SDE Karras</option><option>DDIM</option></select></label><label>Steps<select data-setting="steps">${[20, 24, 28, 32, 35, 40].map(value => `<option ${state.steps === value ? 'selected' : ''}>${value}</option>`).join('')}</select></label></div><div class="wizard-controls" style="margin-top:10px"><label>CFG<select data-setting="cfg">${['4.5', '5.0', '5.5', '6.0', '7.0'].map(value => `<option ${state.cfg === value ? 'selected' : ''}>${value}</option>`).join('')}</select></label><label>Clip skip<select data-setting="clipSkip"><option ${state.clipSkip === '1' ? 'selected' : ''}>1</option><option ${state.clipSkip === '2' ? 'selected' : ''}>2</option></select></label><div class="wizard-note">先設定人物數量，再為每個人物選擇性別與詳細資料模式。</div></div>${nextButton()}`; }
function peopleCharacterCard(slot, index) { const matches = searchCharacters(slot); const c = characterForSlot(slot); const recent = recentCharacters(); return `<article class="character-card"><div class="character-card-head"><b>人物 ${index + 1}</b><span class="model-pill">${slot.detailed ? '需要詳細標籤' : '不需詳細'}</span></div><div class="person-grid"><label>性別<select data-slot-gender="${index}"><option ${slot.gender === '女性' ? 'selected' : ''}>女性</option><option ${slot.gender === '男性' ? 'selected' : ''}>男性</option><option ${slot.gender === '其他' ? 'selected' : ''}>其他／異種</option></select></label><label class="switch-row" style="margin:0"><input type="checkbox" data-slot-detailed="${index}" ${slot.detailed ? 'checked' : ''}><span class="switch"></span><span><b>詳細角色資料</b><small>關閉則只輸出人物數量</small></span></label></div><div class="character-modes"><button class="mode-chip ${slot.mode === '原創' ? 'active' : ''}" data-slot-mode="${index}" data-mode="原創">原創角色</button><button class="mode-chip ${slot.mode === '動漫角色' ? 'active' : ''}" data-slot-mode="${index}" data-mode="動漫角色">動漫角色</button></div>${slot.mode === '動漫角色' && slot.detailed ? `<label>查詢動漫或角色<input data-character-query="${index}" value="${esc(slot.query)}" placeholder="例如：To LOVE-Ru、Lala、拉拉"></label><div class="character-results">${matches.map(item => `<button class="character-result ${c?.id === item.id ? 'active' : ''}" data-character="${index}:${esc(item.id)}">${esc(item.characterZh)} · ${esc(item.characterEn)}<small>${esc(item.animeZh)} · ${esc(item.animeEn)}</small></button>`).join('')}</div>${!slot.query && recent.length ? `<div class="recent-label">最近使用角色</div><div class="character-results">${recent.slice(0, 6).map(item => `<button class="character-result" data-character="${index}:${esc(item.id)}">${esc(item.characterZh)}<small>${esc(item.animeEn)}</small></button>`).join('')}</div>` : ''}<button class="ghost" data-open-character style="margin-top:10px">＋ 新增動漫／原創角色資料</button>${c ? `<p class="wizard-note">角色自帶標籤：${esc(c.traits.map(item => `${item.zh} / ${item.en}`).join('、'))}</p>` : ''}` : slot.detailed ? `<div class="wizard-fields"><label>作品／系列中文<input data-original-field="${index}:originalAnimeZh" value="${esc(slot.originalAnimeZh)}" placeholder="原創作品"></label><label>Anime / series English<input data-original-field="${index}:originalAnimeEn" value="${esc(slot.originalAnimeEn)}"></label><label>作品英文標籤<input data-original-field="${index}:originalAnimeTag" value="${esc(slot.originalAnimeTag)}" placeholder="original_series"></label><label>角色中文<input data-original-field="${index}:originalCharacterZh" value="${esc(slot.originalCharacterZh)}"></label><label>Character English<input data-original-field="${index}:originalCharacterEn" value="${esc(slot.originalCharacterEn)}"></label><label>角色英文標籤<input data-original-field="${index}:originalCharacterTag" value="${esc(slot.originalCharacterTag)}" placeholder="my_character"></label><label>特徵中文<textarea data-original-field="${index}:originalTraitsZh" rows="2" placeholder="粉紅頭髮, 呆毛, 綠眼睛">${esc(slot.originalTraitsZh)}</textarea></label><label>Traits English<textarea data-original-field="${index}:originalTraitsEn" rows="2" placeholder="pink hair, ahoge, green eyes">${esc(slot.originalTraitsEn)}</textarea></label></div>` : '<p class="wizard-note">此人物將只使用人物數量標籤，不加入作品、角色與外觀細節。</p>'}</article>`; }
function charactersStep() { return `${state.peopleSlots.map((slot, index) => peopleCharacterCard(slot, index)).join('')}${nextButton('完成角色設定')}`; }
function tagsStep(groups) { return `${renderTagPicker(groups, 'wizard')}${nextButton()}`; }
function finalStep() { return `<div class="wizard-fields"><label>Amanatsu 品質前綴<textarea data-setting="preprompt" rows="2">${esc(state.preprompt)}</textarea></label><label>額外正向標籤<textarea data-setting="extra" rows="2" placeholder="可用中文或英文，以逗號或換行分隔">${esc(state.extra)}</textarea></label></div><label style="margin-top:12px">負面標籤（英文或中文）<textarea data-setting="negative" rows="4">${esc(state.negative)}</textarea></label><label class="switch-row"><input type="checkbox" data-setting="showAdult" ${state.showAdult ? 'checked' : ''}><span class="switch"></span><span><b>顯示 18+ 標籤分類</b><small>只建立成年角色內容，開啟後可在前面分類選取成人向標籤。</small></span></label><p class="wizard-note">所有英文輸出標籤會以英文句點結尾；負面標籤也會同步顯示中文翻譯。</p>`; }
function renderWizard() { $('#wizard').innerHTML = [stepCard(0, '人物數量與模型', '先選人物數量、性別比例與 Amanatsu 設定', '①', peopleStep()), stepCard(1, '場景與畫面', '背景、時間、鏡頭與構圖', '⌂', tagsStep(['場景', '畫面'])), stepCard(2, '人物與角色資料', '每位人物可選動漫角色、原創角色或不需詳細', '♙', charactersStep()), stepCard(3, '外觀、臉部與身體', '髮色、眼睛、虎牙、胸部與裸露狀態', '✦', tagsStep(['外觀特徵', '臉部特徵', '胸部', '裸露'])), stepCard(4, '服裝與細節', '上衣、下身、內衣、顏色、蕾絲、材質與穿脫狀態', '◇', tagsStep(['上衣', '褲子', '裙子', '胸罩', '內褲', '襪子', '鞋子', '服裝', '配件', '服裝顏色', '服裝細節', '服裝材質', '穿脫狀態'])), stepCard(5, '表情', '表情、眼睛與嘴部狀態', '☺', tagsStep(['表情'])), stepCard(6, '姿勢與 18+ 姿勢', '基本姿勢、性行為與性姿勢；單人基本姿勢會互斥', '♧', tagsStep(['姿勢', '性行為', '性姿勢'])), stepCard(7, '品質與負面標籤', '調整前綴、額外標籤與負面標籤', '✓', finalStep())].join(''); }

function renderFilters() { const groups = ['全部', ...new Set(allTags().map(item => item.group))]; $('#group-filters').innerHTML = groups.map(group => `<button class="filter ${state.group === group ? 'active' : ''}" data-group="${esc(group)}">${esc(group)}</button>`).join(''); }
function renderTags() { const query = state.query.toLowerCase(); const items = allTags().filter(item => (state.group === '全部' || item.group === state.group) && (state.showAdult || !item.adult) && (!query || `${item.zh} ${item.en}`.toLowerCase().includes(query))); $('#tag-list').innerHTML = items.length ? items.map(tagButton).join('') : '<div class="empty">沒有符合的標籤，可使用搜尋或新增自訂標籤。</div>'; }
function renderPresets() { $('#preset-list').innerHTML = state.presets.length ? state.presets.map((preset, index) => `<div class="preset"><span class="preset-number">${index + 1}</span><span class="preset-info"><b>${esc(preset.name)}</b><small>${(preset.payload.selected || []).length} 個標籤 · ${esc(preset.payload.gender || '')} ${preset.payload.count || ''} 人</small></span><span class="preset-actions"><button class="icon-button" data-load="${index}">載入</button><button class="icon-button" data-delete="${index}">刪除</button></span></div>`).join('') : '<div class="preset-empty">尚未儲存組合；完成後可使用輸出區的儲存按鈕。</div>'; }
function renderOutput() { $('#positive-output').value = positiveText(); $('#chinese-output').value = chineseText(); $('#negative-output').value = negativeText(); $('#negative-chinese').value = negativeChinese(); $('#selected-summary').textContent = `已選 ${selectedTags().length} 個資料庫標籤 · 英文每個標籤以句點結尾`; $('#order-summary').textContent = `${personSummary()} → 角色特徵 → 服裝 → 表情 → 姿勢 → 場景／畫面 · ${state.sampler} · ${state.steps} steps · CFG ${state.cfg} · Clip skip ${state.clipSkip}`; }
function syncControls() { const controls = { '#model': state.model, '#gender': state.gender, '#people-count': String(state.peopleSlots.length), '#sampler': state.sampler, '#steps': String(state.steps), '#cfg': state.cfg, '#clip-skip': state.clipSkip, '#preprompt': state.preprompt, '#extra-positive': state.extra, '#negative': state.negative, '#search': state.query }; Object.entries(controls).forEach(([selector, value]) => { const element = $(selector); if (element) element.value = value; }); const adult = $('#show-adult'); if (adult) adult.checked = state.showAdult; }
function render() { renderWizard(); renderFilters(); renderTags(); renderPresets(); renderOutput(); syncControls(); persist(); }
async function copyText(value, label) { try { await navigator.clipboard.writeText(value); } catch { const area = document.createElement('textarea'); area.value = value; document.body.append(area); area.select(); document.execCommand('copy'); area.remove(); } toast(`${label}已複製`); }
function downloadBackup() { const blob = new Blob([JSON.stringify(snapshot(), null, 2)], { type: 'application/json' }); const link = document.createElement('a'); link.href = URL.createObjectURL(blob); link.download = 'betterwaifu-prompt-backup.json'; link.click(); URL.revokeObjectURL(link.href); toast('備份已匯出'); }
function importBackup(file) { const reader = new FileReader(); reader.onload = () => { try { localStorage.setItem(STORAGE_KEY, reader.result); location.reload(); } catch { toast('JSON 備份格式無法讀取'); } }; reader.readAsText(file); }
function groupOrder(group) { if (group === '場景') return 6; if (group === '表情') return 3; if (group === '姿勢') return 4; if (['性行為', '性姿勢'].includes(group)) return 5; if (['服裝', '上衣', '褲子', '裙子', '胸罩', '內褲', '襪子', '鞋子', '配件', '服裝顏色', '服裝細節', '服裝材質', '穿脫狀態'].includes(group)) return 2; return 1; }

document.addEventListener('click', event => {
  const tagButton = event.target.closest('[data-tag]'); if (tagButton) { toggleTag(tagButton.dataset.tag); return; }
  const stepButton = event.target.closest('[data-step]'); if (stepButton) { state.step = Number(stepButton.dataset.step); render(); return; }
  const next = event.target.closest('[data-next]'); if (next) { if (state.step === 2 && !characterComplete()) { toast('請完成每位需要詳細設定人物的角色資料，或關閉詳細角色資料。'); return; } state.step = Math.min(7, state.step + 1); render(); return; }
  const groupButton = event.target.closest('[data-group]'); if (groupButton) { state.group = groupButton.dataset.group; render(); return; }
  const characterButton = event.target.closest('[data-character]'); if (characterButton) { const [index, id] = characterButton.dataset.character.split(':'); chooseCharacter(Number(index), id); return; }
  const modeButton = event.target.closest('[data-slot-mode]'); if (modeButton) { state.peopleSlots[Number(modeButton.dataset.slotMode)].mode = modeButton.dataset.mode; state.peopleSlots[Number(modeButton.dataset.slotMode)].characterId = ''; render(); return; }
  const openCharacter = event.target.closest('[data-open-character]'); if (openCharacter) { $('#character-dialog').showModal(); return; }
  const loadButton = event.target.closest('[data-load]'); if (loadButton) { const preset = state.presets[Number(loadButton.dataset.load)]; if (preset) { Object.assign(state, { ...preset.payload, selected: new Set(preset.payload.selected || []), peopleSlots: (preset.payload.peopleSlots || [newSlot()]).map(slot => ({ ...newSlot(), ...slot })) }); render(); toast(`已載入「${preset.name}」`); } return; }
  const deleteButton = event.target.closest('[data-delete]'); if (deleteButton) { state.presets.splice(Number(deleteButton.dataset.delete), 1); render(); toast('組合已刪除'); }
});

document.addEventListener('input', event => {
  const wizardSearch = event.target.closest('[data-wizard-search]'); if (wizardSearch) { state.wizardQuery = wizardSearch.value; renderWizard(); return; }
  const characterSearch = event.target.closest('[data-character-query]'); if (characterSearch) { state.peopleSlots[Number(characterSearch.dataset.characterQuery)].query = characterSearch.value; renderWizard(); return; }
  const original = event.target.closest('[data-original-field]'); if (original) { const [index, field] = original.dataset.originalField.split(':'); state.peopleSlots[Number(index)][field] = original.value; persist(); renderOutput(); return; }
  const setting = event.target.closest('[data-setting]'); if (setting && ['preprompt', 'extra', 'negative'].includes(setting.dataset.setting)) { state[setting.dataset.setting === 'preprompt' ? 'preprompt' : setting.dataset.setting === 'extra' ? 'extra' : 'negative'] = setting.value; persist(); renderOutput(); }
  if (event.target.id === 'search') { state.query = event.target.value; render(); }
});
document.addEventListener('change', event => {
  const count = event.target.closest('[data-people-count]'); if (count) { setPeopleCount(count.value); render(); return; }
  const gender = event.target.closest('[data-slot-gender]'); if (gender) { state.peopleSlots[Number(gender.dataset.slotGender)].gender = gender.value.split('／')[0]; state.gender = state.peopleSlots[0].gender; persist(); renderOutput(); return; }
  const detailed = event.target.closest('[data-slot-detailed]'); if (detailed) { state.peopleSlots[Number(detailed.dataset.slotDetailed)].detailed = detailed.checked; persist(); render(); return; }
  const setting = event.target.closest('[data-setting]'); if (setting) { const key = setting.dataset.setting; if (key === 'showAdult') state.showAdult = setting.checked; else if (key === 'steps') state.steps = Number(setting.value); else state[key] = setting.value; persist(); render(); }
});

$('#search').addEventListener('input', event => { state.query = event.target.value; render(); });
$('#clear-search').addEventListener('click', () => { state.query = ''; render(); });
$('#model').addEventListener('change', event => { state.model = event.target.value; persist(); });
$('#gender').addEventListener('change', event => { state.peopleSlots.forEach(slot => { slot.gender = event.target.value; }); state.gender = event.target.value; render(); });
$('#people-count').addEventListener('change', event => { setPeopleCount(event.target.value); render(); });
$('#sampler').addEventListener('change', event => { state.sampler = event.target.value; renderOutput(); persist(); });
$('#steps').addEventListener('change', event => { state.steps = Number(event.target.value); renderOutput(); persist(); });
$('#cfg').addEventListener('change', event => { state.cfg = event.target.value; renderOutput(); persist(); });
$('#clip-skip').addEventListener('change', event => { state.clipSkip = event.target.value; renderOutput(); persist(); });
$('#show-adult').addEventListener('change', event => { state.showAdult = event.target.checked; render(); });
$('#preprompt').addEventListener('input', event => { state.preprompt = event.target.value; renderOutput(); persist(); });
$('#extra-positive').addEventListener('input', event => { state.extra = event.target.value; renderOutput(); persist(); });
$('#negative').addEventListener('input', event => { state.negative = event.target.value; renderOutput(); persist(); });
$('#copy-positive').addEventListener('click', () => copyText(positiveText(), '正向英文標籤'));
$('#sticky-copy-positive').addEventListener('click', () => copyText(positiveText(), '正向英文標籤'));
$('#sticky-copy-negative').addEventListener('click', () => copyText(negativeText(), '負面英文標籤'));
$('#save-preset').addEventListener('click', () => { const name = window.prompt('組合名稱', 'Amanatsu 組合'); if (!name?.trim()) return; state.presets.unshift({ name: name.trim(), payload: snapshot() }); render(); toast('組合已儲存'); });
$('#export-btn').addEventListener('click', downloadBackup);
$('#import-btn').addEventListener('click', () => $('#import-file').click());
$('#import-file').addEventListener('change', event => { if (event.target.files?.[0]) importBackup(event.target.files[0]); event.target.value = ''; });
$('#add-tag-btn').addEventListener('click', () => { $('#custom-zh').value = ''; $('#custom-en').value = ''; $('#custom-group').value = '自訂特徵'; $('#custom-dialog').showModal(); });
$('#custom-form').addEventListener('submit', event => { event.preventDefault(); const zh = $('#custom-zh').value.trim(); const en = clean($('#custom-en').value); if (!zh || !en) return; const group = $('#custom-group').value; const item = { id: `custom_${Date.now()}`, group, zh, en, order: groupOrder(group), adult: false, conflictGroup: '', builtIn: false }; state.customTags.push(item); state.selected.add(item.id); $('#custom-dialog').close(); render(); toast('自訂標籤已加入'); });
$('#character-form').addEventListener('submit', event => { event.preventDefault(); const animeZh = $('#character-anime-zh').value.trim(), animeEn = $('#character-anime-en').value.trim(), characterZh = $('#character-zh').value.trim(), characterEn = $('#character-en').value.trim(); if (!animeZh || !animeEn || !characterZh || !characterEn) return; const c = { id: `custom_character_${Date.now()}`, animeZh, animeEn, animeTag: clean($('#character-anime-tag').value) || slug(animeEn), characterZh, characterEn, characterTag: clean($('#character-tag').value) || slug(characterEn), traits: splitTags($('#character-traits-en').value).map((en, index) => ({ en, zh: splitTags($('#character-traits-zh').value)[index] || en })) }; state.customCharacters.push(c); const emptySlot = state.peopleSlots.find(slot => slot.mode === '動漫角色' && !slot.characterId); if (emptySlot) emptySlot.characterId = c.id; state.recentCharacterIds = [c.id, ...state.recentCharacterIds].slice(0, 10); $('#character-dialog').close(); render(); toast('角色資料已儲存'); });

restore(); render();
if ('serviceWorker' in navigator && location.protocol !== 'file:') navigator.serviceWorker.register('./sw.js').catch(() => {});
