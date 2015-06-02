unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  IPPeerServer, System.Tether.Manager, System.Tether.AppProfile, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, System.Actions, FMX.ActnList;

type
  TForm3 = class(TForm)
    TetheringManager1: TTetheringManager;
    TetheringAppProfile1: TTetheringAppProfile;
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    EditButton1: TEditButton;
    ImageControl1: TImageControl;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    ImageControl2: TImageControl;
    ActionList1: TActionList;
    actReset: TAction;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TetheringManager1PairedToRemote(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure TetheringManager1RequestManagerPassword(const Sender: TObject;
      const ARemoteIdentifier: string; var Password: string);
    procedure EditButton1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TetheringAppProfile1ResourceReceived(const Sender: TObject;
      const AResource: TRemoteResource);
    procedure actResetExecute(Sender: TObject);
    procedure actResetUpdate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}

procedure TForm3.actResetExecute(Sender: TObject);
begin
  Edit1.Text := '';
  Label2.Text := '';
end;

procedure TForm3.actResetUpdate(Sender: TObject);
begin
  actReset.Enabled := (Edit1.Text <> '') OR
                      (Label2.Text <> '');
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  TetheringManager1.AutoConnect;
end;

procedure TForm3.Button2Click(Sender: TObject);
var
  LStream : TMemoryStream;
begin
  if OpenDialog1.Execute then
  begin
    ImageControl1.LoadFromFile(OpenDialog1.FileName);

    Lstream := TMemoryStream.Create;
    ImageControl1.Bitmap.SaveToStream(LStream);
    LStream.Position := 0;

    TetheringAppProfile1.Resources.FindByName('SomeImage').Value := LStream;
  end;
end;

procedure TForm3.EditButton1Click(Sender: TObject);
begin
  TetheringAppProfile1.Resources.FindByName('SomeText').Value := Edit1.Text;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Caption := Format('App1 : %s', [TetheringManager1.Identifier]);
end;

procedure TForm3.TetheringAppProfile1ResourceReceived(const Sender: TObject;
  const AResource: TRemoteResource);
begin
  if AResource.Hint = 'ReplyText' then
  begin
    Label2.Text := AResource.Value.AsString;
  end
  else if AResource.Hint = 'ReplyImage' then
  begin
    AResource.Value.AsStream.Position := 0;
    ImageControl2.Bitmap.LoadFromStream(AResource.Value.AsStream);
  end;
end;

procedure TForm3.TetheringManager1PairedToRemote(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  Label1.Text := Format('Connected : %s %s', [AManagerInfo.ManagerIdentifier, AManagerInfo.ManagerName]);
end;

procedure TForm3.TetheringManager1RequestManagerPassword(const Sender: TObject;
  const ARemoteIdentifier: string; var Password: string);
begin
  Password := 'The wingless dove protects its nest';
end;

end.
