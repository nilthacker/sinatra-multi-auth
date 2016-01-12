class CreateUsers < ActiveRecord::Migration
  ###############################################
  #                                             #
  #     Do NOT change the password schema.      #
  #                                             #
  ###############################################
  def change
    create_table :users do |t|
      t.string :fullname
      t.string :email, :null => false
      t.string :password_hash, :null => false
      t.timestamps null: false
    end
    add_index :users, :email, :unique => true
  end
  create_table :auths do |t|
    t.reference :user, :null => false
    t.string :unique_id, :null => false
    t.string :type, :null => false
    t.timestamps null: false
  end
  add_index :auths, :unique_id, :unique => true
end
end
