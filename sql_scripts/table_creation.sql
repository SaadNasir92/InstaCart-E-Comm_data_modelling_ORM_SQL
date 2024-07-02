CREATE TABLE "orders" (
    "order_id" INTEGER   NOT NULL,
    "user_id" INTEGER   NOT NULL,
    "order_number" INTEGER   NOT NULL,
    "order_dow" INTEGER   NOT NULL,
    "order_hour_of_day" INTEGER   NOT NULL,
    "days_since_prior_order" INTEGER,
    CONSTRAINT "pk_orders" PRIMARY KEY (
        "order_id"
     )
);

CREATE TABLE "products" (
    "product_id" INTEGER   NOT NULL,
    "product_name" VARCHAR(255)   NOT NULL,
    "aisle_id" INTEGER   NOT NULL,
    "department_id" INTEGER   NOT NULL,
    CONSTRAINT "pk_products" PRIMARY KEY (
        "product_id"
     )
);

CREATE TABLE "order_products" (
    "order_id" INTEGER   NOT NULL,
    "product_id" INTEGER   NOT NULL,
    "add_to_cart_order" INTEGER   NOT NULL,
    "reordered" INTEGER   NOT NULL,
    CONSTRAINT "pk_order_products" PRIMARY KEY (
        "order_id","product_id"
     )
);

CREATE TABLE "aisles" (
    "aisle_id" INTEGER   NOT NULL,
    "aisle" VARCHAR(60)   NOT NULL,
    CONSTRAINT "pk_aisles" PRIMARY KEY (
        "aisle_id"
     )
);

CREATE TABLE "departments" (
    "department_id" INTEGER   NOT NULL,
    "department" VARCHAR(60)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "department_id"
     )
);

ALTER TABLE "products" ADD CONSTRAINT "fk_products_aisle_id" FOREIGN KEY("aisle_id")
REFERENCES "aisles" ("aisle_id");

ALTER TABLE "products" ADD CONSTRAINT "fk_products_department_id" FOREIGN KEY("department_id")
REFERENCES "departments" ("department_id");

ALTER TABLE "order_products" ADD CONSTRAINT "fk_order_products_order_id" FOREIGN KEY("order_id")
REFERENCES "orders" ("order_id");

ALTER TABLE "order_products" ADD CONSTRAINT "fk_order_products_product_id" FOREIGN KEY("product_id")
REFERENCES "products" ("product_id");