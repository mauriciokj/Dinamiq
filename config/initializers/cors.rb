Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "localhost:5174", "localhost:5173", "127.0.0.1:5173",
    "localhost:3009", "127.0.0.1:3009",
    "http://72.167.132.22:3009", "populiz.com", "www.populiz.com",
    "https://populiz.com", "https://www.populiz.com"

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      credentials: true
  end
end
