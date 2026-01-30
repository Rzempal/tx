# 📂 Tecnomatix AI Compliance Agent - Struktura Projektu

Ten dokument opisuje architekturę plików i folderów dla wtyczki "AI Compliance Agent" do Tecnomatix
Process Simulate. Projekt integruje API Gemini w celu weryfikacji standardów inżynierskich (OEM).

## Drzewo Projektu (File System)

Zalecana struktura w Visual Studio (Solution Explorer): TecnomatixAiAgent (Solution) └──
TecnomatixAiAgent (Project - Class Library .NET Framework 4.7.2) ├── Properties │ └──
AssemblyInfo.cs // Wersjonowanie pliku DLL ├── References // (Tutaj dodajesz DLL Siemensa) │ ├──
Core │ └── GeminiClient.cs // [MÓZG] Klient HTTP do komunikacji z API │ ├── Models │ └──
AuditItem.cs // Klasa danych (Wiersz tabeli wyników) │ ├── Commands │ └── OemGuardianCommand.cs //
[STRAŻNIK] Główna logika wtyczki (Execute) │ ├── UI │ └── AuditResultForm.cs // [WIZUALIZACJA] Okno
z tabelą wyników │ ├── Resources │ └── Rules  
 │ └── VASS_Rules.json // [REGUŁY] Plik wygenerowany przez "Extractora" │ ├── CommandReg.xml //
Rejestracja przycisku w Process Simulate └── packages.config // Lista pakietów NuGet
(Newtonsoft.Json)

## Zawartość Plików (Manifest)

Poniżej instrukcja, który kod z naszej rozmowy wkleić do którego pliku.

### Core/GeminiClient.cs

- Zawartość: Kod klienta HTTP z asynchroniczną metodą AskGemini.
- Modyfikacja: Zamiast wpisywać klucz API na sztywno, użyj: private static readonly string ApiKey =
  Environment.GetEnvironmentVariable("GEMINI_API_KEY", EnvironmentVariableTarget.User);

### Models/AuditItem.cs

- Zawartość: Prosta klasa modelu danych (DTO), którą wcześniej zdefiniowaliśmy wewnątrz pliku UI.
  Warto ją wydzielić dla porządku. public class AuditItem { public string id { get; set; } public
  string name { get; set; } public string status { get; set; } public string violation_code { get;
  set; } public string reason { get; set; } }

### UI/AuditResultForm.cs

- Zawartość: Kod klasy TxForm tworzącej tabelę (DataGridView).
- Ważne: Upewnij się, że używa using TecnomatixAiAgent.Models; jeśli wydzieliłeś klasę AuditItem.

### Commands/OemGuardianCommand.cs

- Zawartość: Główna klasa dziedzicząca po TxButtonCommand.
- Logika:
  - Pobiera dane z TxApplication.ActiveDocument.
  - Wczytuje plik reguł z folderu Resources/Rules/VASS_Rules.json.
  - Buduje Prompt Systemowy.
  - Wywołuje GeminiClient.AskGemini(...).
  - Przekazuje wynik do AuditResultForm.LoadAuditData(...) i wyświetla okno.

## Konfiguracja Środowiska (Krok po kroku)

### Krok 1: Wymagane Biblioteki (References)

Kliknij prawym przyciskiem myszy na References w Visual Studio i dodaj:

- Z folderu Tecnomatix (.../eMPower/):
  - Tecnomatix.Engineering.dll
  - Tecnomatix.Engineering.Ui.dll
- Z NuGet Package Manager:
  - Newtonsoft.Json (wersja 13.0.x lub nowsza).

### Krok 2: Plik CommandReg.xml

Aby przycisk pojawił się w menu, utwórz plik XML w folderze DotNetCommands w katalogu instalacyjnym
Tecnomatix: <CommandReg> <Cmd 
    InternalId="TecnomatixAiAgent.Commands.OemGuardianCommand" 
    ExternalId="AiAgent.CheckStandard" 
    Caption="AI Audit" 
    Category="AI Tools" 
    Module="TecnomatixAiAgent.dll" 
  /> </CommandReg>

### Krok 3: Bezpieczeństwo (API Key)

Nie wpisuj klucza API w kodzie!

- W systemie Windows otwórz Edytuj zmienne środowiskowe systemu.
- Dodaj nową zmienną użytkownika:
  - Nazwa: GEMINI_API_KEY
  - Wartość: (Twój klucz zaczynający się od AIza...)
- Zrestartuj Visual Studio i Process Simulate, aby zaczytały nową zmienną.

## Kompilacja i Wdrożenie (Deployment)

- Ustaw tryb budowania na Release.
- Zbuduj projekt (Build Solution).
- Wejdź do folderu bin/Release.
- Skopiuj pliki:
  - TecnomatixAiAgent.dll
  - Newtonsoft.Json.dll (Ważne! Tecnomatix może go nie mieć w standardzie)
- Wklej je do folderu .../eMPower/DotNetCommands w katalogu instalacyjnym Process Simulate.
