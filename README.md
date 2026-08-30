# 🐦 Flappy Bird

<p align="center">
  <strong>Flappy Bird — 2D Arcade Game</strong>
</p>

<p align="center">
  Game 2D arcade sederhana yang dibuat menggunakan Godot Engine 4.7.
</p>

---

## 🎮 Tentang Game

**Flappy Bird** adalah game arcade 2D dengan gameplay sederhana tetapi membutuhkan ketepatan dan konsentrasi.

Pemain mengendalikan seekor burung yang harus melewati celah di antara pipa tanpa menabrak pipa atau jatuh ke tanah.

Setiap pipa yang berhasil dilewati akan memberikan **+1 Score**.

Tujuan utama permainan adalah mendapatkan **score setinggi mungkin**.

---

## ✨ Fitur

Game ini memiliki berbagai fitur:

- 🐦 Gameplay Flappy Bird 2D
- 🎯 Sistem Score
- 🏆 High Score
- 💀 Game Over
- 🔄 Restart Game
- ⏸️ Pause Game
- 🏠 Main Menu
- ⚙️ Settings
- 🔊 Background Music
- 🔔 Sound Effects
- 🎵 Pengaturan volume musik
- 🔊 Pengaturan volume SFX
- 🎨 Graphics Settings
- 🖥️ Fullscreen
- 🖥️ Borderless Fullscreen
- 🪟 Windowed Mode
- 📐 Pengaturan Resolution Windows
- ⚡ FPS Target
- 🎨 Graphics Quality
- 💾 Penyimpanan Settings
- 📱 Android Touch Control
- 💻 Windows Keyboard Control
- 🖱️ Windows Mouse Control
- 📱 Dukungan Android
- 💻 Dukungan Windows
- ℹ️ About Page
- 👨‍💻 Informasi Developer & Kontak WhatsApp

---

# 🕹️ Cara Bermain

## 💻 Windows

Gunakan:

**SPACE**
→ Membuat burung terbang.

**Klik Mouse**
→ Membuat burung terbang.

Tujuan:

1. Kendalikan burung.
2. Lewati celah pipa.
3. Jangan menyentuh pipa.
4. Jangan jatuh ke tanah.
5. Dapatkan score sebanyak mungkin.

---

## 📱 Android

Gunakan:

**TAP LAYAR**
→ Membuat burung terbang.

Tujuan:

1. Tap layar untuk mengontrol burung.
2. Atur waktu tap dengan tepat.
3. Lewati celah pipa.
4. Hindari pipa.
5. Jangan jatuh ke tanah.
6. Dapatkan score tertinggi.

---

# 🖥️ Graphics Settings

Game menyediakan pengaturan grafis untuk menyesuaikan pengalaman bermain.

## Quality

Tersedia:

- LOW
- MEDIUM
- HIGH

Pengaturan Quality digunakan untuk menyesuaikan efek visual yang tersedia di dalam game.

---

## Resolution

Pada Windows, game dapat menyediakan berbagai resolusi yang didukung monitor.

Contoh:

- 1280 × 720
- 1280 × 800
- 1366 × 768
- 1440 × 900
- 1600 × 900
- 1680 × 1050
- 1920 × 1080
- 1920 × 1200
- 2560 × 1080
- 2560 × 1440
- 2560 × 1600
- 3440 × 1440
- 3840 × 2160

Game hanya menampilkan resolusi yang sesuai dengan perangkat/monitor.

---

## 🖥️ Display Mode

Windows menyediakan:

- Fullscreen
- Borderless Fullscreen
- Windowed

Pengaturan ini diterapkan menggunakan **GDScript Godot 4.7** dan bukan sekadar perubahan tampilan UI.

---

## ⚡ FPS Target

Tersedia:

- 30 FPS
- 60 FPS
- 120 FPS
- Unlimited

Pengaturan FPS diterapkan secara langsung pada engine game (`Engine.max_fps`).

---

# 🔊 Audio Settings

Game memiliki:

### 🎵 Music

Mengatur background music game.

### 🔔 Sound Effects

Mengatur suara efek seperti:

