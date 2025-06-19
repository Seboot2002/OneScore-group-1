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
('Metal'),
('Alternative'),
('Jazz'),
('Hip-Hop'),
('Electronic'),
('Classic'),
('Rap');

-- 3. Insertando Artistas
DELETE FROM Artist;
DELETE FROM sqlite_sequence WHERE name='Artist';
INSERT INTO Artist (name, genre_id, picture_url, debut_year) VALUES
('Michael Jackson', 1, 'https://dovemibutto.wordpress.com/wp-content/uploads/2013/06/bad-michael-jacksons-short-films-11016298-1124-1054.jpg', 1964),
('Pink Floyd', 2, 'https://upload.wikimedia.org/wikipedia/en/d/d6/Pink_Floyd_-_all_members.jpg', 1965),
('AC/DC', 3, 'https://paulkingart.com/wp-content/uploads/2024/01/AC-DC-1979_PWKing.jpg', 1973),
('Twenty one Pilots', 4, 'https://akamai.sscdn.co/uploadfile/letras/fotos/5/7/3/5/5735ee859fa91274b1ea2ab0e4a40f06.jpg', 2009),
('Imagine Dragons', 2, 'https://www.coca-cola.com/content/dam/onexp/global/central/offerings/coke-studio/artists/2_Imagine_Dragons_by_Eric_Ray_Davidson_GREEN_04_1-1.jpg', 2008),
('Dream Theater', 3, 'https://cdn-images.dzcdn.net/images/artist/2224b2118fd879e7c18fe3c3eab882bf/1900x1900-000000-80-0-0.jpg', 1985),
('Arctic Monkeys', 4, 'https://rocknvivo.com/wp-content/uploads/2012/02/arctic-monkeys.jpg', 2002);

-- 4. Insertando Albums
DELETE FROM Album;
DELETE FROM sqlite_sequence WHERE name='Album';
INSERT INTO Album (title, release_year, genre_id, cover_url, artist_id) VALUES
-- Michael Jackson
('Thriller', 1982, 1, 'https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/32/4f/fd/324ffda2-9e51-8f6a-0c2d-c6fd2b41ac55/074643811224.jpg/600x600bf-60.jpg', 1),
-- Pink Floyd
('The Dark Side of the Moon', 1973, 2, 'https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/3c/1b/a9/3c1ba9e1-15b1-03b3-3bfd-09dbd9f1705b/dj.mggvbaou.jpg/600x600bf-60.jpg', 2),
-- AC/DC
('Back in Black', 1980, 3, 'https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/1e/14/58/1e145814-281a-58e0-3ab1-145f5d1af421/886443673441.jpg/600x600bf-60.jpg', 3),
-- Twenty one Pilots
('Clancy', 2024, 4, 'https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/8b/39/c6/8b39c655-00fd-1b52-52ea-a98de686f3ae/075679659729.jpg/600x600bf-60.jpg', 4),
('Scaled and Icy', 2021, 1, 'https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/24/f2/15/24f215e3-52cc-078b-d799-d58d606feddd/075679786210.jpg/600x600bf-60.jpg', 4),
('Trench', 2018, 2, 'https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/a3/c0/2b/a3c02b76-baa1-e575-dcba-247509200424/075679864789.jpg/600x600bf-60.jpg', 4),
('Blurryface', 2015, 4, 'https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/8e/e2/89/8ee28904-0821-610d-5011-a61845f62756/075679926951.jpg/600x600bf-60.jpg', 4),
('Vessel', 2013, 4, 'https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/73/a7/23/73a7230c-19df-02a4-ff4e-53944024f63d/075679957924.jpg/600x600bf-60.jpg', 4),
('Twenty One Pilots', 2009, 2, 'https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/ca/7a/d0/ca7ad083-e97a-de0c-a8f2-5e144662dc87/884501253109_cover.jpg/486x486bb.png', 4),
-- Imagine Dragons
('Smoke & Mirrors', 2014, 2, 'https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/c1/16/59/c116596f-f3fd-3499-6cc2-bcb5b4931e6e/14UMGIM61459.rgb.jpg/600x600bf-60.jpg', 5),
-- Dream Theater
('Images and Words', 1992, 3, 'https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/62/02/e1/6202e1a9-e297-848e-c3c2-e4571fc8d2e0/mzi.opgeoigt.jpg/1200x1200bb.jpg', 6),
-- Arctic Monkeys
('Whatever People Say I Am, That''s What I''m Not', 2006, 2, 'https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/cf/9b/96/cf9b9637-f619-eceb-5382-e9b4d44e74fb/dj.npwkgmai.jpg/600x600bf-60.jpg', 7),
('Favourite Worst Nightmare', 2007, 4, 'https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/82/90/14/829014ad-a301-62ab-bee6-f4cca4457411/mzi.hozudery.jpg/600x600bf-60.jpg', 7),
('Humbug', 2009, 2, 'https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/4a/07/92/4a0792a5-03c9-10d8-a60c-94fa8bb6508a/mzi.nlrajrgr.jpg/1200x630bb.jpg', 7),
('Suck It and See', 2011, 4, 'https://is1-ssl.mzstatic.com/image/thumb/Features/62/5b/66/dj.wlpuxxqn.jpg/600x600bf-60.jpg', 7),
('AM', 2013, 2, 'https://is1-ssl.mzstatic.com/image/thumb/Music113/v4/cc/0f/2d/cc0f2d02-5ff1-10e7-eea2-76863a55dbad/887828031795.png/600x600bf-60.jpg', 7),
('Tranquility Base Hotel & Casino', 2018, 5, 'https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/f3/ac/06/f3ac06b3-9217-adc8-cc33-8e930293e495/887835044184.png/600x600bf-60.jpg', 7),
('The Car', 2022, 5, 'https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/0f/03/0f/0f030fb9-a529-dba5-4e9d-4fbf2ed25037/887828045563.png/1200x1200bf-60.jpg', 7);

