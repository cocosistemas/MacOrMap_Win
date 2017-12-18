unit Testo;

interface

uses windows,System.classes,vettoriale,GR32, GR32_Image, GR32_Layers, vertice, sysutils,FMX.Dialogs;

type
 TTesto = class(TVettoriale)
   	scritta : String;
    x,y : Real;
	  i_font : Integer;
	  i_style: Integer;
    altezza : real;
    angolo  : real;
	  alli    : integer;

   Constructor Create;                                   virtual;
   Destructor  Done;                                     virtual;
   procedure   initTesto          (x1,y1,alt,ang : Real);
   procedure   initTestoStr       (x1,y1,alt,ang : Real; caratteri : String );

   procedure   Disegna            (HHDC : TImage32);                        override;
   procedure   DisegnaConColori   (HHDC : TImage32; Color32Bordo   : TColor32; Color32Dentro  : TColor32;spess:Integer); override;
   procedure   DisegnaAffineSpo   (DC : hdc ;  dx,dy : Real);          override;
   procedure   DisegnaAffineRot   (DC : hdc ;  xc,yc,rot : Real);      override;
   procedure   DisegnaAffineSca   (DC : hdc ;  xc,yc,sca : Real);      override;
   procedure   DisegnaSpoRotSca   (HHDC : TImage32;  xc,yc,rot,sca : Real;xp,yp : real;ColBordo,ColDentro : Tcolor32);  override;

   procedure   faiLimiti          ;                                         override;
   Procedure   salvavettorialeMacMap (St : TMemoryStream);                           override;
   Procedure   aprivettorialeMacMap  (St : TMemoryStream);                           override;


   Function    Match_conPt             (x1,y1 : Real): Boolean;                   override;
   Function    inSchermo: Boolean;                                                override;

   function    Copia              (dx, dy : Real)  : TVettoriale;           override;
   procedure   Sposta             ( dx,dy : Real);                          override;
   procedure   Ruota              ( xc , yc , ang  : Real);                 override;
   procedure   Ruotaang           ( ang : Real);
   procedure   Scala              ( xc , yc , scal : Real);                 override;
   procedure   Scalasc            ( scal : Real);


{

  - (void) cambiastringa    : (NSString *)   _newtext;
  - (void) DisegnaSelected  : (CGContextRef)  hdc    : (InfoObj *) _info;  // solo per i testi
  - (void) cambiaaltezza    : (double)       newh;


  - (bool) SnapFine         : (InfoObj *)     _info  : (double)     x1      : (double) y1;
  - (bool) SnapVicino       : (InfoObj *)     _info  : (double)     x1      : (double) y1;
  - (void) seleziona_conPt  : (CGContextRef)  hdc    : (InfoObj *) _info    : (double) x1  : (double) y1: (NSMutableArray *) _LSelezionati ;
  - (bool) Match_conPt      : (InfoObj *)     _info  : (double) x1           : (double) y1;

  - (void) Sposta          : (double) dx :  (double) dy;
  - (Vettoriale *) Copia           : (double) dx :  (double) dy;
  - (void) Ruota           : (double) xc :  (double) yc : (double) ang;
  - (void) Ruotaang        : (double) ang;
  - (void) Scala           : (double) xc :  (double) yc : (double) scal;
  - (void) Scalasc         : (double) scal;
  - (void) CopiainLista    : (NSMutableArray *) inlista;

  - (NSString *) caratteritesto;
  - (double)     altezzatesto;

  - (bool) testinternoschermo : (InfoObj *) _info  ;

  - (void) CatToUtm : (InfoObj *) _info;

  - (void) TestoAltoQU ;

  - (Testo *) copiaPura ;


}

 end;

implementation

uses varbase, funzioni;

constructor TTesto.Create;
 begin
   Inherited Create;
    tipo := PTesto;
 end;

Destructor  TTesto.Done;
 begin
   Inherited Done;
 end;

procedure   TTesto.initTesto          (x1,y1,alt,ang : Real);
begin
  x := x1; y:=y1;     altezza :=alt;  angolo := ang;
end;

