Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :product_import_task, except: %i[edit update show] do
      post 'restart', action: :restart, on: :member
    end
  end
end
