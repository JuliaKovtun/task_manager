# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Creates a user
User.create!(email: 'user@gmail.com', password: '123456', password_confirmation: '123456')

# Creates an array of project parameters
projects_params = (1..10).map do |number|
  { title: "Project #{number}", description: "The description of project #{number}" }
end

# Creates projects with the parameters
Project.create!(projects_params)

# Creates tasks for the first 5 projects
Project.first(5).each do |project|
  tasks = [
    { title: "New task for project #{project.title}", description: 'Task description', status: :new },
    { title: "In progress task for project #{project.title}", description: 'Task description', status: :in_progress },
    { title: "Done task for project #{project.title}", description: 'Task description', status: :done }
  ]
  project.tasks.create!(tasks)
end
