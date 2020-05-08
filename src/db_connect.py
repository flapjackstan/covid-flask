import yaml
import sqlalchemy
import pandas as pd

    #import mysql.connector
    #cnx = mysql.connector.connect(user=user, password=pw,host=host, database=db)
    #cnx.close()

# https://cloud.google.com/sql/docs/mysql/connect-external-app?authuser=1#python

def query(table, statement):


    with open(r'../test_keys.yaml') as file:
        keys = yaml.load(file, Loader=yaml.FullLoader)

    user = keys['user']
    pw = keys['password']
    host = keys['host']
    db = keys['database']
    conn = keys['conn']
    key = keys['key']

    s=('mysql://{username}:{password}@{host}/{db_name}?charset=utf8'
        '&unix_socket=/cloudsql/{instance_connection_name}'
        .format(username=user, password=pw, host=host, db_name=db, instance_connection_name=conn)) ## both conn and key work here

    engine = sqlalchemy.create_engine(s, echo=True)
    connection = engine.connect()
    
    df = pd.read_sql(statement + table, engine)
    connection.close()
    return df
    
    
    #how do i test this?????
def insert(table, obj):

    with open(r'../test_keys.yaml') as file:
        keys = yaml.load(file, Loader=yaml.FullLoader)

    user = keys['user']
    pw = keys['password']
    host = keys['host']
    db = keys['database']
    conn = keys['conn']
    key = keys['key']

    s=('mysql://{username}:{password}@{host}/{db_name}?charset=utf8'
        '&unix_socket=/cloudsql/{instance_connection_name}'
        .format(username=user, password=pw, host=host, db_name=db, instance_connection_name=conn)) ## both conn and key work here

    engine = sqlalchemy.create_engine(s, echo=True)
    connection = engine.connect()
    
    sql = ("INSERT INTO {table}(Code, Name, Latitude, Longitude) VALUES(\"{Code}\",\"{Name}\",{Latitude},{Longitude});"
          .format(table=table, Code=obj.getKey(), Name=obj.getName(), Latitude=obj.getLat(), Longitude=obj.getLong()))
    
    connection.execute(sqlalchemy.text(sql))
    
    connection.close()
    
    # text = ("INSERT INTO ?(Code, Name, Latitude, Longitude)"
           # "VALUES (?,?,?,?)", (table,obj.getSchool()))


    # return text
    
#meta = sqlalchemy.MetaData()

# -------------------------------------------------------------------
# created a table in the database
# t1 = sqlalchemy.Table('Table_1', meta,
           # sqlalchemy.Column('id', sqlalchemy.Integer, primary_key=True),
           # sqlalchemy.Column('name',sqlalchemy.String(80)))

# print(meta)
# meta.create_all(engine)

# connection.execute(sqlalchemy.text(''' CREATE TABLE Cars(Id INTEGER PRIMARY KEY, 
                                                         # Name TEXT, 
                                                         # Price INTEGER)'''))
                                                         
                                                         

#connection.execute(sqlalchemy.text(''' DROP TABLE Schools''')) 

# cant use long for Longitude
# connection.execute(sqlalchemy.text(''' CREATE TABLE Schools(Id INTEGER AUTO_INCREMENT,
                                                            # Code TEXT,
                                                            # Name TEXT, 
                                                            # Latitude FLOAT,
                                                            # Longitude FLOAT,
                                                            # PRIMARY KEY (Id))''')) 

# -------------------------------------------------------------
# df = pd.read_csv('../data/schools.csv')
# df.head()
# df.to_sql('Schools',engine, if_exists = 'append', index = False)
# -----------------------------------------------------------------
# inspector = sqlalchemy.inspect(engine)

#print('tables available: ',engine.table_names())
# print(inspector.get_columns('Table_1'))

# ---------------------------------------------------------------