-- 5. Insertando canciones
-- 5. Insertando canciones completas para todos los álbumes
DELETE FROM Song;
DELETE FROM sqlite_sequence WHERE name='Song';

-- Album 1: Michael Jackson - Thriller (1982)
INSERT INTO Song (title, n_track, album_id) VALUES
('Wanna Be Startin'' Somethin''', 1, 1),
('Baby Be Mine', 2, 1),
('The Girl Is Mine', 3, 1),
('Thriller', 4, 1),
('Beat It', 5, 1),
('Billie Jean', 6, 1),
('Human Nature', 7, 1),
('P.Y.T. (Pretty Young Thing)', 8, 1),
('The Lady in My Life', 9, 1);

-- Album 2: Pink Floyd - The Dark Side of the Moon (1973)
INSERT INTO Song (title, n_track, album_id) VALUES
('Speak to Me', 1, 2),
('Breathe (In the Air)', 2, 2),
('On the Run', 3, 2),
('Time', 4, 2),
('The Great Gig in the Sky', 5, 2),
('Money', 6, 2),
('Us and Them', 7, 2),
('Any Colour You Like', 8, 2),
('Brain Damage', 9, 2),
('Eclipse', 10, 2);

-- Album 3: AC/DC - Back in Black (1980)
INSERT INTO Song (title, n_track, album_id) VALUES
('Hells Bells', 1, 3),
('Shoot to Thrill', 2, 3),
('What Do You Do for Money Honey', 3, 3),
('Given the Dog a Bone', 4, 3),
('Let Me Put My Love into You', 5, 3),
('Back in Black', 6, 3),
('You Shook Me All Night Long', 7, 3),
('Have a Drink on Me', 8, 3),
('Shake a Leg', 9, 3),
('Rock and Roll Ain''t Noise Pollution', 10, 3);

-- Album 4: Twenty One Pilots - Clancy (2024)
INSERT INTO Song (title, n_track, album_id) VALUES
('Overcompensate', 1, 4),
('Next Semester', 2, 4),
('Backslide', 3, 4),
('Midwest Indigo', 4, 4),
('Routines in the Night', 5, 4),
('Vignette', 6, 4),
('The Craving (Jenna''s Version)', 7, 4),
('Lavish', 8, 4),
('Navigating', 9, 4),
('Snap to Attention', 10, 4),
('Oldies Station', 11, 4),
('At the Risk of Feeling Dumb', 12, 4),
('Paladin Strait', 13, 4);

-- Album 5: Twenty One Pilots - Scaled and Icy (2021)
INSERT INTO Song (title, n_track, album_id) VALUES
('Good Day', 1, 5),
('Choker', 2, 5),
('Shy Away', 3, 5),
('The Outside', 4, 5),
('Saturday', 5, 5),
('Never Take It', 6, 5),
('Mulberry Street', 7, 5),
('Formidable', 8, 5),
('Bounce Man', 9, 5),
('No Chances', 10, 5),
('Redecorate', 11, 5);

