import os
from flask import Flask, send_from_directory, jsonify, render_template,make_response

# Get the directory where the Python file is running
current_directory = os.path.dirname(os.path.abspath(__file__))

# Define the static path
static_folder_path = os.path.join(current_directory, 'dist')

# Define the index path
template_folder_path = os.path.join(current_directory, 'dist')

# Create the Flask app
app = Flask(__name__, static_folder=static_folder_path, template_folder=template_folder_path)

# Set the cache control max age for static files to 1 day
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 31536000/365

# Serve React App
@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve(path):
    if path != "" and os.path.exists(app.static_folder + '/' + path):
        return send_from_directory(app.static_folder, path)
    else:
        return render_template('index.html')
    
if __name__ == '__main__':
    app.run(debug=True, port=5001)