- Flap
- Score
- Button Click & Hover
- Pause
- Game Over

Volume musik dan SFX dapat disesuaikan melalui Settings.

---

# ⚙️ Settings

Menu Settings menyediakan:

- Audio Settings
- Graphics Settings
- Music Toggle
- SFX Toggle
- Music Volume Slider
- SFX Volume Slider
- Graphics Quality Dropdown
- Resolution Dropdown
- Display Mode Dropdown
- FPS Target Dropdown
- Tombol APPLY, RESET, dan BACK

Pengaturan disimpan secara persisten sehingga konfigurasi pemain tetap tersedia ketika game dibuka kembali.

---

# 💾 Save Settings

Konfigurasi game disimpan menggunakan sistem penyimpanan lokal Godot.

Pengaturan mencakup:

```text
graphics_quality
resolution_w
resolution_h
display_mode
fps_target
music_enabled
sfx_enabled
music_volume
sfx_volume
```

File konfigurasi disimpan pada lokasi user Godot:

`user://settings.cfg` dan disinkronkan ke `user://savegame.dat`.

---

# 📱 Platform

Game ditargetkan untuk:

- **Android** (Format: `.apk`)
- **Windows** (Format: `.zip` / `.exe` build mandiri)

Build Windows didistribusikan bersama seluruh file pendukung yang diperlukan oleh Godot.

---

# 📥 Download

### 📱 Android

Download file:

`FlappyBird-Android.apk`

Kemudian install pada perangkat Android yang kompatibel.

### 💻 Windows

Download:

`FlappyBird-Windows.zip`

Kemudian:

1. Extract ZIP.
2. Buka folder game.
3. Jalankan `FlappyBird.exe`.

> Jangan hanya menyalin file EXE. Gunakan seluruh isi folder Windows build agar resource game tersedia lengkap.

---

# 🚀 GitHub Releases

Build game tersedia melalui GitHub Releases.

Setiap versi dapat menggunakan format tag:

- `v1.0.0`
- `v1.0.1`
- `v1.1.0`
- `v2.0.0`

Contoh release:

**FLAPPY BIRD v1.0.0**

File yang disertakan:

- 📱 `FlappyBird-Android.apk`
- 💻 `FlappyBird-Windows.zip`

---

# 🛠️ Teknologi

| Teknologi | Digunakan |
| :--- | :--- |
| **Godot Engine** | 4.7 |
| **GDScript** | Gameplay & Systems |
| **2D Renderer** | Game Rendering |
| **Android** | Target Platform |
| **Windows** | Target Platform |
| **GitHub** | Source Code & Distribution |
| **GitHub Actions** | Automated Build & Release |

---

# 📂 Struktur Project

```text
FlappyBird/
│
├── assets/
│   ├── audio/
│   │   ├── music/
│   │   └── sfx/
│   ├── icon/
│   └── textures/
│       └── icons/
│
├── scenes/
│   ├── gameplay/
│   │   ├── Bird.tscn
│   │   └── Ground.tscn
│   ├── main/
│   │   └── Main.tscn
│   ├── obstacles/
│   │   ├── PipePair.tscn
│   │   └── TopPipe.tscn / BottomPipe.tscn
│   └── ui/
│       ├── AboutMenu.tscn
│       ├── GameOver.tscn
│       ├── HUD.tscn
│       ├── MainMenu.tscn
│       ├── PauseMenu.tscn
│       └── Settings.tscn
│
├── scripts/
│   ├── DisplaySettings.gd
│   ├── core/
│   │   ├── AudioManager.gd
│   │   ├── GameManager.gd
│   │   ├── Main.gd
│   │   └── SaveManager.gd
│   ├── gameplay/
│   ├── obstacles/
│   └── ui/
│       ├── AboutMenu.gd
│       ├── GameOver.gd
│       ├── HUD.gd
│       ├── MainMenu.gd
│       ├── PauseMenu.gd
│       └── Settings.gd
│
├── .github/
│   └── workflows/
│       └── build.yml
│
├── project.godot
├── export_presets.cfg
├── .gitignore
└── README.md
```

