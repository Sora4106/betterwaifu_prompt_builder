# BetterWaifu Prompt Builder

一個完全獨立的 AI 提示標籤組合工具，針對 BetterWaifu 的 Amanatsu 1.1 使用情境設計。

本資料夾包含兩個版本：

- `flutter_pwa/`：Flutter Web PWA，可建置、安裝並離線使用。
- `standalone_web/`：不需要 Flutter 或 Node 的單機瀏覽器版本，直接用靜態檔案即可執行。

## 已包含的功能

- 漸進式折疊流程：人物數量 → 場景／畫面 → 人物 → 外觀 → 服裝 → 表情 → 姿勢 → 品質／負面。
- 先選人物數量，再分別設定每位人物的性別；每位人物可選詳細設定、只保留人物數量，或使用原創／動漫角色模式。
- 角色資料庫含常用動漫角色、作品英文名稱、角色英文名稱與角色自帶特徵；最近使用角色會記憶在本機，也能自行新增完整角色資料。
- 角色類型、外觀特徵、髮型、眼睛、虎牙、角、尾巴、胸部/裸露、表情、姿勢、性行為、性姿勢、服裝、場景、畫面與品質標籤。
- 上衣、褲子、裙子、胸罩、內褲、襪子、鞋子、服裝、配件等服裝子分類。
- Danbooru 風格的成人向分類，敏感分類會以 18+ 標記提示。
- 自訂標籤：中文、英文都可輸入，儲存後兩種內容都保留。
- 依照「角色/特徵 → 服裝 → 表情 → 姿勢 → 其他」排序產生結果。
- 英文欄位每個標籤都以英文句點 `.` 結尾；中文翻譯在旁欄。
- 複製正向英文提示詞、負面提示詞與整組 JSON。
- 衝突提示：上衣／胸罩、褲子／內褲、泳裝／其他連身服、穿脫狀態、場景、表情與姿勢等互斥標籤會先詢問是否移除原標籤；多人時允許不同人物分別使用坐姿與站姿。
- 本機記憶：人物設定、最近角色、自訂標籤、已儲存預設組合都寫入瀏覽器 localStorage。
- 匯出/匯入 JSON，方便備份與跨版本轉移。

## 使用方式

### Flutter Web PWA

在 `flutter_pwa` 資料夾執行：

```powershell
flutter pub get
flutter run -d chrome
```

正式建置：

```powershell
flutter build web --release
```

建置結果在 `flutter_pwa/build/web/`。請用 HTTP server 提供它，瀏覽器才會啟用完整的 service worker/PWA 行為。

### 單機 Web 版本

直接開啟 `standalone_web/index.html` 即可。若瀏覽器限制 `file://` 的剪貼簿權限，可在該目錄啟動簡易 HTTP server：

```powershell
py -m http.server 8080
```

再開啟 `http://127.0.0.1:8080/`。

## 內容來源與實作取捨

標籤分類參考 Danbooru 的 breasts、sex acts、sexual positions、nudity、face tags 與其 tag checklist。Danbooru 的實際標籤會持續變動，本工具內建的是可編輯的常用起始目錄，不是完整鏡像。

BetterWaifu 文件目前公開說明的方向包括：使用逗號分隔的 tag、主體/細節/服裝/表情/姿勢/場景的 prompt 結構、括號強調、負面提示詞，以及 Anima 系列可混用自然語言與 Danbooru-style tags。Amanatsu 1.1 的專屬公開規格未能核實，所以預設前綴與排序規則都可以在介面內修改。

參考：

- https://danbooru.donmai.us/wiki_pages/tag_group%3Abreasts_tags
- https://danbooru.donmai.us/wiki_pages/tag_group:sex_acts
- https://danbooru.donmai.us/wiki_pages/tag_group:sexual_positions
- https://danbooru.donmai.us/wiki_pages/tag_group%3Anudity
- https://danbooru.donmai.us/wiki_pages/tag_group%3Aface_tags
- https://docs.betterwaifu.com/p/documentation/prompting/basics
- https://betterwaifu.com/updates
- https://betterwaifu.com/tags?category=ALL
- https://betterwaifu.com/blog/illustrious-guide

指南中可作為 Amanatsu（Illustrious）起始測試的設定已放進介面：Euler a、28 steps、CFG 5、Clip skip 2；這些不是強制規則，仍可依 seed、尺寸與 prompt 調整。

## 注意

工具只負責本機提示詞組合與記憶，不會自動呼叫 BetterWaifu API，也不會上傳你的自訂標籤或提示詞。請依 BetterWaifu 的服務條款與內容規範使用，並只建立成年角色內容。
