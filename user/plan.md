# TX1 Gun jumper
To jest zadanie wymagające konkretnego podejścia matematycznego (operacje na macierzach transformacji) oraz wykorzystania klasy TxSelectionInteraction do wybierania lokacji w pętli.
Poniżej przygotowałem kompletny kod wtyczki.
Jak to będzie działać (Workflow):
 * W drzewie (Object Tree) zaznaczasz Frame (układ współrzędnych), który ma być Twoim TCP (np. tool_tip wewnątrz uchwytu/narzędzia).
 * Klikasz przycisk wtyczki.
   * Skrypt automatycznie wykryje, do jakiego narzędzia (Resource) należy ten Frame.
   * Skrypt obliczy pozycję tego Frame'a względem punktu zerowego narzędzia (to jest Twoja stała transformacja).
 * Klikasz w lokacje (w oknie 3D lub Operation Tree).
 * Narzędzie natychmiast "skacze" w to miejsce, ustawiając wybrany Frame idealnie w punkcie i orientacji lokacji (zerowanie delty).
 * Klikasz ESC, aby zakończyć.
Kod źródłowy (C#)
Skopiuj ten kod do swojego projektu Visual Studio. Wymaga referencji Tecnomatix.Engineering.dll oraz Tecnomatix.Engineering.Ui.dll.
using System;
using Tecnomatix.Engineering;
using Tecnomatix.Engineering.Ui;

namespace AdvancedPlacementTools
{
    [TxCommandExternalId("AdvancedPlacement.QuickRelocate")]
    public class QuickRelocateCommand : TxButtonCommand
    {
        public override void Execute(object cmdParams)
        {
            // KROK 1: Pobranie zaznaczenia (użytkownik musi wybrać Frame - TCP)
            TxObjectList selection = TxApplication.ActiveSelection.GetItems();

            if (selection.Count != 1)
            {
                TxMessageBox.Show("Proszę zaznaczyć DOKŁADNIE JEDEN obiekt typu Frame (TCP), który ma być punktem odniesienia.", "Błąd wyboru", System.Windows.Forms.MessageBoxButtons.OK, System.Windows.Forms.MessageBoxIcon.Warning);
                return;
            }

            // Sprawdzamy, czy zaznaczono Frame
            TxFrame selectedTcpFrame = selection[0] as TxFrame;
            
            if (selectedTcpFrame == null)
            {
                TxMessageBox.Show("Zaznaczony obiekt nie jest ramką (TxFrame). Wybierz Frame wewnątrz narzędzia.", "Błąd typu", System.Windows.Forms.MessageBoxButtons.OK, System.Windows.Forms.MessageBoxIcon.Warning);
                return;
            }

            // KROK 2: Znalezienie rodzica (Narzędzia), którym będziemy ruszać
            // Szukamy w górę drzewa, aż trafimy na obiekt, który może się ruszać (ITxLocatableObject)
            ITxLocatableObject movingObject = GetMovableParent(selectedTcpFrame);

            if (movingObject == null)
            {
                TxMessageBox.Show("Nie znaleziono ruchomego rodzica dla wybranego Frame'a.", "Błąd hierarchii", System.Windows.Forms.MessageBoxButtons.OK, System.Windows.Forms.MessageBoxIcon.Error);
                return;
            }

            // KROK 3: Obliczenie stałej transformacji (Gdzie jest TCP względem punktu zerowego narzędzia?)
            // Wzór: T_Tool_World * T_TCP_Local = T_TCP_World
            // Zatem: T_TCP_Local = (T_Tool_World)^-1 * T_TCP_World
            TxTransformation tToolWorld = movingObject.AbsoluteLocation;
            TxTransformation tTcpWorld = selectedTcpFrame.AbsoluteLocation;
            
            // To jest nasza macierz przesunięcia TCP względem Roota narzędzia
            TxTransformation tTcpLocal = tToolWorld.Inverse() * tTcpWorld;

            // KROK 4: Uruchomienie interakcji wybierania lokacji
            // Przekazujemy obiekt do ruszenia i macierz TCP
            RelocateInteraction interaction = new RelocateInteraction(movingObject, tTcpLocal);
            interaction.Start();
        }

        // Metoda pomocnicza do szukania "Narzędzia" w górę drzewa
        private ITxLocatableObject GetMovableParent(TxObject obj)
        {
            ITxObject current = obj;
            while (current != null)
            {
                if (current is ITxLocatableObject && !(current is TxFrame))
                {
                    return (ITxLocatableObject)current;
                }
                current = current.Collection; // Idziemy wyżej w hierarchii
            }
            return null;
        }

        public override void Update(object cmdParams)
        {
            // Przycisk aktywny tylko gdy coś jest zaznaczone
            ((TxCommandAttribute)cmdParams).Status = TxApplication.ActiveSelection.GetItems().Count > 0 
                ? TxCommandStatus.Enabled 
                : TxCommandStatus.Disabled;
        }
    }

    // Klasa obsługująca klikanie w lokacje
    public class RelocateInteraction : TxSelectionInteraction
    {
        private ITxLocatableObject _toolToMove;
        private TxTransformation _tcpOffsetInverse;

        public RelocateInteraction(ITxLocatableObject tool, TxTransformation tcpOffset)
        {
            _toolToMove = tool;
            
            // Obliczamy odwrotność offsetu raz, żeby nie liczyć przy każdym kliknięciu.
            // Matematyka: Chcemy, żeby TCP było w Lokacji.
            // T_NewTool * T_Offset = T_Location
            // T_NewTool = T_Location * (T_Offset)^-1
            _tcpOffsetInverse = tcpOffset.Inverse();

            // Konfiguracja filtra - pozwalamy klikać tylko w Lokacje
            TxTypeFilter locFilter = new TxTypeFilter();
            locFilter.AddIncludedType(typeof(TxLocation)); // Obejmuje większość punktów
            this.SetFilter(locFilter);
        }

        // Ta metoda wykonuje się przy każdym kliknięciu w pasujący obiekt
        protected override void OnSelected(TxObjectList selectedObjects)
        {
            if (selectedObjects.Count == 0) return;

            // Pobieramy klikniętą lokację
            ITxLocatableObject targetLoc = selectedObjects[0] as ITxLocatableObject;

            if (targetLoc != null)
            {
                try
                {
                    // Pobieramy pozycję globalną klikniętej lokacji
                    TxTransformation tTargetWorld = targetLoc.AbsoluteLocation;

                    // Obliczamy, gdzie musi znaleźć się punkt zerowy narzędzia
                    TxTransformation tNewToolPosition = tTargetWorld * _tcpOffsetInverse;

                    // Wykonujemy ruch (zabezpieczony w transakcji dla Undo/Redo)
                    TxApplication.ActiveDocument.PlatformSpecificTransactionStart("Quick Relocate Tool");
                    _toolToMove.AbsoluteLocation = tNewToolPosition;
                    TxApplication.ActiveDocument.PlatformSpecificTransactionEnd();

                    // Odświeżamy ekran
                    TxApplication.RefreshDisplay();
                }
                catch (Exception ex)
                {
                    TxMessageBox.Show("Błąd podczas przenoszenia: " + ex.Message);
                }
            }

            // Czyścimy zaznaczenie interakcji, żeby być gotowym na kolejne kliknięcie
            this.ClearSelection();
        }
    }
}

Kluczowe elementy tego rozwiązania:
 * Matematyka (Inverse Matrix):
   Aby wyzerować delty, stosujemy wzór: NowaPozycjaNarzędzia = PozycjaLokacji * OdwróconaMacierzTCP.
   Dzięki temu, jeśli TCP jest przesunięty o X=100 względem narzędzia, to narzędzie musi stanąć w X=-100 względem lokacji, aby TCP trafił idealnie w punkt.
 * TxSelectionInteraction:
   Użyłem tej klasy zamiast surowego OnMouseClick, ponieważ użytkownik napisał w punkcie 3: "wyprojektowane lokacje". Klasa ta automatycznie "przykleja się" do obiektów typu TxLocation (robi highlight po najechaniu myszką), co eliminuje błędy precyzji kliknięcia.
 * Filtr typów (TxTypeFilter):
   Kod pozwala klikać tylko w obiekty typu TxLocation. Jeśli klikniesz w podłogę lub robota, nic się nie stanie – to celowe zachowanie, aby uniknąć przypadkowych przesunięć.
 * Hierarchia (GetMovableParent):
   Kod jest inteligentny – jeśli zaznaczysz Frame głęboko zagnieżdżony w strukturze (np. Gripper -> Jaw -> TCP), skrypt znajdzie głównego rodzica, którym można poruszać.
Jak skompilować?
Pamiętaj, aby dodać referencję do Tecnomatix.Engineering.Ui.dll (oprócz standardowego Engineering.dll), ponieważ klasa TxSelectionInteraction znajduje się w przestrzeni nazw UI.
