-- Create the table if it doesn't already exist
CREATE TABLE IF NOT EXISTS examples (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Insert philosophers if they don't already exist
INSERT INTO examples (name)
SELECT 'Socrates' 
WHERE NOT EXISTS (SELECT 1 FROM examples WHERE name = 'Socrates')
UNION ALL
SELECT 'Plato'
WHERE NOT EXISTS (SELECT 1 FROM examples WHERE name = 'Plato')
UNION ALL
SELECT 'Aristotle'
WHERE NOT EXISTS (SELECT 1 FROM examples WHERE name = 'Aristotle')
UNION ALL
SELECT 'Immanuel Kant'
WHERE NOT EXISTS (SELECT 1 FROM examples WHERE name = 'Immanuel Kant')
UNION ALL
SELECT 'Friedrich Nietzsche'
WHERE NOT EXISTS (SELECT 1 FROM examples WHERE name = 'Friedrich Nietzsche')
UNION ALL
SELECT 'René Descartes'
WHERE NOT EXISTS (SELECT 1 FROM examples WHERE name = 'René Descartes')
UNION ALL
SELECT 'John Locke'
WHERE NOT EXISTS (SELECT 1 FROM examples WHERE name = 'John Locke')
UNION ALL
SELECT 'David Hume'
WHERE NOT EXISTS (SELECT 1 FROM examples WHERE name = 'David Hume')
UNION ALL
SELECT 'Thomas Hobbes'
WHERE NOT EXISTS (SELECT 1 FROM examples WHERE name = 'Thomas Hobbes')
UNION ALL
SELECT 'Jean-Paul Sartre'
WHERE NOT EXISTS (SELECT 1 FROM examples WHERE name = 'Jean-Paul Sartre')
UNION ALL
SELECT 'Albert Camus'
WHERE NOT EXISTS (SELECT 1 FROM examples WHERE name = 'Albert Camus');
