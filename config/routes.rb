Rails.application.routes.draw do

  root to: 'visitantes#index'

  resources :conjuntos_de_unidades_de_analisis
  resources :unidades_de_analisis, only: [:show, :edit, :update, :destroy]
  resources :covariables
  resources :categorias_de_la_covariable, only: [:show, :edit, :update, :destroy]
  resources :conjuntos_de_datos
  get "conjuntos_de_datos/:id/tabla_de_datos", to: "conjuntos_de_datos#tabla_de_datos", as: :tabla_de_datos_del_conjunto

  devise_for :usuarios, controllers: { sessions: "sesiones", registrations: "usuarios", passwords: "passwords" }
  devise_scope :usuario do
    get "usuarios", to: "usuarios#index", as: :usuarios
    get "usuarios/:id/edit", to: "usuarios#admin_edit", as: :edit_usuario
    put "usuarios/:id", to: "usuarios#admin_update", as: :update_usuario
    delete "usuarios/:id", to: "usuarios#admin_destroy", as: :destroy_usuario
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
