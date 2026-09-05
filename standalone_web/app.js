/* BetterWaifu Prompt Atelier — dependency-free browser version. */
const STORAGE_KEY = 'betterwaifu_prompt_builder_state_v2';
const VERSION_STORAGE_KEY = 'betterwaifu_prompt_builder_last_seen_version';
const APP_VERSION = window.BETTERWAIFU_VERSION || { label: '1.1.0+2', history: [] };

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
  tag('scene_sports_field', '場景', '運動場', 'sports field', 6, false, 'scene'),
  tag('scene_soccer_field', '場景', '足球場', 'soccer field', 6, false, 'scene'),
  tag('scene_basketball_court', '場景', '籃球場', 'basketball court', 6, false, 'scene'),
  tag('scene_tennis_court', '場景', '網球場', 'tennis court', 6, false, 'scene'),
  tag('scene_baseball_field', '場景', '棒球場', 'baseball field', 6, false, 'scene'),
  tag('scene_volleyball_court', '場景', '排球場', 'volleyball court', 6, false, 'scene'),
  tag('scene_track_stadium', '場景', '田徑場', 'track and field stadium', 6, false, 'scene'),
  tag('scene_rugby_field', '場景', '橄欖球場', 'rugby field', 6, false, 'scene'),
  tag('scene_hockey_field', '場景', '曲棍球場', 'field hockey field', 6, false, 'scene'),
  tag('scene_badminton_court', '場景', '羽球場', 'badminton court', 6, false, 'scene'),
  tag('scene_golf_course', '場景', '高爾夫球場', 'golf course', 6, false, 'scene'),
  tag('scene_swimming_pool', '場景', '游泳池', 'swimming pool', 6, false, 'scene'),
  tag('scene_indoor_pool', '場景', '室內游泳館', 'indoor swimming pool', 6, false, 'scene'),
  tag('scene_sports_hall', '場景', '體育館', 'sports hall', 6, false, 'scene'),
  tag('scene_gym', '場景', '健身房', 'gym', 6, false, 'scene'),
  tag('scene_training_room', '場景', '訓練室', 'training room', 6, false, 'scene'),
  tag('scene_martial_arts_dojo', '場景', '武道館', 'martial arts dojo', 6, false, 'scene'),
  tag('scene_dance_studio', '場景', '舞蹈教室', 'dance studio', 6, false, 'scene'),
  tag('scene_ice_rink', '場景', '溜冰場', 'ice rink', 6, false, 'scene'),
  tag('scene_skate_park', '場景', '滑板公園', 'skate park', 6, false, 'scene'),
  tag('scene_bowling_alley', '場景', '保齡球館', 'bowling alley', 6, false, 'scene'),
  tag('scene_archery_range', '場景', '射箭場', 'archery range', 6, false, 'scene'),
  tag('scene_boxing_ring', '場景', '拳擊場', 'boxing ring', 6, false, 'scene'),
  tag('scene_wrestling_arena', '場景', '摔角場', 'wrestling arena', 6, false, 'scene'),
  tag('scene_stadium_bleachers', '場景', '體育場看台', 'stadium bleachers', 6, false, 'scene'),
  tag('scene_locker_room', '場景', '運動更衣室', 'locker room', 6, false, 'scene'),
  tag('scene_sports_festival', '場景', '運動會場', 'sports festival grounds', 6, false, 'scene'),
  tag('scene_city_street', '場景', '城市街道', 'city street', 6, false, 'scene'),
  tag('scene_shopping_mall', '場景', '購物中心', 'shopping mall', 6, false, 'scene'),
  tag('scene_cafe', '場景', '咖啡廳', 'cafe', 6, false, 'scene'),
  tag('scene_restaurant', '場景', '餐廳', 'restaurant', 6, false, 'scene'),
  tag('scene_library', '場景', '圖書館', 'library', 6, false, 'scene'),
  tag('scene_park', '場景', '公園', 'park', 6, false, 'scene'),
  tag('scene_forest', '場景', '森林', 'forest', 6, false, 'scene'),
  tag('scene_mountain', '場景', '山區', 'mountain', 6, false, 'scene'),
  tag('scene_rooftop', '場景', '屋頂', 'rooftop', 6, false, 'scene'),
  tag('scene_train_station', '場景', '車站', 'train station', 6, false, 'scene'),
  tag('scene_train_interior', '場景', '電車內', 'train interior', 6, false, 'scene'),
  tag('scene_office', '場景', '辦公室', 'office', 6, false, 'scene'),
  tag('scene_hospital', '場景', '醫院', 'hospital', 6, false, 'scene'),
  tag('scene_shrine', '場景', '神社', 'shrine', 6, false, 'scene'),
  tag('scene_temple', '場景', '寺廟', 'temple', 6, false, 'scene'),
  tag('scene_church', '場景', '教堂', 'church', 6, false, 'scene'),
  tag('scene_amusement_park', '場景', '遊樂園', 'amusement park', 6, false, 'scene'),
  tag('scene_aquarium', '場景', '水族館', 'aquarium', 6, false, 'scene'),
  tag('scene_museum', '場景', '博物館', 'museum', 6, false, 'scene'),
  tag('scene_theater', '場景', '劇院', 'theater', 6, false, 'scene'),
  tag('scene_concert_stage', '場景', '演唱會舞台', 'concert stage', 6, false, 'scene'),
  tag('scene_school_hallway', '場景', '校園走廊', 'school hallway', 6, false, 'scene'),
  tag('scene_school_rooftop', '場景', '學校屋頂', 'school rooftop', 6, false, 'scene'),
  tag('scene_convenience_store', '場景', '便利商店', 'convenience store', 6, false, 'scene'),
  tag('scene_hot_spring', '場景', '溫泉', 'hot spring', 6, false, 'scene'),
  tag('scene_water_park', '場景', '水上樂園', 'water park', 6, false, 'scene'),
  tag('scene_campsite', '場景', '露營地', 'campsite', 6, false, 'scene'),
  tag('scene_castle', '場景', '城堡', 'castle', 6, false, 'scene'),
  tag('camera_portrait', '畫面', '肖像構圖', 'portrait', 7, false, 'framing'),
  tag('camera_fullbody', '畫面', '全身', 'full body', 7, false, 'framing'),
  tag('camera_upperbody', '畫面', '上半身', 'upper body', 7, false, 'framing'),
  tag('camera_closeup', '畫面', '特寫', 'close-up', 7, false, 'framing'),
  tag('camera_cowboy', '畫面', '牛仔鏡頭', 'cowboy shot', 7, false, 'framing'),
  tag('camera_above', '畫面', '俯視角度', 'from above', 7, false, 'camera'),
  tag('camera_below', '畫面', '仰視角度', 'from below', 7, false, 'camera'),
  tag('camera_pov', '畫面', '第一人稱視角', 'pov', 7, false, 'camera'),
  tag('camera_birds_eye', '畫面', '鳥瞰視角', 'birds-eye', 7, false, 'camera'),
  tag('camera_wide_shot', '畫面', '遠景鏡頭', 'wide shot', 7, false, 'framing'),
  tag('camera_isometric', '畫面', '等角視角', 'isometric', 7, false, 'camera'),
  tag('camera_high_angle', '畫面', '高角度視角', 'high-angle view', 7, false, 'camera'),
  tag('camera_low_angle', '畫面', '低角度視角', 'low-angle view', 7, false, 'camera'),
  tag('camera_eye_level', '畫面', '平視角度', 'eye-level shot', 7, false, 'camera'),
  tag('camera_front_view', '畫面', '正面視角', 'front view', 7, false, 'camera'),
  tag('camera_side_view', '畫面', '側面視角', 'side view', 7, false, 'camera'),
  tag('camera_rear_view', '畫面', '背面視角', 'rear view', 7, false, 'camera'),
  tag('camera_three_quarter', '畫面', '三分之四視角', 'three-quarter view', 7, false, 'camera'),
  tag('camera_over_shoulder', '畫面', '越肩視角', 'over-the-shoulder view', 7, false, 'camera'),

  tag('trait_long_hair', '外觀特徵', '長髮', 'long hair', 1),
  tag('trait_short_hair', '外觀特徵', '短髮', 'short hair', 1),
  tag('trait_hair_between', '外觀特徵', '瀏海遮眼', 'hair between eyes', 1),
  tag('trait_blonde', '外觀特徵', '金髮', 'blonde hair', 1, false, 'hair_color'),
  tag('trait_black_hair', '外觀特徵', '黑髮', 'black hair', 1, false, 'hair_color'),
  tag('trait_silver', '外觀特徵', '銀髮', 'silver hair', 1, false, 'hair_color'),
  tag('trait_blue_hair', '外觀特徵', '藍髮', 'blue hair', 1, false, 'hair_color'),
  tag('trait_red_hair', '外觀特徵', '紅髮', 'red hair', 1, false, 'hair_color'),
  tag('trait_pink_hair', '外觀特徵', '粉紅髮', 'pink hair', 1, false, 'hair_color'),
  tag('hair_very_short', '髮型', '極短髮', 'very short hair', 1, false, 'hair_length'),
  tag('hair_medium', '髮型', '中長髮', 'medium hair', 1, false, 'hair_length'),
  tag('hair_very_long', '髮型', '超長髮', 'very long hair', 1, false, 'hair_length'),
  tag('hair_bob_cut', '髮型', '鮑伯頭', 'bob cut', 1, false, 'hair_style'),
  tag('hair_pixie_cut', '髮型', '精靈短髮', 'pixie cut', 1, false, 'hair_style'),
  tag('hair_straight', '髮型', '直髮', 'straight hair', 1, false, 'hair_style'),
  tag('hair_wavy', '髮型', '波浪髮', 'wavy hair', 1, false, 'hair_style'),
  tag('hair_curly', '髮型', '捲髮', 'curly hair', 1, false, 'hair_style'),
  tag('hair_messy', '髮型', '凌亂髮', 'messy hair', 1, false, 'hair_style'),
  tag('hair_spiky', '髮型', '刺蝟頭', 'spiky hair', 1, false, 'hair_style'),
  tag('hair_ponytail', '髮型', '馬尾', 'ponytail', 1, false, 'hair_style'),
  tag('hair_high_ponytail', '髮型', '高馬尾', 'high ponytail', 1, false, 'hair_style'),
  tag('hair_low_ponytail', '髮型', '低馬尾', 'low ponytail', 1, false, 'hair_style'),
  tag('hair_side_ponytail', '髮型', '側馬尾', 'side ponytail', 1, false, 'hair_style'),
  tag('hair_twintails', '髮型', '雙馬尾', 'twintails', 1, false, 'hair_style'),
  tag('hair_short_twintails', '髮型', '短雙馬尾', 'short twintails', 1, false, 'hair_style'),
  tag('hair_low_twintails', '髮型', '低雙馬尾', 'low twintails', 1, false, 'hair_style'),
  tag('hair_single_braid', '髮型', '單辮子', 'single braid', 1, false, 'hair_style'),
  tag('hair_twin_braids', '髮型', '雙辮子', 'twin braids', 1, false, 'hair_style'),
  tag('hair_side_braid', '髮型', '側辮子', 'side braid', 1, false, 'hair_style'),
  tag('hair_french_braid', '髮型', '法式辮子', 'french braid', 1, false, 'hair_style'),
  tag('hair_bun', '髮型', '髮髻', 'hair bun', 1, false, 'hair_style'),
  tag('hair_double_bun', '髮型', '雙丸子頭', 'double bun', 1, false, 'hair_style'),
  tag('hair_odango', '髮型', '丸子頭', 'odango', 1, false, 'hair_style'),
  tag('hair_side_bun', '髮型', '側髮髻', 'side bun', 1, false, 'hair_style'),
  tag('hair_drill', '髮型', '鑽頭捲', 'drill hair', 1, false, 'hair_style'),
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
  tag('short_skirt', '裙子', '短裙', 'short skirt', 2, false, 'bottom'),
  tag('knee_length_skirt', '裙子', '及膝裙', 'knee-length skirt', 2, false, 'bottom'),
  tag('midi_skirt', '裙子', '中長裙', 'midi skirt', 2, false, 'bottom'),
  tag('maxi_skirt', '裙子', '超長裙', 'maxi skirt', 2, false, 'bottom'),
  tag('pencil_skirt', '裙子', '鉛筆裙', 'pencil skirt', 2, false, 'bottom'),
  tag('a_line_skirt', '裙子', 'A字裙', 'a-line skirt', 2, false, 'bottom'),
  tag('circle_skirt', '裙子', '傘裙', 'circle skirt', 2, false, 'bottom'),
  tag('tiered_skirt', '裙子', '蛋糕裙', 'tiered skirt', 2, false, 'bottom'),
  tag('tutu_skirt', '裙子', '芭蕾舞裙', 'tutu skirt', 2, false, 'bottom'),
  tag('wrap_skirt', '裙子', '裹身裙', 'wrap skirt', 2, false, 'bottom'),
  tag('slit_skirt', '裙子', '開衩裙', 'slit skirt', 2, false, 'bottom'),
  tag('denim_skirt', '裙子', '牛仔裙', 'denim skirt', 2, false, 'bottom'),
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
  tag('sports_uniform', '服裝', '運動制服', 'sports uniform', 2, false, 'one_piece'),
  tag('cheerleading_uniform', '服裝', '啦啦隊制服', 'cheerleading uniform', 2, false, 'one_piece'),
  tag('gymnastics_leotard', '服裝', '體操連身衣', 'gymnastics leotard', 2, false, 'one_piece'),
  tag('martial_arts_uniform', '服裝', '武道服', 'martial arts uniform', 2, false, 'one_piece'),
  tag('top_sports_jersey', '上衣', '運動球衣', 'sports jersey', 2, false, 'top'),
  tag('top_basketball_jersey', '上衣', '籃球球衣', 'basketball jersey', 2, false, 'top'),
  tag('top_soccer_jersey', '上衣', '足球球衣', 'soccer jersey', 2, false, 'top'),
  tag('top_volleyball_jersey', '上衣', '排球球衣', 'volleyball jersey', 2, false, 'top'),
  tag('top_sports_tank', '上衣', '運動背心', 'sports tank top', 2, false, 'top'),
  tag('top_compression_shirt', '上衣', '運動壓縮衣', 'compression shirt', 2, false, 'top'),
  tag('top_warmup_jacket', '上衣', '運動熱身外套', 'warm-up jacket', 2, false, 'top'),
  tag('bottom_athletic_shorts', '褲子', '運動短褲', 'athletic shorts', 2, false, 'bottom'),
  tag('bottom_track_pants', '褲子', '田徑長褲', 'track pants', 2, false, 'bottom'),
  tag('bottom_training_pants', '褲子', '訓練長褲', 'training pants', 2, false, 'bottom'),
  tag('bottom_yoga_pants', '褲子', '瑜伽褲', 'yoga pants', 2, false, 'bottom'),
  tag('skirt_tennis', '裙子', '網球裙', 'tennis skirt', 2, false, 'bottom'),
  tag('skirt_cheerleading', '裙子', '啦啦隊短裙', 'cheerleading skirt', 2, false, 'bottom'),
  tag('socks_sports', '襪子', '運動襪', 'sports socks', 2, false, 'legwear'),
  tag('shoes_running', '鞋子', '跑鞋', 'running shoes', 2, false, 'footwear'),
  tag('shoes_basketball', '鞋子', '籃球鞋', 'basketball shoes', 2, false, 'footwear'),
  tag('shoes_soccer_cleats', '鞋子', '足球釘鞋', 'soccer cleats', 2, false, 'footwear'),
  tag('shoes_tennis', '鞋子', '網球鞋', 'tennis shoes', 2, false, 'footwear'),
  tag('clothing_gothic', '服裝', '哥德蘿莉塔', 'gothic', 2, false, 'one_piece'),
  tag('style_gothic_evening_gown', '服裝風格', '哥德式晚禮服', 'gothic evening gown', 2, false, 'one_piece'),
  tag('style_black_gothic_evening_gown', '服裝風格', '黑色哥德式晚禮服', 'black gothic evening gown', 2, false, 'one_piece'),
  tag('style_gothic_dress', '服裝風格', '哥德式洋裝', 'gothic dress', 2, false, 'one_piece'),
  tag('style_black_gothic_dress', '服裝風格', '黑色哥德式洋裝', 'black gothic dress', 2, false, 'one_piece'),
  tag('style_gothic_maid_outfit', '服裝風格', '哥德式女僕裝', 'gothic maid outfit', 2, false, 'one_piece'),
  tag('style_gothic_school_uniform', '服裝風格', '哥德式制服', 'gothic school uniform', 2, false, 'one_piece'),
  tag('style_victorian_dress', '服裝風格', '維多利亞式洋裝', 'Victorian dress', 2, false, 'one_piece'),
  tag('style_dark_academia_outfit', '服裝風格', '暗黑學院風服裝', 'dark academia outfit', 2, false, 'one_piece'),
  tag('style_steampunk_outfit', '服裝風格', '蒸氣龐克服裝', 'steampunk outfit', 2, false, 'one_piece'),
  tag('style_black_formal_gown', '服裝風格', '黑色正式晚禮服', 'black formal evening gown', 2, false, 'one_piece'),
  tag('top_style_gothic', '上衣風格', '哥德式上衣風格', 'gothic style top', 2, false, 'top_style'),
  tag('top_style_punk', '上衣風格', '朋克風上衣風格', 'punk style top', 2, false, 'top_style'),
  tag('top_style_elegant', '上衣風格', '優雅風上衣風格', 'elegant style top', 2, false, 'top_style'),
  tag('top_style_dark_academia', '上衣風格', '暗黑學院風上衣風格', 'dark academia style top', 2, false, 'top_style'),
  tag('top_style_victorian', '上衣風格', '維多利亞風上衣風格', 'Victorian style blouse', 2, false, 'top_style'),
  tag('top_style_casual', '上衣風格', '休閒風上衣風格', 'casual style top', 2, false, 'top_style'),
  tag('top_style_streetwear', '上衣風格', '街頭風上衣風格', 'streetwear style top', 2, false, 'top_style'),
  tag('top_style_sailor', '上衣風格', '水手風上衣風格', 'sailor style top', 2, false, 'top_style'),
  tag('bottom_style_gothic', '下身風格', '哥德式裙子風格', 'gothic style skirt', 2, false, 'bottom_style'),
  tag('bottom_style_punk', '下身風格', '朋克風裙子風格', 'punk style skirt', 2, false, 'bottom_style'),
  tag('bottom_style_elegant', '下身風格', '優雅風裙子風格', 'elegant style skirt', 2, false, 'bottom_style'),
  tag('bottom_style_dark_academia', '下身風格', '暗黑學院風裙子風格', 'dark academia style skirt', 2, false, 'bottom_style'),
  tag('bottom_style_victorian', '下身風格', '維多利亞風裙子風格', 'Victorian style skirt', 2, false, 'bottom_style'),
  tag('bottom_style_casual', '下身風格', '休閒風褲子風格', 'casual style pants', 2, false, 'bottom_style'),
  tag('bottom_style_streetwear', '下身風格', '街頭風褲子風格', 'streetwear style pants', 2, false, 'bottom_style'),
  tag('bottom_style_sailor', '下身風格', '水手風裙子風格', 'sailor style skirt', 2, false, 'bottom_style'),
  tag('bra', '胸罩', '胸罩', 'bra', 2, true, 'bra'),
  tag('sports_bra', '胸罩', '運動胸罩', 'sports bra', 2, false, 'bra'),
  tag('lace_bra', '胸罩', '蕾絲胸罩', 'lace bra', 2, true, 'bra'),
  tag('strapless_bra', '胸罩', '無肩帶胸罩', 'strapless bra', 2, true, 'bra'),
  tag('underwear_camisole', '內衣', '吊帶內衣', 'camisole underwear', 2, true, 'underwear'),
  tag('underwear_chemise', '內衣', '睡衣式內衣', 'chemise', 2, true, 'underwear'),
  tag('underwear_bandeau', '內衣', '無肩帶內衣', 'bandeau underwear', 2, true, 'underwear'),
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

  // Accessories stay independent from clothing and can be colored separately.
  tag('accessory_color_black', '配件顏色', '黑色配件', 'black accessory', 2, false, 'accessory_color'),
  tag('accessory_color_white', '配件顏色', '白色配件', 'white accessory', 2, false, 'accessory_color'),
  tag('accessory_color_red', '配件顏色', '紅色配件', 'red accessory', 2, false, 'accessory_color'),
  tag('accessory_color_blue', '配件顏色', '藍色配件', 'blue accessory', 2, false, 'accessory_color'),
  tag('accessory_color_pink', '配件顏色', '粉紅色配件', 'pink accessory', 2, false, 'accessory_color'),
  tag('accessory_color_purple', '配件顏色', '紫色配件', 'purple accessory', 2, false, 'accessory_color'),
  tag('accessory_color_green', '配件顏色', '綠色配件', 'green accessory', 2, false, 'accessory_color'),
  tag('accessory_color_yellow', '配件顏色', '黃色配件', 'yellow accessory', 2, false, 'accessory_color'),
  tag('accessory_color_brown', '配件顏色', '棕色配件', 'brown accessory', 2, false, 'accessory_color'),
  tag('accessory_color_gold', '配件顏色', '金色配件', 'gold accessory', 2, false, 'accessory_color'),
  tag('accessory_color_silver', '配件顏色', '銀色配件', 'silver accessory', 2, false, 'accessory_color'),
  tag('accessory_color_multicolored', '配件顏色', '多彩配件', 'multicolored accessory', 2, false, 'accessory_color'),

  tag('color_black', '服裝顏色', '黑色', 'black', 2, false, 'clothing_color'),
  tag('color_white', '服裝顏色', '白色', 'white', 2, false, 'clothing_color'),
  tag('color_red', '服裝顏色', '紅色', 'red', 2, false, 'clothing_color'),
  tag('color_blue', '服裝顏色', '藍色', 'blue', 2, false, 'clothing_color'),
  tag('color_pink', '服裝顏色', '粉紅色', 'pink', 2, false, 'clothing_color'),
  tag('color_purple', '服裝顏色', '紫色', 'purple', 2, false, 'clothing_color'),
  tag('color_green', '服裝顏色', '綠色', 'green', 2, false, 'clothing_color'),
  tag('color_yellow', '服裝顏色', '黃色', 'yellow', 2, false, 'clothing_color'),
  tag('color_brown', '服裝顏色', '棕色', 'brown', 2, false, 'clothing_color'),
  tag('top_color_black', '上衣顏色', '黑色上衣', 'black top', 2, false, 'top_color'),
  tag('top_color_white', '上衣顏色', '白色上衣', 'white top', 2, false, 'top_color'),
  tag('top_color_red', '上衣顏色', '紅色上衣', 'red top', 2, false, 'top_color'),
  tag('top_color_blue', '上衣顏色', '藍色上衣', 'blue top', 2, false, 'top_color'),
  tag('top_color_pink', '上衣顏色', '粉紅色上衣', 'pink top', 2, false, 'top_color'),
  tag('top_color_purple', '上衣顏色', '紫色上衣', 'purple top', 2, false, 'top_color'),
  tag('top_color_green', '上衣顏色', '綠色上衣', 'green top', 2, false, 'top_color'),
  tag('top_color_yellow', '上衣顏色', '黃色上衣', 'yellow top', 2, false, 'top_color'),
  tag('top_color_brown', '上衣顏色', '棕色上衣', 'brown top', 2, false, 'top_color'),
  tag('bottom_color_black', '下身顏色', '黑色下身', 'black bottoms', 2, false, 'bottom_color'),
  tag('bottom_color_white', '下身顏色', '白色下身', 'white bottoms', 2, false, 'bottom_color'),
  tag('bottom_color_red', '下身顏色', '紅色下身', 'red bottoms', 2, false, 'bottom_color'),
  tag('bottom_color_blue', '下身顏色', '藍色下身', 'blue bottoms', 2, false, 'bottom_color'),
  tag('bottom_color_pink', '下身顏色', '粉紅色下身', 'pink bottoms', 2, false, 'bottom_color'),
  tag('bottom_color_purple', '下身顏色', '紫色下身', 'purple bottoms', 2, false, 'bottom_color'),
  tag('bottom_color_green', '下身顏色', '綠色下身', 'green bottoms', 2, false, 'bottom_color'),
  tag('bottom_color_yellow', '下身顏色', '黃色下身', 'yellow bottoms', 2, false, 'bottom_color'),
  tag('bottom_color_brown', '下身顏色', '棕色下身', 'brown bottoms', 2, false, 'bottom_color'),
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
  tag('pose_arms_up', '姿勢', '雙手舉起', 'arms up', 4, false, 'arm_pose'),
  tag('pose_hand_hip', '姿勢', '手放腰上', 'hand on hip', 4, false, 'hand_gesture'),
  tag('pose_leaning', '姿勢', '倚靠', 'leaning', 4),
  tag('pose_bent_over', '姿勢', '彎腰', 'bent over', 4, true),
  tag('pose_presenting', '姿勢', '展示姿勢', 'presenting', 4, true),
  tag('pose_ass_up', '姿勢', '翹臀', 'ass up', 4, true),
  tag('pose_from_behind', '姿勢', '背後視角', 'from behind', 4),
  tag('pose_selfie', '姿勢', '自拍', 'selfie', 4),
  tag('pose_sitting_chair', '姿勢', '坐在椅子上', 'sitting on chair', 4, false, 'basic_pose'),
  tag('pose_sitting_bed', '姿勢', '坐在床上', 'sitting on bed', 4, false, 'basic_pose'),
  tag('pose_sitting_floor', '姿勢', '坐在地上', 'sitting on floor', 4, false, 'basic_pose'),
  tag('pose_sitting_sofa', '姿勢', '坐在沙發上', 'sitting on sofa', 4, false, 'basic_pose'),
  tag('pose_sitting_bench', '姿勢', '坐在長椅上', 'sitting on bench', 4, false, 'basic_pose'),
  tag('pose_standing_straight', '姿勢', '立正站立', 'standing straight', 4, false, 'basic_pose'),
  tag('pose_standing_one_leg', '姿勢', '單腳站立', 'standing on one leg', 4, false, 'basic_pose'),
  tag('pose_standing_crossed_legs', '姿勢', '交叉腿站立', 'standing with crossed legs', 4, false, 'basic_pose'),
  tag('pose_standing_legs_apart', '姿勢', '分腿站立', 'standing with legs apart', 4, false, 'basic_pose'),
  tag('pose_standing_tiptoes', '姿勢', '踮腳站立', 'standing on tiptoes', 4, false, 'basic_pose'),
  tag('pose_lying_back', '姿勢', '仰躺', 'lying on back', 4, false, 'basic_pose'),
  tag('pose_lying_stomach', '姿勢', '趴躺', 'lying on stomach', 4, false, 'basic_pose'),
  tag('pose_lying_bed', '姿勢', '躺在床上', 'lying on bed', 4, false, 'basic_pose'),
  tag('pose_lying_floor', '姿勢', '躺在地上', 'lying on floor', 4, false, 'basic_pose'),
  tag('pose_one_leg_up', '姿勢', '抬起單腳', 'one leg raised', 4, false, 'leg_raise'),
  tag('pose_left_leg_up', '姿勢', '抬起左腳', 'left leg raised', 4, false, 'left_leg_raise'),
  tag('pose_right_leg_up', '姿勢', '抬起右腳', 'right leg raised', 4, false, 'right_leg_raise'),
  tag('pose_both_legs_up', '姿勢', '抬起雙腳', 'both legs raised', 4, false, 'leg_raise'),
  tag('pose_thigh_raised', '姿勢', '抬起大腿', 'raised thigh', 4, false, 'leg_detail'),
  tag('pose_lower_leg_raised', '姿勢', '抬起小腿', 'raised lower leg', 4, false, 'leg_detail'),
  tag('pose_bent_leg', '姿勢', '彎曲腿部', 'bent leg', 4, false, 'leg_detail'),
  tag('pose_left_hand_up', '姿勢', '抬起左手', 'left hand raised', 4, false, 'left_arm_pose'),
  tag('pose_right_hand_up', '姿勢', '抬起右手', 'right hand raised', 4, false, 'right_arm_pose'),
  tag('pose_one_hand_up', '姿勢', '抬起單手', 'one hand raised', 4, false, 'arm_pose'),
  tag('pose_both_hands_up', '姿勢', '抬起雙手', 'both hands raised', 4, false, 'arm_pose'),
  tag('pose_waving', '姿勢', '揮手', 'waving', 4, false, 'hand_gesture'),
  tag('pose_hands_together', '姿勢', '雙手合十', 'hands together', 4, false, 'hand_gesture'),
  tag('pose_hands_behind_back', '姿勢', '雙手放在背後', 'hands behind back', 4, false, 'hand_gesture'),
  tag('pose_hand_on_head', '姿勢', '手放在頭上', 'hand on head', 4, false, 'hand_gesture'),
  tag('pose_peace_sign', '姿勢', '比出和平手勢', 'peace sign', 4, false, 'hand_gesture'),
  tag('pose_pointing', '姿勢', '指向前方', 'pointing', 4, false, 'hand_gesture'),
  tag('pose_head_up', '姿勢', '抬頭', 'looking up', 4, false, 'head_vertical'),
  tag('pose_head_down', '姿勢', '低頭', 'looking down', 4, false, 'head_vertical'),
  tag('pose_head_tilt_left', '姿勢', '頭向左歪', 'head tilt left', 4, false, 'head_tilt'),
  tag('pose_head_tilt_right', '姿勢', '頭向右歪', 'head tilt right', 4, false, 'head_tilt'),
  tag('pose_head_turn_left', '姿勢', '頭轉向左側', 'head turned left', 4, false, 'head_direction'),
  tag('pose_head_turn_right', '姿勢', '頭轉向右側', 'head turned right', 4, false, 'head_direction'),
  tag('action_basketball_shooting', '動作', '投籃', 'shooting basketball', 4),
  tag('action_basketball_dribbling', '動作', '運球', 'dribbling basketball', 4),
  tag('action_basketball_dunk', '動作', '灌籃', 'dunking', 4),
  tag('action_soccer_kicking', '動作', '踢足球', 'kicking soccer ball', 4),
  tag('action_soccer_dribbling', '動作', '足球帶球', 'dribbling soccer ball', 4),
  tag('action_baseball_batting', '動作', '打棒球', 'batting', 4),
  tag('action_baseball_pitching', '動作', '投棒球', 'pitching', 4),
  tag('action_tennis_swing', '動作', '揮網球拍', 'swinging tennis racket', 4),
  tag('action_volleyball_spiking', '動作', '排球扣球', 'spiking volleyball', 4),
  tag('action_badminton_swing', '動作', '揮羽球拍', 'swinging badminton racket', 4),
  tag('action_archery', '動作', '射箭', 'drawing bow', 4),
  tag('action_aiming', '動作', '瞄準', 'aiming', 4),
  tag('action_sword_swinging', '動作', '揮劍', 'sword swinging', 4),
  tag('action_fencing', '動作', '擊劍', 'fencing', 4),
  tag('action_running', '動作', '奔跑', 'running', 4),
  tag('action_jumping', '動作', '跳躍', 'jumping', 4),
  tag('action_dancing', '動作', '跳舞', 'dancing', 4),
  tag('action_skating', '動作', '溜冰', 'ice skating', 4),
  tag('action_swimming', '動作', '游泳', 'swimming', 4),
  tag('action_cycling', '動作', '騎腳踏車', 'cycling', 4),
  tag('action_climbing', '動作', '攀爬', 'climbing', 4),
  tag('action_punching', '動作', '出拳', 'punching', 4),
  tag('action_kicking', '動作', '踢腿', 'kicking', 4),
  tag('action_throwing', '動作', '投擲', 'throwing', 4),
  tag('action_playing_guitar', '動作', '彈吉他', 'playing guitar', 4),
  tag('action_playing_piano', '動作', '彈鋼琴', 'playing piano', 4),
  tag('action_reading', '動作', '閱讀', 'reading', 4),
  tag('action_writing', '動作', '書寫', 'writing', 4),
  tag('action_painting', '動作', '繪畫', 'painting', 4),
  tag('action_photographing', '動作', '拍照', 'photography', 4),
  tag('action_using_phone', '動作', '使用手機', 'using smartphone', 4),
  tag('action_typing', '動作', '打字', 'typing', 4),
  tag('action_cooking', '動作', '烹飪', 'cooking', 4),
  tag('action_eating', '動作', '吃東西', 'eating', 4),
  tag('action_drinking', '動作', '喝東西', 'drinking', 4),
  tag('object_basketball', '物件', '籃球', 'basketball', 4),
  tag('object_soccer_ball', '物件', '足球', 'soccer ball', 4),
  tag('object_volleyball', '物件', '排球', 'volleyball', 4),
  tag('object_baseball', '物件', '棒球', 'baseball', 4),
  tag('object_baseball_bat', '物件', '棒球棒', 'baseball bat', 4),
  tag('object_tennis_racket', '物件', '網球拍', 'tennis racket', 4),
  tag('object_badminton_racket', '物件', '羽球拍', 'badminton racket', 4),
  tag('object_bow', '物件', '弓', 'bow', 4),
  tag('object_arrow', '物件', '箭', 'arrow', 4),
  tag('object_sword', '物件', '劍', 'sword', 4),
  tag('object_shield', '物件', '盾牌', 'shield', 4),
  tag('object_umbrella', '物件', '雨傘', 'umbrella', 4),
  tag('object_camera', '物件', '相機', 'camera', 4),
  tag('object_smartphone', '物件', '智慧型手機', 'smartphone', 4),
  tag('object_laptop', '物件', '筆記型電腦', 'laptop', 4),
  tag('object_tablet', '物件', '平板電腦', 'tablet', 4),
  tag('object_headphones', '物件', '耳機', 'headphones', 4),
  tag('object_book', '物件', '書本', 'book', 4),
  tag('object_notebook', '物件', '筆記本', 'notebook', 4),
  tag('object_pen', '物件', '原子筆', 'pen', 4),
  tag('object_pencil', '物件', '鉛筆', 'pencil', 4),
  tag('object_backpack', '物件', '背包', 'backpack', 4),
  tag('object_handbag', '物件', '手提包', 'handbag', 4),
  tag('object_briefcase', '物件', '公事包', 'briefcase', 4),
  tag('object_water_bottle', '物件', '水瓶', 'water bottle', 4),
  tag('object_cup', '物件', '杯子', 'cup', 4),
  tag('object_mug', '物件', '馬克杯', 'mug', 4),
  tag('object_plate', '物件', '盤子', 'plate', 4),
  tag('object_fork', '物件', '叉子', 'fork', 4),
  tag('object_spoon', '物件', '湯匙', 'spoon', 4),
  tag('object_chopsticks', '物件', '筷子', 'chopsticks', 4),
  tag('object_microphone', '物件', '麥克風', 'microphone', 4),
  tag('object_guitar', '物件', '吉他', 'guitar', 4),
  tag('object_violin', '物件', '小提琴', 'violin', 4),
  tag('object_piano', '物件', '鋼琴', 'piano', 4),
  tag('object_paintbrush', '物件', '畫筆', 'paintbrush', 4),
  tag('object_palette', '物件', '調色盤', 'palette', 4),
  tag('object_flower', '物件', '花朵', 'flower', 4),
  tag('object_bouquet', '物件', '花束', 'bouquet', 4),
  tag('object_balloon', '物件', '氣球', 'balloon', 4),
  tag('object_teddy_bear', '物件', '泰迪熊', 'teddy bear', 4),
  tag('object_stuffed_toy', '物件', '玩偶', 'stuffed toy', 4),
  tag('object_skateboard', '物件', '滑板', 'skateboard', 4),
  tag('object_bicycle', '物件', '腳踏車', 'bicycle', 4),
  tag('object_candle', '物件', '蠟燭', 'candle', 4),
  tag('object_key', '物件', '鑰匙', 'key', 4),
  tag('object_gift', '物件', '禮物', 'present', 4),
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
const negativeCatalog = [
  { en: 'lowres', zh: '低解析度' }, { en: 'blurry', zh: '模糊' },
  { en: 'worst quality', zh: '最差品質' }, { en: 'bad quality', zh: '低品質' },
  { en: 'bad anatomy', zh: '錯誤的人體結構' }, { en: 'bad hands', zh: '錯誤的手部' },
  { en: 'bad feet', zh: '錯誤的腳部' }, { en: 'extra digits', zh: '多餘手指' },
  { en: 'fewer digits', zh: '手指數量不足' }, { en: 'extra limbs', zh: '多餘肢體' },
  { en: 'missing fingers', zh: '缺少手指' }, { en: 'multiple views', zh: '多重視角' },
  { en: 'deformed', zh: '變形' }, { en: 'poorly drawn face', zh: '臉部繪製不佳' },
  { en: 'duplicate', zh: '重複內容' }, { en: 'text', zh: '文字' }, { en: 'error', zh: '錯誤' },
  { en: 'jpeg artifacts', zh: 'JPEG 壓縮瑕疵' }, { en: 'watermark', zh: '浮水印' },
  { en: 'logo', zh: '標誌' }, { en: 'signature', zh: '簽名' }, { en: 'username', zh: '使用者名稱' },
  { en: 'unfinished', zh: '未完成' }, { en: 'displeasing', zh: '令人不悅' },
  { en: 'scan artifacts', zh: '掃描瑕疵' }, { en: 'sketch', zh: '草稿' },
  { en: 'monochrome', zh: '單色' }, { en: 'greyscale', zh: '灰階' }, { en: 'artist name', zh: '藝術家名稱' },
];
const newSlot = () => ({ gender: '女性', detailed: true, mode: '原創', characterId: '', animeQuery: '', animeTag: '', query: '', originalAnimeZh: '', originalAnimeEn: '', originalAnimeTag: '', originalCharacterZh: '', originalCharacterEn: '', originalCharacterTag: '', originalTraitsZh: '', originalTraitsEn: '' });
const state = { selected: new Set(), personSelected: {}, personQueries: {}, wizardGroups: {}, customTags: [], customCharacters: [], recentCharacterIds: [], presets: [], group: '全部', query: '', step: 0, peopleSlots: [newSlot()], gender: '女性', count: 1, model: 'Amanatsu 1.1', sampler: 'Euler a', steps: 28, cfg: '5.0', clipSkip: '2', showAdult: false, preprompt: 'masterpiece, best quality, newest, absurdres, highres', extra: '', negative: defaultNegative, negativeTranslations: {} };
const lookupState = { query: '', target: 0, anime: [], characters: [], selectedAnime: null, loading: false, error: '' };

