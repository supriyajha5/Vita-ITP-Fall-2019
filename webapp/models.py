from webapp import db, login_manager
from datetime import datetime
from flask_login import UserMixin

#to find users by id
@login_manager.user_loader
def load_user(user_id):
	return User.query.get(int(user_id))

class User(db.Model, UserMixin):
	id = db.Column(db.Integer, primary_key = True)
	username = db.Column(db.String(20), unique = True, nullable = False)
	email = db.Column(db.String(120), unique = True, nullable = False)
	password = db.Column(db.String(60), nullable = False)
	image_file = db.Column(db.String(20), nullable = False, default = 'default.jpg')
	info = db.relationship('Info', backref = 'username', lazy = True)

	def __repr__(self):
		return f"User('{self.username}', '{self.email}' '{self.image_file}')"

# for parents
class Info(db.Model):
	id = db.Column(db.Integer, primary_key = True)
	kids_name = db.Column(db.String(20), nullable = False)
	kids_dob = db.Column(db.String(20), nullable = False)
	guardian = db.Column(db.String(20), nullable = False)
	kids_weight = db.Column(db.Integer, nullable = False)
	kids_height = db.Column(db.Integer, nullable = False)
	address = db.Column(db.Text, nullable = False)
	user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable = False)

	def __repr__(self):
		return f"Info('{self.kids_name}', '{self.kids_dob}', '{self.guardian}')"

# for physicians 
class Records(db.Model):
	id = db.Column(db.Integer, primary_key = True)
	medical_records = db.Column(db.String(20), nullable = False)
	physician_name = db.Column(db.String(20), nullable = False)
	comments = db.Column(db.Text, nullable = False)
	user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable = False)

	def __repr__(self):
		return f"Records('{self.physician_name}', '{self.medical_records}')"


# for physicians 
class AnxietyData(db.Model):
	id = db.Column(db.Integer, primary_key = True)
	time = db.Column(db.DateTime, nullable = False, default = datetime.now())
	heartbeat = db.Column(db.String(20), nullable = False)
	bp = db.Column(db.String(20), nullable = False)
	level = db.Column(db.String(20), nullable = False)
	location = db.Column(db.String(20), nullable = False)
	user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable = False)

	def __repr__(self):
		return f"Records('{self.id}', '{self.time}', '{self.heartbeat}', '{self.bp}', '{self.level}', '{self.location}')"
