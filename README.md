# Campus Recruitment Management System
### Eclipse Dynamic Web Project | Tomcat 10.1 | MySQL 9 | Jakarta EE 10

---

## How to Import & Run in Eclipse

### Requirements
| Tool | Version |
|------|---------|
| Eclipse IDE | **Enterprise Java and Web Developers** edition |
| JDK | 17 or higher |
| Apache Tomcat | **10.1.x** |
| MySQL | **9.x** |

---

### Step 1 — Setup MySQL Database
1. Open **MySQL Workbench**
2. `File → Open SQL Script` → select `database/schema.sql`
3. Click the ⚡ **Run** button
4. This creates the `campus_recruitment` database with tables + sample data

### Step 2 — Configure Database Password
Open `src/com/campus/util/DBConnection.java`
Change:
```java
private static final String PASSWORD = ""; // ← put your MySQL password here
```

### Step 3 — Import Project into Eclipse
1. `File → Import → General → Existing Projects into Workspace`
2. Click **Browse** → select the `CampusRecruitment` folder (this folder)
3. Make sure **"CampusRecruitment"** is checked → click **Finish**

> ⚠️ Do NOT import as "Maven Project". Use **"Existing Projects into Workspace"**.

### Step 4 — Add Tomcat 10.1 Server in Eclipse
*(Skip if you already have Tomcat 10.1 added)*
1. `Window → Preferences → Server → Runtime Environments → Add`
2. Choose **Apache Tomcat v10.1**
3. Browse to your Tomcat 10.1 installation folder → Finish

### Step 5 — Run on Server
1. Right-click the project → **Run As → Run on Server**
2. Select **Tomcat v10.1** → Next → Finish
3. Eclipse deploys and opens the browser automatically

### Step 6 — Access the App
Open: **http://localhost:8080/CampusRecruitment/**

---

## Default Login Credentials

| Role    | Email                    | Password    |
|---------|--------------------------|-------------|
| Admin   | admin@university.edu     | admin123    |
| Company | hr@techcorp.com          | company123  |
| Company | recruitment@infosys.com  | company123  |
| Student | arjun@student.edu        | student123  |
| Student | priya@student.edu        | student123  |

---

## Project Structure

```
CampusRecruitment/
├── .project               ← Eclipse project descriptor
├── .classpath             ← Eclipse classpath (JARs auto-linked)
├── .settings/             ← Eclipse web/Java facet settings
├── src/                   ← Java source files
│   └── com/campus/
│       ├── dao/           ← Database Access Objects
│       ├── filter/        ← AuthFilter (session protection)
│       ├── model/         ← POJOs (Admin, Student, Company, Drive, Application)
│       ├── servlet/       ← All Servlets
│       └── util/          ← DBConnection, EmailUtil, ExcelExportUtil
├── WebContent/            ← Web root
│   ├── WEB-INF/
│   │   ├── web.xml        ← Jakarta EE 10 web descriptor
│   │   └── lib/           ← ALL JARs included (no Maven needed)
│   ├── css/style.css
│   ├── js/main.js
│   ├── index.jsp
│   ├── login.jsp
│   ├── register.jsp
│   ├── error.jsp
│   ├── admin/             ← Admin portal JSPs
│   ├── company/           ← Company portal JSPs
│   └── student/           ← Student portal JSPs
└── database/
    └── schema.sql         ← MySQL 9 schema + sample data
```

---

## Included JARs (WEB-INF/lib) — No Downloads Needed

| JAR | Purpose |
|-----|---------|
| mysql-connector-j-9.0.0.jar | MySQL 9 JDBC Driver |
| jakarta.mail-2.0.3.jar | Email notifications |
| poi-5.2.5.jar | Excel export (core) |
| poi-ooxml-5.2.5.jar | Excel export (.xlsx) |
| xmlbeans-5.2.1.jar | POI dependency |
| commons-compress-1.27.1.jar | POI dependency |
| commons-collections4-4.4.jar | POI dependency |
| commons-codec-1.17.0.jar | POI dependency |
| log4j-api-2.23.1.jar | POI logging |
| SparseBitSet-1.3.jar | POI dependency |
| curvesapi-1.08.jar | POI charts |
| commons-fileupload-1.5.jar | Resume upload |
| commons-io-2.15.1.jar | File I/O |
| jbcrypt-0.4.jar | Password hashing |
| gson-2.10.1.jar | JSON utilities |

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Red errors on import | Right-click project → Properties → Java Build Path → verify Tomcat 10.1 is listed |
| `Unknown database` | Run `database/schema.sql` in MySQL Workbench first |
| `Access denied` | Update PASSWORD in `DBConnection.java` |
| `Communications link failure` | Start your MySQL 9 server |
| Error page shows on all URLs | Verify Tomcat version is 10.1 (not 9.x) |
