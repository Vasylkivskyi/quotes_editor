Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :quotes do
    resources :line_item_dates, except: %i[index show] do
      resources :line_items, except: %i[index show]
    end
  end
end
