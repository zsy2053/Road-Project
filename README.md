# README

## Ruby and Rails Versions

This application requires Ruby version >= 2.4.3 and Rails version >= 5.1.4

## Environment Variables

### Database

* DB_ADAPTER
* DB_HOST
* DB_PORT
* DB_NAME
* DB_USER
* DB_PASS

### Secret Base
* SECRET_KEY_BASE

### Email Settings

_production_ assumes a GMail account is being used to send mail as follows:

* GMAIL_ADDRESS
* GMAIL_PORT
* GMAIL_DOMAIN
* GMAIL_USER_NAME
* GMAIL_PASSWORD
* GMAIL_AUTHENTICATION
* GMAIL_ENABLE_STARTTLS_AUTO

_development_ has been configured to use the {mailcatcher}[http://mailcatcher.me/] gem. See page on how to install and use to collect emails.

### Web Application URL

* WEB_APP_URL - for example <i>http://localhost:3000</i>, NOTE: no trailing slash 
* URL_PROTOCOL 
* URL_DOMAIN 
* URL_PORT 

---

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
