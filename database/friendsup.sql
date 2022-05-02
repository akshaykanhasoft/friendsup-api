--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: f(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f(_type text, _first integer, _second integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $$
    select case _type when 'ab' then _first else _second end;
$$;


ALTER FUNCTION public.f(_type text, _first integer, _second integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: event_category; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.event_category (
    id integer NOT NULL,
    event_id integer DEFAULT 0,
    cat_id integer DEFAULT 0
);


ALTER TABLE public.event_category OWNER TO friendsup;

--
-- Name: event_category_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.event_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_category_id_seq OWNER TO friendsup;

--
-- Name: event_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.event_category_id_seq OWNED BY public.event_category.id;


--
-- Name: event_images; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.event_images (
    id integer NOT NULL,
    event_id integer DEFAULT 0,
    image_name character varying(255) DEFAULT NULL::character varying,
    created_at character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.event_images OWNER TO friendsup;

--
-- Name: event_images_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.event_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_images_id_seq OWNER TO friendsup;

--
-- Name: event_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.event_images_id_seq OWNED BY public.event_images.id;


--
-- Name: event_invited_users; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.event_invited_users (
    id integer NOT NULL,
    event_id integer DEFAULT 0,
    invited_user_id integer DEFAULT 0,
    interested integer DEFAULT 0,
    going integer DEFAULT 0,
    created_at character varying(255) DEFAULT NULL::character varying,
    requested integer DEFAULT 0
);


ALTER TABLE public.event_invited_users OWNER TO friendsup;

--
-- Name: COLUMN event_invited_users.requested; Type: COMMENT; Schema: public; Owner: friendsup
--

COMMENT ON COLUMN public.event_invited_users.requested IS 'default = 0
requested = 1
accept = 2
reject = 3';


--
-- Name: event_invited_users_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.event_invited_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_invited_users_id_seq OWNER TO friendsup;

--
-- Name: event_invited_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.event_invited_users_id_seq OWNED BY public.event_invited_users.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.events (
    event_id integer NOT NULL,
    event_name character varying(255) DEFAULT NULL::character varying,
    event_description text,
    event_type integer DEFAULT 0,
    event_start_date character varying(255) DEFAULT NULL::character varying,
    event_end_date character varying(255) DEFAULT NULL::character varying,
    approval integer DEFAULT 0,
    event_location character varying(255) DEFAULT NULL::character varying,
    event_lat character varying(255) DEFAULT NULL::character varying,
    event_lng character varying(255) DEFAULT NULL::character varying,
    created_by integer DEFAULT 0,
    created_at character varying(255),
    "timestamp" character varying(255)
);


ALTER TABLE public.events OWNER TO friendsup;

--
-- Name: COLUMN events.event_type; Type: COMMENT; Schema: public; Owner: friendsup
--

COMMENT ON COLUMN public.events.event_type IS '1 = private
0 = public';


--
-- Name: events_event_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.events_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_event_id_seq OWNER TO friendsup;

--
-- Name: events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.events_event_id_seq OWNED BY public.events.event_id;


--
-- Name: favourite; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.favourite (
    id integer NOT NULL,
    user_id integer,
    fav_user_id integer
);


ALTER TABLE public.favourite OWNER TO friendsup;

--
-- Name: favourite_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.favourite_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.favourite_id_seq OWNER TO friendsup;

--
-- Name: favourite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.favourite_id_seq OWNED BY public.favourite.id;


--
-- Name: friend_request; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.friend_request (
    id integer NOT NULL,
    from_id integer,
    to_id integer,
    req_status integer DEFAULT 0
);


ALTER TABLE public.friend_request OWNER TO friendsup;

--
-- Name: COLUMN friend_request.req_status; Type: COMMENT; Schema: public; Owner: friendsup
--

COMMENT ON COLUMN public.friend_request.req_status IS '1 req send
2 req accept
3 req decline';


--
-- Name: friend_request_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.friend_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.friend_request_id_seq OWNER TO friendsup;

--
-- Name: friend_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.friend_request_id_seq OWNED BY public.friend_request.id;


--
-- Name: friends; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.friends (
    id integer NOT NULL,
    user_id integer,
    friend_user_id integer,
    created_at character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.friends OWNER TO friendsup;

--
-- Name: friends_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.friends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.friends_id_seq OWNER TO friendsup;

--
-- Name: friends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.friends_id_seq OWNED BY public.friends.id;


--
-- Name: group_details; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.group_details (
    userfirebaseid character varying(255),
    groupid integer,
    is_admin integer DEFAULT 0,
    id integer NOT NULL
);


ALTER TABLE public.group_details OWNER TO friendsup;

--
-- Name: group_details_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.group_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_details_id_seq OWNER TO friendsup;

--
-- Name: group_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.group_details_id_seq OWNED BY public.group_details.id;


--
-- Name: group_invitation_to_users; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.group_invitation_to_users (
    userfirebaseid character varying(255),
    groupid integer,
    is_admin integer,
    user_id integer,
    created_date bigint,
    modified_date bigint,
    id integer NOT NULL,
    requested integer DEFAULT 0
);


ALTER TABLE public.group_invitation_to_users OWNER TO friendsup;

--
-- Name: group_invitation_to_users_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.group_invitation_to_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_invitation_to_users_id_seq OWNER TO friendsup;

--
-- Name: group_invitation_to_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.group_invitation_to_users_id_seq OWNED BY public.group_invitation_to_users.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.groups (
    modified_date bigint,
    user_id integer,
    created_date bigint,
    group_desc text,
    group_subject character varying(255),
    group_name character varying(255),
    group_profile character varying(255),
    group_status integer,
    id integer NOT NULL,
    approval integer DEFAULT 0
);


ALTER TABLE public.groups OWNER TO friendsup;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_id_seq OWNER TO friendsup;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: groups_post; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.groups_post (
    user_id bigint,
    groups_id bigint,
    group_post_text character varying(255),
    group_post_profile character varying(255),
    created_date bigint,
    modified_date bigint,
    group_post_location character varying(255),
    id integer NOT NULL
);


ALTER TABLE public.groups_post OWNER TO friendsup;

--
-- Name: groups_post_comments; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.groups_post_comments (
    groups_post_id bigint,
    comment_text text,
    created_date bigint,
    modified_date bigint,
    user_id bigint,
    id integer NOT NULL,
    groups_id bigint DEFAULT 0
);


ALTER TABLE public.groups_post_comments OWNER TO friendsup;

--
-- Name: groups_post_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.groups_post_comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_post_comments_id_seq OWNER TO friendsup;

--
-- Name: groups_post_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.groups_post_comments_id_seq OWNED BY public.groups_post_comments.id;


--
-- Name: groups_post_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.groups_post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_post_id_seq OWNER TO friendsup;

--
-- Name: groups_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.groups_post_id_seq OWNED BY public.groups_post.id;


--
-- Name: groups_post_image; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.groups_post_image (
    groups_images character varying(255),
    created_date bigint,
    updated_date bigint,
    groups_post_id integer,
    id integer NOT NULL
);


ALTER TABLE public.groups_post_image OWNER TO friendsup;

--
-- Name: groups_post_image_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.groups_post_image_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_post_image_id_seq OWNER TO friendsup;

--
-- Name: groups_post_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.groups_post_image_id_seq OWNED BY public.groups_post_image.id;


--
-- Name: groups_post_like; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.groups_post_like (
    groups_post_id bigint,
    user_id bigint,
    created_date bigint,
    modified_date bigint,
    id integer NOT NULL,
    groups_id bigint DEFAULT 0
);


ALTER TABLE public.groups_post_like OWNER TO friendsup;

--
-- Name: groups_post_like_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.groups_post_like_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_post_like_id_seq OWNER TO friendsup;

--
-- Name: groups_post_like_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.groups_post_like_id_seq OWNED BY public.groups_post_like.id;


--
-- Name: interest_main_categories; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.interest_main_categories (
    id integer NOT NULL,
    value character varying(255),
    image_name character varying(255)
);


ALTER TABLE public.interest_main_categories OWNER TO friendsup;

--
-- Name: interest_sub_categories; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.interest_sub_categories (
    id integer NOT NULL,
    value character varying(255) DEFAULT NULL::character varying,
    main_category_id integer
);


ALTER TABLE public.interest_sub_categories OWNER TO friendsup;

--
-- Name: interest_sub_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.interest_sub_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.interest_sub_categories_id_seq OWNER TO friendsup;

--
-- Name: interest_sub_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.interest_sub_categories_id_seq OWNED BY public.interest_sub_categories.id;


--
-- Name: life_status; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.life_status (
    id integer NOT NULL,
    value character varying(255) DEFAULT NULL::bpchar
);


ALTER TABLE public.life_status OWNER TO friendsup;

--
-- Name: life_status_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.life_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.life_status_id_seq OWNER TO friendsup;

--
-- Name: life_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.life_status_id_seq OWNED BY public.life_status.id;


--
-- Name: main_interest_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.main_interest_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.main_interest_categories_id_seq OWNER TO friendsup;

--
-- Name: main_interest_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.main_interest_categories_id_seq OWNED BY public.interest_main_categories.id;


--
-- Name: master_event_category; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.master_event_category (
    id integer NOT NULL,
    category_name character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.master_event_category OWNER TO friendsup;

--
-- Name: master_event_category_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.master_event_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.master_event_category_id_seq OWNER TO friendsup;

--
-- Name: master_event_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.master_event_category_id_seq OWNED BY public.master_event_category.id;


--
-- Name: master_groups; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.master_groups (
    group_id integer NOT NULL,
    group_firebase_id character varying(255) DEFAULT NULL::character varying,
    display_name character varying(255) DEFAULT NULL::character varying,
    group_image character varying(255)
);


ALTER TABLE public.master_groups OWNER TO friendsup;

--
-- Name: master_groups_group_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.master_groups_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.master_groups_group_id_seq OWNER TO friendsup;

--
-- Name: master_groups_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.master_groups_group_id_seq OWNED BY public.master_groups.group_id;


--
-- Name: master_iam; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.master_iam (
    id integer NOT NULL,
    value character varying(255)
);


ALTER TABLE public.master_iam OWNER TO friendsup;

--
-- Name: master_iam_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.master_iam_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.master_iam_id_seq OWNER TO friendsup;

--
-- Name: master_iam_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.master_iam_id_seq OWNED BY public.master_iam.id;


--
-- Name: master_looking_for_friends; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.master_looking_for_friends (
    id integer NOT NULL,
    value character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.master_looking_for_friends OWNER TO friendsup;

--
-- Name: master_looking_for_friends_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.master_looking_for_friends_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.master_looking_for_friends_id_seq OWNER TO friendsup;

--
-- Name: master_looking_for_friends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.master_looking_for_friends_id_seq OWNED BY public.master_looking_for_friends.id;


--
-- Name: master_myself; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.master_myself (
    id integer NOT NULL,
    value character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.master_myself OWNER TO friendsup;

--
-- Name: master_myself_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.master_myself_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.master_myself_id_seq OWNER TO friendsup;

--
-- Name: master_myself_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.master_myself_id_seq OWNED BY public.master_myself.id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.notification (
    id integer NOT NULL,
    from_id integer,
    to_id integer,
    notification_type integer,
    notification_text character varying(255) DEFAULT NULL::character varying,
    "time" character varying(255) DEFAULT NULL::character varying,
    read_status integer,
    event_id integer DEFAULT 0,
    group_id integer
);


ALTER TABLE public.notification OWNER TO friendsup;

--
-- Name: notification_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_id_seq OWNER TO friendsup;

--
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.notification_id_seq OWNED BY public.notification.id;


--
-- Name: notification_type; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.notification_type (
    id integer NOT NULL,
    value character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.notification_type OWNER TO friendsup;

--
-- Name: notification_type_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.notification_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_type_id_seq OWNER TO friendsup;

--
-- Name: notification_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.notification_type_id_seq OWNED BY public.notification_type.id;


--
-- Name: report_abuse; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.report_abuse (
    id integer NOT NULL,
    reported_by integer,
    reported_to integer,
    post_id integer,
    reason text,
    created_date character varying(255),
    group_id integer DEFAULT 0
);


ALTER TABLE public.report_abuse OWNER TO friendsup;

--
-- Name: report_abuse_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.report_abuse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_abuse_id_seq OWNER TO friendsup;

--
-- Name: report_abuse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.report_abuse_id_seq OWNED BY public.report_abuse.id;


--
-- Name: user_photos; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.user_photos (
    "photoId" integer NOT NULL,
    userid integer,
    image_name character varying(255),
    profile_picture integer DEFAULT 0,
    "position" integer
);


ALTER TABLE public.user_photos OWNER TO friendsup;

--
-- Name: userPhotos_photoId_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public."userPhotos_photoId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."userPhotos_photoId_seq" OWNER TO friendsup;

--
-- Name: userPhotos_photoId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public."userPhotos_photoId_seq" OWNED BY public.user_photos."photoId";


--
-- Name: user_access_token; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.user_access_token (
    access_id integer NOT NULL,
    user_id integer,
    token character(255),
    "time" integer,
    exp_time integer,
    status integer,
    ip character(255),
    ssid character(255) DEFAULT NULL::bpchar
);


ALTER TABLE public.user_access_token OWNER TO friendsup;

--
-- Name: user_access_token_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.user_access_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_access_token_id_seq OWNER TO friendsup;

--
-- Name: user_access_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.user_access_token_id_seq OWNED BY public.user_access_token.access_id;


--
-- Name: user_child; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.user_child (
    id integer NOT NULL,
    user_id integer,
    child_name character varying(255) DEFAULT NULL::character varying,
    child_gender character varying(255) DEFAULT NULL::character varying,
    child_age integer
);


ALTER TABLE public.user_child OWNER TO friendsup;

--
-- Name: user_child_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.user_child_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_child_id_seq OWNER TO friendsup;

--
-- Name: user_child_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.user_child_id_seq OWNED BY public.user_child.id;


--
-- Name: user_consider_myself; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.user_consider_myself (
    id integer NOT NULL,
    user_id integer,
    myself_status integer
);


ALTER TABLE public.user_consider_myself OWNER TO friendsup;

--
-- Name: user_consider_myself_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.user_consider_myself_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_consider_myself_id_seq OWNER TO friendsup;

--
-- Name: user_consider_myself_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.user_consider_myself_id_seq OWNED BY public.user_consider_myself.id;


--
-- Name: user_fcm_token; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.user_fcm_token (
    id integer NOT NULL,
    userid integer NOT NULL,
    fcm_token character varying(255) DEFAULT NULL::character varying,
    platform integer
);


ALTER TABLE public.user_fcm_token OWNER TO friendsup;

--
-- Name: user_fcm_token_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.user_fcm_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_fcm_token_id_seq OWNER TO friendsup;

--
-- Name: user_fcm_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.user_fcm_token_id_seq OWNED BY public.user_fcm_token.id;


--
-- Name: user_iam; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.user_iam (
    id integer NOT NULL,
    user_id integer,
    iam_status integer
);


ALTER TABLE public.user_iam OWNER TO friendsup;

--
-- Name: user_iam_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.user_iam_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_iam_id_seq OWNER TO friendsup;

--
-- Name: user_iam_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.user_iam_id_seq OWNED BY public.user_iam.id;


--
-- Name: user_interest; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.user_interest (
    id integer NOT NULL,
    user_id integer,
    interest integer
);


ALTER TABLE public.user_interest OWNER TO friendsup;

--
-- Name: user_interest_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.user_interest_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_interest_id_seq OWNER TO friendsup;

--
-- Name: user_interest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.user_interest_id_seq OWNED BY public.user_interest.id;


--
-- Name: user_life_status; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.user_life_status (
    id integer NOT NULL,
    user_id integer,
    relation_status integer
);


ALTER TABLE public.user_life_status OWNER TO friendsup;

--
-- Name: user_life_status_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.user_life_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_life_status_id_seq OWNER TO friendsup;

--
-- Name: user_life_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.user_life_status_id_seq OWNED BY public.user_life_status.id;


--
-- Name: user_looking_friends; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.user_looking_friends (
    id integer NOT NULL,
    user_id integer,
    looking_friends integer
);


ALTER TABLE public.user_looking_friends OWNER TO friendsup;

--
-- Name: user_looking_friends_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.user_looking_friends_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_looking_friends_id_seq OWNER TO friendsup;

--
-- Name: user_looking_friends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.user_looking_friends_id_seq OWNED BY public.user_looking_friends.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: friendsup
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255),
    firstname character varying(255),
    lastname character varying(255),
    password character varying(255) DEFAULT NULL::bpchar,
    gender character varying(255),
    fb_id character varying(255) DEFAULT NULL::bpchar,
    signup_from integer DEFAULT 0,
    gmail_id character varying(255) DEFAULT NULL::bpchar,
    "firebaseId" character varying(255),
    created_time integer,
    username character varying(255) DEFAULT NULL::bpchar,
    "mobileNumber" bigint,
    location character varying(255) DEFAULT NULL::bpchar,
    work_place character varying(255) DEFAULT NULL::bpchar,
    iam text,
    consider text,
    "lookingForFriends" text,
    dob character varying(255) DEFAULT NULL::bpchar,
    inerest character varying(1000) DEFAULT NULL::bpchar,
    is_modified integer DEFAULT 0,
    work_position character varying(255) DEFAULT NULL::bpchar,
    state character varying(255) DEFAULT NULL::character varying,
    country character varying(255) DEFAULT NULL::character varying,
    latitude character varying(255) DEFAULT NULL::character varying,
    longitude character varying(255) DEFAULT NULL::character varying,
    city character varying(255) DEFAULT NULL::character varying,
    mystory text,
    "ageFrom" integer,
    "ageTo" integer,
    distance integer,
    county character varying(255),
    postcode character varying(255),
    forgot_password_otp bigint DEFAULT 0,
    profile_completed integer DEFAULT 0
);


ALTER TABLE public.users OWNER TO friendsup;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: friendsup
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO friendsup;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: friendsup
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: event_category id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.event_category ALTER COLUMN id SET DEFAULT nextval('public.event_category_id_seq'::regclass);


--
-- Name: event_images id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.event_images ALTER COLUMN id SET DEFAULT nextval('public.event_images_id_seq'::regclass);


--
-- Name: event_invited_users id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.event_invited_users ALTER COLUMN id SET DEFAULT nextval('public.event_invited_users_id_seq'::regclass);


--
-- Name: events event_id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.events ALTER COLUMN event_id SET DEFAULT nextval('public.events_event_id_seq'::regclass);


--
-- Name: favourite id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.favourite ALTER COLUMN id SET DEFAULT nextval('public.favourite_id_seq'::regclass);


--
-- Name: friend_request id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.friend_request ALTER COLUMN id SET DEFAULT nextval('public.friend_request_id_seq'::regclass);


--
-- Name: friends id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.friends ALTER COLUMN id SET DEFAULT nextval('public.friends_id_seq'::regclass);


--
-- Name: group_details id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.group_details ALTER COLUMN id SET DEFAULT nextval('public.group_details_id_seq'::regclass);


--
-- Name: group_invitation_to_users id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.group_invitation_to_users ALTER COLUMN id SET DEFAULT nextval('public.group_invitation_to_users_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: groups_post id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.groups_post ALTER COLUMN id SET DEFAULT nextval('public.groups_post_id_seq'::regclass);


--
-- Name: groups_post_comments id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.groups_post_comments ALTER COLUMN id SET DEFAULT nextval('public.groups_post_comments_id_seq'::regclass);


--
-- Name: groups_post_image id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.groups_post_image ALTER COLUMN id SET DEFAULT nextval('public.groups_post_image_id_seq'::regclass);


--
-- Name: groups_post_like id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.groups_post_like ALTER COLUMN id SET DEFAULT nextval('public.groups_post_like_id_seq'::regclass);


--
-- Name: interest_main_categories id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.interest_main_categories ALTER COLUMN id SET DEFAULT nextval('public.main_interest_categories_id_seq'::regclass);


--
-- Name: interest_sub_categories id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.interest_sub_categories ALTER COLUMN id SET DEFAULT nextval('public.interest_sub_categories_id_seq'::regclass);


--
-- Name: life_status id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.life_status ALTER COLUMN id SET DEFAULT nextval('public.life_status_id_seq'::regclass);


--
-- Name: master_event_category id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.master_event_category ALTER COLUMN id SET DEFAULT nextval('public.master_event_category_id_seq'::regclass);


--
-- Name: master_groups group_id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.master_groups ALTER COLUMN group_id SET DEFAULT nextval('public.master_groups_group_id_seq'::regclass);


--
-- Name: master_iam id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.master_iam ALTER COLUMN id SET DEFAULT nextval('public.master_iam_id_seq'::regclass);


--
-- Name: master_looking_for_friends id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.master_looking_for_friends ALTER COLUMN id SET DEFAULT nextval('public.master_looking_for_friends_id_seq'::regclass);


--
-- Name: master_myself id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.master_myself ALTER COLUMN id SET DEFAULT nextval('public.master_myself_id_seq'::regclass);


--
-- Name: notification id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.notification ALTER COLUMN id SET DEFAULT nextval('public.notification_id_seq'::regclass);


--
-- Name: notification_type id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.notification_type ALTER COLUMN id SET DEFAULT nextval('public.notification_type_id_seq'::regclass);


--
-- Name: report_abuse id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.report_abuse ALTER COLUMN id SET DEFAULT nextval('public.report_abuse_id_seq'::regclass);


--
-- Name: user_access_token access_id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_access_token ALTER COLUMN access_id SET DEFAULT nextval('public.user_access_token_id_seq'::regclass);


--
-- Name: user_child id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_child ALTER COLUMN id SET DEFAULT nextval('public.user_child_id_seq'::regclass);


--
-- Name: user_consider_myself id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_consider_myself ALTER COLUMN id SET DEFAULT nextval('public.user_consider_myself_id_seq'::regclass);


--
-- Name: user_fcm_token id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_fcm_token ALTER COLUMN id SET DEFAULT nextval('public.user_fcm_token_id_seq'::regclass);


--
-- Name: user_iam id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_iam ALTER COLUMN id SET DEFAULT nextval('public.user_iam_id_seq'::regclass);


--
-- Name: user_interest id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_interest ALTER COLUMN id SET DEFAULT nextval('public.user_interest_id_seq'::regclass);


--
-- Name: user_life_status id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_life_status ALTER COLUMN id SET DEFAULT nextval('public.user_life_status_id_seq'::regclass);


--
-- Name: user_looking_friends id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_looking_friends ALTER COLUMN id SET DEFAULT nextval('public.user_looking_friends_id_seq'::regclass);


--
-- Name: user_photos photoId; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_photos ALTER COLUMN "photoId" SET DEFAULT nextval('public."userPhotos_photoId_seq"'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: event_category; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.event_category (id, event_id, cat_id) FROM stdin;
689	277	6
\.


--
-- Data for Name: event_images; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.event_images (id, event_id, image_name, created_at) FROM stdin;
136	277	jsIWJYxC7DASqtF.jpg	1560403981
\.


--
-- Data for Name: event_invited_users; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.event_invited_users (id, event_id, invited_user_id, interested, going, created_at, requested) FROM stdin;
349	277	297	0	0	1559656347	0
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.events (event_id, event_name, event_description, event_type, event_start_date, event_end_date, approval, event_location, event_lat, event_lng, created_by, created_at, "timestamp") FROM stdin;
277	Hello	Help	1	04-08-2019 07:21:pm	04-09-2019 07:21 pm	1	Ahmednagar, Maharashtra, India	19.0948287	74.74797889999999	272	1560403975	1567535400
\.


--
-- Data for Name: favourite; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.favourite (id, user_id, fav_user_id) FROM stdin;
201	272	274
202	272	281
\.


--
-- Data for Name: friend_request; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.friend_request (id, from_id, to_id, req_status) FROM stdin;
\.


--
-- Data for Name: friends; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.friends (id, user_id, friend_user_id, created_at) FROM stdin;
\.


--
-- Data for Name: group_details; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.group_details (userfirebaseid, groupid, is_admin, id) FROM stdin;
vmhIvrXFx3Z043QwqlfG8JfjHTE2	221	0	93
TrkAoJKEPZVoOGsXQRG90BiKITB2	221	1	94
VV60R22I8PSRT83gif9qXdKYzVO2	221	0	95
\N	217	0	58
\N	217	0	59
\N	217	1	60
\N	217	0	61
TrkAoJKEPZVoOGsXQRG90BiKITB2	218	1	62
vmhIvrXFx3Z043QwqlfG8JfjHTE2	218	0	63
VV60R22I8PSRT83gif9qXdKYzVO2	218	0	64
\N	219	1	74
\N	219	0	75
\N	219	0	76
TrkAoJKEPZVoOGsXQRG90BiKITB2	220	1	83
VV60R22I8PSRT83gif9qXdKYzVO2	220	0	84
vmhIvrXFx3Z043QwqlfG8JfjHTE2	220	0	85
VkpPbZNIvySjEJ5M9w8TUXhrxI32	222	1	86
VV60R22I8PSRT83gif9qXdKYzVO2	222	0	87
gPb1mFUwRtcgUkOnfWml6Qms2Bn1	222	0	88
TrkAoJKEPZVoOGsXQRG90BiKITB2	222	0	89
\.


--
-- Data for Name: group_invitation_to_users; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.group_invitation_to_users (userfirebaseid, groupid, is_admin, user_id, created_date, modified_date, id, requested) FROM stdin;
vmhIvrXFx3Z043QwqlfG8JfjHTE2	40	1	272	1558607946	1558607946	120	3
gPb1mFUwRtcgUkOnfWml6Qms2Bn1	41	0	274	1558607988	1558607988	124	3
vmhIvrXFx3Z043QwqlfG8JfjHTE2	40	0	274	1558608304	1558608304	128	3
TrkAoJKEPZVoOGsXQRG90BiKITB2	41	1	271	1558608130	1558608130	126	3
vmhIvrXFx3Z043QwqlfG8JfjHTE2	42	1	272	1558673810	1558673810	129	3
TrkAoJKEPZVoOGsXQRG90BiKITB2	42	0	271	1558673810	1558673810	130	3
VkpPbZNIvySjEJ5M9w8TUXhrxI32	42	0	275	1558673850	1558673850	132	3
VkpPbZNIvySjEJ5M9w8TUXhrxI32	40	0	275	1558678351	1558678351	133	3
vmhIvrXFx3Z043QwqlfG8JfjHTE2	43	1	272	1558950250	1558950250	134	3
VkpPbZNIvySjEJ5M9w8TUXhrxI32	43	0	275	1558950319	1558950319	136	1
VkpPbZNIvySjEJ5M9w8TUXhrxI32	44	1	275	1558951295	1558951295	137	3
vmhIvrXFx3Z043QwqlfG8JfjHTE2	44	0	272	1560318153	1560318153	140	3
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.groups (modified_date, user_id, created_date, group_desc, group_subject, group_name, group_profile, group_status, id, approval) FROM stdin;
1558607988	272	1558607988	Testing	Testing	Testing 2 - public	\N	0	41	0
1558608304	272	1558607946	Testing	Testing	Testing 1	\N	1	40	0
1558673810	272	1558673810	Nothing \n	Technology 	Hello testing 	\N	1	42	1
1558950250	272	1558950250	how are ou 	hwll	Hello	ANI2GYBbMz049WR.jpg	1	43	1
1560239293	275	1558951295	Enhanced your knowledge	hhdhd	React native Technology	PzMtXUvXkOCUWmb.jpg	1	44	0
\.


--
-- Data for Name: groups_post; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.groups_post (user_id, groups_id, group_post_text, group_post_profile, created_date, modified_date, group_post_location, id) FROM stdin;
275	42	Hello\n	\N	1558674511	1558674511		59
275	44	Good to know that	\N	1560233268	1560233268		61
272	43	Hello	\N	1560316563	1560316563		62
275	44	Hello \nThis group Is  really h\n\n\nA\nSD\nASDASD\nA\nSD\n\nD\nA\nD\nASDA\nSDASD	\N	1560318322	1560322782	Ahmedabad Airport (AMD), Hansol, Ahmedabad, Gujarat, India	63
272	44	Asdasdasdasd	\N	1560333823	1560333823		65
\.


--
-- Data for Name: groups_post_comments; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.groups_post_comments (groups_post_id, comment_text, created_date, modified_date, user_id, id, groups_id) FROM stdin;
\.


--
-- Data for Name: groups_post_image; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.groups_post_image (groups_images, created_date, updated_date, groups_post_id, id) FROM stdin;
2NCXrX5j0utrJsu.jpg	1560233280	1560233280	61	26
ab0IMUwaTCZXUi9.jpg	1560231329	1560317214	60	25
AXdPUswBUZjua5s.jpg	1560318329	1560318329	63	27
o3EDxcXKs2ry44U.jpg	1560318412	1560318412	64	28
\.


--
-- Data for Name: groups_post_like; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.groups_post_like (groups_post_id, user_id, created_date, modified_date, id, groups_id) FROM stdin;
\.


--
-- Data for Name: interest_main_categories; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.interest_main_categories (id, value, image_name) FROM stdin;
15	Home & Lifestyle	\N
21	Sports & Fitness	Fitness@2x.png
22	Technology and Computing	computing@2x.png
23	Travel	Travel@2x.png
2	Automotive	Automative@2x.png
1	Arts	Arts@2x.png
4	Business & Career	Business@2x.png
3	Books & Literature	Book@2x.png
6	Culture and Entertainment	Entertainment@2x.png
5	Charity	Cherity@2x.png
8	Fashion, Style & Beauty	Fashion@2x.png
7	Family	Family@2x.png
10	Food & Drink	Food@2x.png
9	Movies and Television	Movies@2x.png
12	Indoor Hobbies	indoor hobbies@2x.png
11	Gaming & Games	Gaming@2x.png
14	Health & Wellness	Health@2x.png
13	Outdoor Hobbies	Outdoor hobbies@2x.png
16	Music and Radio	Music@2x.png
18	Parenting	Parenting@2x.png
17	Parties & Nightlife	Parties@2x.png
20	Religion & Spirituality	Religion@2x.png
19	Pets	Pet@2x.png
\.


--
-- Data for Name: interest_sub_categories; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.interest_sub_categories (id, value, main_category_id) FROM stdin;
1	Animation	1
2	Architecture	1
3	Ceramics	1
4	Collage	1
5	Computer Art	1
6	Conceptual Art	1
7	Design	1
8	Drawing	1
9	Graffiti Art	1
10	Graphic Art	1
11	Illustration	1
12	Installation	1
13	Jewellery Art	1
14	Mosaic Art	1
15	Painting	1
16	Performance Art	1
17	Photography	1
18	Printmaking	1
19	Sculpture	1
20	Video Art	1
21	Aircrafts	2
22	Boats	2
23	Convertibles	2
24	Hybrid and electric vehicles	2
25	Luxury vehicles	2
26	Motorcycles	2
27	Off-road vehicles	2
28	Performance vehicles	2
29	Trucks	2
30	Vintage cars	2
31	Biographies and memoirs	3
32	Business and finance	3
33	Comics	3
34	Cookbooks, food, and wine	3
35	Crime	3
36	Fiction	3
37	Health, mind, and body	3
38	History	3
39	Hobbies and Crafts	3
40	Home and Garden	3
41	Kids	3
42	Medical	3
43	Mystery and crime	3
44	Non-fiction	3
45	Parenting	3
46	Politics and current events	3
47	Romance	3
48	Self Help	3
49	Sports	3
50	Travel	3
51	Trilogy	3
52	Advertising	4
53	Biotech and biomedical	4
54	Construction	4
55	Entrepreneurship	4
56	Financial planning	4
57	Government	4
58	Green solutions	4
59	Hedge Funds	4
60	Human resources	4
61	Investing	4
62	Investors and patents	4
63	Job fairs	4
64	Job search	4
65	Leadership	4
66	Marketing	4
67	Military	4
68	Non-profit	4
69	Real estate	4
70	Retirement planning	4
71	Small business	4
72	Stocks	4
73	Technology	4
74	Animal Charities	5
75	Anti-bullying	5
76	Arts & Culture Charties	5
77	Charities for disabled people‎	5
79	Childrens charities‎	5
80	Disaster Relief & Humanitarian	5
81	Disease & Disorder	5
82	Education Charities	5
83	Environmental Charities	5
84	Health Charities	5
85	Homelessness	5
86	International Development	5
87	LGBT	5
88	Libraries & Historical Societies	5
89	Medical Research	5
90	Medical Services & Treatment	5
91	Patient and Family Support	5
92	Peace & Human Rights	5
93	Pet and Animal Welfare	5
94	Prison charities‎	5
95	School Reform and Experimental Education	5
96	Social welfare	5
97	Sports charities	5
98	Volunteering	5
99	Wildlife Conservation	5
100	Youth charities‎	5
101	Amusement parks‎	6
102	Art exhibits‎	6
103	Childrens‎	6
104	Comedy clubs‎	6
105	Current Affairs‎	6
106	Dance‎	6
107	Drag shows‎	6
108	Fairs‎	6
109	Festivals‎	6
110	Film‎	6
111	Gastronomy‎	6
112	History‎	6
113	Human Interest‎	6
114	Lifestyle‎	6
115	Literature‎	6
116	Live entertainment‎	6
117	Movie festivals‎	6
118	Museums and Heritage‎	6
119	Music‎	6
120	Music festivals and concerts‎	6
121	Opera‎	6
122	Science‎	6
123	Sporting events‎	6
124	Sports‎	6
125	Stand-up comedy‎	6
126	Tech tradeshows‎	6
127	Theater‎	6
128	Tourism‎	6
129	Water parks‎	6
130	Adoption	7
131	Childhood	7
132	Childlessness	7
133	Divided family	7
134	Dysfunctional family	7
135	Extended family	7
136	Familiy Business	7
137	Familiy Law	7
138	Familiy Theraphy	7
139	Family Economy	7
140	Family Planning	7
141	Family reunion	7
142	Family traditions	7
143	Family values	7
144	Father absence	7
145	Firstborn	7
146	Foster Care	7
147	Fostering	7
148	Homemaking	7
149	Housewives‎	7
150	Kids	7
151	Living apart together	7
152	Only child	7
153	Orphan	7
154	Parenting	7
155	Pregnancy	7
156	Pre-school playgroup	7
157	Same-sex marriage and the family	7
158	Siblings	7
159	Stay-at-home dad	7
160	Stepfamiliy	7
161	Stepfamily	7
162	Surrogacy‎	7
163	Trial separation	7
164	Working parent	7
165	Beauty pageants‎	8
166	Body art	8
167	Clothing‎	8
168	Color analysis	8
169	Cosmetic surgery‎	8
170	Cut and sew	8
171	Designer clothing	8
172	Digital fashion	8
173	Face care	8
174	Facial care	8
175	Fashion Design	8
176	Fashion entrepreneur	8
177	Fashion events‎	8
178	Fashion industry‎	8
179	Fashion influencer	8
180	Fashion occupations‎	8
181	Footwear	8
182	Hair care	8
183	Hair removal‎	8
184	Hairstyles‎	8
185	History of fashion‎	8
186	Makeup / lashes / brows	8
187	Make-up and cosmetics	8
188	Male beauty‎	8
189	Nail care‎	8
190	Oral care‎	8
191	Outfit of the day	8
192	Perfumes and fragrances	8
193	Photo shoot	8
194	Shaving and grooming	8
195	Skin care	8
196	Spa	8
197	Street fashion‎	8
198	Style analysis	8
199	Tattoo / piercing	8
200	Action and adventure	9
201	Animation	9
202	Binge Watching	9
203	Biographical	9
204	Bollywood	9
205	Breakfast TV	9
206	Business and news	9
207	Childrens	9
208	Comedy	9
209	Daytime TV	9
210	Disaster	9
211	Docudrama	9
212	Documentary	9
213	Drama	9
214	Economics	9
215	Food reality	9
216	Foreign	9
217	Game show	9
218	Hidden camera	9
219	Horror	9
220	Independent	9
221	Medical drama	9
222	Music	9
223	Musicals	9
224	Reality TV	9
225	Relegiuos	9
226	Romance	9
227	Sci-fi and fantasy	9
228	Sitcom	9
229	Sports	9
230	Teen drama	9
231	Telenovela	9
232	War	9
233	Web series	9
234	American cuisine	10
235	Atkins	10
236	Barbecues and grilling	10
237	Beer	10
238	Cajun and Creole	10
239	Chinese cuisine	10
240	Cocktails	10
241	Coffee	10
242	Cooking	10
243	Desserts	10
244	Diabetic	10
245	Dining out	10
246	Ethnic foods	10
247	Fast food	10
248	Fine dining	10
249	French cuisine	10
250	Italian cuisine	10
251	Japanese cuisine	10
252	Kosher 	10
253	Liquor and spirits	10
254	Low FODMAP	10
255	Mexican cuisine	10
256	Seafood	10
257	Soda	10
258	Tea	10
259	Vegan	10
260	Vegetarian	10
261	Weight Watches	10
262	Wine	10
263	Board gaming	11
264	Cards	11
265	Computer gaming	11
266	Console gaming	11
267	Educational games	11
268	Mobile gaming	11
269	Mysteri games	11
270	Online gaming	11
271	Racing games	11
272	Roleplaying games	11
273	Video Games	11
274	Acting	12
275	Aquascaping	12
276	Astrology	12
277	Baking	12
278	Beatboxing	12
279	Birdwatching	12
280	Boating	12
281	Candle making	12
282	Cartoons	12
283	Chess	12
284	Coloring	12
285	Cosplaying	12
286	Creative writing	12
287	Crossword puzzles	12
288	Drawing and sketching	12
289	DYI	12
290	Exercise and fitness	12
291	Foreign language learning	12
292	Gambling	12
293	Homebrewing	12
294	Jewelry making	12
295	Knitting	12
296	Needlework	12
297	Paranormal phenomena	12
298	Podcast	12
299	Pottery	12
300	Puzzles	12
301	Renovation	12
302	Scrapbooking	12
303	Stamps and coins	12
304	Video gaming	12
305	Watching movies	12
306	Watching television	12
307	Wood carving	12
308	Yoga	12
309	DYI	13
310	Astronomy	13
311	Bird watching	13
312	BMX	13
313	Camping	13
314	Canoeing	13
315	Driving	13
316	Fishing	13
317	Flying	13
318	Geocaching	13
319	Ghost hunting	13
320	Hiking	13
321	Hunting	13
322	Ice skating	13
323	Kayaking	13
324	Kite flying	13
325	Kitesurfing	13
326	Motor sports	13
327	Mountain biking	13
328	Mountaineering	13
329	Orienteering	13
330	Rafting	13
331	Rappelling	13
332	Rock climbing	13
333	Roller skating	13
334	Sailing	13
335	Shopping	13
336	Skateboarding	13
337	Skiing	13
338	Skydiving	13
339	Surfing	13
340	Vehicle restoration	13
341	Water sports	13
342	Alcohol and health‎	14
343	Alternative lifestyle	14
344	Childrens health‎	14
345	Disability‎	14
346	Global health‎	14
347	Healing‎	14
348	Health care‎	14
349	Health Club	14
350	Health education‎	14
351	Health law‎	14
352	Health risk‎	14
353	Health system	14
354	Life coaching	14
355	Lifestyle guru	14
356	Lifestyle management	14
357	Mental health‎	14
358	Motivational speaker	14
359	Nutrition‎	14
360	Physical fitness‎	14
361	Quality of life‎	14
362	Sexual health‎	14
363	Social Support networks	14
364	Spa	14
365	Sustainable living	14
366	Apartment	15
367	Appliances	15
368	Automation	15
369	Cleaning	15
370	Domestic technology	15
371	Entertaining at home	15
372	Furniture	15
373	Garage	15
374	Gardening	15
375	Home business	15
376	Home Economics	15
377	Home improvement‎	15
378	Home repair	15
379	Homeschooling	15
380	House	15
381	Housekeeping	15
382	Interior decorating	15
383	Landscaping	15
384	Remodeling and construction	15
385	Alternative	16
386	Blues	16
387	Christian and gospel	16
388	Classical	16
389	Country	16
390	Dance	16
391	DJs	16
392	Electronic	16
393	Hip hop and rap	16
394	Indie spotlight	16
395	Jazz	16
396	Latino	16
397	Metal	16
398	Pop	16
399	R&B and soul	16
400	Reggae	16
401	Rock	16
402	Talk Radio	16
403	Venues	16
404	World	16
405	Bars	17
406	Cabaret‎	17
407	Cinemas	17
408	Cocktail party	17
409	Concerts	17
410	Costume or fancy dress party	17
411	Dinner Party	17
412	Discotheques	17
413	Fundraising party	17
414	Game Party	17
415	Garden Party	17
416	Karaoke	17
417	LAN party	17
418	Live Music	17
419	Night markets‎	17
420	Nightclubs‎	17
421	Nightlife	17
422	Pubs	17
423	Rave Party	17
424	Singles party and mixer	17
425	Toga party	17
426	Adoption	18
427	Babies and toddlers	18
428	Child care‎	18
429	Child custody‎	18
430	Coparenting	18
431	Daycare and preschool	18
432	Elder care	18
433	Empty nest syndrome	18
434	Fatherhood	18
435	LGBT parenting‎ 	18
436	Motherhood	18
437	Parenting K-6 kids	18
438	Parenting styles	18
439	Parenting teens	18
440	Split custody	18
441	Stay-at-home parents‎ 	18
442	Stepfather	18
443	Stepmother	18
444	Toilet training‎ 	18
445	Work at home parent	18
446	Amphibians	19
447	Animal training	19
448	Arthropods	19
449	Birds	19
450	Cats	19
451	Chicken	19
452	Dogs	19
453	Exotic animals	19
454	Fish	19
455	Gerbils	19
456	Goat	19
457	Guinea pigs	19
458	Hamsters	19
459	Hedgehogs	19
460	Horse	19
461	Horses	19
462	Mice	19
463	Rabbits	19
464	Rats	19
465	Reptiles	19
466	Sheep	19
467	Virtual pets‎	19
468	Buddhism	20
469	Christianity	20
470	Earth mysteries	20
471	Energy	20
472	Enlightenment	20
473	Enneagram	20
474	Hinduism	20
475	Islam	20
476	Meditation	20
477	Prayer	20
478	Self-realization	20
479	Auto racing	21
480	Baseball	21
481	Basketball	21
482	Bodybuilding	21
483	Boxing	21
484	Canoeing and kayaking	21
485	Climbing	21
486	College football	21
487	Cricket	21
488	Cycling	21
489	Fantasy sports	21
490	Field hockey	21
491	Figure skating	21
492	Golf	21
493	Golfing	21
494	Handball	21
495	Horse racing	21
496	Ice hockey	21
497	Inline skating	21
498	Jogging	21
499	Judo	21
500	Lacrosse	21
501	Martial arts	21
502	Netball	21
503	Paintball	21
504	Poker	21
505	Power and motorcycles	21
506	Powerlifting	21
507	Rodeo	21
508	Rugby	21
509	Scuba diving	21
510	Snowboarding	21
511	Soccer	21
512	Sporting goods	21
513	Squash	21
514	Swimming	21
515	Table tennis	21
516	Table tennis and ping-pong	21
517	Taekwondo	21
518	Tennis	21
519	Triathlon	21
520	Volleyball	21
521	Walking	21
522	Polo	21
523	Application software	22
524	Artificial Intelligence	22
525	Bare machine computing	22
526	Business software	22
527	Computer code	22
528	Computer engineering‎	22
529	Computer programming	22
530	Computer science	22
531	Computing	22
532	CyberGIS	22
533	EdTech	22
534	FinTech	22
535	Information Technology	22
536	Internet of Things	22
537	MedTech	22
538	Robotics	22
539	Software engineering‎	22
540	System software	22
541	Adventure travel	23
542	Business Travel	23
543	Commuting	23
544	Crusing	23
545	Exploration‎	23
546	Honeymoon	23
547	Interstellar travel‎	23
548	Package tour	23
549	Pet travel	23
550	Pilgrimages‎ 	23
551	Recreational travel	23
552	River cruise	23
553	Road trip	23
554	Safari holidays	23
555	Student Tavel	23
556	Train surfing	23
78	Charities for the elderly‎	5
\.


--
-- Data for Name: life_status; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.life_status (id, value) FROM stdin;
1	Single
2	In a relationship
3	Newlyweds
4	Married
5	Divorced
6	Widowed
7	Parent with young children
8	Parent with older children
9	Parent with grown children
10	Single parent with young children
11	Single parent with older children
12	Single parent with grown children
13	Pregnant / Expecting
\.


--
-- Data for Name: master_event_category; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.master_event_category (id, category_name) FROM stdin;
1	Comedy
2	Art
3	Causes
4	Crafts
5	Dance
6	Drink
7	Film
8	Fitness
9	Food
10	Games
11	Gardening
12	Health
13	Home
14	Literature
15	Music
16	Networking
17	Other
18	Party
19	Religion
20	Shopping
21	Sports
22	Theater
23	Wellness
\.


--
-- Data for Name: master_groups; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.master_groups (group_id, group_firebase_id, display_name, group_image) FROM stdin;
218	Hello _1559735343	Hello 	\N
219	Hello 2_1559735372	Hello 2 edit	PhnXUxzqANZwRis.jpg
220	Hello 3_1559735416	Hello 3 edit	\N
222	Technical Group_1560408173	Technical Group	WpIWhAXlmGzA64h.jpg
221	Hello 4_1559735453	Hello 4123	qmjF8mcu0asskda.jpg
217	Demo chat group_1559721229	Demo chat group update	\N
\.


--
-- Data for Name: master_iam; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.master_iam (id, value) FROM stdin;
1	Active
2	Adaptable
3	Adventurous
4	Ambitious
5	Attention-seeker
6	Calm
7	Caring
8	Creative
9	Emotional
10	Energic
11	Funny
12	Guarded
13	Honest
14	Independent
15	Introvert
16	Mystical
17	Open
18	Optimistic
19	Organized
20	Outgoing
21	Positive
22	Pragmatic
23	Relaxed
24	Shy
25	Spontaneous
\.


--
-- Data for Name: master_looking_for_friends; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.master_looking_for_friends (id, value) FROM stdin;
1	Afterwork
2	Boys Night
3	Business Partner
4	Café Visits
5	Cinema
6	Concerts
7	Deep Conversations
8	Events
9	Exercise and Gym
10	Girls Night
11	Have Fun With
12	Movie and Popcorn
13	Nights out
14	Outdoor Adventures
15	Playdates
16	Restaurant Visits
17	Social Gatherings
18	Spa and wellness
19	Theatre and Opera
21	Walks
22	Work-Related
20	Travel With
\.


--
-- Data for Name: master_myself; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.master_myself (id, value) FROM stdin;
2	A Party Animal
3	Entrepreneur
4	Fitness Junkie
6	Globetrotter
7	Just Divorced
8	Lonely
10	Looking for new Adventures
11	New in Town
12	On Maternity Leave
13	Pregnant
14	Self-Employed
15	Struggling with disease
16	Student
17	Tired of my old friends
18	Trying to get pregnant
1	A Dreamer
5	Focused on my Career
9	Looking for Friends without Kids
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.notification (id, from_id, to_id, notification_type, notification_text, "time", read_status, event_id, group_id) FROM stdin;
463	272	274	4	fromusers invite to join group	1558607988	1	0	41
464	272	271	4	fromusers invite to join group	1558607988	1	0	41
465	272	274	4	fromuser invite to join group	1558608304	1	0	40
470	272	297	2	fromuser invite to join event.	1559656347	1	277	\N
467	272	271	4	fromusers invite to join group	1558673810	1	0	42
466	272	275	4	fromusers invite to join group	1558673810	0	0	42
468	272	275	4	fromusers invite to join group	1558950250	1	0	43
469	275	272	4	fromusers invite to join group	1558951295	0	0	44
\.


--
-- Data for Name: notification_type; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.notification_type (id, value) FROM stdin;
1	send friend request
2	event invitation
\.


--
-- Data for Name: report_abuse; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.report_abuse (id, reported_by, reported_to, post_id, reason, created_date, group_id) FROM stdin;
13	272	275	63	Terrorism	1560409255	44
\.


--
-- Data for Name: user_access_token; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.user_access_token (access_id, user_id, token, "time", exp_time, status, ip, ssid) FROM stdin;
4722	272	1vkh5ghjf4jwn3bc14                                                                                                                                                                                                                                             	1559972442	\N	1	\N	\N
4209	271	1vkh5ghbscjvw81vo0                                                                                                                                                                                                                                             	1558347812	\N	1	\N	\N
4214	271	1vkh5ghbu4jvw91wxt                                                                                                                                                                                                                                             	1558349493	\N	1	\N	\N
4724	272	1vkh5ghjf4jwn3ckz2                                                                                                                                                                                                                                             	1559972500	\N	1	\N	\N
4229	271	1vkh5ghbu4jvwccjls                                                                                                                                                                                                                                             	1558355028	\N	1	\N	\N
4230	271	1vkh5ghbu4jvwcgv9s                                                                                                                                                                                                                                             	1558355230	\N	1	\N	\N
4218	274	1vkh5ghbu4jvw9lcvm                                                                                                                                                                                                                                             	1558350400	\N	1	\N	\N
4217	274	1vkh5ghbu4jvw9l7o4                                                                                                                                                                                                                                             	1558350394	\N	1	\N	\N
4220	274	1vkh5ghbu4jvw9m9e1                                                                                                                                                                                                                                             	1558350443	\N	1	\N	\N
4231	271	1vkh5gh7lojvwcksqo                                                                                                                                                                                                                                             	1558355413	\N	1	\N	\N
4749	272	1vkh5ghfwojwn74p8w                                                                                                                                                                                                                                             	1559978851	\N	1	\N	\N
4255	271	1vkh5gh69wjvz4sumy                                                                                                                                                                                                                                             	1558523750	\N	1	\N	\N
4496	297	1vkh5gh3kgjwixq0tv                                                                                                                                                                                                                                             	1559721185	\N	1	\N	\N
4748	272	1vkh5ghfwojwn72e2f                                                                                                                                                                                                                                             	1559978743	\N	1	\N	\N
4781	272	1vkh5ghfwojwndcl5g                                                                                                                                                                                                                                             	1559989296	\N	1	\N	\N
4782	272	1vkh5ghfwojwndny02                                                                                                                                                                                                                                             	1559989826	\N	1	\N	\N
4907	275	1vkh5ghdywjwstf0y2                                                                                                                                                                                                                                             	1560318615	\N	1	\N	\N
4959	275	1vkh5ghekojwt40yu7                                                                                                                                                                                                                                             	1560336435	\N	1	\N	\N
4238	296	1vkh5gh94gjvywkecf                                                                                                                                                                                                                                             	1558509919	\N	1	\N	\N
4239	296	1vkh5gh94gjvywxe2a                                                                                                                                                                                                                                             	1558510525	\N	1	\N	\N
4240	296	1vkh5gh94gjvywxi15                                                                                                                                                                                                                                             	1558510530	\N	1	\N	\N
4376	271	1vkh5ghdk0jw0iz6n7                                                                                                                                                                                                                                             	1558608027	\N	1	\N	\N
4377	271	1vkh5ghdk0jw0izjto                                                                                                                                                                                                                                             	1558608044	\N	1	\N	\N
4521	271	1vkh5gh3kgjwj64viu                                                                                                                                                                                                                                             	1559735315	\N	1	\N	\N
4208	271	1vkh5ghbscjvw7zd2z                                                                                                                                                                                                                                             	1558347695	\N	1	\N	\N
4785	297	1vkh5ghjmojwpyu0tn                                                                                                                                                                                                                                             	1560146314	\N	1	\N	\N
4908	275	1vkh5ghdywjwsth07n                                                                                                                                                                                                                                             	1560318707	\N	1	\N	\N
4723	272	1vkh5ghjf4jwn3bdne                                                                                                                                                                                                                                             	1559972444	\N	1	\N	\N
4750	272	1vkh5ghfwojwn76lli                                                                                                                                                                                                                                             	1559978939	\N	1	\N	\N
4784	272	1vkh5ghjmojwpyqfb8                                                                                                                                                                                                                                             	1560146146	\N	1	\N	\N
4824	275	1vkh5gh65sjwrel450                                                                                                                                                                                                                                             	1560233239	\N	1	\N	\N
4386	275	1vkh5ghdk0jw1m2yhn                                                                                                                                                                                                                                             	1558673708	\N	1	\N	\N
4522	271	1vkh5gh3kgjwj64z8o                                                                                                                                                                                                                                             	1559735319	\N	1	\N	\N
4960	275	1vkh5ghekojwt44fl5                                                                                                                                                                                                                                             	1560336596	\N	1	\N	\N
4221	274	1vkh5ghbu4jvw9me3l                                                                                                                                                                                                                                             	1558350449	\N	1	\N	\N
4222	274	1vkh5ghbu4jvw9n89v                                                                                                                                                                                                                                             	1558350488	\N	1	\N	\N
4300	271	1vkh5gh1s4jvzbmwzs                                                                                                                                                                                                                                             	1558535231	\N	1	\N	\N
4241	296	1vkh5gh94gjvywxjmx                                                                                                                                                                                                                                             	1558510533	\N	1	\N	\N
4210	271	1vkh5ghbscjvw81yyb                                                                                                                                                                                                                                             	1558347816	\N	1	\N	\N
4301	271	1vkh5gh1s4jvzbn10c                                                                                                                                                                                                                                             	1558535236	\N	1	\N	\N
4309	271	1vkh5gh1s4jvzc5r16                                                                                                                                                                                                                                             	1558536110	\N	1	\N	\N
4212	271	1vkh5ghbu4jvw8c9i6                                                                                                                                                                                                                                             	1558348296	\N	1	\N	\N
4219	271	1vkh5ghbu4jvw9ld01                                                                                                                                                                                                                                             	1558350401	\N	1	\N	\N
4213	271	1vkh5ghbu4jvw91upp                                                                                                                                                                                                                                             	1558349490	\N	1	\N	\N
4909	275	1vkh5ghdywjwstjysd                                                                                                                                                                                                                                             	1560318845	\N	1	\N	\N
4866	275	1vkh5gh65sjwrpbzjk                                                                                                                                                                                                                                             	1560251289	\N	1	\N	\N
4825	272	1vkh5gh65sjwreote7                                                                                                                                                                                                                                             	1560233411	\N	1	\N	\N
4826	272	1vkh5gh65sjwreovmr                                                                                                                                                                                                                                             	1560233414	\N	1	\N	\N
4827	272	1vkh5gh65sjwreqhy1                                                                                                                                                                                                                                             	1560233490	\N	1	\N	\N
4718	272	1vkh5ghjf4jwn2gxf2                                                                                                                                                                                                                                             	1559971023	\N	1	\N	\N
4341	275	1vkh5ghb54jw09c9g9                                                                                                                                                                                                                                             	1558591841	\N	1	\N	\N
4354	275	1vkh5ghb54jw0axhel                                                                                                                                                                                                                                             	1558594510	\N	1	\N	\N
4413	297	1vkh5gh4nsjw67nbtf                                                                                                                                                                                                                                             	1558951795	\N	1	\N	\N
4961	275	1vkh5ghekojwt4a6r5                                                                                                                                                                                                                                             	1560336865	\N	1	\N	\N
4348	275	1vkh5ghb54jw0as4kq                                                                                                                                                                                                                                             	1558594261	\N	1	\N	\N
4790	297	1vkh5ghjmojwpz32hp                                                                                                                                                                                                                                             	1560146736	\N	1	\N	\N
4962	275	1vkh5ghekojwt4i9gf                                                                                                                                                                                                                                             	1560337242	\N	1	\N	\N
4302	271	1vkh5gh1s4jvzbr8t2                                                                                                                                                                                                                                             	1558535433	\N	1	\N	\N
4910	275	1vkh5ghdywjwstmc7y                                                                                                                                                                                                                                             	1560318956	\N	1	\N	\N
4829	272	1vkh5gh65sjwrf3d5c                                                                                                                                                                                                                                             	1560234090	\N	1	\N	\N
4726	272	1vkh5ghjf4jwn3xxrt                                                                                                                                                                                                                                             	1559973496	\N	1	\N	\N
4259	272	1vkh5gh69wjvz55bk5                                                                                                                                                                                                                                             	1558524332	\N	1	\N	\N
4311	271	1vkh5gh1s4jvzc9uxg                                                                                                                                                                                                                                             	1558536301	\N	1	\N	\N
4911	275	1vkh5ghdywjwsud3wt                                                                                                                                                                                                                                             	1560320205	\N	1	\N	\N
4223	271	1vkh5ghbu4jvw9rdmc                                                                                                                                                                                                                                             	1558350681	\N	1	\N	\N
4224	271	1vkh5ghbu4jvw9udpd                                                                                                                                                                                                                                             	1558350821	\N	1	\N	\N
4392	275	1vkh5ghdk0jw1ntnbc                                                                                                                                                                                                                                             	1558676633	\N	1	\N	\N
4260	272	1vkh5gh1s4jvz5he7x                                                                                                                                                                                                                                             	1558524896	\N	1	\N	\N
4312	271	1vkh5gh1s4jvzcbbgz                                                                                                                                                                                                                                             	1558536369	\N	1	\N	\N
4349	275	1vkh5ghb54jw0au2zt                                                                                                                                                                                                                                             	1558594352	\N	1	\N	\N
4393	275	1vkh5ghdk0jw1nu15n                                                                                                                                                                                                                                             	1558676651	\N	1	\N	\N
4314	271	1vkh5gh1s4jvzcigaa                                                                                                                                                                                                                                             	1558536702	\N	1	\N	\N
4228	271	1vkh5ghbu4jvwc6rip                                                                                                                                                                                                                                             	1558354758	\N	1	\N	\N
4963	275	1vkh5ghekojwt4jcni                                                                                                                                                                                                                                             	1560337293	\N	1	\N	\N
4270	274	1vkh5gh1s4jvz6kn2m                                                                                                                                                                                                                                             	1558526727	\N	1	\N	\N
4271	274	1vkh5gh1s4jvz6kr4x                                                                                                                                                                                                                                             	1558526732	\N	1	\N	\N
4272	274	1vkh5gh1s4jvz6szgt                                                                                                                                                                                                                                             	1558527116	\N	1	\N	\N
4277	274	1vkh5gh1s4jvz860qa                                                                                                                                                                                                                                             	1558529404	\N	1	\N	\N
4830	272	1vkh5gh65sjwrf7ayi                                                                                                                                                                                                                                             	1560234274	\N	1	\N	\N
4727	272	1vkh5ghjf4jwn402al                                                                                                                                                                                                                                             	1559973596	\N	1	\N	\N
4753	272	1vkh5ghfwojwn7wzqh                                                                                                                                                                                                                                             	1559980171	\N	1	\N	\N
4232	271	1vkh5gh7lojvwcs5iv                                                                                                                                                                                                                                             	1558355756	\N	1	\N	\N
4233	271	1vkh5gh6k8jvwfazwu                                                                                                                                                                                                                                             	1558359995	\N	1	\N	\N
4244	271	1vkh5gh3vcjvz3xatv                                                                                                                                                                                                                                             	1558522278	\N	1	\N	\N
4814	272	1vkh5gh65sjwrdbxjt                                                                                                                                                                                                                                             	1560231131	\N	1	\N	\N
4912	275	1vkh5ghdywjwsuzzg0                                                                                                                                                                                                                                             	1560321272	\N	1	\N	\N
4245	271	1vkh5gh3vcjvz3xflh                                                                                                                                                                                                                                             	1558522285	\N	1	\N	\N
4246	271	1vkh5gh3vcjvz445ti                                                                                                                                                                                                                                             	1558522599	\N	1	\N	\N
4304	271	1vkh5gh1s4jvzbuoui                                                                                                                                                                                                                                             	1558535594	\N	1	\N	\N
4313	271	1vkh5gh1s4jvzcfwna                                                                                                                                                                                                                                             	1558536583	\N	1	\N	\N
4254	271	1vkh5gh69wjvz4srcw                                                                                                                                                                                                                                             	1558523746	\N	1	\N	\N
4391	275	1vkh5ghdk0jw1ntlhs                                                                                                                                                                                                                                             	1558676630	\N	1	\N	\N
4576	272	1vkh5ghc9sjwk7v1dy                                                                                                                                                                                                                                             	1559798681	\N	1	\N	\N
4602	272	1vkh5ghc9sjwk9y6nx                                                                                                                                                                                                                                             	1559802187	\N	1	\N	\N
4278	274	1vkh5gh1s4jvz88061                                                                                                                                                                                                                                             	1558529496	\N	1	\N	\N
4279	274	1vkh5gh1s4jvz89fn1                                                                                                                                                                                                                                             	1558529563	\N	1	\N	\N
4280	274	1vkh5gh1s4jvz8xf4x                                                                                                                                                                                                                                             	1558530682	\N	1	\N	\N
4281	274	1vkh5gh1s4jvz8z6lx                                                                                                                                                                                                                                             	1558530764	\N	1	\N	\N
4265	271	1vkh5gh1s4jvz5w5dw                                                                                                                                                                                                                                             	1558525584	\N	1	\N	\N
4308	271	1vkh5gh1s4jvzc3bfz                                                                                                                                                                                                                                             	1558535996	\N	1	\N	\N
4497	297	1vkh5gh3kgjwixq5zt                                                                                                                                                                                                                                             	1559721191	\N	1	\N	\N
4305	271	1vkh5gh1s4jvzbvij5                                                                                                                                                                                                                                             	1558535632	\N	1	\N	\N
4307	271	1vkh5gh1s4jvzc19gz                                                                                                                                                                                                                                             	1558535900	\N	1	\N	\N
4831	272	1vkh5gh65sjwrfor2e                                                                                                                                                                                                                                             	1560235088	\N	1	\N	\N
4728	272	1vkh5ghjf4jwn42zja                                                                                                                                                                                                                                             	1559973732	\N	1	\N	\N
4754	272	1vkh5ghfwojwn81f42                                                                                                                                                                                                                                             	1559980377	\N	1	\N	\N
4623	272	1vkh5gh1g8jwkcemwc                                                                                                                                                                                                                                             	1559806314	\N	1	\N	\N
4894	272	1vkh5ghdywjwss4i7e                                                                                                                                                                                                                                             	1560316444	\N	1	\N	\N
4837	272	1vkh5gh65sjwrg61vl                                                                                                                                                                                                                                             	1560235895	\N	1	\N	\N
4913	275	1vkh5ghdywjwsvdj36                                                                                                                                                                                                                                             	1560321904	\N	1	\N	\N
4399	275	1vkh5ghdk0jw1otw19                                                                                                                                                                                                                                             	1558678324	\N	1	\N	\N
4871	275	1vkh5gh65sjwrpgfp7                                                                                                                                                                                                                                             	1560251496	\N	1	\N	\N
4873	275	1vkh5gh65sjwrpjeqg                                                                                                                                                                                                                                             	1560251635	\N	1	\N	\N
4964	275	1vkh5ghax4jwt4suvp                                                                                                                                                                                                                                             	1560337736	\N	1	\N	\N
4315	271	1vkh5gh1s4jvzcl8xf                                                                                                                                                                                                                                             	1558536833	\N	1	\N	\N
4306	271	1vkh5gh1s4jvzbxdmz                                                                                                                                                                                                                                             	1558535719	\N	1	\N	\N
4316	271	1vkh5ghb54jw06d8dl                                                                                                                                                                                                                                             	1558586847	\N	1	\N	\N
4310	271	1vkh5gh1s4jvzc6wft                                                                                                                                                                                                                                             	1558536163	\N	1	\N	\N
4211	271	1vkh5ghbu4jvw8c5ri                                                                                                                                                                                                                                             	1558348292	\N	1	\N	\N
4225	271	1vkh5ghbu4jvwb1kfs                                                                                                                                                                                                                                             	1558352836	\N	1	\N	\N
4226	271	1vkh5ghbu4jvwb6t0s                                                                                                                                                                                                                                             	1558353081	\N	1	\N	\N
4832	272	1vkh5gh65sjwrfrn58                                                                                                                                                                                                                                             	1560235223	\N	1	\N	\N
4729	272	1vkh5ghfwojwn4da31                                                                                                                                                                                                                                             	1559974212	\N	1	\N	\N
4755	272	1vkh5ghfwojwn83jvh                                                                                                                                                                                                                                             	1559980477	\N	1	\N	\N
4761	272	1vkh5ghfwojwn8ml5j                                                                                                                                                                                                                                             	1559981365	\N	1	\N	\N
4544	272	1vkh5gh3kgjwj8r6v1                                                                                                                                                                                                                                             	1559739715	\N	1	\N	\N
4567	272	1vkh5ghc9sjwk725sr                                                                                                                                                                                                                                             	1559797334	\N	1	\N	\N
4914	275	1vkh5ghdywjwsvel0b                                                                                                                                                                                                                                             	1560321954	\N	1	\N	\N
4965	275	1vkh5ghax4jwt4vro3                                                                                                                                                                                                                                             	1560337872	\N	1	\N	\N
4793	297	1vkh5ghjmojwpzj0x0                                                                                                                                                                                                                                             	1560147481	\N	1	\N	\N
4872	275	1vkh5gh65sjwrphbnt                                                                                                                                                                                                                                             	1560251537	\N	1	\N	\N
4669	272	1vkh5ghbr8jwlvwrsz                                                                                                                                                                                                                                             	1559899539	\N	1	\N	\N
4398	275	1vkh5ghdk0jw1otsy9                                                                                                                                                                                                                                             	1558678320	\N	1	\N	\N
4340	275	1vkh5ghb54jw09c6i3                                                                                                                                                                                                                                             	1558591837	\N	1	\N	\N
4227	271	1vkh5ghbu4jvwbcv0p                                                                                                                                                                                                                                             	1558353363	\N	1	\N	\N
4833	272	1vkh5gh65sjwrfxpd6                                                                                                                                                                                                                                             	1560235506	\N	1	\N	\N
4730	272	1vkh5ghfwojwn4gimy                                                                                                                                                                                                                                             	1559974363	\N	1	\N	\N
4756	272	1vkh5ghfwojwn8fxgl                                                                                                                                                                                                                                             	1559981054	\N	1	\N	\N
4757	272	1vkh5ghfwojwn8gu79                                                                                                                                                                                                                                             	1559981097	\N	1	\N	\N
4758	272	1vkh5ghfwojwn8ie7e                                                                                                                                                                                                                                             	1559981169	\N	1	\N	\N
4533	272	1vkh5gh3kgjwj7d9hn                                                                                                                                                                                                                                             	1559737386	\N	1	\N	\N
4339	272	1vkh5ghb54jw09b6ms                                                                                                                                                                                                                                             	1558591790	\N	1	\N	\N
4558	272	1vkh5gh3kgjwja5a56                                                                                                                                                                                                                                             	1559742052	\N	1	\N	\N
4580	272	1vkh5ghc9sjwk82ewi                                                                                                                                                                                                                                             	1559799025	\N	1	\N	\N
4681	272	1vkh5ghbr8jwlx9fji                                                                                                                                                                                                                                             	1559901809	\N	1	\N	\N
4966	272	1vkh5gh6fsjwu85rgq                                                                                                                                                                                                                                             	1560403843	\N	0	\N	\N
4915	275	1vkh5gh784jwsvn73a                                                                                                                                                                                                                                             	1560322355	\N	1	\N	\N
4342	275	1vkh5ghb54jw09kx1h                                                                                                                                                                                                                                             	1558592245	\N	1	\N	\N
4874	275	1vkh5gh65sjwrpmzlr                                                                                                                                                                                                                                             	1560251802	\N	1	\N	\N
4303	271	1vkh5gh1s4jvzbtu28                                                                                                                                                                                                                                             	1558535554	\N	1	\N	\N
4967	272	1vkh5gh6fsjwu85uv2                                                                                                                                                                                                                                             	1560403848	\N	0	\N	\N
4263	271	1vkh5gh1s4jvz5t9jw                                                                                                                                                                                                                                             	1558525449	\N	1	\N	\N
4264	271	1vkh5gh1s4jvz5tcsc                                                                                                                                                                                                                                             	1558525454	\N	1	\N	\N
4380	271	1vkh5ghdk0jw0j624n                                                                                                                                                                                                                                             	1558608347	\N	1	\N	\N
4381	271	1vkh5ghdk0jw0j65hu                                                                                                                                                                                                                                             	1558608352	\N	1	\N	\N
4834	272	1vkh5gh65sjwrfz12s                                                                                                                                                                                                                                             	1560235567	\N	1	\N	\N
4835	272	1vkh5gh65sjwrfzx6k                                                                                                                                                                                                                                             	1560235609	\N	1	\N	\N
4636	272	1vkh5gh1asjwkfcatd                                                                                                                                                                                                                                             	1559811244	\N	1	\N	\N
4767	272	1vkh5ghfwojwn93l75                                                                                                                                                                                                                                             	1559982158	\N	1	\N	\N
4402	296	1vkh5gh4nsjw66ma1g                                                                                                                                                                                                                                             	1558950066	\N	1	\N	\N
4549	272	1vkh5gh3kgjwj9g2cj                                                                                                                                                                                                                                             	1559740876	\N	1	\N	\N
4798	297	1vkh5ghjmojwq0e9vq                                                                                                                                                                                                                                             	1560148939	\N	1	\N	\N
4799	297	1vkh5ghjmojwq0gjdj                                                                                                                                                                                                                                             	1560149044	\N	1	\N	\N
4403	296	1vkh5gh4nsjw66mcyr                                                                                                                                                                                                                                             	1558950070	\N	1	\N	\N
4404	296	1vkh5gh4nsjw66mdsq                                                                                                                                                                                                                                             	1558950071	\N	1	\N	\N
4800	297	1vkh5ghjmojwq0hhdz                                                                                                                                                                                                                                             	1560149088	\N	1	\N	\N
4550	272	1vkh5gh3kgjwj9k28z                                                                                                                                                                                                                                             	1559741062	\N	1	\N	\N
4570	272	1vkh5ghc9sjwk75pna                                                                                                                                                                                                                                             	1559797499	\N	1	\N	\N
4836	272	1vkh5gh65sjwrg3fxb                                                                                                                                                                                                                                             	1560235773	\N	1	\N	\N
4732	272	1vkh5ghfwojwn4p34l                                                                                                                                                                                                                                             	1559974763	\N	1	\N	\N
4762	272	1vkh5ghfwojwn8on7c                                                                                                                                                                                                                                             	1559981461	\N	1	\N	\N
4765	272	1vkh5ghfwojwn8x7yz                                                                                                                                                                                                                                             	1559981861	\N	1	\N	\N
4695	272	1vkh5ghbr8jwlywixy                                                                                                                                                                                                                                             	1559904566	\N	1	\N	\N
4299	272	1vkh5gh1s4jvzbl58m                                                                                                                                                                                                                                             	1558535148	\N	1	\N	\N
4334	272	1vkh5ghb54jw098v7f                                                                                                                                                                                                                                             	1558591682	\N	1	\N	\N
4335	272	1vkh5ghb54jw098z72                                                                                                                                                                                                                                             	1558591687	\N	1	\N	\N
4706	272	1vkh5ghbr8jwm5awuk                                                                                                                                                                                                                                             	1559915315	\N	1	\N	\N
4707	272	1vkh5ghbr8jwm5ccf3                                                                                                                                                                                                                                             	1559915382	\N	1	\N	\N
4714	272	1vkh5ghbr8jwm669ly                                                                                                                                                                                                                                             	1559916778	\N	1	\N	\N
4720	272	1vkh5ghjf4jwn36bnx                                                                                                                                                                                                                                             	1559972208	\N	1	\N	\N
4936	272	1vkh5gh784jwsxxfnd                                                                                                                                                                                                                                             	1560326192	\N	1	\N	\N
4895	272	1vkh5ghdywjwss4kt5                                                                                                                                                                                                                                             	1560316448	\N	1	\N	\N
4276	272	1vkh5gh1s4jvz85buo                                                                                                                                                                                                                                             	1558529371	\N	1	\N	\N
4284	272	1vkh5gh1s4jvz93f7g                                                                                                                                                                                                                                             	1558530962	\N	1	\N	\N
4321	272	1vkh5ghb54jw07tkuh                                                                                                                                                                                                                                             	1558589289	\N	1	\N	\N
4968	272	1vkh5ghh04jwu8f2rn                                                                                                                                                                                                                                             	1560404278	\N	0	\N	\N
4918	275	1vkh5gh784jwsvr2zl                                                                                                                                                                                                                                             	1560322537	\N	1	\N	\N
4876	275	1vkh5gh65sjwrpu3z2                                                                                                                                                                                                                                             	1560252134	\N	1	\N	\N
4801	297	1vkh5ghjmojwq0l1oj                                                                                                                                                                                                                                             	1560149255	\N	1	\N	\N
4382	271	1vkh5ghdk0jw0j80dc                                                                                                                                                                                                                                             	1558608439	\N	1	\N	\N
4838	272	1vkh5gh65sjwrg7fcv                                                                                                                                                                                                                                             	1560235959	\N	1	\N	\N
4839	272	1vkh5gh65sjwrg8u8g                                                                                                                                                                                                                                             	1560236025	\N	1	\N	\N
4733	272	1vkh5ghfwojwn4twnz                                                                                                                                                                                                                                             	1559974988	\N	1	\N	\N
4763	272	1vkh5ghfwojwn8rswl                                                                                                                                                                                                                                             	1559981608	\N	1	\N	\N
4325	272	1vkh5ghb54jw0816q1                                                                                                                                                                                                                                             	1558589644	\N	1	\N	\N
4359	272	1vkh5ghb54jw0bi27w                                                                                                                                                                                                                                             	1558595471	\N	1	\N	\N
4273	272	1vkh5gh1s4jvz7v4fa                                                                                                                                                                                                                                             	1558528895	\N	1	\N	\N
4551	272	1vkh5gh3kgjwj9lgoo                                                                                                                                                                                                                                             	1559741127	\N	1	\N	\N
4572	272	1vkh5ghc9sjwk790zv                                                                                                                                                                                                                                             	1559797654	\N	1	\N	\N
4573	272	1vkh5ghc9sjwk7p7th                                                                                                                                                                                                                                             	1559798409	\N	1	\N	\N
4601	272	1vkh5ghc9sjwk9ma88                                                                                                                                                                                                                                             	1559801632	\N	1	\N	\N
4620	272	1vkh5gh1g8jwkc918d                                                                                                                                                                                                                                             	1559806052	\N	1	\N	\N
4350	275	1vkh5ghb54jw0avdx1                                                                                                                                                                                                                                             	1558594413	\N	1	\N	\N
4870	275	1vkh5gh65sjwrpfemi                                                                                                                                                                                                                                             	1560251448	\N	1	\N	\N
4919	275	1vkh5gh784jwsvsfvu                                                                                                                                                                                                                                             	1560322600	\N	1	\N	\N
4408	275	1vkh5gh4nsjw66phoh                                                                                                                                                                                                                                             	1558950216	\N	1	\N	\N
4877	275	1vkh5gh65sjwrpw0lx                                                                                                                                                                                                                                             	1560252223	\N	1	\N	\N
4802	297	1vkh5ghjmojwq0m43i                                                                                                                                                                                                                                             	1560149304	\N	1	\N	\N
4878	275	1vkh5gh65sjwrpxv73                                                                                                                                                                                                                                             	1560252309	\N	1	\N	\N
4969	275	1vkh5ghgn0jwua4kmb                                                                                                                                                                                                                                             	1560407147	\N	1	\N	\N
4840	272	1vkh5gh65sjwrgju5a                                                                                                                                                                                                                                             	1560236538	\N	1	\N	\N
4621	272	1vkh5gh1g8jwkccp0m                                                                                                                                                                                                                                             	1559806223	\N	1	\N	\N
4622	272	1vkh5gh1g8jwkcdmrv                                                                                                                                                                                                                                             	1559806267	\N	1	\N	\N
4639	272	1vkh5gh1asjwkgapty                                                                                                                                                                                                                                             	1559812849	\N	1	\N	\N
4855	272	1vkh5gh65sjwrhdyaa                                                                                                                                                                                                                                             	1560237943	\N	1	\N	\N
4654	272	1vkh5ghbr8jwlsqr69                                                                                                                                                                                                                                             	1559894219	\N	1	\N	\N
4655	272	1vkh5ghbr8jwlss2k5                                                                                                                                                                                                                                             	1559894281	\N	1	\N	\N
4670	272	1vkh5ghbr8jwlw0avm                                                                                                                                                                                                                                             	1559899704	\N	1	\N	\N
4672	272	1vkh5ghbr8jwlw5qs0                                                                                                                                                                                                                                             	1559899957	\N	1	\N	\N
4682	272	1vkh5ghbr8jwlxazy0                                                                                                                                                                                                                                             	1559901882	\N	1	\N	\N
4294	272	1vkh5gh1s4jvza6h5d                                                                                                                                                                                                                                             	1558532784	\N	1	\N	\N
4416	272	1vkh5ghahgjwhfgbh0                                                                                                                                                                                                                                             	1559630033	\N	1	\N	\N
4387	272	1vkh5ghdk0jw1m4bkn                                                                                                                                                                                                                                             	1558673771	\N	1	\N	\N
4286	272	1vkh5gh1s4jvz97meo                                                                                                                                                                                                                                             	1558531158	\N	1	\N	\N
4937	272	1vkh5gh784jwsy0izt                                                                                                                                                                                                                                             	1560326337	\N	1	\N	\N
4898	272	1vkh5ghdywjwssh0gq                                                                                                                                                                                                                                             	1560317028	\N	1	\N	\N
4287	272	1vkh5gh1s4jvz97z1d                                                                                                                                                                                                                                             	1558531174	\N	1	\N	\N
4288	272	1vkh5gh1s4jvz9a8il                                                                                                                                                                                                                                             	1558531280	\N	1	\N	\N
4424	272	1vkh5ghahgjwhhk1fs                                                                                                                                                                                                                                             	1559633566	\N	1	\N	\N
4856	272	1vkh5gh65sjwrhibde                                                                                                                                                                                                                                             	1560238147	\N	1	\N	\N
4920	275	1vkh5gh784jwsvv7mu                                                                                                                                                                                                                                             	1560322729	\N	1	\N	\N
4879	275	1vkh5gh65sjwrq5rcu                                                                                                                                                                                                                                             	1560252678	\N	1	\N	\N
4803	297	1vkh5ghjmojwq0n3v0                                                                                                                                                                                                                                             	1560149351	\N	1	\N	\N
4841	272	1vkh5gh65sjwrgmtcm                                                                                                                                                                                                                                             	1560236677	\N	1	\N	\N
4843	272	1vkh5gh65sjwrgs5pq                                                                                                                                                                                                                                             	1560236926	\N	1	\N	\N
4735	272	1vkh5ghfwojwn4yn7u                                                                                                                                                                                                                                             	1559975209	\N	1	\N	\N
4857	272	1vkh5gh65sjwrhlrpr                                                                                                                                                                                                                                             	1560238308	\N	1	\N	\N
4515	272	1vkh5gh3kgjwj5n26d                                                                                                                                                                                                                                             	1559734483	\N	1	\N	\N
4517	272	1vkh5gh3kgjwj5zqbb                                                                                                                                                                                                                                             	1559735075	\N	1	\N	\N
4518	272	1vkh5gh3kgjwj60mip                                                                                                                                                                                                                                             	1559735116	\N	1	\N	\N
4443	272	1vkh5ghahgjwhnjae5                                                                                                                                                                                                                                             	1559643608	\N	1	\N	\N
4344	272	1vkh5ghb54jw0af061                                                                                                                                                                                                                                             	1558593648	\N	1	\N	\N
4267	272	1vkh5gh1s4jvz61fq0                                                                                                                                                                                                                                             	1558525831	\N	1	\N	\N
4268	272	1vkh5gh1s4jvz6ard2                                                                                                                                                                                                                                             	1558526266	\N	1	\N	\N
4405	272	1vkh5gh4nsjw66p0zo                                                                                                                                                                                                                                             	1558950195	\N	1	\N	\N
4430	272	1vkh5ghahgjwhhxhn4                                                                                                                                                                                                                                             	1559634193	\N	1	\N	\N
4431	272	1vkh5ghahgjwhi0eyn                                                                                                                                                                                                                                             	1559634330	\N	1	\N	\N
4445	272	1vkh5ghahgjwhnom3u                                                                                                                                                                                                                                             	1559643857	\N	1	\N	\N
4455	272	1vkh5ghahgjwhq1j5z                                                                                                                                                                                                                                             	1559647819	\N	1	\N	\N
4506	272	1vkh5gh3kgjwj4456k                                                                                                                                                                                                                                             	1559731921	\N	1	\N	\N
4507	272	1vkh5gh3kgjwj488hx                                                                                                                                                                                                                                             	1559732112	\N	1	\N	\N
4970	275	1vkh5ghgn0jwuas9to                                                                                                                                                                                                                                             	1560408253	\N	1	\N	\N
4921	275	1vkh5gh784jwsvxpvb                                                                                                                                                                                                                                             	1560322846	\N	1	\N	\N
4804	297	1vkh5ghjmojwq0ph91                                                                                                                                                                                                                                             	1560149461	\N	1	\N	\N
4880	275	1vkh5gh65sjwrq8ajo                                                                                                                                                                                                                                             	1560252796	\N	1	\N	\N
4875	275	1vkh5gh65sjwrpoc5k                                                                                                                                                                                                                                             	1560251865	\N	1	\N	\N
4331	275	1vkh5ghb54jw095xhe                                                                                                                                                                                                                                             	1558591545	\N	1	\N	\N
4842	272	1vkh5gh65sjwrgoxub                                                                                                                                                                                                                                             	1560236776	\N	1	\N	\N
4598	272	1vkh5ghc9sjwk9fnpd                                                                                                                                                                                                                                             	1559801323	\N	1	\N	\N
4419	272	1vkh5ghahgjwhh7m4l                                                                                                                                                                                                                                             	1559632986	\N	1	\N	\N
4938	272	1vkh5gh784jwsy227u                                                                                                                                                                                                                                             	1560326408	\N	1	\N	\N
4900	272	1vkh5ghdywjwssvvoa                                                                                                                                                                                                                                             	1560317722	\N	1	\N	\N
4423	272	1vkh5ghahgjwhhja8i                                                                                                                                                                                                                                             	1559633530	\N	1	\N	\N
4390	272	1vkh5ghdk0jw1nsv5u                                                                                                                                                                                                                                             	1558676596	\N	1	\N	\N
4395	272	1vkh5ghdk0jw1o99zg                                                                                                                                                                                                                                             	1558677362	\N	1	\N	\N
4352	272	1vkh5ghb54jw0aw8zn                                                                                                                                                                                                                                             	1558594453	\N	1	\N	\N
4512	272	1vkh5gh3kgjwj594sn                                                                                                                                                                                                                                             	1559733834	\N	1	\N	\N
4514	272	1vkh5gh3kgjwj5k723                                                                                                                                                                                                                                             	1559734350	\N	1	\N	\N
4318	272	1vkh5ghb54jw06em8u                                                                                                                                                                                                                                             	1558586912	\N	1	\N	\N
4519	272	1vkh5gh3kgjwj62kvt                                                                                                                                                                                                                                             	1559735207	\N	1	\N	\N
4457	272	1vkh5ghahgjwhqcj41                                                                                                                                                                                                                                             	1559648332	\N	1	\N	\N
4464	272	1vkh5ghahgjwhsckg5                                                                                                                                                                                                                                             	1559651693	\N	1	\N	\N
4858	272	1vkh5gh65sjwrhn3wf                                                                                                                                                                                                                                             	1560238370	\N	1	\N	\N
4436	272	1vkh5ghahgjwhkc5nt                                                                                                                                                                                                                                             	1559638237	\N	1	\N	\N
4448	272	1vkh5ghahgjwho7tew                                                                                                                                                                                                                                             	1559644753	\N	1	\N	\N
4388	272	1vkh5ghdk0jw1m4dfn                                                                                                                                                                                                                                             	1558673774	\N	1	\N	\N
4417	272	1vkh5ghahgjwhfi988                                                                                                                                                                                                                                             	1559630123	\N	1	\N	\N
4922	275	1vkh5gh784jwsw2uto                                                                                                                                                                                                                                             	1560323086	\N	1	\N	\N
4881	275	1vkh5gh65sjwrq9cch                                                                                                                                                                                                                                             	1560252845	\N	1	\N	\N
4332	275	1vkh5ghb54jw0960rd                                                                                                                                                                                                                                             	1558591550	\N	1	\N	\N
4333	275	1vkh5ghb54jw097jg4                                                                                                                                                                                                                                             	1558591620	\N	1	\N	\N
4844	272	1vkh5gh65sjwrgvalf                                                                                                                                                                                                                                             	1560237073	\N	1	\N	\N
4737	272	1vkh5ghfwojwn534ca                                                                                                                                                                                                                                             	1559975418	\N	1	\N	\N
4418	272	1vkh5ghahgjwhh1nua                                                                                                                                                                                                                                             	1559632708	\N	1	\N	\N
4420	272	1vkh5ghahgjwhh861f                                                                                                                                                                                                                                             	1559633012	\N	1	\N	\N
4235	272	1vkh5gha4cjvxsgcch                                                                                                                                                                                                                                             	1558442545	\N	1	\N	\N
4242	272	1vkh5gh3vcjvz3ujnr                                                                                                                                                                                                                                             	1558522150	\N	1	\N	\N
4243	272	1vkh5gh3vcjvz3uqk3                                                                                                                                                                                                                                             	1558522159	\N	1	\N	\N
4247	272	1vkh5gh69wjvz48osk                                                                                                                                                                                                                                             	1558522810	\N	1	\N	\N
4248	272	1vkh5gh69wjvz48rfo                                                                                                                                                                                                                                             	1558522813	\N	1	\N	\N
4939	272	1vkh5gh784jwsy3sov                                                                                                                                                                                                                                             	1560326489	\N	1	\N	\N
4751	272	1vkh5ghfwojwn7f9km                                                                                                                                                                                                                                             	1559979344	\N	1	\N	\N
4520	272	1vkh5gh3kgjwj63k5b                                                                                                                                                                                                                                             	1559735253	\N	1	\N	\N
4343	272	1vkh5ghb54jw0aevea                                                                                                                                                                                                                                             	1558593642	\N	1	\N	\N
4410	272	1vkh5gh4nsjw67avpx                                                                                                                                                                                                                                             	1558951214	\N	1	\N	\N
4236	272	1vkh5gh69sjvyt9rug                                                                                                                                                                                                                                             	1558504385	\N	1	\N	\N
4250	272	1vkh5gh69wjvz4ddk6                                                                                                                                                                                                                                             	1558523028	\N	1	\N	\N
4462	272	1vkh5ghahgjwhs6m6l                                                                                                                                                                                                                                             	1559651415	\N	1	\N	\N
4466	272	1vkh5ghahgjwht3kjz                                                                                                                                                                                                                                             	1559652953	\N	1	\N	\N
4923	275	1vkh5gh784jwsw4c50                                                                                                                                                                                                                                             	1560323155	\N	1	\N	\N
4882	275	1vkh5gh65sjwrqa9yr                                                                                                                                                                                                                                             	1560252888	\N	1	\N	\N
4883	275	1vkh5gh65sjwrqbmuj                                                                                                                                                                                                                                             	1560252952	\N	1	\N	\N
4407	275	1vkh5gh4nsjw66pe2k                                                                                                                                                                                                                                             	1558950211	\N	1	\N	\N
4916	275	1vkh5gh784jwsvonyz                                                                                                                                                                                                                                             	1560322424	\N	1	\N	\N
4926	272	1vkh5gh784jwswrxx2                                                                                                                                                                                                                                             	1560324256	\N	1	\N	\N
4927	272	1vkh5gh784jwsws0wy                                                                                                                                                                                                                                             	1560324260	\N	1	\N	\N
4845	272	1vkh5gh65sjwrgwsbx                                                                                                                                                                                                                                             	1560237142	\N	1	\N	\N
4738	272	1vkh5ghfwojwn552px                                                                                                                                                                                                                                             	1559975509	\N	1	\N	\N
4468	272	1vkh5ghahgjwht7hlv                                                                                                                                                                                                                                             	1559653135	\N	1	\N	\N
4470	272	1vkh5ghahgjwhtlht7                                                                                                                                                                                                                                             	1559653789	\N	1	\N	\N
4472	272	1vkh5ghahgjwhtr8al                                                                                                                                                                                                                                             	1559654056	\N	1	\N	\N
4473	272	1vkh5ghahgjwhtsmrp                                                                                                                                                                                                                                             	1559654122	\N	1	\N	\N
4474	272	1vkh5ghahgjwhtwxic                                                                                                                                                                                                                                             	1559654322	\N	1	\N	\N
4476	272	1vkh5ghahgjwhu5obx                                                                                                                                                                                                                                             	1559654730	\N	1	\N	\N
4478	272	1vkh5ghahgjwhuyqjp                                                                                                                                                                                                                                             	1559656086	\N	1	\N	\N
4859	272	1vkh5gh65sjwrhnwjf                                                                                                                                                                                                                                             	1560238408	\N	1	\N	\N
4355	272	1vkh5ghb54jw0b2x7o                                                                                                                                                                                                                                             	1558594764	\N	1	\N	\N
4437	272	1vkh5ghahgjwhkx39q                                                                                                                                                                                                                                             	1559639213	\N	1	\N	\N
4742	272	1vkh5ghfwojwn5fkwo                                                                                                                                                                                                                                             	1559975999	\N	1	\N	\N
4775	272	1vkh5ghfwojwncsfq4                                                                                                                                                                                                                                             	1559988356	\N	1	\N	\N
4776	272	1vkh5ghfwojwncudoi                                                                                                                                                                                                                                             	1559988447	\N	1	\N	\N
4940	272	1vkh5gh784jwsy4dl6                                                                                                                                                                                                                                             	1560326516	\N	1	\N	\N
4924	275	1vkh5gh784jwsw5gdk                                                                                                                                                                                                                                             	1560323207	\N	1	\N	\N
4884	275	1vkh5gh65sjwrqdb0o                                                                                                                                                                                                                                             	1560253030	\N	1	\N	\N
4917	275	1vkh5gh784jwsvq9q6                                                                                                                                                                                                                                             	1560322499	\N	1	\N	\N
4346	275	1vkh5ghb54jw0agmmb                                                                                                                                                                                                                                             	1558593724	\N	1	\N	\N
4347	275	1vkh5ghb54jw0akmdr                                                                                                                                                                                                                                             	1558593910	\N	1	\N	\N
4337	275	1vkh5ghb54jw09a5p0                                                                                                                                                                                                                                             	1558591743	\N	1	\N	\N
4846	272	1vkh5gh65sjwrgy1q9                                                                                                                                                                                                                                             	1560237201	\N	1	\N	\N
4847	272	1vkh5gh65sjwrgz96h                                                                                                                                                                                                                                             	1560237258	\N	1	\N	\N
4849	272	1vkh5gh65sjwrh2nh3                                                                                                                                                                                                                                             	1560237416	\N	1	\N	\N
4739	272	1vkh5ghfwojwn57kle                                                                                                                                                                                                                                             	1559975625	\N	1	\N	\N
4741	272	1vkh5ghfwojwn5ckkg                                                                                                                                                                                                                                             	1559975859	\N	1	\N	\N
4731	272	1vkh5ghfwojwn4jyv8                                                                                                                                                                                                                                             	1559974524	\N	1	\N	\N
4777	272	1vkh5ghfwojwncvq6p                                                                                                                                                                                                                                             	1559988510	\N	1	\N	\N
4779	272	1vkh5ghfwojwnd8kt8                                                                                                                                                                                                                                             	1559989109	\N	1	\N	\N
4449	272	1vkh5ghahgjwhootk9                                                                                                                                                                                                                                             	1559645546	\N	1	\N	\N
4458	272	1vkh5ghahgjwhqihz7                                                                                                                                                                                                                                             	1559648610	\N	1	\N	\N
4438	272	1vkh5ghahgjwhl149a                                                                                                                                                                                                                                             	1559639401	\N	1	\N	\N
4450	272	1vkh5ghahgjwhotoxb                                                                                                                                                                                                                                             	1559645773	\N	1	\N	\N
4459	272	1vkh5ghahgjwhqsufk                                                                                                                                                                                                                                             	1559649093	\N	1	\N	\N
4460	272	1vkh5ghahgjwhqzfrt                                                                                                                                                                                                                                             	1559649400	\N	1	\N	\N
4322	272	1vkh5ghb54jw07wdqq                                                                                                                                                                                                                                             	1558589420	\N	1	\N	\N
4421	272	1vkh5ghahgjwhh9l0y                                                                                                                                                                                                                                             	1559633078	\N	1	\N	\N
4439	272	1vkh5ghahgjwhmk0sl                                                                                                                                                                                                                                             	1559641963	\N	1	\N	\N
4925	275	1vkh5gh784jwswah1j                                                                                                                                                                                                                                             	1560323441	\N	1	\N	\N
4885	275	1vkh5gh65sjwrqepzo                                                                                                                                                                                                                                             	1560253096	\N	1	\N	\N
4412	275	1vkh5gh4nsjw67bsg6                                                                                                                                                                                                                                             	1558951257	\N	1	\N	\N
4864	275	1vkh5gh65sjwrpa7yt                                                                                                                                                                                                                                             	1560251206	\N	1	\N	\N
4868	275	1vkh5gh65sjwrpdmpc                                                                                                                                                                                                                                             	1560251365	\N	1	\N	\N
4869	275	1vkh5gh65sjwrpeqcl                                                                                                                                                                                                                                             	1560251417	\N	1	\N	\N
4886	275	1vkh5gh65sjwrqi6b7                                                                                                                                                                                                                                             	1560253257	\N	1	\N	\N
4928	272	1vkh5gh784jwswxeyo                                                                                                                                                                                                                                             	1560324512	\N	1	\N	\N
4848	272	1vkh5gh65sjwrh0npo                                                                                                                                                                                                                                             	1560237323	\N	1	\N	\N
4850	272	1vkh5gh65sjwrh56pl                                                                                                                                                                                                                                             	1560237534	\N	1	\N	\N
4740	272	1vkh5ghfwojwn59q0o                                                                                                                                                                                                                                             	1559975726	\N	1	\N	\N
4442	272	1vkh5ghahgjwhncv09                                                                                                                                                                                                                                             	1559643308	\N	1	\N	\N
4422	272	1vkh5ghahgjwhhf3n9                                                                                                                                                                                                                                             	1559633335	\N	1	\N	\N
4440	272	1vkh5ghahgjwhn9odg                                                                                                                                                                                                                                             	1559643160	\N	1	\N	\N
4441	272	1vkh5ghahgjwhnal79                                                                                                                                                                                                                                             	1559643202	\N	1	\N	\N
4451	272	1vkh5ghahgjwhows6p                                                                                                                                                                                                                                             	1559645917	\N	1	\N	\N
4378	272	1vkh5ghdk0jw0j33it                                                                                                                                                                                                                                             	1558608209	\N	1	\N	\N
4379	272	1vkh5ghdk0jw0j372c                                                                                                                                                                                                                                             	1558608214	\N	1	\N	\N
4778	272	1vkh5ghfwojwnd7xjm                                                                                                                                                                                                                                             	1559989079	\N	1	\N	\N
4529	272	1vkh5gh3kgjwj6kup0                                                                                                                                                                                                                                             	1559736060	\N	1	\N	\N
4860	272	1vkh5gh65sjwrhqzs5                                                                                                                                                                                                                                             	1560238552	\N	1	\N	\N
4530	272	1vkh5gh3kgjwj6kylq                                                                                                                                                                                                                                             	1559736065	\N	1	\N	\N
4941	272	1vkh5gh784jwt00ia0                                                                                                                                                                                                                                             	1560329695	\N	1	\N	\N
4759	272	1vkh5ghfwojwn8k8is                                                                                                                                                                                                                                             	1559981255	\N	1	\N	\N
4760	272	1vkh5ghfwojwn8li99                                                                                                                                                                                                                                             	1559981314	\N	1	\N	\N
4498	272	1vkh5gh3kgjwixrn8e                                                                                                                                                                                                                                             	1559721260	\N	1	\N	\N
4319	272	1vkh5ghb54jw07m2ao                                                                                                                                                                                                                                             	1558588939	\N	1	\N	\N
4887	275	1vkh5gh65sjwrqjeql                                                                                                                                                                                                                                             	1560253314	\N	1	\N	\N
4971	272	1vkh5ghgn0jwuauczd                                                                                                                                                                                                                                             	1560408350	\N	0	\N	\N
4929	272	1vkh5gh784jwsx71dg                                                                                                                                                                                                                                             	1560324961	\N	1	\N	\N
4851	272	1vkh5gh65sjwrh6ydo                                                                                                                                                                                                                                             	1560237617	\N	1	\N	\N
4637	272	1vkh5gh1asjwkfeban                                                                                                                                                                                                                                             	1559811338	\N	1	\N	\N
4652	272	1vkh5gh4n0jwlr4n5s                                                                                                                                                                                                                                             	1559891508	\N	1	\N	\N
4557	272	1vkh5gh3kgjwj9znca                                                                                                                                                                                                                                             	1559741789	\N	1	\N	\N
4406	272	1vkh5gh4nsjw66p36y                                                                                                                                                                                                                                             	1558950197	\N	1	\N	\N
4428	272	1vkh5ghahgjwhhue7t                                                                                                                                                                                                                                             	1559634049	\N	1	\N	\N
4429	272	1vkh5ghahgjwhhvo50                                                                                                                                                                                                                                             	1559634108	\N	1	\N	\N
4351	272	1vkh5ghb54jw0aw60g                                                                                                                                                                                                                                             	1558594449	\N	1	\N	\N
4453	272	1vkh5ghahgjwhpecdz                                                                                                                                                                                                                                             	1559646737	\N	1	\N	\N
4461	272	1vkh5ghahgjwhs0avf                                                                                                                                                                                                                                             	1559651120	\N	1	\N	\N
4465	272	1vkh5ghahgjwhsgb5t                                                                                                                                                                                                                                             	1559651867	\N	1	\N	\N
4452	272	1vkh5ghahgjwhp0g5b                                                                                                                                                                                                                                             	1559646088	\N	1	\N	\N
4454	272	1vkh5ghahgjwhpjypc                                                                                                                                                                                                                                             	1559646999	\N	1	\N	\N
4745	272	1vkh5ghfwojwn6w4jo                                                                                                                                                                                                                                             	1559978451	\N	1	\N	\N
4780	272	1vkh5ghfwojwndakhm                                                                                                                                                                                                                                             	1559989202	\N	1	\N	\N
4433	272	1vkh5ghahgjwhi9imf                                                                                                                                                                                                                                             	1559634754	\N	1	\N	\N
4373	272	1vkh5ghfeojw0g1pbq                                                                                                                                                                                                                                             	1558603105	\N	1	\N	\N
4888	275	1vkh5gh65sjwrqlyun                                                                                                                                                                                                                                             	1560253434	\N	1	\N	\N
4806	297	1vkh5ghjmojwq0tb6k                                                                                                                                                                                                                                             	1560149640	\N	1	\N	\N
4807	297	1vkh5ghjmojwq0uudb                                                                                                                                                                                                                                             	1560149712	\N	1	\N	\N
4972	272	1vkh5ghgn0jwuauhik                                                                                                                                                                                                                                             	1560408356	\N	0	\N	\N
4930	272	1vkh5gh784jwsxoj9z                                                                                                                                                                                                                                             	1560325777	\N	1	\N	\N
4933	272	1vkh5gh784jwsxsc6p                                                                                                                                                                                                                                             	1560325954	\N	1	\N	\N
4852	272	1vkh5gh65sjwrh8sw9                                                                                                                                                                                                                                             	1560237703	\N	1	\N	\N
4680	272	1vkh5ghbr8jwlx8thv                                                                                                                                                                                                                                             	1559901781	\N	1	\N	\N
4693	272	1vkh5ghbr8jwlxuma2                                                                                                                                                                                                                                             	1559902798	\N	1	\N	\N
4694	272	1vkh5ghbr8jwlyuvzn                                                                                                                                                                                                                                             	1559904490	\N	1	\N	\N
4736	272	1vkh5ghfwojwn513lt                                                                                                                                                                                                                                             	1559975324	\N	1	\N	\N
4293	272	1vkh5gh1s4jvza2g4x                                                                                                                                                                                                                                             	1558532596	\N	1	\N	\N
4367	272	1vkh5ghfeojw0d3dga                                                                                                                                                                                                                                             	1558598144	\N	1	\N	\N
4338	272	1vkh5ghb54jw09b3hq                                                                                                                                                                                                                                             	1558591786	\N	1	\N	\N
4531	272	1vkh5gh3kgjwj6lk1t                                                                                                                                                                                                                                             	1559736093	\N	1	\N	\N
4942	272	1vkh5gh784jwt02dn7                                                                                                                                                                                                                                             	1560329782	\N	1	\N	\N
4889	275	1vkh5gh65sjwrqp9wq                                                                                                                                                                                                                                             	1560253588	\N	1	\N	\N
4890	275	1vkh5gh65sjwrqsxsx                                                                                                                                                                                                                                             	1560253759	\N	1	\N	\N
4809	297	1vkh5ghjmojwq2hmgb                                                                                                                                                                                                                                             	1560152454	\N	1	\N	\N
4943	272	1vkh5gh784jwt06qmu                                                                                                                                                                                                                                             	1560329986	\N	1	\N	\N
4828	272	1vkh5gh65sjwresebp                                                                                                                                                                                                                                             	1560233578	\N	1	\N	\N
4931	272	1vkh5gh784jwsxqre7                                                                                                                                                                                                                                             	1560325881	\N	1	\N	\N
4853	272	1vkh5gh65sjwrhaq7s                                                                                                                                                                                                                                             	1560237793	\N	1	\N	\N
4705	272	1vkh5ghbr8jwm58i1r                                                                                                                                                                                                                                             	1559915203	\N	1	\N	\N
4713	272	1vkh5ghbr8jwm63srk                                                                                                                                                                                                                                             	1559916663	\N	1	\N	\N
4719	272	1vkh5ghjf4jwn2wuqr                                                                                                                                                                                                                                             	1559971766	\N	1	\N	\N
4547	272	1vkh5gh3kgjwj9cbdh                                                                                                                                                                                                                                             	1559740701	\N	1	\N	\N
4548	272	1vkh5gh3kgjwj9diun                                                                                                                                                                                                                                             	1559740757	\N	1	\N	\N
4725	272	1vkh5ghjf4jwn3cy2q                                                                                                                                                                                                                                             	1559972517	\N	1	\N	\N
4261	272	1vkh5gh1s4jvz5khzj                                                                                                                                                                                                                                             	1558525040	\N	1	\N	\N
4262	272	1vkh5gh1s4jvz5qt86                                                                                                                                                                                                                                             	1558525335	\N	1	\N	\N
4360	272	1vkh5ghb54jw0bnehl                                                                                                                                                                                                                                             	1558595720	\N	1	\N	\N
4374	272	1vkh5ghfeojw0g891g                                                                                                                                                                                                                                             	1558603411	\N	1	\N	\N
4425	272	1vkh5ghahgjwhhmrn5                                                                                                                                                                                                                                             	1559633693	\N	1	\N	\N
4320	272	1vkh5ghb54jw07qr05                                                                                                                                                                                                                                             	1558589157	\N	1	\N	\N
4891	275	1vkh5ghdywjwsrbf0t                                                                                                                                                                                                                                             	1560315087	\N	1	\N	\N
4810	297	1vkh5ghjmojwq2rnn3                                                                                                                                                                                                                                             	1560152922	\N	1	\N	\N
4811	297	1vkh5ghjmojwq2t017                                                                                                                                                                                                                                             	1560152985	\N	1	\N	\N
4815	272	1vkh5gh65sjwrdc0h8                                                                                                                                                                                                                                             	1560231134	\N	1	\N	\N
4527	271	1vkh5gh3kgjwj6jd9x                                                                                                                                                                                                                                             	1559735991	\N	1	\N	\N
4528	271	1vkh5gh3kgjwj6jgpc                                                                                                                                                                                                                                             	1559735995	\N	1	\N	\N
4932	272	1vkh5gh784jwsxrxsw                                                                                                                                                                                                                                             	1560325936	\N	1	\N	\N
4854	272	1vkh5gh65sjwrhbxvx                                                                                                                                                                                                                                             	1560237849	\N	1	\N	\N
4816	272	1vkh5gh65sjwrds2uk                                                                                                                                                                                                                                             	1560231884	\N	1	\N	\N
4817	272	1vkh5gh65sjwrdt8vq                                                                                                                                                                                                                                             	1560231938	\N	1	\N	\N
4513	272	1vkh5gh3kgjwj5iado                                                                                                                                                                                                                                             	1559734261	\N	1	\N	\N
4818	272	1vkh5gh65sjwrdwzyv                                                                                                                                                                                                                                             	1560232113	\N	1	\N	\N
4289	272	1vkh5gh1s4jvz9d4gv                                                                                                                                                                                                                                             	1558531415	\N	1	\N	\N
4819	272	1vkh5gh65sjwre0j58                                                                                                                                                                                                                                             	1560232278	\N	1	\N	\N
4823	275	1vkh5gh65sjwrel182                                                                                                                                                                                                                                             	1560233235	\N	1	\N	\N
4385	275	1vkh5ghdk0jw1m2x2j                                                                                                                                                                                                                                             	1558673706	\N	1	\N	\N
4345	275	1vkh5ghb54jw0agi5t                                                                                                                                                                                                                                             	1558593718	\N	1	\N	\N
4336	275	1vkh5ghb54jw09a2tb                                                                                                                                                                                                                                             	1558591739	\N	1	\N	\N
4353	275	1vkh5ghb54jw0axb8u                                                                                                                                                                                                                                             	1558594502	\N	1	\N	\N
4411	275	1vkh5gh4nsjw67bpwa                                                                                                                                                                                                                                             	1558951253	\N	1	\N	\N
4863	275	1vkh5gh65sjwrp0wk1                                                                                                                                                                                                                                             	1560250771	\N	1	\N	\N
4865	275	1vkh5gh65sjwrpb4p8                                                                                                                                                                                                                                             	1560251249	\N	1	\N	\N
4867	275	1vkh5gh65sjwrpcrzm                                                                                                                                                                                                                                             	1560251325	\N	1	\N	\N
4812	297	1vkh5gh6bgjwq590of                                                                                                                                                                                                                                             	1560157092	\N	1	\N	\N
4892	297	1vkh5ghdywjwss0tze                                                                                                                                                                                                                                             	1560316273	\N	1	\N	\N
4893	297	1vkh5ghdywjwss0xms                                                                                                                                                                                                                                             	1560316278	\N	1	\N	\N
4934	272	1vkh5gh784jwsxuc5i                                                                                                                                                                                                                                             	1560326048	\N	1	\N	\N
4650	272	1vkh5gh4n0jwlqxlcl                                                                                                                                                                                                                                             	1559891179	\N	1	\N	\N
4651	272	1vkh5gh4n0jwlqz7cn                                                                                                                                                                                                                                             	1559891254	\N	1	\N	\N
4667	272	1vkh5ghbr8jwlvapu9                                                                                                                                                                                                                                             	1559898510	\N	1	\N	\N
4679	272	1vkh5ghbr8jwlx53vr                                                                                                                                                                                                                                             	1559901607	\N	1	\N	\N
4683	272	1vkh5ghbr8jwlxc81c                                                                                                                                                                                                                                             	1559901939	\N	1	\N	\N
4571	272	1vkh5ghc9sjwk7832e                                                                                                                                                                                                                                             	1559797610	\N	1	\N	\N
4600	272	1vkh5ghc9sjwk9lem1                                                                                                                                                                                                                                             	1559801591	\N	1	\N	\N
4619	272	1vkh5gh1g8jwkc7ndw                                                                                                                                                                                                                                             	1559805988	\N	1	\N	\N
4638	272	1vkh5gh1asjwkg8ysv                                                                                                                                                                                                                                             	1559812768	\N	1	\N	\N
4786	297	1vkh5ghjmojwpyu45e                                                                                                                                                                                                                                             	1560146318	\N	1	\N	\N
4787	297	1vkh5ghjmojwpyx4us                                                                                                                                                                                                                                             	1560146459	\N	1	\N	\N
4788	297	1vkh5ghjmojwpyze3n                                                                                                                                                                                                                                             	1560146565	\N	1	\N	\N
4791	297	1vkh5ghjmojwpz42er                                                                                                                                                                                                                                             	1560146783	\N	1	\N	\N
4789	297	1vkh5ghjmojwpz0k81                                                                                                                                                                                                                                             	1560146619	\N	1	\N	\N
4792	297	1vkh5ghjmojwpzixrc                                                                                                                                                                                                                                             	1560147477	\N	1	\N	\N
4794	297	1vkh5ghjmojwpzxiua                                                                                                                                                                                                                                             	1560148157	\N	1	\N	\N
4795	297	1vkh5ghjmojwq0d48l                                                                                                                                                                                                                                             	1560148885	\N	1	\N	\N
4796	297	1vkh5ghjmojwq0ddtl                                                                                                                                                                                                                                             	1560148897	\N	1	\N	\N
4797	297	1vkh5ghjmojwq0do1v                                                                                                                                                                                                                                             	1560148910	\N	1	\N	\N
4805	297	1vkh5ghjmojwq0s2lv                                                                                                                                                                                                                                             	1560149582	\N	1	\N	\N
4808	297	1vkh5ghjmojwq2hho7                                                                                                                                                                                                                                             	1560152448	\N	1	\N	\N
4813	297	1vkh5ghdewjwq9nd2y                                                                                                                                                                                                                                             	1560164479	\N	1	\N	\N
4935	272	1vkh5gh784jwsxvs57                                                                                                                                                                                                                                             	1560326115	\N	1	\N	\N
4290	272	1vkh5gh1s4jvz9fifh                                                                                                                                                                                                                                             	1558531526	\N	1	\N	\N
4269	272	1vkh5gh1s4jvz6bsjh                                                                                                                                                                                                                                             	1558526314	\N	1	\N	\N
4291	272	1vkh5gh1s4jvz9n09b                                                                                                                                                                                                                                             	1558531876	\N	1	\N	\N
4292	272	1vkh5gh1s4jvz9u9gr                                                                                                                                                                                                                                             	1558532214	\N	1	\N	\N
4397	272	1vkh5ghdk0jw1ot9h8                                                                                                                                                                                                                                             	1558678294	\N	1	\N	\N
4358	272	1vkh5ghb54jw0b9j7a                                                                                                                                                                                                                                             	1558595073	\N	1	\N	\N
4541	272	1vkh5gh3kgjwj8lxl2                                                                                                                                                                                                                                             	1559739470	\N	1	\N	\N
4295	272	1vkh5gh1s4jvzbbfra                                                                                                                                                                                                                                             	1558534695	\N	1	\N	\N
4523	272	1vkh5gh3kgjwj68yud                                                                                                                                                                                                                                             	1559735506	\N	1	\N	\N
4215	272	1vkh5ghbu4jvw9kfi3                                                                                                                                                                                                                                             	1558350357	\N	1	\N	\N
4944	272	1vkh5gh784jwt0mhb3                                                                                                                                                                                                                                             	1560330720	\N	1	\N	\N
4896	272	1vkh5ghdywjwss6m9n                                                                                                                                                                                                                                             	1560316543	\N	1	\N	\N
4897	272	1vkh5ghdywjwss94bi                                                                                                                                                                                                                                             	1560316660	\N	1	\N	\N
4899	272	1vkh5ghdywjwssns1i                                                                                                                                                                                                                                             	1560317344	\N	1	\N	\N
4901	272	1vkh5ghdywjwsswtj2                                                                                                                                                                                                                                             	1560317766	\N	1	\N	\N
4903	272	1vkh5ghdywjwssydc1                                                                                                                                                                                                                                             	1560317838	\N	1	\N	\N
4902	272	1vkh5ghdywjwssxw24                                                                                                                                                                                                                                             	1560317815	\N	1	\N	\N
4904	272	1vkh5ghdywjwst25h2                                                                                                                                                                                                                                             	1560318014	\N	1	\N	\N
4542	272	1vkh5gh3kgjwj8nsbz                                                                                                                                                                                                                                             	1559739556	\N	1	\N	\N
4400	272	1vkh5gh4nsjw65zg01                                                                                                                                                                                                                                             	1558949001	\N	1	\N	\N
4581	272	1vkh5ghc9sjwk84xgp                                                                                                                                                                                                                                             	1559799143	\N	1	\N	\N
4534	272	1vkh5gh3kgjwj7f2b5                                                                                                                                                                                                                                             	1559737470	\N	1	\N	\N
4499	272	1vkh5gh3kgjwixrtu0                                                                                                                                                                                                                                             	1559721269	\N	1	\N	\N
4401	272	1vkh5gh4nsjw663y4l                                                                                                                                                                                                                                             	1558949211	\N	1	\N	\N
4426	272	1vkh5ghahgjwhhoh5n                                                                                                                                                                                                                                             	1559633773	\N	1	\N	\N
4427	272	1vkh5ghahgjwhhqs24                                                                                                                                                                                                                                             	1559633880	\N	1	\N	\N
4444	272	1vkh5ghahgjwhnml3s                                                                                                                                                                                                                                             	1559643762	\N	1	\N	\N
4357	272	1vkh5ghb54jw0b7waj                                                                                                                                                                                                                                             	1558594996	\N	1	\N	\N
4368	272	1vkh5ghfeojw0f89mw                                                                                                                                                                                                                                             	1558601732	\N	1	\N	\N
4369	272	1vkh5ghfeojw0ffls3                                                                                                                                                                                                                                             	1558602074	\N	1	\N	\N
4414	272	1vkh5ghahgjwheyb7x                                                                                                                                                                                                                                             	1559629193	\N	1	\N	\N
4415	272	1vkh5ghahgjwhfa6yu                                                                                                                                                                                                                                             	1559629747	\N	1	\N	\N
4435	272	1vkh5ghahgjwhk8nft                                                                                                                                                                                                                                             	1559638073	\N	1	\N	\N
4447	272	1vkh5ghahgjwho1n49                                                                                                                                                                                                                                             	1559644464	\N	1	\N	\N
4504	272	1vkh5gh3kgjwj3y9f9                                                                                                                                                                                                                                             	1559731647	\N	1	\N	\N
4535	272	1vkh5gh3kgjwj7ham8                                                                                                                                                                                                                                             	1559737574	\N	1	\N	\N
4559	272	1vkh5gh3kgjwjaeqli                                                                                                                                                                                                                                             	1559742493	\N	1	\N	\N
4582	272	1vkh5ghc9sjwk85qmn                                                                                                                                                                                                                                             	1559799180	\N	1	\N	\N
4583	272	1vkh5ghc9sjwk86nfh                                                                                                                                                                                                                                             	1559799223	\N	1	\N	\N
4216	272	1vkh5ghbu4jvw9kiv5                                                                                                                                                                                                                                             	1558350361	\N	1	\N	\N
4200	272	1vkh5gh99gjvvyluy6                                                                                                                                                                                                                                             	1558331948	\N	1	\N	\N
4201	272	1vkh5gh99gjvvylx6l                                                                                                                                                                                                                                             	1558331951	\N	1	\N	\N
4204	272	1vkh5gh99gjvw4xcnw                                                                                                                                                                                                                                             	1558342562	\N	1	\N	\N
4734	272	1vkh5ghfwojwn4voa3                                                                                                                                                                                                                                             	1559975070	\N	1	\N	\N
4366	272	1vkh5ghfeojw0d1tsv                                                                                                                                                                                                                                             	1558598072	\N	1	\N	\N
4375	272	1vkh5ghdk0jw0itial                                                                                                                                                                                                                                             	1558607762	\N	1	\N	\N
4820	272	1vkh5gh65sjwreg9uo                                                                                                                                                                                                                                             	1560233013	\N	1	\N	\N
4821	272	1vkh5gh65sjwrehk1q                                                                                                                                                                                                                                             	1560233073	\N	1	\N	\N
4524	272	1vkh5gh3kgjwj692tz                                                                                                                                                                                                                                             	1559735511	\N	1	\N	\N
4525	272	1vkh5gh3kgjwj6c9y8                                                                                                                                                                                                                                             	1559735660	\N	1	\N	\N
4526	272	1vkh5gh3kgjwj6ghdb                                                                                                                                                                                                                                             	1559735856	\N	1	\N	\N
4456	272	1vkh5ghahgjwhq89tf                                                                                                                                                                                                                                             	1559648133	\N	1	\N	\N
4463	272	1vkh5ghahgjwhsak1k                                                                                                                                                                                                                                             	1559651599	\N	1	\N	\N
4467	272	1vkh5ghahgjwht5e40                                                                                                                                                                                                                                             	1559653038	\N	1	\N	\N
4469	272	1vkh5ghahgjwhtc8oy                                                                                                                                                                                                                                             	1559653357	\N	1	\N	\N
4471	272	1vkh5ghahgjwhtnpst                                                                                                                                                                                                                                             	1559653892	\N	1	\N	\N
4475	272	1vkh5ghahgjwhu4hb4                                                                                                                                                                                                                                             	1559654675	\N	1	\N	\N
4477	272	1vkh5ghahgjwhuwl39                                                                                                                                                                                                                                             	1559655986	\N	1	\N	\N
4479	272	1vkh5ghahgjwhuzha0                                                                                                                                                                                                                                             	1559656121	\N	1	\N	\N
4361	272	1vkh5gh93kjw0bw4dr                                                                                                                                                                                                                                             	1558596127	\N	1	\N	\N
4251	272	1vkh5gh69wjvz4giw9                                                                                                                                                                                                                                             	1558523175	\N	1	\N	\N
4274	272	1vkh5gh1s4jvz7v6iw                                                                                                                                                                                                                                             	1558528898	\N	1	\N	\N
4275	272	1vkh5gh1s4jvz8401b                                                                                                                                                                                                                                             	1558529309	\N	1	\N	\N
4296	272	1vkh5gh1s4jvzbcor5                                                                                                                                                                                                                                             	1558534754	\N	1	\N	\N
4297	272	1vkh5gh1s4jvzbgeot                                                                                                                                                                                                                                             	1558534927	\N	1	\N	\N
4766	272	1vkh5ghfwojwn909xj                                                                                                                                                                                                                                             	1559982004	\N	1	\N	\N
4298	272	1vkh5gh1s4jvzbjixq                                                                                                                                                                                                                                             	1558535073	\N	1	\N	\N
4946	275	1vkh5ghih8jwt2b5im                                                                                                                                                                                                                                             	1560333551	\N	1	\N	\N
4253	272	1vkh5gh69wjvz4po0k                                                                                                                                                                                                                                             	1558523602	\N	1	\N	\N
4256	272	1vkh5gh69wjvz4ty13                                                                                                                                                                                                                                             	1558523801	\N	1	\N	\N
4371	272	1vkh5ghfeojw0fmt5v                                                                                                                                                                                                                                             	1558602411	\N	1	\N	\N
4480	272	1vkh5ghahgjwhv07oz                                                                                                                                                                                                                                             	1559656155	\N	1	\N	\N
4822	272	1vkh5gh65sjwrejhgh                                                                                                                                                                                                                                             	1560233163	\N	1	\N	\N
4481	272	1vkh5ghahgjwhv147z                                                                                                                                                                                                                                             	1559656197	\N	1	\N	\N
4482	272	1vkh5ghahgjwhv5ciz                                                                                                                                                                                                                                             	1559656395	\N	1	\N	\N
4483	272	1vkh5gh6iojwiv7vtz                                                                                                                                                                                                                                             	1559716979	\N	1	\N	\N
4484	272	1vkh5gh6iojwiveav6                                                                                                                                                                                                                                             	1559717279	\N	1	\N	\N
4485	272	1vkh5gh6iojwivgola                                                                                                                                                                                                                                             	1559717390	\N	1	\N	\N
4362	272	1vkh5ghfeojw0byex4                                                                                                                                                                                                                                             	1558596233	\N	1	\N	\N
4205	272	1vkh5gh99gjvw4xfoq                                                                                                                                                                                                                                             	1558342566	\N	1	\N	\N
4234	272	1vkh5gha4cjvxsg9hz                                                                                                                                                                                                                                             	1558442542	\N	1	\N	\N
4249	272	1vkh5gh69wjvz4cise                                                                                                                                                                                                                                             	1558522989	\N	1	\N	\N
4329	272	1vkh5ghb54jw091x9t                                                                                                                                                                                                                                             	1558591358	\N	1	\N	\N
4266	272	1vkh5gh1s4jvz61b64                                                                                                                                                                                                                                             	1558525825	\N	1	\N	\N
4618	272	1vkh5gh4ykjwkc2ji6                                                                                                                                                                                                                                             	1559805750	\N	1	\N	\N
4363	272	1vkh5ghfeojw0csedt                                                                                                                                                                                                                                             	1558597632	\N	1	\N	\N
4364	272	1vkh5ghfeojw0d02e0                                                                                                                                                                                                                                             	1558597990	\N	1	\N	\N
4365	272	1vkh5ghfeojw0d0ks1                                                                                                                                                                                                                                             	1558598014	\N	1	\N	\N
4383	272	1vkh5ghdk0jw0jb0tn                                                                                                                                                                                                                                             	1558608579	\N	1	\N	\N
4384	272	1vkh5ghdk0jw0jbffh                                                                                                                                                                                                                                             	1558608598	\N	1	\N	\N
4409	272	1vkh5gh4nsjw67atfs                                                                                                                                                                                                                                             	1558951211	\N	1	\N	\N
4434	272	1vkh5ghahgjwhiazml                                                                                                                                                                                                                                             	1559634823	\N	1	\N	\N
4486	272	1vkh5gh6iojwivhi5b                                                                                                                                                                                                                                             	1559717428	\N	1	\N	\N
4552	272	1vkh5gh3kgjwj9p6do                                                                                                                                                                                                                                             	1559741301	\N	1	\N	\N
4574	272	1vkh5ghc9sjwk7sw1b                                                                                                                                                                                                                                             	1559798581	\N	1	\N	\N
4575	272	1vkh5ghc9sjwk7tesx                                                                                                                                                                                                                                             	1559798605	\N	1	\N	\N
4553	272	1vkh5gh3kgjwj9ruaw                                                                                                                                                                                                                                             	1559741425	\N	1	\N	\N
4554	272	1vkh5gh3kgjwj9syhq                                                                                                                                                                                                                                             	1559741477	\N	1	\N	\N
4783	272	1vkh5ghjmojwpw8ej7                                                                                                                                                                                                                                             	1560141946	\N	1	\N	\N
4324	272	1vkh5ghb54jw07zh6b                                                                                                                                                                                                                                             	1558589565	\N	1	\N	\N
4327	272	1vkh5ghb54jw08yjmy                                                                                                                                                                                                                                             	1558591201	\N	1	\N	\N
4328	272	1vkh5ghb54jw08zi3l                                                                                                                                                                                                                                             	1558591245	\N	1	\N	\N
4590	272	1vkh5ghc9sjwk8pcpi                                                                                                                                                                                                                                             	1559800095	\N	1	\N	\N
4565	272	1vkh5ghc9sjwk6v8tm                                                                                                                                                                                                                                             	1559797011	\N	1	\N	\N
4592	272	1vkh5ghc9sjwk8tbrm                                                                                                                                                                                                                                             	1559800281	\N	1	\N	\N
4769	272	1vkh5ghfwojwncdpjz                                                                                                                                                                                                                                             	1559987669	\N	1	\N	\N
4773	272	1vkh5ghfwojwncoyqn                                                                                                                                                                                                                                             	1559988194	\N	1	\N	\N
4593	272	1vkh5ghc9sjwk8vrjb                                                                                                                                                                                                                                             	1559800395	\N	1	\N	\N
4594	272	1vkh5ghc9sjwk92a67                                                                                                                                                                                                                                             	1559800699	\N	1	\N	\N
4628	272	1vkh5ghafgjwkd3o9l                                                                                                                                                                                                                                             	1559807482	\N	1	\N	\N
4646	272	1vkh5gh4n0jwlqoo96                                                                                                                                                                                                                                             	1559890763	\N	1	\N	\N
4536	272	1vkh5gh3kgjwj7lvx3                                                                                                                                                                                                                                             	1559737788	\N	1	\N	\N
4389	272	1vkh5ghdk0jw1nstl6                                                                                                                                                                                                                                             	1558676594	\N	1	\N	\N
4356	272	1vkh5ghb54jw0b30j2                                                                                                                                                                                                                                             	1558594769	\N	1	\N	\N
4560	272	1vkh5gh3kgjwjahm5r                                                                                                                                                                                                                                             	1559742627	\N	1	\N	\N
4586	272	1vkh5ghc9sjwk8blkc                                                                                                                                                                                                                                             	1559799454	\N	1	\N	\N
4607	272	1vkh5ghc9sjwkasz2u                                                                                                                                                                                                                                             	1559803624	\N	1	\N	\N
4370	272	1vkh5ghfeojw0flff7                                                                                                                                                                                                                                             	1558602346	\N	1	\N	\N
4752	272	1vkh5ghfwojwn7v7b5                                                                                                                                                                                                                                             	1559980087	\N	1	\N	\N
4252	272	1vkh5gh69wjvz4n4hr                                                                                                                                                                                                                                             	1558523483	\N	1	\N	\N
4629	272	1vkh5ghafgjwkd5mdb                                                                                                                                                                                                                                             	1559807573	\N	1	\N	\N
4647	272	1vkh5gh4n0jwlqud4o                                                                                                                                                                                                                                             	1559891028	\N	1	\N	\N
4502	272	1vkh5gh3kgjwj3eymb                                                                                                                                                                                                                                             	1559730746	\N	1	\N	\N
4945	272	1vkh5ghih8jwt29qx7                                                                                                                                                                                                                                             	1560333485	\N	1	\N	\N
4947	272	1vkh5ghih8jwt2dw3x                                                                                                                                                                                                                                             	1560333679	\N	1	\N	\N
4948	272	1vkh5ghih8jwt2e2vm                                                                                                                                                                                                                                             	1560333687	\N	1	\N	\N
4949	272	1vkh5ghih8jwt2ek3s                                                                                                                                                                                                                                             	1560333710	\N	1	\N	\N
4950	272	1vkh5ghih8jwt2gdi0                                                                                                                                                                                                                                             	1560333794	\N	1	\N	\N
4951	272	1vkh5ghih8jwt2i3od                                                                                                                                                                                                                                             	1560333875	\N	1	\N	\N
4505	272	1vkh5gh3kgjwj3zu4k                                                                                                                                                                                                                                             	1559731720	\N	1	\N	\N
4661	272	1vkh5ghbr8jwluz56m                                                                                                                                                                                                                                             	1559897970	\N	1	\N	\N
4770	272	1vkh5ghfwojwnchrqz                                                                                                                                                                                                                                             	1559987859	\N	1	\N	\N
4677	272	1vkh5ghbr8jwlx0oeh                                                                                                                                                                                                                                             	1559901401	\N	1	\N	\N
4688	272	1vkh5ghbr8jwlxl4a0                                                                                                                                                                                                                                             	1559902354	\N	1	\N	\N
4701	272	1vkh5ghbr8jwm4c0k3                                                                                                                                                                                                                                             	1559913687	\N	1	\N	\N
4537	272	1vkh5gh3kgjwj82p8x                                                                                                                                                                                                                                             	1559738572	\N	1	\N	\N
4538	272	1vkh5gh3kgjwj83q72                                                                                                                                                                                                                                             	1559738620	\N	1	\N	\N
4539	272	1vkh5gh3kgjwj8ecai                                                                                                                                                                                                                                             	1559739115	\N	1	\N	\N
4561	272	1vkh5gh3kgjwjaj9vz                                                                                                                                                                                                                                             	1559742705	\N	1	\N	\N
4587	272	1vkh5ghc9sjwk8dyhf                                                                                                                                                                                                                                             	1559799564	\N	1	\N	\N
4608	272	1vkh5ghc9sjwkaurab                                                                                                                                                                                                                                             	1559803707	\N	1	\N	\N
4609	272	1vkh5ghc9sjwkaxdxa                                                                                                                                                                                                                                             	1559803829	\N	1	\N	\N
4509	272	1vkh5gh3kgjwj504dy                                                                                                                                                                                                                                             	1559733413	\N	1	\N	\N
4510	272	1vkh5gh3kgjwj563fl                                                                                                                                                                                                                                             	1559733692	\N	1	\N	\N
4511	272	1vkh5gh3kgjwj588cr                                                                                                                                                                                                                                             	1559733792	\N	1	\N	\N
4610	272	1vkh5ghc9sjwkb1nog                                                                                                                                                                                                                                             	1559804029	\N	1	\N	\N
4394	272	1vkh5ghdk0jw1o7gh9                                                                                                                                                                                                                                             	1558677277	\N	1	\N	\N
4540	272	1vkh5gh3kgjwj8ljk9                                                                                                                                                                                                                                             	1559739451	\N	1	\N	\N
4562	272	1vkh5gh3kgjwjaks2o                                                                                                                                                                                                                                             	1559742775	\N	1	\N	\N
4611	272	1vkh5ghc9sjwkb9kkx                                                                                                                                                                                                                                             	1559804398	\N	1	\N	\N
4588	272	1vkh5ghc9sjwk8iuvq                                                                                                                                                                                                                                             	1559799792	\N	1	\N	\N
4612	272	1vkh5ghc9sjwkbeo15                                                                                                                                                                                                                                             	1559804636	\N	1	\N	\N
4771	272	1vkh5ghfwojwncmdpn                                                                                                                                                                                                                                             	1559988074	\N	1	\N	\N
4772	272	1vkh5ghfwojwncob3n                                                                                                                                                                                                                                             	1559988164	\N	1	\N	\N
4516	272	1vkh5gh3kgjwj5xkm7                                                                                                                                                                                                                                             	1559734974	\N	1	\N	\N
4396	272	1vkh5ghdk0jw1ot7tf                                                                                                                                                                                                                                             	1558678292	\N	1	\N	\N
4543	272	1vkh5gh3kgjwj8p6qb                                                                                                                                                                                                                                             	1559739621	\N	1	\N	\N
4563	272	1vkh5gh3kgjwjaqg3q                                                                                                                                                                                                                                             	1559743040	\N	1	\N	\N
4589	272	1vkh5ghc9sjwk8kgdp                                                                                                                                                                                                                                             	1559799867	\N	1	\N	\N
4285	272	1vkh5gh1s4jvz94qwv                                                                                                                                                                                                                                             	1558531024	\N	1	\N	\N
4282	272	1vkh5gh1s4jvz927nl                                                                                                                                                                                                                                             	1558530906	\N	1	\N	\N
4283	272	1vkh5gh1s4jvz92awe                                                                                                                                                                                                                                             	1558530910	\N	1	\N	\N
4630	272	1vkh5gh1asjwkdaclc                                                                                                                                                                                                                                             	1559807793	\N	1	\N	\N
4500	272	1vkh5gh3kgjwj2ivxn                                                                                                                                                                                                                                             	1559729250	\N	1	\N	\N
4501	272	1vkh5gh3kgjwj2oc38                                                                                                                                                                                                                                             	1559729504	\N	1	\N	\N
4503	272	1vkh5gh3kgjwj3wigr                                                                                                                                                                                                                                             	1559731565	\N	1	\N	\N
4774	272	1vkh5ghfwojwncr0oa                                                                                                                                                                                                                                             	1559988290	\N	1	\N	\N
4648	272	1vkh5gh4n0jwlqvcg6                                                                                                                                                                                                                                             	1559891074	\N	1	\N	\N
4613	272	1vkh5ghc9sjwkbic75                                                                                                                                                                                                                                             	1559804807	\N	1	\N	\N
4631	272	1vkh5gh1asjwkddsdv                                                                                                                                                                                                                                             	1559807954	\N	1	\N	\N
4632	272	1vkh5gh1asjwkdg0q3                                                                                                                                                                                                                                             	1559808058	\N	1	\N	\N
4564	272	1vkh5gh3kgjwjaroz0                                                                                                                                                                                                                                             	1559743098	\N	1	\N	\N
4591	272	1vkh5ghc9sjwk8s3mj                                                                                                                                                                                                                                             	1559800224	\N	1	\N	\N
4614	272	1vkh5gh484jwkbn3bb                                                                                                                                                                                                                                             	1559805029	\N	1	\N	\N
4615	272	1vkh5gh484jwkbnnba                                                                                                                                                                                                                                             	1559805055	\N	1	\N	\N
4508	272	1vkh5gh3kgjwj4b5d5                                                                                                                                                                                                                                             	1559732248	\N	1	\N	\N
4606	272	1vkh5ghc9sjwkalltt                                                                                                                                                                                                                                             	1559803280	\N	1	\N	\N
4546	272	1vkh5gh3kgjwj9aowe                                                                                                                                                                                                                                             	1559740625	\N	1	\N	\N
4633	272	1vkh5gh1asjwkdhbjw                                                                                                                                                                                                                                             	1559808119	\N	1	\N	\N
4649	272	1vkh5gh4n0jwlqwlle                                                                                                                                                                                                                                             	1559891133	\N	1	\N	\N
4662	272	1vkh5ghbr8jwlv2mtu                                                                                                                                                                                                                                             	1559898133	\N	1	\N	\N
4663	272	1vkh5ghbr8jwlv3n1h                                                                                                                                                                                                                                             	1559898180	\N	1	\N	\N
4764	272	1vkh5ghfwojwn8w67g                                                                                                                                                                                                                                             	1559981812	\N	1	\N	\N
4664	272	1vkh5ghbr8jwlv4nsb                                                                                                                                                                                                                                             	1559898227	\N	1	\N	\N
4665	272	1vkh5ghbr8jwlv8fgq                                                                                                                                                                                                                                             	1559898403	\N	1	\N	\N
4668	272	1vkh5ghbr8jwlvqtzs                                                                                                                                                                                                                                             	1559899262	\N	1	\N	\N
4666	272	1vkh5ghbr8jwlvacga                                                                                                                                                                                                                                             	1559898493	\N	1	\N	\N
4678	272	1vkh5ghbr8jwlx3uem                                                                                                                                                                                                                                             	1559901548	\N	1	\N	\N
4952	272	1vkh5ghih8jwt2uwmv                                                                                                                                                                                                                                             	1560334472	\N	1	\N	\N
4953	272	1vkh5ghih8jwt2x6wl                                                                                                                                                                                                                                             	1560334579	\N	1	\N	\N
4954	272	1vkh5ghih8jwt3k2g7                                                                                                                                                                                                                                             	1560335646	\N	1	\N	\N
4955	272	1vkh5ghih8jwt3lrax                                                                                                                                                                                                                                             	1560335725	\N	1	\N	\N
4689	272	1vkh5ghbr8jwlxnawa                                                                                                                                                                                                                                             	1559902456	\N	1	\N	\N
4861	275	1vkh5gh65sjwri4ty3                                                                                                                                                                                                                                             	1560239197	\N	1	\N	\N
4956	272	1vkh5gh8hojwt3v6i5                                                                                                                                                                                                                                             	1560336165	\N	1	\N	\N
4862	275	1vkh5gh65sjwri4xik                                                                                                                                                                                                                                             	1560239202	\N	1	\N	\N
4905	275	1vkh5ghdywjwst646a                                                                                                                                                                                                                                             	1560318199	\N	1	\N	\N
4906	275	1vkh5ghdywjwst66ix                                                                                                                                                                                                                                             	1560318202	\N	1	\N	\N
4487	272	1vkh5gh6iojwivnaob                                                                                                                                                                                                                                             	1559717698	\N	1	\N	\N
4635	272	1vkh5gh1asjwkfalea                                                                                                                                                                                                                                             	1559811164	\N	1	\N	\N
4488	272	1vkh5gh6iojwiw3dwp                                                                                                                                                                                                                                             	1559718449	\N	1	\N	\N
4257	272	1vkh5gh69wjvz4u197                                                                                                                                                                                                                                             	1558523806	\N	1	\N	\N
4258	272	1vkh5gh69wjvz52yhx                                                                                                                                                                                                                                             	1558524222	\N	1	\N	\N
4744	272	1vkh5ghfwojwn65gue                                                                                                                                                                                                                                             	1559977207	\N	1	\N	\N
4653	272	1vkh5ghbr8jwlsjvde                                                                                                                                                                                                                                             	1559893898	\N	1	\N	\N
4746	272	1vkh5ghfwojwn6z7oe                                                                                                                                                                                                                                             	1559978595	\N	1	\N	\N
4691	272	1vkh5ghbr8jwlxrjq8                                                                                                                                                                                                                                             	1559902654	\N	1	\N	\N
4692	272	1vkh5ghbr8jwlxt8v5                                                                                                                                                                                                                                             	1559902734	\N	1	\N	\N
4703	272	1vkh5ghbr8jwm50zmu                                                                                                                                                                                                                                             	1559914852	\N	1	\N	\N
4711	272	1vkh5ghbr8jwm5t01n                                                                                                                                                                                                                                             	1559916159	\N	1	\N	\N
4712	272	1vkh5ghbr8jwm5wes9                                                                                                                                                                                                                                             	1559916318	\N	1	\N	\N
4605	272	1vkh5ghc9sjwkak4i7                                                                                                                                                                                                                                             	1559803211	\N	1	\N	\N
4626	272	1vkh5gh1g8jwkcrr9e                                                                                                                                                                                                                                             	1559806926	\N	1	\N	\N
4690	272	1vkh5ghbr8jwlxo1in                                                                                                                                                                                                                                             	1559902491	\N	1	\N	\N
4702	272	1vkh5ghbr8jwm503fi                                                                                                                                                                                                                                             	1559914810	\N	1	\N	\N
4710	272	1vkh5ghbr8jwm5s38g                                                                                                                                                                                                                                             	1559916117	\N	1	\N	\N
4717	272	1vkh5ghbr8jwm6jttf                                                                                                                                                                                                                                             	1559917411	\N	1	\N	\N
4595	272	1vkh5ghc9sjwk93mmx                                                                                                                                                                                                                                             	1559800761	\N	1	\N	\N
4596	272	1vkh5ghc9sjwk9e3sz                                                                                                                                                                                                                                             	1559801250	\N	1	\N	\N
4616	272	1vkh5ghdbkjwkbq766                                                                                                                                                                                                                                             	1559805174	\N	1	\N	\N
4634	272	1vkh5gh1asjwkf898k                                                                                                                                                                                                                                             	1559811055	\N	1	\N	\N
4545	272	1vkh5gh3kgjwj8sc6r                                                                                                                                                                                                                                             	1559739769	\N	1	\N	\N
4566	272	1vkh5ghc9sjwk6y0to                                                                                                                                                                                                                                             	1559797141	\N	1	\N	\N
4568	272	1vkh5ghc9sjwk736jl                                                                                                                                                                                                                                             	1559797381	\N	1	\N	\N
4569	272	1vkh5ghc9sjwk74965                                                                                                                                                                                                                                             	1559797431	\N	1	\N	\N
4597	272	1vkh5ghc9sjwk9ep9o                                                                                                                                                                                                                                             	1559801278	\N	1	\N	\N
4768	272	1vkh5ghfwojwn97n6g                                                                                                                                                                                                                                             	1559982347	\N	1	\N	\N
4697	272	1vkh5ghbr8jwlzaw6e                                                                                                                                                                                                                                             	1559905237	\N	1	\N	\N
4700	272	1vkh5ghbr8jwm3y5xr                                                                                                                                                                                                                                             	1559913041	\N	1	\N	\N
4704	272	1vkh5ghbr8jwm52stf                                                                                                                                                                                                                                             	1559914937	\N	1	\N	\N
4743	272	1vkh5ghfwojwn5spsd                                                                                                                                                                                                                                             	1559976612	\N	1	\N	\N
4599	272	1vkh5ghc9sjwk9hogt                                                                                                                                                                                                                                             	1559801417	\N	1	\N	\N
4617	272	1vkh5ghangjwkbvn0r                                                                                                                                                                                                                                             	1559805428	\N	1	\N	\N
4721	272	1vkh5ghjf4jwn373rx                                                                                                                                                                                                                                             	1559972244	\N	1	\N	\N
4532	272	1vkh5gh3kgjwj76pxn                                                                                                                                                                                                                                             	1559737080	\N	1	\N	\N
4372	272	1vkh5ghfeojw0fzkft                                                                                                                                                                                                                                             	1558603006	\N	1	\N	\N
4323	272	1vkh5ghb54jw07xk03                                                                                                                                                                                                                                             	1558589475	\N	1	\N	\N
4432	272	1vkh5ghahgjwhi2jr2                                                                                                                                                                                                                                             	1559634429	\N	1	\N	\N
4446	272	1vkh5ghahgjwhnzwdk                                                                                                                                                                                                                                             	1559644383	\N	1	\N	\N
4326	272	1vkh5ghb54jw08p888                                                                                                                                                                                                                                             	1558590766	\N	1	\N	\N
4317	272	1vkh5ghb54jw06ejjg                                                                                                                                                                                                                                             	1558586908	\N	1	\N	\N
4747	272	1vkh5ghfwojwn712nv                                                                                                                                                                                                                                             	1559978682	\N	1	\N	\N
4624	272	1vkh5gh1g8jwkcfflo                                                                                                                                                                                                                                             	1559806351	\N	1	\N	\N
4640	272	1vkh5gh4n0jwlpw486                                                                                                                                                                                                                                             	1559889431	\N	1	\N	\N
4641	272	1vkh5gh4n0jwlpy5fo                                                                                                                                                                                                                                             	1559889526	\N	1	\N	\N
4656	272	1vkh5ghbr8jwlsugli                                                                                                                                                                                                                                             	1559894392	\N	1	\N	\N
4657	272	1vkh5ghbr8jwlsw501                                                                                                                                                                                                                                             	1559894470	\N	1	\N	\N
4658	272	1vkh5ghbr8jwlus6zx                                                                                                                                                                                                                                             	1559897646	\N	1	\N	\N
4671	272	1vkh5ghbr8jwlw4rcj                                                                                                                                                                                                                                             	1559899912	\N	1	\N	\N
4673	272	1vkh5ghbr8jwlw7iin                                                                                                                                                                                                                                             	1559900040	\N	1	\N	\N
4674	272	1vkh5ghbr8jwlwpubs                                                                                                                                                                                                                                             	1559900895	\N	1	\N	\N
4684	272	1vkh5ghbr8jwlxdt9q                                                                                                                                                                                                                                             	1559902014	\N	1	\N	\N
4696	272	1vkh5ghbr8jwlz9onm                                                                                                                                                                                                                                             	1559905180	\N	1	\N	\N
4708	272	1vkh5ghbr8jwm5phvq                                                                                                                                                                                                                                             	1559915996	\N	1	\N	\N
4715	272	1vkh5ghbr8jwm68j3i                                                                                                                                                                                                                                             	1559916884	\N	1	\N	\N
4555	272	1vkh5gh3kgjwj9urmw                                                                                                                                                                                                                                             	1559741561	\N	1	\N	\N
4577	272	1vkh5ghc9sjwk7x5xx                                                                                                                                                                                                                                             	1559798780	\N	1	\N	\N
4578	272	1vkh5ghc9sjwk7y3p6                                                                                                                                                                                                                                             	1559798824	\N	1	\N	\N
4603	272	1vkh5ghc9sjwkafup9                                                                                                                                                                                                                                             	1559803011	\N	1	\N	\N
4625	272	1vkh5gh1g8jwkcpisp                                                                                                                                                                                                                                             	1559806822	\N	1	\N	\N
4642	272	1vkh5gh4n0jwlpzk3s                                                                                                                                                                                                                                             	1559889591	\N	1	\N	\N
4643	272	1vkh5gh4n0jwlq3acn                                                                                                                                                                                                                                             	1559889765	\N	1	\N	\N
4644	272	1vkh5gh4n0jwlq64gs                                                                                                                                                                                                                                             	1559889898	\N	1	\N	\N
4659	272	1vkh5ghbr8jwluub3g                                                                                                                                                                                                                                             	1559897744	\N	1	\N	\N
4675	272	1vkh5ghbr8jwlwwely                                                                                                                                                                                                                                             	1559901201	\N	1	\N	\N
4685	272	1vkh5ghbr8jwlxezb8                                                                                                                                                                                                                                             	1559902068	\N	1	\N	\N
4686	272	1vkh5ghbr8jwlxhq1j                                                                                                                                                                                                                                             	1559902196	\N	1	\N	\N
4698	272	1vkh5ghbr8jwm3qh2g                                                                                                                                                                                                                                             	1559912682	\N	1	\N	\N
4709	272	1vkh5ghbr8jwm5q3m6                                                                                                                                                                                                                                             	1559916024	\N	1	\N	\N
4716	272	1vkh5ghbr8jwm6aq7g                                                                                                                                                                                                                                             	1559916986	\N	1	\N	\N
4330	272	1vkh5ghb54jw094c0o                                                                                                                                                                                                                                             	1558591471	\N	1	\N	\N
4206	272	1vkh5ghbscjvw7rfhz                                                                                                                                                                                                                                             	1558347324	\N	1	\N	\N
4207	272	1vkh5ghbscjvw7rhr7                                                                                                                                                                                                                                             	1558347327	\N	1	\N	\N
4237	272	1vkh5gh69sjvyt9vcp                                                                                                                                                                                                                                             	1558504389	\N	1	\N	\N
4489	272	1vkh5gh6iojwiw8u23                                                                                                                                                                                                                                             	1559718703	\N	1	\N	\N
4490	272	1vkh5gh3kgjwix1fpz                                                                                                                                                                                                                                             	1559720038	\N	1	\N	\N
4491	272	1vkh5gh3kgjwix4oqp                                                                                                                                                                                                                                             	1559720189	\N	1	\N	\N
4492	272	1vkh5gh3kgjwix614q                                                                                                                                                                                                                                             	1559720252	\N	1	\N	\N
4493	272	1vkh5gh3kgjwixe8ca                                                                                                                                                                                                                                             	1559720635	\N	1	\N	\N
4494	272	1vkh5gh3kgjwixgir4                                                                                                                                                                                                                                             	1559720741	\N	1	\N	\N
4495	272	1vkh5gh3kgjwixhkug                                                                                                                                                                                                                                             	1559720791	\N	1	\N	\N
4556	272	1vkh5gh3kgjwj9wf0i                                                                                                                                                                                                                                             	1559741638	\N	1	\N	\N
4579	272	1vkh5ghc9sjwk7yqtd                                                                                                                                                                                                                                             	1559798854	\N	1	\N	\N
4584	272	1vkh5ghc9sjwk880v3                                                                                                                                                                                                                                             	1559799287	\N	1	\N	\N
4585	272	1vkh5ghc9sjwk88yr3                                                                                                                                                                                                                                             	1559799331	\N	1	\N	\N
4604	272	1vkh5ghc9sjwkahftx                                                                                                                                                                                                                                             	1559803085	\N	1	\N	\N
4627	272	1vkh5gh1g8jwkct4me                                                                                                                                                                                                                                             	1559806990	\N	1	\N	\N
4645	272	1vkh5gh4n0jwlqdj27                                                                                                                                                                                                                                             	1559890243	\N	1	\N	\N
4660	272	1vkh5ghbr8jwluw81t                                                                                                                                                                                                                                             	1559897834	\N	1	\N	\N
4676	272	1vkh5ghbr8jwlwxo1u                                                                                                                                                                                                                                             	1559901260	\N	1	\N	\N
4687	272	1vkh5ghbr8jwlxjoph                                                                                                                                                                                                                                             	1559902288	\N	1	\N	\N
4699	272	1vkh5ghbr8jwm3uzqm                                                                                                                                                                                                                                             	1559912893	\N	1	\N	\N
4957	272	1vkh5ghekojwt3xfjx                                                                                                                                                                                                                                             	1560336270	\N	1	\N	\N
4958	275	1vkh5ghekojwt40uz5                                                                                                                                                                                                                                             	1560336430	\N	1	\N	\N
\.


--
-- Data for Name: user_child; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.user_child (id, user_id, child_name, child_gender, child_age) FROM stdin;
240	274		Boy	3
241	271		Girl	2
121	270		Girl	2
363	272		Boy	1
265	287		Girl	4
264	287		Boy	3
323	273		Girl	3
328	275		Girl	7
\.


--
-- Data for Name: user_consider_myself; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.user_consider_myself (id, user_id, myself_status) FROM stdin;
1079	272	3
1080	272	2
782	287	10
462	281	3
463	281	6
464	281	10
465	281	5
781	287	3
783	287	5
784	287	1
977	275	4
978	275	11
675	274	11
674	274	6
676	271	4
677	271	10
922	273	6
923	273	11
\.


--
-- Data for Name: user_fcm_token; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.user_fcm_token (id, userid, fcm_token, platform) FROM stdin;
695	272	cC9HdrPqJkE:APA91bEwaXlnWiX8c-10i8Jy1zG4ZdNRVKWVyW1ha7GgiyzYtmX6wbvmMAdz_K1fok33V5eoB33cP3Gl09B_3mrgDNTBKDl1o9Z1grQMeuhrJNX9ID2IQPXY98XSA3Def05EyKLIH0-s	2
788	275	f1voVJA4O6k:APA91bFTW4L7lyizVjiaKZLqcnu5Ipa3kjWpqmNCJdzER24KGlJ4C_KtuJ2DeaCTy6Uz6EVCipmZ2_zRCU1XkQjjGu7loda80QBikPzecJeyNz5FWWP3b7JUEZIUogvOXl9WFjIA59mZ	2
694	272	d2GeJeBLEF4:APA91bG_3OOIQSM1TaEIGNjU2dsNaX2exyTHQRcCySf737psBkYvn2QJqx5wwUOdVcfaIH6vUgktpUa20Qsv3PUhlvouWkr9e3GflRge2tUzYy3ZncAaaiaanb2CKDN8Ytqm3lYZBSxM	2
730	272	d2GeJeBLEF4:APA91bG_3OOIQSM1TaEIGNjU2dsNaX2exyTHQRcCySf737psBkYvn2QJqx5wwUOdVcfaIH6vUgktpUa20Qsv3PUhlvouWkr9e3GflRge2tUzYy3ZncAaaiaanb2CKDN8Ytqm3lYZBSxM	2
731	273	fBILYha_cKg:APA91bF9nUhxInARLj8T71LNEZVbi3kBN3SJhtbZzHk6Cl6IYMmVn8bRuRo8fZf0L7UMi_lc8-xBg9JGK2iNPBQql_oVmvZAt8xWHdYBFcCXUDt69iQLseyDRCB4ZZX6GNY0l1XVFwOT	1
699	272	coBTZsSHH3U:APA91bEGTjO7YWEDnhzPL03r-WE_1hbdUlrxFubOOhtZywWxlJKxkveOK9Pn3cycHQE72PHR_gEbJ6qHa4ep7ytP6FsJEF7eMSrn4gP5IxsvItUuBgr2m2OnMmZT3cJjqnwQvsZetSml	2
789	272	fTFynldWX68:APA91bHu4sujS3ZtwFNzIO-95yNtsNOVmtSHWEMZQkP0dk6M63yqiCCHECBr050Bw9jfjvrFTzxK8QtP5G512C5Mv_6AKA8mSXSgDJR8ajEkyl6etYSiV8887gfwgengEBV0nVXNiB7i	2
683	272	eeR1vcRk9pY:APA91bEFPfrpaM1MOtejYYjKoOI9SwIBGQEXh-pU1yLUy8vPlCsgJOp2lCxl6UmsMGBHXjKDY3s-itklkKs6zSxwhCg7Ij7piOmlPiI0q6sZgkiotw_akOaHj6bJZs_HwtrLPGMpB_st	2
795	272	fF56GN691hQ:APA91bG_C2QGBohnz-cTzIZ1MSJIuNgVP5Zl-UvTyy7RHf6bQQAz8wyI5uVY2k6g1nyhHU1RPssY4hQQAwgzYDWZIANaSsrmWhSDvCtS41arsWnFG-XWrmY6Ynu23uqp6OyihBOxNl43	2
785	275	f1Qkg1E7xiA:APA91bE14B_4UbLivm8ld2bVNvlnA82Kr7iPUuU-yS0WB3VS3RQ8fBD3Xl471_cEJNoSMY5lUGJzhJTz5HQEdHkRMGdNEfCPBUmAAK-58s6nx-8wVYj50A9rqlal8PyJib2k5BCXE3lB	2
786	272	epz8RCWlids:APA91bFVUIc10o80Nbs5py40TTfLphxJE8GRG9tRhtd3iMA65juViHB2iNo9z42H3Jc2uM5lNzZgJ0vdCatBrjZlGHZeXAbWyuMCVTudLJwQbV6yHPQSHopJ5uss5cn0NIvWnaZIIdcq	2
787	272	f5xzWOD88T0:APA91bGLd9skD3f9V8QhjjDGQ0tYvcLvaKnjVUbJsApDQw69a2NUpDpO0u0CRoNnwQDWGfg1UBUV7avrgtigzezGNtHh0OKzDwqJoGA_K2yTeI3FDtCx9jLUGaH7GSyKidXC2N8Xeld-	2
790	275	dD4mtA3orNQ:APA91bG4TTvri5uzKfJYmRBuuffud1iXRlK3TBgvPP9t5lU_Ec2avVBDgmr-BpYKOMM_w8PjO8RoCDsMOtXrUOXYkGZl-TRDRG8RQUOrZjJPHuqo4v8ISB6I6Gpfij5beeFkDfuuodSw	2
791	272	eEQ1vnyRBK0:APA91bGlLcfPTkxSmXjLGc1_BeEha6gzhRb8bp20InHJ-3X15kwFPS9Euk3GS5WyBumKRknWCrdh0PJVORYsL51y_GdumdbNWFjuGUYcvWoTsXp3t1wftn1QP_prrnaDPL3r6t9CqpIo	2
692	272	et-ryLl2xyU:APA91bGMGlLZVHiuhX1sTSL7SQROHRrb9dwnUP1WXMKiNI79DwjNqoLjPr0c4NwBkf5crLHZqn1r9lOKVuVqAGr7oylLiicpvQ4fBtsYFa3JaiWoF3piQ2cPVFKM3cXjmt1TRY_0Lp6w	2
600	281	dmts58PBuPE:APA91bFV5GGatobOLePvKYFRsAdzspRl3ReUKOz_k3nNmrUATFEh5DEJNydkujyPFCPtac7oaN-9DyOflx0NJLi3B7hIzkaZO24nFLGA4Jyt6iHCOSmQDFQlA-jmSL_76JgV376oAKb5	2
693	272	eAtdOBTsdDA:APA91bFH4c68pX-KM5aDGAMFQKW8I_AstC8cSeuemk0OU-s-ghtsN69XdUU1ZwBFeVCO26jAsU66fqimcUWimG9FrqP8X-pZ7zLAfGtmn4y2ssf62dVpDg7BXJBeiqL1gr_Z7jtquB3g	2
547	277	fg_Sx4JqQc0:APA91bGe0J4OQnm6T6Ojgn3rSDuUN_FerSbH4VAg0Li00nOfTIPJOJAvE4c4LvsZcTMUo8P_ut9vA-ApQu032DPmTp47EKZ7ZnY7MA9hG99njaGzjOZBC-d1I9XoAlBjbteKTuC2mbn8	2
793	272	eolKZigC-xE:APA91bH8HHwsEyY_PUSbnuOYxbpwGjV74vAoyHaSxJuI-emONrPecgizgLyD3MezcYIvGCRacaZgnnp3o1w5JoTmRreEjwO6VS4o04q-z58NDhmZ21REkuWj1wLNBReptiq_FvOMoGF3	2
804	272	ftgDVYXrbeM:APA91bEAIlQgoh8xmeY-b3rBHllUdUSHAVKVmJVPmrwS95mwPVj6jPBcTiziIwABejiSXFDdgBXWlP-DbJr3TDk8lBoCvTKkN-xkS3_09f0eF_Y6csMLEvBiSvfFFtq-pax63qaxUV8e	2
750	271	feyUb6iUyp8:APA91bExB-8AO4XeKH7L1GcwLcI9FABHWBVbTgp_4WG4wjLn7m4SjZF-pFJcNkTbVX2vYRE6krpan4okbOj-XZLMjRRrENFi_4f5AwTkEBhx77GH6gTiJ6NO72Zk7yDBewN4Zu26yClm	2
765	274	czHHoAP4HoU:APA91bHYUBRoPa6vaL3pBHOrlszAVuu7C_omYOeYBja2WUGIYBStNcPxopUqdZbJXYutkx0vAsYW0wuKE82t5d_xUA0JLv0GjocdGW3niOeigV6uOi-04mPZuxPEQ6v2xA8DoqJscpvf	2
756	296		2
679	287	elmktUv9OZ8:APA91bGyCjXT4LSC_BY4ROAkHinzX2tOrdAuCa2p5v4CRYP12ijS41Pgi3-8pp6NV72wMOlZ-Nhus_lsCx6fptpXQIgpcjO9mvbKiJ-mmBevZS4CPuf0BL_mHJ1aaevbwWlPEYqWa4Yy	2
673	271	cdDEJwBh4Og:APA91bGThxsDgmVE5RkdnNjAOLDHdDFo1nfrDeiYdnrJid1z1kvbw36iEoqyQ1e9QLVJZJd54RMaMUXxJhqBLQcgu614zINJr4lXFAdKg-xKvhFlDzTxaSAcZ0j6RKScWwR51H9zTNo2	2
722	272	fOH8dVaCcOQ:APA91bHaMzGLlecW0HuOXoaaNvrjNzXcwRLOe0D_LS59yB4kW9cXz76ORq0KHASMamL5SHPDiU9TAtwWp_QXPSx3L2o4mn_HJVkDKDWRh_juFG2kiRfj7QFNs8GBDb6af4u9Df9VK0SZ	2
818	275	dkenMHoXA8c:APA91bEZuTT8hMi31iVe5xhiyWGRbG59Mnr0v1vMdqkl-s-S8mgcPeaoB1tYO8Aw171RPF9vGwqNaGZT0k0oL0uNbf-vXYwCIzq0RUB4hEBm8yXWjPDSm1z6vJmbRdDKx_iY-nmtCoMh	2
682	287	cVuUQyVJ_6g:APA91bFy5mWe18LGWnbw-HJ5e4vLt6XtQP5NKbBrv95DG5xOzlZHZPjkW8fDMLUIV7zwno-1Rfo8K9BNgbN3lgdZRvSNyaaqqmO_DCs51mecaXVCm9sTxeZqfB9E3kq5OjDls3a49wqq	2
728	273	fdhZVGOav8w:APA91bGZ4olb1r4dxyVVFwZQG-YYZWCtsmkKiy_OEshm2Oy5V7Xr7vedHxUjpGrZm5Zx0pekiuSC1L0H7F4jsKsyvKg-lPSMCFM87L_AEiX5Vg8K0pSEOwn8q7E1Gas7Lr9N3NhHFL4L	2
826	272	ePxGR5XghJA:APA91bFkj1zYoMCtY-YXanV1ISsc2EYuUbApd8d5VeLKPWZKnd_BnGtfe1jcSXDHLQLCPKtv6-wSiw6F7UwH3CotZUNLe4-Xvog-8cxFwkmtZ129h5Qp-NkyItHrjKpTp87gghea2rcn	2
823	275	fDsx9rzSWYk:APA91bFHvol-0AVeUZjkeXneI8O3P7xLY2tzllD_6jXbwABX4GjBUoBRm2wa2WFVpK17OzwMApfUBmw7VtFngdZ0Xd4P5u5S-WYXE4_fC9T1tXbbFtABD9UIucjyw81DFXHSLhmy5U8e	2
824	272	ePxGR5XghJA:APA91bFkj1zYoMCtY-YXanV1ISsc2EYuUbApd8d5VeLKPWZKnd_BnGtfe1jcSXDHLQLCPKtv6-wSiw6F7UwH3CotZUNLe4-Xvog-8cxFwkmtZ129h5Qp-NkyItHrjKpTp87gghea2rcn	2
\.


--
-- Data for Name: user_iam; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.user_iam (id, user_id, iam_status) FROM stdin;
984	287	1
990	287	14
988	287	8
987	287	7
986	287	4
985	287	3
989	287	13
991	287	21
992	287	25
830	274	8
829	274	4
831	271	4
832	271	8
574	281	1
575	281	3
576	281	4
577	281	7
578	281	8
579	281	10
580	281	11
581	281	13
582	281	14
583	281	19
1299	272	1
1301	272	2
1300	272	1
1302	272	2
1199	275	4
1200	275	9
1134	273	3
1135	273	7
\.


--
-- Data for Name: user_interest; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.user_interest (id, user_id, interest) FROM stdin;
2467	287	203
2469	287	212
2470	287	248
2471	287	472
1348	281	52
1349	281	53
1350	281	55
1351	281	56
1352	281	59
1353	281	62
1354	281	64
1355	281	4
1958	274	1
1956	274	5
1957	274	8
1959	271	22
1960	271	25
1961	271	32
2466	287	110
2472	287	478
2784	275	9
2786	275	3
2463	287	47
2785	275	5
2906	272	1
2787	275	8
2465	287	65
2907	272	8
2464	287	55
2462	287	35
2468	287	211
2696	273	5
2698	273	8
2697	273	6
\.


--
-- Data for Name: user_life_status; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.user_life_status (id, user_id, relation_status) FROM stdin;
1574	272	2
1575	272	1
1078	281	1
1482	275	1
1483	275	6
1246	274	3
1247	274	7
1248	271	1
1249	271	2
1327	287	1
1444	273	1
1445	273	7
\.


--
-- Data for Name: user_looking_friends; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.user_looking_friends (id, user_id, looking_friends) FROM stdin;
859	287	16
858	287	14
860	287	18
853	287	5
857	287	12
856	287	11
855	287	10
854	287	7
861	287	20
713	274	8
712	274	4
714	271	4
715	271	8
1156	272	1
475	281	3
476	281	7
477	281	8
478	281	9
479	281	11
480	281	10
1157	272	2
1062	275	4
1063	275	8
1006	273	3
1007	273	7
\.


--
-- Data for Name: user_photos; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.user_photos ("photoId", userid, image_name, profile_picture, "position") FROM stdin;
617	272	W8P5CKD7Lp0yboM1559633981000.jpg	0	2
551	287	wCwzWvUCgIj3EaU1556090594000.jpg	0	2
630	272	dGfjUA7MviWmPnO1559976236000.jpg	1	1
469	281	Y7KGwuDsTBHteMT1554321341000.jpg	1	1
470	281	NUBBMojDSF8vIml1554321341000.jpg	0	2
550	287	vyl1f4oavUNnK9C1556106271000.jpg	1	1
464	274	gpwhcr4fAuYbX8C1555605431000.jpg	1	1
461	271	zfjvJaJlekhFOVd1555605552000.jpg	1	1
465	275	ZTf27jH4iX4QGeK1555605631000.jpg	1	1
569	273	CwHZ2MK5K30UiF41557487054000.jpg	0	2
601	273	TfGkadpJ3ZkOPxR1557500676000.jpg	0	3
602	273	PNoVhx3RVr1Sip51557500676000.jpg	0	4
603	273	pXAJpvCHGaFBYj31557500676000.jpg	0	5
604	273	1jNH5w5hlHmBkLn1557500848000.jpg	1	1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: friendsup
--

COPY public.users (id, email, firstname, lastname, password, gender, fb_id, signup_from, gmail_id, "firebaseId", created_time, username, "mobileNumber", location, work_place, iam, consider, "lookingForFriends", dob, inerest, is_modified, work_position, state, country, latitude, longitude, city, mystory, "ageFrom", "ageTo", distance, county, postcode, forgot_password_otp, profile_completed) FROM stdin;
296	harul.kanhasoft@gmail.com	Harul	Koshti	\N		173781406832339	1	\N	FUAGSHDifBVs4dTjo1veLqMJEIr2	1558509916	Harul	\N	\N		\N	\N	\N			1		\N						15	30	5			0	0
297	ashish.kanhasoft@gmail.com	Ashish	\N	0e7517141fb53f21ee439b355b5a1d0a	Female	\N	0	\N	VV60R22I8PSRT83gif9qXdKYzVO2	1558951792	Ashish	\N	\N		\N	\N	\N			1		\N					Hello how are you ?	15	30	5			3589	0
271	john@gmail.com	John	\N	0e7517141fb53f21ee439b355b5a1d0a	Male	\N	0	\N	TrkAoJKEPZVoOGsXQRG90BiKITB2	1554130820	John	\N	\N	Tata Steel	\N	\N	\N	02-09-1993	22,25,32	1	Manager	\N	Oslo			Oslo	\N	15	30	28	1st street	0128	0	1
274	bruce@gmail.com	Bruce	\N	0e7517141fb53f21ee439b355b5a1d0a	Male	\N	0	\N	gPb1mFUwRtcgUkOnfWml6Qms2Bn1	1554131414	Bruce	\N	\N	Akastor	\N	\N	\N	18-12-1996	5,8,1	1	SEO	\N	Oslo			Oslo	Looking forward...	29	47	27	7th street	0128	0	1
273	martin@gmail.com	Martin	\N	0e7517141fb53f21ee439b355b5a1d0a	Male	\N	0	\N	Wqp0jrvkWkYIVWPwgrGe9RgKmUD2	1554131257	Martin	\N	\N	Norsk Hydro	\N	\N	\N	13-06-1992	5,6,8	1	Designer	\N	Oslo			Oslo	Norah testing 123	24	42	33	4th street	0128	0	1
281	isundland@beconnected.no	Ingvild	Sundland	\N	Female	10160764580385447	1	\N	L8texYNwq1WUcNObQo3nTGjTaK02	1554321067	Ingvild	\N	\N	BeConnected AS	\N	\N	\N	30-12-1987	52,53,55,56,59,62,64,4	1	CEO	\N	Oslo	59.91273	10.74609	Oslo	\N	30	40	200	Stovner	0982	0	1
275	joseph@gmail.com	Joseph	\N	0e7517141fb53f21ee439b355b5a1d0a	Male	\N	0	\N	VkpPbZNIvySjEJ5M9w8TUXhrxI32	1554131551	Joseph	\N	\N	Equinor	\N	\N	\N	16-04-1992	9,5,3,8	1	Chairman	\N	Oslo			Oslo	Looking for a beautiful girl...	23	42	30	8th street	0379	0	1
287	isundland@fastfolge.no	isundland	\N	cc8e78ba3b51adcfd32e45cdd22ea507	Female	\N	0	\N	WlS3U9pRhxPBDvDyKGRP67Byn4S2	1556090119	isundland	\N	\N	BeConnected	\N	\N	\N	30-12-1987	35,47,55,65,110,203,211,212,248,472,478	1	CEO	\N	Oslo	59.91273	10.74609	Oslo	\N	30	41	83	Gamle Stovner	0982	0	1
272	lisa@gmail.com	Lisa Name	\N	0e7517141fb53f21ee439b355b5a1d0a	Female	\N	0	\N	vmhIvrXFx3Z043QwqlfG8JfjHTE2	1554130975	Lisa Name	\N	\N	Kanhasoft	\N	\N	\N	10-03-1994	1,8	1	Developer	\N	Akershus			Strømmen	Thanks	21	37	26	Assad’s	2010	1743	1
\.


--
-- Name: event_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.event_category_id_seq', 689, true);


--
-- Name: event_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.event_images_id_seq', 136, true);


--
-- Name: event_invited_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.event_invited_users_id_seq', 349, true);


--
-- Name: events_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.events_event_id_seq', 277, true);


--
-- Name: favourite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.favourite_id_seq', 202, true);


--
-- Name: friend_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.friend_request_id_seq', 177, true);


--
-- Name: friends_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.friends_id_seq', 108, true);


--
-- Name: group_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.group_details_id_seq', 95, true);


--
-- Name: group_invitation_to_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.group_invitation_to_users_id_seq', 140, true);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.groups_id_seq', 44, true);


--
-- Name: groups_post_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.groups_post_comments_id_seq', 62, true);


--
-- Name: groups_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.groups_post_id_seq', 65, true);


--
-- Name: groups_post_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.groups_post_image_id_seq', 28, true);


--
-- Name: groups_post_like_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.groups_post_like_id_seq', 56, true);


--
-- Name: interest_sub_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.interest_sub_categories_id_seq', 556, true);


--
-- Name: life_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.life_status_id_seq', 13, true);


--
-- Name: main_interest_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.main_interest_categories_id_seq', 23, true);


--
-- Name: master_event_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.master_event_category_id_seq', 23, true);


--
-- Name: master_groups_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.master_groups_group_id_seq', 222, true);


--
-- Name: master_iam_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.master_iam_id_seq', 25, true);


--
-- Name: master_looking_for_friends_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.master_looking_for_friends_id_seq', 22, true);


--
-- Name: master_myself_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.master_myself_id_seq', 18, true);


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.notification_id_seq', 470, true);


--
-- Name: notification_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.notification_type_id_seq', 2, true);


--
-- Name: report_abuse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.report_abuse_id_seq', 13, true);


--
-- Name: userPhotos_photoId_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public."userPhotos_photoId_seq"', 630, true);


--
-- Name: user_access_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.user_access_token_id_seq', 4972, true);


--
-- Name: user_child_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.user_child_id_seq', 363, true);


--
-- Name: user_consider_myself_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.user_consider_myself_id_seq', 1080, true);


--
-- Name: user_fcm_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.user_fcm_token_id_seq', 826, true);


--
-- Name: user_iam_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.user_iam_id_seq', 1302, true);


--
-- Name: user_interest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.user_interest_id_seq', 2907, true);


--
-- Name: user_life_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.user_life_status_id_seq', 1575, true);


--
-- Name: user_looking_friends_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.user_looking_friends_id_seq', 1157, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: friendsup
--

SELECT pg_catalog.setval('public.users_id_seq', 297, true);


--
-- Name: event_category event_category_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.event_category
    ADD CONSTRAINT event_category_pkey PRIMARY KEY (id);


--
-- Name: event_images event_images_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.event_images
    ADD CONSTRAINT event_images_pkey PRIMARY KEY (id);


--
-- Name: event_invited_users event_invited_users_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.event_invited_users
    ADD CONSTRAINT event_invited_users_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);


--
-- Name: favourite favourite_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.favourite
    ADD CONSTRAINT favourite_pkey PRIMARY KEY (id);


--
-- Name: friend_request friend_request_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.friend_request
    ADD CONSTRAINT friend_request_pkey PRIMARY KEY (id);


--
-- Name: friends friends_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.friends
    ADD CONSTRAINT friends_pkey PRIMARY KEY (id);


--
-- Name: interest_sub_categories interest_sub_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.interest_sub_categories
    ADD CONSTRAINT interest_sub_categories_pkey PRIMARY KEY (id);


--
-- Name: life_status life_status_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.life_status
    ADD CONSTRAINT life_status_pkey PRIMARY KEY (id);


--
-- Name: interest_main_categories main_interest_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.interest_main_categories
    ADD CONSTRAINT main_interest_categories_pkey PRIMARY KEY (id);


--
-- Name: master_event_category master_event_category_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.master_event_category
    ADD CONSTRAINT master_event_category_pkey PRIMARY KEY (id);


--
-- Name: master_groups master_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.master_groups
    ADD CONSTRAINT master_groups_pkey PRIMARY KEY (group_id);


--
-- Name: master_iam master_iam_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.master_iam
    ADD CONSTRAINT master_iam_pkey PRIMARY KEY (id);


--
-- Name: master_looking_for_friends master_looking_for_friends_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.master_looking_for_friends
    ADD CONSTRAINT master_looking_for_friends_pkey PRIMARY KEY (id);


--
-- Name: master_myself master_myself_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.master_myself
    ADD CONSTRAINT master_myself_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_type notification_type_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.notification_type
    ADD CONSTRAINT notification_type_pkey PRIMARY KEY (id);


--
-- Name: report_abuse report_abuse_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.report_abuse
    ADD CONSTRAINT report_abuse_pkey PRIMARY KEY (id);


--
-- Name: user_photos userPhotos_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_photos
    ADD CONSTRAINT "userPhotos_pkey" PRIMARY KEY ("photoId");


--
-- Name: user_access_token user_access_token_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_access_token
    ADD CONSTRAINT user_access_token_pkey PRIMARY KEY (access_id);


--
-- Name: user_child user_child_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_child
    ADD CONSTRAINT user_child_pkey PRIMARY KEY (id);


--
-- Name: user_consider_myself user_consider_myself_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_consider_myself
    ADD CONSTRAINT user_consider_myself_pkey PRIMARY KEY (id);


--
-- Name: user_fcm_token user_fcm_token_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_fcm_token
    ADD CONSTRAINT user_fcm_token_pkey PRIMARY KEY (id);


--
-- Name: user_iam user_iam_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_iam
    ADD CONSTRAINT user_iam_pkey PRIMARY KEY (id);


--
-- Name: user_interest user_interest_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_interest
    ADD CONSTRAINT user_interest_pkey PRIMARY KEY (id);


--
-- Name: user_life_status user_life_status_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_life_status
    ADD CONSTRAINT user_life_status_pkey PRIMARY KEY (id);


--
-- Name: user_looking_friends user_looking_friends_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_looking_friends
    ADD CONSTRAINT user_looking_friends_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: fki_depends_on_event_id; Type: INDEX; Schema: public; Owner: friendsup
--

CREATE INDEX fki_depends_on_event_id ON public.event_images USING btree (event_id);


--
-- Name: fki_depends_on_eventid; Type: INDEX; Schema: public; Owner: friendsup
--

CREATE INDEX fki_depends_on_eventid ON public.event_invited_users USING btree (event_id);


--
-- Name: fki_depends_on_events; Type: INDEX; Schema: public; Owner: friendsup
--

CREATE INDEX fki_depends_on_events ON public.event_category USING btree (event_id);


--
-- Name: fki_depends_on_mastercategory; Type: INDEX; Schema: public; Owner: friendsup
--

CREATE INDEX fki_depends_on_mastercategory ON public.event_category USING btree (cat_id);


--
-- Name: fki_depends_on_users_userid; Type: INDEX; Schema: public; Owner: friendsup
--

CREATE INDEX fki_depends_on_users_userid ON public.user_photos USING btree (userid);


--
-- Name: fki_group_details_master_group_fkey; Type: INDEX; Schema: public; Owner: friendsup
--

CREATE INDEX fki_group_details_master_group_fkey ON public.group_details USING btree (groupid);


--
-- Name: event_invited_users depends_on_eventid; Type: FK CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.event_invited_users
    ADD CONSTRAINT depends_on_eventid FOREIGN KEY (event_id) REFERENCES public.events(event_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_photos depends_on_users_userid; Type: FK CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.user_photos
    ADD CONSTRAINT depends_on_users_userid FOREIGN KEY (userid) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: group_details group_details_master_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: friendsup
--

ALTER TABLE ONLY public.group_details
    ADD CONSTRAINT group_details_master_group_fkey FOREIGN KEY (groupid) REFERENCES public.master_groups(group_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

