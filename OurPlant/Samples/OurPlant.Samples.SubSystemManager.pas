// *****************************************************************************
//
//                            OurPlant OS
//                       Micro Cell Architecture
//                             for Delphi
//                            2019 / 2020
//
// Copyright (c) 2019-2020 Gerrit H�cker
// Copyright (c) 2019-2020 H�cker Automation GmbH
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// Authors History:
//    Gerrit H�cker (2020)
// *****************************************************************************

{-------------------------------------------------------------------------------
Jedes OurPlant System geht vom Discovery Manager als Wurzel (root) aus. Zur
Verwaltung von Sysbsystemen bietet es sich jedoch an, einen Manager einzubauen.

Unter diesem Manager k�nnen Substrukturen eingenst�ndig verwaltet werden.
Insbesonder f�r eine andere Speicherung (Art, Format und Zeitpunkt) spielt hier
eine wichtige Rolle. Auch dienen Subsystem Manager zur B�ndelung gleichartiger
Zellen / Zellstrukturen (z.B. Module, Systemkomponenten, Programme, etc)

Mit dem Beispiel SubSystem Manager wird gezeigt, wie das Speichermodell vom
Discovery Manager mit seiner Standard-L�sung unterhalb des Managers abgewandelt
wird.
-------------------------------------------------------------------------------}
unit OurPlant.Samples.SubSystemManager;

interface

uses
  OurPlant.Common.CellObject,
  OurPlant.SkillInterface.DataManager;

const
  C_SUB_SYSTEM_SAMPLE_NAME = 'SubSystemSample';
  C_SAMPLE_FILE_DIR = 'C:\data\OurPlant samples';

type

  {-------------------------------------------------------------------------------
  Die TcoSubSystemManagerSample verwaltet eine eigene Zellstruktur. Sie wird
  konstruiert, soblad sie im System global angesprochen wird. Dann wird sie Teil
  der Haupt-Zellstruktur des Discovery Managers.

  Das Speichermodell nutzt noch den gleichen DataManager, wie der CDM und arbeitet
  aber in einen anderem Verzeichnisstruktur (C:\data\OurPlant samples). Alternativ
  k�nnte hier auch ein anderer DataManager (z.B. Netzwerk oder SQL) verwendet werden.
  -------------------------------------------------------------------------------}

  // Der Typname wird auf "SubSystemSampleManager" festgelegt.
  // Der Typ kann �ber die Typ-GUID "7A4C4432-4641-4D2A-ABB9-F8DF85F1FBDA"
  // eindeutig identifiziert und reproduziert werden.
  [RegisterCellType('subsystem manager sample','{7A4C4432-4641-4D2A-ABB9-F8DF85F1FBDA}')]

  // Das Objekt TcoSubSystemManagerSample wird von TCellObject abgeleitet.
  // Dadurch unterst�tzt der Manager grunds�tzlich auch das Interface IsiCellObject.
  TcoSubSystemManagerSample = class(TCellObject)

    // Der DataManager ist intern direkt �ber fDataManager als ein Skill-Interface
    // "IsiDataManager1" ansprechbar. TcoStandardDataManager unterst�tzt dieses
    // Skill-Interface.
    fDataManager : IsiDataManager1;

  public
    // �berschreibe die Funktion CellConstruction von TCellObject, um die
    // Zellstruktur und Inhalte anzulegen
    /// <summary>
    ///  construction of cell content & structures and set defaults
    ///  Are called at the end of AfterConstruction of TCellobject. Derivate's
    ///  overrides this method to define and construct the cell structure and
    ///  settings.
    /// </summary>
    procedure CellConstruction; override;

    // Die allgemeine Save-Routine des TCellObject reicht den Aufruf zum Save nur
    // an seine Subzellen weiter. Die Routine muss um die eigene Save-Aufgabe
    // erweitert werden. Hierf�r wird der eigene DataManager in seine Grundfunktion
    // siSaveTo verwendet.
    procedure siSave; override;

    // Die allgemeine Restore-Routine des TCellObject reicht den Aufruf zum Save nur
    // an seine Subzellen weiter. Die Routine muss um die eigene Save-Aufgabe
    // erweitert werden. Hierf�r wird der eigene DataManager in seine Grundfunktion
    // siSaveTo verwendet.
    procedure siRestore; override;
  end;

implementation

uses
  OurPlant.Common.DiscoveryManager,
  OurPlant.Common.DataManager;

procedure TcoSubSystemManagerSample.CellConstruction;
begin
  // SubCellContent := false verhindert, dass der Inhalte und
  // die Subzellen der Zelle (Instanz) von TcoSubSystemManagerSample von der
  // �bergordneten Zelle (Discovery Manager) mitgesichert wird.
  fSubCellContent := False;


  // Konstruiere einen Standard Datamanager als SubZellen
  // der eigene DataManager tr�gt den Namen "SubDataManager"
  fDataManager := ConstructNewCellAs<IsiDataManager1>(TcoStandardDataManager,'SubDataManager');

  // Der StandardDataManager hat eine Eigenschaft (string data cell) als Subzelle
  // von dieser Zelle ist diese Zelle �ber den relativen Zell-Pfad (LongName)
  // "SubDataManager/FileDir" ansprechbar. Mit SetValue kann diese Eigenschaft
  // auf C_Sample_File_Dir gesetzt werden. Der DataManager wird dieses Verzeichnis
  // als Standard-Root verwenden.
  siFindCell('SubDataManager/FileDir').siAsString := C_SAMPLE_FILE_DIR;

end;

procedure TcoSubSystemManagerSample.siSave;
begin
  Assert(Assigned(fDataManager),'Not assigned data manager in SubSystemManagerSample '+siLongName);

  fDataManager.siSaveCellJSONContent( Self);

  inherited siSave;
end;

procedure TcoSubSystemManagerSample.siRestore;
begin
  Assert(Assigned(fDataManager),'Not assigned data manager in SubSystemManagerSample '+siLongName);

  fDataManager.siRestoreCellJSONContent( Self);

  inherited siRestore;
end;

end.
