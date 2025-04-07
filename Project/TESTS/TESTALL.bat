@echo off
D:
CD D:\PROJECT
echo Trying to compile EXE
CALL TESTS\EXE.BAT PROJ

CD D:\PROJECT\TESTS
TASM cmp.asm > NUL
TLINK cmp > NUL
del /q PROJ.EXE > NUL

COPY D:\PROJECT\PROJ.EXE . > NUL
DEL D:\RESULT.TXT > NUL

echo Testing...
echo ================================================

echo V2_01
CALL TESTONE V2_01

echo MT_BN
CALL TESTONE MT_BN

echo MT_BNN
CALL TESTONE MT_BNN

echo MT_SN
CALL TESTONE MT_SN

echo MT_SNN
CALL TESTONE MT_SNN

echo MT_MSN
CALL TESTONE MT_MSN

echo MT_MSNN
CALL TESTONE MT_MSNN

echo MT_MBN
CALL TESTONE MT_MBN

echo MT_MBNN
CALL TESTONE MT_MBNN

echo ================================================

:end
del PROJ.*
del CMP.OBJ
del CMP.EXE
del CMP.MAP

type D:\RESULT.TXT
