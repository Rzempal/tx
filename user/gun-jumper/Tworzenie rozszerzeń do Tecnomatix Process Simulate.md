Tworzenie rozszerzeń (makr, wtyczek, komend) do Tecnomatix Process Simulate opiera się głównie na .NET API. Oznacza to, że standardem branżowym do pisania tych narzędzi jest język C#.
Oto analityczne i logiczne zestawienie procesu tworzenia wtyczek, oparte na dokumentacji technicznej i standardach Siemens:
1. Wymagane środowisko i narzędzia
Aby pisać wtyczki, potrzebujesz następujących elementów:
 * Język programowania: C# (jest to główny język wspierany przez Tecnomatix .NET API).
 * Środowisko programistyczne (IDE): Microsoft Visual Studio (wersja Community lub Professional).
 * Zainstalowany Process Simulate: Musisz mieć dostęp do plików instalacyjnych programu, aby pobrać z nich biblioteki (pliki .dll).
2. Architektura rozwiązania
Wtyczka do Process Simulate to w rzeczywistości biblioteka klas (Class Library), która po skompilowaniu do pliku .dll jest ładowana przez program przy starcie.
Główna biblioteka, której będziesz używać, to zazwyczaj:
 * Tecnomatix.Engineering.dll – zawiera podstawowe funkcje inżynieryjne i definicje obiektów (roboty, zasoby, operacje).
3. Proces tworzenia krok po kroku
 * Utworzenie projektu: W Visual Studio tworzysz nowy projekt typu "Class Library" (.NET Framework). [Inference: Wersja .NET Framework musi być zgodna z wersją Process Simulate, której używasz – zazwyczaj jest to 4.x].
 * Dodanie referencji: Do projektu musisz dodać odwołania (References) do plików DLL z folderu instalacyjnego Process Simulate (zazwyczaj znajdują się w folderze eMPower lub DotNetCommands). Kluczowy plik to wspomniany Tecnomatix.Engineering.dll.
 * Implementacja kodu:
   * Tworzysz klasę, która dziedziczy po odpowiednim interfejsie API (np. TxButtonCommand lub podobnym, zależnie od tego, czy tworzysz przycisk w menu, czy funkcję działającą w tle).
   * Nadpisujesz metody takie jak Execute (co ma się stać po kliknięciu) oraz Update (kiedy przycisk jest aktywny).
 * Kompilacja: Budujesz rozwiązanie (Build), co generuje Twój plik .dll.
 * Wdrożenie (Deployment):
   * Gotowy plik .dll należy umieścić w specjalnym folderze, który Process Simulate skanuje przy uruchomieniu.
   * Zazwyczaj jest to folder: .../eMPower/DotNetCommands.
4. Gdzie szukać dokumentacji?
To najważniejszy punkt, ponieważ nazwy klas i metod zmieniają się w zależności od wersji.
 * Plik pomocy CHM: W folderze instalacyjnym Process Simulate (często w podkatalogu Help lub eMPower/Help) znajduje się plik o nazwie zbliżonej do Tecnomatix.NET_API.chm lub API_Reference.chm. Jest to "biblia" dla programisty tego systemu.
 * Siemens Community: Oficjalne forum Siemens PLM posiada dział poświęcony Tecnomatix, gdzie użytkownicy dzielą się fragmentami kodu.
Podsumowanie
Nie pisze się tutaj typowych "makr" jak w Excelu (VBA). Pisze się pełnoprawne wtyczki w C#, które kompiluje się do plików DLL i wrzuca do folderu aplikacji.
Źródła:
 * Siemens Digital Industries Software Community (sekcja Tecnomatix Developer Forum)
 * Dokumentacja techniczna Tecnomatix Process Simulate (Help Library)
Co mogę dla Ciebie zrobić dalej?
Chcesz, abym przygotował prosty, przykładowy szkielet kodu w C#, który wyświetla komunikat "Hello World" w Process Simulate, abyś zobaczył strukturę takiej klasy?
