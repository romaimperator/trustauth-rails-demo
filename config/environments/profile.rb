RailsDemo::Application.configure do
  config.cache_classes = true

  config.action_controller.perform_caching = true

  config.cache_template_loading = true

  config.active_support.deprecation = :stderr

end
