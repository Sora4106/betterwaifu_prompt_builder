/* BetterWaifu Prompt Atelier — dependency-free browser version. */
const STORAGE_KEY = 'betterwaifu_prompt_builder_state_v1';
const tag = (id, group, zh, en, order, adult = false) => ({ id, group, zh, en, order, adult, builtIn: true });

const seedTags = [
  tag('role_girl','角色類型','女性角色','1girl',0), tag('role_boy','角色類型','男性角色','1boy',0), tag('role_person','角色類型','人物','1person',0), tag('role_original','角色類型','原創角色','original',0), tag('role_elf','角色類型','精靈','elf',0), tag('role_catgirl','角色類型','貓娘','catgirl',0), tag('role_bunny','角色類型','兔女郎角色','bunny girl',0), tag('role_witch','角色類型','魔女','witch',0),
  tag('trait_long_hair','外觀特徵','長髮','long hair',1), tag('trait_short_hair','外觀特徵','短髮','short hair',1), tag('trait_hair_between_eyes','外觀特徵','瀏海遮眼','hair between eyes',1), tag('trait_blonde','外觀特徵','金髮','blonde hair',1), tag('trait_black','外觀特徵','黑髮','black hair',1), tag('trait_silver','外觀特徵','銀髮','silver hair',1), tag('trait_blue','外觀特徵','藍髮','blue hair',1), tag('trait_red','外觀特徵','紅髮','red hair',1), tag('trait_pink','外觀特徵','粉紅髮','pink hair',1), tag('trait_blue_eyes','外觀特徵','藍眼睛','blue eyes',1), tag('trait_green_eyes','外觀特徵','綠眼睛','green eyes',1), tag('trait_red_eyes','外觀特徵','紅眼睛','red eyes',1), tag('trait_purple_eyes','外觀特徵','紫眼睛','purple eyes',1), tag('trait_tall','外觀特徵','高挑身材','tall',1), tag('trait_curvy','外觀特徵','曲線身材','curvy',1), tag('trait_slim','外觀特徵','纖細身材','slim',1), tag('trait_mature','外觀特徵','成熟外貌（成年）','mature female',1), tag('trait_makeup','外觀特徵','化妝','makeup',1), tag('trait_earrings','外觀特徵','耳環','earrings',1), tag('trait_tattoo','外觀特徵','刺青','tattoo',1),
  tag('top_tshirt','上衣','T恤','t-shirt',2), tag('top_shirt','上衣','襯衫','shirt',2), tag('top_sweater','上衣','毛衣','sweater',2), tag('top_hoodie','上衣','連帽衫','hoodie',2), tag('top_jacket','上衣','夾克','jacket',2), tag('top_crop','上衣','短版上衣','crop top',2), tag('top_offshoulder','上衣','露肩上衣','off-shoulder shirt',2), tag('top_blouse','上衣','女式襯衫','blouse',2),
  tag('bottom_jeans','褲子','牛仔褲','jeans',2), tag('bottom_shorts','褲子','短褲','shorts',2), tag('bottom_hotpants','褲子','熱褲','hot pants',2), tag('bottom_trousers','褲子','長褲','trousers',2), tag('bottom_leggings','褲子','內搭褲','leggings',2), tag('skirt','裙子','裙子','skirt',2), tag('miniskirt','裙子','迷你裙','miniskirt',2), tag('pleated_skirt','裙子','百褶裙','pleated skirt',2),
  tag('dress','服裝','洋裝','dress',2), tag('sundress','服裝','夏日洋裝','sundress',2), tag('uniform','服裝','校服','school uniform',2), tag('suit','服裝','商務套裝','business suit',2), tag('kimono','服裝','和服','kimono',2), tag('apron','服裝','圍裙','apron',2), tag('swimsuit','服裝','泳裝','swimsuit',2), tag('bikini','服裝','比基尼','bikini',2),
  tag('bra','胸罩','胸罩','bra',2,true), tag('sports_bra','胸罩','運動胸罩','sports bra',2), tag('lace_bra','胸罩','蕾絲胸罩','lace bra',2,true), tag('panties','內褲','內褲','panties',2,true), tag('highleg_panties','內褲','高衩內褲','highleg panties',2,true), tag('thong','內褲','丁字褲','thong',2,true),
  tag('socks','襪子','短襪','socks',2), tag('kneehighs','襪子','膝上襪','kneehighs',2), tag('thighhighs','襪子','大腿襪','thighhighs',2), tag('pantyhose','襪子','連褲襪','pantyhose',2), tag('fishnet','襪子','網襪','fishnet legwear',2), tag('sneakers','鞋子','運動鞋','sneakers',2), tag('boots','鞋子','靴子','boots',2), tag('heels','鞋子','高跟鞋','high heels',2), tag('sandals','鞋子','涼鞋','sandals',2), tag('gloves','配件','手套','gloves',2), tag('ribbon','配件','蝴蝶結','hair ribbon',2), tag('choker','配件','頸圈','choker',2), tag('glasses','配件','眼鏡','glasses',2),
  tag('smile','表情','微笑','smile',3), tag('grin','表情','咧嘴笑','grin',3), tag('open_mouth','表情','張嘴','open mouth',3), tag('blush','表情','臉紅','blush',3), tag('looking','表情','看向觀眾','looking at viewer',3), tag('closed_eyes','表情','閉眼','closed eyes',3), tag('wink','表情','眨眼','wink',3), tag('tears','表情','眼淚','tears',3), tag('surprised','表情','驚訝','surprised',3), tag('embarrassed','表情','害羞','embarrassed',3), tag('serious','表情','嚴肅','serious',3), tag('angry','表情','生氣','angry',3), tag('ahegao','表情','情慾表情（成年角色）','ahegao',3,true), tag('orgasm_face','表情','高潮表情（成年角色）','orgasm',3,true),
  tag('standing','姿勢','站立','standing',4), tag('sitting','姿勢','坐著','sitting',4), tag('kneeling','姿勢','跪姿','kneeling',4), tag('lying','姿勢','躺著','lying',4), tag('lying_side','姿勢','側躺','lying on side',4), tag('lying_back','姿勢','仰躺','lying on back',4), tag('squatting','姿勢','蹲姿','squatting',4), tag('arms_up','姿勢','雙手舉起','arms up',4), tag('hand_on_hip','姿勢','手放腰上','hand on hip',4), tag('leaning','姿勢','倚靠','leaning',4), tag('bent_over','姿勢','彎腰（成年角色）','bent over',4,true), tag('presenting','姿勢','展示姿勢（成年角色）','presenting',4,true), tag('ass_up','姿勢','臀部抬起（成年角色）','ass up',4,true), tag('from_behind','姿勢','從後方視角','from behind',4), tag('selfie','姿勢','自拍姿勢','selfie',4),
  tag('flat_chest','胸部','平胸','flat chest',5), tag('small_breasts','胸部','小胸','small breasts',5), tag('medium_breasts','胸部','中等胸部','medium breasts',5), tag('large_breasts','胸部','大胸','large breasts',5), tag('huge_breasts','胸部','巨乳','huge breasts',5,true), tag('breasts','胸部','胸部可見','breasts',5,true), tag('cleavage','胸部','乳溝','cleavage',5,true), tag('nipples','胸部','乳頭可見','nipples',5,true), tag('breast_press','胸部','胸部擠壓','breast press',5,true), tag('groping','胸部','撫摸胸部','groping',5,true),
  tag('nude','裸露','裸體','nude',6,true), tag('topless','裸露','上空','topless',6,true), tag('bottomless','裸露','下空','bottomless',6,true), tag('bare_shoulders','裸露','裸肩','bare shoulders',6), tag('bare_legs','裸露','裸腿','bare legs',6), tag('barefoot','裸露','赤腳','barefoot',6), tag('midriff','裸露','露腰','midriff',6), tag('covering_breasts','裸露','遮住胸部','covering breasts',6,true), tag('covering_crotch','裸露','遮住胯部','covering crotch',6,true),
  tag('sex','性行為','性行為（成年角色）','sex',7,true), tag('vaginal','性行為','陰道性交（成年角色）','vaginal',7,true), tag('anal','性行為','肛交（成年角色）','anal',7,true), tag('oral','性行為','口交（成年角色）','oral',7,true), tag('blowjob','性行為','口交行為（成年角色）','blowjob',7,true), tag('handjob','性行為','手交（成年角色）','handjob',7,true), tag('fingering','性行為','手指刺激（成年角色）','fingering',7,true), tag('masturbation','性行為','自慰（成年角色）','masturbation',7,true), tag('kissing','性行為','接吻','kissing',7), tag('grinding','性行為','磨蹭（成年角色）','grinding',7,true), tag('bondage','性行為','束縛（成年角色）','bondage',7,true), tag('bdsm','性行為','BDSM（成年角色）','bdsm',7,true), tag('cum','性行為','體液（成年角色）','cum',7,true),
  tag('missionary','性姿勢','傳教士體位（成年角色）','missionary',8,true), tag('cowgirl','性姿勢','女上位（成年角色）','cowgirl position',8,true), tag('reverse_cowgirl','性姿勢','背向女上位（成年角色）','reverse cowgirl',8,true), tag('doggystyle','性姿勢','後入式（成年角色）','doggystyle',8,true), tag('standing_sex','性姿勢','站立性交（成年角色）','standing sex',8,true), tag('riding','性姿勢','騎乘（成年角色）','riding',8,true), tag('sixty_nine','性姿勢','六九式（成年角色）','sixty-nine',8,true), tag('group_sex','性姿勢','多人性行為（成年角色）','group sex',8,true),
  tag('bedroom','場景','臥室','bedroom',9), tag('bathroom','場景','浴室','bathroom',9), tag('classroom','場景','教室','classroom',9), tag('beach','場景','海灘','beach',9), tag('cherry_blossoms','場景','櫻花樹下','cherry blossoms',9), tag('night','場景','夜晚','night',9), tag('sunset','場景','日落','sunset',9), tag('simple_background','場景','簡單背景','simple background',9),
  tag('portrait','畫面','肖像構圖','portrait',10), tag('full_body','畫面','全身','full body',10), tag('upper_body','畫面','上半身','upper body',10), tag('closeup','畫面','特寫','close-up',10), tag('cowboy_shot','畫面','膝上構圖','cowboy shot',10), tag('from_above','畫面','俯視','from above',10), tag('from_below','畫面','仰視','from below',10), tag('pov','畫面','第一人稱視角','pov',10),
  tag('masterpiece','品質','傑作','masterpiece',11), tag('best_quality','品質','最佳品質','best quality',11), tag('newest','品質','最新風格','newest',11), tag('absurdres','品質','超高解析','absurdres',11), tag('highres','品質','高解析','highres',11), tag('general','品質','一般安全評級','general',11), tag('detailed','品質','高度細節','highly detailed',11), tag('anatomically_correct','品質','解剖結構正確','anatomically correct',11), tag('proper_proportions','品質','比例正確','proper proportions',11), tag('clear_composition','品質','清晰構圖','clear composition',11), tag('professional_lighting','品質','專業打光','professional lighting',11), tag('cinematic_light','品質','電影感光線','cinematic light',11), tag('soft_shadows','品質','柔和陰影','soft shadows',11), tag('detailed_environment','品質','細節環境','detailed environment',11), tag('anime_style','品質','動漫風格','anime style',11)
];

