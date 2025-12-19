from sqlalchemy import  text, create_engine
from sqlalchemy.orm import Session

engine = create_engine( "sqlite+pysqlite:///memory.db", echo= True)

# commit as you go
# with engine.connect() as conn:
#     # result = conn.execute(text("select 'hello world' "))
#     # print(result.all)

#         # conn.execute(text("CREATE TABLE some_table3 (x int, y int)"))
#     conn.execute(text("INSERT INTO some_table3 (x, y) VALUES (:x, :y)"),[{"x": 1, "y": 1}, {"x":2, "y":4}, {"x":2, "y":6}],)
#     conn.commit()


# with engine.begin() as conn:

  #     # conn.execute(text("CREATE TABLE some_table (x int, y int)"))
  #     conn.execute(text("INSERT INTO some_table3 (x, y) VALUES (:x, :y)"),
  #                  [
  #                      {"x":2, "y":45},
  #                      {"x": 13, "y": 16}
  #                  ])
  #     conn.commit()

with engine.connect() as conn:
    result = conn.execute(text("SELECT x, y from some_table3"))
    for row in result:
        print(f"x: {row.x}, y: {row.y}")

    lay = conn.execute(text("SELECT x, y  FROM some_table3 WHERE y>5"))
    for row in lay:
        print(f"x: {row.x}, y: {row.y}")


stmt = text("SELECT x, y FROM some_table3 WHERE y> :y ORDER BY x, y")

with Session(engine) as session:
    result = session.execute(stmt, {"y": 3})
    for row in result:
        print(f"x: {row.x}, y: {row.y}")