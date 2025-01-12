/*
  # Initial Schema Setup for SaaS Starter Kit

  1. New Tables
    - services
      - id (uuid, primary key)
      - user_id (uuid, foreign key)
      - name (text)
      - auth_token (text)
      - status (text)
      - created_at (timestamp)
    
    - transactions
      - id (uuid, primary key)
      - service_id (uuid, foreign key)
      - amount (numeric)
      - status (text)
      - created_at (timestamp)
    
    - webhooks
      - id (uuid, primary key)
      - user_id (uuid, foreign key)
      - url (text)
      - events (text[])
      - is_active (boolean)
      - created_at (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
*/

-- Services Table
CREATE TABLE services (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  name text NOT NULL,
  auth_token text,
  status text DEFAULT 'inactive',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE services ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their own services"
  ON services
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id);

-- Transactions Table
CREATE TABLE transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  service_id uuid REFERENCES services NOT NULL,
  amount numeric NOT NULL,
  status text DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view transactions for their services"
  ON transactions
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM services
      WHERE services.id = transactions.service_id
      AND services.user_id = auth.uid()
    )
  );

-- Webhooks Table
CREATE TABLE webhooks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  url text NOT NULL,
  events text[] NOT NULL,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE webhooks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their own webhooks"
  ON webhooks
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id);