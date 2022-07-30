:: Run Docfx for a given git release

@echo off
setlocal

for %%I in ("%~dp0\..") do set "dir=%%~fI"
set src="%dir%\daggerfall-unity"
set docs="%dir%\daggerfall-unity-docs"

cd %src%

git checkout master
git fetch origin

echo Available tags:
git ls-remote --tags origin

echo.
set /p commit= "RESET daggerfall-unity master at commit: "
git reset --hard %commit%

for /f %%i in ('git describe --exact-match %commit%') do set tag=%%i

echo.
echo Updating C# solution...
"C:\Program Files\Unity\Hub\Editor\2019.4.40f1\Editor\Unity.exe" -batchmode -projectPath=%src% -executeMethod "UnityEditor.SyncVS.SyncSolution" -quit

cd %docs%

echo.
echo Running Docfx...
docfx

echo.
echo Committing %tag% to daggerfall-unity-docs...
git checkout master
git add *
git commit -m %tag%

pause