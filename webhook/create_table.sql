CREATE TABLE cred_verifiers (
  id SERIAL PRIMARY KEY,
  cred_id VARCHAR(255) NOT NULL,
  chain VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  endpoint VARCHAR(255) NOT NULL,
  timestamp BIGINT NOT NULL
);