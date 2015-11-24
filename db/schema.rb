# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150701201118) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "permisos", force: :cascade do |t|
    t.string "codigo"
    t.string "nombre"
  end

  create_table "permisos_de_usuario", force: :cascade do |t|
    t.string   "name",                              null: false
    t.string   "authorizable_type"
    t.integer  "authorizable_id"
    t.boolean  "system",            default: false, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "permisos_de_usuario", ["authorizable_type", "authorizable_id"], name: "idx_aa_tt_aa_id_on_pp_dd_uu", using: :btree
  add_index "permisos_de_usuario", ["name"], name: "index_permisos_de_usuario_on_name", using: :btree

  create_table "permisos_de_usuario_usuarios", id: false, force: :cascade do |t|
    t.integer "usuario_id",            null: false
    t.integer "permiso_de_usuario_id", null: false
  end

  add_index "permisos_de_usuario_usuarios", ["permiso_de_usuario_id"], name: "index_permisos_de_usuario_usuarios_on_permiso_de_usuario_id", using: :btree
  add_index "permisos_de_usuario_usuarios", ["usuario_id"], name: "index_permisos_de_usuario_usuarios_on_usuario_id", using: :btree

  create_table "roles_asignables", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.boolean  "global",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "sexos", force: :cascade do |t|
    t.string "nombre"
    t.string "codigo"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string   "nombre",                 default: "",    null: false
    t.string   "apellido",               default: "",    null: false
    t.integer  "sexo_id"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "cuenta_eliminada",       default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "usuarios", ["confirmation_token"], name: "index_usuarios_on_confirmation_token", unique: true, using: :btree
  add_index "usuarios", ["email"], name: "index_usuarios_on_email", unique: true, using: :btree
  add_index "usuarios", ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true, using: :btree
  add_index "usuarios", ["unlock_token"], name: "index_usuarios_on_unlock_token", unique: true, using: :btree

  add_foreign_key "usuarios", "sexos"
end