-- Album 6: Twenty One Pilots - Trench (2018)
INSERT INTO Song (title, n_track, album_id) VALUES
('Jumpsuit', 1, 6),
('Levitate', 2, 6),
('Morph', 3, 6),
('My Blood', 4, 6),
('Chlorine', 5, 6),
('Smithereens', 6, 6),
('Neon Gravestones', 7, 6),
('The Hype', 8, 6),
('Nico and the Niners', 9, 6),
('Cut My Lip', 10, 6),
('Bandito', 11, 6),
('Pet Cheetah', 12, 6),
('Legend', 13, 6),
('Leave the City', 14, 6);

-- Album 7: Twenty One Pilots - Blurryface (2015)
INSERT INTO Song (title, n_track, album_id) VALUES
('Heavydirtysoul', 1, 7),
('Stressed Out', 2, 7),
('Ride', 3, 7),
('Fairly Local', 4, 7),
('Tear in My Heart', 5, 7),
('Lane Boy', 6, 7),
('The Judge', 7, 7),
('Polarize', 8, 7),
('We Don''t Believe What''s on TV', 9, 7),
('Message Man', 10, 7),
('Hometown', 11, 7),
('Not Today', 12, 7),
('Goner', 13, 7),
('Doubt', 14, 7);

-- Album 8: Twenty One Pilots - Vessel (2013)
INSERT INTO Song (title, n_track, album_id) VALUES
('Ode to Sleep', 1, 8),
('Holding on to You', 2, 8),
('Migraine', 3, 8),
('House of Gold', 4, 8),
('Car Radio', 5, 8),
('Semi-Automatic', 6, 8),
('Screen', 7, 8),
('The Run and Go', 8, 8),
('Fake You Out', 9, 8),
('Guns for Hands', 10, 8),
('Trees', 11, 8),
('Truce', 12, 8);

-- Album 9: Twenty One Pilots - Twenty One Pilots (2009)
INSERT INTO Song (title, n_track, album_id) VALUES
('Implicit Demand for Proof', 1, 9),
('Fall Away', 2, 9),
('The Pantaloon', 3, 9),
('Addict with a Pen', 4, 9),
('Friend, Please', 5, 9),
('March to the Sea', 6, 9),
('Johnny Boy', 7, 9),
('Oh Ms Believer', 8, 9),
('Air Catcher', 9, 9),
('Trapdoor', 10, 9),
('A Car, a Torch, a Death', 11, 9),
('Taxi Cab', 12, 9),
('Before You Start Your Day', 13, 9),
('Isle of Flightless Birds', 14, 9);

-- Album 10: Imagine Dragons - Smoke & Mirrors (2014)
INSERT INTO Song (title, n_track, album_id) VALUES
('Shots', 1, 10),
('Gold', 2, 10),
('Smoke and Mirrors', 3, 10),
('I''m So Sorry', 4, 10),
('I Bet My Life', 5, 10),
('Polaroid', 6, 10),
('Friction', 7, 10),
('It Comes Back to You', 8, 10),
('Dream', 9, 10),
('Trouble', 10, 10),
('Summer', 11, 10),
('Hopeless Opus', 12, 10),
('The Fall', 13, 10);

-- Album 11: Dream Theater - Images and Words (1992)
INSERT INTO Song (title, n_track, album_id) VALUES
('Pull Me Under', 1, 11),
('Another Day', 2, 11),
('Take the Time', 3, 11),
('Surrounded', 4, 11),
('Metropolis—Part I: The Miracle and the Sleeper', 5, 11),
('Under a Glass Moon', 6, 11),
('Wait for Sleep', 7, 11),
('Learning to Live', 8, 11);

-- Album 12: Arctic Monkeys - Whatever People Say I Am, That's What I'm Not (2006)
INSERT INTO Song (title, n_track, album_id) VALUES
('The View from the Afternoon', 1, 12),
('I Bet You Look Good on the Dancefloor', 2, 12),
('Fake Tales of San Francisco', 3, 12),
('Dancing Shoes', 4, 12),
('You Probably Couldn''t See for the Lights but You Were Staring Straight at Me', 5, 12),
('Still Take You Home', 6, 12),
('Riot Van', 7, 12),
('Red Light Indicates Doors Are Secured', 8, 12),
('Mardy Bum', 9, 12),
('Perhaps Vampires Is a Bit Strong But...', 10, 12),
('When the Sun Goes Down', 11, 12),
('From the Ritz to the Rubble', 12, 12),
('A Certain Romance', 13, 12);

-- Album 13: Arctic Monkeys - Favourite Worst Nightmare (2007)
INSERT INTO Song (title, n_track, album_id) VALUES
('Brianstorm', 1, 13),
('Teddy Picker', 2, 13),
('D Is for Dangerous', 3, 13),
('Balaclava', 4, 13),
('Fluorescent Adolescent', 5, 13),
('Only Ones Who Know', 6, 13),
('Do Me a Favour', 7, 13),
('This House Is a Circus', 8, 13),
('If You Were There, Beware', 9, 13),
('The Bad Thing', 10, 13),
('Old Yellow Bricks', 11, 13),
('505', 12, 13);

