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
    IsSKPD:boolean;
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
    Logout1: TMenuItem;
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
    procedure Exit1Click(Sender: TObject);
    procedure frxReport1Preview(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnDesignClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frxReport1GetValue(const VarName: String;
      var Value: Variant);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DirectoryWatch1Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
//    WPath: String;
   //MenuModified:Boolean;
   apppath:string;
   testing:boolean;
   afilename:string;
   inifile:tinifile;
   procedure get_paper;
   procedure getfilelist;
   procedure print(wpath,filenm:string);
  public
    { Public declarations }
    //RptPath:string;
  end;

var
  frmFastReport: TfrmFastReport;

implementation


{$R *.DFM}

procedure TfrmFastReport.print(wpath,filenm:string);
var filename:String;
begin
        memo1.Lines.Add(afilename);
        if UpperCase(extractFileExt(filenm))='.CSV' then
        begin
          con1.Close;
          con1.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;'+
                                 'Data Source='+wpath+';' +
                                 'Extended Properties=''text;HDR=Yes;FMT=Delimited''';
          //qry1.SQL.Text:='select * from '+filenm;
          con1.Open;
          //qry1.Open;
          filename := apppath+'\fr3\'+ ChangeFileExt(filenm, '')+'.fr3';
          frxreport1.LoadFromFile(filename);
        end
        else
        begin
          frxreport1.LoadFromFile(apppath+'\fr3\'+cboKertas.Items[cboKertas.ItemIndex]);
        end;
        
        if chkAutoPrint.Checked then
        begin
          frxReport1.PrepareReport(True);
          frxReport1.PrintOptions.ShowDialog := False;
          frxReport1.Print;
        end
        else
        begin
          //Application.BringToFront;
          BringToFront;
          //frmFastReport.BringToFront;
          frxReport1.ShowReport;
        end;
end;

procedure TfrmFastReport.getfilelist;
var
  WatchPath    : String;
  SR      : TSearchRec;
  //filename : String;
  //sl: TStringList;
begin
  testing:=False;
  WatchPath:=DirectoryWatch1.Directory; //Get the path of the selected file
  try
    if FindFirst(WatchPath + '*.prn', faArchive, SR) = 0 then
    begin
      Memo1.Lines.Clear;
      repeat
        afilename := WatchPath+SR.Name;
        print(WatchPath,SR.Name);
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
    
    if FindFirst(WatchPath + '*.csv', faArchive, SR) = 0 then
    begin
      Memo1.Lines.Clear;
      repeat
        afilename := WatchPath+SR.Name;
        print(WatchPath,SR.Name);
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
  except
    on e:exception do
      memo1.Lines.Add(e.Message)
  end;
end;

procedure TfrmFastReport.get_paper;
var
  SR      : TSearchRec;
  filename : String;

begin
  cboKertas.Items.Clear;
  if FindFirst(apppath + '\fr3\*.fr3', faArchive, SR) = 0 then
  begin
    repeat
      filename := apppath+SR.Name;
      cboKertas.Items.Add(SR.Name);
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
  cboKertas.ItemIndex:=0;
end;

procedure TfrmFastReport.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmFastReport.frxReport1Preview(Sender: TObject);
var
   frmPreview: TfrxPreviewForm;
begin
   frxReport1.PreviewOptions.Modal := False;
   frmPreview := TfrxPreviewForm(frxReport1.PreviewForm);
//   frmPreview := TfrxPreviewForm(frxReport1.PreviewPages);
   frmPreview.BorderStyle := bsNone;
   frmPreview.Parent:=Panel3;
   frmPreview.Left:=0;
   frmPreview.Top:=0;
   frmPreview.Width:=Panel1.ClientWidth;
   frmPreview.Height:=Panel1.ClientHeight;
end;

procedure TfrmFastReport.btnTestClick(Sender: TObject);
begin
  //getfilelist;
  if opendialog1.Execute then
  begin
    if Not btnStart.Enabled then
    begin
       btnStop.Click();
    end;
    testing:=True;
    afilename := opendialog1.FileName;
    print(extractFilePath(afilename),extractfilename(afilename));
  end;
end;

procedure TfrmFastReport.btnDesignClick(Sender: TObject);
begin
   //frxreport1.LoadFromFile(apppath+'\fr3\'+cboKertas.Items[cboKertas.ItemIndex]);
   frxReport1.DesignReport;
   get_paper;
end;

procedure TfrmFastReport.FormCreate(Sender: TObject);
begin
  apppath := ExtractFilePath(Application.ExeName);
  testing:=True;
  get_paper;
  inifile := TIniFile.Create(appPath+'config.ini');
  label1.Caption:= inifile.ReadString('General', 'tmpdir', getTempDirectory);
  cboKertas.ItemIndex := inifile.ReadInteger('General', 'kertas', 0);
  chkAutoPrint.Checked:=  inifile.ReadBool('General', 'autoprint', False);
  DirectoryWatch1.Directory:= label1.Caption;
  statusbar1.Panels[0].Text:=GetDefaultPrinter;
  BtnStart.Enabled:=True;
  BtnStop.Enabled:= not btnStart.Enabled;


  //statusbar1.Panels[1].Text:= label1.Caption;
end;

procedure TfrmFastReport.frxReport1GetValue(const VarName: String;
  var Value: Variant);
var
  sl:TStringList;
begin
    if CompareText(VarName, 'file') = 0 then
    begin
      sl := TStringList.Create;
      sl.LoadFromFile(afilename);
      Value := sl.Text;
      sl.Free;
    end;
    if not testing then
    begin
       deletefile(afilename);
       memo1.Lines.Add('deleted');
    end;
end;

procedure TfrmFastReport.btnStartClick(Sender: TObject);
begin
  Memo1.Clear;
  Memo1.Lines.Add('--LOG--');
  //IdHTTPServer1.Active:=True;
  Memo1.Lines.Add(DateTimeToStr(Now)+': Server started');
  getfilelist;
  DirectoryWatch1.Active:=True;
  BtnStart.Enabled:=False;
  BtnStop.Enabled:= not btnStart.Enabled;

end;

procedure TfrmFastReport.btnStopClick(Sender: TObject);
begin
  //IdHTTPServer1.Active:=False;
  Memo1.Lines.Add(DateTimeToStr(Now)+': Server stopped');
  DirectoryWatch1.Active:=False;
  BtnStart.Enabled:=True;
  BtnStop.Enabled:= not btnStart.Enabled;
end;

procedure TfrmFastReport.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  //IdHTTPServer1.Active:=False;

end;

procedure TfrmFastReport.DirectoryWatch1Change(Sender: TObject);
begin
  getfilelist;
end;

procedure TfrmFastReport.BitBtn1Click(Sender: TObject);
begin
   if opendialog1.Execute then
   begin
      label1.Caption:=extractFilePath(opendialog1.FileName);
      DirectoryWatch1.Directory:=label1.Caption;
   end;
end;

procedure TfrmFastReport.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Memo1.Lines.Add(DateTimeToStr(Now)+': Application Terminated');
  DirectoryWatch1.Active:=False;

  inifile.WriteString('General', 'tmpdir', label1.Caption);
  inifile.WriteInteger('General', 'kertas', cboKertas.ItemIndex);
  inifile.WriteBool('General', 'autoprint', chkAutoPrint.Checked);
  inifile.Free;

end;

end.

