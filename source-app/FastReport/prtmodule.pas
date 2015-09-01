unit prtmodule;
interface
uses Windows, SysUtils, Printers, Variants, Classes;

type
  TPrnBuffRec = record
  bufflength: Word;
  Buff_1: array[0..255] of Char;
end;


function DirectToPrinter(S: string; NextLine: Boolean): Boolean;
function GetTempDirectory: String;
function PrintFile(afile:string):boolean;
function GetDefaultPrinter: string;
function StringPrints(ts:TStrings):boolean;

implementation

function DirectToPrinter(S: string; NextLine: Boolean): Boolean;
var
  Buff: TPrnBuffRec;
  TestInt: Integer;
begin
  TestInt := PassThrough;
  if Escape(Printer.Handle, QUERYESCSUPPORT, SizeOf(TESTINT), @testint, nil) > 0 then
  begin
    if NextLine then  S := S + #13 + #10;
    StrPCopy(Buff.Buff_1, S);
    Buff.bufflength := StrLen(Buff.Buff_1);
    Escape(Printer.Canvas.Handle, Passthrough, 0, @buff, nil);
    Result := True;
  end
  else
    Result := False;
end;

function GetTempDirectory: String;
var
  tempFolder: array[0..MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, @tempFolder);
  result := StrPas(tempFolder);
end;

function GetDefaultPrinter: string;
var
  ResStr: array[0..255] of Char;
begin
  GetProfileString('Windows', 'device', '', ResStr, 255);
  Result := StrPas(ResStr);
end;

function PrintFile(afile:string):boolean;
var myFile:TextFile;
    s:string;
begin
  result := False;
  AssignFile(myFile, afile);
  Reset(myFile);
  if Not Eof(myfile) then
  begin
    try
      printer.BeginDoc;
      try
        while not Eof(myFile) do
        begin
          ReadLn(myFile, s);
          DirectToPrinter(s,True);
        end;
      finally
        printer.EndDoc;
        result := true;
      end
    except
      on e:exception do
      begin
      end;
    end;
  end
  else
  begin
      //todo exception create
      //if fdebug then
      //  memo1.Lines.Add('File Empty');
  end;
  CloseFile(myFile);
end;

function StringPrints(ts:TStrings):boolean;
var i:integer;
    s:string;
begin
  result:=false;
  try
    printer.BeginDoc;
    try
       for i:=0 to ts.Count-1 do
          DirectToPrinter(ts[i],True);
    finally
      printer.EndDoc;
      result := true;
    end
  except
    on e:exception do
    begin
    end;
  end;
end;

end.
