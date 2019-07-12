# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170206123849) do

  create_table "affiliates", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.string "company", null: false
    t.string "a_id", null: false
    t.text "a_tag", null: false
    t.boolean "delete_flg", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banks", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.integer "user_id"
    t.integer "year"
    t.string "name"
    t.integer "opt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "expire_flg"
  end

  create_table "calenders", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.string "opt"
    t.date "holliday"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dividends", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.date "pay_date"
    t.string "stock_code"
    t.string "stock_name"
    t.decimal "pay_rate_mny", precision: 9, scale: 2
    t.integer "pay_quantity"
    t.integer "pay_profit_mny"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "bank_id"
    t.string "stock_type"
  end

  create_table "message_reads", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.integer "message_id"
    t.integer "user_id"
    t.boolean "read_flg"
    t.boolean "delete_flg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.integer "user_id"
    t.date "send_date"
    t.string "subject"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_holds", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.integer "user_id"
    t.string "stock_code", limit: 15
    t.date "buy_date"
    t.bigint "buy_rate_mny"
    t.bigint "buy_quantity"
    t.date "sell_date"
    t.bigint "sell_rate_mny"
    t.bigint "sell_quantity"
    t.bigint "expenses_mny"
    t.bigint "profit_loss_mny"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stock_type"
    t.string "stock_name", limit: 50
    t.integer "bank_id"
  end

  create_table "stock_info_change_mails", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.string "stock_code"
    t.string "stock_name"
    t.integer "end_rate_mny"
    t.string "change_type"
    t.string "stock_message"
    t.date "target_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
  end

  create_table "stock_info_changes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.string "change_type"
    t.string "stock_code"
    t.string "stock_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "mail_send"
    t.date "target_date"
  end

  create_table "stock_infos", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.string "market_code"
    t.string "stock_code"
    t.string "stock_name"
    t.integer "end_rate_mny"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "start_rate_mny"
    t.integer "max_rate_mny"
    t.integer "min_rate_mny"
    t.bigint "buy_sell_quantity"
    t.bigint "trading_sum_mny"
  end

  create_table "stock_monitor_mails", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.string "monitor_type"
    t.string "stock_code"
    t.integer "monitor_mny"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "end_rate_mny"
    t.integer "min_rate_mny"
    t.integer "max_rate_mny"
    t.string "stock_name"
    t.string "email"
  end

  create_table "stock_monitors", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.string "stock_code"
    t.string "monitor_type"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "system_codes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.string "opt"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key"
    t.string "sort"
    t.index ["opt", "key"], name: "system_code_uniq_index", unique: true
  end

  create_table "system_infos", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.date "send_date"
    t.string "subject"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.string "title"
    t.string "link"
    t.string "category"
    t.datetime "pubDate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "username"
    t.boolean "mail_enabled", default: true, null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