// AniList does not index every Chinese distribution title. Try common aliases
// automatically before reporting that a title cannot be found.
const animeSearchAliases = {
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
  '葬送的芙莉蓮': ['Frieren: Beyond Journey\'s End', 'Sousou no Frieren', '葬送のフリーレン'],
  '涼宮春日的憂鬱': ['The Melancholy of Haruhi Suzumiya', 'Suzumiya Haruhi no Yuuutsu', '涼宮ハルヒの憂鬱'],
  '出包王女': ['To LOVE-Ru', 'To LOVEる -とらぶる-'],
};
function animeSearchTerms(query) {
  const input = query.trim();
  const normalized = input.toLowerCase().replace(/\s+/g, '');
  const terms = [input];
  Object.entries(animeSearchAliases).forEach(([alias, variants]) => {
    if (alias.toLowerCase().replace(/\s+/g, '') === normalized) terms.push(...variants);
  });
  return [...new Set(terms.filter(Boolean))];
}

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
function traitOverrideGroups(en) {
  const value = String(en || '').trim().toLowerCase();
  const groups = new Set();
  if (/\b(blonde|black|silver|blue|red|pink|white|purple|aqua|brown|green|orange|yellow)\s+hair\b/.test(value)) groups.add('hair_color');
  if (/\b(very\s+short|very\s+long|long|medium|short)\s+hair\b/.test(value)) groups.add('hair_length');
  if (/\b(bob\s+cut|pixie\s+cut|straight\s+hair|wavy\s+hair|curly\s+hair|messy\s+hair|spiky\s+hair|braid|braids|ponytail|twintails|bun|odango|drill\s+hair)\b/.test(value)) groups.add('hair_style');
  if (/\b(green|blue|red|purple|yellow|aqua|brown|pink|orange)\s+eyes\b/.test(value)) groups.add('eye_color');
  if (['slim', 'tall', 'curvy', 'muscular', 'petite'].includes(value)) groups.add('body_type');
  if (['flat chest', 'small breasts', 'medium breasts', 'large breasts', 'huge breasts'].includes(value)) groups.add('breast_size');
  return groups;
}
function personOverrideGroups(index) { return new Set(selectedTags(index).flatMap(item => [...traitOverrideGroups(item.en)])); }
function traitsFromSlot(slot, index = null) {
  const c = characterForSlot(slot);
  if (!slot.detailed) return { en: [], zh: [] };
  if (slot.mode === '動漫角色' && c) {
    const replaced = index === null ? new Set() : personOverrideGroups(index);
    const traits = c.traits.filter(item => [...traitOverrideGroups(item.en)].every(group => !replaced.has(group)));
    return { en: traits.map(item => item.en), zh: traits.map(item => item.zh) };
  }
  return { en: splitTags(slot.originalTraitsEn), zh: splitTags(slot.originalTraitsZh) };
}
function characterChineseForSlot(slot, index = null) {
  if (!slot.detailed) return ['此角色不設定細節'];
  const c = characterForSlot(slot);
  if (slot.mode === '動漫角色' && c) return [`${c.animeZh}（${c.animeEn}）`, `${c.characterZh}（${c.characterEn}）`, ...traitsFromSlot(slot, index).zh];
  const names = [];
  if (slot.originalAnimeZh.trim() || slot.originalAnimeEn.trim()) names.push(`${slot.originalAnimeZh || slot.originalAnimeEn}（${slot.originalAnimeEn || slot.originalAnimeZh}）`);
  if (slot.originalCharacterZh.trim() || slot.originalCharacterEn.trim()) names.push(`${slot.originalCharacterZh || slot.originalCharacterEn}（${slot.originalCharacterEn || slot.originalCharacterZh}）`);
  return [...names, ...traitsFromSlot(slot, index).zh];
}
function characterEnglishForSlot(slot, index = null) {
  if (!slot.detailed) return [];
  const c = characterForSlot(slot);
  if (slot.mode === '動漫角色' && c) return [c.animeTag, c.characterTag, ...traitsFromSlot(slot, index).en];
  const names = [];
  if (slot.originalAnimeTag.trim()) names.push(clean(slot.originalAnimeTag));
  if (slot.originalCharacterTag.trim()) names.push(clean(slot.originalCharacterTag));
  return [...names, ...traitsFromSlot(slot, index).en].filter(Boolean);
}
function characterTokens() {
  const en = [], zh = [];
  state.peopleSlots.forEach(slot => {
    en.push(...characterEnglishForSlot(slot, state.peopleSlots.indexOf(slot)));
    zh.push(...characterChineseForSlot(slot, state.peopleSlots.indexOf(slot)));
  });
  return { en: unique(en.filter(Boolean)), zh: unique(zh.filter(Boolean)) };
}
function personTagSet(index) { if (!state.personSelected[index]) state.personSelected[index] = []; return new Set(state.personSelected[index]); }
function savePersonTagSet(index, ids) { state.personSelected[index] = [...ids]; }
const outputGroupOrder = { '外觀特徵': 10, '臉部特徵': 11, '胸部': 12, '裸露': 13, '髮型': 14, '服裝': 20, '服裝風格': 21, '服裝顏色': 22, '上衣': 23, '上衣風格': 24, '上衣顏色': 25, '褲子': 26, '裙子': 26, '下身風格': 27, '下身顏色': 28, '內衣': 30, '胸罩': 31, '內褲': 32, '襪子': 33, '鞋子': 34, '配件': 35, '配件顏色': 36, '服裝細節': 37, '服裝材質': 38, '穿脫狀態': 39, '表情': 40, '姿勢': 41, '性行為': 42, '性姿勢': 43, '動作': 44, '物件': 45, '場景': 60, '畫面': 61 };
function selectedTags(personIndex = null) { const ids = personIndex === null ? state.selected : personTagSet(personIndex); return allTags().filter(item => ids.has(item.id)).sort((a, b) => (outputGroupOrder[a.group] ?? 50) - (outputGroupOrder[b.group] ?? 50) || a.order - b.order || a.en.localeCompare(b.en)); }
function personSelectedCount() { return Object.values(state.personSelected).reduce((total, ids) => total + ids.length, 0); }
function tokens() { const perPerson = []; state.peopleSlots.forEach((slot, index) => { perPerson.push(...characterEnglishForSlot(slot, index), ...selectedTags(index).map(item => item.en)); }); return unique([...peopleTokens(), ...perPerson, ...selectedTags().map(item => item.en), ...splitTags(state.extra), ...splitTags(state.preprompt)]); }
function positiveText() { return tokens().map(item => `${item}.`).join(' '); }
function chineseText() { const list = [personSummary()]; state.peopleSlots.forEach((slot, index) => { if (!slot.detailed) return; list.push(`人物 ${index + 1}：${[...characterChineseForSlot(slot, index), ...selectedTags(index).map(item => item.zh)].join('、')}`); }); list.push(...selectedTags().map(item => item.zh)); if (state.extra.trim()) list.push(`額外正向標籤：${state.extra.trim()}`); if (state.preprompt.trim()) list.push(`Amanatsu 品質前綴：${state.preprompt.trim()}`); return list.join('。'); }
const negativeTranslations = { lowres: '低解析度', 'worst quality': '最差品質', 'bad quality': '低品質', 'bad anatomy': '錯誤的人體結構', 'bad hands': '錯誤的手部', 'extra digits': '多餘手指', 'multiple views': '多重視角', 'fewer digits': '手指數量不足', 'extra limbs': '多餘肢體', 'missing fingers': '缺少手指', deformed: '變形', text: '文字', error: '錯誤', 'jpeg artifacts': 'JPEG 壓縮瑕疵', watermark: '浮水印', unfinished: '未完成', displeasing: '令人不悅', signature: '簽名', username: '使用者名稱', 'scan artifacts': '掃描瑕疵', 'bad feet': '錯誤的腳部', 'poorly drawn face': '臉部繪製不佳', duplicate: '重複內容', 'short hair': '短髮', 'very short hair': '極短髮', 'long hair': '長髮', 'very long hair': '超長髮', 'medium hair': '中長髮' };
function hairLengthTag(value) { const match = /^\s*(very short|very long|long|medium|short) hair\s*$/i.exec(String(value || '')); return match ? match[0].toLowerCase() : ''; }
function effectiveHairLength(slot, index) {
  if (!slot.detailed) return '';
  const selected = selectedTags(index).map(item => hairLengthTag(item.en)).find(Boolean);
  if (selected) return selected;
  const character = characterForSlot(slot);
  if (slot.mode === '動漫角色' && character) {
    const original = character.traits.map(item => hairLengthTag(item.en)).find(Boolean);
    if (original) return original;
  }
  return splitTags(slot.originalTraitsEn).map(hairLengthTag).find(Boolean) || '';
}
function hairGuardNegativeTags() {
  const lengths = [];
  state.peopleSlots.forEach((slot, index) => {
    const length = effectiveHairLength(slot, index);
    if (length && !lengths.includes(length)) lengths.push(length);
  });
  if (lengths.length !== 1) return [];
  const result = [];
  if (lengths[0] === 'short hair' || lengths[0] === 'very short hair') result.push('long hair');
  else if (lengths[0] === 'long hair' || lengths[0] === 'very long hair') result.push('short hair');
  else if (lengths[0] === 'medium hair') result.push('short hair', 'long hair');
  return unique(result);
}
function negativeTokens() { return unique([...splitTags(state.negative), ...hairGuardNegativeTags()]); }
function negativeText() { return negativeTokens().map(item => `${item}.`).join(' '); }
function negativeChinese() { return negativeTokens().map(item => state.negativeTranslations?.[item.toLowerCase()] || negativeTranslations[item.toLowerCase()] || `未翻譯：${item}`).map(item => `${item}。`).join(' '); }