const state = {
  selected: new Set(), customTags: [], presets: [], group: '全部', query: '',
  gender: '女性', count: 1, model: 'Amanatsu 1.1', sampler: 'Euler a', steps: 28, cfg: '5.0', clipSkip: '2', showAdult: false,
  preprompt: 'masterpiece, best quality, newest, absurdres, highres', extra: '',
  negative: 'lowres, worst quality, bad quality, bad anatomy, bad hands, extra digits, multiple views, fewer digits, extra limbs, missing fingers, deformed, text, error, jpeg artifacts, watermark, unfinished, displeasing, signature, username, scan artifacts'
};
const $ = selector => document.querySelector(selector);
const allTags = () => [...seedTags, ...state.customTags];
const esc = value => String(value ?? '').replace(/[&<>'"]/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;',"'":'&#39;','"':'&quot;'}[char]));
const clean = value => String(value ?? '').trim().replace(/^[,，\s]+|[,，\s]+$/g, '').replace(/\s+/g, ' ');
const splitTags = value => String(value ?? '').split(/[,，\n]+/).map(clean).filter(Boolean);
const unique = list => [...new Map(list.map(item => [item.toLowerCase(), item])).values()];

function peopleTag() {
  if (state.gender === '女性') return state.count === 1 ? '1girl' : `${state.count}girls`;
  if (state.gender === '男性') return state.count === 1 ? '1boy' : `${state.count}boys`;
  return state.count === 1 ? '1person' : `${state.count}people`;
}
function peopleZh() { return `${state.count} 人${state.gender === '混合' ? '人物' : state.gender + '角色'}`; }
function selectedTags() { return allTags().filter(item => state.selected.has(item.id)).sort((a,b) => a.order - b.order || a.en.localeCompare(b.en)); }
function tokens() { return unique([peopleTag(), ...selectedTags().map(item => item.en), ...splitTags(state.extra), ...splitTags(state.preprompt)]); }
function positiveText() { return tokens().map(item => `${item}.`).join(' '); }
function chineseText() {
  const list = [peopleZh(), ...selectedTags().map(item => item.zh)];
  if (state.extra.trim()) list.push(`額外英文標籤：${state.extra.trim()}`);
  if (state.preprompt.trim()) list.push(`Amanatsu 品質前綴：${state.preprompt.trim()}`);
  return list.join('。 ');
}
function negativeText() { return splitTags(state.negative).map(item => `${item}.`).join(' '); }
function snapshot() { return { ...state, selected: [...state.selected] }; }
function persist() { localStorage.setItem(STORAGE_KEY, JSON.stringify(snapshot())); }
function toast(message) { const element = $('#toast'); element.textContent = message; element.classList.add('show'); clearTimeout(toast.timer); toast.timer = setTimeout(() => element.classList.remove('show'), 1800); }
function restore() {
  try {
    const saved = JSON.parse(localStorage.getItem(STORAGE_KEY) || 'null');
    if (!saved) return;
    state.selected = new Set(saved.selected || []); state.customTags = saved.customTags || []; state.presets = saved.presets || [];
    state.group = saved.group || '全部'; state.query = saved.query || ''; state.gender = saved.gender || state.gender; state.count = Number(saved.count) || 1; state.model = saved.model || state.model; state.sampler = saved.sampler || state.sampler; state.steps = Number(saved.steps) || state.steps; state.cfg = saved.cfg || state.cfg; state.clipSkip = saved.clipSkip || state.clipSkip; state.showAdult = saved.showAdult === true;
    state.preprompt = saved.preprompt ?? state.preprompt; state.extra = saved.extra ?? ''; state.negative = saved.negative ?? state.negative;
  } catch { toast('記憶資料無法讀取，已使用預設值'); }
}
function renderFilters() {
  const groups = ['全部', ...new Set(allTags().map(item => item.group))];
  $('#group-filters').innerHTML = groups.map(group => `<button class="filter ${state.group === group ? 'active' : ''}" data-group="${esc(group)}">${esc(group)}</button>`).join('');
}
function renderTags() {
  const query = state.query.toLowerCase();
  const items = allTags().filter(item => (state.group === '全部' || item.group === state.group) && (state.showAdult || !item.adult) && (!query || `${item.zh} ${item.en}`.toLowerCase().includes(query)));
  $('#tag-list').innerHTML = items.length ? items.map(item => `<button class="tag ${state.selected.has(item.id) ? 'selected' : ''} ${item.adult ? 'adult' : ''}" data-tag="${esc(item.id)}"><span>${item.adult ? '<i class="adult-dot">18+</i> ' : ''}${esc(item.zh)}</span><em>${esc(item.en)}</em></button>`).join('') : '<div class="empty">沒有符合條件的標籤。可以新增自己的中文/英文標籤。</div>';
}
function renderPresets() {
  if (!state.presets.length) { $('#preset-list').innerHTML = '<div class="preset-empty">尚無儲存組合。按輸出結果右上角的書籤按鈕保存。</div>'; return; }
  $('#preset-list').innerHTML = state.presets.map((preset, index) => `<div class="preset"><span class="preset-number">${index + 1}</span><span class="preset-info"><b>${esc(preset.name)}</b><small>${(preset.payload.selected || []).length} 個標籤 · ${esc(preset.payload.gender)} ${preset.payload.count} 人</small></span><span class="preset-actions"><button class="icon-button" title="載入" data-load="${index}">↺</button><button class="icon-button" title="刪除" data-delete="${index}">×</button></span></div>`).join('');
}
function renderOutput() {
  $('#positive-output').value = positiveText(); $('#chinese-output').value = chineseText(); $('#negative-output').value = negativeText();
  $('#selected-summary').textContent = `已選 ${selectedTags().length} 個資料庫標籤 · 英文每個標籤以句點結尾`;
  $('#order-summary').textContent = `${peopleTag()} → 角色/特徵 → 服裝 → 表情 → 姿勢 → 場景/畫面 → 品質前綴 · 設定：${state.sampler} · ${state.steps} steps · CFG ${state.cfg} · Clip skip ${state.clipSkip}`;
}
function syncControls() { $('#model').value = state.model; $('#gender').value = state.gender; $('#people-count').value = String(state.count); $('#sampler').value = state.sampler; $('#steps').value = String(state.steps); $('#cfg').value = state.cfg; $('#clip-skip').value = state.clipSkip; $('#show-adult').checked = state.showAdult; $('#preprompt').value = state.preprompt; $('#extra-positive').value = state.extra; $('#negative').value = state.negative; $('#search').value = state.query; }
function render() { renderFilters(); renderTags(); renderPresets(); renderOutput(); syncControls(); persist(); }
async function copyText(value, label) {
  try { await navigator.clipboard.writeText(value); } catch {
    const area = document.createElement('textarea'); area.value = value; document.body.append(area); area.select(); document.execCommand('copy'); area.remove();
  }
  toast(`${label}已複製`);
}
function downloadBackup() { const blob = new Blob([JSON.stringify(snapshot(), null, 2)], { type: 'application/json' }); const link = document.createElement('a'); link.href = URL.createObjectURL(blob); link.download = 'betterwaifu-prompt-backup.json'; link.click(); URL.revokeObjectURL(link.href); toast('記憶資料已匯出'); }
function importBackup(file) { const reader = new FileReader(); reader.onload = () => { try { localStorage.setItem(STORAGE_KEY, reader.result); location.reload(); } catch { toast('JSON 檔案格式不正確'); } }; reader.readAsText(file); }
function groupOrder(group) { if (group === '自訂角色') return 0; if (group === '自訂特徵') return 1; if (group === '表情') return 3; if (group === '姿勢') return 4; if (group === '場景') return 9; return 2; }

