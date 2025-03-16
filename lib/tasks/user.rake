namespace :user do
  desc "Creates a user"
  task create: :environment do
    user = User.create!(api_token: SecureRandom.hex(20))

    puts "User created successfully!"
    puts "Id: #{user.id}\nAPI Token: #{user.api_token}"
  end
end