function negativeToolsMarkup() {
  const selected = new Set(splitTags(state.negative).map(item => item.toLowerCase()));
  return `<div class="negative-tools"><button type="button" class="ghost" data-add-negative>＋ 新增負面標籤</button><button type="button" class="ghost" data-reset-negative>恢復預設負面標籤</button></div><div class="tag-list compact negative-presets">${negativeCatalog.map(item => `<button type="button" class="tag ${selected.has(item.en.toLowerCase()) ? 'selected' : ''}" data-negative-tag="${esc(item.en)}" data-negative-zh="${esc(item.zh)}">${esc(item.zh)} / ${esc(item.en)}</button>`).join('')}</div>`;
}
function toggleNegativeTag(en, zh) {
  const tags = splitTags(state.negative);
  const index = tags.findIndex(item => item.toLowerCase() === en.toLowerCase());
  if (index >= 0) tags.splice(index, 1); else tags.push(en);
  state.negativeTranslations = state.negativeTranslations || {};
  state.negativeTranslations[en.toLowerCase()] = zh;
  state.negative = tags.join(', ');
  render();
}
function addNegativeTag() {
  const en = clean(window.prompt('請輸入英文負面標籤', '') || '');
  if (!en) return;
  const zh = clean(window.prompt('請輸入中文翻譯（可留空）', '') || '') || en;
  const tags = splitTags(state.negative);
  if (!tags.some(item => item.toLowerCase() === en.toLowerCase())) tags.push(en);
  state.negativeTranslations = state.negativeTranslations || {};
  state.negativeTranslations[en.toLowerCase()] = zh;
  state.negative = tags.join(', ');
  render();
  toast(`已加入負面標籤：${en}`);
}