document.addEventListener('click', event => {
  const tagButton = event.target.closest('[data-tag]');
  if (tagButton) { const id = tagButton.dataset.tag; state.selected.has(id) ? state.selected.delete(id) : state.selected.add(id); render(); return; }
  const groupButton = event.target.closest('[data-group]'); if (groupButton) { state.group = groupButton.dataset.group; render(); return; }
  const loadButton = event.target.closest('[data-load]'); if (loadButton) { const preset = state.presets[Number(loadButton.dataset.load)]; if (preset) { Object.assign(state, { ...preset.payload, selected: new Set(preset.payload.selected || []) }); render(); toast(`已載入「${preset.name}」`); } return; }
  const deleteButton = event.target.closest('[data-delete]'); if (deleteButton) { state.presets.splice(Number(deleteButton.dataset.delete), 1); render(); toast('組合已刪除'); return; }
});

$('#search').addEventListener('input', event => { state.query = event.target.value; render(); });
$('#clear-search').addEventListener('click', () => { state.query = ''; render(); });
$('#model').addEventListener('change', event => { state.model = event.target.value; persist(); });
$('#gender').addEventListener('change', event => { state.gender = event.target.value; renderOutput(); persist(); });
$('#people-count').addEventListener('change', event => { state.count = Number(event.target.value); renderOutput(); persist(); });
$('#sampler').addEventListener('change', event => { state.sampler = event.target.value; renderOutput(); persist(); });
$('#steps').addEventListener('change', event => { state.steps = Number(event.target.value); renderOutput(); persist(); });
$('#cfg').addEventListener('change', event => { state.cfg = event.target.value; renderOutput(); persist(); });
$('#clip-skip').addEventListener('change', event => { state.clipSkip = event.target.value; renderOutput(); persist(); });
$('#show-adult').addEventListener('change', event => { state.showAdult = event.target.checked; render(); });
$('#preprompt').addEventListener('input', event => { state.preprompt = event.target.value; renderOutput(); persist(); });
$('#extra-positive').addEventListener('input', event => { state.extra = event.target.value; renderOutput(); persist(); });
$('#negative').addEventListener('input', event => { state.negative = event.target.value; renderOutput(); persist(); });
$('#copy-positive').addEventListener('click', () => copyText(positiveText(), '英文正向標籤'));
$('#save-preset').addEventListener('click', () => { const name = window.prompt('組合名稱', '我的 Amanatsu 組合'); if (!name?.trim()) return; state.presets.unshift({ name: name.trim(), payload: snapshot() }); render(); toast('組合已儲存'); });
$('#export-btn').addEventListener('click', downloadBackup);
$('#import-btn').addEventListener('click', () => $('#import-file').click());
$('#import-file').addEventListener('change', event => { if (event.target.files?.[0]) importBackup(event.target.files[0]); event.target.value = ''; });
$('#add-tag-btn').addEventListener('click', () => { $('#custom-zh').value = ''; $('#custom-en').value = ''; $('#custom-group').value = '自訂特徵'; $('#custom-dialog').showModal(); });
$('#custom-form').addEventListener('submit', event => { event.preventDefault(); const zh = $('#custom-zh').value.trim(); const en = clean($('#custom-en').value); if (!zh || !en) return; const group = $('#custom-group').value; const item = { id: `custom_${Date.now()}`, group, zh, en, order: groupOrder(group), adult: false, builtIn: false }; state.customTags.push(item); state.selected.add(item.id); $('#custom-dialog').close(); render(); toast('自訂標籤已加入'); });

restore(); render();
if ('serviceWorker' in navigator && location.protocol !== 'file:') navigator.serviceWorker.register('./sw.js').catch(() => {});
