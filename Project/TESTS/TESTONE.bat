@echo off
D:
CD D:\PROJECT\TESTS

DEL %1.ACT > NUL
DEL %1.BAD > NUL
PROJ %2 < %1.IN > %1.ACT
CALL FC2 /B %1