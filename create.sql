CREATE TABLE users (
    id CHAR(36) PRIMARY KEY,
    identifier TEXT NOT NULL,
    metadata JSON NOT NULL,
    createdAt TEXT,
    UNIQUE KEY (identifier(255))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS threads (
    id CHAR(36) PRIMARY KEY,
    createdAt TEXT,
    name TEXT,
    userId CHAR(36),
    userIdentifier TEXT,
    metadata JSON,
    FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Create a separate table for thread tags since MySQL doesn't support array types natively
CREATE TABLE IF NOT EXISTS thread_tags (
    threadId CHAR(36) NOT NULL,
    tag VARCHAR(255) NOT NULL,
    PRIMARY KEY (threadId, tag),
    FOREIGN KEY (threadId) REFERENCES threads(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS steps (
    id CHAR(36) PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    threadId CHAR(36) NOT NULL,
    parentId CHAR(36),
    streaming BOOLEAN NOT NULL,
    waitForAnswer BOOLEAN,
    isError BOOLEAN,
    metadata JSON,
    input TEXT,
    output TEXT,
    createdAt TEXT,
    command TEXT,
    start TEXT,
    end TEXT,
    generation JSON,
    showInput TEXT,
    language TEXT,
    indent INT,
    FOREIGN KEY (threadId) REFERENCES threads(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Create a separate table for step tags
CREATE TABLE IF NOT EXISTS step_tags (
    stepId CHAR(36) NOT NULL,
    tag VARCHAR(255) NOT NULL,
    PRIMARY KEY (stepId, tag),
    FOREIGN KEY (stepId) REFERENCES steps(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS elements (
    id CHAR(36) PRIMARY KEY,
    threadId CHAR(36),
    type TEXT,
    url TEXT,
    chainlitKey TEXT,
    name TEXT NOT NULL,
    display TEXT,
    objectKey TEXT,
    size TEXT,
    page INT,
    language TEXT,
    forId CHAR(36),
    mime TEXT,
    props JSON,
    FOREIGN KEY (threadId) REFERENCES threads(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS feedbacks (
    id CHAR(36) PRIMARY KEY,
    forId CHAR(36) NOT NULL,
    threadId CHAR(36) NOT NULL,
    value INT NOT NULL,
    comment TEXT,
    FOREIGN KEY (threadId) REFERENCES threads(id) ON DELETE CASCADE
) ENGINE=InnoDB;