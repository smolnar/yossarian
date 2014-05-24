--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: musicbrainz_unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS musicbrainz_unaccent WITH SCHEMA public;


--
-- Name: EXTENSION musicbrainz_unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION musicbrainz_unaccent IS 'Removes accents from Unicode data';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: artists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE artists (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    image character varying(255),
    musicbrainz_uuid character varying(255),
    lastfm_url character varying(255),
    lastfm_image_small character varying(255),
    lastfm_image_medium character varying(255),
    lastfm_image_large character varying(255),
    lastfm_image_extralarge character varying(255),
    lastfm_image_mega character varying(255),
    tags character varying(255)[] DEFAULT '{}'::character varying[],
    lastfm_summary character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE artists_id_seq OWNED BY artists.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    lastfm_uuid character varying(255),
    title character varying(255) NOT NULL,
    lastfm_description text,
    lastfm_url character varying(1024),
    website character varying(1024),
    venue_name character varying(255),
    venue_latitude character varying(255) NOT NULL,
    venue_longitude character varying(255) NOT NULL,
    venue_city character varying(255),
    venue_country character varying(255),
    venue_street character varying(255),
    venue_postalcode character varying(255),
    venue_url character varying(255),
    starts_at timestamp without time zone NOT NULL,
    ends_at timestamp without time zone,
    lastfm_image_small character varying(255),
    lastfm_image_medium character varying(255),
    lastfm_image_large character varying(255),
    lastfm_image_extralarge character varying(255),
    poster character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    performances_count integer DEFAULT 0 NOT NULL,
    tags character varying(255)[] DEFAULT '{}'::character varying[],
    notable_performances_count integer DEFAULT 0 NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: performances; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE performances (
    id integer NOT NULL,
    artist_id integer,
    event_id integer,
    headliner boolean NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: performances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE performances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: performances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE performances_id_seq OWNED BY performances.id;


--
-- Name: recordings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE recordings (
    id integer NOT NULL,
    track_id integer NOT NULL,
    artist_id integer NOT NULL,
    youtube_url character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: recordings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recordings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recordings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recordings_id_seq OWNED BY recordings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: tracks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tracks (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tracks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tracks_id_seq OWNED BY tracks.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY artists ALTER COLUMN id SET DEFAULT nextval('artists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY performances ALTER COLUMN id SET DEFAULT nextval('performances_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY recordings ALTER COLUMN id SET DEFAULT nextval('recordings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tracks ALTER COLUMN id SET DEFAULT nextval('tracks_id_seq'::regclass);


--
-- Name: artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: performances_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY performances
    ADD CONSTRAINT performances_pkey PRIMARY KEY (id);


--
-- Name: recordings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY recordings
    ADD CONSTRAINT recordings_pkey PRIMARY KEY (id);


--
-- Name: tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tracks
    ADD CONSTRAINT tracks_pkey PRIMARY KEY (id);


--
-- Name: index_artists_on_unaccented_lowercased_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_artists_on_unaccented_lowercased_name ON artists USING btree (lower(musicbrainz_unaccent((name)::text)));


--
-- Name: index_events_on_tags; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_tags ON events USING gin (tags);


--
-- Name: index_events_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_title ON events USING btree (title);


--
-- Name: index_events_on_unaccented_lowercased_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_unaccented_lowercased_title ON events USING btree (lower(musicbrainz_unaccent((title)::text)));


--
-- Name: index_events_on_venue_country; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_venue_country ON events USING btree (venue_country);


--
-- Name: index_performances_on_artist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_performances_on_artist_id ON performances USING btree (artist_id);


--
-- Name: index_performances_on_artist_id_and_event_id_and_headliner; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_performances_on_artist_id_and_event_id_and_headliner ON performances USING btree (artist_id, event_id, headliner);


--
-- Name: index_performances_on_event_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_performances_on_event_id ON performances USING btree (event_id);


--
-- Name: index_performances_on_event_id_and_headliner; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_performances_on_event_id_and_headliner ON performances USING btree (event_id, headliner);


--
-- Name: index_recordings_on_artist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_recordings_on_artist_id ON recordings USING btree (artist_id);


--
-- Name: index_recordings_on_track_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_recordings_on_track_id ON recordings USING btree (track_id);


--
-- Name: index_recordings_on_track_id_and_artist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_recordings_on_track_id_and_artist_id ON recordings USING btree (track_id, artist_id);


--
-- Name: index_tracks_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tracks_on_name ON tracks USING btree (name);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140417094429');

INSERT INTO schema_migrations (version) VALUES ('20140417100101');

INSERT INTO schema_migrations (version) VALUES ('20140417101733');

INSERT INTO schema_migrations (version) VALUES ('20140417222938');

INSERT INTO schema_migrations (version) VALUES ('20140417223218');

INSERT INTO schema_migrations (version) VALUES ('20140420235151');

INSERT INTO schema_migrations (version) VALUES ('20140521101620');

INSERT INTO schema_migrations (version) VALUES ('20140521101840');

INSERT INTO schema_migrations (version) VALUES ('20140522085916');

INSERT INTO schema_migrations (version) VALUES ('20140522091059');

INSERT INTO schema_migrations (version) VALUES ('20140522092124');

INSERT INTO schema_migrations (version) VALUES ('20140522092137');

INSERT INTO schema_migrations (version) VALUES ('20140523164505');

