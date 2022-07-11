# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  namespace :api do
    resource :metrics, only: [:create]
    get 'metrics', to: 'metrics#index', param: :per, as: :metrics_avg
    get 'metrics/list', to: 'metrics#list', param: %i[timestamp per], as: :metrics_list
  end
end
