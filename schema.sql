-- TaskBridge relational schema.
-- Create a new, empty database before running this script.

CREATE TABLE users (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_email_unique UNIQUE (email)
);

COMMENT ON TABLE users IS 'People who can be assigned TaskBridge tasks.';
COMMENT ON COLUMN users.id IS 'Generated primary key for a user.';
COMMENT ON COLUMN users.email IS 'Unique email address for a user.';

CREATE TABLE projects (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT projects_pkey PRIMARY KEY (id)
);

COMMENT ON TABLE projects IS 'Projects that group related tasks.';
COMMENT ON COLUMN projects.id IS 'Generated primary key for a project.';

CREATE TABLE tasks (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    user_id BIGINT NOT NULL,
    project_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT tasks_pkey PRIMARY KEY (id),
    CONSTRAINT tasks_status_check
        CHECK (status IN ('pending', 'in_progress', 'completed')),
    CONSTRAINT tasks_user_id_fkey
        FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,
    CONSTRAINT tasks_project_id_fkey
        FOREIGN KEY (project_id)
        REFERENCES projects (id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
);

COMMENT ON TABLE tasks IS 'Tasks, each assigned to one user and one project.';
COMMENT ON COLUMN tasks.id IS 'Generated primary key for a task.';
COMMENT ON COLUMN tasks.status IS 'Task lifecycle state: pending, in_progress, or completed.';

-- PostgreSQL does not automatically index the referencing side of a foreign key.
CREATE INDEX tasks_user_id_idx ON tasks (user_id);
CREATE INDEX tasks_project_id_idx ON tasks (project_id);
