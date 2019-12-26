import os
import secrets
from PIL import Image
import requests
from webapp.key import key
from flask import render_template, url_for, flash, redirect, request, jsonify
from webapp.form import RegisterationForm, LoginForm, UpdateInfoForm, AddNewRecordsForm
from webapp.models import User, Info, Records, AnxietyData
from webapp import app, db, bcrypt
from flask_login import login_user, current_user, logout_user, login_required


search_url = "https://maps.googleapis.com/maps/api/place/textsearch/json"
details_url = "https://maps.googleapis.com/maps/api/place/details/json"


@app.route("/")
@app.route("/info")
@login_required
def info():
	info = Info.query.filter_by(user_id = current_user.id).first()
	if current_user.is_authenticated:
		image_file = url_for('static', filename = 'profile_pics/' + current_user.image_file)
	else:
		image_file = url_for('static', filename = 'profile_pics/' + 'default.jpg')
	return render_template('info.html', info = info, title = 'Basic Info', image_file = image_file)


@app.route("/charts")
@login_required
def charts():
	info = Info.query.filter_by(user_id = current_user.id).first()
	data = AnxietyData.query.filter_by(user_id = current_user.id)
	return render_template('anxiety_data.html', data = data, info=info)


@app.route("/records")
@login_required
def records():
	return render_template('physician_input.html', records = records)


@app.route("/register", methods= ['GET', 'POST'])
def register():
	if current_user.is_authenticated:
		return redirect(url_for('basic_info'))
	form = RegisterationForm()
	if form.validate_on_submit():
		hashed_password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
		user = User(username=form.username.data, email = form.email.data, password = hashed_password)
		db.session.add(user)
		db.session.commit()
		flash("Your account has been created. You can now login", 'success')
		return redirect(url_for('login'))
	return render_template('register.html', title = 'Register', form = form)


@app.route("/login", methods= ['GET', 'POST'])
def login():
	if current_user.is_authenticated:
		return redirect(url_for('info'))
	form = LoginForm()
	if form.validate_on_submit():
		user = User.query.filter_by(username=form.username.data).first()
		if user and bcrypt.check_password_hash(user.password, form.password.data):
				login_user(user, remember=form.remember_user.data) 
				next_page = request.args.get('next')
				return redirect(next_page) if next_page else redirect(url_for('info'))
		else:		
			flash('Login unsuccessful. Check username or password', 'danger')
	return render_template('login.html', title = 'Login', form = form)

@app.route("/logout")
def logout():
	logout_user()
	return redirect(url_for('info'))

def save_picture(form_picture):
	random_hex = secrets.token_hex(8)
	_, f_ext = os.path.splitext(form_picture.filename)
	picture_fn = random_hex + f_ext
	picture_path = os.path.join(app.root_path, 'static/profile_pics', picture_fn)
	
	output_size = (125, 125)
	i = Image.open(form_picture)
	i.thumbnail(output_size)
	i.save(picture_path)

	return picture_fn

# for parents
@app.route("/info/update", methods= ['GET', 'POST'])
@login_required
def update_info():
	form = UpdateInfoForm()
	if form.validate_on_submit():
		if form.picture.data:
			picture_file = save_picture(form.picture.data)
			current_user.image_file = picture_file
			db.session.commit()
		
		info = Info(kids_name=form.kids_name.data, kids_dob=form.kids_dob.data, guardian=form.guardian.data, kids_weight=form.weight.data, kids_height= form.height.data, address = form.address.data, user_id = current_user.id)
		
		db.session.add(info)
		db.session.commit()
		flash("Information has been updated!", "success")
		return redirect(url_for('info'))
	return render_template('update_info.html', title = 'Update Info', form = form)

# for physicians
@app.route("/records/add", methods= ['GET', 'POST'])
@login_required
def add_records():
	form = AddNewRecordsForm()
	if form.validate_on_submit():
		flash("New record has been added!", "success")
		return redirect(url_for('info'))
	return render_template('add_records.html', title = 'New Records', form = form)


@app.route("/geolocation", methods=["GET"])
@login_required
def geolocation():
	return render_template('geolocation.html', title = 'Location')


@app.route("/sendRequest/<string:query>")
def results(query):
	search_payload = {"key":key, "query":query}
	search_req = requests.get(search_url, params=search_payload)
	search_json = search_req.json()

	place_id = search_json["results"][0]["place_id"]

	details_payload = {"key":key, "placeid":place_id}
	details_resp = requests.get(details_url, params=details_payload)
	details_json = details_resp.json()

	url = details_json["result"]["url"]
	return jsonify({'result' : url})

'''
Commenting as we do not really need an update account info page, code be reused for other purposes
@app.route("/account", methods= ['GET', 'POST'])
@login_required
def account():
	form =  UpdateAccountForm()
	if form.validate_on_submit():
		if form.picture.data:
			print("Hey" , form.picture.data)
			picture_file = save_picture(form.picture.data)
			current_user.image_file = picture_file
		current_user.username = form.username.data
		current_user.email = form.email.data
		db.session.commit()
		flash("Your account information has been updated!", "success")
		return redirect(url_for('account'))
	elif request.method == 'GET':
		form.username.data = current_user.username
		form.email.data = current_user.email
	image_file = url_for('static', filename = 'profile_pics/' + current_user.image_file)
	return render_template('account.html', title = 'Account', image_file = image_file, form = form)
'''