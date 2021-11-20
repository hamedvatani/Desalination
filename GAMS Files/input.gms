Parameters
WD,WS,ALPHA
W,W5,W15,W50,W80
WL5,WL15,WL50,WL80
CWS,CO,CK
CW,CW5,CW15,CW50,CW80
CWH,WHZ,WHF
RW5,RW15,RW50,RW80,RWH
T4,WLH
O,K
M
;

Variables
Z;
    Positive Variables
XWDI,XWD,XSO,XSK
XO,XOW
XK,XKH
XW5,XW15
XWH
;

INTEGER VARIABLES
F5,F15
XW50,XW80
;

BINARY VARIABLES
U1,U2,U3,U4,U5
;


Equations
Obj,C0,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15
C16,C17,C18,C19,C20,C21,C22,C23,C24,C25,C26,C27,C28,C29,C30
C31,C32,C33,C34,C35,C36,C37,C38;

Obj..     Z =E=

(
  RW5*XW5 + RW15*XW15 + RW50*XW50 + RW80*XW80 +
  RWH*XWH
)
-
(
  CWS*XWD  +  CO*XO + CK*XK +
  CW*(0.5*XW5 +1.5*XW15 + 5*XW50 + 8*XW80) +
  CW5*XW5 + CW15*XW15 + CW50*XW50 + CW80*XW80 +
  CWH*XWH
);

C0..     XWDI      =L= WS;
C1..     XWDI      =L= WD;
C2..     XWD       =L= (1/100)*ALPHA*XWDI;
C3..     XSO + XSK =E= XWD;

C4..     XSO =L= O;
C5..     XO  =L= XSO;
C6..     XOW =L= XO;

C7..    XSK =L= K;
C8..    XK =L= XSK;
C9..    XKH =L= XK;


C10..   0.5*XW5 + 1.5*XW15 + 5*XW50 +  8*XW80 =L= W;
C11..   0.5*XW5 + 1.5*XW15 + 5*XW50 +  8*XW80 =L= (1/100)* T4 * XOW;

C12..   XW5  =L= W5;
C13..   XW15 =L= W15;
C14..   XW50 =L= W50;
C15..   XW80 =L= W80;

C16..   XW5  =E= 24 * F5;
C17..   XW15 =E= 6  * F15;

C18..   XW5 =G= 0;
C19..   XW5 =L= M * U1;
C20..   U1 * WL5 =L= XW5;

C21..   XW15 =G= 0;
C22..   XW15 =L= M * U2;
C23..   U2 * WL15 =L= XW15;

C24..   XW50 =G= 0;
C25..   XW50 =L= M * U3;
C26..   U3 * WL50 =L= XW50;

C27..   XW80 =G= 0;
C28..   XW80 =L= M * U4;
C29..   U4 * WL80 =L= XW80;

C30..   XWH =L= XK;
C31..   XWH =L= WHZ;
C32..   XWH =L= WHF;
C33..   XWH =L= XKH;

C34..   XWH =G= 0;
C35..   XWH =L= M * U5;
C36..   U5 * WLH =L= XWH;

C37..   F5 =G= 0;
C38..   F15 =G= 0;

Model O_Model /All/;

File aO_Model /Results.txt/;

Puttl aO_Model 'Title ' System.title, @60 'Page ' System.page//;

Put aO_Model ;

WD=10000;WS=9000;ALPHA=72;
W=4500;W5=4000;W15=2700;W50=850;W80=400;
WL5=300;WL15=210;WL50=150;WL80=80;
CWS=110;CO=20;CK=18;
CW5=50;CW15=150;CW50=400;CW80=720;
CWH=85;WHZ=3800;WHF=3800;
RW5=2000;RW15=3500;RW50=4500;RW80=7000;RWH=42000;
WLH=50;


O=WS;
K=WS;
CO=0;
CK=0;
T4=100;
CW=0;

F5.UP=100000;
F15.UP=100000;

XW50.UP=100000;
XW80.UP=100000;


OPTION optca=0,optcr=0, RESLIM=50000 ;

M=300000;
Solve O_Model Using MIP Maximizing Z;

PUT Z.L;
Put/;
PUT XWDI.L;PUT XWD.L;PUT XSO.L;PUT XSK.L; Put/;
PUT XO.L;PUT XOW.L;   Put/;
PUT XK.L;PUT XKH.L;   Put/;
PUT XW5.L; PUT XW15.L;PUT XWH.L;    Put/;
PUT XW50.L;PUT XW80.L    Put/; Put/;Put/;

PUT F5.L; PUT F15.L;
Put/;
PUT U1.L; PUT U2.L;PUT U3.L;PUT U4.L;PUT U5.L;






