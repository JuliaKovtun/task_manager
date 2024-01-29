# README

Ruby on Rails-based project management system, designed to allow users to manage and track projects and tasks through a simple and intuitive RESTful API interface. It focuses on providing essential functionalities for project and task management, including creation, editing, and viewing, along with secure user authentication.

## Project set up

To get started with Task Manager, clone the repository, install the required gems:

```bash
git clone https://github.com/JuliaKovtun/task_manager.git
cd task_manager
bundle install
rails db:migrate
rails db:seed
```

To run the project use <code>--dev-caching</code> for enabling caching in development environment:
```bash
rails s --dev-caching
```
## API
### Authentication

By default seeds create user with email <code>user@gmail.com</code> and password <code>123456</code>. You will need these credencials for authentication.

```bash
curl --location --request POST 'http://localhost:3000/users/sign_in' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw '{
  "user": {
    "email": "user@gmail.com",
    "password": "123456"
  }
}'
```
On success, you will receive auth_token, which you will need to use in headers for the next requests. Example of successful result:
```bash
{
    "success": true,
    "auth_token": "byQt8nESTsfWVd22nEBH",
    "email": "user@gmail.com"
}
```

### GET /projects/:id
Returns one project.
```bash
curl --location --request GET 'http://localhost:3000/projects/:id' \
--header 'Accept: application/json' \
--header 'X-User-Email: user@gmail.com' \
--header 'X-User-Token: generated_token'
```

### GET /projects
Returns all projects.
```bash
curl --location --request GET 'http://localhost:3000/projects/' \
--header 'X-User-Email: user@gmail.com' \
--header 'X-User-Token: generated_token' \
--header 'Accept: application/json'
```

### POST /projects
Creates a project.
```bash
curl --location --request POST 'http://localhost:3000/projects/' \
--header 'X-User-Email: user@gmail.com' \
--header 'X-User-Token: generated_token' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data '{
  "project": {
    "title": "Project title",
    "description": "Project description"
  }
}'
```

### PUT /projects
Updates a project.
```bash
curl --location --request PUT 'http://localhost:3000/projects/:id' \
--header 'Accept: application/json' \
--header 'X-User-Email: user@gmail.com' \
--header 'X-User-Token: generated_token' \
--header 'Content-Type: application/json' \
--data '{
  "project": {
    "title": "Project title",
    "description": "Project description"
  }
}'
```

### DELETE /projects/:id
Deletes project.
```bash
curl --location --request DELETE 'http://localhost:3000/projects/:id' \
--header 'Accept: application/json' \
--header 'X-User-Email: user@gmail.com' \
--header 'X-User-Token: generated_token'
```

### GET /projects/:project_id/tasks/:id
Returns one task.
```bash
curl --location --request GET 'http://localhost:3000/projects/:project_id/tasks/:id' \
--header 'Accept: application/json' \
--header 'X-User-Email: user@gmail.com' \
--header 'X-User-Token: generated_token'
```
### GET /projects/:project_id/tasks 
Returns all tasks in project. You can filter tasks by status using url params:
```
?status=new
?status=in_progress
?status=done
```
Example request with filter:
```bash
curl --location --request GET 'http://localhost:3000/projects/:project_id/tasks?status=in_progress' \
--header 'Accept: application/json' \
--header 'X-User-Email: user@gmail.com' \
--header 'X-User-Token: generated_token'
```
Example request without filter:
```bash
curl --location --request GET 'http://localhost:3000/projects/:project_id/tasks' \
--header 'Accept: application/json' \
--header 'X-User-Email: user@gmail.com' \
--header 'X-User-Token: generated_token'
```

### POST /projects/:project_id/tasks
Creates a task.
Possible params for task status are: `new`, `in_progress`, `done`.
```bash
curl --location --request POST 'http://localhost:3000/projects/:project_id/tasks' \
--header 'Accept: application/json' \
--header 'X-User-Email: user@gmail.com' \
--header 'X-User-Token: generated_token' \
--header 'Content-Type: application/json' \
--data '{
  "task": {
    "title": "Task title",
    "description": "Task description",
    "status": "in_progress"
  }
}'
```

### PUT  /projects/:project_id/tasks/:id
Updates the task.
```bash
curl --location --request PUT 'http://localhost:3000/projects/:project_id/tasks/:id' \
--header 'Accept: application/json' \
--header 'X-User-Token: generated_token' \
--header 'X-User-Email: user@gmail.com' \
--header 'Content-Type: application/json' \
--data '{
  "task": {
    "title": "Updated task title",
    "description": "Updated task description",
    "status": "new"
  }
}'
```

### DELETE /projects/:project_id/tasks/:id
Deletes the task.
```bash
curl --location --request DELETE 'http://localhost:3000/projects/26/tasks/32' \
--header 'Accept: application/json' \
--header 'X-User-Token: generated_token' \
--header 'X-User-Email: user@gmail.com'
```

## How to run the test suite

```bash
bundle exec rspec
```




