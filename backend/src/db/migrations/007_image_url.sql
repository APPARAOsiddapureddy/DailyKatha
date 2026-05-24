-- Add image_url column to cards table for Astra Studio image integration
ALTER TABLE cards ADD COLUMN IF NOT EXISTS image_url TEXT;