function snapshot() { return { ...state, selected: [...state.selected], personSelected: state.personSelected, peopleSlots: state.peopleSlots.map(slot => ({ ...slot })) }; }
function persist() { localStorage.setItem(STORAGE_KEY, JSON.stringify(snapshot())); }
function toast(message) { const element = $('#toast'); if (!element) return; element.textContent = message; element.classList.add('show'); clearTimeout(toast.timer); toast.timer = setTimeout(() => element.classList.remove('show'), 1900); }
function renderVersionInfo() { const label = $('#app-version'); if (label) label.textContent = `v${APP_VERSION.label}`; const outputVersion = $('#output-version'); if (outputVersion) outputVersion.textContent = APP_VERSION.label; const history = $('#version-history'); if (history) history.innerHTML = (APP_VERSION.history || []).map(item => `<article class="version-entry"><b>${esc(item.label)} · ${esc(item.date)}</b><p>${esc(item.notes)}</p></article>`).join(''); }
function checkForVersionUpdate() { const previous = localStorage.getItem(VERSION_STORAGE_KEY); localStorage.setItem(VERSION_STORAGE_KEY, APP_VERSION.label); if (previous && previous !== APP_VERSION.label) { setTimeout(() => { toast(`已更新至 ${APP_VERSION.label}`); $('#version-dialog')?.showModal(); }, 350); } }
function migrateLegacyPersonalTags(saved) { if (saved.personSelected) return; const personalGroups = new Set(['外觀特徵', '臉部特徵', '胸部', '裸露', '髮型', '上衣', '褲子', '裙子', '內衣', '胸罩', '內褲', '襪子', '鞋子', '服裝', '配件', '配件顏色', '服裝風格', '上衣風格', '下身風格', '上衣顏色', '下身顏色', '服裝顏色', '服裝細節', '服裝材質', '穿脫狀態', '表情', '姿勢', '動作', '物件', '性行為', '性姿勢']); const ids = allTags().filter(item => state.selected.has(item.id) && personalGroups.has(item.group)).map(item => item.id); if (ids.length) { state.personSelected[0] = ids; ids.forEach(id => state.selected.delete(id)); } }
function restore() { try { const saved = JSON.parse(localStorage.getItem(STORAGE_KEY) || 'null'); if (!saved) return; Object.assign(state, saved); state.negativeTranslations = saved.negativeTranslations || {}; state.selected = new Set(saved.selected || []); state.personSelected = saved.personSelected || {}; migrateLegacyPersonalTags(saved); state.personQueries = {}; state.peopleSlots = (saved.peopleSlots || []).map(slot => ({ ...newSlot(), ...slot })); if (!state.peopleSlots.length) state.peopleSlots = [newSlot()]; state.customTags = saved.customTags || []; state.customCharacters = saved.customCharacters || []; state.recentCharacterIds = saved.recentCharacterIds || []; state.presets = saved.presets || []; state.count = state.peopleSlots.length; state.gender = state.peopleSlots[0].gender; } catch { toast('記憶資料無法讀取，已使用預設值。'); } }

function setPeopleCount(value) { const count = Math.max(1, Math.min(10, Number(value) || 1)); while (state.peopleSlots.length < count) state.peopleSlots.push(newSlot()); while (state.peopleSlots.length > count) state.peopleSlots.pop(); Object.keys(state.personSelected).forEach(key => { if (Number(key) >= count) delete state.personSelected[key]; }); state.count = count; state.gender = state.peopleSlots[0].gender; lookupState.target = Math.min(lookupState.target, count - 1); }
function searchAnime(slot) { const q = slot.animeQuery.toLowerCase().trim(); const seen = new Set(); return allCharacters().filter(item => { if (seen.has(item.animeTag)) return false; seen.add(item.animeTag); return !q || `${item.animeZh} ${item.animeEn} ${item.animeTag}`.toLowerCase().includes(q); }).slice(0, 12); }
function searchCharacters(slot) { const q = slot.query.toLowerCase().trim(); return allCharacters().filter(item => (slot.animeTag ? item.animeTag === slot.animeTag : false) && (!q || `${item.characterZh} ${item.characterEn} ${item.characterTag}`.toLowerCase().includes(q))).slice(0, 12); }
function recentCharacters() { return state.recentCharacterIds.map(findCharacter).filter(Boolean); }
function chooseAnime(index, animeTag) { const slot = state.peopleSlots[index]; slot.animeTag = animeTag; slot.animeQuery = ''; slot.query = ''; slot.characterId = ''; persist(); render(); }
function chooseCharacter(index, id) { const slot = state.peopleSlots[index]; const c = findCharacter(id); if (!c) return; slot.mode = '動漫角色'; slot.animeTag = c.animeTag; slot.characterId = c.id; slot.query = ''; state.recentCharacterIds = [c.id, ...state.recentCharacterIds.filter(item => item !== c.id)].slice(0, 10); persist(); render(); }
function characterComplete() { return state.peopleSlots.every(slot => !slot.detailed || (slot.mode === '動漫角色' ? Boolean(characterForSlot(slot)) : Boolean(slot.originalCharacterEn.trim() && slot.originalCharacterTag.trim()))); }
function slug(value) { return clean(value).toLowerCase().replace(/[^a-z0-9_ -]/g, '').replace(/\s+/g, '_'); }

