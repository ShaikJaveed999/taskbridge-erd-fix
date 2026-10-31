# Three-Minute Video Explanation Script

This is a recording script only; no video has been recorded.

## 0:00-0:30 — Design considerations

“The original ERD image was not supplied, so I have not claimed to find specific errors in it. Instead, I designed the schema from the stated requirements and focused on avoiding common issues such as missing keys, duplicate user or project data, and invalid task relationships.”

## 0:30-1:00 — Corrected ERD

“Here is the corrected ERD. Users and projects each have a one-to-many relationship with tasks. The `M` side is on tasks: one user may be assigned many tasks, and one project may contain many tasks. Each individual task references exactly one user and one project.”

## 1:00-1:40 — Tables and relationships

“The schema has three tables: `users`, `projects`, and `tasks`. User details live in `users`; project details live in `projects`; and each task stores its own details plus `user_id` and `project_id`. Those foreign keys link the task to its user and project without copying their names or descriptions into every task.”

## 1:40-2:20 — Keys and constraints

“Each table has a generated identity primary key. The task foreign keys are required, so a task cannot exist without its user and project. User email is required and unique. Task status defaults to `pending`, and a check constraint limits it to `pending`, `in_progress`, or `completed`. Delete restrictions prevent deleting a user or project that still has tasks.”

## 2:20-3:00 — PostgreSQL demonstration

“To run the schema in an empty database, I use `psql -U username -d database_name -f schema.sql`. In `psql`, `\\dt` lists the tables, and `\\d users`, `\\d projects`, and `\\d tasks` show their definitions. If a PostgreSQL server is available, I can also insert valid rows and demonstrate that duplicate emails, invalid statuses, and missing foreign-key references are rejected.”
