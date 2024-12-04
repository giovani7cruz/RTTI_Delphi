(*

Criado por Giovani Da Cruz
https://giovanidacruz.com.br

*)
program GetPropertysClass;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Rtti,
  System.TypInfo,
  System.SysUtils;

type
  TMinhaClasse = class
  private
    FNome: string;
    FIdade: Integer;
    FSalario: Double;
    FPropPrivate: Integer;
    FPropProtected: Integer;
    // propriedades protected nao listam no GetProperties
    property PropPrivate : Integer read FPropPrivate write FPropPrivate;
  protected
    // propriedades protected nao listam no GetProperties
    property PropProtected : Integer read FPropProtected write FPropProtected;
  public
    property Nome: string read FNome write FNome;
    property Idade: Integer read FIdade write FIdade;
  published
    property Salario: Double read FSalario write FSalario;
  end;

procedure PercorrerPropriedades(AObj: TObject; aTypes : array of TMemberVisibility);
var
  ctx: TRttiContext;
  rttiType: TRttiType;
  prop: TRttiProperty;
  value: TValue;
  isInArray: Boolean;
  visibility: TMemberVisibility;
begin
  ctx := TRttiContext.Create;
  try
    rttiType := ctx.GetType(AObj.ClassType);
    for prop in rttiType.GetProperties do
    begin
      isInArray := False;
      for visibility in aTypes do
      begin
        if prop.Visibility = visibility then
        begin
          isInArray := True;
          Break;
        end;
      end;

      if isInArray then
      begin
        value := prop.GetValue(AObj);
        Writeln(Format('%s = %s', [prop.Name, value.ToString]));
      end;
    end;
  finally
    ctx.Free;
  end;
end;

var
  Obj: TMinhaClasse;
begin
  Obj := TMinhaClasse.Create;
  try
    Obj.Nome := 'Giovani da Cruz';
    Obj.Idade := 30;
    Obj.Salario := 4500.75;

    Writeln('Propriedades "public" da classe TMinhaClasse:');
    PercorrerPropriedades(Obj, [mvPublic]);
    Writeln('');

    Writeln('Propriedades "published" da classe TMinhaClasse:');
    PercorrerPropriedades(Obj, [mvPublished]);
    Writeln('');

    { Mesmo colocando todas as opções, somente é possível listar
    public / published }
    Writeln('"Todas" Propriedades da classe TMinhaClasse:');
    PercorrerPropriedades(Obj, [mvPublished, mvPublic, mvProtected, mvPrivate]);
  finally
    Obj.Free;
  end;

  Readln; // <- Pausa
end.
