# Page Review Management System

A full-featured Java Web Application for creating, managing, and reviewing pages with user authentication, admin moderation, and MySQL database integration.

This project is built using **Java Servlet + JSP + MySQL** and follows a simple MVC-style structure.

---

## 🚀 Features

### 👤 User Features

* User Registration & Login
* Profile Management
* Add New Pages
* Edit/Delete Own Pages
* Submit Reviews & Ratings
* Edit Own Reviews
* View Personal Pages & Reviews
* Public Page Viewing System

### 🛡️ Admin Features

* Admin Login Panel
* Approve/Reject Reviews
* Approve/Disable Pages
* Suspend/Unsuspend Users
* Moderate User Activities

### 🗄️ Database Features

* Automatic Database Initialization
* Automatic Table Creation
* Default Admin Creation
* MySQL JDBC Integration

---

## 🧰 Tech Stack

| Technology    | Usage               |
| ------------- | ------------------- |
| Java          | Backend Logic       |
| JSP           | Frontend View       |
| Servlet       | Controller Layer    |
| MySQL         | Database            |
| JDBC          | Database Connection |
| Apache Tomcat | Application Server  |
| NetBeans      | Project Development |
| HTML/CSS      | UI Design           |

---

## 📁 Project Structure

```bash
Page-Review-Management-main/
│
├── src/
│   ├── java/
│   │   ├── admin/
│   │   ├── controller/
│   │   ├── dao/
│   │   ├── model/
│   │   ├── user/
│   │   └── util/
│   │
│   └── conf/
│
├── web/
│   ├── admin/
│   ├── user/
│   ├── WEB-INF/
│   └── index.jsp
│
├── dist/
│   └── PageReviewManagement.war
│
├── build.xml
└── README.md
```

---

## ⚙️ Setup Instructions

### 1️⃣ Clone Repository

```bash
git clone https://github.com/your-username/Page-Review-Management.git
cd Page-Review-Management
```

---

### 2️⃣ Configure MySQL

Create a MySQL server and update credentials inside:

```bash
src/java/util/DBConfig.java
```

Update:

```java
public static final String DB_USER = "root";
public static final String DB_PASS = "your_password";
```

---

### 3️⃣ Import Project into NetBeans

* Open NetBeans
* File → Open Project
* Select the project folder

---

### 4️⃣ Add MySQL JDBC Driver

Download MySQL Connector/J and add it to project libraries.

Recommended:

* mysql-connector-j-8.x.x.jar

---

### 5️⃣ Deploy to Apache Tomcat

* Configure Tomcat Server
* Run the project
* The system will automatically:

  * Create database
  * Create required tables
  * Insert default admin account

---

## 🔐 Default Admin Login

```text
Username: admin
Password: admin123
```

---

## 🗃️ Database Auto Initialization

The project contains an automatic database initialization system.

Main utility files:

```bash
src/java/util/DBInitializer.java
src/java/util/DBUtil.java
src/java/util/DBConfig.java
```

The system automatically:

* Checks MySQL connection
* Creates database if missing
* Creates required tables
* Validates schema
* Creates default admin user

---

## 📌 Main Modules

### User Module

| Servlet           | Purpose            |
| ----------------- | ------------------ |
| RegisterServlet   | User Registration  |
| LoginServlet      | User Login         |
| ProfileServlet    | Profile Management |
| AddPageServlet    | Add New Page       |
| EditPageServlet   | Edit Page          |
| DeletePageServlet | Delete Page        |
| AddReviewServlet  | Add Review         |
| EditReviewServlet | Edit Review        |
| MyPagesServlet    | User Pages         |
| MyReviewsServlet  | User Reviews       |

---

### Admin Module

| Servlet                   | Purpose                 |
| ------------------------- | ----------------------- |
| AdminLoginServlet         | Admin Authentication    |
| ReviewActionServlet       | Review Moderation       |
| TogglePageApprovalServlet | Page Approval Control   |
| ToggleUserSuspendServlet  | Suspend/Unsuspend Users |

---

## 🧠 System Workflow

```text
User Registration/Login
        ↓
Create Page
        ↓
Admin Approval
        ↓
Public Visibility
        ↓
Users Submit Reviews
        ↓
Admin Moderates Reviews
```

---

## 🌐 Deployment Options

You can deploy this project on:

* Apache Tomcat
* GlassFish
* Localhost XAMPP + Tomcat
* VPS Java Hosting

---

## 📸 Screens Included

* User Dashboard
* Admin Dashboard
* Review Management
* Page Listing
* Review Submission Form

---

## 🔒 Security Notes

Current implementation includes:

* Session-based login system
* Admin authorization
* Database schema validation
* User suspension system

Recommended improvements:

* Password hashing (BCrypt)
* CSRF protection
* Input validation
* Prepared statement optimization
* Role-based access control

---

## 🛠️ Future Improvements

* Search & Filtering
* AJAX Reviews
* Pagination
* Email Verification
* REST API Integration
* Responsive Bootstrap UI
* Image Upload Support
* Notification System

---

## 👨‍💻 Author

**Md. Murad Hasan Media**

GitHub:

[https://github.com/mdmuradhasanmedia](https://github.com/mdmuradhasanmedia)

---

## 📜 License

This project is created for educational and learning purposes.

You are free to modify and use it for personal or academic projects.

---

## ⭐ Support

If you like this project:

* Star the repository
* Fork the project
* Share with others
* Contribute improvements

---

## 📬 Contact

For collaboration or support:

* GitHub Issues
* Pull Requests
* Repository Discussions
