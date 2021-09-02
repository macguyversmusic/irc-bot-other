unit ircbotnew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus, ScktComp, token,
  strutils;

type
  TForm1 = class(TForm)
    cs: TClientSocket;
    Timer1: TTimer;
    Edit1: TEdit;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure csError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure csDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure csConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure csRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Start;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    Procedure AddLog(logstring: String);
    Procedure ircparse(data: String);
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  nick: string; // variables  add any strings you want to call later here

  // this adds any data to the memo1 and you call it like this
  // addlog(yourstring); or addlog('hello');
  // whatever you encase in the ()   is named logstring inside the procedure
  // its just a way to shorten memo1.lines.add('bla'); to addlog('bla')
procedure TForm1.AddLog(logstring: String);
Begin
  Memo1.Lines.Add(logstring);
end;

// this is called as the program starts you can initialise variables
// here or call procedures
procedure TForm1.FormCreate(Sender: TObject);
begin
  AddLog('Bot started...');
  // call the addlog function with a string could be a variable
  nick := 'a_nick_1'; // change this to a nick of your choice
  Start; // calls the start procedure
end;

// start procedure call this again  and again if theres
// an error or a disconnect,
procedure TForm1.Start;
begin
  cs.Host := 'budapest.hu.eu.undernet.org'; // could be any sever
  cs.Port := 6667; // any legal irc port
  cs.Active := true; // try to make a connection
end;

// this procedure runs if theres an error on the socket
procedure TForm1.csError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  AddLog('Something wrong?'); // run the addlog function with the string
  ErrorCode := 0; // irrelevant
  AddLog('trying to reconnect...'); // add this to your memo box
  Start; // call start again to reconnect
end;

// same as above except this is when we are  disconnected by the server or network down etc
procedure TForm1.csDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  AddLog('Disconnected from server'); // add this to your memo box
  AddLog('trying to reconnect...'); // add this to your memo box
  Start; // call start again to reconnect
end;

procedure TForm1.csConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  AddLog('Connected...');
      cs.Socket.SendText('USER blagard blouub bla blub' + #13#10);
    cs.Socket.SendText(nick + #13#10);
end;

// ok here we parse the incoming data
Procedure TForm1.ircparse(data: String);
var
  content: String;
  tmp, tmp2, tmp3, tmp4, tmp5: String;
  index: Integer;
begin
  lowercase(data); // change the string called data to lowercase
  AddLog(data); // write it to our memo with the addlog procedure
  if data[1] = ':' then // check if the first char of data is a ':'
  Begin
    tmp := GetFirstToken(data); // procedure breaks the data up in to spaces
    // so a string like 'hello world i am here' has 5 tokens
    tmp2 := GetNextToken; // gets the next group of letters up to the next space
    tmp3 := GetRemainingTokens; // gets all remaining letters including spaces
    delete(tmp, 1, 1);
    // removes the first character from string tmp which we know is a ':'
    index := pos('!', tmp);
    if Index > 0 then
    begin
    end;
  end

  else // deal with ping etc

  Begin
    if lowercase(GetFirstToken(data)) = 'ping' then
    begin
      AddLog('*** PING PONG');
      content := GetRemainingTokens;
      cs.Socket.SendText('PONG ' + content + #10#13);
      cs.Socket.SendText('JOIN #fbnbt 3edcvfr4' + #10#13);
    end;
  end;

  if ansicontainsstr(data, 'No ident response') then
  begin
    //tmp2 := GetNextToken; // gets the next group of letters up to the next space
    cs.Socket.SendText('USER abb blub bla blub' + #10);
    cs.Socket.SendText(nick + #10);
  end;
  end;


// this event is called whenever the socket receives a string/data
procedure TForm1.csRead(Sender: TObject; Socket: TCustomWinSocket);
var
  s, temp: String;
  i: Integer;
begin
  s := Socket.ReceiveText; // put the whole string of text in to a var called s
  AddLog(s);
  if ansicontainsstr(s,'NOTICE AUTH :*** No ident response') then
  begin
      Socket.SendText('USER abb blub bla blub' + #10);
       end
       else


  while (pos(#10, s) <> 0) do // while we dont see newline
  Begin
    temp := copy(s, 1, pos(#10, s) - 1);
    // copy everything up to newline to temp
    delete(s, 1, pos(#10, s)); // delete the newline char

    ircparse(temp); // parse the incoming data
  end;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
// this procedure checks for a keypress in the edit box
var
  s: String;
begin
  s := Edit1.Text; // the edit text is given to variable s
  if Key = VK_RETURN then // if it detects you press return
  Begin
    if s[1] = '/' then // if the first char in
    Begin
      delete(s, 1, 1); // remove the /  and send raw
      cs.Socket.SendText(Edit1.Text + #10);
    end

    else

    Begin
      cs.Socket.SendText(Edit1.Text + #10);
      // just send whatever you type to the server
    end;
    Edit1.Text := '';
  end;
end;

end.
