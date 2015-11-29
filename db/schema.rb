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

ActiveRecord::Schema.define(version: 20151128210338) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categorias_de_la_covariable", force: :cascade do |t|
    t.string   "nombre",        null: false
    t.text     "descripcion"
    t.integer  "covariable_id", null: false
    t.integer  "created_user",  null: false
    t.integer  "updated_user",  null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "categorias_de_la_covariable", ["covariable_id", "nombre"], name: "index_unique_cdlc_on_covariable_id_and_nombre", unique: true, using: :btree
  add_index "categorias_de_la_covariable", ["covariable_id"], name: "index_categorias_de_la_covariable_on_covariable_id", using: :btree
  add_index "categorias_de_la_covariable", ["covariable_id"], name: "index_cdlc_on_covariable_id", using: :btree

  create_table "conjuntos_de_datos", force: :cascade do |t|
    t.string   "nombre",                              null: false
    t.text     "descripcion"
    t.integer  "conjunto_de_unidades_de_analisis_id", null: false
    t.integer  "covariable_id"
    t.integer  "created_user",                        null: false
    t.integer  "updated_user",                        null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "conjuntos_de_datos", ["conjunto_de_unidades_de_analisis_id"], name: "index_cdd_on_conjunto_de_unidades_de_analisis_id", using: :btree
  add_index "conjuntos_de_datos", ["covariable_id"], name: "index_conjuntos_de_datos_on_covariable_id", using: :btree

  create_table "conjuntos_de_unidades_de_analisis", force: :cascade do |t|
    t.string   "nombre",                          null: false
    t.text     "descripcion"
    t.integer  "tipo_de_unidades_de_analisis_id"
    t.integer  "created_user",                    null: false
    t.integer  "updated_user",                    null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "conjuntos_de_unidades_de_analisis", ["tipo_de_unidades_de_analisis_id"], name: "index_cua_on_tipo_de_unidades_de_analisis_id", using: :btree

  create_table "covariables", force: :cascade do |t|
    t.string   "nombre",       null: false
    t.text     "descripcion"
    t.integer  "created_user", null: false
    t.integer  "updated_user", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "datos", force: :cascade do |t|
    t.integer  "conjunto_de_datos_id",                        null: false
    t.integer  "unidad_de_analisis_id",                       null: false
    t.integer  "categoria_de_la_covariable_id"
    t.decimal  "valor",                         precision: 6, null: false
    t.integer  "created_user",                                null: false
    t.integer  "updated_user",                                null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "datos", ["categoria_de_la_covariable_id"], name: "index_datos_on_categoria_de_la_covariable_id", using: :btree
  add_index "datos", ["conjunto_de_datos_id", "unidad_de_analisis_id", "categoria_de_la_covariable_id"], name: "index_datos_unique_on_terna_de_unicidad", unique: true, using: :btree
  add_index "datos", ["conjunto_de_datos_id"], name: "index_datos_on_conjunto_de_datos_id", using: :btree
  add_index "datos", ["unidad_de_analisis_id"], name: "index_datos_on_unidad_de_analisis_id", using: :btree

  create_table "permisos", force: :cascade do |t|
    t.string "codigo"
    t.string "nombre"
  end

  create_table "permisos_de_usuario", force: :cascade do |t|
    t.string   "name",                              null: false
    t.string   "authorizable_type",                 null: false
    t.integer  "authorizable_id"
    t.boolean  "system",            default: false, null: false
    t.integer  "created_user",                      null: false
    t.integer  "updated_user",                      null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "permisos_de_usuario", ["authorizable_type", "authorizable_id"], name: "index_pdu_on_authorizable", using: :btree
  add_index "permisos_de_usuario", ["name"], name: "index_permisos_de_usuario_on_name", using: :btree

  create_table "permisos_otorgados", force: :cascade do |t|
    t.integer  "usuario_id"
    t.integer  "permiso_de_usuario_id"
    t.integer  "created_user",          null: false
    t.integer  "updated_user",          null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "permisos_otorgados", ["permiso_de_usuario_id"], name: "index_permisos_otorgados_on_permiso_de_usuario_id", using: :btree
  add_index "permisos_otorgados", ["usuario_id"], name: "index_permisos_otorgados_on_usuario_id", using: :btree

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

  create_table "tipos_de_evaluacion", force: :cascade do |t|
    t.string  "nombre"
    t.text    "descripcion"
    t.boolean "implementado", default: false
  end

  create_table "tipos_de_unidades_de_analisis", force: :cascade do |t|
    t.string "nombre"
    t.text   "descripcion"
  end

  create_table "unidades_de_analisis", force: :cascade do |t|
    t.string   "nombre",                              null: false
    t.text     "descripcion"
    t.integer  "conjunto_de_unidades_de_analisis_id"
    t.integer  "created_user",                        null: false
    t.integer  "updated_user",                        null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "unidades_de_analisis", ["conjunto_de_unidades_de_analisis_id", "nombre"], name: "index_unique_uda_on_cduda_id_and_nombre", unique: true, using: :btree
  add_index "unidades_de_analisis", ["conjunto_de_unidades_de_analisis_id"], name: "index_uda_on_conjunto_de_unidades_de_analisis_id", using: :btree

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

  add_foreign_key "categorias_de_la_covariable", "covariables"
  add_foreign_key "categorias_de_la_covariable", "usuarios", column: "created_user"
  add_foreign_key "categorias_de_la_covariable", "usuarios", column: "updated_user"
  add_foreign_key "conjuntos_de_datos", "conjuntos_de_unidades_de_analisis"
  add_foreign_key "conjuntos_de_datos", "covariables"
  add_foreign_key "conjuntos_de_datos", "usuarios", column: "created_user"
  add_foreign_key "conjuntos_de_datos", "usuarios", column: "updated_user"
  add_foreign_key "conjuntos_de_unidades_de_analisis", "tipos_de_unidades_de_analisis"
  add_foreign_key "conjuntos_de_unidades_de_analisis", "usuarios", column: "created_user"
  add_foreign_key "conjuntos_de_unidades_de_analisis", "usuarios", column: "updated_user"
  add_foreign_key "covariables", "usuarios", column: "created_user"
  add_foreign_key "covariables", "usuarios", column: "updated_user"
  add_foreign_key "datos", "categorias_de_la_covariable"
  add_foreign_key "datos", "conjuntos_de_datos"
  add_foreign_key "datos", "unidades_de_analisis"
  add_foreign_key "datos", "usuarios", column: "created_user"
  add_foreign_key "datos", "usuarios", column: "updated_user"
  add_foreign_key "permisos_de_usuario", "usuarios", column: "created_user"
  add_foreign_key "permisos_de_usuario", "usuarios", column: "updated_user"
  add_foreign_key "permisos_otorgados", "permisos_de_usuario"
  add_foreign_key "permisos_otorgados", "usuarios"
  add_foreign_key "permisos_otorgados", "usuarios", column: "created_user"
  add_foreign_key "permisos_otorgados", "usuarios", column: "updated_user"
  add_foreign_key "unidades_de_analisis", "conjuntos_de_unidades_de_analisis"
  add_foreign_key "unidades_de_analisis", "usuarios", column: "created_user"
  add_foreign_key "unidades_de_analisis", "usuarios", column: "updated_user"
  add_foreign_key "usuarios", "sexos"
end
