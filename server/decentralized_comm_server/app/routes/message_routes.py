from flask import Blueprint, request, jsonify
from app.extensions import db
from app.models.message import Message

message_bp = Blueprint("message_bp",__name__)

@message_bp.route("/messages", methods = ["POST"])
def send_message():
    data = request.get_json()

    required_fields = {"chat_id", "sender_id", "content"}

    if not data or not required_fields.issubset(data):
        return jsonify({"error": "chat_id, sender_id and content is required"}), 400



    message = Message(
          chat_id   = data["chat_id"]
        , sender_id = data["sender_id"],
        content= data["content"]
    )

    db.session.add(message)
    db.session.commit()

    return jsonify({
        "id"        : message.id,
        "chat_id"   : message.chat_id,
        "sender_id" : message.sender_id,
        "content"   : message.content,
        "created_at": message.created_at.isoformat()

    }), 201


@message_bp.route("/messages/<int:chat_id>", methods=["GET"])
def get_messages(chat_id):
    messages = (
        Message.query.filter_by(chat_id=chat_id).order_by(Message.created_at.asc()).all()
        )

    return jsonify([
        {
            "id"       : message.id,
            "chat_id"  : message.chat_id,
            "sender_id": message.sender_id,
            "content"  : message.content,
            "created_at":message.created_at.isoformat()
        }

        for message in messages
    ])
