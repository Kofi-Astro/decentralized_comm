from flask import Blueprint, request, jsonify
from app.extensions import db
from app.models.user import User

user_bp = Blueprint('user', __name__)

@user_bp.route("/users", methods=["POST"])
def create_user():
    data = request.get_json()

    if not data:
        return jsonify({"error": "JSON body is required"}), 400

    if "username" not in data or "password" not in data:
        return jsonify({"error": "username and password are required"}), 400

    new_user = User(
        username = data["username"],
        password = data["password"],
    )

    db.session.add(new_user)
    db.session.commit()

    return jsonify({
        "id"        : new_user.id,
        "username"  : new_user.username,
        "created_at": new_user.created_at.isoformat(),

    }), 201


@user_bp.route("/users", methods=["GET"])
def get_users():
    users = User.query.all()

    return jsonify([{
          "id"        : user.id,
          "username"  : user.username,
          "created_at": user.created_at.isoformat()
          }
          for user in users
          ])

    # return jsonify([{
    #     "id"        : user.id,
    #     "username"  : user.username,
    #     "created_at": user.created_at.isoformat()
    #     } for user in users])



@user_bp.route("/users/<int:user_id>", methods=["GET"])
def get_user(user_id):
    user = User.query.get_or_404(user_id)

    return jsonify({
        "id"        : user.id,
        "username"  : user.username,
        "created_at": user.created_at.isoformat()
    })
