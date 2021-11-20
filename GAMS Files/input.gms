*Sets
Parameters
WD,WS,O,K
D,D3,D5,D15,D50
N,N3,N5,N15,N20
M,M3,M10,M15
W,W3,W5,W15,W50,W80
CWS,CO,CK
CD,CD3,CD5,CD15,CD50
CN,CN3,CN5,CN15,CN20
CM,CM3,CM10,CM15
CW,CW3,CW5,CW15,CW50,CW80
CWH,WHZ,WHF
RD3,RD5,RD15,RD50
RN3,RN5,RN15,RN20
RM3,RM10,RM15
RW3,RW5,RW15,RW50,RW80,RWH
ALPHA,BETA,GAMA
T1,T2,T3,T4 ;


Variables
Z
XWD
XD3,XD5,XD15,XD50
XN3,XN5,XN15,XN20
XM3,XM10,XM15
XW3,XW5,XW15,XW50,XW80
XWH,XWDI
XOD,XON,XOM,XOW,XOWH
XSO,XSK,XO,XK
 ;
    Positive Variables
XWD
XD3,XD5,XD15
XN3,XN5,XN15
XM3,XM10,XM15
XW3,XW5,XW15,
XWH,XWDI
XOD,XON,XOM,XOW,XOWH
XSO,XSK,XO,XK

;

INTEGER VARIABLES
XW50,XW80,XD50,XN20
K1,K2,K3,K4,K5,K6,K7,K8,K9,K10,K11,K12
;

Equations
Obj,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15
C16,C17,C18,C19,C20,C21,C22,C23,C24,C25,C26,C27,C28,C29,C30
C31,C32,C33,C34,C35,C36,C37,C38,C39,C40,C41,C42,C43,C44,C45,C46,C47;

Obj..     Z =E=

(
         RD3*XD3 + RD5*XD5 + RD15*XD15 + RD50*XD50 +
         RN3*XN3 + RN5*XN5 + RN15*XN15 + RN20*XN20 +
         RM3*XM3 + RM10*XM10 + RM15*XM15 +
         RW3*XW3 + RW5*XW5 + RW15*XW15 + RW50*XW50 + RW80*XW80 +
         RWH*XWH

)
-
(

         CD*(0.3*XD3 + 0.5*XD5 + 1.5* XD15 + 5*XD50)+
         CD3*XD3 + CD5*XD5 + CD15*XD15 + CD50*XD50  +

         CN*(0.3*XN3 + 0.5*XN5 + 0.5*XN15 + 2*XN20)  +
         CN3*XN3 + CN5*XN5 + CN15*XN15 + CN20*XN20  +

         CM*(0.3*XM3 + 1*XM10 + 1.5*XM15)+
         CM3*XM3 + CM10*XM10 + CM15*XM15+

         CW*(0.3*XW3 + 0.5*XW5 + 1.5*XW15 + 5*XW50 + 8*XW80)+
         CW3*XW3 + CW5*XW5 + CW15*XW15 + CW50*XW50 + CW80*XW80+

         CWH*XWH
)

;

C1..     XWDI      =L= WD ;
C2..     XWD       =L= (1/100)*ALPHA*XWDI;
C3..     XSO + XSK =L= XWD;

C4..     XSO =L= O;
C5..     XO  =L= BETA * XSO;
C6..     XOD + XON + XOM + XOW =L= XO;

C7..    XSK =L= K;
C8..    XK =L= GAMA * XSK;

C9..    0.3*XD3 + 0.5*XD5 + 1.5*XD15 + 5*XD50 =L= D;
C10..   0.3*XD3 + 0.5*XD5 + 1.5*XD15 + 5*XD50 =L= T1 * XOD;
C11..   XD3 =L= D3;
C12..   XD5 =L= D5;
C13..   XD15 =L= D15;
C14..   XD50 =L= D50;
C15..   XD3 =E= 24 * K1;
C16..   XD5 =E= 24 * K2;
C17..   XD15 =E= 6 * K3;

