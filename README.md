JBoss BPM Suite Mortgage Demo 
=============================


Quickstart
----------

1. Clone project.

2. Add products to installs directory.

3. Run 'init.sh' or 'init.bat' file.

4. Start JBoss BPMS Server by running 'standalone.sh' or 'standalone.bat' in the <path-to-project>/target/jboss-eap-6.1/bin directory.

5. Login to http://localhost:8080/business-central  

```
  - login for admin role (u:erics / p:bpmsuite)

  - login for appraisor role (u:alan / p:bpmsuite)

  - login for broker role (u:bob / p:bpmsuite)

  - login for manager role (u:mary / p:bpmsuite)
```

6. Mortgage Loan demo pre-installed as project.

7. Process and Task dashboard pre-filled with mock data optional now. 

8. You can pre-load the BPM Suite Mortgage project with multiple pre-configured process instances, some will run through the
rejected path, some will be waiting for you in the various human task when you login. To inject these pre-configured
requests just run the client jar from a command line shell. You can run the following command from the 'support' directory:

```
   java -jar jboss-mortgage-demo-client.jar erics bpmsuite
```

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

- Helper jar to pre-load with sixteen process instances in various states.

Note that the entire demo is running default in memory, restart server, lose your process instances, data, monitoring history.


Supporting Articles
-------------------

[Red Hat JBoss BPM Suite - installing the Mortgage demo project (video)] (http://www.schabell.org/2013/10/jboss-bpm-suite-install-mortage-demo-video.html)

[Red Hat JBoss BPM Suite - get rocking with the all new Mortgage Demo] (http://www.schabell.org/2013/10/jboss-bpm-suite-rocking-the-mortgage-demo.html)


Released versions
-----------------

See the tagged releases for the following versions of the product:

- v1.2 - JBoss BPM Suite 6.0.1.GA, JBoss EAP 6.1.1, and mortgage demo installed.

- v1.1 - JBoss BPM Suite 6.0.0.GA, JBoss EAP 6.1.1, and mortgage demo installed, mock data question removed.

- v1.0 - JBoss BPM Suite 6.0.0.GA, JBoss EAP 6.1.1, and mortgage demo installed.

- v0.7 - JBoss BPM Suite 6.0.0.CR2, JBoss EAP 6.1.1, and mortgage demo installed.

- v0.6 - JBoss BPM Suite 6.0.0.CR1, JBoss EAP 6.1.1, and mortgage demo installed, optional mock data population.

- v0.5 - JBoss BPM Suite 6.0.0.CR1, JBoss EAP 6.1.1, and mortgage demo installed, optional mock data population.

- v0.4 - JBoss BPM Suite 6.0.0.Beta, JBoss EAP 6.1.1, mock data populated in Process and Task dashboard, and mortgage demo installed.

- v0.3 - JBoss BPM Suite 6.0.0.Beta1, JBoss EAP 6.0, and mortgage demo installed.

- v0.2 - JBoss BPM Suite ER4, JBoss EAP 6.0, new roles assignment, and mortgage demo installed.

- v0.1 - JBoss BPM Suite ER3, JBoss EAP 6.0, and mortgage demo installed.


![Install Console](https://github.com/eschabell/bpms-mortgage-demo/blob/master/docs/demo-images/install-console.png?raw=true)

![Mortgage Process](https://github.com/eschabell/bpms-mortgage-demo/blob/master/docs/demo-images/mortgage-process.png?raw=true)

![Process and Task Dashboard](https://github.com/eschabell/bpms-mortgage-demo/blob/master/docs/demo-images/mock-bpm-data.png?raw=true)

