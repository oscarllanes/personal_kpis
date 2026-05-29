--
-- PostgreSQL database dump
--

\restrict SY9MFBeNp8x3zs8rCGtPTkuly5BmWgLJGcogOqDQbt3Je09cjw2SvQg4BLcUgIa

-- Dumped from database version 15.18
-- Dumped by pg_dump version 15.18

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
-- Name: kpi_definitions; Type: TABLE; Schema: public; Owner: oscar_admin
--

CREATE TABLE public.kpi_definitions (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    user_id integer
);


ALTER TABLE public.kpi_definitions OWNER TO oscar_admin;

--
-- Name: kpi_definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: oscar_admin
--

CREATE SEQUENCE public.kpi_definitions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kpi_definitions_id_seq OWNER TO oscar_admin;

--
-- Name: kpi_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oscar_admin
--

ALTER SEQUENCE public.kpi_definitions_id_seq OWNED BY public.kpi_definitions.id;


--
-- Name: kpi_logs; Type: TABLE; Schema: public; Owner: oscar_admin
--

CREATE TABLE public.kpi_logs (
    id integer NOT NULL,
    user_id integer NOT NULL,
    definition_id integer,
    entry_date date NOT NULL,
    value text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.kpi_logs OWNER TO oscar_admin;

--
-- Name: kpi_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: oscar_admin
--

CREATE SEQUENCE public.kpi_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kpi_logs_id_seq OWNER TO oscar_admin;

--
-- Name: kpi_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oscar_admin
--

ALTER SEQUENCE public.kpi_logs_id_seq OWNED BY public.kpi_logs.id;


--
-- Name: trial_balance; Type: TABLE; Schema: public; Owner: oscar_admin
--

CREATE TABLE public.trial_balance (
    id bigint NOT NULL,
    fiscal_year integer NOT NULL,
    fiscal_period integer NOT NULL,
    ledger character varying NOT NULL,
    gl_account integer NOT NULL,
    gl_description character varying(70) NOT NULL,
    period numeric(19,4) DEFAULT 0.00,
    balance numeric(19,4) DEFAULT 0.00,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.trial_balance OWNER TO oscar_admin;

--
-- Name: trial_balance_id_seq; Type: SEQUENCE; Schema: public; Owner: oscar_admin
--

CREATE SEQUENCE public.trial_balance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trial_balance_id_seq OWNER TO oscar_admin;

--
-- Name: trial_balance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oscar_admin
--

ALTER SEQUENCE public.trial_balance_id_seq OWNED BY public.trial_balance.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: oscar_admin
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text NOT NULL
);


ALTER TABLE public.users OWNER TO oscar_admin;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: oscar_admin
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO oscar_admin;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oscar_admin
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: kpi_definitions id; Type: DEFAULT; Schema: public; Owner: oscar_admin
--

ALTER TABLE ONLY public.kpi_definitions ALTER COLUMN id SET DEFAULT nextval('public.kpi_definitions_id_seq'::regclass);


--
-- Name: kpi_logs id; Type: DEFAULT; Schema: public; Owner: oscar_admin
--

ALTER TABLE ONLY public.kpi_logs ALTER COLUMN id SET DEFAULT nextval('public.kpi_logs_id_seq'::regclass);


--
-- Name: trial_balance id; Type: DEFAULT; Schema: public; Owner: oscar_admin
--

ALTER TABLE ONLY public.trial_balance ALTER COLUMN id SET DEFAULT nextval('public.trial_balance_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: oscar_admin
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: kpi_definitions kpi_definitions_name_key; Type: CONSTRAINT; Schema: public; Owner: oscar_admin
--

ALTER TABLE ONLY public.kpi_definitions
    ADD CONSTRAINT kpi_definitions_name_key UNIQUE (name);


--
-- Name: kpi_definitions kpi_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: oscar_admin
--

ALTER TABLE ONLY public.kpi_definitions
    ADD CONSTRAINT kpi_definitions_pkey PRIMARY KEY (id);


--
-- Name: kpi_logs kpi_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: oscar_admin
--

ALTER TABLE ONLY public.kpi_logs
    ADD CONSTRAINT kpi_logs_pkey PRIMARY KEY (id);


--
-- Name: trial_balance trial_balance_pkey; Type: CONSTRAINT; Schema: public; Owner: oscar_admin
--

ALTER TABLE ONLY public.trial_balance
    ADD CONSTRAINT trial_balance_pkey PRIMARY KEY (id);


--
-- Name: trial_balance unique_fiscal_data; Type: CONSTRAINT; Schema: public; Owner: oscar_admin
--

ALTER TABLE ONLY public.trial_balance
    ADD CONSTRAINT unique_fiscal_data UNIQUE (fiscal_year, fiscal_period, ledger, gl_account);


--
-- Name: kpi_logs unique_kpi_entry; Type: CONSTRAINT; Schema: public; Owner: oscar_admin
--

ALTER TABLE ONLY public.kpi_logs
    ADD CONSTRAINT unique_kpi_entry UNIQUE (user_id, definition_id, entry_date);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: oscar_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: oscar_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: kpi_definitions fk_user; Type: FK CONSTRAINT; Schema: public; Owner: oscar_admin
--

ALTER TABLE ONLY public.kpi_definitions
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: kpi_logs kpi_logs_definition_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: oscar_admin
--

ALTER TABLE ONLY public.kpi_logs
    ADD CONSTRAINT kpi_logs_definition_id_fkey FOREIGN KEY (definition_id) REFERENCES public.kpi_definitions(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO user_01;


--
-- Name: TABLE kpi_definitions; Type: ACL; Schema: public; Owner: oscar_admin
--

GRANT SELECT ON TABLE public.kpi_definitions TO user_01;


--
-- Name: TABLE kpi_logs; Type: ACL; Schema: public; Owner: oscar_admin
--

GRANT SELECT ON TABLE public.kpi_logs TO user_01;


--
-- Name: TABLE trial_balance; Type: ACL; Schema: public; Owner: oscar_admin
--

GRANT SELECT ON TABLE public.trial_balance TO user_01;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: oscar_admin
--

GRANT SELECT ON TABLE public.users TO user_01;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: oscar_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE oscar_admin IN SCHEMA public GRANT SELECT ON TABLES  TO user_01;


--
-- PostgreSQL database dump complete
--

\unrestrict SY9MFBeNp8x3zs8rCGtPTkuly5BmWgLJGcogOqDQbt3Je09cjw2SvQg4BLcUgIa