C18..   0.3*XN3 + 0.5*XN5 + 1.5*XN15 + 2*XN20 =L= N;
C19..   0.3*XN3 + 0.5*XN5 + 1.5*XN15 + 2*XN20 =L= T2 * XON;
C20..   XN3 =L= N3;
C21..   XN5 =L= N5;
C22..   XN15 =L= N15;
C23..   XN20 =L= N20;
C24..   XN3 =E= 24 * K4;
C25..   XN5 =E= 24 * K5;
C26..   XN15 =E= 6 * K6;

C27..   0.3*XM3 + 1*XM10 + 1.5*XM15 =L= M;
C28..   0.3*XM3 + 1*XM10 + 1.5*XM15 =L= T3 * XOM;
C29..   XM3 =L= M3;
C30..   XM10 =L= M10;
C31..   XM15 =L= M15;
C32..   XM3 =E= 24 * K7;
C33..   XM10 =E= 6 * K8;
C34..   XM15 =E= 6 * K9;


C35..   0.3*XW3 + 0.5*XW5 + 1.5*XW15 + 5*XW50 + 8*XW80 =L= W;
C36..   0.3*XW3 + 0.5*XW5 + 1.5*XW15 + 5*XW50 + 8*XW80 =L= T4 * XOW;
C37..   XW3 =L= W3;
C38..   XW5 =L= W5;
C39..   XW15 =L= W15;
C40..   XW50 =L= W50;
C41..   XW80 =L= W80;
C42..   XW3 =E= 24 * K10;
C43..   XW5 =E= 24 * K11;
C44..   XW15 =E= 6 * K12;

C45..   XWH =L= XK;
C46..   XWH =L= WHZ;
C47..   XWH =L= WHF;

Model O_Model /All/;

File aO_Model /Results.txt/;

Puttl aO_Model 'Title ' System.title, @60 'Page ' System.page//;

Put aO_Model ;

WD=11000;WS=1000;O=11400;K=1400;D=400;D3=200;D5=300;D15=300;D50=300;
N=500;N3=300;N5=300;N15=300;N20=300;
M=1000;M3=300;M10=300;M15=300;
W=10000;W3=300;W5=300;W15=300;W50=300;W80=300;
CWS=300;CO=300;CK=300;
CD=300;CD3=300;CD5=300;CD15=300;CD50=300;
CN=300;CN3=300;CN5=300;CN15=300;CN20=300;
CM=300;CM3=300;CM10=1;CM15=1;
CW=300;CW3=300;CW5=300;CW15=300;CW50=300;CW80=300;
CWH=300;WHZ=300;WHF=300;
RD3=300;RD5=300;RD15=1400;RD50=4500;
RN3=7500;RN5=800;RN15=500;RN20=400;
RM3=700;RM10=600;RM15=500;
RW3=5400;RW5=8571;RW15=1450;RW50=1240;RW80=1350;RWH=12554;
ALPHA=0.3;BETA=0.2;GAMA=0.41;
T1=0.2;T2=0.3;T3=0.5;T4=0.44;

Solve O_Model Using MIP Maximizing z;

PUT Z.L;
Put/;
PUT XWD.L;PUT XD3.L;PUT XD5.L;PUT XD15.L;
Put/;
PUT XD50.L;PUT XN3.L;PUT XN5.L;PUT XN15.L;
Put/;
PUT XN20.L;PUT XM3.L;PUT XM10.L;PUT XM15.L;
Put/;
PUT XW3.L;PUT XW5.L;PUT XW15.L;PUT XW50.L;
Put/;
PUT XW80.L;PUT XWH.L;PUT XWDI.L;PUT XOD.L;
Put/;
PUT XON.L;PUT XOM.L;PUT XOW.L;PUT XSO.L;
Put/;
PUT XSK.L;PUT XO.L;PUT XK.L;

Put/;





