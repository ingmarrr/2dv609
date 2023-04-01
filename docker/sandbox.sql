CREATE DATABASE sandbox;

\c sandbox;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE,
  password VARCHAR(50),
  full_name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE emergency_scenarios (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  category VARCHAR(100),
  description TEXT,
  keywords TEXT[],
  instructions TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