async function jikanJson(path) {
  const response = await fetch(`https://api.jikan.moe/v4/${path}`);
  if (!response.ok) throw new Error(`Jikan HTTP ${response.status}`);
  return response.json();
}
async function anilistJson(query, search) {
  const response = await fetch('https://graphql.anilist.co', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ query, variables: { search } }) });
  if (!response.ok) throw new Error(`AniList HTTP ${response.status}`);
  return response.json();
}
async function searchRemoteAnime() {
  const query = clean(lookupState.query);
  if (!query) { toast('請先輸入動漫名稱再查詢'); return; }
  lookupState.loading = true; lookupState.error = ''; render();
  try {
    const queryText = `query ($search: String!) { Page(perPage: 8) { media(search: $search, type: ANIME) { id title { romaji english native } synonyms startDate { year } characters(perPage: 50) { edges { role node { id name { full native } description } } } } } }`;
    const raw = [];
    for (const term of animeSearchTerms(query)) {
      const result = await anilistJson(queryText, term);
      raw.push(...(result.data?.Page?.media || []));
      if (raw.length) break;
    }
    const seen = new Set();
    lookupState.anime = raw.filter(item => {
      if (!item.id || seen.has(item.id)) return false;
      seen.add(item.id);
      return item.title?.english || item.title?.romaji || item.title?.native;
    }).map(item => ({ id: item.id, source: 'anilist', title: item.title.english || item.title.romaji || item.title.native, titleJapanese: item.title.native || '', synonyms: item.synonyms || [], year: item.startDate?.year || '', characters: (item.characters?.edges || []).filter(edge => edge.node?.id && edge.node?.name?.full).map(edge => ({ id: edge.node.id, name: edge.node.name.full, nameKanji: edge.node.name.native || '', role: edge.role || '', about: edge.node.description || '' })) }));
    if (!lookupState.anime.length) lookupState.error = '查無作品。已嘗試常見中文別名，請改用英文／日文名稱或使用手動新增。';
  } catch { lookupState.anime = []; lookupState.error = '自動查詢失敗，請稍後再試或使用手動新增。'; }
  lookupState.loading = false; render();
}
async function loadRemoteCharacters(anime) {
  lookupState.loading = true; lookupState.error = ''; lookupState.selectedAnime = anime; render();
  try {
    lookupState.characters = anime.source === 'anilist' ? anime.characters : (await jikanJson(`anime/${anime.id}/characters`)).data || [];
  } catch { lookupState.characters = []; lookupState.error = '角色查詢失敗，請稍後再試。'; }
  lookupState.loading = false; render();
}
async function remoteAbout(id) { try { const result = await jikanJson(`characters/${id}/full`); return result.data?.about || ''; } catch { return ''; } }
function remoteTraits(about) {
  const text = String(about || '').toLowerCase().replaceAll('-', ' '); const traits = []; const add = (zh, en) => { if (!traits.some(item => item.en === en)) traits.push({ zh, en }); };
  const hairs = { pink: '粉紅色頭髮', red: '紅色頭髮', blue: '藍色頭髮', green: '綠色頭髮', purple: '紫色頭髮', blonde: '金色頭髮', black: '黑色頭髮', white: '白色頭髮', silver: '銀色頭髮', brown: '棕色頭髮', aqua: '藍綠色頭髮', orange: '橘色頭髮', yellow: '黃色頭髮' };
  Object.entries(hairs).forEach(([en, zh]) => { if (new RegExp(`\\b${en} hair\\b`).test(text)) add(zh, `${en} hair`); });
  const eyes = { pink: '粉紅色眼睛', red: '紅色眼睛', blue: '藍色眼睛', green: '綠色眼睛', purple: '紫色眼睛', brown: '棕色眼睛', aqua: '藍綠色眼睛', yellow: '黃色眼睛' };
  Object.entries(eyes).forEach(([en, zh]) => { if (new RegExp(`\\b${en} eyes?\\b`).test(text)) add(zh, `${en} eyes`); });
  [['very long hair', '超長髮', 'very long hair'], ['long hair', '長髮', 'long hair'], ['medium hair', '中長髮', 'medium hair'], ['short hair', '短髮', 'short hair'], ['very short hair', '極短髮', 'very short hair'], ['bob cut', '鮑伯頭', 'bob cut'], ['pixie cut', '精靈短髮', 'pixie cut'], ['straight hair', '直髮', 'straight hair'], ['wavy hair', '波浪髮', 'wavy hair'], ['curly hair', '捲髮', 'curly hair'], ['twin tails', '雙馬尾', 'twintails'], ['twintails', '雙馬尾', 'twintails'], ['ponytail', '馬尾', 'ponytail'], ['braid', '辮子', 'braid'], ['bun', '髮髻', 'hair bun'], ['ahoge', '呆毛', 'ahoge'], ['glasses', '眼鏡', 'glasses'], ['horns', '角', 'horns'], ['elf ears', '精靈耳', 'elf ears'], ['pointed ears', '尖耳朵', 'pointed ears'], ['tail', '尾巴', 'tail'], ['slim', '纖細身材', 'slim'], ['medium breasts', '中等胸部', 'medium breasts'], ['large breasts', '豐滿胸部', 'large breasts']].forEach(([needle, zh, en]) => { if (text.includes(needle) && !(needle === 'long hair' && text.includes('very long hair')) && !(needle === 'short hair' && text.includes('very short hair'))) add(zh, en); });
  return traits;
}
function remoteCatalogCharacter(anime, remote) {
  const normalized = remote.name.toLowerCase().replace(/[^a-z0-9]/g, ''); const local = allCharacters().find(item => item.characterEn.toLowerCase().replace(/[^a-z0-9]/g, '') === normalized || item.characterTag === slug(remote.name));
  return { id: `jikan_character_${remote.id}`, animeZh: anime.titleJapanese || anime.title, animeEn: anime.title, animeTag: slug(anime.title), characterZh: remote.nameKanji || remote.name, characterEn: remote.name, characterTag: slug(remote.name), traits: local?.traits || remoteTraits(remote.about) };
}
async function importRemoteCharacters() {
  const anime = lookupState.selectedAnime; if (!anime || !lookupState.characters.length) return;
  lookupState.loading = true; render(); const additions = []; const target = Number(lookupState.target) || 0;
  for (let index = 0; index < lookupState.characters.length; index += 1) {
    const remote = lookupState.characters[index];
    if (index < 18 && !remote.about && anime.source !== 'anilist') remote.about = await remoteAbout(remote.id);
    const character = remoteCatalogCharacter(anime, remote);
    if (!state.customCharacters.some(item => item.id === character.id)) additions.push(character);
    if (index < lookupState.characters.length - 1 && index < 17) await new Promise(resolve => setTimeout(resolve, 350));
  }
  state.customCharacters.push(...additions); const slot = state.peopleSlots[target];
  if (slot && additions.length) { slot.mode = '動漫角色'; slot.characterId = additions[0].id; slot.animeTag = additions[0].animeTag; state.recentCharacterIds = [additions[0].id, ...state.recentCharacterIds.filter(id => id !== additions[0].id)].slice(0, 10); }
  lookupState.loading = false; persist(); render(); toast(`已匯入 ${additions.length} 個角色；前 18 個會嘗試從公開簡介補抓外觀特徵`);
}
function remoteLookupStep() {
  const characters = lookupState.characters; const anime = lookupState.selectedAnime;
  return `<article class="lookup-panel"><div class="lookup-row"><label>自動查詢動漫（公開資料）<input data-auto-anime-query value="${esc(lookupState.query)}" placeholder="例如：To LOVE-Ru、Re:ZERO"></label><label>加入第幾位人物<select data-auto-target>${state.peopleSlots.map((_, index) => `<option value="${index}" ${lookupState.target === index ? 'selected' : ''}>人物 ${index + 1}</option>`).join('')}</select></label><button type="button" class="primary" data-auto-search-anime ${lookupState.loading ? 'disabled' : ''}>🌐 自動查詢</button></div>${lookupState.error ? `<p class="wizard-note">${esc(lookupState.error)}</p>` : ''}${lookupState.anime.length ? `<div class="lookup-box"><b>動漫搜尋結果</b>${lookupState.anime.map(item => `<button class="character-result" data-auto-anime="${item.id}">${esc(item.title)}${item.titleJapanese ? ` · ${esc(item.titleJapanese)}` : ''}<small>查詢此作品的角色</small></button>`).join('')}</div>` : ''}${anime ? `<div class="lookup-box"><b>${esc(anime.title)}：已查到 ${characters.length} 名角色</b><button type="button" class="ghost" data-auto-import-all ${lookupState.loading ? 'disabled' : ''}>匯入角色與可辨識特徵</button>${characters.map(item => `<span class="remote-character-chip">${esc(item.name)}${item.nameKanji ? ` · ${esc(item.nameKanji)}` : ''}</span>`).join('')}</div>` : ''}<p class="wizard-note">資料來源：AniList；若該來源無法回應會顯示錯誤，匯入後仍可手動新增與修正角色特徵。</p></article>`;
}

function conflictGroup(item) { if (item.conflictGroup) return item.conflictGroup; const traitGroup = [...traitOverrideGroups(item.en)][0]; if (traitGroup) return traitGroup; if (item.group === '上衣風格') return 'top_style'; if (item.group === '下身風格') return 'bottom_style'; if (item.group === '上衣顏色') return 'top_color'; if (item.group === '下身顏色') return 'bottom_color'; if (item.group === '服裝顏色') return 'clothing_color'; if (item.group === '配件顏色') return 'accessory_color'; if (item.group === '上衣') return 'top'; if (['褲子', '裙子'].includes(item.group)) return 'bottom'; if (item.group === '胸罩') return 'bra'; if (['內衣', '內褲'].includes(item.group)) return 'underwear'; if (['服裝', '服裝風格'].includes(item.group)) return 'one_piece'; return ''; }
function conflictingTags(candidate, personIndex = null) {
  const group = conflictGroup(candidate); if (!group) return [];
  return selectedTags(personIndex).filter(item => {
    const other = conflictGroup(item); if (!other) return false;
    if (group === 'basic_pose' && other === 'basic_pose') return true;
    if (group === 'topless' && ['top', 'top_style', 'bra'].includes(other)) return true;
    if (group === 'bottomless' && ['bottom', 'bottom_style', 'underwear'].includes(other)) return true;
    if (['top', 'top_style', 'bra'].includes(group) && other === 'topless') return true;
    if (group === 'arm_pose' && ['left_arm_pose', 'right_arm_pose'].includes(other)) return true;
    if (['left_arm_pose', 'right_arm_pose'].includes(group) && other === 'arm_pose') return true;
    if (['bottom', 'bottom_style', 'underwear'].includes(group) && other === 'bottomless') return true;
    const clothingLayers = ['top', 'bottom', 'top_color', 'bottom_color', 'top_style', 'bottom_style'];
    if (group === 'one_piece' && clothingLayers.includes(other)) return true;
    if (other === 'one_piece' && clothingLayers.includes(group)) return true;
    if (group === 'nudity' && [...clothingLayers, 'one_piece'].includes(other)) return true;
    if (other === 'nudity' && [...clothingLayers, 'one_piece'].includes(group)) return true;
    return group === other && ['scene', 'time', 'framing', 'camera', 'hair_color', 'hair_length', 'body_type', 'breast_size', 'expression_eyes', 'expression_mouth', 'expression_mood', 'wear_state', 'legwear', 'footwear', 'sex_position'].includes(group);
  });
}
function characterOverrideMessage(item, personIndex) {
  if (personIndex === null) return '';
  const slot = state.peopleSlots[personIndex];
  const character = slot && slot.mode === '動漫角色' ? characterForSlot(slot) : null;
  const groups = traitOverrideGroups(item.en);
  if (!character || !groups.size) return '';
  if (selectedTags(personIndex).some(selected => [...traitOverrideGroups(selected.en)].some(group => groups.has(group)))) return '';
  const replaced = character.traits.filter(trait => [...traitOverrideGroups(trait.en)].some(group => groups.has(group)));
  if (!replaced.length) return '';
  return `角色「${character.characterZh}」原本包含：${replaced.map(trait => `${trait.zh}（${trait.en}）`).join('、')}。\n\n新增「${item.zh}（${item.en}）」會替換同類特徵，輸出時移除原本的標籤。要套用嗎？`;
}
function toggleTag(id, personIndex = null) { const item = allTags().find(candidate => candidate.id === id); if (!item) return; const ids = personIndex === null ? state.selected : personTagSet(personIndex); if (ids.has(id)) { ids.delete(id); if (personIndex === null) state.selected = ids; else savePersonTagSet(personIndex, ids); render(); return; } const overrideMessage = characterOverrideMessage(item, personIndex); if (overrideMessage && !window.confirm(overrideMessage)) return; const conflicts = conflictingTags(item, personIndex); if (conflicts.length) { const names = conflicts.map(candidate => `${candidate.zh} (${candidate.en})`).join('、'); if (!window.confirm(`新增「${item.zh}」會與已選標籤衝突：${names}\n\n按「確定」移除原標籤並換成新標籤；按「取消」保留原選擇。`)) return; conflicts.forEach(candidate => ids.delete(candidate.id)); } ids.add(id); if (personIndex === null) state.selected = ids; else savePersonTagSet(personIndex, ids); render(); }

function tagButton(item, personIndex = null) { const selected = personIndex === null ? state.selected.has(item.id) : personTagSet(personIndex).has(item.id); return `<button class="tag ${selected ? 'selected' : ''} ${item.adult ? 'adult' : ''}" data-tag="${esc(item.id)}" data-person-tag="${personIndex === null ? '' : personIndex}"><span>${item.adult ? '<i class="adult-dot">18+</i> ' : ''}${esc(item.zh)}</span><em>${esc(item.en)}</em></button>`; }
function renderTagPicker(groups, filterKey, personIndex = null) { const query = personIndex === null ? (state.wizardQuery || '') : (state.personQueries[personIndex] || ''); const filtered = allTags().filter(item => groups.includes(item.group) && (state.showAdult || !item.adult) && (!query || `${item.zh} ${item.en}`.toLowerCase().includes(query.toLowerCase()))); return `<div class="search-line"><span>⌕</span><input data-wizard-search="${filterKey}" data-person-search="${personIndex === null ? '' : personIndex}" value="${esc(query)}" placeholder="搜尋中文或英文標籤…"></div><div class="wizard-tags">${filtered.length ? filtered.map(item => tagButton(item, personIndex)).join('') : '<div class="empty">沒有符合的標籤，可使用新增自訂標籤。</div>'}</div>`; }
function stepHeader(index, title, desc, icon) { const open = state.step === index; return `<button class="wizard-header" data-step="${index}"><span class="wizard-number">${index + 1}</span><span class="wizard-icon">${icon}</span><span class="wizard-title"><b>${title}</b><small>${desc}</small></span><span class="wizard-chevron">${open ? '⌃' : '⌄'}</span></button>`; }
function stepCard(index, title, desc, icon, body) { return `<section class="wizard-step ${state.step === index ? 'open' : 'closed'}">${stepHeader(index, title, desc, icon)}${state.step === index ? `<div class="wizard-body"><div class="wizard-body-inner">${body}</div></div>` : ''}</section>`; }
function nextButton(label = '下一步') { return `<div class="wizard-actions"><button class="primary" data-next="1">${label} →</button></div>`; }

