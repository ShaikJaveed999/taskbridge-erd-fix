# TaskBridge: Corrected ERD and PostgreSQL Schema

## 1. Project Overview

TaskBridge is a task management system modeled with three normalized entities: users, projects, and tasks. This repository contains a corrected entity-relationship diagram (ERD) and an executable PostgreSQL schema for the assignment.

The original ERD image was not supplied. This design is based on the stated requirements; it does not claim to identify defects in an unseen diagram.

## 2. Original ERD Analysis

Because the original diagram was not provided, it cannot be inspected or compared with this design. The ERD here is a fresh design derived from the required entities and relationships.

## 3. Problems and Design Considerations

These are potential issues to avoid when designing this system, not claims about the missing original ERD:

- Omitting primary keys or using non-unique attributes to identify rows.
- Storing task assignees or project membership as repeated text instead of foreign keys.
- Allowing a task to have a missing user or project when both relationships are required.
- Allowing duplicate email addresses or unsupported task statuses.
- Duplicating user or project details in every task row, which can create inconsistent updates.
- Deleting a user or project while tasks still reference it.

## 4. Corrected ERD

The diagram shows each attribute, primary and foreign keys, and one-to-many cardinality. A user can have many assigned tasks, and a project can contain many tasks. Each task references exactly one user and exactly one project.

![Corrected TaskBridge ERD](https://chatgpt.com/c/corrected_erd.png)

The exported image is also included in this repository as `corrected_erd.png`.

## 5. Database Design Explanation

The database contains three tables because users, projects, and tasks are distinct entities with their own attributes and identities. Keeping each entity's details in one table avoids unnecessary duplication.

- **Users** stores a person's name, unique email, and creation timestamp.
- **Projects** stores a project name, optional description, and creation timestamp.
- **Tasks** stores the task's title, optional description, status, creation timestamp, and references to its assigned user and containing project.

Each `id` is a generated identity primary key. Primary keys uniquely identify records without relying on changeable values such as names or email addresses.

## 6. Entity Relationships

- **Users (1) to Tasks (many):** `tasks.user_id` references `users.id`. A task must have exactly one user; a user may be assigned any number of tasks, including none.
- **Projects (1) to Tasks (many):** `tasks.project_id` references `projects.id`. A task must belong to exactly one project; a project may contain any number of tasks, including none.

The foreign keys preserve referential integrity by requiring each task reference to match an existing user and project. Deleting a referenced user or project is restricted until its tasks have been reassigned or removed.

## 7. PostgreSQL Schema Explanation

[`schema.sql`](./schema.sql) creates the parent tables (`users`, `projects`) before `tasks`, so the referenced tables exist when its foreign keys are defined. IDs use `BIGINT GENERATED ALWAYS AS IDENTITY`. Optional descriptions use `TEXT`; timestamps use `TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP`.

## 8. Constraints and Indexing Strategy

- Primary keys identify every row.
- `users.email` is `NOT NULL` and `UNIQUE` so an email address cannot be shared by multiple user records.
- Required names, task titles, task status, and task relationship IDs are `NOT NULL`.
- The `tasks.status` check constraint permits only `pending`, `in_progress`, or `completed`.
- Both task foreign keys use `ON DELETE RESTRICT` and `ON UPDATE RESTRICT`. Parent rows cannot be changed in a way that leaves tasks orphaned.
- Indexes on `tasks.user_id` and `tasks.project_id` support lookups and joins by their foreign keys. PostgreSQL does not automatically create indexes on the referencing columns.

## 9. How to Run the Schema

Create or select an empty PostgreSQL database, then run:

```sh
psql -U username -d database_name -f schema.sql
```

The script creates the tables and indexes; it does not create a database or drop existing objects.

## 10. How to Verify the Tables

In the `psql` prompt, run:

```text
\dt
\d users
\d projects
\d tasks
```

These commands list the tables and show their columns, constraints, and indexes.

## 11. Assumptions and Limitations

- The original flawed ERD was not provided, so this design is based only on the stated requirements.
- A task must have one user and one project; both foreign-key columns are therefore `NOT NULL`.
- Users and projects may exist without tasks.
- Referenced users and projects are not automatically deleted; delete restrictions protect existing task relationships.
- Email uniqueness uses PostgreSQL's ordinary case-sensitive `UNIQUE` comparison. Case-insensitive email matching was not specified.
- The schema is designed for PostgreSQL and has not been executed against a live PostgreSQL server unless a separate test environment is available.
