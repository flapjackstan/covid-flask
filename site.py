import pandas as pd
from src.db_tools import getKeys, query, CallProcedure
from src.converter import Borough, convertBorough, convertHospitals
from src.form import SchoolForm
from flask import Flask, render_template, abort, url_for, redirect, request, flash

app = Flask(__name__)
app.config['SECRET_KEY'] = 'you-will-never-guess'

keys_path = '../keys.yaml'
keys = getKeys(keys_path)

@app.route("/")
def index():

    table = 'Boroughs'
    statement = 'SELECT * FROM '

    df = query(keys, table, statement)
    borough = convertBorough(df)

    #dictionary with code val as key
    #borough_by_code = {borough.code: borough for borough in borough}
    
    procedure = 'CALL BoroughCases()'
    
    df = CallProcedure(keys, procedure)

    return render_template('index.html', tables=[df.to_html(classes='data')], titles=df.columns.values, borough=borough)
    
    
@app.route("/form", methods = ['GET', 'POST'])
def form():
    form = SchoolForm(request.form)
    if request.method == 'POST' and form.validate():
        result = request.form
        
        school = School(result['code'],result['school'],result['latitude'],result['longitude'])
        
        flash('Thanks for registering') # how do i get this to flash tho?
        print(school.getName())
        print(insert('Schools', school))
        # do stuff when the form is submitted then redirect

        
        return redirect(url_for('index'))

    # show the form, it wasn't submitted
    return render_template('form.html', form=form)

@app.route("/<borough_name>")
def show_hospitals(borough_name):
    
    procedure = 'CALL HospitalsByBorough(\"' + borough_name + '\")'
    print(procedure)
    
    df = CallProcedure(keys, procedure)
    hospitals = convertHospitals(df)

    # dictionary with code val as key
    # borough_by_name = {borough.name: borough for borough in borough}
    
    # borough = borough_by_key.get(school_name)
    if hospitals:
        return render_template('leaf.html', hospitals=hospitals)
    else:
        abort(404)

app.run(host='localhost', debug=True)