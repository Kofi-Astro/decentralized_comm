# from flask import Blueprint, request, jsonify
# from sqlalchemy import func
# from app.extensions import db
# from app.models.chat import Chat, ChatParticipant

# chat_bp = Blueprint("chat_bp", __name__)

# @chat_bp.route("/chats", methods=["POST"])
# def create_or_fetch_chat():
#     data = request.get_json()

#     if not data or "user_ids" not in data:
#         return jsonify({"error": "user_ids is required"}), 400

#     user_ids = data["user_ids"]

#     if len(user_ids) < 2:
#         return jsonify({"error": "At least 2 users required"}), 400

#       # Try to find existing chats first
#     existing_chat = (
#         db.session.query(Chat).join(ChatParticipant).filter(ChatParticipant.user_id.in_(user_ids)).group_by(Chat.id).having(func.count(Chat.id)==len(user_ids)).scalar()
#     )

#     if existing_chat:
#         return jsonify({
#             "id"      : existing_chat.id,
#             "is_group": existing_chat.is_group,
#             "created_at":existing_chat.created_at.isoformat(),
#         }), 200
# scalar

# #Create new chat
#     chat = Chat(is_group = False)

#     db.session.add(chat)
#     db.session.flush() # get chat.id

#       # Attach Participants
#     for uid in user_ids:
#         db.session.add(ChatParticipant(chat_id=chat.id, user_id=uid))

#     db.session.commit()

#     return jsonify({"id": chat.id,  "is_group":chat.is_group, "created_at":chat.created_at.isoFormat(),},), 201



# @chat_bp.route("/chats", methods=["GET"])
# def get_chats():
#     user_id = request.args.get("user_id", type=int)

#     if not user_id:
#         return jsonify({"error":"user_id required"}), 400

#     chats = (
#        db.session.query(Chat).join(ChatParticipant).filter(ChatParticipant.user_id == user_id).all()
#    )


#     return jsonify([
#         {
#             "id"      : chat.id,
#             "is_group": chat.is_group,
#             "created_at": chat.created_at.isoformat()

#         }
#         for chat in chats
#     ])


# @chat_bp.route("/chats/<int:chat_id>", methods =["GET"])
# def fetch_chat(chat_id):
#     chat = Chat.query.get_or_404(chat_id)

#     return jsonify([
#         {
#             "id"      : chat.id,
#             "name"    : chat.name,
#             "is_group": chat.is_group,
#             "created_at":chat.created_at.isoformat()
#         }

  #     ])


from flask import Blueprint, request, jsonify
from sqlalchemy import func
from app.extensions import db
from app.models.chat import Chat, ChatParticipant
from app.models.user import User

chat_bp = Blueprint("chat_bp", __name__)

# ---------------- CREATE OR FETCH CHAT ----------------
@chat_bp.route("/chats", methods=["POST"])
def create_or_fetch_chat():
    data = request.get_json()

    if not data or "user_ids" not in data:
        return jsonify({"error": "user_ids is required"}), 400

    user_ids = data["user_ids"]

    if len(user_ids) < 2:
        return jsonify({"error": "At least 2 users required"}), 400

    # 🔹 Try to find existing chat
    existing_chat = (
        db.session.query(Chat)
        .join(ChatParticipant)
        .filter(ChatParticipant.user_id.in_(user_ids))
        .group_by(Chat.id)
        .having(func.count(ChatParticipant.user_id) == len(user_ids))
        .scalar()
    )

    if existing_chat:
        return jsonify({
            "id": existing_chat.id,
            "is_group": existing_chat.is_group,
            "created_at": existing_chat.created_at.isoformat()
        }), 200

    # 🔹 Create new chat (NO COMMA!)
    chat = Chat(is_group=False)
    db.session.add(chat)
    db.session.flush()  # ensures chat.id exists

    # 🔹 Attach participants
    for uid in user_ids:
        db.session.add(
            ChatParticipant(chat_id=chat.id, user_id=uid)
        )

    db.session.commit()

    return jsonify({
        "id": chat.id,
        "is_group": chat.is_group,
        "created_at": chat.created_at.isoformat()
    }), 201


# ---------------- GET USER CHATS ----------------
@chat_bp.route("/chats", methods=["GET"])
def get_chats():
    user_id = request.args.get("user_id", type=int)

    if not user_id:
        return jsonify({"error": "user_id required"}), 400



    chats = (
        db.session.query(Chat)
        .join(ChatParticipant)
        .filter(ChatParticipant.user_id == user_id)
        .all()
    )

    response = []

    for chat in chats:
          # Find recipient
        recipient = (
            db.session.query(User).join(ChatParticipant).filter(ChatParticipant.chat_id == chat.id , ChatParticipant.user_id!= user_id).first()
        )
        if not chat.is_group and not recipient:
            continue

        response.append({
            "id"        : chat.id,
            "is_group"  : chat.is_group,
            "created_at": chat.created_at,
            "recipient":{
                "id": recipient.id,
                "username":recipient.username
            } if recipient else None
        })

      # return jsonify([
      #     {
      #         "id": chat.id,
      #         "is_group": chat.is_group,
      #         "created_at": chat.created_at.isoformat()
      #     }
      #     for chat in chats])

    return jsonify(response)



# ---------------- FETCH SINGLE CHAT ----------------
@chat_bp.route("/chats/<int:chat_id>", methods=["GET"])
def fetch_chat(chat_id):
    chat = Chat.query.get_or_404(chat_id)

    return jsonify({
        "id": chat.id,
        "is_group": chat.is_group,
        "created_at": chat.created_at.isoformat()
    })