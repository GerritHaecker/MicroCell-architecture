// *****************************************************************************
//
//                            OurPlant OS
//                       Micro Cell Architecture
//                             for Delphi
//                            2019 / 2020
//
// Copyright (c) 2019-2021 Gerrit H�cker
// Copyright (c) 2019-2021 H�cker Automation GmbH
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
//    Gerrit H�cker (2019 - 2021)
// *****************************************************************************

unit OurPlant.Sample.CellSample1;

interface

uses
  OurPlant.Common.CellObject,
  OurPlant.Common.DataCell,
  OurPlant.Samples.SkillInterface;

type
  {$REGION 'TcoCellSampleA'}
  [RegisterCellType( 'Cell Sample A', '{BF0E6FCC-AD04-44EF-9BFC-CEBC93F21FF8}')]
  TcoCellSampleA = class(TCellObject, IsiCellObject)

  end;
  {$ENDREGION}
  {$REGION 'TcoCellSampleB'}
  [RegisterCellType( 'Cell Sample B', '{AECD48D4-782B-45F1-AD17-224CAB16AA28}')]
  TcoCellSampleB = class(TCellObject, IsiCellObject)
  strict protected
    [NewCell( TcoInteger, 'Mein Integer', 99846)]
    fsiMeinInteger : IsiInteger;

    [NewCell( TcoString, 'Mein String', 'Test')]
    fsiMeinString : IsiString;

    [NewCell( TcoInteger, 'Mein String/Hat auch ein Integer', '0815')]
    fsiMeinStringSeinInteger : IsiInteger;

  public
    procedure CellConstruction; override;
  end;
  {$ENDREGION}
  {$REGION 'TcoCellSampleC - Einfache Implementierung von Skill-Interface'}
  [RegisterCellType( 'Cell Sample C', '{7DC28566-D552-482A-852E-4F86E87DEEDF}')]
  TcoCellSampleC = class(TcoFirstSkill1, IsiFirstSkill1)
  strict protected
    [NewCell( TcoInteger, 'Mein Integer', 99846)]
    fsiMeinInteger : IsiInteger;

  strict protected
    function siGetInteger : Integer; override;
    procedure siSetInteger(const aInteger : Integer); override;

  end;
  {$ENDREGION}
  {$REGION 'TcoCellSampleD - Andocken eines Skill-Interface-Adapters'}
  [RegisterCellType( 'Cell Sample D', '{2484C511-D8BD-4299-BA7D-D6984FC0CAFF}')]
  TcoCellSampleD = class(TCellObject, IsiFirstSkill1)
  public
    procedure CellConstruction; override;

  strict protected
    [NewCell( TcoInteger, 'Mein Integer', 99846)]
    fsiMeinInteger : IsiInteger;

    [IndependentCell( TsiFirstSkill1, 'First skill')]
    fsiFirstSkill : IsiFirstSkill1;

    [IndependentCell( TsiFirstSkill1, 'Second skill')]
    fsiSecondSkill : IsiFirstSkill1;

    property FirstSkill : IsiFirstSkill1 read fsiFirstSkill implements IsiFirstSkill1;

  strict private
    //[OnReadCell('FirstSkill/siInteger')]
    procedure OnGetInteger(const aSender : IsiCellObject);
    procedure OnSetInteger(const aSender : IsiCellObject);

    procedure OnGetInteger2(const aSender : IsiCellObject);
    procedure OnSetInteger2(const aSender : IsiCellObject);

  end;
  {$ENDREGION}
  {$REGION 'TcoDesposedCell - Abgesetzte Zelle von Cell Sample E'}
  TcoDeposedCell = class(TcoFirstSkill1, IsiFirstSkill1)
  strict protected
    [NewCell( TcoCellReference, 'Integer_Ref' )]
    fsiMeinIntegerRef : IsiCellReference;

    function siGetInteger : Integer; override;
    procedure siSetInteger(const aInteger : Integer); override;
  end;
  {$ENDREGION}
  {$REGION 'TcoCellSampleE - Andocken einer abgesetzten Skill-Interface-Zelle'}
  [RegisterCellType( 'Cell Sample E', '{2484C511-D8BD-4299-BA7D-D6984FC0CAFF}')]
  TcoCellSampleE = class(TCellObject, IsiFirstSkill1)
  public
    procedure CellConstruction; override;

  strict protected
    [IndependentCell( TcoDeposedCell, 'First skill')]
    fsiFirstSkill : IsiFirstSkill1;

    [NewCell( TcoInteger, 'Mein Integer', 99846)]
    fsiMeinInteger : IsiInteger;

    property FirstSkill : IsiFirstSkill1 read fsiFirstSkill implements IsiFirstSkill1;
  end;
  {$ENDREGION}
