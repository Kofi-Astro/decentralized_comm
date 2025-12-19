from flask import Flask
from .config import Config
from .extensions import db
from .routes.user_routes import user_bp

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

      # Initialize extensions
    db.init_app(app)

      # Register blueprints
    app.register_blueprint(user_bp)

    with app.app_context():
        db.create_all()

    return app