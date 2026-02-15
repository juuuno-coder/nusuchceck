Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  # Customer namespace
  namespace :customers do
    resources :requests, only: [:index, :show, :new, :create] do
      member do
        post :cancel
        post :accept_estimate
        post :deposit_escrow
        post :confirm_completion
      end
      resources :reviews, only: [:new, :create]
      resources :insurance_claims, only: [:new, :create], controller: "insurance_claims"
    end
    resources :estimates, only: [:show]

    resources :insurance_claims, only: [:index, :show, :new, :create, :edit, :update] do
      member do
        post :submit_claim
        post :customer_approve
        post :customer_request_changes
        get  :download_pdf
      end
    end
  end

  # Master namespace
  namespace :masters do
    resources :requests, only: [:index, :show] do
      member do
        post :visit
        post :arrive
        post :detection_complete
        post :detection_fail
        post :submit_estimate
        post :start_construction
        post :complete_construction
      end
      resources :estimates, only: [:new, :create, :edit, :update]
      resources :insurance_claims, only: [:new, :create], controller: "insurance_claims"
    end
    resource :profile, only: [:show, :edit, :update], controller: "profiles"

    resources :insurance_claims, only: [:index, :show, :edit, :update] do
      member do
        post :send_to_customer
        get  :download_pdf
      end
    end
  end

  # Admin namespace
  namespace :admin do
    root to: "dashboard#index"
    resources :dashboard, only: [:index]
    resources :requests, only: [:index, :show] do
      member do
        post :assign_master
        post :close_no_charge
        post :finalize
      end
    end
    resources :masters, only: [:index, :show] do
      member do
        post :verify
        post :reject
      end
    end
    resources :escrow_transactions, only: [:index, :show] do
      member do
        post :release_payment
        post :refund
      end
    end

    resources :insurance_claims, only: [:index, :show] do
      member do
        post :start_review
        post :approve
        post :reject
        post :complete
      end
    end
  end

  # PDF downloads
  resources :requests, only: [] do
    member do
      get :insurance_report_pdf
      get :estimate_pdf
      get :completion_report_pdf
    end
  end

  # API for standard estimate items
  namespace :api do
    resources :standard_estimate_items, only: [:index]
  end

  # Notifications
  resources :notifications, only: [:index] do
    member do
      post :mark_as_read
    end
    collection do
      post :mark_all_as_read
    end
  end

  # AI 누수 빠른 점검 (비로그인 허용)
  resources :leak_inspections, only: [:new, :create, :show]

  # Static pages
  root "pages#home"
  get "about", to: "pages#about"
end
