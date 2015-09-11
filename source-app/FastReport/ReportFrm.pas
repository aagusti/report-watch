unit ReportFrm;

{$I frx.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, frxDesgn, frxClass, frxDCtrl,
  frxChart, frxRich, frxBarcode, ImgList, ComCtrls, ExtCtrls, frxOLE,
  frxCross, frxDMPExport, frxExportImage, frxExportRTF,
  frxExportXML, frxExportXLS, frxExportHTML, frxGZip, frxExportPDF,
  frxADOComponents, frxChBox, frxExportText, frxExportCSV, frxExportMail,
  frxIBXComponents, frxDBXComponents, frxPreview, frxDBSet, ToolWin,
  FMTBcd, SqlExpr, {DBXQuery,} Menus, frxExportTXT, DBCtrls, Mask, ADODB,
  Grids, DBGrids, XMLIntf, XMLDoc, xmldom, msxmldom, Buttons, DirWatch,
  prtModule, IniFiles;

type
  PReport = ^TReportMenu;
  TReportMenu = record
    FileName: string;
    Param1: string;
    IsSKPD: boolean;
  end;

  TfrmFastReport = class(TForm)
    frxDesigner1: TfrxDesigner;
    frxBarCodeObject1: TfrxBarCodeObject;
    frxRichObject1: TfrxRichObject;
    frxDialogControls1: TfrxDialogControls;
    ImageList1: TImageList;
    frxOLEObject1: TfrxOLEObject;
    frxCrossObject1: TfrxCrossObject;
    frxDotMatrixExport1: TfrxDotMatrixExport;
    frxBMPExport1: TfrxBMPExport;
    frxJPEGExport1: TfrxJPEGExport;
    frxTIFFExport1: TfrxTIFFExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxXLSExport1: TfrxXLSExport;
    frxXMLExport1: TfrxXMLExport;
    frxRTFExport1: TfrxRTFExport;
    frxGZipCompressor1: TfrxGZipCompressor;
    frxPDFExport1: TfrxPDFExport;
    Label4: TLabel;
    frxCheckBoxObject1: TfrxCheckBoxObject;
    frxMailExport1: TfrxMailExport;
    frxCSVExport1: TfrxCSVExport;
    frxGIFExport1: TfrxGIFExport;
    frxSimpleTextExport1: TfrxSimpleTextExport;
    Panel3: TPanel;
    ImageList2: TImageList;
    imgButtons: TImageList;
    ilDaftarTV: TImageList;
    pmnuExport: TPopupMenu;
    mnEksTXT: TMenuItem;
    mnEksHTML: TMenuItem;
    mnEksRTF: TMenuItem;
    mnEksXLS: TMenuItem;
    mnEksPDF: TMenuItem;
    mnEksBMP: TMenuItem;
    mnEksJPG: TMenuItem;
    mnEksTIF: TMenuItem;
    pmnuZoom: TPopupMenu;
    N251: TMenuItem;
    N501: TMenuItem;
    N661: TMenuItem;
    N1001: TMenuItem;
    N2001: TMenuItem;
    N4001: TMenuItem;
    SelebarHalaman1: TMenuItem;
    SatuHalaman1: TMenuItem;
    DuaHalaman1: TMenuItem;
    frxTXTExport1: TfrxTXTExport;
    frxHTMLExport2: TfrxHTMLExport;
    frxADOComponents1: TfrxADOComponents;
    Splitter1: TSplitter;
    Panel1: TPanel;
    XMLDocument1: TXMLDocument;
    PopupMenu1: TPopupMenu;
    ambah1: TMenuItem;
    Edit1: TMenuItem;
    Hapus1: TMenuItem;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    DBConnection1: TMenuItem;
    Exit1: TMenuItem;
    About1: TMenuItem;
    Memo1: TMemo;
    Panel2: TPanel;
    btnStart: TBitBtn;
    btnStop: TBitBtn;
    btnTest: TBitBtn;
    btnDesign: TBitBtn;
    chkAutoPrint: TCheckBox;
    DirectoryWatch1: TDirectoryWatch;
    OpenDialog1: TOpenDialog;
    BitBtn1: TBitBtn;
    cboKertas: TComboBox;
    Label1: TLabel;
    con1: TADOConnection;
    DataSource1: TDataSource;
    frxReport1: TfrxReport;
    Label2: TLabel;
    ReportTemplate1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure frxReport1Preview(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnDesignClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frxReport1GetValue(const VarName: string;
      var Value: Variant);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DirectoryWatch1Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frxReport1AfterPrintReport(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure ReportTemplate1Click(Sender: TObject);
    procedure cboKertasChange(Sender: TObject);
  private
    { Private declarations }
    apppath: string;
    fr3dir: string;
    csvdir: string;
    csvdirnm: string;
    afilename: string;
    testing: boolean;
    inifile: tinifile;

    procedure get_paper;
    procedure getfilelist;
    procedure print(wpath, filenm: string);
  public
    { Public declarations }

  end;

var
  frmFastReport: TfrmFastReport;

implementation

{$R *.DFM}

procedure Deletefiles(APath, AFileSpec: string);
var
  lSearchRec: TSearchRec;
  lFind: integer;
  lPath: string;
begin
  lPath := IncludeTrailingPathDelimiter(APath);

  lFind := FindFirst(lPath + AFileSpec, faAnyFile, lSearchRec);
  while lFind = 0 do
  begin
    DeleteFile(lPath + lSearchRec.Name);

    lFind := SysUtils.FindNext(lSearchRec);
  end;
  FindClose(lSearchRec);
end;

procedure TfrmFastReport.DirectoryWatch1Change(Sender: TObject);
begin
  Memo1.Lines.Add('## Directory changed');
  getfilelist;
end;

procedure TfrmFastReport.getfilelist;
var
  WatchPath: string;
  SR: TSearchRec;
  FileHandle: Integer;
begin
  testing := False;

  WatchPath := DirectoryWatch1.Directory; //Get the path of the selected file
  try
    if FindFirst(WatchPath + '*.prn', faArchive, SR) = 0 then
    begin
      repeat
        afilename := WatchPath + SR.Name;
        //tunggu hingga file tercipta untukku.. apa coba
        FileHandle := FileOpen(afilename, fmOpenRead or fmShareExclusive);
        if FileHandle >= 0 then
        begin
          FileClose(FileHandle);
          print(WatchPath, SR.Name);
        end;
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;

    if FindFirst(WatchPath + '*.csv', faArchive, SR) = 0 then
    begin
      repeat
        afilename := WatchPath + SR.Name;
        //tunggu hingga file tercipta untukku.. apa coba
        FileHandle := FileOpen(afilename, fmOpenRead or fmShareExclusive);
        if FileHandle >= 0 then
        begin
          FileClose(FileHandle);
          print(WatchPath, SR.Name);
        end;
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
  except
    on e: exception do
      memo1.Lines.Add('## Exception: ' + e.Message)
  end;
end;

procedure TfrmFastReport.print(wpath, filenm: string);
var
  filename: string;
begin
  memo1.Lines.Add('');
  memo1.Lines.Add('## Load file: ' + ExtractFileName(afilename));
  if not FileExists(afilename) then
    memo1.Lines.Add('## File not found!');

  if UpperCase(extractFileExt(filenm)) = '.CSV' then
  begin
    con1.Close;
    con1.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
      'Data Source=' + wpath + ';' +
      'Extended Properties=''text;HDR=Yes;FMT=Delimited''';
    con1.Open;

    //qry1.SQL.Text:='select * from '+filenm;
    //qry1.Open;

    filename := csvdir + ChangeFileExt(filenm, '') + '.fr3';
    if not FileExists(filename) then
      memo1.Lines.Add('## Template not found!');
    frxreport1.LoadFromFile(filename);
  end
  else
  begin
    frxreport1.LoadFromFile(fr3dir + cboKertas.Items[cboKertas.ItemIndex]);
  end;

  if chkAutoPrint.Checked then
  begin
    frxReport1.PrepareReport(True);
    frxReport1.PrintOptions.ShowDialog := False;
    frxReport1.Print;
    frxReport1.Clear;
  end
  else
  begin
    frxReport1.PrintOptions.ShowDialog := True;
    frxReport1.ShowReport;
    Application.BringToFront;
  end;
end;

procedure TfrmFastReport.get_paper;
var
  SR: TSearchRec;
  idxname, filename: string;
begin
  idxname := cboKertas.Items.Strings[cboKertas.itemindex];

  cboKertas.Items.Clear;
  if FindFirst(fr3dir + '*.fr3', faArchive, SR) = 0 then
  begin
    repeat
      filename := fr3dir + SR.Name;
      cboKertas.Items.Add(SR.Name);
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
  if not (idxname = '') then
    cboKertas.ItemIndex := cboKertas.Items.IndexOf(idxname)
  else
    cboKertas.ItemIndex := 0;
end;

procedure TfrmFastReport.frxReport1Preview(Sender: TObject);
var
  frmPreview: TfrxPreviewForm;
begin
  frxReport1.PreviewOptions.Modal := False;
  frmPreview := TfrxPreviewForm(frxReport1.PreviewForm);
  //frmPreview := TfrxPreviewForm(frxReport1.PreviewPages);
  frmPreview.BorderStyle := bsNone;
  frmPreview.Parent := Panel3;
  frmPreview.Left := 0;
  frmPreview.Top := 0;
  frmPreview.Width := Panel1.ClientWidth;
  frmPreview.Height := Panel1.ClientHeight;
end;

procedure TfrmFastReport.btnTestClick(Sender: TObject);
begin
  OpenDialog1.InitialDir:= apppath + 'test\';
  if OpenDialog1.Execute then
  begin
    if not btnStart.Enabled then
    begin
      btnStop.Click();
    end;
    testing := True;
    afilename := OpenDialog1.FileName;
    print(extractFilePath(afilename), extractfilename(afilename));
  end;
end;

procedure TfrmFastReport.btnDesignClick(Sender: TObject);
begin
  frxReport1.DesignReport;
  get_paper;
  if(afilename<>'') and FileExists(afilename) then
    print(extractFilePath(afilename), extractfilename(afilename));
end;

procedure TfrmFastReport.FormCreate(Sender: TObject);
var
  Locale: LongInt;
begin
  //set locale to en - ngaruh
  Locale := GetUserDefaultLCID();
  SetLocaleInfo(Locale, LOCALE_SThousand, ',');
  SetLocaleInfo(Locale, LOCALE_SDecimal, '.');
  SendMessage(HWND_BROADCAST, WM_WININICHANGE, 0, 0);

  //init
  apppath := ExtractFilePath(Application.ExeName);

  inifile := TIniFile.Create(appPath + 'config.ini');
  csvdirnm := inifile.ReadString('General', 'csvdirnm', 'test');
  label1.Caption := inifile.ReadString('General', 'tmpdir', getTempDirectory);
  cboKertas.ItemIndex := inifile.ReadInteger('General', 'kertas', 0);
  chkAutoPrint.Checked := inifile.ReadBool('General', 'autoprint', False);
                                                  
  fr3dir  := apppath + 'fr3\';
  csvdir  := fr3dir + csvdirnm + '\';
  testing := True;
  get_paper;

  DirectoryWatch1.Directory := label1.Caption;
  statusbar1.Panels[0].Text := GetDefaultPrinter;

  BtnStart.Enabled := True;
  BtnStop.Enabled := not btnStart.Enabled;
end;

procedure TfrmFastReport.frxReport1GetValue(const VarName: string;
  var Value: Variant);
var
  sl: TStringList;
begin
  if CompareText(VarName, 'file') = 0 then
  begin
    sl := TStringList.Create;
    sl.LoadFromFile(afilename);
    Value := sl.Text;
    sl.Free;
  end;
  //  if not testing then
  //  begin
  //    deletefile(afilename);
  //    memo1.Lines.Add('deleted');
  //  end;
end;

procedure TfrmFastReport.btnStartClick(Sender: TObject);
begin
  Deletefiles(ExtractFilePath(label1.Caption), '*.prn');
  Deletefiles(ExtractFilePath(label1.Caption), '*.csv');

  Memo1.Clear;
  Memo1.Lines.Add('-- LOG --');
  Memo1.Lines.Add('## Service started - ' + DateTimeToStr(Now));
  getfilelist;
  DirectoryWatch1.Active := True;
  BtnStart.Enabled := False;
  BtnStop.Enabled := not btnStart.Enabled;
end;

procedure TfrmFastReport.btnStopClick(Sender: TObject);
begin
  Memo1.Lines.Add('## Service stopped - ' + DateTimeToStr(Now));
  DirectoryWatch1.Active := False;
  BtnStart.Enabled := True;
  BtnStop.Enabled := not btnStart.Enabled;
end;

procedure TfrmFastReport.BitBtn1Click(Sender: TObject);
begin
  OpenDialog1.InitialDir:= apppath;
  OpenDialog1.FileName:= 'Select a directory to watch';
  if OpenDialog1.Execute then
  begin
    label1.Caption := extractFilePath(OpenDialog1.FileName);
    DirectoryWatch1.Directory := Label1.Caption;
  end;
end;

procedure TfrmFastReport.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Memo1.Lines.Add('## Application terminated - ' + DateTimeToStr(Now));
  DirectoryWatch1.Active := False;

  inifile.WriteString('General', 'tmpdir', label1.Caption);
  inifile.WriteInteger('General', 'kertas', cboKertas.ItemIndex);
  inifile.WriteBool('General', 'autoprint', chkAutoPrint.Checked);
  inifile.Free;
end;

procedure TfrmFastReport.frxReport1AfterPrintReport(Sender: TObject);
begin
  Memo1.Lines.Add('## Print file: ' + ExtractFileName(afilename));
  if not testing then
  begin
    deletefile(afilename);
    memo1.Lines.Add('## Delete file: ' + ExtractFileName(afilename));
  end;
end;

procedure TfrmFastReport.About1Click(Sender: TObject);
begin
  MessageDlg('Dot Matrix Report Watcher' + #13 + #10 + '' + #13 + #10 +
    'OpenSIPKD®.com © 2015', mtInformation, [mbOK], 0);
end;

procedure TfrmFastReport.Exit1Click(Sender: TObject);
var
  s: string;
begin
  s := 'Do you want to stop program? ';
  if MessageDlg(s, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    Application.Terminate;
end;

procedure TfrmFastReport.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  s: string;
begin
  s := 'Do you want to stop program? ';
  if MessageDlg(s, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    CanClose := false
  else
    CanClose := true;
end;

procedure TfrmFastReport.ReportTemplate1Click(Sender: TObject);
begin
  repeat
    csvdirnm := InputBox('Report Template', 'Enter report template directory name',
      csvdirnm);
  until csvdirnm <> '';

  CreateDir(fr3dir + csvdirnm);
  inifile.WriteString('General', 'csvdirnm', csvdirnm);
  csvdir := fr3dir + csvdirnm + '\';
end;

procedure TfrmFastReport.cboKertasChange(Sender: TObject);
begin
  if not (UpperCase(extractFileExt(afilename)) = '.CSV') and not (afilename='') then
    print(extractFilePath(afilename), extractfilename(afilename));
  Self.ActiveControl := nil;
end;

end.
                                                        
