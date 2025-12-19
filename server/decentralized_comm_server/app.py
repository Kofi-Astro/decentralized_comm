from datetime import datetime
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase



class Base(DeclarativeBase):
    pass

db = SQLAlchemy(model_class=Base)


# Create my flask app
app = Flask(__name__)

  # configure the SQLite database, relative to the app instance folder
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///decen_comm.db"

db.init_app(app)




#Data Class // Row of data
class User(db.Model):
    id         = db.Column(db.Integer,primary_key=True )
    username   = db.Column(db.String(20), nullable = False, unique = True)
    password   = db.Column(db.String(50), nullable = False)
    created_at = db.Column(db.DateTime, default = datetime.now)

    def __repr__(self):
        return f"User {self.username} and {self.id}"












  # Routes to various functions
@app.route("/")
def index():
    return 'this is the starting page'

@app.route("/register", methods = ["POST"])
def registerUser():
    return;

@app.route("/login", methods = ["PUT", "GET"])
def loginUser():
    return









if   __name__ == "__main__":
    with app.app_context()     :
        db.create_all()

    app.run(debug=True)