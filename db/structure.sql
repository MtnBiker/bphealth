SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: blood_pressures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blood_pressures (
    id bigint NOT NULL,
    statdate timestamp with time zone,
    systolic integer,
    diastolic integer,
    heartrate integer,
    "sourceName" character varying,
    "sourceVersion" character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    comment character varying
);


--
-- Name: blood_pressures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blood_pressures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blood_pressures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blood_pressures_id_seq OWNED BY public.blood_pressures.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying,
    username character varying,
    password_digest character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: view_bp_time_with_zones; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.view_bp_time_with_zones AS
 SELECT blood_pressures.id,
    blood_pressures.statdate,
    (blood_pressures.statdate)::time with time zone AS stattime,
    blood_pressures.systolic,
    blood_pressures.diastolic,
    blood_pressures.heartrate
   FROM public.blood_pressures
  ORDER BY blood_pressures.statdate;


--
-- Name: blood_pressures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blood_pressures ALTER COLUMN id SET DEFAULT nextval('public.blood_pressures_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: blood_pressures blood_pressures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blood_pressures
    ADD CONSTRAINT blood_pressures_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_blood_pressures_on_statdate; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blood_pressures_on_statdate ON public.blood_pressures USING btree (statdate);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20211008182058'),
('20211008194952'),
('20211008220948'),
('20211008234308'),
('20211009174442'),
('20211009180724'),
('20211010142703'),
('20211012190555'),
('20211014163248'),
('20211014233831'),
('20211015014318'),
('20211101035420'),
('20211102182448'),
('20211102182733'),
('20211110235454'),
('20211111002400'),
('20211111013639'),
('20211121214459'),
('20211214003254'),
('20211228045750');


