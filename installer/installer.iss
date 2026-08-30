; Inno Setup Script for Flappy Bird 2D (Windows 11 / 10 Installer)
; Automatic SSD Installation to C:\FlappyBird and Clean Uninstaller

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
; Folder instalasi default: C:\FlappyBird (atau folder pilihan user)
DefaultDirName=C:\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=..\release
OutputBaseFilename=FlappyBird-Setup
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
Name: "cleandata"; Description: "Hapus data save & konfigurasi lokal (C:\FlappyBird\Data) saat uninstall"; GroupDescription: "Pengaturan Data:"; Flags: unchecked

[Files]
; Mengambil seluruh file build Windows dari folder builds\windows
Source: "..\builds\windows\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; Shortcut Start Menu
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"
; Shortcut Uninstaller di Start Menu
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"
; Shortcut Desktop
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; IconFilename: "{app}\{#MyAppExeName}"

[Run]
; Opsi jalankan game langsung setelah instalasi
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Hapus file instalasi di C:\FlappyBird
Type: files; Name: "{app}\*.*"
Type: filesandordirs; Name: "{app}\Data\*"
Type: dirifempty; Name: "{app}\Data"
Type: dirifempty; Name: "{app}"