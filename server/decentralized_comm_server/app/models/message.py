from datetime import datetime
from sqlalchemy.sql import func
from app.extensions import db


class Message(db.Model):
    __tablename__ = "messages"

    id = db.Column(db.Integer, primary_key=True)
    chat_id = db.Column(db.Integer, db.ForeignKey("chats.id"), nullable=False)
    sender_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable = False)
    content = db.Column(db.Text, nullable = False)
    created_at = db.Column(db.DateTime(timezone = True), server_default = func.now())

    def __repr__(self):
        return f"<Message {self.id}  chat={self.chat_id} sender={self.sender_id}>"