CREATE SEQUENCE users_id_seq START WITH 1;
CREATE TABLE users (
  id   INT          NOT NULL DEFAULT nextval('users_id_seq'),
  name VARCHAR(255) NOT NULL,
  hashedPassword CHAR(60) NULL,
  last_login TIMESTAMP NULL,
  CONSTRAINT PK_users PRIMARY KEY (id)
);

CREATE SEQUENCE institutions_id_seq START WITH 1;
CREATE TABLE institutions (
  id   INT          NOT NULL DEFAULT nextval('institutions_id_seq'),
  name VARCHAR(255) NOT NULL,
  CONSTRAINT PK_institutions PRIMARY KEY (id)
);

CREATE SEQUENCE accounts_id_seq START WITH 1;
CREATE TABLE accounts (
  id             INT            NOT NULL DEFAULT nextval('accounts_id_seq'),
  parent_id      INT            NULL,
  institution_id INT            NOT NULL,
  account_number VARCHAR(255)   NOT NULL,
  alias          VARCHAR(255)   NULL,
  type_id        INT            NOT NULL, -- Checking, Savings, Credit Line, etc...
  balance        NUMERIC(19, 2) NOT NULL DEFAULT 0.0,
  CONSTRAINT PK_accounts PRIMARY KEY (id),
  CONSTRAINT FK_accounts_parent_id FOREIGN KEY (parent_id) REFERENCES accounts (id),
  CONSTRAINT FK_accounts_institution_id FOREIGN KEY (institution_id) REFERENCES institutions (id),
  CONSTRAINT U_accounts_inst_acct UNIQUE (institution_id, account_number),
  CONSTRAINT U_accounts_alias UNIQUE (alias)
);

CREATE SEQUENCE transactions_id_seq START WITH 1;
CREATE TABLE transactions (
  id          INT            NOT NULL DEFAULT nextval('transactions_id_seq'),
  account_id  INT            NOT NULL,
  date        TIMESTAMP      NOT NULL,
  description VARCHAR(255)   NOT NULL,
  val         NUMERIC(19, 2) NOT NULL,
  category_id INT            NULL,
  receipt_id  INT            NULL,
  notes       VARCHAR(8000)  NULL,
  budgeted    BIT            NULL,
  CONSTRAINT PK_Transactions PRIMARY KEY (id)
);

CREATE SEQUENCE account_types_id_seq START WITH 1;
CREATE TABLE account_types (
  id          INT          NOT NULL DEFAULT nextval('account_types_id_seq'),
  description VARCHAR(255) NOT NULL,
  CONSTRAINT PK_account_types PRIMARY KEY (id)
);

-- Functions
------------

CREATE FUNCTION fn_insert_transaction(_account_id INT, _date TIMESTAMP, _desc VARCHAR(255), _value NUMERIC(19, 2))
  RETURNS VOID AS
$BODY$
BEGIN
  INSERT INTO transactions (account_id, date, description, val) VALUES (_account_id, _date, _desc, _value);
  UPDATE accounts SET balance = balance + _value WHERE id = _account_id;
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;

-- CREATE SEQUENCE tags_id_seq START WITH 1;
-- CREATE TABLE tags (
--   id   INT          NOT NULL DEFAULT nextval('tags_id_seq'),
--   name VARCHAR(255) NOT NULL,
--   CONSTRAINT pk_tags PRIMARY KEY (id)
-- );
--
-- CREATE SEQUENCE account_types_id_seq START WITH 1;
-- CREATE TABLE account_types (
--   id          INT          NOT NULL DEFAULT nextval('account_types_id_seq'),
--   description VARCHAR(255) NOT NULL,
--   CONSTRAINT PK_account_types PRIMARY KEY (id)
-- );
--
-- CREATE SEQUENCE receipts_id_seq START WITH 1;
-- CREATE TABLE receipts (
--   id   INT           NOT NULL DEFAULT nextval('receipts_id_seq'),
--   path VARCHAR(1000) NOT NULL,
--   CONSTRAINT PK_receipts PRIMARY KEY (id)
-- );
--
-- CREATE SEQUENCE payees_id_seq START WITH 1;
-- CREATE TABLE payees (
--   id   INT          NOT NULL DEFAULT nextval('payees_id_seq'),
--   name VARCHAR(255) NOT NULL,
--   CONSTRAINT PK_payees PRIMARY KEY (id)
-- );
--
-- CREATE SEQUENCE icons_id_seq START WITH 1;
-- CREATE TABLE icons (
--   id   INT          NOT NULL DEFAULT nextval('icons_id_seq'),
--   data VARBINARY(1) NOT NULL,
--   CONSTRAINT PK_icons PRIMARY KEY (id)
-- );
--
-- CREATE SEQUENCE categories_id_seq START WITH 1;
-- CREATE TABLE categories (
--   id        INT          NOT NULL DEFAULT nextval('categories_id_seq'),
--   parent_id INT          NULL,
--   name      VARCHAR(255) NOT NULL,
--   icon_id   INT          NULL,
--   CONSTRAINT PK_categories PRIMARY KEY (id),
--   CONSTRAINT U_categories_name UNIQUE (name)
-- );
--
--
-- CREATE TABLE ScheduledTransactions (
--   id          INT            NOT NULL,
--   account_id  INT            NOT NULL,
--   description VARCHAR(255)   NULL,
--   category_id INT            NULL,
--   payee_id    INT            NOT NULL,
--   quantity    DECIMAL(19, 2) NULL,
--   recurring   BIT            NOT NULL,
--   notes       VARCHAR(max)   NULL,
--   CONSTRAINT PK_ScheduledTransactions PRIMARY KEY (id)
-- );
--
-- CREATE TABLE transaction_tags (
--   transaction_id INT NOT NULL,
--   tag_id         INT NOT NULL,
--   CONSTRAINT PK_transaction_tags PRIMARY KEY (transaction_id, tag_id)
-- );

