import mysql.connector as connector
# 1. Establish connection to the Little Lemon database
connection = connector.connect(
   user="root",
   password="your_password",
   host="127.0.0.1",
   database="LittleLemonDB"
)
cursor = connection.cursor()
print("Connected to LittleLemonDB successfully!")
# 2. Query customers with orders over $60
join_query = """
SELECT Customers.FullName, Customers.ContactNumber, Orders.TotalCost
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.TotalCost > 60;
"""
cursor.execute(join_query)
results = cursor.fetchall()
print("\nCustomers with orders > $60:")
for row in results:
   print(row)
# 3. Call the stored procedures
print("\nCalling GetMaxQuantity():")
cursor.callproc("GetMaxQuantity")
for result in cursor.stored_results():
   print(result.fetchall())
print("\nCalling ManageBooking():")
cursor.callproc("ManageBooking", ("2022-10-10", 5))
for result in cursor.stored_results():
   print(result.fetchall())
print("\nCalling AddBooking():")
cursor.callproc("AddBooking", (99, 1, 4, "2022-12-30"))
connection.commit()
for result in cursor.stored_results():
   print(result.fetchall())
print("\nCalling UpdateBooking():")
cursor.callproc("UpdateBooking", (99, "2022-12-31"))
connection.commit()
for result in cursor.stored_results():
   print(result.fetchall())
print("\nCalling CancelBooking():")
cursor.callproc("CancelBooking", (99,))
connection.commit()
for result in cursor.stored_results():
   print(result.fetchall())
# Close connection
cursor.close()
connection.close()
