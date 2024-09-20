@echo off
REM List of libraries to check for
set "libraries= pandas,matplotlib,pyodbc,sqlalchemy,tkcalendar,tk,openpyxl,streamlit, pymssql, xlsxwriter"
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
set TMPFILE=%TEMP%\PyLauncher_Temp.py
del %TMPFILE%
echo Python code starting...   
echo from glob import glob>> %TMPFILE%      
echo import os>> %TMPFILE%      
echo import sys>> %TMPFILE%     
echo import subprocess>> %TMPFILE%     
echo from tkinter import *>> %TMPFILE%      
echo import tkinter as tk>> %TMPFILE%       
echo from tkinter import ttk>> %TMPFILE%        
echo # Get the path to the current script or frozen executable>> %TMPFILE%      
echo try:>> %TMPFILE%       
echo     python_exe = sys.argv[1]>> %TMPFILE%    
echo     app_path = sys.argv[2]>> %TMPFILE% 
echo except:>> %TMPFILE%        
echo     python_exe = ''>> %TMPFILE%
echo     app_path = os.path.dirname(os.path.abspath(__file__))>> %TMPFILE%
echo # Get a list of all Python files in the app directory>> %TMPFILE%      
echo all_files = glob('{}/**/*.{}'.format(app_path, 'py'), recursive=True)>> %TMPFILE%     
echo # Filter out files with a specific name (e.g. 'PyLauncher_Temp.py')>> %TMPFILE%      
echo python_files = [f for f in all_files if not f.endswith('PyLauncher_Temp.py')]>> %TMPFILE%        
echo # Get the name of each Python file (without the .py extension)>> %TMPFILE%     
echo name_list = [os.path.splitext(os.path.basename(f))[0] for f in python_files]>> %TMPFILE%    
echo def open_program(i, python_files):>> %TMPFILE%     
echo     # Get the file path of the selected Python file>> %TMPFILE%        
echo     file_path = python_files[i]>> %TMPFILE%        
echo     # Launch the selected Python file using the full path to the Python executable>> %TMPFILE%     
echo     print('Launching: ', python_files[i])>> %TMPFILE%      
echo     if python_exe == '':>> %TMPFILE%       
echo         print('From: default python directory')>> %TMPFILE%        
echo         subprocess.call(['python', file_path])>> %TMPFILE%     
echo     else:>> %TMPFILE%      
echo         print('From:',python_exe)>> %TMPFILE%      
echo         subprocess.call([python_exe+'\python', file_path])>> %TMPFILE%              
echo # Get the full path to the Python executable from the command line arguments>> %TMPFILE%       
       
echo # Create the GUI>> %TMPFILE%       
echo root = tk.Tk()>> %TMPFILE%     
echo root.title('PyLauncher')>> %TMPFILE%
echo dark_style = ttk.Style()>> %TMPFILE%       
echo dark_style.theme_use('clam')>> %TMPFILE%       
echo dark_style.configure('.', background='#3E3E3E', foreground='#F8F8F8', font=('TkDefaultFont', 11))>> %TMPFILE%      
echo dark_style.configure('TLabel', background='#3E3E3E', foreground='#F8F8F8')>> %TMPFILE%     
echo dark_style.configure('TNotebook', background='#3E3E3E', foreground='#F8F8F8', bordercolor='#3E3E3E')>> %TMPFILE%       
echo dark_style.configure('TNotebook.Tab', background='#1C1C1C', foreground='#F8F8F8', padding=(10, 3))>> %TMPFILE%     
echo dark_style.map('TNotebook.Tab', background=[('selected', '#3E3E3E')], foreground=[('selected', '#F8F8F8')])>> %TMPFILE%        
echo # Add a tab control>> %TMPFILE%        
echo tab_control = ttk.Notebook(root)>> %TMPFILE%       
echo tab_control.grid(column=0, row=0)>> %TMPFILE%          
echo # Add a 'Run' tab>> %TMPFILE%      
echo tab1 = ttk.Frame(tab_control)>> %TMPFILE%      
echo tab_control.add(tab1, text='Run')>> %TMPFILE%         
echo # Add a label and buttons for each Python file>> %TMPFILE%     
echo from_label = ttk.Label(tab1, text='PyLauncher\nChoose a program:')>> %TMPFILE%       
echo from_label.grid(column=0, row=0, padx=5, pady=5, columnspan=3)>> %TMPFILE%           
echo n_columns=3 >> %TMPFILE%      
echo n_rows = int(len(name_list) / n_columns + 1)>> %TMPFILE%
echo i=0 >> %TMPFILE%
echo for r in range(1, n_rows + 1):>> %TMPFILE%     
echo     if r == n_rows:>> %TMPFILE%        
echo         n_columns = len(name_list) - (n_columns * (len(name_list) // n_columns))>> %TMPFILE%      
echo     for c in range(0, n_columns):>> %TMPFILE%      
echo         button = ttk.Button(tab1, text=name_list[i],>> %TMPFILE%       
echo                            command=lambda i=i: open_program(i, python_files))>> %TMPFILE%      
echo         button.grid(row=r, column=c)>> %TMPFILE%       
echo         i+=1 >> %TMPFILE%        
echo root.mainloop()>> %TMPFILE%
REM This launches the program launcher
echo Launching python from %python_path%
echo looking for .py files in %cd%
%python_path%\python %TEMP%\program_launcher_temp.py %python_path% "%cd%\scripts"