function peopleStep() { return `<div class="wizard-controls"><label>人物數量<select data-people-count>${[1, 2, 3, 4, 5, 6].map(value => `<option value="${value}" ${state.peopleSlots.length === value ? 'selected' : ''}>${value} 人</option>`).join('')}</select></label><label>模型<select data-setting="model"><option>Amanatsu 1.1</option><option>Amanatsu（自訂設定）</option><option>通用 Danbooru</option></select></label><label>Sampler<select data-setting="sampler"><option>Euler a</option><option>DPM++ 2M Karras</option><option>DPM++ SDE Karras</option><option>DDIM</option></select></label><label>Steps<select data-setting="steps">${[20, 24, 28, 32, 35, 40].map(value => `<option ${state.steps === value ? 'selected' : ''}>${value}</option>`).join('')}</select></label></div><div class="wizard-controls" style="margin-top:10px"><label>CFG<select data-setting="cfg">${['4.5', '5.0', '5.5', '6.0', '7.0'].map(value => `<option ${state.cfg === value ? 'selected' : ''}>${value}</option>`).join('')}</select></label><label>Clip skip<select data-setting="clipSkip"><option ${state.clipSkip === '1' ? 'selected' : ''}>1</option><option ${state.clipSkip === '2' ? 'selected' : ''}>2</option></select></label><div class="wizard-note">先設定人物數量，再為每個人物選擇性別與詳細資料模式。</div></div>${nextButton()}`; }
function peopleCharacterCard(slot, index) { const matches = searchCharacters(slot); const c = characterForSlot(slot); const recent = recentCharacters(); return `<article class="character-card"><div class="character-card-head"><b>人物 ${index + 1}</b><span class="model-pill">${slot.detailed ? '需要詳細標籤' : '不需詳細'}</span></div><div class="person-grid"><label>性別<select data-slot-gender="${index}"><option ${slot.gender === '女性' ? 'selected' : ''}>女性</option><option ${slot.gender === '男性' ? 'selected' : ''}>男性</option><option ${slot.gender === '其他' ? 'selected' : ''}>其他／異種</option></select></label><label class="switch-row" style="margin:0"><input type="checkbox" data-slot-detailed="${index}" ${slot.detailed ? 'checked' : ''}><span class="switch"></span><span><b>詳細角色資料</b><small>關閉則只輸出人物數量</small></span></label></div><div class="character-modes"><button class="mode-chip ${slot.mode === '原創' ? 'active' : ''}" data-slot-mode="${index}" data-mode="原創">原創角色</button><button class="mode-chip ${slot.mode === '動漫角色' ? 'active' : ''}" data-slot-mode="${index}" data-mode="動漫角色">動漫角色</button></div>${slot.mode === '動漫角色' && slot.detailed ? `<label>查詢動漫或角色<input data-character-query="${index}" value="${esc(slot.query)}" placeholder="例如：To LOVE-Ru、Lala、拉拉"></label><div class="character-results">${matches.map(item => `<button class="character-result ${c?.id === item.id ? 'active' : ''}" data-character="${index}:${esc(item.id)}">${esc(item.characterZh)} · ${esc(item.characterEn)}<small>${esc(item.animeZh)} · ${esc(item.animeEn)}</small></button>`).join('')}</div>${!slot.query && recent.length ? `<div class="recent-label">最近使用角色</div><div class="character-results">${recent.slice(0, 6).map(item => `<button class="character-result" data-character="${index}:${esc(item.id)}">${esc(item.characterZh)}<small>${esc(item.animeEn)}</small></button>`).join('')}</div>` : ''}<button class="ghost" data-open-character style="margin-top:10px">＋ 新增動漫／原創角色資料</button>${c ? `<p class="wizard-note">角色自帶標籤：${esc(c.traits.map(item => `${item.zh} / ${item.en}`).join('、'))}</p>` : ''}` : slot.detailed ? `<div class="wizard-fields"><label>作品／系列中文<input data-original-field="${index}:originalAnimeZh" value="${esc(slot.originalAnimeZh)}" placeholder="原創作品"></label><label>Anime / series English<input data-original-field="${index}:originalAnimeEn" value="${esc(slot.originalAnimeEn)}"></label><label>作品英文標籤<input data-original-field="${index}:originalAnimeTag" value="${esc(slot.originalAnimeTag)}" placeholder="original_series"></label><label>角色中文<input data-original-field="${index}:originalCharacterZh" value="${esc(slot.originalCharacterZh)}"></label><label>Character English<input data-original-field="${index}:originalCharacterEn" value="${esc(slot.originalCharacterEn)}"></label><label>角色英文標籤<input data-original-field="${index}:originalCharacterTag" value="${esc(slot.originalCharacterTag)}" placeholder="my_character"></label><label>特徵中文<textarea data-original-field="${index}:originalTraitsZh" rows="2" placeholder="粉紅頭髮, 呆毛, 綠眼睛">${esc(slot.originalTraitsZh)}</textarea></label><label>Traits English<textarea data-original-field="${index}:originalTraitsEn" rows="2" placeholder="pink hair, ahoge, green eyes">${esc(slot.originalTraitsEn)}</textarea></label></div>` : '<p class="wizard-note">此人物將只使用人物數量標籤，不加入作品、角色與外觀細節。</p>'}</article>`; }
function peopleCharacterCard(slot, index) { const animeMatches = searchAnime(slot); const matches = searchCharacters(slot); const c = characterForSlot(slot); return `<article class="character-card"><div class="character-card-head"><b>人物 ${index + 1}</b><span class="model-pill">${slot.detailed ? '需要詳細標籤' : '不需詳細'}</span></div><div class="person-grid"><label>性別<select data-slot-gender="${index}"><option ${slot.gender === '女性' ? 'selected' : ''}>女性</option><option ${slot.gender === '男性' ? 'selected' : ''}>男性</option><option ${slot.gender === '其他' ? 'selected' : ''}>其他／異種</option></select></label><label class="switch-row" style="margin:0"><input type="checkbox" data-slot-detailed="${index}" ${slot.detailed ? 'checked' : ''}><span class="switch"></span><span><b>詳細角色資料</b><small>關閉則只輸出人物數量</small></span></label></div><div class="character-modes"><button class="mode-chip ${slot.mode === '原創' ? 'active' : ''}" data-slot-mode="${index}" data-mode="原創">原創角色</button><button class="mode-chip ${slot.mode === '動漫角色' ? 'active' : ''}" data-slot-mode="${index}" data-mode="動漫角色">動漫角色</button></div>${slot.mode === '動漫角色' && slot.detailed ? `<label>第一步：搜尋動漫<input data-anime-query="${index}" value="${esc(slot.animeQuery)}" placeholder="例如：To LOVE-Ru、Re:ZERO"></label><div class="character-results">${animeMatches.map(item => `<button class="character-result ${slot.animeTag === item.animeTag ? 'active' : ''}" data-anime="${index}:${esc(item.animeTag)}">${esc(item.animeZh)} · ${esc(item.animeEn)}<small>先選作品，再選角色</small></button>`).join('')}</div>${slot.animeTag ? `<label style="margin-top:10px">第二步：搜尋角色<input data-character-query="${index}" value="${esc(slot.query)}" placeholder="例如：Lala、拉拉"></label><div class="character-results">${matches.map(item => `<button class="character-result ${c?.id === item.id ? 'active' : ''}" data-character="${index}:${esc(item.id)}">${esc(item.characterZh)} · ${esc(item.characterEn)}<small>${esc(item.animeZh)} · ${esc(item.animeEn)}</small></button>`).join('')}</div>` : '<p class="wizard-note">請先選擇動漫作品，接著才會顯示該作品的角色。</p>'}<button class="ghost" data-open-character style="margin-top:10px">＋ 新增動漫／原創角色資料</button>${c ? `<p class="wizard-note">角色自帶標籤：${esc(c.traits.map(item => `${item.zh} / ${item.en}`).join('、'))}</p>` : ''}` : slot.detailed ? `<div class="wizard-fields"><label>作品／系列中文<input data-original-field="${index}:originalAnimeZh" value="${esc(slot.originalAnimeZh)}" placeholder="原創作品"></label><label>Anime / series English<input data-original-field="${index}:originalAnimeEn" value="${esc(slot.originalAnimeEn)}"></label><label>作品英文標籤<input data-original-field="${index}:originalAnimeTag" value="${esc(slot.originalAnimeTag)}" placeholder="original_series"></label><label>角色中文<input data-original-field="${index}:originalCharacterZh" value="${esc(slot.originalCharacterZh)}"></label><label>Character English<input data-original-field="${index}:originalCharacterEn" value="${esc(slot.originalCharacterEn)}"></label><label>角色英文標籤<input data-original-field="${index}:originalCharacterTag" value="${esc(slot.originalCharacterTag)}" placeholder="my_character"></label><label>特徵中文<textarea data-original-field="${index}:originalTraitsZh" rows="2" placeholder="粉紅頭髮, 呆毛, 綠眼睛">${esc(slot.originalTraitsZh)}</textarea></label><label>Traits English<textarea data-original-field="${index}:originalTraitsEn" rows="2" placeholder="pink hair, ahoge, green eyes">${esc(slot.originalTraitsEn)}</textarea></label></div>` : '<p class="wizard-note">此人物將只使用人物數量標籤，不加入作品、角色與外觀細節。</p>'}</article>`; }
function peopleStep() { return `<div class="wizard-controls"><label>人物數量（必填）<select data-people-count>${Array.from({ length: 10 }, (_, index) => index + 1).map(value => `<option value="${value}" ${state.peopleSlots.length === value ? 'selected' : ''}>${value} 人</option>`).join('')}</select></label><div class="wizard-note">先選人物數量，再為每位人物選擇性別與詳細資料；模型參數請在 AI 生成網站設定。</div></div>${nextButton('下一步：場景')}`; }
function charactersStep() { return `${remoteLookupStep()}${state.peopleSlots.map((slot, index) => peopleCharacterCard(slot, index)).join('')}${nextButton('完成角色設定')}`; }
function charactersStep() { return `${remoteLookupStep()}${state.peopleSlots.map((slot, index) => peopleCharacterCard(slot, index)).join('')}${nextButton('完成角色設定')}`; }
function tagsStep(groups) { return `${renderTagPicker(groups, 'wizard')}${nextButton()}`; }
function finalStep() { return `<div class="wizard-fields"><label>Amanatsu 品質前綴<textarea data-setting="preprompt" rows="2">${esc(state.preprompt)}</textarea></label><label>額外正向標籤<textarea data-setting="extra" rows="2" placeholder="可用中文或英文，以逗號或換行分隔">${esc(state.extra)}</textarea></label></div><label style="margin-top:12px">負面標籤（英文或中文）<textarea data-setting="negative" rows="4">${esc(state.negative)}</textarea></label>${negativeToolsMarkup()}<p class="wizard-note">自動髮長防衝突：長髮會在負面輸出加入 short hair；改選短髮後則加入 long hair。自動詞不會改寫上方可編輯欄位。</p><label class="switch-row"><input type="checkbox" data-setting="showAdult" ${state.showAdult ? 'checked' : ''}><span class="switch"></span><span><b>顯示 18+ 標籤分類</b><small>只建立成年角色內容，開啟後可在前面分類選取成人向標籤。</small></span></label><p class="wizard-note">所有英文輸出標籤會以英文句點結尾；負面標籤也會同步顯示中文翻譯。</p>`; }
function renderWizard() { $('#wizard').innerHTML = [stepCard(0, '人物數量', '先選人物數量與性別比例；模型參數請在 AI 生成網站設定', '①', peopleStep()), stepCard(1, '場景與畫面', '背景、時間、鏡頭與構圖', '⌂', tagsStep(['場景', '畫面'])), stepCard(2, '人物與角色資料', '先選動漫作品，再選該作品的角色', '♙', charactersStep()), stepCard(3, '角色特徵', '每位人物各自設定外觀、臉部、胸部與裸露', '✦', personTagsStep(['外觀特徵', '臉部特徵', '胸部', '裸露'], '以下標籤會分別套用到各人物，不會讓兩個人物共用。')), stepCard(4, '服裝與穿脫狀態', '先選服裝類型，再分開選顏色、蕾絲、材質與穿脫狀態', '◇', clothingStep()), stepCard(5, '表情', '每位人物各自設定表情', '☺', personTagsStep(['表情'], '請分別設定每位人物的表情。')), stepCard(6, '姿勢與 18+ 姿勢', '每位人物各自設定姿勢；不同人物可以使用不同姿勢', '♧', personTagsStep(['姿勢', '性行為', '性姿勢'], '請分別設定每位人物的基本姿勢、性行為與性姿勢。')), stepCard(7, '品質與負面標籤', '全圖共用的品質、額外與負面標籤', '✓', finalStep())].join(''); }

