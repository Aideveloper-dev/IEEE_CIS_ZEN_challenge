from flask import Flask
from flask_cors import CORS
from app2.config import init_app, db, login_manager
from app2.models.user import User

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

def create_app():
    app = init_app()
    
    # Configure CORS properly
    CORS(app, resources={
        r"/*": {
            "origins": "*",
            "methods": ["GET", "POST", "OPTIONS"],
            "allow_headers": ["Content-Type", "Authorization"]
        }
    })

    # Register blueprints
    from app2.routes.auth import auth
    from app2.routes.avatar import avatar
    #from app2.routes.clothing import clothing
    from app2.routes.clothing import clothing_bp

    app.register_blueprint(auth)
    app.register_blueprint(avatar, url_prefix='/avatar')
    #app.register_blueprint(clothing, url_prefix='/clothing')

    
    app.register_blueprint(clothing_bp)
    # Create database tables
    with app.app_context():
        db.create_all()

    return app 