implementation

{$REGION 'TcoCellSampleB implementierung'}
procedure TcoCellSampleB.CellConstruction;
begin
  inherited;

  //fsiMeinInteger := ConstructNewCellAs<IsiInteger>( TcoInteger, 'Mein Integer' );
  //fsiMeinInteger.siAsInteger := 99846;
end;
{$ENDREGION}
{$REGION 'TcoCellSampleC implementierung'}
function TcoCellSampleC.siGetInteger : Integer;
begin
  Result := fsiMeinInteger.siAsInteger;
end;

procedure TcoCellSampleC.siSetInteger(const aInteger : Integer);
begin
  fsiMeinInteger.siAsInteger := aInteger;
end;
{$ENDREGION}
{$REGION 'TcoCellSampleD implementierung'}
procedure TcoCellSampleD.CellConstruction;
begin
  inherited;
  with ValidCell( fsiFirstSkill.siGetSubCell('siInteger')) do
  begin
    siOnRead  := OnGetInteger;
    siOnWrite := OnSetInteger;
  end;

  with ValidCell( fsiSecondSkill.siGetSubCell('siInteger')) do
  begin
    siOnRead  := OnGetInteger2;
    siOnWrite := OnSetInteger2;
  end;

end;

procedure TcoCellSampleD.OnGetInteger(const aSender : IsiCellObject);
begin
  CellAs<IsiInteger>( aSender).siAsInteger := fsiMeinInteger.siAsInteger;
end;

procedure TcoCellSampleD.OnSetInteger(const aSender : IsiCellObject);
begin
  fsiMeinInteger.siAsInteger := CellAs<IsiInteger>( aSender).siAsInteger;
end;

procedure TcoCellSampleD.OnGetInteger2(const aSender : IsiCellObject);
begin
  CellAs<IsiInteger>( aSender).siAsInteger := fsiMeinInteger.siAsInteger + 100;
end;

procedure TcoCellSampleD.OnSetInteger2(const aSender : IsiCellObject);
begin
  fsiMeinInteger.siAsInteger := CellAs<IsiInteger>( aSender).siAsInteger - 100;
end;


{$ENDREGION}
{$REGION 'TcoDesposedCell von Cell Sample E Implementierung'}
function TcoDeposedCell.siGetInteger : Integer;
begin
  if not IsValidAs<IsiInteger>( fsiMeinIntegerRef.siAsCell ) then
    Exit(0);

  Result := CellAs<IsiInteger>( fsiMeinIntegerRef.siAsCell ).siAsInteger
end;

procedure TcoDeposedCell.siSetInteger(const aInteger : Integer);
begin
  if not IsValid( fsiMeinIntegerRef.siAsCell ) then
    Exit;

  CellAs<IsiInteger>( fsiMeinIntegerRef.siAsCell ).siAsInteger := aInteger;
end;
{$ENDREGION}
{$REGION 'TcoCellSampleE implementierung'}
procedure TcoCellSampleE.CellConstruction;
var
  vRef : IsiCellReference;
begin
  inherited;

  if IsValidAs<IsiCellReference>( FirstSkill.siGetSubCell( 'Integer_Ref'), vRef ) then
    vRef.siAsCell := fsiMeinInteger;
end;
{$ENDREGION}

initialization
  TcoCellSampleA.RegisterExplicit;
  TcoCellSampleB.RegisterExplicit;
  TcoCellSampleC.RegisterExplicit;
  TcoCellSampleD.RegisterExplicit;
  TcoDeposedCell.RegisterExplicit;
  TcoCellSampleE.RegisterExplicit;
end.
