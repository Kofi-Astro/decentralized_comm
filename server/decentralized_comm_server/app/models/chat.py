from datetime import datetime
from app.extensions import db
from sqlalchemy.sql import func

class Chat(db.Model):
    __tablename__ = "chats"

    id         = db.Column(db.Integer, primary_key=True)
    name       = db.Column(db.String(100), nullable=False)
    is_group   = db.Column(db.Boolean, default = False)
    created_at = db.Column(db.DateTime(timezone = True), server_default = func.now())

    messages = db.relationship("Message", backref= "chat", lazy = True)


    def __repr__(self):
        return f"<Chat {self.id}>"