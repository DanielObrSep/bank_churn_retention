Bank Churn Retention - dbt Project
Descripción
Este proyecto utiliza dbt y duckdb para transformar y analizar datos de clientes bancarios con el objetivo de identificar patrones relacionados con la retención y abandono de clientes. Los datos provienen de dos archivos CSV (Bank_Churn_Account_Info y Bank_Churn_Customer_Info) que han sido cargados como seeds y modelados en una arquitectura de tipo staging + marts.

Estructura del proyecto

dbt_project/
├── models/
│   ├── staging/
│   │   ├── stg_bank_churn_account.sql
│   │   ├── stg_bank_churn_account.yml
│   │   ├── stg_bank_churn_customer.sql
│   │   └── stg_bank_churn_customer.yml
│   ├── marts/
│   │   └── marts_bank_churn.sql
│   │   └── marts_bank_churn.yml
├── seeds/
│   ├── Bank_Churn_Account_Info.csv
│   └── Bank_Churn_Customer_Info.csv
├── dbt_project.yml
└── README.md

Objetivos de modelado

### `stg_bank_churn_account`
- Conversión de `Balance` a tipo `float`
- Separación del símbolo monetario
- Eliminación de duplicados
- Eliminación de valores nulos
- Normalización de variables categóricas (`HasCrCard`, `IsActiveMember`)

### `stg_bank_churn_customer`
- Limpieza de duplicados
- Normalización de texto (`Gender`, `Geography`)
- Limpieza de símbolo monetario en `EstimatedSalary`
- Conversión de tipos y limpieza de espacios

### `marts_bank_churn`
- Unión de tablas `account` y `customer` por `CustomerId`
- Consolidación de los datos limpios en una vista final para análisis

Requisitos
Python 3.10+
duckdb
dbt-core >= 1.9
dbt-duckdb

Instalación
python -m venv venv
venv\Scripts\activate
pip install dbt-core dbt-duckdb

## Instalación

```bash
python -m venv venv
venv\Scripts\activate
pip install dbt-core dbt-duckdb

# Inicializar el entorno
dbt debug

# Cargar datos semilla
dbt seed

# Ejecutar modelos
dbt run

# Ejecutar tests
dbt test

Documentación

dbt docs generate
dbt docs serve

