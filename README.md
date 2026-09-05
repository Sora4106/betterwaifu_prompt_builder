# BetterWaifu Prompt Builder（內部使用）

本專案是 BetterWaifu Amanatsu 1.1 的提示標籤組合工具，包含：

- Flutter Web PWA 版本：`flutter_pwa/`
- 瀏覽器單機版本：`standalone_web/`
- 漸進式人物、場景、特徵、服裝、表情、姿勢與負面標籤流程
- 中英文標籤、角色資料庫、自訂角色、自訂標籤與本機記憶
- 正／負提示詞固定複製按鈕、衝突替換提示與 JSON 備份
- 版本顯示、版本歷程與新版首次開啟提示

這是內部系統，不提供公開使用說明，也不應將自訂角色、標籤或提示詞上傳到第三方服務。

## 版本維護

版本資料位於 `version.json`。有新功能或新項目時，在專案根目錄執行：

```powershell
.\tools\update-version.ps1 -Notes "新增功能說明"
```

這會自動增加 patch 版本與 build number，並追加更新內容到版本歷程、Flutter 版本常數、單機版版本檔與 Flutter `pubspec.yaml`。部署流程也會在偵測到未更新版本的專案變更時自動執行同樣的追加動作。

若要指定版本，可使用：

```powershell
.\tools\update-version.ps1 -Version 1.2.0 -Notes "版本更新說明"
```

版本歷程保留於 `CHANGELOG.md`，最新版本在最上方。
