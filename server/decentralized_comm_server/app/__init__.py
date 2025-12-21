from flask import Flask
from .config import Config
from .extensions import db
from .routes.user_routes import user_bp
from .routes.chat_routes import chat_bp
from .routes.message_routes import message_bp
# from .routes.message_routes import message_bp


def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

      # Initialize extensions
    db.init_app(app)

      # Register blueprints
    app.register_blueprint(user_bp)
    app.register_blueprint(chat_bp)
    app.register_blueprint(message_bp)


    with app.app_context():
        db.create_all()

    return app