procedure   TTesto.initTestoStr       (x1,y1,alt,ang : Real; caratteri : String );
begin
  x := x1; y:=y1;  altezza :=alt;  angolo := ang;
  scritta := caratteri;
end;

procedure   TTesto.faiLimiti ;
begin
	limx1 := x  ;	limx2 := x+(altezza/80)*Length(scritta)*0.8 ;	limy1 := y ;	limy2 := y+(altezza/80) ;
end;



var x1, y1 : single;
    ht : Integer;
begin
 if b_erased then exit;
 if Not(inSchermo) then exit;
	x1 :=Xinschermo(x); 	y1 :=Yinschermo(y+altezza/parahTesto);
  ht := round((altezza/(scalavista* parahTesto)));

  if ht<5 then exit;
  HHDC.Bitmap.Canvas.Font.Height:=ht;
  HHDC.Bitmap.Canvas.Font.Orientation := round(angolo*1800/pi);
  HHDC.Bitmap.Canvas.textout(round(X1),round(Y1),scritta);











     Font.Color := _piano.Color32Bordo;
     Font.Size := ht;
    Font.Orientation := round(angolo*1800/pi);
     UpdateFont;
    textout(round(X1),round(Y1),scritta);
//     RenderText(round(X1),round(Y1),scritta, 0,_piano.Color32Bordo);
    end;

end;

procedure   TTesto.DisegnaConColori   (HHDC : TImage32; Color32Bordo   : TColor32; Color32Dentro  : TColor32;spess:Integer);
var x1, y1 : single;
    ht : Integer;
    R,G,B : Byte;
begin
 if b_erased then exit;
  x1 :=Xinschermo(x); 	y1 :=Yinschermo(y+altezza/80);
  ht := round((altezza/(scalavista* parahTesto)));
  if ht<5 then exit;
      R :=  TColor32Entry(Color32Bordo).R;
      G :=  TColor32Entry(Color32Bordo).G;
      B :=  TColor32Entry(Color32Bordo).B;
  HHDC.Bitmap.Canvas.Font.Height:=ht;
  HHDC.Bitmap.Canvas.Font.Color:=RGB(R,G,B) ;
  HHDC.Bitmap.Canvas.Font.Orientation := round(angolo*1800/pi);
  HHDC.Bitmap.Canvas.textout(round(X1),round(Y1),scritta);
end;



procedure   TTesto.DisegnaAffineSpo   (DC : hdc ;  dx,dy : Real);
var paralungcar : Real;






















   lineto(dc,round(Xinschermo(x3+dx)),round(Yinschermo(y3+dy)));
   lineto(dc,round(Xinschermo(x4+dx)),round(Yinschermo(y4+dy)));
   lineto(dc,round(Xinschermo(x+dx)),round(Yinschermo(y+dy)));
end;




procedure   TTesto.DisegnaAffineRot   (DC : hdc ;  xc,yc,rot : Real);
var x1, y1 : real;


    locx,locy : Real;
begin




	x1:=locx+xc;           	y1:=locy+yc;
 	x1 :=  Xinschermo(x1);	y1 :=  Yinschermo(y1);


	x2 :=round(x1+ht*Length(scritta)); 	y2 := y1+ht;
  MoveToex(dc,round(x1),round(y1),nil);
  Lineto(dc,round(x2),round(y1));
  Lineto(dc,round(x2),round(y2));
  Lineto(dc,round(x1),round(y2));
  Lineto(dc,round(x1),round(y1));
end;


var x1, y1 : real;
    x2, y2 : real;

    locx,locy : Real;
begin

	x1 :=x-xc; 	     y1 :=y-yc;
	locx := x1*sca;        	locy := y1*sca;
	x1 :=locx+xc;	   y1:=locy+yc;
 	x1 :=  Xinschermo(x1); y1 :=  Yinschermo(y1);
  ht := round((((altezza/scalavista)*sca)/80)*0.8);
  if ht<2 then exit;
	x2 :=round(x1+ht*Length(scritta)); 	y2 := y1+ht;
  MoveToex(dc,round(x1),round(y1),nil);
  Lineto(dc,round(x2),round(y1));
  Lineto(dc,round(x2),round(y2));
  Lineto(dc,round(x1),round(y2));
  Lineto(dc,round(x1),round(y1));

