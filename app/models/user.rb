require 'digest/sha1'
# this model expects a certain database layout and its based on the name/login pattern. 
class User < ActiveRecord::Base

  def self.authenticate(login, pass)
    #    find_first(["login = ? AND password = ?", login, sha1(pass)])
    User.find_by_login_and_password(login,sha1(pass))
  end  

  def self.login_type(login,pass)
    #   find_first(["login = ? AND password= ?",login,sha1(pass)])
    User.find_by_login_and_password(login,sha1(pass))
  end

  def self.sha1(pass)
    Digest::SHA1.hexdigest("change-me--#{pass}--")
  end
  
  def change_password(pass)
    update_attribute "password", self.class.sha1(pass)
  end
 
  before_create :crypt_password
  
  def crypt_password
    write_attribute("password", self.class.sha1(password))
  end
  def password_check?(pass)
    self.password == self.class.sha1(pass)
  end

  validates_length_of :login, :within => 5..10, :on => :create
  validates_length_of :login, :within => 5..10, :on => :update
  validates_length_of :password, :within => 5..10, :on => :create
  validates_presence_of  :password,  :on => :update
  validates_presence_of :login, :password,  :on => :create
  validates_uniqueness_of :login, :on => :create
  validates_uniqueness_of :login, :on => :update
  validates_confirmation_of :password, :on => :create  
  validates_presence_of :usertype, :on => :create
  validates_presence_of :usertype, :on => :update
  validates_presence_of :firstname, :on => :update
  validates_presence_of :lastname, :on => :update
  validates_presence_of :firstname, :on => :create
  validates_presence_of :lastname, :on => :create
  validates_presence_of :login, :on => :create
  validates_presence_of :login, :on => :update
  validates_presence_of :password, :on => :create
 
end
