from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, FloatField
from wtforms.validators import DataRequired, Length

class SchoolForm(FlaskForm):
    school = StringField('School Name', validators=[DataRequired(),Length(min = 4, max = 15)])
    code = StringField('3 Letter Key', validators=[DataRequired(),Length(min = 2, max = 4)])
    latitude = FloatField('Latitude', validators=[DataRequired()])
    longitude = FloatField('Longitude', validators=[DataRequired()])
    submit = SubmitField('Submit')