end;

procedure   TTesto.DisegnaSpoRotSca   (HHDC : TImage32;  xc,yc,rot,sca : Real;xp,yp : real;ColBordo,ColDentro : Tcolor32);
begin

end;






Procedure   TTesto.SalvavettorialeMacMap (St : TMemoryStream);
var ll,k : Integer;
    cc : char;
begin
  Inherited salvavettorialeMacMap(st);
 	st.Write(x, sizeof(x));
 	st.Write(y, sizeof(y));
 	st.Write(i_font  , sizeof(i_font));
 	st.Write(i_style , sizeof(i_style));
 	st.Write(alli    , sizeof(alli));
 	st.Write(altezza , sizeof(altezza));
 	st.Write(angolo  , sizeof(angolo));

  ll := length(scritta);
 	st.Write(ll      , sizeof(ll));
  for k:=1 to ll do
   begin cc := scritta[k];	st.Write(cc , sizeof(cc)); end;
end;

Procedure   TTesto.aprivettorialeMacMap  (St : TMemoryStream);
var ll , k: Integer;
    cc : char;
begin
  Inherited aprivettorialeMacMap(st);
 	st.Read(x, sizeof(x));
 	st.Read(y, sizeof(y));
 	st.Read(i_font  , sizeof(i_font));
 	st.Read(i_style , sizeof(i_style));
 	st.Read(alli    , sizeof(alli));
 	st.Read(altezza , sizeof(altezza));
 	st.Read(angolo  , sizeof(angolo));
  ll := length(scritta);
 	st.Read(ll      , sizeof(ll));
  for k:=1 to ll do
   begin st.Read(cc , sizeof(cc)); scritta:= scritta+cc; end;
end;





   tx1,ty1 : real;
begin
  off  :=  give_offsetmirino ;
  Rotoscalacentra (x, y , -angolo, 1.0, x1,y1,  locx1, locy1  );
  tx1 := x + length(scritta)*altezza/parahTesto;
  ty1 := y + altezza/parahTesto;
  if ( (locx1>(x-off)) and  (locx1<(tx1+off)) and  (locy1>(y-off)) and  (locy1<(ty1+off)) ) then  begin ListaSelezionati.Add(self);  end;
end;








 resulta := false;
  off  :=  give_offsetmirino ;
  Rotoscalacentra (x, y , -angolo, 1.0, x1,y1,  locx1, locy1  );
  if ( (locx1>(limx1-off)) and  (locx1<(limx2+off)) and  (y1>(limy1-off)) and  (y1<(limy2+off)) ) then  begin resulta:=true;  end;
  result := resulta;
end;







  y1 := Yinschermo(limy1); if y1 <0 then resulta :=false;
  x1 := Xinschermo(limx1); if x1 >Wschermo then resulta :=false;
  y1 := Yinschermo(limy2); if y1 >Hschermo then resulta :=false;
 result := resulta;
end;





  	newtxt := TTesto.Create;
  	newtxt.initer(_disegno,_piano);
    newtxt.initTestoStr(x,y,altezza,angolo,scritta);
  	_piano.Listavector.Add(newtxt);
  	newtxt.Sposta(dx,dy);
  	newtxt.faiLimiti;
 	result:=newtxt;
end;


begin
   x :=x+dx;	 y :=y+dy;
end;

procedure   TTesto.Ruota              ( xc , yc , ang  : Real);
begin
 Sposta(-xc,-yc);	Ruotaang(ang);	Sposta(xc,yc);  angolo:=angolo+ang;
end;

procedure   TTesto.Ruotaang  ( ang : Real);
var  locx,locy : Real;
begin
	locx := x*cos(ang) - y*sin(ang);        	locy := x*sin(ang) + y*cos(ang);
	x :=locx;	y :=locy;
end;

procedure   TTesto.Scala              ( xc , yc , scal : Real);
begin
 Sposta(-xc,-yc);	Scalasc(scal);	Sposta(xc,yc);
end;

procedure   TTesto.Scalasc            ( scal : Real);
begin

end;

end.