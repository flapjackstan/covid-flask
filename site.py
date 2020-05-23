import pandas as pd
import geopandas as gpd
from flask import Flask, render_template, abort, url_for, redirect, request, flash

from src.db_tools import getKeys, query, CallProcedure
from src.converter import Borough, Patient, Results, convertBorough, convertHospitals
from src.form import PatientForm, UpdateForm

app = Flask(__name__)
app.config['SECRET_KEY'] = 'you-will-never-guess'

keys_path = 'keys.yaml'
keys = getKeys(keys_path)

zip_codes = gpd.read_file('data/spatial/shp/bor_zip_codes.shp')
zip_codes.crs= {'init': 'epsg:4326'} # WGS84

table = 'Boroughs'
statement = 'SELECT * FROM '

df = query(keys, table, statement)
borough = convertBorough(df)
    
borough_by_name = {borough.name: borough for borough in borough}

@app.route("/")
def index():
   
    procedure = 'CALL AllBoroughCases()'
    df = CallProcedure(keys, procedure, DQL=True)
    
    return render_template('index.html', tables=[df.to_html(classes='table table-striped table-hover', index=False)], titles=df.columns.values, borough=borough)
    
@app.route("/form_create", methods = ['GET', 'POST'])
def form_create():

    form = PatientForm(request.form)
    
    if request.method == 'GET':
        return render_template('form_create.html', form=form)
    
    if request.method == 'POST' and form.validate():
        form_input = request.form
        
        patient = Patient(form_input['first_name'],form_input['last_name'], form_input['id'],form_input['latitude'],form_input['longitude'], form_input['symptoms'])
        patient.geoLocate(zip_codes)
        
        procedure = 'CALL InsertPatient(\"' + patient.getFirst() + '\",\"' + patient.getLast() + '\", \"' + str(patient.getId()) + '\", \"' + str(patient.getLat()) + '\",\"' + str(patient.getLong()) + '\", \"' + str(patient.getZip()) + '\",\"' + patient.getSymptoms() + '\")'
        
        CallProcedure(keys, procedure, DDL=True)
        
        return redirect(url_for('index'))
        
    elif request.method != form.validate():
        flash('Error in processing patient')
        
        return render_template('form_create.html', form=form)
        
@app.route("/form_update", methods = ['GET', 'POST'])
def form_update():

    form = UpdateForm(request.form)
    form_input = request.form
    
    procedure = 'CALL PatientIds()'
    ids = CallProcedure(keys, procedure, DQL=True)
    
    if request.method == 'GET':
        return render_template('form_update.html', form=form)
    
    if request.method == 'POST' and form.validate() and int(form_input['id']) in ids.PID.values:
        form_input = request.form
        
        result = Results(form_input['id'], form_input['results'])
        
        procedure = 'CALL UpdatePatient(' + result.getId() + ', ' + result.getResults() + ');'
        #print(procedure)
        CallProcedure(keys, procedure, DML=True)
        
        return redirect(url_for('index'))
        
    if request.method == 'POST' and int(form_input['id']) not in ids.PID.values:
        flash('ID not recognized')
        return render_template('form_update.html', form=form)
    
    else:
        return render_template('form_update.html', form=form)

@app.route("/<borough_name>")
def show_hospitals(borough_name):
    
    boro = borough_by_name.get(borough_name)
    
    procedure = 'CALL HospitalsByBorough(\"' + borough_name + '\")'
    df = CallProcedure(keys, procedure, DQL=True)
    
    hospitals = convertHospitals(df)
    
    procedure = 'CALL ZipByBorough(\"' + borough_name + '\")'
    zips = CallProcedure(keys, procedure, DQL=True)
    
    table = 'Demographics_Latin'
    statement = 'SELECT * FROM'
    
    df = query(keys, table, statement)
    zips = pd.merge(zips,df,on='GEOID10')
    
    table = 'Cases'
    statement = 'SELECT * FROM'
    
    df = query(keys, table, statement)
    zips = pd.merge(zips,df[['GEOID10','4-16-2020_Positive','4-16-2020_Total','4-16-2020_zcta_cum.perc_pos']],on='GEOID10')
    
    table = 'Hospitals'
    statement = 'SELECT * FROM'
    
    df = query(keys, table, statement)
    zips = pd.merge(zips,df[['GEOID10','TOTAL_BEDS','AVG_VENTILATOR_USE']],on='GEOID10')
    
    if hospitals:
        return render_template('leaf.html', tables=[zips.to_html(classes='table table-striped table-hover', index=False)],titles=[zips.columns.values], hospitals=hospitals)
    else:
        abort(404)

app.run(host='localhost', debug=True)