from app import create_app
from flask_cors import CORS
import os

app = create_app()
CORS(app)

if __name__ == '__main__':
    base_dir = os.path.dirname(os.path.abspath(__file__))
    clothing_dir = os.path.join(base_dir, 'static', '3D_CLOTHING')
    print(f"Server starting. Base directory: {base_dir}")
    print(f"Looking for 3D_CLOTHING in: {clothing_dir}")
    
    # Check if directory exists
    if not os.path.exists(clothing_dir):
        print(f"WARNING: 3D_CLOTHING directory not found at {clothing_dir}")
    else:
        print("Available files in 3D_CLOTHING:")
        for file in os.listdir(clothing_dir):
            print(f" - {file}")
    
    app.run(debug=True, host='0.0.0.0', port=5000) 
