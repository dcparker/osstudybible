class Main < Application

  namespace '/'

  get :home do
    template :index
  end

  # This is not yet limited to just one controller or namespace.
  error do
    Cilantro.report_error(env['sinatra.error'])
    template :error_page
  end
end