function personTagsStep(groups, instruction) { return `<p class="wizard-note">${instruction}</p>${state.peopleSlots.map((slot, index) => { const c = characterForSlot(slot); const title = c ? `${c.characterZh} · ${c.characterEn}` : `人物 ${index + 1}`; return `<article class="character-card"><div class="character-card-head"><b>人物 ${index + 1} · ${esc(title)}</b><span class="model-pill">${slot.detailed ? '本人物專屬設定' : '不需細節'}</span></div>${slot.detailed ? renderTagPicker(groups, `person-${index}`, index) : '<p class="wizard-note">此人物設定為不需細節，不加入這一類標籤。</p>'}</article>`; }).join('')}${nextButton()}`; }
function renderWizard() { $('#wizard').innerHTML = [stepCard(0, '人物數量與模型', '先選人物數量、性別比例與 Amanatsu 設定', '①', peopleStep()), stepCard(1, '場景與畫面', '背景、時間、鏡頭與構圖（全圖共用）', '⌂', tagsStep(['場景', '畫面'])), stepCard(2, '人物與角色資料', '先選動漫作品，再選該作品的角色', '♙', charactersStep()), stepCard(3, '角色特徵', '每位人物各自設定外觀、臉部、胸部與裸露', '✦', personTagsStep(['外觀特徵', '臉部特徵', '胸部', '裸露'], '以下標籤會分別套用到各人物，不會讓兩個人物共用。')), stepCard(4, '服裝與穿脫狀態', '先選服裝類型，再分開選顏色、蕾絲、材質與穿脫狀態', '◇', clothingStep()), stepCard(5, '表情', '每位人物各自設定表情', '☺', personTagsStep(['表情'], '請分別設定每位人物的表情。')), stepCard(6, '姿勢與 18+ 姿勢', '每位人物各自設定姿勢；不同人物可以使用不同姿勢', '♧', personTagsStep(['姿勢', '性行為', '性姿勢'], '請分別設定每位人物的基本姿勢、性行為與性姿勢。')), stepCard(7, '品質與負面標籤', '全圖共用的品質、額外與負面標籤', '✓', finalStep())].join(''); }
function wizardGroupLabel(group) { if (group === '褲子') return '下身／褲子'; if (group === '服裝') return '連身裙／整套服裝'; if (group === '服裝顏色') return '連身裝顏色'; return group; }
function renderTagPicker(groups, filterKey, personIndex = null) { const query = personIndex === null ? (state.wizardQuery || '') : (state.personQueries[personIndex] || ''); const currentGroup = groups.includes(state.wizardGroups[filterKey]) ? state.wizardGroups[filterKey] : groups[0]; state.wizardGroups[filterKey] = currentGroup; const filtered = allTags().filter(item => item.group === currentGroup && (state.showAdult || !item.adult) && (!query || `${item.zh} ${item.en}`.toLowerCase().includes(query.toLowerCase()))); const filters = `<div class="wizard-filter-row">${groups.map(group => `<button type="button" class="filter ${group === currentGroup ? 'active' : ''}" data-wizard-group="${esc(filterKey)}|${esc(group)}">${esc(wizardGroupLabel(group))}</button>`).join('')}</div>`; return `${filters}<div class="search-line"><span>⌕</span><input data-wizard-search="${filterKey}" data-person-search="${personIndex === null ? '' : personIndex}" value="${esc(query)}" placeholder="搜尋目前分類的中文或英文標籤…"></div><div class="wizard-tags">${filtered.length ? filtered.map(item => tagButton(item, personIndex)).join('') : '<div class="empty">目前分類沒有符合的標籤，可新增自訂標籤。</div>'}</div>`; }
function clothingStep() { const styles = ['上衣', '褲子', '裙子', '內衣', '胸罩', '內褲', '襪子', '鞋子', '服裝', '配件']; const details = ['服裝風格', '上衣風格', '下身風格', '上衣顏色', '下身顏色', '服裝顏色', '配件顏色', '服裝細節', '服裝材質', '穿脫狀態']; return `<p class="wizard-note">服裝類型、風格與顏色／細節分開選擇：配件已獨立分類，配件顏色也可單獨選擇；上衣顏色與下身顏色可分開設定。連身裝等同上衣與下身，但仍可搭配內搭。</p>${state.peopleSlots.map((slot, index) => { const c = characterForSlot(slot); const title = c ? `${c.characterZh} · ${c.characterEn}` : `人物 ${index + 1}`; return `<article class="character-card"><div class="character-card-head"><b>人物 ${index + 1} · ${esc(title)}</b><span class="model-pill">${slot.detailed ? '本人物專屬設定' : '不需細節'}</span>${slot.detailed ? `<button type="button" class="icon-button" data-random-clothing="${index}" title="隨機服裝穿搭">🎲 隨機穿搭</button>` : ''}</div>${slot.detailed ? `<b>服裝類型與樣式</b>${renderTagPicker(styles, `clothing-style-${index}`, index)}<hr><b>風格、顏色與服裝細節（可多選）</b>${renderTagPicker(details, `clothing-detail-${index}`, index)}` : '<p class="wizard-note">此人物設定為不需細節，不加入服裝標籤。</p>'}</article>`; }).join('')}${nextButton('下一步：表情')}`; }
function clothingStep() {
  const styles = ['上衣', '褲子', '裙子', '內衣', '胸罩', '內褲', '襪子', '鞋子', '服裝', '配件'];
  const details = ['服裝風格', '上衣風格', '下身風格', '上衣顏色', '下身顏色', '服裝顏色', '配件顏色', '服裝細節', '服裝材質', '穿脫狀態'];
  return `<p class="wizard-note">服裝類型、風格與顏色／細節分開選擇。配件已獨立分類，配件顏色也可單獨選擇；只有選擇連身裝後才會顯示連身裝顏色，連身裝仍可搭配內搭。</p>${state.peopleSlots.map((slot, index) => { const c = characterForSlot(slot); const title = c ? `${c.characterZh} · ${c.characterEn}` : `人物 ${index + 1}`; const hasOnePiece = selectedTags(index).some(item => ['服裝', '服裝風格'].includes(item.group)); const visibleDetails = hasOnePiece ? details : details.filter(group => group !== '服裝顏色'); return `<article class="character-card"><div class="character-card-head"><b>人物 ${index + 1} · ${esc(title)}</b><span class="model-pill">${slot.detailed ? '本人物專屬設定' : '不需細節'}</span>${slot.detailed ? `<button type="button" class="icon-button" data-random-clothing="${index}" title="隨機服裝穿搭">🎲 隨機穿搭</button>` : ''}</div>${slot.detailed ? `<b>服裝類型與樣式</b>${renderTagPicker(styles, `clothing-style-${index}`, index)}<hr><b>風格、顏色與服裝細節（可多選）</b>${renderTagPicker(visibleDetails, `clothing-detail-${index}`, index)}` : '<p class="wizard-note">此人物設定為不需細節，不加入服裝標籤。</p>'}</article>`; }).join('')}${nextButton('下一步：表情')}`;
}

