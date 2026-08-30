; Inno Setup Script for Flappy Bird 2D (Windows 11 / 10 Installer)
; Automatic SSD Folder Creation & Clean Uninstaller

#define MyAppName "Flappy Bird"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Rafael Sitompul"
#define MyAppExeName "FlappyBird.exe"
#define MyAppId "{{9F82A41B-5E3D-4A71-8B1C-E73F28B0A891}"

[Setup]
AppId={#MyAppId}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
; Otomatis membuat folder di SSD: C:\Program Files\Flappy Bird (atau drive SSD tempat Windows terpasang)
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=..\release
OutputBaseFilename=FlappyBird-Setup-v1.0.0
SetupIconFile=..\assets\icon\game_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName} 2D Game
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern

; Hak Administrator Penuh saat Instalasi Windows 11 / 10
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=commandline
ArchitecturesInstallIn64BitMode=x64

; Bersihkan file saat uninstall tanpa meninggalkan error / file sisa
CloseApplications=yes
RestartApplications=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkedonce

[Files]
; Salin FlappyBird.exe ke dalam folder SSD {app}
Source: "FlappyBird.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; Shortcut Start Menu
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"
; Shortcut Uninstaller di Start Menu
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"
; Shortcut Desktop
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; IconFilename: "{app}\{#MyAppExeName}"

[Run]
; Opsi buka game setelah instalasi selesai
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Hapus seluruh folder game di SSD dan file konfigurasi saat di-uninstall
Type: files; Name: "{app}\*.*"
Type: dirifempty; Name: "{app}"