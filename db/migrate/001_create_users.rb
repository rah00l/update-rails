class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
        t.column :login,:string
        t.column :password,:string
        t.column :firstname,:string
        t.column :lastname,:string
        t.column :phoneno,:string
        t.column :usertype,:string
        t.column :emailid,:string
        t.column :userstatus,:int,:default=>0
        t.column :loginstatus,:char,:default=>'N'
    end
    
      User.create(:login => 'admin',
  :password => 'sprylogic',
 :firstname=>'surekha',
 :lastname=>'patil',
 :phoneno=>'257125127',
  :usertype=>'Admin',
  :emailid=>'surekha@sprylogic.com',
  :userstatus=>'1',
  :loginstatus=>'N'
  )
  end

  def self.down
    drop_table :users
  end
end
