class CreateUsers < ActiveRecord::Migration
  ###############################################
  #                                             #
  #     Do NOT change the password schema.      #
  #                                             #
  ###############################################
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email, :null => false
      t.string :password_hash
      t.string :avatar_url
      t.timestamps null: false
    end

    add_index :users, :email, :unique => true

    create_table :auths do |t|
      t.references :user, :null => false
      t.string :unique_id, :null => false
      t.string :service, :null => false
      t.timestamps null: false
    end

    add_index :auths, :unique_id, :unique => true
  end
end
