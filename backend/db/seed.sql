-- 1. Insertando Usuarios
DELETE FROM User;
DELETE FROM sqlite_sequence WHERE name='User';
INSERT INTO User (name, last_name, nickname, mail, password, photo_url) VALUES
('Sebastian', 'Camayo', 'sebas', 'sebas@email.com', 'pass123', 'https://www.siliconera.com/wp-content/uploads/2023/07/screen-shot-2023-07-02-at-101027-am.png'),
('Rodrigo', 'de los Rios', 'rodrigo', 'rodrigo@email.com', 'pass123', 'https://i.pinimg.com/736x/8e/37/74/8e377443a55964052d087e2bc0acab01.jpg'),
('Carlos', 'López', 'carlitos', 'carlos@email.com', 'mysecret789', 'https://cdn-images.dzcdn.net/images/cover/d03bc475b34f292b6a43e919dacfb8da/1900x1900-000000-80-0-0.jpg'),
('Tyler', 'Joseph', 'clancy', 'clancy@email.com', 'bandito', 'https://www.shutterstock.com/image-vector/annunciation-blessed-virgin-mary-conception-260nw-2566163865.jpg'),
('Sofía', 'Ramírez', 'sofy', 'sofia@email.com', 'abc123', 'https://randomuser.me/api/portraits/women/65.jpg');

-- 2. Insertando géneros musicales
DELETE FROM Genre;
DELETE FROM sqlite_sequence WHERE name='Genre';
INSERT INTO Genre (name) VALUES
('Pop'),
('Rock'),
('Reggaetón'),
('Salsa'),
('Jazz'),
('Hip-Hop'),
('Electronic'),
('Classic'),
('Cumbia'),
('Metal');