---

# 🎯 Gameplay Rules

Burung akan terkena Game Over apabila:

1. Menyentuh pipa bagian atas.
2. Menyentuh pipa bagian bawah.
3. Menyentuh tanah.

Collision pipa mengikuti visual pipa secara presisi sehingga pemain hanya terkena Game Over ketika burung benar-benar menyentuh pipa.

Area score hanya digunakan untuk memberikan score ketika burung berhasil melewati celah pipa.

---

# 🏆 Score

Setiap pasangan pipa yang berhasil dilewati:

**+1 SCORE**

Score ditampilkan secara real-time selama permainan.

Setelah Game Over, pemain dapat melihat score yang diperoleh serta High Score terbaru yang tercatat.

---

# 💀 Game Over

Jika burung menabrak pipa atau tanah:

**GAME OVER**

Kemudian pemain dapat memilih:

- `[ RETRY ]` untuk mengulang permainan seketika.
- `[ MAIN MENU ]` untuk kembali ke halaman utama.

---

# ℹ️ About

Game memiliki halaman About lengkap yang berisi:

- Sambutan & Gambaran Game
- Informasi Game (Genre, Engine, Platform, Mode, Versi)
- Profil Developer
- Tombol Kontak Langsung WhatsApp Developer
- Panduan Cara Bermain (Windows & Android)
- Panduan Kontrol Lengkap
- Daftar Fitur Game
- Penjelasan Sistem Audio
- Penjelasan Sistem Grafis
- Versi Game
- Credits Game & Lisensi

Halaman About menggunakan layout `ScrollContainer` yang responsif di laptop/PC dan layar sentuh HP.

---

# 👨‍💻 Developer

**Rafael Sitompul**  
*Game Developer*  
Indonesia  

### 📱 Contact Developer

WhatsApp: **+62 895-0978-9282**  
Link Direct: [Chat on WhatsApp](https://wa.me/6289509789282)

---

# 🧑‍💻 Development

Project ini dikembangkan menggunakan:

- **Godot Engine 4.7**
- **GDScript**

Seluruh gameplay dan sistem window/display dibuat menggunakan GDScript murni yang kompatibel dengan Godot 4.7.

---

# 🔧 Build Project

Untuk membuka dan mengembangkan project:

1. Install **Godot Engine 4.7**.
2. Clone repository:
   ```bash
   git clone https://github.com/your-username/flappy-bird.git
   ```
3. Buka project melalui Godot Project Manager.
4. Import project (`project.godot`).
5. Jalankan project dengan menekan tombol **Play** (F5).

---

# 📦 Export

Project disiapkan untuk:

- **Android** → Menghasilkan `FlappyBird-Android.apk`
- **Windows Desktop** → Menghasilkan paket build mandiri `FlappyBird-Windows.zip`

---

# 🤖 GitHub Actions

Project dapat dikonfigurasi dengan GitHub Actions untuk otomatisasi build dan release:

```text
Push Tag (v*.*.*)
       ↓
GitHub Actions Workflow
       ↓
Godot 4.7 Setup
       ↓
Export Android APK & Windows Build
       ↓
Package Artifacts (.apk & .zip)
       ↓
Publish ke GitHub Release
```

---

# 🔐 Security

- Jangan menyimpan Password, Keystore, Private Key, API Key, atau Credential di repository publik.
- Gunakan **GitHub Secrets** untuk menyimpan data sensitif proses CI/CD.

---

# 📜 License

Lisensi project mengikuti ketentuan yang ditentukan oleh developer.

Asset grafis, audio, font, dan library pihak ketiga digunakan sesuai dengan ketentuan lisensinya masing-masing.

---

# ❤️ Credits

- **Game**: Flappy Bird
- **Developer**: Rafael Sitompul
- **Engine**: Godot Engine 4.7
- **Programming**: GDScript
- **Platform**: Android & Windows

---

# ⭐ Flappy Bird

Terima kasih telah memainkan Flappy Bird!

Terbang sejauh mungkin, hindari semua pipa, dan raih score tertinggimu! 🐦✨

*Good luck and have fun!*