from flask import Blueprint, request, jsonify
from app.extensions import db
from app.models.chat import Chat

chat_bp = Blueprint("chat_bp", __name__)

@chat_bp.route("/chats", methods=["POST"])
def create_chat():
    data = request.get_json()

    if not data:
        return jsonify({"error": "JSON body is required"}), 400

    chat = Chat(
        name     = data.get("name"),
        is_group = data.get("is_group", False)

    )

    db.session.add(chat)
    db.session.commit()

    return jsonify({"id": chat.id}), 201


@chat_bp.route("/chats", methods=["GET"])
def get_chats():
    chats = Chat.query.all()

    return jsonify([
        {
            "id"        : chat.id,
            "name"      : chat.name,
            "is_group"  : chat.is_group,
            "created_at": chat.created_at.isoformat()

        }
        for chat in chats
    ])


@chat_bp.route("/chats/<int:chat_id>", methods =["GET"])
def fetch_chat():
    chat = Chat.query.get_or_404(chat.id)

    return jsonify([
        {
            "id"      : chat.id,
            "name"    : chat.name,
            "is_group": chat.is_group,
            "created_at":chat.created_at.isoformat()
        }

    ])