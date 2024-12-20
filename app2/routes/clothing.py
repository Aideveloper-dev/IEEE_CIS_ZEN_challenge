from flask import Blueprint, request, jsonify
import os
import open3d as o3d
import numpy as np

# Create blueprint with a URL prefix
clothing_bp = Blueprint('clothing', __name__, url_prefix='/clothing')

# Now the route is relative to the blueprint's prefix
@clothing_bp.route('/update_cloth', methods=['POST'])
def update_cloth():
    try:
        data = request.get_json()
        if not data:
            print("No data received")
            return jsonify({'success': False, 'error': 'No data received'}), 400

        cloth = data.get('cloth')
        size = data.get('size')
        
        print(f"Received request for cloth: {cloth}, size: {size}")

        if not cloth or not size:
            print("Missing parameters")
            return jsonify({'success': False, 'error': 'Missing cloth or size parameter'}), 400

        # Get the absolute path to the 3D_CLOTHING directory
        base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        clothing_dir = os.path.join(base_dir, 'static', '3D_CLOTHING')
        full_path = os.path.join(clothing_dir, cloth)

        print(f"Looking for file at: {full_path}")
        
        # Check if file exists
        if not os.path.exists(full_path):
            print(f"File not found: {full_path}")
            return jsonify({
                'success': False, 
                'error': f'File not found: {cloth}',
                'path_checked': full_path
            }), 404

        # Load the mesh
        try:
            mesh = o3d.io.read_triangle_mesh(full_path)
            print(f"Successfully loaded mesh file")
        except Exception as e:
            print(f"Error reading mesh file: {str(e)}")
            return jsonify({
                'success': False,
                'error': f'Error reading mesh file: {str(e)}'
            }), 500

        if not mesh.has_vertices():
            print("Loaded mesh has no vertices")
            return jsonify({
                'success': False,
                'error': 'Loaded mesh has no vertices'
            }), 400

        # Convert mesh data
        vertices = np.asarray(mesh.vertices).tolist()
        triangles = np.asarray(mesh.triangles).tolist()

        print(f"Successfully processed mesh with {len(vertices)} vertices")

        return jsonify({
            'success': True,
            'cloth_vertices': vertices,
            'cloth_triangles': triangles,
            'size': size
        })

    except Exception as e:
        print(f"Server error: {str(e)}")
        return jsonify({
            'success': False,
            'error': str(e),
            'type': str(type(e))
        }), 500

from flask import send_file

@clothing_bp.route('/models/<path:filename>')
def serve_model(filename):
    return send_file(f'static/models/{filename}')