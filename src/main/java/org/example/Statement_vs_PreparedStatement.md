# Statement vs PreparedStatement in JDBC

## Statement
- Accepts string as SQL queries, so less readable
- Vulnerable to SQL injection, when input string is concatenated(see example in Injection.java).
- JDBC passes the query with inline values to the database. So the database engine must ensure all the checks and the query will not appear as the same to the database and it will prevent cache usage.
- The Statement interface is suitable for DDL queries like CREATE, ALTER, and DROP.
- The Statement interface can’t be used for storing and retrieving files and arrays.

## PreparedStatement
- PreparedStatement has methods to bind various object types, including files and arrays, so the code becomes easy to understand.
- It protects against SQL injection, by escaping the text for all the parameter values provided(see example in Injection.java).
- PreparedStatement uses pre-compilation. As soon as the database gets a query, it will check the cache before pre-compiling the query.
- Better performance for repeated executions due to precompilation. 
- The PreparedStatement is suitable for DML queries.