-- Insertar usuarios
DELETE FROM User;

INSERT INTO User (user_id, name, last_name, nickname, mail, password, photo_url) VALUES
(1, 'Sebastian', 'Camayo', 'sebas', 'sebas@email.com', 'pass123', 'https://www.siliconera.com/wp-content/uploads/2023/07/screen-shot-2023-07-02-at-101027-am.png'),
(2, 'Rodrigo', 'de los Rios', 'rodrigo', 'rodrigo@email.com', 'pass123', 'https://i.pinimg.com/736x/8e/37/74/8e377443a55964052d087e2bc0acab01.jpg'),
(3, 'Carlos', 'López', 'carlitos', 'carlos@email.com', 'mysecret789', 'https://cdn-images.dzcdn.net/images/cover/d03bc475b34f292b6a43e919dacfb8da/1900x1900-000000-80-0-0.jpg'),
(4, 'Tyler', 'Joseph', 'Clancy', 'clancy@email.com', 'bandito', 'https://www.shutterstock.com/image-vector/annunciation-blessed-virgin-mary-conception-260nw-2566163865.jpg'),
(5, 'Sofía', 'Ramírez', 'sofy', 'sofia@email.com', 'abc123', 'https://randomuser.me/api/portraits/women/65.jpg');

-- Insertar géneros musicales
DELETE FROM Genre;

INSERT INTO Genre (id, name) VALUES
(1, 'Pop'),
(2, 'Rock'),
(3, 'Reggaetón'),
(4, 'Salsa'),
(5, 'Jazz'),
(6, 'Hip-Hop'),
(7, 'Electronic'),
(8, 'Classic'),
(9, 'Cumbia'),
(10, 'Metal');