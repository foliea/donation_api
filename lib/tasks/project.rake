namespace :project do
  desc "Create a new project with a given name"
  task :create, [ :name ] => :environment do |t, args|
    name = args[:name]

    if name.blank?
      puts "Error: You must provide a project name."

      exit
    end
    project = Project.create(name: args[:name])

    if !project.persisted?
      puts "Error: Unable to create project."

      project.errors.full_messages.each { |message| puts message }

      exit
    end

    puts "Project created successfully!"
    puts "Id: #{project.id}\nName: #{project.name}"
  end
end
