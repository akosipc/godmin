require "godmin/helpers/application"
require "godmin/helpers/forms"
require "godmin/helpers/navigation"
require "godmin/helpers/translations"

module Godmin
  module ApplicationController
    extend ActiveSupport::Concern

    included do
      include Godmin::Helpers::Translations

      helper Godmin::Helpers::Application
      helper Godmin::Helpers::Forms
      helper Godmin::Helpers::Navigation
      helper Godmin::Helpers::Translations

      helper_method :authentication_enabled?
      helper_method :authorization_enabled?
      helper_method :engine_namespace
      helper_method :engine_wrapper

      before_action :append_view_paths

      layout "godmin/application"
    end

    def welcome; end

    private

    def engine_namespace
      engine_wrapper.namespace
    end

    def engine_wrapper
      EngineWrapper.new(self)
    end

    def append_view_paths
      append_view_path Godmin::ResourceResolver.new(controller_path, engine_wrapper)
      append_view_path Godmin::GodminResolver.new(controller_path, engine_wrapper)
    end

    def authentication_enabled?
      singleton_class.include?(Godmin::Authentication)
    end

    def authorization_enabled?
      singleton_class.include?(Godmin::Authorization)
    end
  end
end
