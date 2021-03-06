// *****************************************************************************
//
//                       OurPlant OS Architecture
//                             for Delphi
//                                2019
//
// Copyrights 2019 @ H�cker Automation GmbH
// *****************************************************************************
unit OurPlant.Samples.CellObject;

interface

uses
  OurPlant.Common.CellObject,
  OurPlant.Common.DataCell,
  OurPlant.Samples.SkillInterface;

const
  C_TEST_CHILD_NAME=     'Cell Object Sample';
  C_TEST_CHILD_Type=     '{69B8A5C8-F7AB-4360-BA6D-65DA714B1E70}';
  C_TEST_CHILD_INTEGER=  66;
  C_TEST_CHILD_MIN=      -100;
  C_TEST_CHILD_MAX=      100;

type
  // Declaration of the skill interface sample IsiTestValueGetter
  IsiTestValueGetter = interface(IsiCellObject)
    ['{9998AC3A-6C66-4697-A643-5C5A13B7A8FD}']
    function siTestValueGetterGetIntegerField : Integer;
    procedure siTestValueGetterSetIntegerField(const aInteger : Integer);
    property siTestValueGetterIntegerField : Integer read siTestValueGetterGetIntegerField write siTestValueGetterSetIntegerField;

    function siTestValueGetterIntegerCell : IsiInteger;
  end;

  // Declaration of the cell object to the skill interface sample IsiTestValueGetter
  [RegisterCellType( C_TEST_CHILD_NAME, C_TEST_CHILD_Type)]   // Register the sample cell object class in DM

  [NewCell( TcoString, 'TestString', 'default text for TestString' )]
  [NewCell( TcoString, 'TestString/SubString', 'text additional sub string')]
  [NewCell( TcoString, 'TestString/SubString/SubSubString', 'text additional sub sub string')]

  TCellObjectTestChild = class(TCellObject, IsiTestValueGetter)
  public // commons of TCellObjectTestChild
    /// <summary>
    ///  construction of cell content & structures and set defaults
    ///  Are called at the end of AfterConstruction of TCellobject. Derivate's
    ///  overrides this method to define and construct the cell structure and
    ///  settings.
    /// </summary>
    procedure CellConstruction; override;

  strict protected
    // sample for internal working field, setted to a default value
    fIntegerField : Integer;

    // sample for an public data cell (Integer)
    [NewCell( TcoInteger, 'IntegerCell', C_TEST_CHILD_INTEGER)]
    fIntegerCell : IsiInteger;

  public
    // implementation of skill interface IsiTestValueGetter
    function siTestValueGetterGetIntegerField : Integer;
    procedure siTestValueGetterSetIntegerField(const aInteger : Integer);
    function siTestValueGetterIntegerCell : IsiInteger;

  end;

implementation

uses
  System.Rtti,
  System.SysUtils;

{ TCellObjectTestChildClass }

procedure TCellObjectTestChild.CellConstruction;
begin
  inherited;

  // set default of a simple work field sample
  fIntegerField := C_TEST_CHILD_INTEGER;

  // construct new sub cell structure as string cell and set defaults
  // this cell
  //   TestString          = 'default text for TestString'
  //      SubStrng         = 'text additional sub string'
  //         SubSubString  = 'text additional sub sub string'
  //   TestBoolean         = true
  //   TestDate            = 1.1.2020
  //   TestTime            = current time
  //   TestDateTime        = curent date + time
  //   IntegerCell         = C_TEST_CHILD_INTEGER

  ConstructNewCell(TcoString,'TestString').siAsString :=
    'default text for TestString';
  ConstructNewCell(TcoString,'TestString/SubString').siAsString :=
    'text additional sub string';
  ConstructNewCell(TcoString,'TestString/SubString/SubSubString').siAsString :=
    'text additional sub sub string';

  // construct boolean data cell and set default value
  ConstructNewCellAs<IsiBoolean>(TcoBoolean,'TestBoolean').siAsBoolean := True;

  // construct Date/Time cell and set the current date and time
  ConstructNewCellAs<IsiDateTime>(TcoDate,'TestDate').siAsString := '1.1.2020';
  ConstructNewCellAs<IsiDateTime>(TcoTime,'TestTime').siAsDateTime := Time;
  ConstructNewCellAs<IsiDateTime>(TcoDateTime,'TestDateTime').siAsDateTime := Now;

  // Add existing cells in other sub cell lists
  // destination empty -> Add TestString/SubString/SubSubString in this cell list
  ConstructCell('TestString/SubString/SubSubString');

  // construct existing "TestBoolean" in sub cell list of "TestString"
  ConstructCell('TestBoolean', 'TestString');

  // add existing "TestDate" in sub cell list of  "TestString\SubString"
  ConstructCell('TestDate', 'TestString/SubString');

  // construct a sample for an public data cell (Integer)
  //fIntegerCell := ConstructNewCellAs<IsiInteger>(TcoInteger,'IntegerCell');
  //fIntegerCell.siAsInteger := C_TEST_CHILD_INTEGER; // set the default to C_TEST_CHILD_INTEGER

end;

// Implementation of skill interface methods of cell object
function TCellObjectTestChild.siTestValueGetterGetIntegerField: Integer;
begin
  Result := fIntegerField;
end;

procedure TCellObjectTestChild.siTestValueGetterSetIntegerField(const aInteger : Integer);
begin
  fIntegerField:= aInteger;
end;

function TCellObjectTestChild.siTestValueGetterIntegerCell : IsiInteger;
begin
  Result:= fIntegerCell;
end;

end.
