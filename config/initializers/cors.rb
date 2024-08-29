Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:3030', 'https://tamagokakegohan.com/'
    resource '*',
      headers: :any,
      expose: ["access-token", "expiry", "token-type", "uid", "client"],
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end