-- Album 14: Arctic Monkeys - Humbug (2009)
INSERT INTO Song (title, n_track, album_id) VALUES
('My Propeller', 1, 14),
('Crying Lightning', 2, 14),
('Dangerous Animals', 3, 14),
('Secret Door', 4, 14),
('Potion Approaching', 5, 14),
('Fire and the Thud', 6, 14),
('Cornerstone', 7, 14),
('Dance Little Liar', 8, 14),
('Pretty Visitors', 9, 14),
('The Jeweller''s Hands', 10, 14);

-- Album 15: Arctic Monkeys - Suck It and See (2011)
INSERT INTO Song (title, n_track, album_id) VALUES
('She''s Thunderstorms', 1, 15),
('Black Treacle', 2, 15),
('Brick by Brick', 3, 15),
('The Hellcat Spangled Shalalala', 4, 15),
('Don''t Sit Down ''Cause I''ve Moved Your Chair', 5, 15),
('Library Pictures', 6, 15),
('All My Own Stunts', 7, 15),
('Reckless Serenade', 8, 15),
('Piledriver Waltz', 9, 15),
('Love Is a Laserquest', 10, 15),
('Suck It and See', 11, 15),
('That''s Where You''re Wrong', 12, 15);

-- Album 16: Arctic Monkeys - AM (2013)
INSERT INTO Song (title, n_track, album_id) VALUES
('Do I Wanna Know?', 1, 16),
('R U Mine?', 2, 16),
('One for the Road', 3, 16),
('Arabella', 4, 16),
('I Want It All', 5, 16),
('No. 1 Party Anthem', 6, 16),
('Mad Sounds', 7, 16),
('Fireside', 8, 16),
('Why''d You Only Call Me When You''re High?', 9, 16),
('Snap Out of It', 10, 16),
('Knee Socks', 11, 16),
('I Wanna Be Yours', 12, 16);

-- Album 17: Arctic Monkeys - Tranquility Base Hotel & Casino (2018)
INSERT INTO Song (title, n_track, album_id) VALUES
('Star Treatment', 1, 17),
('One Point Perspective', 2, 17),
('American Sports', 3, 17),
('Tranquility Base Hotel & Casino', 4, 17),
('Golden Trunks', 5, 17),
('Four Out of Five', 6, 17),
('The World''s First Ever Monster Truck Front Flip', 7, 17),
('Science Fiction', 8, 17),
('She Looks Like Fun', 9, 17),
('Batphone', 10, 17),
('The Ultracheese', 11, 17);

-- Album 18: Arctic Monkeys - The Car (2022)
INSERT INTO Song (title, n_track, album_id) VALUES
('There''d Better Be a Mirrorball', 1, 18),
('I Ain''t Quite Where I Think I Am', 2, 18),
('Sculptures of Anything Goes', 3, 18),
('Jet Skis on the Moat', 4, 18),
('Body Paint', 5, 18),
('The Car', 6, 18),
('Big Ideas (Don''t Get Any)', 7, 18),
('Hello You', 8, 18),
('Mr Schwartz', 9, 18),
('Perfect Sense', 10, 18);

-- 6. Insertando relacion Album_User
DELETE FROM Album_User;
-- Usuario 1: Sebastián
INSERT INTO Album_User (user_id, album_id, rank_date, rank_state) VALUES (1, 1, '01-01-2023', 'Valorado');
INSERT INTO Album_User (user_id, album_id, rank_date, rank_state) VALUES (1, 2, '10-02-2023', 'Por valorar');

-- Usuario 2: Rodrigo
INSERT INTO Album_User (user_id, album_id, rank_date, rank_state) VALUES (2, 3, '15-03-2023', 'Valorado');
INSERT INTO Album_User (user_id, album_id, rank_date, rank_state) VALUES (2, 4, '20-04-2023', 'Por valorar');

-- Usuario 3: Carlos
INSERT INTO Album_User (user_id, album_id, rank_date, rank_state) VALUES (3, 5, '05-05-2024', 'Valorado');
INSERT INTO Album_User (user_id, album_id, rank_date, rank_state) VALUES (3, 6, '12-06-2024', 'Por valorar');

-- Usuario 4: Tyler
INSERT INTO Album_User (user_id, album_id, rank_date, rank_state) VALUES (4, 7, '22-07-2024', 'Valorado');
INSERT INTO Album_User (user_id, album_id, rank_date, rank_state) VALUES (4, 8, '30-08-2024', 'Por valorar');

