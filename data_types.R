
# 1. lists-using list() function to combine elements into a list
my_list <- list(1, "two", 3L, 4+2i, FALSE)
print(my_list)

# using str() to show structure of my list
str(my_list)

# using class() to see the data type
class(my_list)

# using length() to see length of the file
length(my_list)

# creating a list, a vector of names and assigning names to the list
# method1
student_grades <- list(75, 90, 63)

student_names <- c("Justin", "Sarah", "Dave")

names(student_grades) <- student_names

student_grades

# method2
student_grades2 = list("Justin" = 80, "Sarah" = 77, "Dave" = 55)
student_grades2

# using attributes()
attributes(student_grades2)


# 2.factors-using factors() function to create a factor for some vector.
dept <- c("Sales", "Engineering", "Management", "Management", "Sales", "Sales")
dept_factor <- factor(dept)
print(dept)
print(dept_factor)

# assigning names to our employees using names() with factors
emp_names <- c("Jeff", "John", "Suzy", "Sally", "Barb", "Bob")
names(dept_factor) <- emp_names
dept_factor

# 3.matrix
# method 1
# using matrix() function
# nrow - specifies the no.of rows
# ncol - specifies the no.of columns
# byrow - orders by rows if TRUE or by columns if FALSE
my_matrix <- matrix(c(1, 2, 3, 5), nrow=2, byrow=TRUE)
print(my_matrix)

matrix2 = matrix(1:9, nrow=5, byrow=TRUE)
matrix2

## 1:9 = c(1, 2, 3, ...9)

# method 2
# using cbind() and rbind() functions to create matrix
# Notice columns take names from vectors.
age <- c(22, 35, 53)
salary <- c(55000, 65000, 75000)
age_salary_matrix_bycolumn <- cbind(age, salary)
print(age_salary_matrix_bycolumn)

age_salary_byrow <- rbind(age, salary)
print(age_salary_byrow)

# similar to naming vectors, here we use rownames() and colnames() to name cols
emp_matrix <- matrix(c(1, 2, 3, 25, 35, 45, 50000, 65000, 75000), nrow=3)
colnames(emp_matrix) <- c("ID", "Age", "Salary")
rownames(emp_matrix) <- c("Jim", "Sally", "John")

print(emp_matrix)
class(emp_matrix)

length(emp_matrix)
nrow(emp_matrix)
ncol(emp_matrix)
dim(emp_matrix)

attributes(emp_matrix)


# 3. Arrays
# usnig array() function
# dim - specifies the dimensions of the array
my_array <- array(1:12, dim = c(2, 2, 3))
print(my_array)

# similar idea for naming arrays as well.
# use argument dimnames that takes a list of vectors
my_array2 <- array(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
                   dim = c(2, 2, 3),
                   dimnames = list(
                     c("row1", "row2"),
                     c("col1", "col2"),
                     c("df1", "df2", "df3")
                   )
)
print(my_array2)

class(my_array2)
nrow(my_array2)
ncol(my_array2)
dim(my_array2)
str(my_array2)
length(my_array2)
attributes(my_array2)


# 4. Data Frames
# Using data.frame() function to create data frame
# similar to matrices, but can use different types
# notice by default column names take my vector names
emp_name <- c("Joe", "Jim", "John", "Jeff")
emp_dept <- c("Sales", "Eng", "Mgmt", "Mgmt")
emp_salary <- c(75000, 73000, 78000, 79000)

my_df <- data.frame(emp_name, emp_dept, emp_salary)
print(my_df)

# can change these names using names(), colnames(), and rownames() functions
# just we do in vectors and matrices.
# generally you will only want to name columns as data frames are 
# used for tabular data
colnames(my_df) <- c("NAME", "DEPT", "SALARY")

print(my_df)


class(my_df)
is.data.frame(my_df)
str(my_df)

# by default data.frame() will import all character vectors as factors
# if we don't want this set the argument stringASfactors = FALSE
my_df2 <- data.frame(emp_name, emp_dept, emp_salary, stringsAsFactors = FALSE)
print(my_df2)
str(my_df2)

class(my_df2)
nrow(my_df2)
ncol(my_df2)
dim(my_df2)
attributes(my_df2)
length(my_df2)