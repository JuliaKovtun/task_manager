json.extract! @project, :id, :title, :description
json.tasks @project.tasks, :id, :title, :status, :description
