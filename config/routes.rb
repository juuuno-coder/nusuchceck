Rails.application.routes.draw do
  # === Devise (고객 전용 회원가입) ===
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  # === app.nusucheck.com → 고객 앱 진입점 ===
  # 루트만 지정, 나머지 라우트는 모든 도메인에서 공유
  constraints(SubdomainConstraint.new("app")) do
    root to: "customers/requests#index", as: :app_subdomain_root
  end

  # === 전문가 전용 라우트 ===
  # expert.nusucheck.com 서브도메인 또는 /expert 경로로 접근
  constraints(subdomain: "expert") do
    get "/", to: "expert/pages#index"
    devise_scope :user do
      get  "sign_up", to: "expert/registrations#new"
      post "sign_up", to: "expert/registrations#create"
    end
  end

  # /expert 경로 (서브도메인 없을 때도 접근 가능)
  scope "/expert", as: "expert" do
    get "/", to: "expert/pages#index", as: :root
    devise_scope :user do
      get  "sign_up", to: "expert/registrations#new",    as: :sign_up
      post "sign_up", to: "expert/registrations#create",  as: :registration
    end
  end

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
      collection do
        get :open_orders   # 공개 오더 목록
      end
      member do
        post :claim        # 선착순 선택
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
        post :publish        # 공개 오더 풀에 등록
        post :assign_master  # 관리자 직접 배정 (수동)
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

  # Health check (Fly.io)
  get "up", to: proc { [200, {}, ["OK"]] }

  # Static pages
  root "pages#home"
  get "about", to: "pages#about"
end
