from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileAllowed
from wtforms import StringField, PasswordField, SubmitField, BooleanField, ValidationError, TextAreaField
from wtforms.validators import DataRequired, Length, Email, EqualTo
from webapp.models import User, Info
from flask_login import current_user

class RegisterationForm(FlaskForm):
	username = StringField('Username', validators = [DataRequired(), Length(min =2, max = 20)])
	email = StringField('Email', validators = [DataRequired(), Email()])
	password = PasswordField('Password', validators = [DataRequired()])
	confirm_password = PasswordField('Confirm Password', validators = [DataRequired(), EqualTo('password')])
	submit = SubmitField('Sign Up')

	def validate_username(self, username):
		user = User.query.filter_by(username = username.data).first()
		if user:
			raise ValidationError('That username is taken. Please choose a different one.')

	def validate_email(self, email):
		email = User.query.filter_by(email = email.data).first()
		if email:
			raise ValidationError('That email is taken. Please choose a different one.')



class LoginForm(FlaskForm):
	username = StringField('Username', validators = [DataRequired(), Length(min =2, max = 20)])
	password = PasswordField('Password', validators = [DataRequired()])
	remember_user = BooleanField('Remember Me')
	submit = SubmitField('Sign In')


#for parents
class UpdateInfoForm(FlaskForm):
	kids_name = StringField('Name of the Child', validators = [DataRequired()])
	kids_dob = StringField('Date of Birth', validators = [DataRequired()])
	guardian = StringField('Guardian Name', validators = [DataRequired()])
	weight = StringField('Weight of the Child', validators = [DataRequired()])
	height = StringField('Height of the Child', validators = [DataRequired()])
	address = StringField('Safe Areas', validators = [DataRequired()])
	picture = FileField('Upload a Picture', validators = [FileAllowed(['jpg', 'png', 'jpeg'])])
	submit = SubmitField('Update')


# for physicians
class AddNewRecordsForm(FlaskForm):
	medical_records = FileField('Upload Medical Records', validators = [FileAllowed(['pdf', 'doc', 'docx'])])
	physicians_name = StringField('Name of the Physician', validators = [DataRequired()])
	comments = TextAreaField('Comments', validators = [DataRequired()])
	submit = SubmitField('Add')


'''Commenting as we do not really need an update account form, code be reused for other purposes
class UpdateAccountForm(FlaskForm):
	username = StringField('Username', validators = [DataRequired(), Length(min =2, max = 20)])
	email = StringField('Email', validators = [DataRequired(), Email()])
	picture = FileField('Update Profile Picture', validators = [FileAllowed(['jpg', 'png', 'jpeg'])])
	submit = SubmitField('Update')

	def validate_username(self, username):
		if username.data != current_user.username:
			user = User.query.filter_by(username = username.data).first()
			if user:
				raise ValidationError('That username is taken. Please choose a different one.')

	def validate_email(self, email):
		if email.data != current_user.email:
			email = User.query.filter_by(email = email.data).first()
			if email:
				raise ValidationError('That email is taken. Please choose a different one.')
'''