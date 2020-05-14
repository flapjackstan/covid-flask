from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, FloatField, RadioField
from wtforms.validators import DataRequired, Length

class PatientForm(FlaskForm):
    first_name = StringField('Patient First Name', validators=[DataRequired(),Length(min = 2, max = 25)])
    last_name = StringField('Patient Last Name', validators=[DataRequired(),Length(min = 2, max = 25)])
    id = StringField('ID', validators=[DataRequired(),Length(min = 2, max = 9)])
    latitude = FloatField('Latitude', validators=[DataRequired()])
    longitude = FloatField('Longitude', validators=[DataRequired()])
    symptoms = StringField('Symptoms', validators=[DataRequired(),Length(min = 0, max = 500)])
    submit = SubmitField('Submit')
    
class UpdateForm(FlaskForm):
    id = StringField('ID', validators=[DataRequired(),Length(min = 2, max = 9)])
    results = RadioField('Test Results', choices = [('FALSE','False'),('TRUE','True')], validators=[DataRequired()])
    submit = SubmitField('Submit')
