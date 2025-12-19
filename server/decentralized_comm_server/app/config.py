import os


class Config:
    SQLALCHEMY_DATABASE_URI        = "sqlite:///decentralized_comm.db"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = os.getenv("SECRET_KEY", "dev-secret-key")