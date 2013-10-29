JBoss BPM Suite Mortgage Demo 
=============================

Demo based on JBoss BPM Suite product.


Quickstart
----------

1. Clone project.

2. Add products to installs directory.

3. Run 'init.sh'

4. Login to http://localhost:8080/business-central  (u:erics / p:bpmsuite)

  - login for appraisor role (u:alan / p:bpmsuite)

  - login for broker role (u:bob / p:bpmsuite)

  - login for manager role (u:mary / p:bpmsuite)

6. Enjoy JBoss BPM Suite with Mortgage Demo pre-installed!


Notes
-----
The following functionality is covered:

- One advanced process.

- Four Human Tasks assigned to 3 different roles

- Use of Swimlanes to assign a task to the user who previously took ownership

- Several guide business rules

- Several technical rules

- A guided web decision table

- Several Script Tasks for Java work

- One Web Service task using SOAP/HTTP

- Exclusive use of the BPMS Data Modeler for creating the Java fact model

- Use of graphic form designer to create 4 forms with an example of javascript validation

There is a deployed WAR file for a Web Service that is to be called by the process. The process can be started through the console
using a graphical form but the WAR file also includes a servlet that uses the REST API to remotely create 16 instances of the
process with distinct data resulting in different process states.


Released versions
-----------------

See the tagged releases for the following versions of the product:

- v0.3 - JBoss BPM Suite 6.0.0.Beta1, JBoss EAP 6.0, and mortgage demo installed.

- v0.2 - JBoss BPM Suite ER4, JBoss EAP 6.0, new roles assignment, and mortgage demo installed.

- v0.1 - JBoss BPM Suite ER3, JBoss EAP 6.0, and mortgage demo installed.
