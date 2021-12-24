CREATE DATABASE telegram;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users(
    user_id uuid NOT NULL default uuid_generate_v4() PRIMARY KEY,
    user_firstname varchar(30) not null,
    user_lastname varchar(50) not null,
    user_phone varchar(50) not null,
    user_username varchar(50) unique not null,
    user_email varchar(70) unique not null,
    user_image text [] default {'https://via.placeholder.com/200x200'},
    user_date timestamp with time zone not null default current_timestamp,
    user_status boolean not null default true 
);

CREATE TABLE groups(
    group_id uuid NOT NULL default uuid_generate_v4() PRIMARY KEY,
    group_name varchar(77) not null,
    group_media text [] default {'https://via.placeholder.com/200x200'},
    group_date timestamp with time zone not null default current_timestamp,
    group_status boolean not null default true,
    group_author uuid not null,
    CONSTRAINT fk_group_author
        FOREIGN KEY(group_author)
            REFERENCES users(user_id)
            ON DELETE CASCADE
);

CREATE TABLE kanals(
    kanal_id uuid NOT NULL default uuid_generate_v4() PRIMARY KEY,
    kanal_name varchar(77) not null,
    kanal_media text [] default {'https://via.placeholder.com/200x200'},
    kanal_date timestamp with time zone not null default current_timestamp,
    kanal_status boolean not null default true,
    kanal_author uuid not null,
    CONSTRAINT fk_kanal_author
        FOREIGN KEY(kanal_author)
            REFERENCES users(user_id)
            ON DELETE CASCADE
);

CREATE TABLE group_users(
    group_users_id uuid NOT NULL default uuid_generate_v4() PRIMARY KEY,
    group_users_date timestamp with time zone not null default current_timestamp,
    group_id uuid not null,
    user_id uuid not null,
    CONSTRAINT fk_group_id
        FOREIGN KEY(group_id)
            REFERENCES groups(group_id)
            ON DELETE CASCADE,
    CONSTRAINT fk_user_id_group
        FOREIGN KEY(user_id)
            REFERENCES users(user_id)
            ON DELETE CASCADE
);

CREATE TABLE kanal_users(
    kanal_users_id uuid NOT NULL default uuid_generate_v4() PRIMARY KEY,
    kanal_users_date timestamp with time zone not null default current_timestamp,
    kanal_id uuid not null,
    user_id uuid not null,
    CONSTRAINT fk_kanal_id
        FOREIGN KEY(kanal_id)
            REFERENCES kanals(kanal_id)
            ON DELETE CASCADE,
    CONSTRAINT fk_user_id_kanal
        FOREIGN KEY(user_id)
            REFERENCES users(user_id)
            ON DELETE CASCADE
);

CREATE TABLE messages(
    message_id uuid NOT NULL default uuid_generate_v4() PRIMARY KEY,
    message_date timestamp with time zone not null default current_timestamp,
    message_text text default null,
    message_media text default null,
    message_status boolean not null default true,
    message_author uuid not null,
    message_user uuid default null,
    message_group uuid default null,
    message_kanal uuid default null,
    message_ref_message uuid default null,
    CONSTRAINT fk_message_author
        FOREIGN KEY(message_author)
            REFERENCES users(user_id)
            ON DELETE CASCADE,
    CONSTRAINT fk_message_user
        FOREIGN KEY(message_user)
            REFERENCES users(user_id)
            ON DELETE CASCADE,
    CONSTRAINT fk_message_group
        FOREIGN KEY(message_group)
            REFERENCES groups(group_id)
            ON DELETE CASCADE,
    CONSTRAINT fk_message_kanal
        FOREIGN KEY(message_kanal)
            REFERENCES kanals(kanal_id)
            ON DELETE CASCADE,
    CONSTRAINT fk_message_ref_message
        FOREIGN KEY(message_ref_message)
            REFERENCES messages(message_id)
            ON DELETE CASCADE
);

