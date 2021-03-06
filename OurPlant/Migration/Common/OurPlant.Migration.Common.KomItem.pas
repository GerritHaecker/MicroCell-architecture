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
//    Gerrit H�cker (2019 - 2020)
// *****************************************************************************

{-------------------------------------------------------------------------------
   The Unit is part of migration fro OurPlant 2019 to the micro cell architecture.

   It contains:
     * A skill interface for KomItem useability (migration skill) in cell object
     * The migration object inherited from KomItem

    ------------------------------------
   | TKomItem                           |
   |  IUnknown, INameAble,              |
   |  ICommunicationModule, IGUID,      |
   |  ICoordinates, IPPSelectRequest    |
    ------------------------------------
                     |
    ------------------------------------
   | TmoKomItem                         |
   |  ImiKomItem                        |
    ------------------------------------
                     |                                        |
    ------------------------------------
   | TmoSample                          |
   |                                    |
    ------------------------------------


-------------------------------------------------------------------------------}
unit OurPlant.Migration.Common.KomItem;

interface

{$REGION 'uses'}
uses
  OurPlant.Common.OurPlantObject,
  OurPlant.Migration.Common.SysTypes,
  VideoCamera,
  MPKomponenten;
{$ENDREGION}

{$REGION 'global constants of KomItem'}

{$ENDREGION}

