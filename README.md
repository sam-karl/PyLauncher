# PyLauncher
PyLauncher is a simple utility that uses batch (.bat) files to streamline the setup and management of Python environments. It checks if Python is installed, installs it if necessary (along with required dependencies), and offers two main functionalities:

1. Flask Web Launcher: Launches a Flask app to serve static built web files.
2. Script Launcher: Looks for Python scripts within a scripts folder and presents a GUI for selecting and launching the desired script.

# Getting Started
• Windows OS: PyLauncher uses batch files (.bat), so it's designed for Windows environments.

# Installation
1. Clone the repository
   ```
   git clone https://github.com/sam-karl/PyLauncher.git
   ```
2. Double click Web_Pylauncher or Pylauncher(.bat) files
3. Wait for default browser or script launcher GUI to launch

# Notes
• The scripts launcher creates a local version of the gui inside the users temp folder. This allows this script to be more portable and be dragged into any folder containing a scripts folder and the .bat will be able to find the .py files.
• The libraries that are installed are defined wihtin the .bat file, this could be altered to use a requirements file if it exists.
• This program should work with Anaconda but I have not tested it as much.



