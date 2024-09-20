@echo off
REM List of libraries to check for
set "libraries= pandas,matplotlib,pyodbc,sqlalchemy, tk,openpyxl, pymssql, flask, python-dateutil, scipy"
set python_path=""
set pip_folder=""
set python_locations=C:\Anaconda;%userprofile%\Anaconda;%userprofile%\Miniconda;C:\Python,%userprofile%\AppData\Local\Continuum\anaconda
pip --version > nul 2>&1
if errorlevel 1 (
    echo pip is not setup in environment
    REM Navigate to the directory where pip is installed
    for /D %%i in (%python_locations%) do (
        echo Checking for Python in %%i*
        for /D %%d in (%%i*) do (
            set python_path=%%~fd
            set pip_folder=%%~fd\Scripts
            goto :install_libraries
        )
    )
    :choice
    set /p choice=Install Python? [Y/N]: 
    if /i "%choice%"=="Y" (
        echo Installing python
        REM Add your code here
        set python_path="C:\Python"
        set pip_folder="C:\Python\Scripts"
        curl -L https://www.python.org/ftp/python/3.11.2/python-3.11.2-amd64.exe -o "%userprofile%\Downloads\python.exe"
        "%userprofile%\Downloads\python.exe" /quiet TargetDir="C:\Python"
        echo Python 3.11.2 installed to "C:\Python".
        del "%userprofile%\Downloads\python.exe"
        echo setting paths...
        setx PATH "C:\Python;%PATH%" /M
        setx PATH "C:\Python\Scripts;%PATH%" /M
        setx PATH "C:\Python\Bin;%PATH%" /M
        goto :install_libraries
    ) else if /i "%choice%"=="N" (
        echo goodbye
        exit /b 1
    ) else (
        echo Invalid Choice
        goto :choice
    )

) else (
    for /F "delims=" %%i in ('where /F pip') do (
    set "pip_folder=%%~dpi"
    goto :break1
    )
    :break1
    for /F "delims=" %%i in ('where /F python') do (
    set "python_path=%%~dpi"
    goto :break2
    )
    :break2
    echo python/pip found in global environment
    )


:install_libraries
pushd %pip_folder%
echo Setting python Directory to %python_path%
echo Setting pip Directory to %pip_folder%

REM Get a list of all installed packages
if exist %pip_folder%\conda.exe (
    echo conda installed
    set install_command=conda
) else (
    set install_command=pip
)
%install_command% list > "%TEMP%\pip_list.txt"
echo list of installed libraries created
echo installing missing libraries
for %%i in (%libraries%) do (
    REM Check if the library is in the pip list
    findstr /i "%%i" "%TEMP%\pip_list.txt" > nul
    REM If the library is not installed, install it using pip
    echo checking for %%i
    if errorlevel 1 (
        REM This line prints a message indicating that the library is being installed
        echo Installing %%i...
        %install_command% install %%i
        if errorlevel 1 (
            REM This line prints an error message if there was an issue installing the library
            echo ERROR: Could not install %%i
        )
    ) else (
        REM This line prints a message indicating that the library was found
        echo %%i found.
    )
)

REM Delete the pip list file

del "%TEMP%\pip_list.txt"

REM Change back to the original directory
popd

REM Switch to Python code

echo Launching "%~dp0web\app.py"

@echo off
start /min cmd /c "timeout /t 3 /nobreak > NUL && start http://127.0.0.1:5001"

%python_path%\python "%~dp0web\app.py"

