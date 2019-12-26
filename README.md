# Vita-ITP-Fall-2019
This repository is created for the final project submission of ITP Fall 2019 at NYU Courant's department of Computer Science. 
This source code was used to develop an iWatch app named Vita along with a dashboard piece. 
Group Members are: Akanksha, Mohith, Shradha and Supriya, students at NYU Courant and 
aids a research effort at NYU Meyers school of nursing.

----- READ ME ------

Installations:
Install the below Python libraries using the cmd command 'pip install'
bcrypt==3.1.4
Flask==1.0
Flask-Bcrypt==0.7.1
Flask-Login==0.4.1
Flask-Mail==0.9.1
Flask-SQLAlchemy==2.3.2
Flask-WTF==0.14.2
Jinja2==2.10
Pillow==5.3.0
SQLAlchemy==1.2.7

Starting the server:
Once installed, start the server (from inside the webapp directory) using the cmd command 'python run.py'

Database: 
To access the database file 'site.db', run the following commands (from inside the webapp directory)
> python
> from webapp import db
> from webapp.models import User, Info, Records, AnxietyData