-- Usuario 5: Sofía
INSERT INTO Album_User (user_id, album_id, rank_date, rank_state) VALUES (5, 9, '03-09-2025', 'Valorado');
INSERT INTO Album_User (user_id, album_id, rank_date, rank_state) VALUES (5, 10, '10-10-2025', 'Por valorar');



--7. Insertando relacion Artist_User
DELETE FROM Artist_User ;
-- Usuario 1: Sebastián
INSERT INTO Artist_User (user_id, artist_id) VALUES (1, 1);
INSERT INTO Artist_User (user_id, artist_id) VALUES (1, 2);

-- Usuario 2: Rodrigo
INSERT INTO Artist_User (user_id, artist_id) VALUES (2, 2);
INSERT INTO Artist_User (user_id, artist_id) VALUES (2, 3);

-- Usuario 3: Carlos
INSERT INTO Artist_User (user_id, artist_id) VALUES (3, 3);
INSERT INTO Artist_User (user_id, artist_id) VALUES (3, 4);

-- Usuario 4: Tyler
INSERT INTO Artist_User (user_id, artist_id) VALUES (4, 4);
INSERT INTO Artist_User (user_id, artist_id) VALUES (4, 5);

-- Usuario 5: Sofía
INSERT INTO Artist_User (user_id, artist_id) VALUES (5, 6);
INSERT INTO Artist_User (user_id, artist_id) VALUES (5, 7);



--8. Insertando relacion Song_User
DELETE FROM Song_User ;
INSERT INTO Song_User (user_id, song_id, score) VALUES (1, 1, 85);
INSERT INTO Song_User (user_id, song_id, score) VALUES (1, 2, 70);
INSERT INTO Song_User (user_id, song_id, score) VALUES (1, 3, 75);
INSERT INTO Song_User (user_id, song_id, score) VALUES (1, 4, 95);
INSERT INTO Song_User (user_id, song_id, score) VALUES (1, 5, 90);
INSERT INTO Song_User (user_id, song_id, score) VALUES (1, 6, 100);
INSERT INTO Song_User (user_id, song_id, score) VALUES (1, 7, 80);
INSERT INTO Song_User (user_id, song_id, score) VALUES (1, 8, 78);
INSERT INTO Song_User (user_id, song_id, score) VALUES (1, 9, 72);
INSERT INTO Song_User (user_id, song_id, score) VALUES (2, 10, 65);
INSERT INTO Song_User (user_id, song_id, score) VALUES (2, 11, 88);
INSERT INTO Song_User (user_id, song_id, score) VALUES (2, 12, 70);
INSERT INTO Song_User (user_id, song_id, score) VALUES (2, 13, 90);
INSERT INTO Song_User (user_id, song_id, score) VALUES (2, 14, 85);
INSERT INTO Song_User (user_id, song_id, score) VALUES (2, 15, 100);
INSERT INTO Song_User (user_id, song_id, score) VALUES (2, 16, 92);
INSERT INTO Song_User (user_id, song_id, score) VALUES (2, 17, 75);
INSERT INTO Song_User (user_id, song_id, score) VALUES (2, 18, 83);
INSERT INTO Song_User (user_id, song_id, score) VALUES (2, 19, 88);
INSERT INTO Song_User (user_id, song_id, score) VALUES (3, 20, 92);
INSERT INTO Song_User (user_id, song_id, score) VALUES (3, 21, 85);
INSERT INTO Song_User (user_id, song_id, score) VALUES (3, 22, 78);
INSERT INTO Song_User (user_id, song_id, score) VALUES (3, 23, 80);
INSERT INTO Song_User (user_id, song_id, score) VALUES (3, 24, 75);
INSERT INTO Song_User (user_id, song_id, score) VALUES (3, 25, 98);
INSERT INTO Song_User (user_id, song_id, score) VALUES (3, 26, 100);
INSERT INTO Song_User (user_id, song_id, score) VALUES (3, 27, 82);
INSERT INTO Song_User (user_id, song_id, score) VALUES (3, 28, 77);
INSERT INTO Song_User (user_id, song_id, score) VALUES (3, 29, 85);
INSERT INTO Song_User (user_id, song_id, score) VALUES (4, 26, 100);
INSERT INTO Song_User (user_id, song_id, score) VALUES (4, 27, 82);
INSERT INTO Song_User (user_id, song_id, score) VALUES (4, 28, 77);
INSERT INTO Song_User (user_id, song_id, score) VALUES (4, 29, 85);


