from datetime import datetime
from sqlalchemy.sql import func
from app.extensions import db


class User(db.Model):
    __tablename__ = "users"

    id         = db.Column(db.Integer, primary_key = True)
    username   = db.Column(db.String(80), unique = True, nullable = False)
    password   = db.Column(db.String(120), nullable = False)
    created_at = db.Column(db.DateTime(timezone = True), server_default= func.now())

    def __repr__(self):
        return super().__repr__()