type
  {$REGION 'ImiKomItem1 - Migration Interface of KomItem for request of cell'}
  {-----------------------------------------------------------------------------
  ImiKomItem1 ist das Interface des Migrationsobjektes von TKomItem. Es wird in
  der Ableitung TmoKomItem implementiert und enth�lt alle Methoden der "alten"
  Klasse. Auch wird �ber das ImiKomItem den Zellen der Zugriff auf die alte Welt
  er�ffnet. Sie erm�glicht somit ein R�ckgreifen auf andere Klassen, Objekte,
  Interface und Methoden.

  Im ImiKomItem1 werden die "alten" KomItem Methoden und Eigenschaften bereit
  gestellt. Sie sollen damit dem Zellobjekt in der Migration zur Verf�gung
  gestellt werden.
  -----------------------------------------------------------------------------}
  /// <summary>
  ///   The interface of the migration object of TKomItem.
  /// </summary>
  /// <remarks>
  ///   It is implemented in the derivation TmoKomItem and contains all methods
  ///   of the "old" class. The ImiKomItem also opens up access to the old
  ///   world for cells. It thus allows a return to other classes, objects,
  ///   interfaces and methods.
  /// </remarks>
  ImiKomItem1 = interface(IsiOurPlantObject)
    ['{31B38390-CACD-4C1B-8228-CB812277AD89}']
    {$REGION 'migration of getter, setter and properties'}
    {$REGION  'Name of KomItem'}
    property IdName : string read siGetName write siSetName;
    {$ENDREGION}

    {$REGION  'Instance of controller KomList object'}
    /// <summary>
    ///   Get instance of controller KomList object
    /// </summary>
    function GetKomList : TKomList;
    /// <summary>
    ///   Set the controller of item as KomList
    /// </summary>
    procedure SetKomList(const aKomList : TKomList);
    /// <summary>
    ///   Read / Write the Controller of item as TKomList
    /// </summary>
    property KomList : TKomList read GetKomList write SetKomList;
    {$ENDREGION}

    {$REGION  'sub orientated component'}
    /// <summary>
    ///   Get the sub component
    /// </summary>
    function GetSubKomponente : TKomItem;
    /// <summary>
    ///   set the sub component
    /// </summary>
    procedure SetSubKomponente(const aKomItem : TKomItem);
    /// <summary>
    ///   Read / Write the sub orientated component
    /// </summary>
    property SubKomponente : TKomItem read GetSubKomponente write SetSubKomponente;
    {$ENDREGION}

    {$REGION  'external type name of unit'}
    /// <summary>
    ///   Get the external type name of unit
    /// </summary>
    function GetTypBezeichnung : string;
    /// <summary>
    ///   Set the external type name of unit
    /// </summary>
    procedure SetTypBezeichnung(const aName : string);
    /// <summary>
    ///   Describe (read / write) the external type name of unit
    /// </summary>
    property TypBezeichnung : string read GetTypBezeichnung write SetTypBezeichnung;
    {$ENDREGION}

    {$REGION  'version name of unit'}
    /// <summary>
    ///   Get the version name of the unit
    /// </summary>
    function GetVersionName : string;
    /// <summary>
    ///   Set the version name of unit
    /// </summary>
    procedure SetVersionName(const aVersionName : string);
    /// <summary>
    ///   Read / Write version name of unit behind KomItem
    /// </summary>
    property VersionName : string read GetVersionName write SetVersionName;
    {$ENDREGION}

    {$REGION  'switch off sequences'}
    /// <summary>
    ///   Get the flag that the unit always switched off
    /// </summary>
    function GetImmerAusschalten : Boolean;
    /// <summary>
    ///   Set that the unit always switched off
    /// </summary>
    procedure SetImmerAusschalten(const aValue : Boolean);
    /// <summary>
    ///   read / write the flag that the unit always switched off
    /// </summary>
    property ImmerAusschalten : Boolean read GetImmerAusschalten write SetImmerAusschalten;

    /// <summary>
    ///   Get the flag that the unit never switched off
    /// </summary>
    function GetNieAusschalten : Boolean;
    /// <summary>
    ///   Set that the unit never switched off
    /// </summary>
    procedure SetNieAusschalten(const aValue : Boolean);
    /// <summary>
    ///   read / write the flag that the unit never switched off
    /// </summary>
    property NieAusschalten : Boolean read GetNieAusschalten write SetNieAusschalten;
    {$ENDREGION}

    {$REGION  'locking area'}
    /// <summary>
    ///   get the status that the unit use a locking area
    /// </summary>
    function GetSperrBereichAktiv : Boolean;
    /// <summary>
    ///   Set the status that the unit use a locking area
    /// </summary>
    procedure SetSperrBereichAktiv(const aValue : Boolean);
    /// <summary>
    ///   Read /write the status that the unit use a locking area
    /// </summary>
    property SperrBereichAktiv : Boolean read GetSperrBereichAktiv write SetSperrBereichAktiv;

    /// <summary>
    ///   Get the miniumum range in X of locking area.
    /// </summary>
    function GetSperrBereichXMin : Extended;
    /// <summary>
    ///   Set the miniumum range in X of locking area.
    /// </summary>
    procedure SetSperrBereichXMin( const aValue : Extended);
    /// <summary>
    ///   Read / write the miniumum range in X of locking area.
    /// </summary>
    property SperrBereichXMin : Extended read GetSperrBereichXMin write SetSperrBereichXMin;

    /// <summary>
    ///   Get the max. range in X of locking area.
    /// </summary>
    function GetSperrBereichXMax : Extended;
    /// <summary>
    ///   Set the max. range in X of locking area.
    /// </summary>
    procedure SetSperrBereichXMax( const aValue : Extended);
    /// <summary>
    ///   Read / write the mmaximum range in X of locking area.
    /// </summary>
    property SperrBereichXMax : Extended read GetSperrBereichXMax write SetSperrBereichXMax;

    /// <summary>
    ///   Get the miniumum range in Y of locking area.
    /// </summary>
    function GetSperrBereichYMin : Extended;
    /// <summary>
    ///   Set the miniumum range in Y of locking area.
    /// </summary>
    procedure SetSperrBereichYMin( const aValue : Extended);
    /// <summary>
    ///   Read / write the miniumum range in Y of locking area.
    /// </summary>
    property SperrBereichYMin : Extended read GetSperrBereichYMin write SetSperrBereichYMin;

    /// <summary>
    ///   Get the max. range in Y of locking area.
    /// </summary>
    function GetSperrBereichYMax : Extended;
    /// <summary>
    ///   Set the max. range in Y of locking area.
    /// </summary>
    procedure SetSperrBereichYMax( const aValue : Extended);
    /// <summary>
    ///   Read / write the mmaximum range in Y of locking area.
    /// </summary>
    property SperrBereichYMax : Extended read GetSperrBereichYMax write SetSperrBereichYMax;
    {$ENDREGION}

    {$REGION  'unit as a 3D placing head'}
    /// <summary>
    ///   Get the flag, that the unit is a 3D placing head
    /// </summary>
    function GetIst3DBK : Boolean;
    /// <summary>
    ///   Set the flag, the unit is a 3D placing head
    /// </summary>
    procedure SetIst3DBK(const aValue : Boolean);
    /// <summary>
    ///   Read / Write flag, that the unit is a 3D placing head
    /// </summary>
    property Ist3DBK : Boolean read GetIst3DBK write SetIst3DBK;
    {$ENDREGION}

    {$REGION  'unit is a tool changer'}
    /// <summary>
    ///   Get the flag, that the unit is a tool changer
    /// </summary>
    function GetWerkzeugwechsler : Boolean;
    /// <summary>
    ///   Set the flag, that the unit is a tool changer
    /// </summary>
    procedure SetWerkzeugwechsler( const aValue : Boolean);
    /// <summary>
    ///   Read / write for unit is a tool changer
    /// </summary>
    property Werkzeugwechsler : Boolean read GetWerkzeugwechsler write SetWerkzeugwechsler;
    {$ENDREGION}

    {$REGION  'unit is a substrate fixture'}
    /// <summary>
    ///   Get the flag, that the unit is a substrate fixture
    /// </summary>
    function GetSubstratFix : Boolean;
    /// <summary>
    ///   Set the flag, that the unit is a substrate fixture
    /// </summary>
    procedure SetSubstratFix( const aValue : Boolean);
    /// <summary>
    ///   read / write that the unit is a tool changer
    /// </summary>
    property SubstratFix : Boolean read GetSubstratFix write SetSubstratFix;
    {$ENDREGION}

    {$REGION  'unit ist a part magazine fixture'}
    /// <summary>
    ///   Get the flag, that the unit is a part magazine fixture
    /// </summary>
    function GetBauteilFix : Boolean;
    /// <summary>
    ///   Set the flag, that the unit is a part magazine fixture
    /// </summary>
    procedure SetBauteilFix( const aValue : Boolean);
    /// <summary>
    ///   read / write that the unit is a part magazine fixture
    /// </summary>
    property BauteilFix : Boolean read GetBauteilFix write SetBauteilFix;
    {$ENDREGION}

    {$REGION  'unit is a dropping container'}
    /// <summary>
    ///   Get the flag, that the unit is a dropping container
    /// </summary>
    function GetAbwurfFix : Boolean;
    /// <summary>
    ///   Set the flag, that the unit is a dropping container
    /// </summary>
    procedure SetAbwurfFix( const aValue : Boolean);
    /// <summary>
    ///   read / write that the unit is a dropping container
    /// </summary>
    property AbwurfFix : Boolean read GetAbwurfFix write SetAbwurfFix;
    {$ENDREGION}

    {$REGION  'unit is a dosing head'}
    /// <summary>
    ///   Get flag, that the unit is a dosing head
    /// </summary>
    function GetDosierkopf : Boolean;
    /// <summary>
    ///   Set flag, that the unit is a dosing head
    /// </summary>
    procedure SetDosierkopf( const aValue : Boolean);
    /// <summary>
    ///   read / write that the unit is a dosing head
    /// </summary>
    property Dosierkopf : Boolean read GetDosierkopf write SetDosierkopf;
    {$ENDREGION}

    {$REGION  'unit is a 3d support fixture'}
    /// <summary>
    ///   get that the unit is a 3d support fixture
    /// </summary>
    function GetDreiDAufnahme: Boolean;
    /// <summary>
    ///   Set that the unit is a 3d support fixture
    /// </summary>
    procedure SetDreiDAufnahme(const aValue: Boolean);
    /// <summary>
    ///   read / write that the unit is a 3d support fixture
    /// </summary>
    property DreiDAufnahme: Boolean read GetDreiDAufnahme write SetDreiDAufnahme;
    {$ENDREGION}

    {$REGION  'support unit is feedable'}
    /// <summary>
    ///   get that the support unit is feedable
    /// </summary>
    function GetVorschubFaehig: Boolean;
    /// <summary>
    ///   Set that the support unit is feedable
    /// </summary>
    procedure SetVorschubFaehig(const aValue: Boolean);
    /// <summary>
    ///   read / write that the support unit is feedable
    /// </summary>
    property VorschubFaehig: Boolean read GetVorschubFaehig write SetVorschubFaehig;
    {$ENDREGION}

    {$REGION  'unit is a transport system (conveyor)'}
    /// <summary>
    ///   get that unit is a transport system (conveyor)
    /// </summary>
    function GetTransportSystem: Boolean;
    /// <summary>
    ///   Set that unit is a transport system (conveyor)
    /// </summary>
    procedure SetTransportSystem(const aValue: Boolean);
    /// <summary>
    ///   read / write unit is a transport system (conveyor)
    /// </summary>
    property TransportSystem: Boolean read GetTransportSystem write SetTransportSystem;
    {$ENDREGION}

    {$REGION  'unit is or has a I/O module'}
    /// <summary>
    ///   get that unit is or has a I/O module
    /// </summary>
    function GetIOModul: Boolean;
    /// <summary>
    ///   Set that unit is or has a I/O module
    /// </summary>
    procedure SetIOModul(const aValue: Boolean);
    /// <summary>
    ///   read / write unit is or has a I/O module
    /// </summary>
    property IOModul: Boolean read GetIOModul write SetIOModul;
    {$ENDREGION}

    {$REGION  'unit is or has a analouge I/O module'}
    /// <summary>
    ///   get that unit is or has a analouge I/O module
    /// </summary>
    function GetAnalogModul: Boolean;
    /// <summary>
    ///   Set that unit is or has a analouge I/O module
    /// </summary>
    procedure SetAnalogModul(const aValue: Boolean);
    /// <summary>
    ///   read / write unit is or has a analouge I/O module
    /// </summary>
    property AnalogModul: Boolean read GetAnalogModul write SetAnalogModul;
    {$ENDREGION}

    {$REGION  'unit is a clamping support'}
    /// <summary>
    ///   get that unit is a clamping support
    /// </summary>
    function GetKlemmAufnahme: Boolean;
    /// <summary>
    ///   Set that unit is a clamping support
    /// </summary>
    procedure SetKlemmAufnahme(const aValue: Boolean);
    /// <summary>
    ///   read / write unit is a clamping support
    /// </summary>
    property KlemmAufnahme: Boolean read GetKlemmAufnahme write SetKlemmAufnahme;
    {$ENDREGION}

    {$REGION  'unit as wafer system use a saw ring'}
    /// <summary>
    ///   get that the unit as wafer system use a saw ring
    /// </summary>
    function GetWAESaegering: Boolean;
    /// <summary>
    ///   Set that the unit as wafer system use a saw ring
    /// </summary>
    procedure SetWAESaegering(const aValue: Boolean);
    /// <summary>
    ///   read / write unit as wafer system use a saw ring
    /// </summary>
    property WAESaegering: Boolean read GetWAESaegering write SetWAESaegering;
    {$ENDREGION}

    {$REGION  'unit do eject the part during pickup'}
    /// <summary>
    ///   get that the unit do eject the part during pickup
    /// </summary>
    function GetAustechen: Boolean;
    /// <summary>
    ///   Set that the unit do eject the part during pickup
    /// </summary>
    procedure SetAustechen(const aValue: Boolean);
    /// <summary>
    ///   read / write unit do eject the part during pickup
    /// </summary>
    property Austechen: Boolean read GetAustechen write SetAustechen;
    {$ENDREGION}

    {$REGION  'current choise of place (compartment)'}
    /// <summary>
    ///   get current choise of place (compartment)
    /// </summary>
    function GetAktuellePlatzWahl: LongInt;
    /// <summary>
    ///   Set current choise of place (compartment)
    /// </summary>
    procedure SetAktuellePlatzWahl(const aValue: LongInt);
    /// <summary>
    ///   read / write current choise of place (compartment)
    /// </summary>
    property AktuellePlatzWahl: LongInt read GetAktuellePlatzWahl write SetAktuellePlatzWahl;
    {$ENDREGION}

    {$REGION  'unit work with Y axis'}
    /// <summary>
    ///   get unit work with Y axis
    /// </summary>
    function GetYAktiv: Boolean;
    /// <summary>
    ///   Set unit work with Y axis
    /// </summary>
    procedure SetYAktiv(const aValue: Boolean);
    /// <summary>
    ///   read / write unit work with Y axis
    /// </summary>
    property YAktiv: Boolean read GetYAktiv write SetYAktiv;
   {$ENDREGION}

    {$REGION  'current scan text'}
    /// <summary>
    ///   get current scan text
    /// </summary>
    function GetScannerText: string;
    /// <summary>
    ///   Set current scan text
    /// </summary>
    procedure SetScannerText(const aValue: string);
    /// <summary>
    ///   read / write current scan text
    /// </summary>
    property ScannerText: string read GetScannerText write SetScannerText;
    {$ENDREGION}

    {$REGION  'Z axis'}
    /// <summary>
    ///   get factor SI to increments for z axis
    /// </summary>
    function GetSIInkrementeZ: Extended;
    /// <summary>
    ///   Set factor SI to increments for z axis
    /// </summary>
    procedure SetSIInkrementeZ(const aValue: Extended);
    /// <summary>
    ///   read / write factor SI to increments for z axis
    /// </summary>
    property SIInkrementeZ: Extended read GetSIInkrementeZ write SetSIInkrementeZ;

    /// <summary>
    ///   get Z axis zero offset
    /// </summary>
    function GetNullpunktZ: Extended;
    /// <summary>
    ///   Set Z axis zero offset
    /// </summary>
    procedure SetNullpunktZ(const aValue: Extended);
    /// <summary>
    ///   read / write Z axis zero offset
    /// </summary>
    property NullpunktZ: Extended read GetNullpunktZ write SetNullpunktZ;

    /// <summary>
    ///   get Z axis never switched off
    /// </summary>
    function GetNieAusschaltenZ: Boolean;
    /// <summary>
    ///   Set Z axis never switched off
    /// </summary>
    procedure SetNieAusschaltenZ(const aValue: Boolean);
    /// <summary>
    ///   read / write Z axis never switched off
    /// </summary>
    property NieAusschaltenZ: Boolean read GetNieAusschaltenZ write SetNieAusschaltenZ;
    {$ENDREGION}

    {$REGION  'cam & recognition unit'}
    /// <summary>
    ///   get the reference of interface to cam 1
    /// </summary>
    function GetCamChannel1: ICameraChannel;
    /// <summary>
    ///   set the reference of interface to cam 1
    /// </summary>
    procedure SetCamChannel1(aCamChannel: ICameraChannel);
    /// <summary>
    ///   read / write the reference of interface to cam 1
    /// </summary>
    property Kamera1: ICameraChannel read GetCamChannel1 write SetCamChannel1;

    /// <summary>
    ///   get the reference of interface to cam 2
    /// </summary>
    function GetCamChannel2: ICameraChannel;
    /// <summary>
    ///   set the reference of interface to cam 2
    /// </summary>
    procedure SetCamChannel2(aCamChannel: ICameraChannel);
    /// <summary>
    ///   read / write the reference of interface to cam 1
    /// </summary>
    property Kamera2: ICameraChannel read GetCamChannel2 write SetCamChannel2;

    /// <summary>
    ///   Get that the unit has cams
    /// </summary>
    function GetHasCams: Boolean;
    /// <summary>
    ///   Set that the unit has cams
    /// </summary>
    procedure SetHasCams(const aValue: Boolean);
    /// <summary>
    ///   read / write that the unit has cams
    /// </summary>
    property HasCams: Boolean read GetHasCams write SetHasCams;

    /// <summary>
    ///   Get the reference to RGBI migration interface for last light setting
    ///   of cam teach in
    /// </summary>
    function CamLichtMem: ImiRGBI;

    /// <summary>
    ///   get the gain setting of cam teach in
    /// </summary>
    function GetCamGainMem: LongInt;
    /// <summary>
    ///   set the gain setting of cam teach in
    /// </summary>
    procedure SetCamGainMem(aValue: LongInt);
    /// <summary>
    ///   read / write the gain setting of cam teach in
    /// </summary>
    property CamGainMem: LongInt read GetCamGainMem write SetCamGainMem;

    /// <summary>
    ///   get the last zoom setting of cam teach in
    /// </summary>
    function GetCAMZoomMem: extended;
    /// <summary>
    ///   set the last zoom setting of cam teach in
    /// </summary>
    procedure SetCAMZoomMem(aValue: extended);
    /// <summary>
    ///   read / write the last zoom setting of cam teach in
    /// </summary>
    property CAMZoomMem: extended read GetCAMZoomMem write SetCAMZoomMem;

    /// <summary>
    ///   get the last dx value of teachIn cam window
    /// </summary>
    function GetCamDxMem: extended;
    /// <summary>
    ///   set the last dx value of teachIn cam window
    /// </summary>
    procedure SetCamDxMem(aValue: extended);
    /// <summary>
    ///   read / write the last dx value of teachIn cam window
    /// </summary>
    property CamDxMem: extended read GetCamDxMem write SetCamDxMem;

    /// <summary>
    ///   get the last dy value of teachIn cam window
    /// </summary>
    function GetCamDyMem: extended;
    /// <summary>
    ///   set the last dy value of teachIn cam window
    /// </summary>
    procedure SetCamDyMem(aValue: extended);
    /// <summary>
    ///   read / write the last dy value of teachIn cam window
    /// </summary>
    property CamDyMem: extended read GetCamDyMem write SetCamDyMem;

    /// <summary>
    ///   Get the reference of RGBI migration interface of current light
    ///   setup
    /// </summary>
    function AktuellesLicht : ImiRGBI;

    /// <summary>
    ///   Get positive focal point offset
    /// </summary>
    function GetPosBrennpunktVerschiebung : Extended;
    /// <summary>
    ///   Set positive focal point offset
    /// </summary>
    procedure SetPosBrennpunktVerschiebung(const aValue: Extended);
    /// <summary>
    ///   Read / write positive focal point offset
    /// </summary>
    property PosBrennpunktVerschiebung: Extended read GetPosBrennpunktVerschiebung
     write SetPosBrennpunktVerschiebung;

    /// <summary>
    ///   Get negative focal point offset
    /// </summary>
    function GetNegBrennpunktVerschiebung : Extended;
    /// <summary>
    ///   Set negative focal point offset
    /// </summary>
    procedure SetNegBrennpunktVerschiebung(const aValue: Extended);
    /// <summary>
    ///   Read / write positive focal point offset
    /// </summary>
    property NegBrennpunktVerschiebung: Extended read GetNegBrennpunktVerschiebung
     write SetNegBrennpunktVerschiebung;
    {$ENDREGION}

    {$REGION  'xxx'}
    {$ENDREGION}

    {$REGION  'xxx'}
    {$ENDREGION}

    {$REGION  'xxx'}
    {$ENDREGION}

    {$REGION  'xxx'}
    {$ENDREGION}

    {$REGION  'xxx'}
    {$ENDREGION}

    {$ENDREGION}
  end;
  {$ENDREGION}

  {$REGION 'TmoKomItem - migration object of KomItem'}
  //[RegisterCellType('KomItem migration modul','{794B4EFF-EE7F-4E2F-85D8-6D31C1D7B969}')]
  TmoKomItem = class(TKomItem, ImiKomItem1)
  strict protected
  public
    {$REGION 'Object construction and other class operations'}
    {$ENDREGION}
  end;
  {$ENDREGION}

implementation

uses
  System.SysUtils;

{$REGION 'TmoKomItem implementation'}
{$ENDREGION}



end.