/****** Object:  Default DF__Accounts__Balanc__08B54D69    Script Date: 05/07/2017 20:43:35 ******/
-- ALTER TABLE Accounts
--   ADD DEFAULT ((0)) FOR Balance
--
-- /****** Object:  Default DF_ScheduledTransactions_Quantity    Script Date: 05/07/2017 20:43:35 ******/
-- ALTER TABLE ScheduledTransactions
--   ADD CONSTRAINT DF_SCHEDULEDTRANSACTIONS_QUANTITY DEFAULT ((0)) FOR Quantity
--
-- /****** Object:  Default DF__Transacti__Debit__73BA3083    Script Date: 05/07/2017 20:43:35 ******/
-- ALTER TABLE Transactions
--   ADD DEFAULT ((0.0)) FOR Quantity
--
-- /****** Object:  ForeignKey FK_Accounts_AccountTypes_AccountTypeId    Script Date: 05/07/2017 20:43:35 ******/
-- ALTER TABLE Accounts
-- REFERENCES AccountTypes (AccountTypeId)
--
-- ALTER TABLE Accounts CHECK CONSTRAINT FK_Accounts_AccountTypes_AccountTypeId
--
-- /****** Object:  ForeignKey FK_Cateries_Icons_IconId    Script Date: 05/07/2017 20:43:35 ******/
-- ALTER TABLE Cateries
-- REFERENCES Icons (IconID)
--
-- ALTER TABLE Cateries CHECK CONSTRAINT FK_Cateries_Icons_IconId
--
-- /****** Object:  ForeignKey FK_Cateries_ParentId    Script Date: 05/07/2017 20:43:35 ******/
-- ALTER TABLE Cateries
-- REFERENCES Cateries (CateryId)
--
-- ALTER TABLE Cateries CHECK CONSTRAINT FK_Cateries_ParentId
--
-- /****** Object:  ForeignKey FK_ScheduledTransactions_Cateries_CateryId    Script Date: 05/07/2017 20:43:35 ******/
-- ALTER TABLE ScheduledTransactions
-- REFERENCES Cateries (CateryId)
--
-- ALTER TABLE ScheduledTransactions CHECK CONSTRAINT FK_ScheduledTransactions_Cateries_CateryId
--
-- /****** Object:  ForeignKey FK_Transactions_Cateries_CateryId    Script Date: 05/07/2017 20:43:35 ******/
-- ALTER TABLE Transactions
-- REFERENCES Cateries (CateryId)
--
-- ALTER TABLE Transactions CHECK CONSTRAINT FK_Transactions_Cateries_CateryId
--
-- /****** Object:  ForeignKey FK_Transactions_Receipts_ReceiptId    Script Date: 05/07/2017 20:43:35 ******/
-- ALTER TABLE Transactions
-- REFERENCES Receipts (ReceiptId)
--
-- ALTER TABLE Transactions CHECK CONSTRAINT FK_Transactions_Receipts_ReceiptId
--
-- /****** Object:  ForeignKey FK_TransactionTags_Tags_TagId    Script Date: 05/07/2017 20:43:35 ******/
-- ALTER TABLE TransactionTags
-- REFERENCES Tags (TagId)
--
-- ALTER TABLE TransactionTags CHECK CONSTRAINT FK_TransactionTags_Tags_TagId
--
-- /****** Object:  ForeignKey FK_TransactionTags_Transactions_TransactionId    Script Date: 05/07/2017 20:43:35 ******/
-- ALTER TABLE TransactionTags
-- REFERENCES Transactions (TransactionId)
--
-- ALTER TABLE TransactionTags CHECK CONSTRAINT FK_TransactionTags_Transactions_TransactionId