function randomClothingTag(groups) { const seen = new Set(); const candidates = allTags().filter(item => groups.includes(item.group) && (state.showAdult || !item.adult) && !seen.has(`${item.group}|${item.en}`) && seen.add(`${item.group}|${item.en}`)); return candidates.length ? candidates[Math.floor(Math.random() * candidates.length)] : null; }
function randomClothing(personIndex) { const ids = personTagSet(personIndex); const clothingGroups = new Set(['上衣', '褲子', '裙子', '內衣', '胸罩', '內褲', '襪子', '鞋子', '服裝', '配件', '配件顏色', '服裝風格', '上衣風格', '下身風格', '上衣顏色', '下身顏色', '服裝顏色', '服裝細節', '服裝材質', '穿脫狀態']); allTags().forEach(item => { if (ids.has(item.id) && clothingGroups.has(item.group)) ids.delete(item.id); }); const add = item => { if (item) ids.add(item.id); }; if (Math.random() < .5) { add(randomClothingTag(['服裝', '服裝風格'])); add(randomClothingTag(['服裝顏色'])); } else { add(randomClothingTag(['上衣'])); add(randomClothingTag(['褲子', '裙子'])); if (Math.random() < .6) add(randomClothingTag(['上衣風格'])); if (Math.random() < .6) add(randomClothingTag(['下身風格'])); if (Math.random() < .6) add(randomClothingTag(['上衣顏色'])); if (Math.random() < .6) add(randomClothingTag(['下身顏色'])); } if (Math.random() < .5) add(randomClothingTag(['胸罩'])); if (Math.random() < .5) add(randomClothingTag(['內衣'])); if (Math.random() < .5) add(randomClothingTag(['內褲'])); if (Math.random() < .7) add(randomClothingTag(['襪子'])); if (Math.random() < .8) add(randomClothingTag(['鞋子'])); if (Math.random() < .6) add(randomClothingTag(['穿脫狀態'])); if (Math.random() < .7) add(randomClothingTag(['服裝材質'])); const detailCandidates = allTags().filter(item => item.group === '服裝細節' && (state.showAdult || !item.adult)); detailCandidates.sort(() => Math.random() - .5).slice(0, 1 + Math.floor(Math.random() * 3)).forEach(item => ids.add(item.id)); const accessoryCandidates = allTags().filter(item => item.group === '配件' && (state.showAdult || !item.adult)); accessoryCandidates.sort(() => Math.random() - .5).slice(0, Math.floor(Math.random() * 3)).forEach(item => ids.add(item.id)); if (accessoryCandidates.length && Math.random() < .8) add(randomClothingTag(['配件顏色'])); savePersonTagSet(personIndex, ids); render(); toast(`人物 ${personIndex + 1} 已隨機生成服裝穿搭`); }
function renderFilters() { const groups = ['全部', ...new Set(allTags().map(item => item.group))]; $('#group-filters').innerHTML = groups.map(group => `<button class="filter ${state.group === group ? 'active' : ''}" data-group="${esc(group)}">${esc(group)}</button>`).join(''); }
function renderTags() { const query = state.query.toLowerCase(); const items = allTags().filter(item => (state.group === '全部' || item.group === state.group) && (state.showAdult || !item.adult) && (!query || `${item.zh} ${item.en}`.toLowerCase().includes(query))); $('#tag-list').innerHTML = items.length ? items.map(item => tagButton(item)).join('') : '<div class="empty">沒有符合的標籤，可使用搜尋或新增自訂標籤。</div>'; }
function renderPresets() { $('#preset-list').innerHTML = state.presets.length ? state.presets.map((preset, index) => `<div class="preset"><span class="preset-number">${index + 1}</span><span class="preset-info"><b>${esc(preset.name)}</b><small>${(preset.payload.selected || []).length} 個標籤 · ${esc(preset.payload.gender || '')} ${preset.payload.count || ''} 人</small></span><span class="preset-actions"><button class="icon-button" data-load="${index}">載入</button><button class="icon-button" data-delete="${index}">刪除</button></span></div>`).join('') : '<div class="preset-empty">尚未儲存組合；完成後可使用輸出區的儲存按鈕。</div>'; }
function renderOutput() { $('#positive-output').value = positiveText(); $('#chinese-output').value = chineseText(); $('#negative-output').value = negativeText(); $('#negative-chinese').value = negativeChinese(); $('#selected-summary').textContent = `已選 ${selectedTags().length + personSelectedCount()} 個資料庫標籤 · 英文每個標籤以句點結尾`; $('#order-summary').textContent = `${personSummary()} → 每位人物的角色特徵／服裝／表情／姿勢 → 場景／畫面`; }
function clearAllTags() { if (!window.confirm('確定清除目前組合的所有標籤嗎？\n\n正向標籤、人物角色、人物細節、額外文字與提示前綴會清除；負面標籤會恢復預設內容，之後仍可繼續新增。\n\n自訂標籤、角色資料、已儲存組合與版本記錄不會被刪除。')) return; state.selected = new Set(); state.personSelected = {}; state.personQueries = {}; state.wizardGroups = {}; state.peopleSlots = [newSlot()]; state.peopleSlots[0].detailed = false; state.count = 1; state.gender = '女性'; state.step = 0; state.group = '全部'; state.query = ''; state.wizardQuery = ''; state.extra = ''; state.negative = defaultNegative; state.preprompt = ''; render(); toast('目前組合已清除，負面標籤已恢復預設'); }
function syncControls() { const controls = { '#model': state.model, '#gender': state.gender, '#people-count': String(state.peopleSlots.length), '#sampler': state.sampler, '#steps': String(state.steps), '#cfg': state.cfg, '#clip-skip': state.clipSkip, '#preprompt': state.preprompt, '#extra-positive': state.extra, '#negative': state.negative, '#search': state.query }; Object.entries(controls).forEach(([selector, value]) => { const element = $(selector); if (element) element.value = value; }); const adult = $('#show-adult'); if (adult) adult.checked = state.showAdult; }
function scrollToStep(index) { requestAnimationFrame(() => { const target = document.querySelectorAll('.wizard-step')[index]; if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start' }); }); }
function renderWizardKeepingFocus(selector, value) { renderWizard(); const field = document.querySelector(selector); if (field) { field.focus(); field.setSelectionRange(String(value).length, String(value).length); } }
function render() { renderWizard(); renderFilters(); renderTags(); renderPresets(); renderOutput(); syncControls(); const negativeTools = $('#negative-tools'); if (negativeTools) negativeTools.innerHTML = negativeToolsMarkup(); persist(); }
async function copyText(value, label) { try { await navigator.clipboard.writeText(value); } catch { const area = document.createElement('textarea'); area.value = value; document.body.append(area); area.select(); document.execCommand('copy'); area.remove(); } toast(`${label}已複製`); }
function downloadBackup() { const blob = new Blob([JSON.stringify(snapshot(), null, 2)], { type: 'application/json' }); const link = document.createElement('a'); link.href = URL.createObjectURL(blob); link.download = 'betterwaifu-prompt-backup.json'; link.click(); URL.revokeObjectURL(link.href); toast('備份已匯出'); }
function importBackup(file) { const reader = new FileReader(); reader.onload = () => { try { localStorage.setItem(STORAGE_KEY, reader.result); location.reload(); } catch { toast('JSON 備份格式無法讀取'); } }; reader.readAsText(file); }
function groupOrder(group) { if (group === '場景') return 6; if (group === '表情') return 3; if (group === '姿勢') return 4; if (['動作', '物件'].includes(group)) return 4; if (['性行為', '性姿勢'].includes(group)) return 5; if (['服裝', '髮型', '上衣', '褲子', '裙子', '內衣', '胸罩', '內褲', '襪子', '鞋子', '配件', '配件顏色', '服裝風格', '上衣風格', '下身風格', '上衣顏色', '下身顏色', '服裝顏色', '服裝細節', '服裝材質', '穿脫狀態'].includes(group)) return 2; return 1; }

document.addEventListener('click', event => {
  if (event.target.closest('[data-auto-search-anime]')) { searchRemoteAnime(); return; }
  const autoAnime = event.target.closest('[data-auto-anime]'); if (autoAnime) { const anime = lookupState.anime.find(item => String(item.id) === autoAnime.dataset.autoAnime); if (anime) loadRemoteCharacters(anime); return; }
  if (event.target.closest('[data-auto-import-all]')) { importRemoteCharacters(); return; }
  const negativeTag = event.target.closest('[data-negative-tag]'); if (negativeTag) { toggleNegativeTag(negativeTag.dataset.negativeTag, negativeTag.dataset.negativeZh || negativeTag.dataset.negativeTag); return; }
  if (event.target.closest('[data-add-negative]')) { addNegativeTag(); return; }
  if (event.target.closest('[data-reset-negative]')) { state.negative = defaultNegative; render(); toast('負面標籤已恢復預設'); return; }
  const randomClothingButton = event.target.closest('[data-random-clothing]'); if (randomClothingButton) { randomClothing(Number(randomClothingButton.dataset.randomClothing)); return; }
  const tagButton = event.target.closest('[data-tag]'); if (tagButton) { const rawPerson = tagButton.dataset.personTag; const personIndex = rawPerson === '' ? null : Number(rawPerson); const item = allTags().find(candidate => candidate.id === tagButton.dataset.tag); if (personIndex !== null && item?.group === '服裝顏色' && !selectedTags(personIndex).some(candidate => ['服裝', '服裝風格'].includes(candidate.group))) { toast('請先選擇連身裝，才可以設定連身裝顏色'); return; } toggleTag(tagButton.dataset.tag, personIndex); return; }
  const wizardGroupButton = event.target.closest('[data-wizard-group]'); if (wizardGroupButton) { const value = wizardGroupButton.dataset.wizardGroup || ''; const separator = value.indexOf('|'); if (separator >= 0) { state.wizardGroups[value.slice(0, separator)] = value.slice(separator + 1); render(); } return; }
  const stepButton = event.target.closest('[data-step]'); if (stepButton) { state.step = Number(stepButton.dataset.step); render(); scrollToStep(state.step); return; }
  const next = event.target.closest('[data-next]'); if (next) { if (state.step === 1 && !characterComplete()) { toast('請完成每位需要詳細設定人物的角色資料，或關閉詳細角色資料。'); return; } state.step = Math.min(6, state.step + 1); render(); scrollToStep(state.step); return; }
  const groupButton = event.target.closest('[data-group]'); if (groupButton) { state.group = groupButton.dataset.group; render(); return; }
  const characterButton = event.target.closest('[data-character]'); if (characterButton) { const [index, id] = characterButton.dataset.character.split(':'); chooseCharacter(Number(index), id); return; }
  const animeButton = event.target.closest('[data-anime]'); if (animeButton) { const [index, animeTag] = animeButton.dataset.anime.split(':'); chooseAnime(Number(index), animeTag); return; }
  const modeButton = event.target.closest('[data-slot-mode]'); if (modeButton) { state.peopleSlots[Number(modeButton.dataset.slotMode)].mode = modeButton.dataset.mode; state.peopleSlots[Number(modeButton.dataset.slotMode)].characterId = ''; render(); return; }
  const openCharacter = event.target.closest('[data-open-character]'); if (openCharacter) { $('#character-dialog').showModal(); return; }
  const loadButton = event.target.closest('[data-load]'); if (loadButton) { const preset = state.presets[Number(loadButton.dataset.load)]; if (preset) { Object.assign(state, { ...preset.payload, selected: new Set(preset.payload.selected || []), peopleSlots: (preset.payload.peopleSlots || [newSlot()]).map(slot => ({ ...newSlot(), ...slot })) }); render(); toast(`已載入「${preset.name}」`); } return; }
  const deleteButton = event.target.closest('[data-delete]'); if (deleteButton) { state.presets.splice(Number(deleteButton.dataset.delete), 1); render(); toast('組合已刪除'); }
});

document.addEventListener('input', event => {
  const autoAnimeQuery = event.target.closest('[data-auto-anime-query]'); if (autoAnimeQuery) { lookupState.query = autoAnimeQuery.value; return; }
  const personSearch = event.target.closest('[data-person-search]'); if (personSearch && personSearch.dataset.personSearch !== '') { state.personQueries[personSearch.dataset.personSearch] = personSearch.value; renderWizardKeepingFocus(`[data-person-search="${personSearch.dataset.personSearch}"]`, personSearch.value); return; }
  const wizardSearch = event.target.closest('[data-wizard-search]'); if (wizardSearch) { state.wizardQuery = wizardSearch.value; renderWizardKeepingFocus(`[data-wizard-search="${wizardSearch.dataset.wizardSearch}"]`, wizardSearch.value); return; }
  const animeSearch = event.target.closest('[data-anime-query]'); if (animeSearch) { const index = Number(animeSearch.dataset.animeQuery); state.peopleSlots[index].animeQuery = animeSearch.value; renderWizardKeepingFocus(`[data-anime-query="${index}"]`, animeSearch.value); return; }
  const characterSearch = event.target.closest('[data-character-query]'); if (characterSearch) { const index = Number(characterSearch.dataset.characterQuery); state.peopleSlots[index].query = characterSearch.value; renderWizardKeepingFocus(`[data-character-query="${index}"]`, characterSearch.value); return; }
  const original = event.target.closest('[data-original-field]'); if (original) { const [index, field] = original.dataset.originalField.split(':'); state.peopleSlots[Number(index)][field] = original.value; persist(); renderOutput(); return; }
  const setting = event.target.closest('[data-setting]'); if (setting && ['preprompt', 'extra', 'negative'].includes(setting.dataset.setting)) { state[setting.dataset.setting === 'preprompt' ? 'preprompt' : setting.dataset.setting === 'extra' ? 'extra' : 'negative'] = setting.value; persist(); renderOutput(); }
  if (event.target.id === 'search') { state.query = event.target.value; render(); }
});
document.addEventListener('change', event => {
  const autoTarget = event.target.closest('[data-auto-target]'); if (autoTarget) { lookupState.target = Number(autoTarget.value); render(); return; }
  const count = event.target.closest('[data-people-count]'); if (count) { setPeopleCount(count.value); render(); return; }
  const gender = event.target.closest('[data-slot-gender]'); if (gender) { state.peopleSlots[Number(gender.dataset.slotGender)].gender = gender.value.split('／')[0]; state.gender = state.peopleSlots[0].gender; persist(); renderOutput(); return; }
  const detailed = event.target.closest('[data-slot-detailed]'); if (detailed) { state.peopleSlots[Number(detailed.dataset.slotDetailed)].detailed = detailed.checked; persist(); render(); return; }
  const setting = event.target.closest('[data-setting]'); if (setting) { const key = setting.dataset.setting; if (key === 'showAdult') state.showAdult = setting.checked; else if (key === 'steps') state.steps = Number(setting.value); else state[key] = setting.value; persist(); render(); }
});

$('#search').addEventListener('input', event => { state.query = event.target.value; render(); });
$('#clear-search').addEventListener('click', () => { state.query = ''; render(); });
$('#gender')?.addEventListener('change', event => { state.peopleSlots.forEach(slot => { slot.gender = event.target.value; }); state.gender = event.target.value; render(); });
$('#people-count')?.addEventListener('change', event => { setPeopleCount(event.target.value); render(); });
$('#show-adult').addEventListener('change', event => { state.showAdult = event.target.checked; render(); });
$('#preprompt').addEventListener('input', event => { state.preprompt = event.target.value; renderOutput(); persist(); });
$('#extra-positive').addEventListener('input', event => { state.extra = event.target.value; renderOutput(); persist(); });
$('#negative').addEventListener('input', event => { state.negative = event.target.value; renderOutput(); persist(); });
$('#copy-positive').addEventListener('click', () => copyText(positiveText(), '正向英文標籤'));
$('#sticky-copy-positive').addEventListener('click', () => copyText(positiveText(), '正向英文標籤'));
$('#sticky-copy-negative').addEventListener('click', () => copyText(negativeText(), '負面英文標籤'));
$('#save-preset').addEventListener('click', () => { const name = window.prompt('組合名稱', 'Amanatsu 組合'); if (!name?.trim()) return; state.presets.unshift({ name: name.trim(), payload: snapshot() }); render(); toast('組合已儲存'); });
$('#clear-all').addEventListener('click', clearAllTags);
$('#export-btn').addEventListener('click', downloadBackup);
$('#import-btn').addEventListener('click', () => $('#import-file').click());
$('#import-file').addEventListener('change', event => { if (event.target.files?.[0]) importBackup(event.target.files[0]); event.target.value = ''; });
$('#add-tag-btn').addEventListener('click', () => { $('#custom-zh').value = ''; $('#custom-en').value = ''; $('#custom-group').value = '自訂特徵'; $('#custom-dialog').showModal(); });
$('#custom-form').addEventListener('submit', event => { event.preventDefault(); const zh = $('#custom-zh').value.trim(); const en = clean($('#custom-en').value); if (!zh || !en) return; const group = $('#custom-group').value; const item = { id: `custom_${Date.now()}`, group, zh, en, order: groupOrder(group), adult: false, conflictGroup: '', builtIn: false }; state.customTags.push(item); const personalGroup = ['自訂角色', '自訂特徵', '髮型', '上衣', '褲子', '裙子', '內衣', '胸罩', '內褲', '襪子', '鞋子', '服裝', '配件', '配件顏色', '服裝風格', '上衣風格', '下身風格', '上衣顏色', '下身顏色', '服裝顏色', '服裝細節', '服裝材質', '穿脫狀態', '表情', '姿勢', '動作', '物件'].includes(group); if (personalGroup) { const ids = personTagSet(0); ids.add(item.id); savePersonTagSet(0, ids); } else state.selected.add(item.id); $('#custom-dialog').close(); render(); toast('自訂標籤已加入'); });
$('#character-form').addEventListener('submit', event => { event.preventDefault(); const animeZh = $('#character-anime-zh').value.trim(), animeEn = $('#character-anime-en').value.trim(), characterZh = $('#character-zh').value.trim(), characterEn = $('#character-en').value.trim(); if (!animeZh || !animeEn || !characterZh || !characterEn) return; const c = { id: `custom_character_${Date.now()}`, animeZh, animeEn, animeTag: clean($('#character-anime-tag').value) || slug(animeEn), characterZh, characterEn, characterTag: clean($('#character-tag').value) || slug(characterEn), traits: splitTags($('#character-traits-en').value).map((en, index) => ({ en, zh: splitTags($('#character-traits-zh').value)[index] || en })) }; state.customCharacters.push(c); const emptySlot = state.peopleSlots.find(slot => slot.mode === '動漫角色' && !slot.characterId); if (emptySlot) { emptySlot.animeTag = c.animeTag; emptySlot.animeQuery = ''; emptySlot.characterId = c.id; } state.recentCharacterIds = [c.id, ...state.recentCharacterIds].slice(0, 10); $('#character-dialog').close(); render(); toast('角色資料已儲存'); });

function charactersStep() {
  const count = state.peopleSlots.length;
  return `<div class="people-count-control"><b>人物資料數量：${count}／10</b><span><button type="button" class="icon-button" data-person-adjust="-1" ${count <= 1 ? 'disabled' : ''}>−</button><button type="button" class="icon-button" data-person-adjust="1" ${count >= 10 ? 'disabled' : ''}>＋</button></span></div><p class="wizard-note">標籤中的人物數量會依這裡的角色資料卡自動計算；每位人物可分別指定性別、詳細角色或不需細節。</p>${remoteLookupStep()}${state.peopleSlots.map((slot, index) => peopleCharacterCard(slot, index)).join('')}${nextButton('完成角色設定：下一步特徵')}`;
}

function renderWizard() {
  $('#wizard').innerHTML = [
    stepCard(0, '場景與畫面', '背景、時間、鏡頭與構圖', '⌂', tagsStep(['場景', '畫面'])),
    stepCard(1, '人物與角色資料', '在角色資料卡調整人物數量與性別', '♙', charactersStep()),
    stepCard(2, '角色特徵', '每位人物各自設定外觀、髮型、臉部、胸部與裸露', '✦', personTagsStep(['外觀特徵', '髮型', '臉部特徵', '胸部', '裸露'], '以下標籤會分別套用到各人物，不會讓兩個人物共用。')),
    stepCard(3, '服裝與穿脫狀態', '先選服裝類型，再分開選顏色、蕾絲、材質與穿脫狀態', '◇', clothingStep()),
    stepCard(4, '表情', '每位人物各自設定表情', '☺', personTagsStep(['表情'], '請分別設定每位人物的表情。')),
    stepCard(5, '姿勢、動作與物件', '每位人物可設定基本姿勢、運動動作與手持物件', '♧', personTagsStep(['姿勢', '動作', '物件', '性行為', '性姿勢'], '請分別設定每位人物的基本姿勢、運動動作、常見物件與 18+ 姿勢。')),
    stepCard(6, '品質與負面標籤', '全圖共用的品質、額外與負面標籤', '✓', finalStep()),
  ].join('');
}

document.addEventListener('click', event => {
  const adjust = event.target.closest('[data-person-adjust]');
  if (!adjust) return;
  setPeopleCount(state.peopleSlots.length + Number(adjust.dataset.personAdjust));
  render();
  scrollToStep(1);
});

restore(); state.step = Math.min(6, Math.max(0, Number(state.step) || 0)); render();
renderVersionInfo();
checkForVersionUpdate();
$('#version-btn').addEventListener('click', () => $('#version-dialog').showModal());
$('#version-close').addEventListener('click', () => $('#version-dialog').close());
$('#version-ok').addEventListener('click', () => $('#version-dialog').close());
if ('serviceWorker' in navigator && location.protocol !== 'file:') navigator.serviceWorker.register('./sw.js').catch(() => {});
